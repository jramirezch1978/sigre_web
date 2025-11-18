$PBExportHeader$w_com711_confin_cp_071.srw
forward
global type w_com711_confin_cp_071 from w_rpt
end type
type cb_4 from commandbutton within w_com711_confin_cp_071
end type
type sle_confin from singlelineedit within w_com711_confin_cp_071
end type
type st_2 from statictext within w_com711_confin_cp_071
end type
type em_mes from editmask within w_com711_confin_cp_071
end type
type st_1 from statictext within w_com711_confin_cp_071
end type
type em_year from editmask within w_com711_confin_cp_071
end type
type pb_1 from picturebutton within w_com711_confin_cp_071
end type
type dw_report from u_dw_rpt within w_com711_confin_cp_071
end type
type gb_2 from groupbox within w_com711_confin_cp_071
end type
type gb_1 from groupbox within w_com711_confin_cp_071
end type
end forward

global type w_com711_confin_cp_071 from w_rpt
integer width = 2661
integer height = 1996
string title = "Documentos Provisionados con un confin diferente al de comedores(Com711) "
string menuname = "m_reporte"
long backcolor = 134217750
cb_4 cb_4
sle_confin sle_confin
st_2 st_2
em_mes em_mes
st_1 st_1
em_year em_year
pb_1 pb_1
dw_report dw_report
gb_2 gb_2
gb_1 gb_1
end type
global w_com711_confin_cp_071 w_com711_confin_cp_071

on w_com711_confin_cp_071.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_4=create cb_4
this.sle_confin=create sle_confin
this.st_2=create st_2
this.em_mes=create em_mes
this.st_1=create st_1
this.em_year=create em_year
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.sle_confin
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_mes
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.em_year
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_com711_confin_cp_071.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.sle_confin)
destroy(this.st_2)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

string ls_confin

string 	ls_cuenta
integer  li_year, li_mes

li_year = YEAR(today())
li_mes  = MONTH(today())

em_year.TEXT = string(li_year)
em_mes.TEXT = string(li_mes)
	
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')
ii_help = 101           // help topic
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

event ue_retrieve;call super::ue_retrieve;string 	ls_confin, ls_desc_confin
integer 	li_ok, li_year, li_mes

this.SetRedraw(false)

ls_confin 	= String(sle_confin.text)
li_mes   	= integer(em_mes.text)
li_year     = integer(em_year.text)

if IsNull(ls_confin) then
	MessageBox('COMEDORES', 'NO HA INGRESO UN CONCEPTO FINANCIERO VÁLIDO',StopSign!)
	return
end if

if li_year < 0 then
	MessageBox('COMEDORES', 'NO HA INGRESO UN AÑO VALIDO',StopSign!)
	return
end if

if li_mes < 0 then
	MessageBox('COMEDORES', 'NO HA INGRESO UN MES VÀLIDO',StopSign!)
	return
end if

idw_1.Retrieve(li_year, li_mes, ls_confin)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
this.SetRedraw(true)
end event

type cb_4 from commandbutton within w_com711_confin_cp_071
integer x = 635
integer y = 136
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_confin.text = sl_param.field_ret[1]
END IF

end event

type sle_confin from singlelineedit within w_com711_confin_cp_071
integer x = 105
integer y = 136
integer width = 480
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_com711_confin_cp_071
integer x = 896
integer y = 120
integer width = 137
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_mes from editmask within w_com711_confin_cp_071
integer x = 1061
integer y = 120
integer width = 233
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_com711_confin_cp_071
integer x = 1317
integer y = 124
integer width = 137
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_com711_confin_cp_071
integer x = 1481
integer y = 124
integer width = 233
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean autoskip = true
boolean spin = true
double increment = 1
end type

type pb_1 from picturebutton within w_com711_confin_cp_071
integer x = 1970
integer y = 52
integer width = 457
integer height = 188
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type dw_report from u_dw_rpt within w_com711_confin_cp_071
integer x = 37
integer y = 300
integer width = 2395
integer height = 1072
string dataobject = "d_confin_comedor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_com711_confin_cp_071
integer x = 859
integer y = 44
integer width = 910
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = " Seleccione Mes y Año"
end type

type gb_1 from groupbox within w_com711_confin_cp_071
integer x = 37
integer y = 48
integer width = 773
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Cuenta Contable "
end type

