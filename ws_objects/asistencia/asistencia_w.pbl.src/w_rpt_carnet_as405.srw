$PBExportHeader$w_rpt_carnet_as405.srw
forward
global type w_rpt_carnet_as405 from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_rpt_carnet_as405
end type
type cb_1 from commandbutton within w_rpt_carnet_as405
end type
type gb_3 from groupbox within w_rpt_carnet_as405
end type
type st_1 from statictext within w_rpt_carnet_as405
end type
end forward

global type w_rpt_carnet_as405 from w_report_smpl
integer width = 3461
integer height = 1644
string title = "Marcaciones con Carnet Inactivos (AS405)"
string menuname = "m_reporte"
long backcolor = 79741120
uo_1 uo_1
cb_1 cb_1
gb_3 gb_3
st_1 st_1
end type
global w_rpt_carnet_as405 w_rpt_carnet_as405

on w_rpt_carnet_as405.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_1=create cb_1
this.gb_3=create gb_3
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.st_1
end on

on w_rpt_carnet_as405.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.gb_3)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fec_desde
date ld_fec_hasta
ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

DECLARE pb_usp_rpt_carnet PROCEDURE FOR USP_RPT_CARNET
        (:ld_fec_desde, :ld_fec_hasta ) ;
Execute pb_usp_rpt_carnet ;
dw_report.retrieve(ld_fec_desde,ld_fec_hasta)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rpt_carnet_as405
integer x = 9
integer y = 416
integer width = 3410
integer height = 1044
integer taborder = 30
string dataobject = "d_rpt_carnet_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_rpt_carnet_as405
integer x = 1024
integer y = 232
integer height = 96
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;string ls_inicio, ls_fec 
date ld_fec
uo_1.of_set_label('Desde','Hasta')

// Obtiene primer día del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 uo_1.of_set_fecha(date(ls_inicio),today())
 uo_1.of_set_rango_inicio(date('01/01/1900'))   // rango inicial
 uo_1.of_set_rango_fin(date('31/12/9999'))      // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_rpt_carnet_as405
integer x = 2432
integer y = 228
integer width = 274
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;w_rpt_carnet_as405.Event ue_retrieve()
end event

type gb_3 from groupbox within w_rpt_carnet_as405
integer x = 951
integer y = 156
integer width = 1422
integer height = 204
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Ingrese Rango de Fechas "
borderstyle borderstyle = styleraised!
end type

type st_1 from statictext within w_rpt_carnet_as405
integer x = 233
integer y = 36
integer width = 3182
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "MARCACIONES CON NUMERO DE CARNET NO VALIDOS"
alignment alignment = center!
boolean focusrectangle = false
end type

