$PBExportHeader$w_cm769_doc_compras.srw
$PBExportComments$Reporte de Servicios por Centro de Costos
forward
global type w_cm769_doc_compras from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm769_doc_compras
end type
type cb_3 from commandbutton within w_cm769_doc_compras
end type
type rb_ocd from radiobutton within w_cm769_doc_compras
end type
type rb_oc from radiobutton within w_cm769_doc_compras
end type
type rb_osd from radiobutton within w_cm769_doc_compras
end type
type rb_os from radiobutton within w_cm769_doc_compras
end type
type gb_1 from groupbox within w_cm769_doc_compras
end type
end forward

global type w_cm769_doc_compras from w_report_smpl
integer width = 3177
integer height = 1420
string title = "Documentos Compras [CM769]"
string menuname = "m_impresion"
uo_1 uo_1
cb_3 cb_3
rb_ocd rb_ocd
rb_oc rb_oc
rb_osd rb_osd
rb_os rb_os
gb_1 gb_1
end type
global w_cm769_doc_compras w_cm769_doc_compras

type variables

end variables

on w_cm769_doc_compras.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
this.rb_ocd=create rb_ocd
this.rb_oc=create rb_oc
this.rb_osd=create rb_osd
this.rb_os=create rb_os
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.rb_ocd
this.Control[iCurrent+4]=this.rb_oc
this.Control[iCurrent+5]=this.rb_osd
this.Control[iCurrent+6]=this.rb_os
this.Control[iCurrent+7]=this.gb_1
end on

on w_cm769_doc_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.rb_ocd)
destroy(this.rb_oc)
destroy(this.rb_osd)
destroy(this.rb_os)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_tipo, ls_grupo
Date ld_desde, ld_hasta
Long ll_count

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

//Seleccion del Reporte
If rb_oc.Checked then
	dw_report.DataObject = 'd_rpt_oc'
elseif rb_ocd.Checked then
	dw_report.DataObject = 'd_rpt_oc_det'
elseif rb_os.Checked then
	dw_report.DataObject = 'd_rpt_os'
elseif rb_osd.Checked then
	dw_report.DataObject = 'd_rpt_os_det'
end if

dw_report.SetTransObject(sqlca)
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.Text = Upper(gs_user)
dw_report.object.t_empresa.Text = gs_empresa
dw_report.object.t_objeto.Text = 'w_cm769_doc_compras'
dw_report.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(ld_desde, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(ld_hasta, "DD/MM/YYYY")		

dw_report.Retrieve(ld_desde, ld_hasta)

ib_preview = true
this.event ue_preview()
end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

event ue_filter;call super::ue_filter;idw_1.GroupCalc()
end event

event ue_sort;call super::ue_sort;idw_1.GroupCalc()
end event

type dw_report from w_report_smpl`dw_report within w_cm769_doc_compras
integer x = 27
integer y = 368
integer width = 2505
integer height = 840
string dataobject = "d_rpt_oc_det"
end type

type uo_1 from u_ingreso_rango_fechas within w_cm769_doc_compras
integer x = 494
integer y = 40
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

type cb_3 from commandbutton within w_cm769_doc_compras
integer x = 503
integer y = 144
integer width = 329
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.Event ue_retrieve()
end event

type rb_ocd from radiobutton within w_cm769_doc_compras
integer x = 46
integer y = 68
integer width = 375
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle OC"
boolean checked = true
end type

type rb_oc from radiobutton within w_cm769_doc_compras
integer x = 46
integer y = 136
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen OC"
end type

type rb_osd from radiobutton within w_cm769_doc_compras
integer x = 46
integer y = 204
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle OS"
end type

type rb_os from radiobutton within w_cm769_doc_compras
integer x = 46
integer y = 272
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen OS"
end type

type gb_1 from groupbox within w_cm769_doc_compras
integer y = 12
integer width = 485
integer height = 340
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

