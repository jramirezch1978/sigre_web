$PBExportHeader$w_ope767_resumen_actividades.srw
forward
global type w_ope767_resumen_actividades from w_report_smpl
end type
type cb_1 from commandbutton within w_ope767_resumen_actividades
end type
type uo_1 from u_ingreso_rango_fechas within w_ope767_resumen_actividades
end type
type gb_1 from groupbox within w_ope767_resumen_actividades
end type
type dw_1 from datawindow within w_ope767_resumen_actividades
end type
type cb_2 from commandbutton within w_ope767_resumen_actividades
end type
end forward

global type w_ope767_resumen_actividades from w_report_smpl
integer width = 3214
integer height = 2064
string title = "(OPE767) Resumen de Actividades "
string menuname = "m_rpt_smpl"
cb_1 cb_1
uo_1 uo_1
gb_1 gb_1
dw_1 dw_1
cb_2 cb_2
end type
global w_ope767_resumen_actividades w_ope767_resumen_actividades

on w_ope767_resumen_actividades.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.gb_1=create gb_1
this.dw_1=create dw_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cb_2
end on

on w_ope767_resumen_actividades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.cb_2)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True

ib_preview = false
THIS.Event ue_preview()

end event

type dw_report from w_report_smpl`dw_report within w_ope767_resumen_actividades
integer x = 27
integer y = 456
integer width = 3109
integer height = 1284
string dataobject = "d_rpt_resumen_x_actividad_tbl"
end type

type cb_1 from commandbutton within w_ope767_resumen_actividades
integer x = 2743
integer y = 96
integer width = 384
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicial,ld_fecha_final

Decimal {4} ldc_tasa_cambio


ld_fecha_inicial = uo_1.of_get_fecha1()
ld_fecha_final   = uo_1.of_get_fecha2()


//ejecuta procedimeinto de asigancion de labores
DECLARE PB_usp_ope_destajo_efect_x_fechas PROCEDURE FOR usp_ope_destajo_efect_x_fechas
(:ld_fecha_inicial,:ld_fecha_final);
EXECUTE pb_usp_ope_destajo_efect_x_fechas ;
	
IF SQLCA.SQLCode = -1 THEN 
   MessageBox("SQL error", SQLCA.SQLErrText)

END IF



 

//buscar tipo de cambio

dw_report.retrieve(String(ld_fecha_inicial,'dd/mm/yyyy'),String(ld_fecha_final,'dd/mm/yyyy'))
//dw_1.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa

end event

type uo_1 from u_ingreso_rango_fechas within w_ope767_resumen_actividades
event destroy ( )
integer x = 55
integer y = 144
integer taborder = 60
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type gb_1 from groupbox within w_ope767_resumen_actividades
integer x = 27
integer y = 72
integer width = 1426
integer height = 240
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

type dw_1 from datawindow within w_ope767_resumen_actividades
boolean visible = false
integer x = 521
integer y = 480
integer width = 2281
integer height = 1580
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "Grafico Participacion por Actividad"
string dataobject = "d_grp_resumen_actividades_grp"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

type cb_2 from commandbutton within w_ope767_resumen_actividades
boolean visible = false
integer x = 2743
integer y = 240
integer width = 384
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grafico"
end type

event clicked;dw_1.Visible = true
end event

