$PBExportHeader$w_pt777_prsp_caja_vs_tesoreria.srw
forward
global type w_pt777_prsp_caja_vs_tesoreria from w_rpt
end type
type st_1 from statictext within w_pt777_prsp_caja_vs_tesoreria
end type
type em_fecha2 from editmask within w_pt777_prsp_caja_vs_tesoreria
end type
type em_fecha1 from editmask within w_pt777_prsp_caja_vs_tesoreria
end type
type em_nro_prsp from singlelineedit within w_pt777_prsp_caja_vs_tesoreria
end type
type pb_reporte from picturebutton within w_pt777_prsp_caja_vs_tesoreria
end type
type rb_opcion1 from radiobutton within w_pt777_prsp_caja_vs_tesoreria
end type
type rb_fecha2 from radiobutton within w_pt777_prsp_caja_vs_tesoreria
end type
type dw_report from u_dw_rpt within w_pt777_prsp_caja_vs_tesoreria
end type
type gb_1 from groupbox within w_pt777_prsp_caja_vs_tesoreria
end type
end forward

global type w_pt777_prsp_caja_vs_tesoreria from w_rpt
integer width = 5207
integer height = 2192
string title = "[PT777] Seguimiento de Presupuesto de Caja vs Tesorería"
string menuname = "m_impresion"
st_1 st_1
em_fecha2 em_fecha2
em_fecha1 em_fecha1
em_nro_prsp em_nro_prsp
pb_reporte pb_reporte
rb_opcion1 rb_opcion1
rb_fecha2 rb_fecha2
dw_report dw_report
gb_1 gb_1
end type
global w_pt777_prsp_caja_vs_tesoreria w_pt777_prsp_caja_vs_tesoreria

forward prototypes
public subroutine wf_genera_cc_sol (string as_tipo, date ad_fecha_inicio, date ad_fecha_final)
public subroutine wf_genera_cc_rsp (string as_tipo, date ad_fecha_inicio, date ad_fecha_final)
end prototypes

public subroutine wf_genera_cc_sol (string as_tipo, date ad_fecha_inicio, date ad_fecha_final);DECLARE PB_usp_ope_orden_trabajo_slc PROCEDURE FOR usp_ope_orden_trabajo_slc
(:as_tipo,:ad_fecha_inicio,:ad_fecha_final);
EXECUTE PB_usp_ope_orden_trabajo_slc;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_usp_ope_orden_trabajo_slc ;
end subroutine

public subroutine wf_genera_cc_rsp (string as_tipo, date ad_fecha_inicio, date ad_fecha_final);DECLARE PB_usp_ope_orden_trabajo_rsp PROCEDURE FOR usp_ope_orden_trabajo_rsp
(:as_tipo,:ad_fecha_inicio,:ad_fecha_final);
EXECUTE PB_usp_ope_orden_trabajo_rsp;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_usp_ope_orden_trabajo_rsp ;
end subroutine

on w_pt777_prsp_caja_vs_tesoreria.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.em_fecha2=create em_fecha2
this.em_fecha1=create em_fecha1
this.em_nro_prsp=create em_nro_prsp
this.pb_reporte=create pb_reporte
this.rb_opcion1=create rb_opcion1
this.rb_fecha2=create rb_fecha2
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_fecha2
this.Control[iCurrent+3]=this.em_fecha1
this.Control[iCurrent+4]=this.em_nro_prsp
this.Control[iCurrent+5]=this.pb_reporte
this.Control[iCurrent+6]=this.rb_opcion1
this.Control[iCurrent+7]=this.rb_fecha2
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
end on

on w_pt777_prsp_caja_vs_tesoreria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_fecha2)
destroy(this.em_fecha1)
destroy(this.em_nro_prsp)
destroy(this.pb_reporte)
destroy(this.rb_opcion1)
destroy(this.rb_fecha2)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.ii_zoom_actual = 80
THIS.Event ue_preview()

em_Fecha1.text = '01/01/' + string(date(gnvo_app.of_fecha_actual( )), 'yyyy')
em_Fecha2.text = string(date(gnvo_app.of_fecha_actual( )), 'dd/mm/yyyy')
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;String ls_flag, ls_nro_prsp
Date   ld_fecha1,ld_fecha2

//rango de fechas

dw_report.Settransobject(sqlca)
ib_preview = FALSE
dw_report.event ue_preview( )

IF rb_opcion1.checked THEN     
	
	ls_flag = '1'
	em_fecha1.getdata( ld_fecha1 )
	em_fecha2.getdata( ld_fecha2 )

ELSE
	ls_flag = '2'
	ls_nro_prsp = em_nro_prsp.text
	
END IF 

dw_report.Retrieve(ls_flag, ld_fecha1, ld_fecha2, ls_nro_prsp)
dw_report.object.datawindow.print.orientation = 1
dw_report.object.datawindow.print.paper.size = 8

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_user.text 	= gs_user
dw_report.Object.t_empresa.text 	= gs_empresa
dw_report.Object.t_ventana.text 	= this.ClassName()
dw_report.object.t_stitulo1.text = 'Desde ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')

end event

type st_1 from statictext within w_pt777_prsp_caja_vs_tesoreria
integer x = 1079
integer y = 56
integer width = 197
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "hasta"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_fecha2 from editmask within w_pt777_prsp_caja_vs_tesoreria
integer x = 1285
integer y = 60
integer width = 398
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
boolean dropdowncalendar = true
end type

type em_fecha1 from editmask within w_pt777_prsp_caja_vs_tesoreria
integer x = 690
integer y = 60
integer width = 398
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_nro_prsp from singlelineedit within w_pt777_prsp_caja_vs_tesoreria
event dobleclick pbm_lbuttondblclk
integer x = 677
integer y = 144
integer width = 434
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select nro_presupuesto as numero_presupuesto, " &
		 + "descripcion as descripcion_presupuesto " &
		 + "from prsp_caja " &
		 + "where flag_estado = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if

end event

type pb_reporte from picturebutton within w_pt777_prsp_caja_vs_tesoreria
integer x = 1966
integer y = 52
integer width = 366
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\bmp\aceptar.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
ib_preview = false
parent.event ue_preview( )
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type rb_opcion1 from radiobutton within w_pt777_prsp_caja_vs_tesoreria
integer x = 37
integer y = 60
integer width = 613
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Presupuestada"
boolean checked = true
end type

event clicked;em_nro_prsp.enabled = false
em_fecha1.enabled = true
em_fecha2.enabled = true
end event

type rb_fecha2 from radiobutton within w_pt777_prsp_caja_vs_tesoreria
integer x = 37
integer y = 144
integer width = 613
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Presupuesto"
end type

event clicked;em_nro_prsp.enabled = true
em_fecha1.enabled = false
em_fecha2.enabled = false
end event

type dw_report from u_dw_rpt within w_pt777_prsp_caja_vs_tesoreria
integer y = 248
integer width = 3465
integer height = 1212
integer taborder = 40
string dataobject = "d_rpt_prsp_pago_tbl"
end type

type gb_1 from groupbox within w_pt777_prsp_caja_vs_tesoreria
integer width = 2350
integer height = 236
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

