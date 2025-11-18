$PBExportHeader$w_pr749_costo_prod_ot.srw
forward
global type w_pr749_costo_prod_ot from w_rpt
end type
type hpb_progreso from hprogressbar within w_pr749_costo_prod_ot
end type
type pb_1 from picturebutton within w_pr749_costo_prod_ot
end type
type st_1 from statictext within w_pr749_costo_prod_ot
end type
type sle_mes1 from singlelineedit within w_pr749_costo_prod_ot
end type
type sle_year1 from singlelineedit within w_pr749_costo_prod_ot
end type
type sle_year2 from singlelineedit within w_pr749_costo_prod_ot
end type
type sle_moneda from singlelineedit within w_pr749_costo_prod_ot
end type
type rb_mensual from radiobutton within w_pr749_costo_prod_ot
end type
type rb_1 from radiobutton within w_pr749_costo_prod_ot
end type
type sle_mes2 from singlelineedit within w_pr749_costo_prod_ot
end type
type st_3 from statictext within w_pr749_costo_prod_ot
end type
type st_2 from statictext within w_pr749_costo_prod_ot
end type
type sle_unidad from singlelineedit within w_pr749_costo_prod_ot
end type
type uo_rango from ou_rango_fechas within w_pr749_costo_prod_ot
end type
type cb_2 from commandbutton within w_pr749_costo_prod_ot
end type
type dw_report from u_dw_rpt within w_pr749_costo_prod_ot
end type
type gb_4 from groupbox within w_pr749_costo_prod_ot
end type
end forward

global type w_pr749_costo_prod_ot from w_rpt
integer width = 3675
integer height = 1992
string title = "[PR749] Costo de Produccion x OT"
string menuname = "m_reporte"
event ue_costear ( )
hpb_progreso hpb_progreso
pb_1 pb_1
st_1 st_1
sle_mes1 sle_mes1
sle_year1 sle_year1
sle_year2 sle_year2
sle_moneda sle_moneda
rb_mensual rb_mensual
rb_1 rb_1
sle_mes2 sle_mes2
st_3 st_3
st_2 st_2
sle_unidad sle_unidad
uo_rango uo_rango
cb_2 cb_2
dw_report dw_report
gb_4 gb_4
end type
global w_pr749_costo_prod_ot w_pr749_costo_prod_ot

event ue_costear();Long		ll_year, ll_mes, ll_row
String	ls_nro_ot, ls_mensaje
decimal	ldc_costo_prod

if not rb_mensual.checked then
	MessageBox('Error', 'El costeo del PPTT / Prod Proceso solo se puede hacer mensualmente', StopSign!)
	return
end if

