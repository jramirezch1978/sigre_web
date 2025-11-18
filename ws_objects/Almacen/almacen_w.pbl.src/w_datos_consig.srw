$PBExportHeader$w_datos_consig.srw
forward
global type w_datos_consig from w_abc
end type
type pb_2 from picturebutton within w_datos_consig
end type
type pb_1 from picturebutton within w_datos_consig
end type
type dw_master from u_dw_abc within w_datos_consig
end type
end forward

global type w_datos_consig from w_abc
integer width = 2459
integer height = 1268
string title = "Datos Artículos Consignación"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
pb_2 pb_2
pb_1 pb_1
dw_master dw_master
end type
global w_datos_consig w_datos_consig

type variables
string  	is_flag_contab_ing, is_flag_contab_sal, is_mov_ing, &
			is_mov_sal, is_almacen
integer	ii_factor_prsp
str_mov_art_consig istr_mov_consig

end variables

forward prototypes
public subroutine of_tipo_mov_sal (string as_tipo_mov)
end prototypes

event ue_cancelar();istr_mov_consig.retorno = 'n'
CloseWithReturn(this, istr_mov_consig)
end event

event ue_aceptar();dw_master.AcceptText()

if f_row_Processing( dw_master, "form") <> true then return

istr_mov_consig.retorno 		= 's'
istr_mov_consig.matriz_ing 	= dw_master.object.matriz_ing		[1]
istr_mov_consig.tipo_mov_sal 	= dw_master.object.mov_salida		[1]
istr_mov_consig.receptor_ing 	= dw_master.object.receptor_ing	[1]
istr_mov_consig.cencos 			= dw_master.object.cencos			[1]
istr_mov_consig.cnta_prsp 		= dw_master.object.cnta_prsp		[1]
istr_mov_consig.cod_maquina 	= dw_master.object.cod_maquina	[1]
istr_mov_consig.matriz_sal 	= dw_master.object.matriz_sal		[1]
istr_mov_consig.receptor_sal 	= dw_master.object.receptor_sal	[1]

CloseWithReturn(this, istr_mov_consig)
end event

public subroutine of_tipo_mov_sal (string as_tipo_mov);string ls_null

SetNull(ls_null)

// Verifico si pide o no matriz contable 
select Nvl(factor_presup,0), Nvl(flag_contabiliza, '0')
	into :ii_factor_prsp, :is_flag_contab_sal
from articulo_mov_tipo
where tipo_mov = :as_tipo_mov;

if is_flag_contab_sal = '0' then
	dw_master.object.matriz_sal.protect = '1'
	dw_master.object.matriz_sal.edit.required = 'No'
	dw_master.object.matriz_sal.background.color = RGB(192,192,192)
	dw_master.object.matriz_sal		[1] = ls_null
	dw_master.object.desc_matriz_sal	[1] = ls_null
end if

if ii_factor_prsp = 0 then
	dw_master.object.cencos.protect = 1
	dw_master.object.cencos.edit.required = 'No'	
	dw_master.object.cencos.background.color = RGB(192,192,192)
	dw_master.object.cencos			[1] = ls_null
	dw_master.object.desc_cencos	[1] = ls_null

	dw_master.object.cnta_prsp.protect = 1
	dw_master.object.cnta_prsp.edit.required = 'No'	
	dw_master.object.cnta_prsp.background.color = RGB(192,192,192)
	dw_master.object.cnta_prsp			[1] = ls_null
	dw_master.object.desc_cnta_prsp	[1] = ls_null

	dw_master.object.cod_maquina.protect = 1
//	dw_master.object.cod_maquina.edit.required = 'No'	
	dw_master.object.cod_maquina.background.color = RGB(192,192,192)
	dw_master.object.cod_maquina	[1] = ls_null
	dw_master.object.desc_maq		[1] = ls_null
	
