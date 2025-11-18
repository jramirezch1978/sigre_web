$PBExportHeader$w_cm508_proveedores_calificados.srw
forward
global type w_cm508_proveedores_calificados from w_rpt
end type
type dw_report from u_dw_rpt within w_cm508_proveedores_calificados
end type
type cb_1 from commandbutton within w_cm508_proveedores_calificados
end type
end forward

global type w_cm508_proveedores_calificados from w_rpt
integer x = 283
integer y = 248
integer width = 3150
integer height = 1384
string title = "Proveedores Calificados (CM508)"
string menuname = "m_impresion"
long backcolor = 79741120
dw_report dw_report
cb_1 cb_1
end type
global w_cm508_proveedores_calificados w_cm508_proveedores_calificados

type variables
String is_origen, is_nro_prog
end variables

on w_cm508_proveedores_calificados.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.cb_1
end on

on w_cm508_proveedores_calificados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;//uo_1.of_set_dw ( 'd_sel_prog_compras' )

idw_1 = dw_report
idw_1.object.t_user.text = gs_user
//idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
//This.Event ue_retrieve()
//this.toolbar.Visible = true
 ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;

idw_1.Retrieve()
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type dw_report from u_dw_rpt within w_cm508_proveedores_calificados
integer x = 14
integer y = 204
integer width = 2999
integer height = 768
boolean bringtotop = true
string dataobject = "d_rpt_proveedor_articulo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_cm508_proveedores_calificados
integer x = 2555
integer y = 36
integer width = 366
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
boolean default = true
end type

event clicked;

//DECLARE PB_CMP_RPT_COMPRAS_SUGERIDAS PROCEDURE FOR USP_CMP_COMPRAS_SUGERIDAS_DET( :ld_fecha, :gs_origen);
//EXECUTE PB_CMP_RPT_COMPRAS_SUGERIDAS;
//IF SQLCA.SQLCODE = -1 THEN
//	Messagebox( "Error", "Al ejecutar Store Procedure")
//	Return
//END IF
Parent.event ue_retrieve()
//dw_report.object.t_fecha.text = STRING(ld_fecha, "DD/MM/YYYY")
end event

