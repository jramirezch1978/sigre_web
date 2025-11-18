$PBExportHeader$w_cm701_plan_anual_compras.srw
forward
global type w_cm701_plan_anual_compras from w_rpt_list
end type
type em_anio from editmask within w_cm701_plan_anual_compras
end type
type st_1 from statictext within w_cm701_plan_anual_compras
end type
end forward

global type w_cm701_plan_anual_compras from w_rpt_list
integer width = 3712
integer height = 2000
string title = "PLAN ANUAL DE COMPRAS (CM701)"
string menuname = "m_impresion"
em_anio em_anio
st_1 st_1
end type
global w_cm701_plan_anual_compras w_cm701_plan_anual_compras

type variables
String is_oper
end variables

on w_cm701_plan_anual_compras.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_anio=create em_anio
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_anio
this.Control[iCurrent+2]=this.st_1
end on

on w_cm701_plan_anual_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_anio)
destroy(this.st_1)
end on

event ue_open_pre();call super::ue_open_pre;dw_1.SetTransObject(sqlca)

// Busca tipo de movimiento "Consumo interno"
Select oper_cons_interno into :is_oper from logparam where reckey = '1';


end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

type dw_report from w_rpt_list`dw_report within w_cm701_plan_anual_compras
boolean visible = false
integer x = 32
integer y = 148
integer width = 3040
integer height = 1668
string dataobject = "d_rpt_plan_anual_compras"
end type

event dw_report::doubleclicked;call super::doubleclicked;Date ld_fecha
Long ll_orden_serv
String ls_proveedor

Choose case this.dataobject
	Case 'd_rpt_servicios_proveedor'

	IF row = 0 THEN RETURN

		ld_fecha = date(this.object.tmp_rpt_servicios_proveedor_fecha[row])
		ls_proveedor = GetItemString(row, 'tmp_rpt_servicios_proveedor_proveedor')
		ll_orden_serv = GetItemNumber(row, 'tmp_rpt_servicios_proveedor_orden_servic')
		
		DECLARE PB_SP_RPT_SERV_PROV_DETALLE PROCEDURE FOR LOGI.SP_RPT_SERV_PROV_DETALLE  
         (:ld_fecha, :ls_proveedor, :ll_orden_serv ) ;
		EXECUTE PB_SP_RPT_SERV_PROV_DETALLE;
		
		If sqlca.sqlcode = -1 then
			messagebox("Error al ejecutar Store Procedure", sqlca.sqlerrtext)
		Else		
			opensheet (w_rpt_servicio_proveedor_det,  parent, 0, original!)
		End IF
End Choose
end event

type dw_1 from w_rpt_list`dw_1 within w_cm701_plan_anual_compras
integer x = 27
integer y = 180
integer width = 1609
integer height = 1592
integer taborder = 50
string dataobject = "d_rpt_plan_anual_centro_costos_401"
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2



end event

type pb_1 from w_rpt_list`pb_1 within w_cm701_plan_anual_compras
integer x = 1710
integer y = 608
integer taborder = 60
end type

event pb_1::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	cb_report.enabled = true
end if
end event

type pb_2 from w_rpt_list`pb_2 within w_cm701_plan_anual_compras
integer x = 1705
integer y = 1008
integer taborder = 80
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;if dw_2.rowcount() = 0 then
	cb_report.enabled = false
end if
end event

type dw_2 from w_rpt_list`dw_2 within w_cm701_plan_anual_compras
integer x = 1925
integer y = 188
integer width = 1609
integer height = 1592
integer taborder = 70
string dataobject = "d_rpt_plan_anual_centro_costos_401"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_report from w_rpt_list`cb_report within w_cm701_plan_anual_compras
integer x = 2912
integer y = 36
integer width = 581
integer height = 92
integer taborder = 30
integer weight = 700
boolean enabled = false
string text = "&Generar Reporte"
end type

event cb_report::clicked;call super::clicked;String ls_anio, ls_cod
Any	 la_arg[]
Long 	 ll_row

SetPointer( Hourglass!)
Parent.SetMicroHelp('Espere, Procesando')
if UPPER(cb_report.text) = 'OTRA CONSULTA' then
	cb_report.text = "Generar"	
	cb_report.enabled = false
	dw_report.visible = false
	dw_1.visible = true
	dw_2.visible = true
else	
	// llena tabla temporal con datos seleccionados
	delete from tt_alm_seleccion;
	FOR ll_row = 1 to dw_2.rowcount()		
		ls_cod = dw_2.object.cencos[ll_row]
		Insert into tt_alm_seleccion( cencos) values ( :ls_cod);		
		If sqlca.sqlcode = -1 then
			messagebox("Error al insertar registro",sqlca.sqlerrtext)
		END IF
	NEXT	

	ls_anio = em_anio.text	
//	DECLARE PB_USP_CMP_PLAN_ANUAL_COMPRAS PROCEDURE FOR USP_CMP_PLAN_ANUAL_COMPRAS(:is_oper, :ls_anio);
//	EXECUTE PB_USP_CMP_PLAN_ANUAL_COMPRAS;
//	IF SQLCA.SQLCODE = -1 THEN
//		Messagebox( "Fallo Al ejecutar Store Procedure", sqlca.sqlerrtext)
//		RETURN
//	END IF		
	
	dw_report.SetTransObject(sqlca)			

	idw_1.retrieve(ls_anio)
	parent.event ue_preview()


	dw_report.Object.p_logo.filename = gs_logo
	dw_report.visible = true
	dw_1.visible = false
	dw_2.visible = false
	cb_report.text = 'Otra Consulta'		
	dw_1.reset()
	dw_2.reset()
	em_anio.text = ''
//	dw_1.retrieve(ld_desde, ld_hasta)
	
end if
Parent.SetMicroHelp('')
end event

type em_anio from editmask within w_cm701_plan_anual_compras
integer x = 320
integer y = 48
integer width = 357
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

event modified;SetPointer( Hourglass!)
dw_1.retrieve(is_oper, em_anio.text)
end event

type st_1 from statictext within w_cm701_plan_anual_compras
integer x = 96
integer y = 52
integer width = 210
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

