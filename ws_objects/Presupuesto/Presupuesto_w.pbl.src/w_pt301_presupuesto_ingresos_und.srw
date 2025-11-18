$PBExportHeader$w_pt301_presupuesto_ingresos_und.srw
forward
global type w_pt301_presupuesto_ingresos_und from w_abc_master
end type
type st_1 from statictext within w_pt301_presupuesto_ingresos_und
end type
type em_year from editmask within w_pt301_presupuesto_ingresos_und
end type
type st_2 from statictext within w_pt301_presupuesto_ingresos_und
end type
type em_cencos from editmask within w_pt301_presupuesto_ingresos_und
end type
type st_3 from statictext within w_pt301_presupuesto_ingresos_und
end type
type em_cod_art from editmask within w_pt301_presupuesto_ingresos_und
end type
type cb_cencos from commandbutton within w_pt301_presupuesto_ingresos_und
end type
type cb_cnta from commandbutton within w_pt301_presupuesto_ingresos_und
end type
type cb_1 from commandbutton within w_pt301_presupuesto_ingresos_und
end type
type gb_1 from groupbox within w_pt301_presupuesto_ingresos_und
end type
end forward

global type w_pt301_presupuesto_ingresos_und from w_abc_master
integer width = 2834
integer height = 2224
string title = "Presupuesto de ingresos - Plan de Venta (PT301)"
string menuname = "m_mantenimiento_cl"
event ue_cancelar ( )
event ue_anular ( )
st_1 st_1
em_year em_year
st_2 st_2
em_cencos em_cencos
st_3 st_3
em_cod_art em_cod_art
cb_cencos cb_cencos
cb_cnta cb_cnta
cb_1 cb_1
gb_1 gb_1
end type
global w_pt301_presupuesto_ingresos_und w_pt301_presupuesto_ingresos_und

type variables

end variables

forward prototypes
public subroutine of_limpia_datos ()
public subroutine of_set_status_reg ()
end prototypes

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()

dw_master.ii_update = 0
is_action = ''
of_set_status_reg()


end event

event ue_anular();// Ancestor Script has been Override
string ls_estado
int li_protect

if dw_master.GetRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.GetRow()]

if ls_estado = '0' then
	MessageBox('Aviso', 'No puede Anular un registro anulado')
	return
end if

if ls_estado = '2' then
	MessageBox('Aviso', 'No puede Anular un registro procesado')
	return
end if

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1
is_action = 'anu'
of_set_status_reg()
end event

public subroutine of_limpia_datos ();// Limpia los datos de busqueda
em_year.text = ''
em_cencos.text = ''
em_cod_art.text = ''
end subroutine

public subroutine of_set_status_reg ();/*
  Funcion que verifica el status del documento
*/
Int li_estado

this.changemenu(m_mantenimiento_cl)

// Activa todas las opciones
if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled = true
else
	m_master.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled = true
else
	m_master.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled = true
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
end if
m_master.m_file.m_basedatos.m_grabar.enabled = true


if dw_master.getrow() = 0 then return 

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 	 = false
	m_master.m_file.m_basedatos.m_modificar.enabled  = false	
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false	
	m_master.m_file.m_basedatos.m_anular.enabled 	 = false
	m_master.m_file.m_basedatos.m_insertar.enabled 	= false	

elseif is_Action = 'open' then
	
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
	
	Choose case li_estado
		case 0		// Anulado			
			m_master.m_file.m_basedatos.m_eliminar.enabled   = false
			m_master.m_file.m_basedatos.m_modificar.enabled  = false				
			m_master.m_file.m_basedatos.m_anular.enabled 	 = false
			
		CASE 1   // Activo
		
		CASE 2   // Procesado
			m_master.m_file.m_basedatos.m_eliminar.enabled  = false
			m_master.m_file.m_basedatos.m_modificar.enabled = false		
			m_master.m_file.m_basedatos.m_anular.enabled 	= false
			
	end CHOOSE
	
elseif is_Action = 'edit' OR is_Action = 'anu' OR is_Action = 'del' then
	
	m_master.m_file.m_basedatos.m_insertar.enabled   = false
	m_master.m_file.m_basedatos.m_eliminar.enabled   = false
	m_master.m_file.m_basedatos.m_modificar.enabled  = false	
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false	
	m_master.m_file.m_basedatos.m_anular.enabled 	 = false
	
end if

return 
end subroutine

on w_pt301_presupuesto_ingresos_und.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.st_1=create st_1
this.em_year=create em_year
this.st_2=create st_2
this.em_cencos=create em_cencos
this.st_3=create st_3
this.em_cod_art=create em_cod_art
this.cb_cencos=create cb_cencos
this.cb_cnta=create cb_cnta
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_cencos
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_cod_art
this.Control[iCurrent+7]=this.cb_cencos
this.Control[iCurrent+8]=this.cb_cnta
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.gb_1
end on

on w_pt301_presupuesto_ingresos_und.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.st_2)
destroy(this.em_cencos)
destroy(this.st_3)
destroy(this.em_cod_art)
destroy(this.cb_cencos)
destroy(this.cb_cnta)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)

