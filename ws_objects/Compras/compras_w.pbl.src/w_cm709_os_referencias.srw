$PBExportHeader$w_cm709_os_referencias.srw
forward
global type w_cm709_os_referencias from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm709_os_referencias
end type
type cb_3 from commandbutton within w_cm709_os_referencias
end type
end forward

global type w_cm709_os_referencias from w_report_smpl
integer width = 3177
integer height = 1548
string title = "Orden de Servicos y Referencias (CM709)"
string menuname = "m_impresion"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
end type
global w_cm709_os_referencias w_cm709_os_referencias

type variables

end variables

on w_cm709_os_referencias.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
end on

on w_cm709_os_referencias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

//this.event ue_preview()
idw_1.Retrieve(ld_desde, ld_hasta)
//idw_1.Object.p_logo.filename = gs_logo
end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

type dw_report from w_report_smpl`dw_report within w_cm709_os_referencias
integer x = 9
integer y = 152
integer width = 2039
integer height = 1148
string dataobject = "d_rpt_os_factura_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_origen, ls_nro_orden,ls_proveedor,ls_tipo_doc, &
       ls_nro_doc, ls_name
str_parametros	lstr_rep

ls_name = dwo.name

IF row=0 then return

IF ls_name = 'nro_os' then
	//Datos de orden de servicio
	ls_origen = dw_report.GetItemString(row, 'cod_origen')
	ls_nro_orden = dw_report.GetItemString(row, 'nro_os')
	lstr_rep.string1 = ls_origen
	lstr_rep.string2 = ls_nro_orden
	OpenSheetWithParm(w_cm709_os_referencias_ord_serv, lstr_rep, parent, 2, original!)
END IF

IF ls_name = 'cntas_pagar_nro_doc' then
	//Datos de cuenta por pagar
	ls_proveedor= dw_report.GetItemString(row, 'proveedor')
	ls_tipo_doc= dw_report.GetItemString(row, 'cntas_pagar_tipo_doc')
	ls_nro_doc= dw_report.GetItemString(row, 'cntas_pagar_nro_doc')
	lstr_rep.string1 = ls_proveedor
	lstr_rep.string2 = ls_tipo_doc
	lstr_rep.string3 = ls_nro_doc
	OpenSheetWithParm(w_cm709_os_referencias_cnta_pagar, lstr_rep, parent, 2, original!)
END IF

end event

type uo_1 from u_ingreso_rango_fechas within w_cm709_os_referencias
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

type cb_3 from commandbutton within w_cm709_os_referencias
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
string text = "Generar"
end type

event clicked;parent.Event ue_retrieve()
end event

