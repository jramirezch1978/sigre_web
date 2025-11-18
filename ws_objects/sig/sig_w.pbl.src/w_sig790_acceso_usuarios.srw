$PBExportHeader$w_sig790_acceso_usuarios.srw
forward
global type w_sig790_acceso_usuarios from w_cns
end type
type cbx_todos from checkbox within w_sig790_acceso_usuarios
end type
type cb_1 from commandbutton within w_sig790_acceso_usuarios
end type
type st_etiqueta from statictext within w_sig790_acceso_usuarios
end type
type dw_detalle from u_dw_cns within w_sig790_acceso_usuarios
end type
type dw_master from u_dw_cns within w_sig790_acceso_usuarios
end type
type sle_ano from singlelineedit within w_sig790_acceso_usuarios
end type
type st_2 from statictext within w_sig790_acceso_usuarios
end type
type st_1 from statictext within w_sig790_acceso_usuarios
end type
type ddlb_usuario from u_ddlb within w_sig790_acceso_usuarios
end type
end forward

global type w_sig790_acceso_usuarios from w_cns
integer width = 3630
integer height = 1592
string title = "Accesos de Usuarios a los Sistemas (SIG790)"
string menuname = "m_frame"
cbx_todos cbx_todos
cb_1 cb_1
st_etiqueta st_etiqueta
dw_detalle dw_detalle
dw_master dw_master
sle_ano sle_ano
st_2 st_2
st_1 st_1
ddlb_usuario ddlb_usuario
end type
global w_sig790_acceso_usuarios w_sig790_acceso_usuarios

type variables
String	is_key
end variables

on w_sig790_acceso_usuarios.create
int iCurrent
call super::create
if this.MenuName = "m_frame" then this.MenuID = create m_frame
this.cbx_todos=create cbx_todos
this.cb_1=create cb_1
this.st_etiqueta=create st_etiqueta
this.dw_detalle=create dw_detalle
this.dw_master=create dw_master
this.sle_ano=create sle_ano
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_usuario=create ddlb_usuario
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_todos
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_etiqueta
this.Control[iCurrent+4]=this.dw_detalle
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.sle_ano
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.ddlb_usuario
end on

on w_sig790_acceso_usuarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_todos)
destroy(this.cb_1)
destroy(this.st_etiqueta)
destroy(this.dw_detalle)
destroy(this.dw_master)
destroy(this.sle_ano)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_usuario)
end on

event ue_open_pre;call super::ue_open_pre;sle_ano.Text = String(Year(Today()))

dw_master.SetTransObject(sqlca)
dw_detalle.SetTransObject(sqlca)

of_center_window()
end event

event resize;call super::resize;dw_master.height   = newheight - dw_master.y - 10
dw_detalle.width  = newwidth  - dw_detalle.x - 10
dw_detalle.height = newheight - dw_detalle.y - 10
end event

type cbx_todos from checkbox within w_sig790_acceso_usuarios
integer x = 3118
integer y = 16
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;IF THIS.Checked THEN
	ddlb_usuario.Reset()
	ddlb_usuario.is_dataobject = 'd_usuarios_tbl'
	ddlb_usuario.Event ue_populate()
ELSE
	ddlb_usuario.Reset()
	ddlb_usuario.is_dataobject = 'd_usuarios_activos_tbl'
	ddlb_usuario.Event ue_populate()
END IF

end event

type cb_1 from commandbutton within w_sig790_acceso_usuarios
integer x = 2496
integer y = 28
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;dw_master.Retrieve(sle_ano.Text,is_key)
dw_detalle.Retrieve(sle_ano.Text,is_key)
end event

type st_etiqueta from statictext within w_sig790_acceso_usuarios
boolean visible = false
integer y = 100
integer width = 402
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
boolean focusrectangle = false
end type

type dw_detalle from u_dw_cns within w_sig790_acceso_usuarios
integer x = 2688
integer y = 160
integer width = 882
integer height = 1188
integer taborder = 30
string dataobject = "d_log_login_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1 
end event

event doubleclicked;call super::doubleclicked;STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "fecha"  
		lstr_1.DataObject = 'd_usr_log_objeto_tbl'
		lstr_1.Width = 2000
		lstr_1.Height= 1300
		lstr_1.Title = 'Detalle de Ventanas Accesadas'
		lstr_1.Arg[1] = GetItemString(row,'cod_usr')
      lstr_1.Arg[2] = String(GetItemDateTime(row,'fecha'), 'yyyymmddhhmmss')
      lstr_1.Arg[3] = String(GetItemDateTime(row,'fecha_fin'), 'yyyymmddhhmmss')
		IF lstr_1.Arg[3] = "" THEN	lstr_1.Arg[3] = '99991231245959'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type dw_master from u_dw_cns within w_sig790_acceso_usuarios
event ue_mousemove pbm_mousemove
integer x = 9
integer y = 160
integer width = 2647
integer height = 1188
integer taborder = 20
string dataobject = "d_accesos_usuario_grf"
end type

event ue_mousemove;	Int  li_Rtn, li_Series, li_Category 
	String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
	Long ll_row 
	grObjectType MouseMoveObject 
	MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)
	IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
 		ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías 
 		ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo 
 		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0') //la etiqueta de los valores
 		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
 		st_etiqueta.BringToTop = TRUE 
 		st_etiqueta.x = xpos 
 		st_etiqueta.y = ypos 
 		st_etiqueta.text = ls_mensaje 
 		st_etiqueta.width = len(ls_mensaje) * 30 
 		st_etiqueta.visible = true 
	ELSE 
 		st_etiqueta.visible = false 
	END IF



end event

event constructor;call super::constructor;ii_ck[1] = 1 
end event

type sle_ano from singlelineedit within w_sig790_acceso_usuarios
integer x = 215
integer y = 16
integer width = 219
integer height = 72
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_sig790_acceso_usuarios
integer x = 677
integer y = 16
integer width = 261
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuario:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_sig790_acceso_usuarios
integer x = 9
integer y = 16
integer width = 174
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ddlb_usuario from u_ddlb within w_sig790_acceso_usuarios
integer x = 983
integer y = 16
integer width = 1371
integer height = 452
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_usuarios_activos_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 30                     // Longitud del campo 1
ii_lc2 = 14							// Longitud del campo 2
end event

event ue_output;call super::ue_output;is_key = aa_key


end event

