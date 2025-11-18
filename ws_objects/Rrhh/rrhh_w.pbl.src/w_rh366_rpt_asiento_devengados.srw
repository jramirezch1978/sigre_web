$PBExportHeader$w_rh366_rpt_asiento_devengados.srw
forward
global type w_rh366_rpt_asiento_devengados from w_report_smpl
end type
type cb_1 from commandbutton within w_rh366_rpt_asiento_devengados
end type
type em_fecha from editmask within w_rh366_rpt_asiento_devengados
end type
type st_1 from statictext within w_rh366_rpt_asiento_devengados
end type
type rb_8 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type rb_7 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type rb_6 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type rb_5 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type rb_4 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type rb_3 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type rb_2 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type rb_1 from radiobutton within w_rh366_rpt_asiento_devengados
end type
type gb_2 from groupbox within w_rh366_rpt_asiento_devengados
end type
end forward

global type w_rh366_rpt_asiento_devengados from w_report_smpl
integer width = 3387
integer height = 1500
string title = "(RH366) Reporte de Asientos Contables de Devengados"
string menuname = "m_impresion"
cb_1 cb_1
em_fecha em_fecha
st_1 st_1
rb_8 rb_8
rb_7 rb_7
rb_6 rb_6
rb_5 rb_5
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
gb_2 gb_2
end type
global w_rh366_rpt_asiento_devengados w_rh366_rpt_asiento_devengados

on w_rh366_rpt_asiento_devengados.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_fecha=create em_fecha
this.st_1=create st_1
this.rb_8=create rb_8
this.rb_7=create rb_7
this.rb_6=create rb_6
this.rb_5=create rb_5
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_fecha
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_8
this.Control[iCurrent+5]=this.rb_7
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_5
this.Control[iCurrent+8]=this.rb_4
this.Control[iCurrent+9]=this.rb_3
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.rb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_rh366_rpt_asiento_devengados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_fecha)
destroy(this.st_1)
destroy(this.rb_8)
destroy(this.rb_7)
destroy(this.rb_6)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer ln_nro_libro
date ld_fecha
string ls_sit

ld_fecha = date(em_fecha.text)

if rb_1.checked = true then
	ln_nro_libro = 22
	ls_sit = 'INTERESES GRATIFICACIONES EMPLEADOS'
elseif rb_2.checked = true then
	ln_nro_libro = 26
	ls_sit = 'INTERESES GRATIFICACIONES OBREROS'
elseif rb_3.checked = true then
	ln_nro_libro = 23
	ls_sit = 'INTERESES REMUNERACIONES EMPLEADOS'
elseif rb_4.checked = true then
	ln_nro_libro = 27
	ls_sit = 'INTERESES REMUNERACIONES OBREROS'
elseif rb_5.checked = true then
	ln_nro_libro = 24
	ls_sit = 'INTERESES PAGOS GRATIFICACIONES EMPLEADOS'
elseif rb_6.checked = true then
	ln_nro_libro = 28
	ls_sit = 'INTERESES PAGOS GRATIFICACIONES OBREROS'
elseif rb_7.checked = true then
	ln_nro_libro = 25
	ls_sit = 'INTERESES PAGOS REMUNERACIONES EMPLEADOS'
elseif rb_8.checked = true then
	ln_nro_libro = 29
	ls_sit = 'INTERESES PAGOS REMUNERACIONES OBREROS'
end if

dw_report.retrieve (ln_nro_libro,ld_fecha)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_sit.text = ls_sit

end event

type dw_report from w_report_smpl`dw_report within w_rh366_rpt_asiento_devengados
integer x = 0
integer y = 392
integer width = 3328
integer height = 848
integer taborder = 30
string dataobject = "d_rpt_asiento_devengado_tbl"
end type

type cb_1 from commandbutton within w_rh366_rpt_asiento_devengados
integer x = 2798
integer y = 160
integer width = 293
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_fecha from editmask within w_rh366_rpt_asiento_devengados
integer x = 2345
integer y = 204
integer width = 343
integer height = 64
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh366_rpt_asiento_devengados
integer x = 2290
integer y = 128
integer width = 448
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_8 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 1083
integer y = 276
integer width = 1120
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Pagos Remuneraciones Obreros"
end type

type rb_7 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 1083
integer y = 204
integer width = 1120
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Pagos Remuneraciones Empleados"
end type

type rb_6 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 1083
integer y = 132
integer width = 1120
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Pagos Gratificaciones Obreros"
end type

type rb_5 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 1083
integer y = 60
integer width = 1120
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Pagos Gratificaciones Empleados"
end type

type rb_4 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 91
integer y = 276
integer width = 965
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Remuneraciones Obreros"
end type

type rb_3 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 91
integer y = 204
integer width = 965
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Remuneraciones Empleados"
end type

type rb_2 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 91
integer y = 132
integer width = 965
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Gratificaciones Obreros"
end type

type rb_1 from radiobutton within w_rh366_rpt_asiento_devengados
integer x = 91
integer y = 60
integer width = 965
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Intereses Gratificaciones Empleados"
end type

type gb_2 from groupbox within w_rh366_rpt_asiento_devengados
integer width = 2254
integer height = 372
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione Opción  "
end type

