$PBExportHeader$w_al752_precios_oc_ni_fap.srw
forward
global type w_al752_precios_oc_ni_fap from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_al752_precios_oc_ni_fap
end type
type cb_3 from commandbutton within w_al752_precios_oc_ni_fap
end type
type st_1 from statictext within w_al752_precios_oc_ni_fap
end type
type sle_diferencia from singlelineedit within w_al752_precios_oc_ni_fap
end type
end forward

global type w_al752_precios_oc_ni_fap from w_report_smpl
integer width = 2930
integer height = 1836
string title = "[AL752] Diferencia entre precio de OC y FAP"
string menuname = "m_impresion"
uo_fecha uo_fecha
cb_3 cb_3
st_1 st_1
sle_diferencia sle_diferencia
end type
global w_al752_precios_oc_ni_fap w_al752_precios_oc_ni_fap

type variables
Integer ii_opcion
end variables

on w_al752_precios_oc_ni_fap.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_3=create cb_3
this.st_1=create st_1
this.sle_diferencia=create sle_diferencia
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_diferencia
end on

on w_al752_precios_oc_ni_fap.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.sle_diferencia)
end on

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al752_precios_oc_ni_fap
integer x = 0
integer y = 128
integer width = 1906
integer height = 1424
string dataobject = "d_rpt_precio_oc_ni_fap_tbl"
end type

type uo_fecha from u_ingreso_rango_fechas within w_al752_precios_oc_ni_fap
integer y = 12
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final
end event

type cb_3 from commandbutton within w_al752_precios_oc_ni_fap
integer x = 2377
integer y = 4
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Date 		ld_desde, ld_hasta
decimal	ldc_diferencia

ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()

ldc_diferencia = dec(sle_diferencia.text)

idw_1 = dw_report
ib_preview = false
parent.Event ue_preview()
idw_1.Object.DataWindow.Print.Orientation = 1
idw_1.Visible = True

idw_1.SetTransObject(Sqlca)
dw_report.object.t_fechas.text   = 'Del: ' + string( ld_desde,'dd/mm/yyyy') + ' Al: ' + string( ld_hasta,'dd/mm/yyyy')
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text   	= gs_user
dw_report.object.t_ventana.text 	= parent.classname( )


idw_1.retrieve(ld_desde,ld_hasta, ldc_diferencia)


end event

type st_1 from statictext within w_al752_precios_oc_ni_fap
integer x = 1339
integer y = 24
integer width = 503
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Diferencia Mínima:"
boolean focusrectangle = false
end type

type sle_diferencia from singlelineedit within w_al752_precios_oc_ni_fap
integer x = 1879
integer y = 24
integer width = 343
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0.10"
borderstyle borderstyle = stylelowered!
end type

