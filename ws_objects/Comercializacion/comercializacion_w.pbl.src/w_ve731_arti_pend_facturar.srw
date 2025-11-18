$PBExportHeader$w_ve731_arti_pend_facturar.srw
forward
global type w_ve731_arti_pend_facturar from w_report_smpl
end type
type cb_1 from commandbutton within w_ve731_arti_pend_facturar
end type
type uo_1 from u_ingreso_rango_fechas within w_ve731_arti_pend_facturar
end type
type gb_1 from groupbox within w_ve731_arti_pend_facturar
end type
end forward

global type w_ve731_arti_pend_facturar from w_report_smpl
integer width = 2537
integer height = 1552
string title = "(VE731) Articulo Pendiente a Facturar"
string menuname = "m_reporte"
long backcolor = 12632256
cb_1 cb_1
uo_1 uo_1
gb_1 gb_1
end type
global w_ve731_arti_pend_facturar w_ve731_arti_pend_facturar

on w_ve731_arti_pend_facturar.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_ve731_arti_pend_facturar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;date ad_inicio, ad_fin

ad_inicio = uo_1.of_get_fecha1()
ad_fin    = uo_1.of_get_fecha2()

dw_report.settransobject(sqlca)
dw_report.retrieve(ad_inicio, ad_fin)


dw_report.Object.desde_t.text = string(ad_inicio)
dw_report.Object.hasta_t.text = string(ad_fin)
dw_report.Object.usuario_t.text = gs_user
dw_report.Object.empresa_t.text = gs_empresa
dw_report.object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_ve731_arti_pend_facturar
integer x = 37
integer y = 220
integer width = 2450
integer height = 1120
string dataobject = "d_rpt_art_pend_fac_tbl"
end type

type cb_1 from commandbutton within w_ve731_arti_pend_facturar
integer x = 1499
integer y = 72
integer width = 311
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type uo_1 from u_ingreso_rango_fechas within w_ve731_arti_pend_facturar
integer x = 110
integer y = 76
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(Date('01/01/2001'), date(gd_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/2002')) // rango inicial
of_set_rango_fin(date(gd_fecha)) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type gb_1 from groupbox within w_ve731_arti_pend_facturar
integer x = 37
integer width = 1426
integer height = 204
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Rango de Fechas"
end type