for ll_row = 1 to dw_report.RowCount()
	ll_year 			= Long(dw_report.object.year 			[ll_row])
	ll_mes 			= Long(dw_report.object.mes 			[ll_row])
	ls_nro_ot 		= dw_report.object.nro_orden 			[ll_row]
	ldc_costo_prod	= Dec(dw_report.object.costo_prod	[ll_row])
	
	//ACtualizo el Vale mov
	update articulo_mov am
	   set am.precio_unit = :ldc_costo_prod
	where am.flag_estado <> '0'
	  and am.nro_Vale in (select distinct
	  									  vm.nro_Vale
									from vale_mov 				vm,
										  articulo_mov 		am,
										  articulo_mov_proy 	amp
								  where vm.nro_Vale 			= am.nro_vale
								    and am.origen_mov_proy	= amp.cod_origen
									 and am.nro_mov_proy		= amp.nro_mov
								    and vm.flag_estado 		<> '0'
									 and am.flag_estado		<> '0'
									 and amp.tipo_doc			= (select doc_ot from logparam where reckey = '1')
									 and amp.nro_doc			= :ls_nro_ot
									 and to_number(to_char(vm.fec_registro, 'yyyy')) 	= :ll_year
									 and to_number(to_char(vm.fec_registro, 'mm')) 		= :ll_mes
								    and vm.tipo_mov in (PKG_COSTOS_OT.of_oper_ing_prod(null), 
							 									PKG_COSTOS_OT.of_oper_reproceso(null), 
							 									PKG_COSTOS_OT.of_oper_reempaque(null), 
                      									PKG_COSTOS_OT.of_oper_reclasif(null)));
	
	if SQLCA.SQLCode <> 0 then
		ls_mensaje = SQLCA.SQlErrText
		ROLLBACK;
		MessageBox('Error', 'Ha  ocurrido un error al actualizar el costo del PPTT. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	commit;
	
	hpb_progreso.Position = ll_row / dw_report.RowCount() * 100
									
next
end event

on w_pr749_costo_prod_ot.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.hpb_progreso=create hpb_progreso
this.pb_1=create pb_1
this.st_1=create st_1
this.sle_mes1=create sle_mes1
this.sle_year1=create sle_year1
this.sle_year2=create sle_year2
this.sle_moneda=create sle_moneda
this.rb_mensual=create rb_mensual
this.rb_1=create rb_1
this.sle_mes2=create sle_mes2
this.st_3=create st_3
this.st_2=create st_2
this.sle_unidad=create sle_unidad
this.uo_rango=create uo_rango
this.cb_2=create cb_2
this.dw_report=create dw_report
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_mes1
this.Control[iCurrent+5]=this.sle_year1
this.Control[iCurrent+6]=this.sle_year2
this.Control[iCurrent+7]=this.sle_moneda
this.Control[iCurrent+8]=this.rb_mensual
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.sle_mes2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.sle_unidad
this.Control[iCurrent+14]=this.uo_rango
this.Control[iCurrent+15]=this.cb_2
this.Control[iCurrent+16]=this.dw_report
this.Control[iCurrent+17]=this.gb_4
end on

on w_pr749_costo_prod_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_progreso)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.sle_mes1)
destroy(this.sle_year1)
destroy(this.sle_year2)
destroy(this.sle_moneda)
destroy(this.rb_mensual)
destroy(this.rb_1)
destroy(this.sle_mes2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_unidad)
destroy(this.uo_rango)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.gb_4)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_open_pre;call super::ue_open_pre;
idw_1 = dw_report
idw_1.SetTransObject(sqlca)

sle_unidad.text = gnvo_app.logistica.is_und_kgr
sle_moneda.text = gnvo_app.is_soles

sle_year1.text = string(Date(f_fecha_actual()), 'yyyy')
sle_mes1.text = "01"

sle_year2.text = string(Date(f_fecha_actual()), 'yyyy')
sle_mes2.text = string(Date(f_fecha_actual()), 'mm')
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_unidad, ls_moneda, ls_titulo
Date		ld_fecha1, ld_fecha2
Integer	li_year1, li_mes1, li_year2, li_mes2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

li_year1 = Integer(sle_year1.text)
li_mes1 	= Integer(sle_mes1.text)
li_year2 = Integer(sle_year2.text)
li_mes2 	= Integer(sle_mes2.text)

if rb_mensual.checked then
	if li_year1 <> li_year2 then
		f_mensaje("Error, el preiodo de inicio y el periodo de fin deben ser del mismo año", "")
		return
	end if
end if


If sle_moneda.text = '' Then
	MessageBox('Error', 'Debe elegir un tipo de moneda', StopSign!)
	sle_moneda.setFocus()
	return
End If 
ls_moneda = sle_moneda.text

If sle_unidad.text = '' Then
	MessageBox('Error', 'Debe elegir una unidad', StopSign!)
	sle_unidad.setFocus()
	return
End If 
ls_unidad = sle_unidad.text

//Papel A-4 Apaisado
dw_report.Object.DataWindow.Print.Paper.Size = 256 
dw_report.Object.DataWindow.Print.CustomPage.Width = 297 
dw_report.Object.DataWindow.Print.CustomPage.Length = 210

dw_report.Object.Datawindow.Print.Orientation = 2
//dw_report.Object.DataWindow.Print.Paper.Size	= 1

dw_report.settransobject( sqlca )

