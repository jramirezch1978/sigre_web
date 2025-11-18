$PBExportHeader$w_cm773_os_x_ot_rpt.srw
forward
global type w_cm773_os_x_ot_rpt from w_rpt
end type
type sle_orden from singlelineedit within w_cm773_os_x_ot_rpt
end type
type pb_1 from picturebutton within w_cm773_os_x_ot_rpt
end type
type dw_report from u_dw_rpt within w_cm773_os_x_ot_rpt
end type
type gb_1 from groupbox within w_cm773_os_x_ot_rpt
end type
end forward

global type w_cm773_os_x_ot_rpt from w_rpt
integer width = 2482
integer height = 1800
string title = "(COM733) Reporte de Ordenes de Servicion Por Orden de Trabajo"
string menuname = "m_impresion"
long backcolor = 134217750
sle_orden sle_orden
pb_1 pb_1
dw_report dw_report
gb_1 gb_1
end type
global w_cm773_os_x_ot_rpt w_cm773_os_x_ot_rpt

on w_cm773_os_x_ot_rpt.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_orden=create sle_orden
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_orden
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.gb_1
end on

on w_cm773_os_x_ot_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_orden)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event open;call super::open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;string ls_nro_orden

ls_nro_orden 	= sle_orden.text

if ls_nro_orden = '' or IsNull(ls_nro_orden ) then
	MessageBox('COMEDORES', 'LA ORDEN DE TRABAJO NO ESTA DEFINIDA', StopSign!)
	return
end if

idw_1.Retrieve(ls_nro_orden)

idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
idw_1.object.usuario_t.text = gs_user
this.SetRedraw(true)
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type sle_orden from singlelineedit within w_cm773_os_x_ot_rpt
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 187
integer y = 92
integer width = 407
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event dynamic ue_display()
end event

event ue_display();// Asigna valores a structura 
str_parametros sl_param
sl_param.dw1    = 'd_lista_ot_x_usuario_tbl'
sl_param.titulo = 'Orden de Trabajo'
sl_param.tipo    = '1SQL'                                                          
sl_param.string1 = "WHERE USUARIO= '" + gs_user + "'"
	//+ "' AND COD_ORIGEN = '" + gs_origen + "'"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3
sl_param.field_ret_i[4] = 4
sl_param.field_ret_i[5] = 5
sl_param.field_ret_i[6] = 6
sl_param.field_ret_i[7] = 7
sl_param.field_ret_i[8] = 8
sl_param.field_ret_i[9] = 9
sl_param.field_ret_i[10] = 10

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
				
	This.Text = sl_param.field_ret[2]
	parent.event dynamic ue_retrieve()
			
END IF


end event

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

event modified;//string ls_codigo, ls_data
//
//ls_codigo = trim(this.text)
//
//SetNull(ls_data)
//select descr_especie
//	into :ls_data
//from tg_especies
//where especie = :ls_codigo;
//
//if ls_data = "" or IsNull(ls_data) then
//	Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
//	this.text = ""
//	st_especie.text = ""
//	this.event dynamic ue_reset( )
//	return
//end if
//		
//st_especie.text = ls_data
//
//parent.event dynamic ue_retrieve()
end event

type pb_1 from picturebutton within w_cm773_os_x_ot_rpt
integer x = 718
integer y = 28
integer width = 430
integer height = 200
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve( )

end event

type dw_report from u_dw_rpt within w_cm773_os_x_ot_rpt
integer x = 73
integer y = 264
integer width = 2327
integer height = 1316
string dataobject = "d_rpt_os_x_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_cm773_os_x_ot_rpt
integer x = 78
integer y = 4
integer width = 626
integer height = 228
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Orden:"
end type

