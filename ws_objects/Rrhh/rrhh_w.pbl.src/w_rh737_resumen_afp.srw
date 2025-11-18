$PBExportHeader$w_rh737_resumen_afp.srw
forward
global type w_rh737_resumen_afp from w_report_smpl
end type
type cb_procesar from commandbutton within w_rh737_resumen_afp
end type
type sle_mes from singlelineedit within w_rh737_resumen_afp
end type
type st_3 from statictext within w_rh737_resumen_afp
end type
type sle_year from singlelineedit within w_rh737_resumen_afp
end type
type st_4 from statictext within w_rh737_resumen_afp
end type
type gb_1 from groupbox within w_rh737_resumen_afp
end type
end forward

global type w_rh737_resumen_afp from w_report_smpl
integer width = 4055
integer height = 1652
string title = "[RH737] Resumen Calculo AFP (PLANILLA Y L.B.S.)"
string menuname = "m_impresion"
cb_procesar cb_procesar
sle_mes sle_mes
st_3 st_3
sle_year sle_year
st_4 st_4
gb_1 gb_1
end type
global w_rh737_resumen_afp w_rh737_resumen_afp

on w_rh737_resumen_afp.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_procesar=create cb_procesar
this.sle_mes=create sle_mes
this.st_3=create st_3
this.sle_year=create sle_year
this.st_4=create st_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_procesar
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_year
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.gb_1
end on

on w_rh737_resumen_afp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_procesar)
destroy(this.sle_mes)
destroy(this.st_3)
destroy(this.sle_year)
destroy(this.st_4)
destroy(this.gb_1)
end on

event ue_retrieve;Integer	li_year, li_mes


li_year	= Integer(sle_year.text)
li_mes	= Integer(sle_mes.text)


dw_report.SetTransObject(SQLCA)
dw_report.retrieve(li_year, li_mes)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

event ue_open_pre;Date	ld_today
idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ld_today = Date(gnvo_app.of_fecha_actual())

sle_year.text = string(ld_today, 'yyyy')
sle_mes.text	= string(ld_today, 'mm')


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_report_smpl`dw_report within w_rh737_resumen_afp
integer x = 0
integer y = 208
integer width = 3689
integer height = 1000
integer taborder = 50
string dataobject = "d_rpt_resumen_pago_afp_crt"
end type

event dw_report::clicked;call super::clicked;f_select_current_row(this)
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_procesar from commandbutton within w_rh737_resumen_afp
integer x = 745
integer y = 12
integer width = 352
integer height = 176
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;setPointer(HourGlass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)
end event

type sle_mes from singlelineedit within w_rh737_resumen_afp
integer x = 576
integer y = 76
integer width = 105
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh737_resumen_afp
integer x = 416
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_rh737_resumen_afp
integer x = 201
integer y = 76
integer width = 192
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_rh737_resumen_afp
integer x = 32
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh737_resumen_afp
integer width = 727
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Periodo"
end type