else
	
	dw_master.object.cencos.protect = 0
	dw_master.object.cencos.edit.required = 'Yes'	
	dw_master.object.cencos.background.color = RGB(255,255,255)

	dw_master.object.cnta_prsp.protect = 0
	dw_master.object.cnta_prsp.edit.required = 'Yes'	
	dw_master.object.cnta_prsp.background.color = RGB(255,255,255)

	dw_master.object.cod_maquina.protect = 0
//	dw_master.object.cod_maquina.edit.required = 'Yes'
	dw_master.object.cod_maquina.background.color = RGB(255,255,255)
	
end if
end subroutine

on w_datos_consig.create
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

on w_datos_consig.destroy
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

is_mov_ing 		= istr_mov_consig.tipo_mov_ing
is_almacen 		= istr_mov_consig.almacen

ls_cencos  		= istr_mov_consig.cencos
ls_cnta_prsp 	= istr_mov_consig.cnta_prsp
ls_cod_maquina = istr_mov_consig.cod_maquina

is_mov_sal = istr_mov_consig.tipo_mov_sal

if Not IsNull(is_mov_sal) then
	select desc_tipo_mov
	  into :ls_Desc
	  from articulo_mov_tipo
	 where tipo_mov = :is_mov_sal;
	
	dw_master.object.mov_salida		[1] = is_mov_sal
	dw_master.object.desc_mov_salida	[1] = ls_desc
	
	dw_master.object.mov_salida.background.color = RGB(192,192,192)
	dw_master.object.mov_salida.protect = 1
	dw_master.object.mov_salida.edit.required = 'No'
	
else
	
	dw_master.object.mov_salida.background.color = RGB(255,255,255)
	dw_master.object.mov_salida.protect = 0
	dw_master.object.mov_salida.edit.required = 'Yes'

end if

dw_master.object.receptor_ing		[1] = istr_mov_consig.receptor_ing
dw_master.object.receptor_sal		[1] = istr_mov_consig.receptor_sal

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

if Not IsNull(istr_mov_consig.matriz_ing) and istr_mov_consig.matriz_ing <> '' then
	select descripcion
		into :ls_desc
	from matriz_cntbl_finan
	where matriz = :istr_mov_consig.matriz_ing
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe MATRIZ FINANCIERA: ' + istr_mov_consig.matriz_ing &
				+ ' o no esta activa')
		return
	end if
	
	dw_master.object.matriz_ing		[1] = istr_mov_consig.matriz_ing
	dw_master.object.desc_matriz_ing	[1] = ls_desc
end if

if Not IsNull(istr_mov_consig.matriz_sal) and istr_mov_consig.matriz_sal <> '' then
	select descripcion
		into :ls_desc
	from matriz_cntbl_finan
	where matriz = :istr_mov_consig.matriz_sal
	  and flag_estado = '1';
	
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'No existe MATRIZ FINANCIERA: ' + istr_mov_consig.matriz_sal &
				+ ' o no esta activa')
		return
	end if
	
	dw_master.object.matriz_sal		[1] = istr_mov_consig.matriz_sal
	dw_master.object.desc_matriz_sal	[1] = ls_desc
end if

// Verifico si pide o no matriz contable 
select Nvl(flag_contabiliza, '0')
	into :is_flag_contab_ing
from articulo_mov_tipo
where tipo_mov = :is_mov_ing;

if is_flag_contab_ing = '0' then
	dw_master.object.matriz_ing.protect = '1'
	dw_master.object.matriz_ing.edit.required = 'No'
	dw_master.object.matriz_ing.background.color = RGB(192,192,192)
	dw_master.object.matriz_ing		[1] = ls_null
	dw_master.object.desc_matriz_ing	[1] = ls_null
end if

of_tipo_mov_sal(is_mov_sal)

end event

type pb_2 from picturebutton within w_datos_consig
integer x = 1289
integer y = 968
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
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type pb_1 from picturebutton within w_datos_consig
integer x = 914
integer y = 968
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
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_Aceptar()
end event