if rb_1.checked then
	dw_report.retrieve(ld_fecha1, ld_fecha2, ls_moneda, ls_unidad )
	if ld_fecha1 = ld_fecha2 then
		ls_titulo = 'COSTOS DE PRODUCCION X OT. DÍA ' + string(ld_fecha1, 'dd/mm/yyyy')
	else
		ls_titulo = 'COSTOS DE PRODUCCION X OT. PERIODO ' + string(ld_fecha1, 'dd/mm/yyyy') + ' - ' + string(ld_fecha2, 'dd/mm/yyyy')
	end if
	dw_report.object.st_comentario.text = ls_titulo
	dw_report.object.st_desde.text 		= string(ld_fecha1, 'dd/mm/yyyy')
	dw_report.object.st_hasta.text 		= string(ld_fecha2, 'dd/mm/yyyy')
else
	dw_report.retrieve(li_year1, li_mes1, li_year2, li_mes2, ls_moneda, ls_unidad )
	dw_report.object.st_desde.text 	= string(li_year1) + '-' + string(li_mes1)
	dw_report.object.st_hasta.text 	= string(li_year2) + '-' + string(li_mes2)
end if

dw_report.object.p_logo.filename = gs_logo
dw_report.object.st_usuario.text = gs_user
dw_report.object.st_empresa.text = gs_empresa




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

type hpb_progreso from hprogressbar within w_pr749_costo_prod_ot
integer x = 1426
integer y = 176
integer width = 379
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type pb_1 from picturebutton within w_pr749_costo_prod_ot
integer x = 2903
integer y = 56
integer width = 462
integer height = 184
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Actualizar Costo PPTT"
boolean originalsize = true
vtextalign vtextalign = multiline!
boolean map3dcolors = true
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_costear()
SetPointer(Arrow!)
end event

type st_1 from statictext within w_pr749_costo_prod_ot
integer x = 1824
integer y = 176
integer width = 242
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Unidad:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mes1 from singlelineedit within w_pr749_costo_prod_ot
event dobleclick pbm_lbuttondblclk
integer x = 805
integer y = 168
integer width = 133
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type sle_year1 from singlelineedit within w_pr749_costo_prod_ot
event dobleclick pbm_lbuttondblclk
integer x = 567
integer y = 168
integer width = 229
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type sle_year2 from singlelineedit within w_pr749_costo_prod_ot
event dobleclick pbm_lbuttondblclk
integer x = 1047
integer y = 168
integer width = 229
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type sle_moneda from singlelineedit within w_pr749_costo_prod_ot
event dobleclick pbm_lbuttondblclk
integer x = 2085
integer y = 72
integer width = 288
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select m.cod_moneda as codigo_moneda, "&
			+"m.descripcion as descripcion_moneda "&
  			+"from moneda m Where m.flag_estado = 1"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type rb_mensual from radiobutton within w_pr749_costo_prod_ot
integer x = 59
integer y = 172
integer width = 503
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Costo Mensual:"
end type

event clicked;sle_year1.enabled = true
sle_mes1.enabled = true

sle_year2.enabled = true
sle_mes2.enabled = true

uo_rango.of_enabled(false)

dw_report.dataobject = 'd_rpt_costos_prod_ot_mes_tbl'
dw_report.SetTransObject(SQLCA)
end event

type rb_1 from radiobutton within w_pr749_costo_prod_ot
integer x = 59
integer y = 76
integer width = 434
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Costo Diario: "
boolean checked = true
end type

event clicked;sle_year1.enabled = false
sle_mes1.enabled = false

sle_year2.enabled = false
sle_mes2.enabled = false

uo_rango.of_enabled(true)

dw_report.dataobject = 'd_rpt_costos_prod_ot_tbl'
dw_report.SetTransObject(SQLCA)
end event

type sle_mes2 from singlelineedit within w_pr749_costo_prod_ot
event dobleclick pbm_lbuttondblclk
integer x = 1285
integer y = 168
integer width = 133
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_pr749_costo_prod_ot
integer x = 1824
integer y = 80
integer width = 242
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Moneda:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr749_costo_prod_ot
integer x = 946
integer y = 168
integer width = 91
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_unidad from singlelineedit within w_pr749_costo_prod_ot
event dobleclick pbm_lbuttondblclk
integer x = 2085
integer y = 168
integer width = 288
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "select u.und as unidad, u.desc_unidad as descripcion_unidad " &
		 + "from unidad u " &
		 + "where flag_estado = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type uo_rango from ou_rango_fechas within w_pr749_costo_prod_ot
