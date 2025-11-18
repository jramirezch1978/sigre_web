$PBExportHeader$w_ope731_costo_x_maquina.srw
forward
global type w_ope731_costo_x_maquina from w_report_smpl
end type
type cb_1 from commandbutton within w_ope731_costo_x_maquina
end type
type dw_ot from datawindow within w_ope731_costo_x_maquina
end type
type cb_2 from commandbutton within w_ope731_costo_x_maquina
end type
type uo_1 from u_ingreso_rango_fechas_horas within w_ope731_costo_x_maquina
end type
type rb_detallado from radiobutton within w_ope731_costo_x_maquina
end type
type rb_resumen from radiobutton within w_ope731_costo_x_maquina
end type
type gb_1 from groupbox within w_ope731_costo_x_maquina
end type
type gb_3 from groupbox within w_ope731_costo_x_maquina
end type
type gb_2 from groupbox within w_ope731_costo_x_maquina
end type
end forward

global type w_ope731_costo_x_maquina from w_report_smpl
integer width = 4128
integer height = 2300
string title = "Costo x Maquina $ (OPE731)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
cb_1 cb_1
dw_ot dw_ot
cb_2 cb_2
uo_1 uo_1
rb_detallado rb_detallado
rb_resumen rb_resumen
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_ope731_costo_x_maquina w_ope731_costo_x_maquina

on w_ope731_costo_x_maquina.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.dw_ot=create dw_ot
this.cb_2=create cb_2
this.uo_1=create uo_1
this.rb_detallado=create rb_detallado
this.rb_resumen=create rb_resumen
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ot
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.uo_1
this.Control[iCurrent+5]=this.rb_detallado
this.Control[iCurrent+6]=this.rb_resumen
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_2
end on

on w_ope731_costo_x_maquina.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ot)
destroy(this.cb_2)
destroy(this.uo_1)
destroy(this.rb_detallado)
destroy(this.rb_resumen)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True
end event

event open;call super::open;dw_ot.SetTransObject(sqlca)
dw_ot.InsertRow(0)
end event

type dw_report from w_report_smpl`dw_report within w_ope731_costo_x_maquina
integer x = 37
integer y = 288
integer width = 4014
integer height = 1800
string dataobject = "d_gastos_x_equipo"
end type

type cb_1 from commandbutton within w_ope731_costo_x_maquina
integer x = 3479
integer y = 152
integer width = 421
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
boolean default = true
end type

event clicked;Datetime   ld_fecha_inicio,ld_fecha_final
String ls_ot,ls_desc_maq
Long   ll_count


//verificación de fechas
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

//codigo ot
ls_ot = dw_ot.object.ot_adm[1]

idw_1.ii_zoom_actual = 100

if rb_detallado.checked = true then
	
	dw_report.DataObject = 'd_gastos_x_equipo'
	dw_report.SetTransObject(sqlca)
	dw_report.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_ot,gs_empresa,gs_user)
	
else
	
	dw_report.DataObject = 'd_gastos_x_equipo_r'
	dw_report.SetTransObject(sqlca)
	dw_report.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_ot,gs_empresa,gs_user)
	ib_preview = FALSE
	
end if

dw_report.Object.p_logo.filename = gs_logo

ib_preview = FALSE
Parent.Event ue_preview()
end event

type dw_ot from datawindow within w_ope731_costo_x_maquina
integer x = 1742
integer y = 120
integer width = 827
integer height = 68
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_ot_adm"
boolean border = false
boolean livescroll = true
end type

type cb_2 from commandbutton within w_ope731_costo_x_maquina
integer x = 2706
integer y = 112
integer width = 494
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Maquinas"
end type

event clicked;open(w_ope732_seleccion_maquina)
end event

type uo_1 from u_ingreso_rango_fechas_horas within w_ope731_costo_x_maquina
event destroy ( )
integer x = 32
integer y = 116
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas_horas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(DateTime(today()), DateTime(today())) //para setear la fecha inicial
of_set_rango_inicio(datetime('01/01/1900')) // rango inicial
of_set_rango_fin(datetime('31/12/9999')) // rango final
end event

type rb_detallado from radiobutton within w_ope731_costo_x_maquina
integer x = 3310
integer y = 56
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado"
boolean checked = true
end type

type rb_resumen from radiobutton within w_ope731_costo_x_maquina
integer x = 3666
integer y = 52
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resument"
end type

type gb_1 from groupbox within w_ope731_costo_x_maquina
integer x = 9
integer y = 44
integer width = 1691
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas :"
end type

type gb_3 from groupbox within w_ope731_costo_x_maquina
integer x = 1714
integer y = 40
integer width = 891
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione OT :"
end type

type gb_2 from groupbox within w_ope731_costo_x_maquina
integer x = 2629
integer y = 36
integer width = 649
integer height = 200
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione Maquinas :"
end type

