$PBExportHeader$w_cn749_rpt_tipo_cambio.srw
forward
global type w_cn749_rpt_tipo_cambio from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_cn749_rpt_tipo_cambio
end type
type cb_aceptar from commandbutton within w_cn749_rpt_tipo_cambio
end type
end forward

global type w_cn749_rpt_tipo_cambio from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN749] Tipo de Cambio"
string menuname = "m_abc_report_smpl"
uo_fechas uo_fechas
cb_aceptar cb_aceptar
end type
global w_cn749_rpt_tipo_cambio w_cn749_rpt_tipo_cambio

on w_cn749_rpt_tipo_cambio.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.uo_fechas=create uo_fechas
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_aceptar
end on

on w_cn749_rpt_tipo_cambio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_aceptar)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

dw_report.retrieve(ld_fecha1, ld_fecha2)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn749_rpt_tipo_cambio
integer x = 0
integer y = 124
integer width = 3291
integer height = 1000
integer taborder = 50
string dataobject = "d_rpt_tipo_cambio_tbl"
end type

type uo_fechas from u_ingreso_rango_fechas within w_cn749_rpt_tipo_cambio
integer y = 16
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_aceptar from commandbutton within w_cn749_rpt_tipo_cambio
integer x = 1321
integer y = 12
integer width = 402
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve( )
end event

