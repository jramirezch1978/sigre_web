$PBExportHeader$w_cm705_atencion_oc.srw
forward
global type w_cm705_atencion_oc from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm705_atencion_oc
end type
type cb_3 from commandbutton within w_cm705_atencion_oc
end type
end forward

global type w_cm705_atencion_oc from w_report_smpl
integer width = 3177
integer height = 1404
string title = "Atencion x Orden de Compra (CM705)"
string menuname = "m_impresion"
long backcolor = 134217732
uo_1 uo_1
cb_3 cb_3
end type
global w_cm705_atencion_oc w_cm705_atencion_oc

type variables

end variables

on w_cm705_atencion_oc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
end on

on w_cm705_atencion_oc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

idw_1.Retrieve(ld_desde, ld_hasta)

idw_1.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(ld_desde, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(ld_hasta, "DD/MM/YYYY")		
idw_1.object.t_user.text 	  = gs_user
idw_1.Object.p_logo.filename = gs_logo

idw_1.Object.DataWindow.Print.Orientation = 1
end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

type dw_report from w_report_smpl`dw_report within w_cm705_atencion_oc
integer x = 9
integer y = 152
integer width = 2053
integer height = 1056
string dataobject = "d_rpt_tabla_atencion_oc"
end type

type uo_1 from u_ingreso_rango_fechas within w_cm705_atencion_oc
integer x = 14
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_cm705_atencion_oc
integer x = 2651
integer y = 8
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.Event ue_retrieve()
end event