ib_log = TRUE
end event

event ue_modify;// Ancestor Script has been Override
string ls_estado
int li_protect

if dw_master.GetRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.GetRow()]

if ls_estado = '0' then
	MessageBox('Aviso', 'No puede modificar un registro anulado')
	dw_master.ii_protect = 0
	dw_master.of_protect()
	return
end if

if ls_estado = '2' then
	MessageBox('Aviso', 'No puede modificar un registro procesado')
	dw_master.ii_protect = 0
	dw_master.of_protect()
	return
end if

dw_master.of_protect()

li_protect = integer(dw_master.Object.ano.Protect)

IF li_protect = 0 THEN
   dw_master.Object.ano.Protect = 1
	dw_master.Object.cencos.Protect = 1
	dw_master.Object.cod_art.Protect = 1
END IF

is_action = 'edit'
of_set_status_reg()
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores

ib_update_check = True

if gnvo_app.of_row_Processing( dw_master ) <> true then
	ib_update_check = False
	return
end if

dw_master.of_set_flag_replicacion()

end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_lista_presupuesto_ingresos_und"
sl_param.titulo = ""
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	dw_master.retrieve(Long(sl_param.field_ret[1]), sl_param.field_ret[2], sl_param.field_ret[3])
	dw_master.ii_protect = 0
	dw_master.of_protect()
	is_action = 'open'
	of_set_status_reg()
END IF
end event

event ue_insert;// Override
Long  ll_row

idw_1.reset()
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if


end event

event ue_delete;// Ancestor Script has been Override
string ls_estado
int li_protect
Long  ll_row

if dw_master.GetRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.GetRow()]

if ls_estado = '2' then
	MessageBox('Aviso', 'No puede eliminar un registro procesado')
	return
end if

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

is_action='del'
of_set_status_reg()
end event

