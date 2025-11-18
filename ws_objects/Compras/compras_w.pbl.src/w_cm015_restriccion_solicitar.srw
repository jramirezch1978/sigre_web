$PBExportHeader$w_cm015_restriccion_solicitar.srw
forward
global type w_cm015_restriccion_solicitar from w_abc_master_smpl
end type
type st_1 from statictext within w_cm015_restriccion_solicitar
end type
type st_2 from statictext within w_cm015_restriccion_solicitar
end type
type st_3 from statictext within w_cm015_restriccion_solicitar
end type
type sle_1 from singlelineedit within w_cm015_restriccion_solicitar
end type
type cb_1 from commandbutton within w_cm015_restriccion_solicitar
end type
type st_4 from statictext within w_cm015_restriccion_solicitar
end type
type cb_2 from commandbutton within w_cm015_restriccion_solicitar
end type
type sle_2 from singlelineedit within w_cm015_restriccion_solicitar
end type
type gb_1 from groupbox within w_cm015_restriccion_solicitar
end type
end forward

global type w_cm015_restriccion_solicitar from w_abc_master_smpl
integer width = 3205
integer height = 1600
string title = "Articulos restringidos (CM015)"
string menuname = "m_mantto_smpl"
st_1 st_1
st_2 st_2
st_3 st_3
sle_1 sle_1
cb_1 cb_1
st_4 st_4
cb_2 cb_2
sle_2 sle_2
gb_1 gb_1
end type
global w_cm015_restriccion_solicitar w_cm015_restriccion_solicitar

type variables
String is_tipo_doc
end variables

on w_cm015_restriccion_solicitar.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_1=create sle_1
this.cb_1=create cb_1
this.st_4=create st_4
this.cb_2=create cb_2
this.sle_2=create sle_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.sle_2
this.Control[iCurrent+9]=this.gb_1
end on

on w_cm015_restriccion_solicitar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.cb_2)
destroy(this.sle_2)
destroy(this.gb_1)
end on

event ue_modify();call super::ue_modify;//int li_protect
//
//li_protect = integer(dw_master.Object.forma_pago.Protect)
//
//IF li_protect = 0 THEN
//   dw_master.Object.forma_pago.Protect = 1
//END IF
end event

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 
ii_lec_mst = 0

// busca tipo doc. sol. compra
Select doc_sc 
	into :is_tipo_doc 
from logparam 
where reckey = '1';  
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

event resize;call super::resize;gb_1.X = dw_master.X
gb_1.width = dw_master.width
end event

type dw_master from w_abc_master_smpl`dw_master within w_cm015_restriccion_solicitar
integer y = 372
integer width = 3141
integer height = 1036
string dataobject = "d_abc_articulo_restriccion"
borderstyle borderstyle = styleraised!
end type

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;this.object.tipo_doc[al_row] = is_tipo_doc
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String ls_name, ls_prot, ls_sol

str_parametros sl_param

if row <= 0 then return

this.AcceptText()
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

// Ayuda de busqueda para articulos
IF ls_name = 'cod_art' and ls_prot = '0' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_art[this.getrow()] = sl_param.field_ret[1]
		this.object.nom_articulo[this.getrow()] = sl_param.field_ret[2]
		this.object.und[this.getrow()] = sl_param.field_ret[3]		
 	END IF
END IF

if ls_name = 'cencos' and ls_prot = '0' then	
	sl_param.dw1 = "d_dddw_cencos"   //"d_sel_cencos_segun_presup"   //
	sl_param.titulo = "Centro de Costos"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_lista, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.cencos[this.getrow()] = sl_param.field_ret[1]
		this.object.desc_cencos[this.getrow()] = sl_param.field_ret[2]
		ii_update = 1
	END IF
end if
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc_art, ls_und, ls_desc
Long ll_count

SetNull( ls_null)
IF dwo.name = "cod_art" then
	// Busca codigo
	if gnvo_app.almacen.of_articulo_inventariable( data ) <> 1 then 
		this.object.cod_art[row] = ls_null
		this.object.nom_articulo[row] = ls_null
		this.object.und[row] = ls_null
		return 1
	end if

	Select desc_art, und into :ls_desc_art, :ls_und
		from articulo Where cod_Art = :data;
	this.object.nom_Articulo[row] = ls_desc_art
	this.object.und[row] = ls_und	
end if

if dwo.name = 'cencos' then		
	Select desc_cencos into :ls_desc from centros_costo where
	   cencos = :data;	
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "Centro de costo no existe")
		this.object.cencos[row] = ls_null
		This.SetColumn("cencos")
		this.Setfocus()
		Return 1
	else
		this.object.desc_cencos[row] = ls_desc
	end if
	
end if
end event

type st_1 from statictext within w_cm015_restriccion_solicitar
integer x = 695
integer y = 16
integer width = 1509
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "ARTICULOS RESTRINGIDOS A SOLICITAR"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm015_restriccion_solicitar
integer x = 110
integer y = 156
integer width = 453
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de costo:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cm015_restriccion_solicitar
integer x = 82
integer y = 252
integer width = 453
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo documento:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_cm015_restriccion_solicitar
integer x = 576
integer y = 140
integer width = 297
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cm015_restriccion_solicitar
integer x = 891
integer y = 140
integer width = 87
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_parametros sl_param

		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_cencos"
		sl_param.titulo = "Centros de costo"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			sle_1.text = sl_param.field_ret[1]
			st_4.text =  sl_param.field_ret[2]
		END IF

end event

type st_4 from statictext within w_cm015_restriccion_solicitar
integer x = 1010
integer y = 148
integer width = 731
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_cm015_restriccion_solicitar
integer x = 2162
integer y = 184
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;dw_master.retrieve(sle_1.text, sle_2.text)
end event

type sle_2 from singlelineedit within w_cm015_restriccion_solicitar
event ue_display ( )
event ue_dobleclick pbm_lbuttondblclk
event ue_keydwn pbm_keydown
integer x = 576
integer y = 244
integer width = 297
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\Cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_display();boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT TIPO_DOC AS CODIGO_DOC, " &
		 + "DESC_TIPO_DOC AS DESCRIPCION_DOCUMENTO " &
		 + "FROM DOC_TIPO "
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '2')
		
if ls_codigo <> '' then
	this.text   = ls_codigo
end if
end event

event ue_dobleclick;this.event dynamic ue_display()
end event

event ue_keydwn;// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
 	this.event dynamic ue_display( )
end if
return 0
end event

type gb_1 from groupbox within w_cm015_restriccion_solicitar
integer y = 88
integer width = 3122
integer height = 268
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Búsqueda"
end type

