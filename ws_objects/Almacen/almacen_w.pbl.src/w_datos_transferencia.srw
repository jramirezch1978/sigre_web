$PBExportHeader$w_datos_transferencia.srw
forward
global type w_datos_transferencia from w_abc
end type
type pb_2 from picturebutton within w_datos_transferencia
end type
type pb_1 from picturebutton within w_datos_transferencia
end type
type dw_master from u_dw_abc within w_datos_transferencia
end type
end forward

global type w_datos_transferencia from w_abc
integer width = 2459
integer height = 628
string title = "Datos Artículos Consignación"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_cancelar ( )
event ue_aceptar ( )
pb_2 pb_2
pb_1 pb_1
dw_master dw_master
end type
global w_datos_transferencia w_datos_transferencia

type variables
string  	is_flag_contab, is_tipo_mov
integer	ii_factor_prsp
str_mov_art_consig istr_mov_consig

end variables

event ue_cancelar();istr_mov_consig.retorno = 'n'
CloseWithReturn(this, istr_mov_consig)
end event

event ue_aceptar();if f_row_Processing( dw_master, "form") <> true then return

istr_mov_consig.retorno 		= 's'
istr_mov_consig.cencos 			= dw_master.object.cencos		[1]
istr_mov_consig.cnta_prsp 		= dw_master.object.cnta_prsp	[1]
istr_mov_consig.cod_maquina 	= dw_master.object.cod_maquina[1]
istr_mov_consig.matriz 			= dw_master.object.matriz		[1]
istr_mov_consig.recibido 		= dw_master.object.recibido	[1]

CloseWithReturn(this, istr_mov_consig)
end event

on w_datos_transferencia.create
int iCurrent
call super::create
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_datos_transferencia.destroy
call super::destroy
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_master)
end on

event ue_set_access;//Ancestror Script Override
end event

event ue_open_pre;call super::ue_open_pre;string ls_null, ls_cencos, ls_cnta_prsp, ls_cod_maquina, ls_Desc

idw_1 = dw_master              				// asignar dw corriente
dw_master.InsertRow(0)

SetNull(ls_null)

if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then
	MessageBox('Aviso', 'Paramatros mal enviados, ya que estan nulos o no validos')
	
	return
end if

istr_mov_consig = Message.PowerObjectParm

is_tipo_mov 	= istr_mov_consig.tipo_mov
ls_cencos  		= istr_mov_consig.cencos
ls_cnta_prsp 	= istr_mov_consig.cnta_prsp
ls_cod_maquina = istr_mov_consig.cod_maquina

dw_master.object.recibido[1] = istr_mov_consig.recibido

if Not IsNull(ls_cencos) and ls_cencos <> '' then
	select desc_cencos
		into :ls_desc
	from centros_costo
	where cencos = :ls_cencos
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe centro de costo: ' + ls_cencos +' o no esta activo')
		return
	end if
	
	dw_master.object.cencos[1] = ls_cencos
	dw_master.object.desc_cencos[1] = ls_desc
end if

if Not IsNull(ls_cnta_prsp) and ls_cnta_prsp <> '' then
	select descripcion
		into :ls_desc
	from presupuesto_cuenta
	where cnta_prsp = :ls_cnta_prsp;
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe Cuenta Presupuestal: ' + ls_cod_maquina)
		return
	end if
	
	dw_master.object.cnta_prsp			[1] = ls_cnta_prsp
	dw_master.object.desc_cnta_prsp	[1] = ls_desc
end if

if Not IsNull(ls_cod_maquina) and ls_cod_maquina <> '' then
	select desc_maq
		into :ls_desc
	from maquina
	where cod_maquina = :ls_cod_maquina
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe Codigo de maquina: ' + ls_cod_maquina +' o no esta activo')
		return
	end if
	
	dw_master.object.cod_maquina	[1] = ls_cod_maquina
	dw_master.object.desc_maq		[1] = ls_desc
end if

if Not IsNull(istr_mov_consig.matriz) and istr_mov_consig.matriz <> '' then
	select descripcion
		into :ls_desc
	from matriz_cntbl_finan
	where matriz = :istr_mov_consig.matriz
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe MATRIZ FINANCIERA: ' + istr_mov_consig.matriz &
				+ ' o no esta activa')
		return
	end if
	
	dw_master.object.matriz			[1] = istr_mov_consig.matriz
	dw_master.object.desc_matriz	[1] = ls_desc
end if

// Verifico si pide o no matriz contable 
select Nvl(factor_presup,0), Nvl(flag_contabiliza, '0')
	into :ii_factor_prsp, :is_flag_contab
from articulo_mov_tipo
where tipo_mov = :is_tipo_mov;

if is_flag_contab = '0' then
	dw_master.object.matriz.protect = '1'
	dw_master.object.matriz.edit.required = 'No'
	dw_master.object.matriz.background.color = RGB(192,192,192)
	dw_master.object.matriz		[1] = ls_null
	dw_master.object.desc_matriz	[1] = ls_null
end if

if ii_factor_prsp = 0 then
	dw_master.object.cencos.protect = '1'
	dw_master.object.cencos.edit.required = 'No'	
	dw_master.object.cencos.background.color = RGB(192,192,192)
	dw_master.object.cencos			[1] = ls_null
	dw_master.object.desc_cencos	[1] = ls_null

	dw_master.object.cnta_prsp.protect = '1'
	dw_master.object.cnta_prsp.edit.required = 'No'	
	dw_master.object.cnta_prsp.background.color = RGB(192,192,192)
	dw_master.object.cnta_prsp			[1] = ls_null
	dw_master.object.desc_cnta_prsp	[1] = ls_null

	dw_master.object.cod_maquina.protect = '1'
	dw_master.object.cod_maquina.edit.required = 'No'	
	dw_master.object.cod_maquina.background.color = RGB(192,192,192)
	dw_master.object.cod_maquina	[1] = ls_null
	dw_master.object.desc_maq		[1] = ls_null
