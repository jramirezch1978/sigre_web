$PBExportHeader$w_cm508_sc_oc_ni.srw
forward
global type w_cm508_sc_oc_ni from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm508_sc_oc_ni
end type
type cb_3 from commandbutton within w_cm508_sc_oc_ni
end type
type gb_1 from groupbox within w_cm508_sc_oc_ni
end type
end forward

global type w_cm508_sc_oc_ni from w_report_smpl
integer width = 2670
integer height = 1528
string title = "Atencion de solicitud de compra (CM508)"
string menuname = "m_impresion"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
gb_1 gb_1
end type
global w_cm508_sc_oc_ni w_cm508_sc_oc_ni

on w_cm508_sc_oc_ni.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.gb_1
end on

on w_cm508_sc_oc_ni.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.gb_1)
end on

type dw_report from w_report_smpl`dw_report within w_cm508_sc_oc_ni
integer x = 27
integer y = 308
integer width = 2336
integer height = 1012
string dataobject = "d_rpt_sc_oc_ni_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_cm508_sc_oc_ni
integer x = 64
integer y = 108
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(today(), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_3 from commandbutton within w_cm508_sc_oc_ni
integer x = 1646
integer y = 104
integer width = 274
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Date ld_fecini, ld_fecfin
String ls_texto

SetPointer( hourglass!)
ld_fecini = uo_1.of_get_fecha1()
ld_fecfin = uo_1.of_get_fecha2()
ls_texto = 'Del ' + STRING(ld_fecini, 'dd/mm/yyyy') + ' al ' + STRING(ld_fecfin,'dd/mm/yyyy')
//idw_1.object.p_logo = gs_logo
idw_1.object.t_texto.text = ls_texto
idw_1.retrieve( ld_fecini, ld_fecfin )
SetPointer( arrow!)

idw_1.Visible = True

end event

type gb_1 from groupbox within w_cm508_sc_oc_ni
integer x = 27
integer y = 36
integer width = 1381
integer height = 208
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

