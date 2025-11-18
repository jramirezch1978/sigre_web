$PBExportHeader$w_fi716_rpt_cri.srw
forward
global type w_fi716_rpt_cri from w_rpt
end type
type cbx_1 from checkbox within w_fi716_rpt_cri
end type
type dw_arg from datawindow within w_fi716_rpt_cri
end type
type dw_report from u_dw_rpt within w_fi716_rpt_cri
end type
type cb_1 from commandbutton within w_fi716_rpt_cri
end type
type gb_1 from groupbox within w_fi716_rpt_cri
end type
end forward

global type w_fi716_rpt_cri from w_rpt
integer width = 3589
integer height = 1396
string title = "Reporte de Comprobante de Retencion (FI716)"
string menuname = "m_reporte"
cbx_1 cbx_1
dw_arg dw_arg
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
end type
global w_fi716_rpt_cri w_fi716_rpt_cri

on w_fi716_rpt_cri.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_1=create cbx_1
this.dw_arg=create dw_arg
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.dw_arg
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_fi716_rpt_cri.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.dw_arg)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()


// ii_help = 101           // help topic


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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type cbx_1 from checkbox within w_fi716_rpt_cri
integer x = 2473
integer y = 164
integer width = 462
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
string text = "Mostrar Fecha"
boolean checked = true
end type

event clicked;if cbx_1.checked then
	dw_report.object.t_fecha.visible = '1'
	dw_report.object.t_date.visible = '1'
else
	dw_report.object.t_fecha.visible = '0'
	dw_report.object.t_date.visible = '0'
end if
end event

type dw_arg from datawindow within w_fi716_rpt_cri
integer x = 27
integer y = 60
integer width = 777
integer height = 192
integer taborder = 10
string title = "none"
string dataobject = "d_ext_fechas_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;DATETIME ld_today
InsertRow(0)
SELECT sysdate into :ld_today FROM dual ;
this.object.ad_fecha_inicio[1] = ld_today
this.object.ad_fecha_final[1] = ld_today
end event

event doubleclicked;Datawindow		 ldw	
str_seleccionar lstr_seleccionar



CHOOSE CASE dwo.name
		 CASE 'ad_fecha_inicio'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)		
		 CASE 'ad_fecha_final'				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)					
							
END CHOOSE

end event

event itemchanged;Accepttext()
end event

event itemerror;Return 1
end event

type dw_report from u_dw_rpt within w_fi716_rpt_cri
integer y = 276
integer width = 3511
integer height = 800
integer taborder = 20
string dataobject = "d_rpt_listado_cri_tbl"
end type

type cb_1 from commandbutton within w_fi716_rpt_cri
integer x = 2473
integer y = 48
integer width = 471
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Date 		ld_fecha_inicio,ld_fecha_final
String	ls_mensaje

dw_arg.Accepttext()

ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]


DECLARE USP_FIN_RPT_CRI PROCEDURE FOR 
	USP_FIN_RPT_CRI  (:ld_fecha_inicio,:ld_fecha_final);
EXECUTE USP_FIN_RPT_CRI ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al generar reporte', ls_mensaje)
	Return
END IF

dw_report.Retrieve(gs_empresa,gs_user,ld_fecha_inicio,ld_fecha_final)
dw_report.Object.p_logo.filename = gs_logo

COMMIT;
CLOSE USP_FIN_RPT_CRI;





end event

type gb_1 from groupbox within w_fi716_rpt_cri
integer width = 869
integer height = 260
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

