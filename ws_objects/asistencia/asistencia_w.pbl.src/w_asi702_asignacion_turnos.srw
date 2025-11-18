$PBExportHeader$w_asi702_asignacion_turnos.srw
forward
global type w_asi702_asignacion_turnos from w_rpt
end type
type em_ano from editmask within w_asi702_asignacion_turnos
end type
type ddlb_mes from dropdownlistbox within w_asi702_asignacion_turnos
end type
type st_3 from statictext within w_asi702_asignacion_turnos
end type
type st_2 from statictext within w_asi702_asignacion_turnos
end type
type em_nombres from editmask within w_asi702_asignacion_turnos
end type
type cb_1 from commandbutton within w_asi702_asignacion_turnos
end type
type em_codigo from editmask within w_asi702_asignacion_turnos
end type
type st_1 from statictext within w_asi702_asignacion_turnos
end type
type pb_1 from picturebutton within w_asi702_asignacion_turnos
end type
type dw_report from u_dw_rpt within w_asi702_asignacion_turnos
end type
type gb_2 from groupbox within w_asi702_asignacion_turnos
end type
end forward

global type w_asi702_asignacion_turnos from w_rpt
integer width = 4091
integer height = 2388
string title = "Asignacion de Turnos (ASI702)"
string menuname = "m_reporte"
long backcolor = 67108864
em_ano em_ano
ddlb_mes ddlb_mes
st_3 st_3
st_2 st_2
em_nombres em_nombres
cb_1 cb_1
em_codigo em_codigo
st_1 st_1
pb_1 pb_1
dw_report dw_report
gb_2 gb_2
end type
global w_asi702_asignacion_turnos w_asi702_asignacion_turnos

on w_asi702_asignacion_turnos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.st_3=create st_3
this.st_2=create st_2
this.em_nombres=create em_nombres
this.cb_1=create cb_1
this.em_codigo=create em_codigo
this.st_1=create st_1
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.ddlb_mes
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_nombres
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.em_codigo
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.gb_2
end on

on w_asi702_asignacion_turnos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_nombres)
destroy(this.cb_1)
destroy(this.em_codigo)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_2)
end on

event ue_open_pre;//Overrride

idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 100

ib_preview = false
THIS.Event ue_preview()



 ii_help = 101           // help topic
end event

event ue_retrieve;call super::ue_retrieve;String ls_ano,ls_mes,ls_cod_trabajador

ls_ano    = em_ano.text
ls_mes    = LEFT(ddlb_mes.text,2)
ls_cod_trabajador = em_codigo.text


idw_1.Retrieve(ls_cod_trabajador,ls_ano+ls_mes)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

this.SetRedraw(true)

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;
IF ib_preview THEN
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

type em_ano from editmask within w_asi702_asignacion_turnos
integer x = 521
integer y = 216
integer width = 174
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_asi702_asignacion_turnos
integer x = 521
integer y = 308
integer width = 517
integer height = 856
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_asi702_asignacion_turnos
integer x = 297
integer y = 320
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_asi702_asignacion_turnos
integer x = 297
integer y = 228
integer width = 210
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_nombres from editmask within w_asi702_asignacion_turnos
integer x = 978
integer y = 128
integer width = 1202
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_asi702_asignacion_turnos
integer x = 882
integer y = 128
integer width = 87
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF

end event

type em_codigo from editmask within w_asi702_asignacion_turnos
integer x = 521
integer y = 128
integer width = 338
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_asi702_asignacion_turnos
integer x = 123
integer y = 128
integer width = 384
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "C.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_asi702_asignacion_turnos
integer x = 2738
integer y = 88
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_asi702_asignacion_turnos
integer x = 64
integer y = 456
integer width = 3730
integer height = 1444
string dataobject = "d_rpt_asignacion_turnos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_asi702_asignacion_turnos
integer x = 69
integer y = 32
integer width = 3022
integer height = 400
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Busqueda"
end type