type dw_master from u_dw_abc within w_datos_consig
event ue_display ( string as_columna,  long al_row )
event ue_cancelar ( )
integer width = 2427
integer height = 952
string dataobject = "d_datos_consig_ff"
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cod_art, ls_sub_cat
Date		ld_fecha
str_parametros	sl_param

this.AcceptText()

choose case lower(as_columna)

	case "mov_salida"
		ls_sql = "SELECT a.tipo_mov AS cod_tipo_mov, " &
				  + "a.desc_tipo_mov AS DESCRIPCION_tipo_mov " &
				  + "FROM articulo_mov_tipo a, " &
				  + "almacen_tipo_mov 	    b " &
				  + "Where a.tipo_mov = b.tipo_mov " &
				  + "and a.FLAG_ESTADO = '1' " &
				  + "and NVL(a.factor_sldo_pres,0) = 0 " &
				  + "and NVL(a.factor_sldo_dev,0) = 0 " &
				  + "and NVL(a.factor_sldo_consig,0) = 0 " &
				  + "and NVL(a.flag_ajuste_valorizacion,'0') = '0' " &
				  + "and NVL(a.factor_sldo_total,0) = -1 " &
				  + "and b.almacen = '" + is_almacen + "'" 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.mov_salida			[al_row] = ls_codigo
			this.object.desc_mov_salida	[al_row] = ls_data
			of_tipo_mov_sal(ls_codigo)
			is_mov_sal = ls_codigo
			this.ii_update = 1
		end if
		
		return
		
	case "matriz_ing"
		
		// Busco la matriz contable por Cuenta Presupuestal
		if istr_mov_consig.flag_matriz_contab = 'P' then
			sl_param.dw1 = "d_sel_tipo_mov_matriz_x_op"
			sl_param.titulo = "Matrices de movimiento almacen"
			sl_param.tipo = '1S_MATRIZ'
			sl_param.string1 = istr_mov_consig.tipo_mov_ing
			sl_param.string2 = this.object.cencos[al_row]
			sl_param.string3 = this.object.cnta_prsp[al_row]
			sl_param.factor_prsp = 0
			sl_param.field_ret_i[1] = 3
			sl_param.field_ret_i[2] = 4
	
			OpenWithParm( w_search, sl_param )
			sl_param = Message.PowerObjectParm
			if sl_param.Titulo = 's' then
				this.object.matriz_ing			[1] = sl_param.field_ret[1]
				this.object.desc_matriz_ing	[1] = sl_param.field_ret[2]
			end if
			
		elseif istr_mov_consig.flag_matriz_contab = 'S' then
			// Busco la matriz contable por Codigo de SubCategoria del Articulo
			ls_cod_art = istr_mov_consig.cod_art
			if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
				MessageBox('Error', 'Debe indicar un codigo de articulo valido')
				return
			end if
			
			select sub_cat_art
				into :ls_sub_cat
			from articulo
			where cod_art = :ls_cod_art;
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de Articulo ' + ls_cod_art + ' no existe')
				return
			end if
			
			if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
				MessageBox('Error', 'No se ha definido Codigo de Sub Categoria en Articulo')
				return
			end if
			
			sl_param.dw1 		= "d_sel_tipo_mov_matriz_subcat"
			sl_param.titulo 	= "Matrices de movimiento almacen"
			sl_param.tipo 		= '2S_MATRIZ'
			sl_param.string1 	= istr_mov_consig.tipo_mov_ing
			sl_param.string2 	= this.object.cencos[al_row]
			sl_param.string3 	= ls_sub_cat
			sl_param.factor_prsp = 0  // Factor Presupuesto de Tipo_mov
			sl_param.field_ret_i[1] = 3
			sl_param.field_ret_i[2] = 4
		
			OpenWithParm( w_search, sl_param)		
			sl_param = MESSAGE.POWEROBJECTPARM
			sl_param = Message.PowerObjectParm
			if sl_param.Titulo = 's' then
				this.object.matriz_ing			[1] = sl_param.field_ret[1]
				this.object.desc_matriz_ing	[1] = sl_param.field_ret[2]
			end if
		else
			MessageBox('Error', 'Valor de FLAG_MATRIZ_CONTABLE incorrecto')
		end if
		
		return
		
	case "cencos"
		
		ld_fecha = Date(istr_mov_consig.dw_m.object.fec_registro[al_row])
		
		if is_flag_contab_sal = '0' then
			
			ls_sql = "select distinct cencos as codigo_cencos, " &
					 + "desc_cencos as descripcion_cencos " &
					 + "from vw_alm_cencos_pp " &
					 + "where ano = " + string(ld_fecha, 'yyyy') 
		else
			
			// Busco solamente aquellos centros que costo que tienen
			// matriz contable
			ls_sql = "select distinct cc.cencos as codigo_cencos, " & 
                + "cc.desc_cencos as descripcion_cencos " &
					 + "from centros_costo cc, " &
     				 + "presupuesto_partida pp, " &
					 + "tipo_mov_matriz     tm " &
					 + "where cc.cencos = pp.cencos " &
  					 + "and tm.grp_cntbl = cc.grp_cntbl " &
					 + "and pp.cnta_prsp = tm.cnta_prsp " &
					 + "and cc.flag_estado = '1' " &
					 + "and ano = " + string(ld_fecha, 'yyyy') + " " &
					 + "and tipo_mov = '" + is_mov_sal + "' " &
					 + "order by cc.desc_cencos"
			
		end if
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "cnta_prsp"
		ld_fecha = Date(istr_mov_consig.dw_m.object.fec_registro[al_row])
		
		if IsNull(this.object.cencos[al_row]) or this.object.cencos[al_row] = '' then
			MessageBox('Aviso', 'Centro de Costos esta vacio')
			return 
		end if
		
		if is_flag_contab_sal = '0' then
			
			ls_sql = "SELECT CNTA_PRSP AS CODIGO_CNTA_PRSP, " &
					  + "DESCRIPCION AS DESCRIPCION_CNTA_PRSP " &
					  + "FROM vw_alm_cnta_prsp_pp " &
					  + "where cencos = '" + this.object.cencos[al_row] + "' " &
					  + "and ano = " + string(ld_fecha, 'yyyy')
					  
		else
			
			// Busco Solamente las cuentas presupuestales que tienen asignado una matriz
			// contable
			ls_sql = "select distinct pc.cnta_prsp as codigo_cnta_prsp, " &
					 + "pc.descripcion as descripicion_cnta_prsp " &
					 + "from presupuesto_cuenta pc, " &
					 + "presupuesto_partida pp, " &
					 + "tipo_mov_matriz tm, " &
					 + "centros_costo cc " &
					 + "where pp.cnta_prsp = pc.cnta_prsp " &
					 + "and tm.cnta_prsp = pc.cnta_prsp " &
					 + "and cc.cencos    = pp.cencos " &
					 + "and cc.grp_cntbl = tm.grp_cntbl " &
					 + "and pp.flag_estado <> '0' " &
				    + "and pp.cencos = '" + this.object.cencos[al_row] + "' " &
					 + "and pp.ano = " + string(ld_fecha, 'yyyy') + " " &
					 + "and tm.tipo_mov = '" + is_mov_sal + "' " &
					 + "order by pc.cnta_prsp "
		end if		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	case "cod_maquina"
		ls_sql = "SELECT cod_maquina AS CODIGO_MAQUINA, " &
				  + "DESC_MAQ AS DESCRIPCION_MAQUINA " &
				  + "FROM MAQUINA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_maquina	[al_row] = ls_codigo
			this.object.desc_maq		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "matriz_sal"
		
		// Busco la matriz contable por Cuenta Presupuestal
		if istr_mov_consig.flag_matriz_contab = 'P' then
			sl_param.dw1 = "d_sel_tipo_mov_matriz_x_op"
			sl_param.titulo = "Matrices de movimiento almacen"
			sl_param.tipo = '1S_MATRIZ'
			sl_param.string1 = is_mov_sal
			sl_param.string2 = trim(this.object.cencos[al_row])
			sl_param.string3 = trim(this.object.cnta_prsp[al_row])
			sl_param.factor_prsp = ii_factor_prsp  // Factor Presupuesto de Tipo_mov
			sl_param.field_ret_i[1] = 3
			sl_param.field_ret_i[2] = 4
	
			OpenWithParm( w_search, sl_param )
			sl_param = Message.PowerObjectParm
			if sl_param.Titulo = 's' then
				this.object.matriz_sal			[1] = sl_param.field_ret[1]
				this.object.desc_matriz_sal	[1] = sl_param.field_ret[2]
			end if
			
		elseif istr_mov_consig.flag_matriz_contab = 'S' then
			// Busco la matriz contable por Codigo de SubCategoria del Articulo
			ls_cod_art = istr_mov_consig.cod_art
			if IsNull(ls_cod_art) or trim(ls_cod_art) = '' then
				MessageBox('Error', 'Debe indicar un codigo de articulo valido')
				return
			end if
			
			select sub_cat_art
				into :ls_sub_cat
			from articulo
			where cod_art = :ls_cod_art;
			
			if SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de Articulo ' + ls_cod_art + ' no existe')
				return
			end if
			
			if IsNull(ls_sub_cat) or trim(ls_sub_cat) = '' then
				MessageBox('Error', 'No se ha definido Codigo de Sub Categoria en Articulo')
				return
			end if
			
			sl_param.dw1 		= "d_sel_tipo_mov_matriz_subcat"
			sl_param.titulo 	= "Matrices de movimiento almacen"
			sl_param.tipo 		= '2S_MATRIZ'
			sl_param.string1 	= is_mov_sal
			sl_param.string2 	= this.object.cencos[al_row]
			sl_param.string3 	= ls_sub_cat
			sl_param.factor_prsp = ii_factor_prsp  // Factor Presupuesto de Tipo_mov
			sl_param.field_ret_i[1] = 3
			sl_param.field_ret_i[2] = 4
		
			OpenWithParm( w_search, sl_param)		
			sl_param = MESSAGE.POWEROBJECTPARM
			if sl_param.Titulo = 's' then
				this.object.matriz_sal			[1] = sl_param.field_ret[1]
				this.object.desc_matriz_sal	[1] = sl_param.field_ret[2]
			end if
		else
			MessageBox('Error', 'Valor de FLAG_MATRIZ_CONTABLE incorrecto')
		end if
		
		return

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

	case "mov_salida"
		SELECT a.desc_tipo_mov
			into :ls_desc
		FROM 	articulo_mov_tipo 	a, 
				almacen_tipo_mov 	   b 
		Where a.tipo_mov = b.tipo_mov 
		  and a.FLAG_ESTADO = '1' 
		  and b.almacen = :is_almacen;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Tipo de movimiento no existe, esta anulado o no le corresponde al almacen')
			this.object.mov_salida			[row] = ls_null
			this.object.desc_mov_salida	[row] = ls_null
			return
		end if
		
		this.object.desc_mov_salida	[row] = ls_desc
		of_tipo_mov_sal(data)
		
		return
		
	case "matriz_ing"
		select descripcion
			into :ls_desc
		from matriz_cntbl_finan
		where matriz = :data
		  and	flag_estado = '1';
		 
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Matriz Contable no existe o no esta activo')
			this.object.matriz_ing		[1] = ls_null
			this.object.desc_matriz_ing[1] = ls_null
			return 1
		end if
		
		this.object.desc_matriz_ing[1] = ls_desc
		return
		
	case "matriz_sal"
		select descripcion
			into :ls_desc
		from matriz_cntbl_finan
		where matriz = :data
		  and	flag_estado = '1';
		 
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Matriz Contable no existe o no esta activo')
			this.object.matriz_sal		[1] = ls_null
			this.object.desc_matriz_sal[1] = ls_null
			return 1
		end if
		
		this.object.desc_matriz_sal[1] = ls_desc
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