end if

end event

type pb_2 from picturebutton within w_datos_transferencia
integer x = 1166
integer y = 332
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type pb_1 from picturebutton within w_datos_transferencia
integer x = 791
integer y = 332
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_Aceptar()
end event

type dw_master from u_dw_abc within w_datos_transferencia
event ue_display ( string as_columna,  long al_row )
event ue_cancelar ( )
integer width = 2427
integer height = 340
string dataobject = "d_datos_transferencia_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_display;string 	ls_codigo, ls_data, ls_sql, ls_almacen, ls_anaquel, ls_fila, ls_columna

this.AcceptText()

choose case lower(as_columna)
		
	case "almacen"
		
		ls_sql = "select t.almacen as almacen, " &
				 + "t.desc_almacen as descripcion_almacen " &
				 + "  from almacen t, " &
				 + "       almacen_user au, " &
				 + "       (select almacen " &
				 + "          from almacen " &
				 + "        minus " &
				 + "         select distinct te.almacen_pptt " &
				 + "           from tg_parte_empaque te " &
				 + "          where te.flag_estado <> '0') s " &
				 + " where t.almacen = au.almacen " &
				 + "   and t.almacen = s.almacen " &
				 + "   and au.cod_usr = '" + gs_user + "'"
			
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case 'anaquel'
		ls_almacen = dw_master.object.almacen [1]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			MessageBox('Error', 'Debe indicar un almacen', StopSign!)
			this.setColumn("almacen")
			return
		end if
		
		ls_sql = "select distinct a.anaquel as anaquel " &
				 + "from vw_alm_posiciones_libres a " &
				 + "where a.almacen = '" + ls_almacen + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_anaquel, '1') then
			this.object.anaquel	[al_row] = ls_anaquel
			this.ii_update = 1
		end if			
	
	case 'fila'
		ls_almacen = dw_master.object.almacen [1]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			MessageBox('Error', 'Debe indicar un almacen', StopSign!)
			this.setColumn("almacen")
			return
		end if
		
		ls_anaquel = dw_master.object.anaquel [1]
		
		if IsNull(ls_anaquel) or trim(ls_anaquel) = '' then
			MessageBox('Error', 'Debe indicar un anaquel', StopSign!)
			this.setColumn("anaquel")
			return
		end if
		
		ls_sql = "select distinct a.fila as fila " &
				 + "from vw_alm_posiciones_libres a " &
				 + "where a.almacen = '" + ls_almacen + "'" &
				 + "  and a.anaquel = '" + ls_anaquel + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_fila, '1') then
			this.object.fila_dst		[al_row] = ls_fila
			this.ii_update = 1
		end if		
	
	case 'columna'
		ls_almacen = dw_master.object.almacen_dst [1]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			MessageBox('Error', 'Debe indicar un almacen', StopSign!)
			this.setColumn("almacen")
			return
		end if
		
		ls_anaquel = dw_master.object.anaquel [1]
		
		if IsNull(ls_anaquel) or trim(ls_anaquel) = '' then
			MessageBox('Error', 'Debe indicar un anaquel', StopSign!)
			this.setColumn("anaquel")
			return
		end if
		
		ls_fila = dw_master.object.fila [1]
		
		if IsNull(ls_fila) or trim(ls_fila) = '' then
			MessageBox('Error', 'Debe indicar una fila', StopSign!)
			this.setColumn("fila")
			return
		end if
		
		ls_sql = "select a.columna as columna " &
				 + "from vw_alm_posiciones_libres a " &
				 + "where a.almacen = '" + ls_almacen + "'" &
				 + "  and a.anaquel = '" + ls_anaquel + "'" &
				 + "  and a.fila = '" + ls_fila + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_columna, '1') then
			this.object.columna	[al_row] = ls_columna
			this.ii_update = 1
		end if		

end choose
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string ls_desc, ls_null

SetNull(ls_null)
This.AcceptText()

if row = 0 then return

choose case lower(dwo.name)
	case "matriz"
		select descripcion
			into :ls_desc
		from matriz_cntbl_finan
		where matriz = :data
		  and	flag_estado = '1';
		 
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Matriz Contable no existe o no esta activo')
			this.object.matriz		[1] = ls_null
			this.object.desc_matriz	[1] = ls_null
			return 1
		end if
		
		this.object.desc_matriz[1] = ls_desc
		return
		
	case "cencos"
		select desc_cencos
			into :ls_desc
		from centros_costo
		where cencos = :data
		  and	flag_estado = '1';
		 
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Centro de Costo no existe o no esta activo')
			this.object.cencos		[1] = ls_null
			this.object.desc_dencos	[1] = ls_null
			return 1
		end if
		
		this.object.desc_cencos[1] = ls_desc

	case "cod_maquina"
		select desc_maq
			into :ls_desc
		from maquina
		where cod_maquina = :data
		  and	flag_estado = '1';
		 
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Codigo de Maquina no existe o no esta activo')
			this.object.cod_maquina	[1] = ls_null
			this.object.desc_maq		[1] = ls_null
			return 1
		end if
		
		this.object.desc_cencos[1] = ls_desc

	case "cnta_prsp"
		select descripcion
			into :ls_desc
		from presupuesto_cuenta
		where cnta_prsp = :data;
		 
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Cuenta Presupuestal no existeç')
			this.object.cnta_prsp		[1] = ls_null
			this.object.desc_cnta_prsp	[1] = ls_null
			return 1
		end if
		
		this.object.desc_cnta_prsp[1] = ls_desc

end choose

end event

