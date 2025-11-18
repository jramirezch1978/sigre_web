$PBExportHeader$w_ope714_operaciones_x_facturar_det.srw
forward
global type w_ope714_operaciones_x_facturar_det from w_rpt
end type
type dw_report from u_dw_rpt within w_ope714_operaciones_x_facturar_det
end type
end forward

global type w_ope714_operaciones_x_facturar_det from w_rpt
integer width = 2112
integer height = 1264
string title = "Detalle Operaciones pendientes a facturar"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
dw_report dw_report
end type
global w_ope714_operaciones_x_facturar_det w_ope714_operaciones_x_facturar_det

on w_ope714_operaciones_x_facturar_det.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_ope714_operaciones_x_facturar_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = True
THIS.Event ue_preview()


end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve;call super::ue_retrieve;//String ls_ot
//Date ld_fec_inicio, ld_fec_final
//
//ls_ot = sle_ot.text
//
//if Isnull(ls_ot) or Trim(ls_ot) = '' then
//	Messagebox('Aviso','Debe Seleccionar una Administración de Orden de Trabajo')
//	Return
//end if
//
//ld_fec_inicio = uo_1.of_get_fecha1()
//ld_fec_final = uo_1.of_get_fecha2()  
//
//idw_1.Retrieve(ls_ot, ld_fec_inicio, ld_fec_final)
//idw_1.Object.p_logo.filename = gs_logo
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_filter();call super::ue_filter;idw_1.GroupCalc()
end event

type dw_report from u_dw_rpt within w_ope714_operaciones_x_facturar_det
integer width = 2075
integer height = 1084
string dataobject = "d_operac_a_facturar_det"
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_zoom_actual = 100
end type

event doubleclicked;call super::doubleclicked;String ls_nro_orden, ls_ot_adm, ls_msj, ls_nro_parte
Long ll_operacion, ll_count, ll_item
str_parametros sl_param

if row = 0 then return

Choose Case dwo.name 
	Case 'nro_orden','nro_operacion'	
		ls_nro_orden = this.object.nro_orden[row]
		ll_operacion = this.object.nro_operacion[row]
		ls_ot_adm    = this.object.ot_adm[row]
		
		Select count(*)
		into :ll_count
		from ot_adm_usuario
		where cod_usr = :gs_user and ot_adm = :ls_ot_adm;
	
		IF sqlca.sqlcode = -1 Then
			ls_msj = sqlca.sqlerrtext
			MessageBox( 'Error', ls_msj, StopSign! )
			return
		End If	
	
		If ll_count <= 0 then
			MessageBox("Error","No es un usuario valido para la OT Adm "+ls_ot_adm)
			Return
		end if
		sl_param.opcion = 1
		sl_param.string1 = ls_nro_orden
		sl_param.long1 = ll_operacion
		OpenSheetWithParm (w_ope302_orden_trabajo,sl_param, Parent, 0, Layered!)
	Case "nro_parte", "nro_item"
		ls_nro_parte = this.object.nro_parte[row]
		ll_item = this.object.nro_item[row]
			
		sl_param.opcion = 1
		sl_param.string1 = ls_nro_parte
		sl_param.long1 = ll_item
		OpenSheetWithParm (w_ope305_parte_ot,sl_param, Parent, 0, Layered!)

End Choose

end event