type dw_master from w_abc_master`dw_master within w_pt301_presupuesto_ingresos_und
event ue_display ( string as_columna,  long al_row )
integer y = 176
integer width = 2702
integer height = 1816
string dataobject = "d_abc_presupuesto_ingresos_und"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cod_Art
str_Articulo	lstr_articulo

choose case lower(as_columna)
		
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				 + "DESC_cencos AS DESCRIPCION_cencos " &
				 + "FROM centros_costo " &
				 + "where flag_estado ='1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		return

	case "cod_art"
		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
		
		if lstr_articulo.b_Return then
			this.object.cod_art				[al_row] = lstr_articulo.cod_art
			this.object.desc_art				[al_row] = lstr_articulo.desc_art
			this.object.und					[al_row] = lstr_articulo.und
			
			this.ii_update = 1
		end if
			

	case "cod_plantilla"
		ls_cod_art = this.object.cod_art [al_row]
		
		if ls_cod_art = '' or IsNull(ls_cod_art) then
			MessageBox('Aviso', 'Debe indicar un Codigo de Articulo primero')
			return
		end if
		
		ls_sql = "select cod_plantilla as codigo_plantilla, " &
				 + "descripcion as descripcion_plantilla, " &
				 + "flag_mercado as flag_mercado, " &
				 + "forma_embarque as forma_embarque " &
				 + "from presup_plant " &
				 + "where cod_art = '" + ls_cod_art + "' " &
				 + "or cod_art is null"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_plantilla	[al_row] = ls_codigo
			this.object.desc_plantilla	[al_row] = ls_data
			this.ii_update = 1
		end if
		return
		
		
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc, ls_und, ls_estado, ls_null, ls_mensaje, &
			ls_cod_art
decimal 	ldc_proy

SetNull(ls_null)

// Verifica si existe
this.AcceptText()

if dwo.name = "cencos" then	
	Select desc_cencos 
		into :ls_desc 
	from centros_costo 
	where cencos = :data
	  and flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		Messagebox( "Error", "Centro de costo no existe o no esta activo", Exclamation!)		
		this.object.cencos		[row] = ls_null
		this.object.desc_cencos	[row] = ls_null
		Return 1
	end if	
	
	this.object.desc_cencos[row] = ls_desc

elseIF dwo.name = "cod_art" then		
	
	Select desc_art, und
		into :ls_desc, :ls_und
	from articulo 
	where cod_art = :data
	  and flag_estado = '1'
	  and NVL(flag_inventariable, '0') = '1';
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Articulo no existe, no esta activo o esta como no inventariable", Exclamation!)		
		this.object.cod_Art	[row] = ls_null
		this.object.desc_Art	[row] = ls_null
		this.object.und		[row] = ls_null
		Return 1
	end if
	
	this.object.desc_art	[row] = ls_desc
	this.object.und		[row] = ls_und	

elseif dwo.name = "cod_plantilla" then	
	
	ls_cod_art = this.object.cod_art [row]
	
	if ls_Cod_art = '' or IsNull(ls_cod_art) then
		MessageBox('Aviso', 'Debe especificar primero un codigo de articulo')
		return
	end if
	
	Select descripcion 
		into :ls_desc 
	from presup_plant 
	where cod_plantilla = :data
	  and (cod_art = :ls_cod_art or cod_art is null);	
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Codigo de Plantilla no existe o no corresponde al Articulo", Exclamation!)		
		this.object.cod_plantilla	[row] = ls_null
		this.object.desc_plantilla	[row] = ls_null
		Return 1
	end if
	
	this.object.desc_plantilla	[row] = ls_desc

elseif left(dwo.name,4) = "proy" then
	ldc_proy = dec(data)
	if ldc_proy < 0 then
		MessageBox('Aviso', 'La proyección de Producción (' + string(dwo.name) + ') no debe ser negativa')
		this.Setitem( row, string(dwo.name), 0)
		this.SetColumn(string(dwo.name))
		return 1
	end if

end if
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr				[al_row] = gs_user
this.object.flag_replicacion	[al_row] = '1'
this.object.flag_estado			[al_row] = '1'

this.object.proy_ene[al_row] = 0
this.object.proy_feb[al_row] = 0
this.object.proy_mar[al_row] = 0
this.object.proy_abr[al_row] = 0
this.object.proy_may[al_row] = 0
this.object.proy_jun[al_row] = 0
this.object.proy_jul[al_row] = 0
this.object.proy_ago[al_row] = 0
this.object.proy_set[al_row] = 0
this.object.proy_oct[al_row] = 0
this.object.proy_nov[al_row] = 0
this.object.proy_dic[al_row] = 0

this.object.pu_proy_ene[al_row] = 0
this.object.pu_proy_feb[al_row] = 0
this.object.pu_proy_mar[al_row] = 0
this.object.pu_proy_abr[al_row] = 0
this.object.pu_proy_may[al_row] = 0
this.object.pu_proy_jun[al_row] = 0
this.object.pu_proy_jul[al_row] = 0
this.object.pu_proy_ago[al_row] = 0
this.object.pu_proy_set[al_row] = 0
this.object.pu_proy_oct[al_row] = 0
this.object.pu_proy_nov[al_row] = 0
this.object.pu_proy_dic[al_row] = 0

is_action = 'new'

end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

type st_1 from statictext within w_pt301_presupuesto_ingresos_und
integer x = 23
integer y = 72
integer width = 142
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_pt301_presupuesto_ingresos_und
integer x = 178
integer y = 64
integer width = 210
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_2 from statictext within w_pt301_presupuesto_ingresos_und
integer x = 416
integer y = 72
integer width = 325
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cencos from editmask within w_pt301_presupuesto_ingresos_und
integer x = 754
integer y = 64
integer width = 265
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_3 from statictext within w_pt301_presupuesto_ingresos_und
integer x = 1138
integer y = 72
integer width = 320
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cod Artículo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cod_art from editmask within w_pt301_presupuesto_ingresos_und
integer x = 1477
integer y = 64
integer width = 343
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_cencos from commandbutton within w_pt301_presupuesto_ingresos_und
integer x = 1019
integer y = 64
integer width = 91
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year

ls_year = trim(em_year.text)

if ls_year = '' or IsNull(ls_year) then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

ls_sql = "select distinct b.cencos as codigo_cencos, " &
		 + "b.desc_cencos as descripcion_cencos " &
		 + "from presup_ingresos_und a, " &
		 + "centros_costo b " &
		 + "where a.cencos = b.cencos " &
		 + "and a.ano = " + ls_year
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_cencos.text = ls_codigo
end if
		

end event

type cb_cnta from commandbutton within w_pt301_presupuesto_ingresos_und
integer x = 1819
integer y = 64
integer width = 91
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_year, ls_cencos

ls_year = trim(em_year.text)

if ls_year = '' or IsNull(ls_year) then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

ls_cencos = trim(em_cencos.text)

if ls_cencos = '' or IsNull(ls_cencos) then
	MessageBox('Aviso', 'Debe especificar un centro de costo')
	return
end if

ls_sql = "select b.cod_art as codigo_Articulo, " &
		 + "b.desc_art as descripcion_articulo, " &
		 + "b.und as unidad " &
		 + "from presup_ingresos_und a, " &
		 + "articulo b " &
		 + "where a.cod_art = b.cod_art " &
		 + "and a.ano = " + ls_year + " " &
		 + "and a.cencos = '" + ls_cencos + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	em_cod_art.text = ls_codigo
end if
		


end event

type cb_1 from commandbutton within w_pt301_presupuesto_ingresos_und
integer x = 2025
integer y = 64
integer width = 261
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;if em_year.text = '' then
	MessageBox('Aviso', 'Debe especificar un año')
	return
end if

if em_cencos.text = '' then
	MessageBox('Aviso', 'Debe especificar un Centro de Costo')
	return
end if

if em_cod_art.text = '' then
	MessageBox('Aviso', 'Debe especificar un Centro de Costo')
	return
end if

dw_master.retrieve(Long(em_year.text), em_cencos.text, em_cod_art.text)
dw_master.ii_protect = 0
dw_master.of_protect()
of_limpia_datos()
of_set_status_reg()
end event

type gb_1 from groupbox within w_pt301_presupuesto_ingresos_und
integer width = 2354
integer height = 168
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de búsqueda"
end type