event destroy ( )
integer x = 567
integer y = 68
integer taborder = 30
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type cb_2 from commandbutton within w_pr749_costo_prod_ot
integer x = 2432
integer y = 56
integer width = 462
integer height = 184
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_pr749_costo_prod_ot
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer y = 296
integer width = 3598
integer height = 996
string dataobject = "d_rpt_costos_prod_ot_tbl"
end type

event doubleclicked;call super::doubleclicked;str_parametros lstr_param
w_cns_general	lw_cns

choose case lower(dwo.name)
		
	case "costo_mp"
		
		lstr_param.string1 = this.object.nro_orden 			[row]
		lstr_param.string2 = sle_moneda.text
		lstr_param.fecha1  = Date(this.object.fec_proceso 	[row])
		lstr_param.tipo 	 = '1S2S1D'
		lstr_param.dw1 	 = 'd_cns_costo_mp_ot_tbl'
		lstr_param.titulo	 = 'Consumo diario de Materia Prima x OT'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
	
	case "costo_sum"
		
		lstr_param.string1 = this.object.nro_orden 			[row]
		lstr_param.string2 = sle_moneda.text
		lstr_param.fecha1  = Date(this.object.fec_proceso 	[row])
		lstr_param.tipo 	 = '1S2S1D'
		lstr_param.dw1 	 = 'd_cns_costo_sum_ot_tbl'
		lstr_param.titulo	 = 'Consumo diario de SUMINISTROS x OT'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_ins"
		
		lstr_param.string1 = this.object.nro_orden 			[row]
		lstr_param.string2 = sle_moneda.text
		lstr_param.fecha1  = Date(this.object.fec_proceso 	[row])
		lstr_param.tipo 	 = '1S2S1D'
		lstr_param.dw1 	 = 'd_cns_costo_ins_ot_tbl'
		lstr_param.titulo	 = 'Consumo diario de INSUMOS x OT'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_pptt"
		
		lstr_param.string1 = this.object.nro_orden 			[row]
		lstr_param.string2 = sle_moneda.text
		lstr_param.fecha1  = Date(this.object.fec_proceso 	[row])
		lstr_param.tipo 	 = '1S2S1D'
		lstr_param.dw1 	 = 'd_cns_costo_pptt_ot_tbl'
		lstr_param.titulo	 = 'Consumo diario de PPTT / PROD EN PROCESO x OT'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_mat"
		
		lstr_param.string1 = this.object.nro_orden 			[row]
		lstr_param.string2 = sle_moneda.text
		lstr_param.fecha1  = Date(this.object.fec_proceso 	[row])
		lstr_param.tipo 	 = '1S2S1D'
		lstr_param.dw1 	 = 'd_cns_costo_mat_ot_tbl'
		lstr_param.titulo	 = 'Consumo diario de Materiales x OT'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_jor"
		
		lstr_param.string1 = this.object.nro_orden 			[row]
		lstr_param.string2 = sle_moneda.text
		lstr_param.fecha1  = Date(this.object.fec_proceso 	[row])
		lstr_param.tipo 	 = '1S2S1D'
		lstr_param.dw1 	 = 'd_cns_costo_jor_ot_tbl'
		lstr_param.titulo	 = 'Costo Diario de Jornal por OT'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_dst"
		
		lstr_param.string1 = this.object.nro_orden 			[row]
		lstr_param.string2 = sle_moneda.text
		lstr_param.fecha1  = Date(this.object.fec_proceso 	[row])
		lstr_param.tipo 	 = '1S2S1D'
		lstr_param.dw1 	 = 'd_cns_costo_dst_ot_tbl'
		lstr_param.titulo	 = 'Costo Diario de Jornal por OT'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_serv"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_serv_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo x Servicios de Terceros por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
		

end choose
end event

type gb_4 from groupbox within w_pr749_costo_prod_ot
integer width = 3502
integer height = 284
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Parámetros "
end type

