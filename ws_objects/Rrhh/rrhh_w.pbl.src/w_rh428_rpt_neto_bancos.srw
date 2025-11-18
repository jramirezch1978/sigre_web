$PBExportHeader$w_rh428_rpt_neto_bancos.srw
forward
global type w_rh428_rpt_neto_bancos from w_report_smpl
end type
type cb_3 from commandbutton within w_rh428_rpt_neto_bancos
end type
type cb_2 from commandbutton within w_rh428_rpt_neto_bancos
end type
type cb_1 from commandbutton within w_rh428_rpt_neto_bancos
end type
type em_fecha from editmask within w_rh428_rpt_neto_bancos
end type
type st_1 from statictext within w_rh428_rpt_neto_bancos
end type
type sle_origen from singlelineedit within w_rh428_rpt_neto_bancos
end type
type sle_desc_origen from singlelineedit within w_rh428_rpt_neto_bancos
end type
type sle_tipo from singlelineedit within w_rh428_rpt_neto_bancos
end type
type sle_desc_tipo from singlelineedit within w_rh428_rpt_neto_bancos
end type
type rb_boletas from radiobutton within w_rh428_rpt_neto_bancos
end type
type rb_grati from radiobutton within w_rh428_rpt_neto_bancos
end type
type rb_cts from radiobutton within w_rh428_rpt_neto_bancos
end type
type st_2 from statictext within w_rh428_rpt_neto_bancos
end type
type st_3 from statictext within w_rh428_rpt_neto_bancos
end type
type rb_quincena from radiobutton within w_rh428_rpt_neto_bancos
end type
type sle_year from singlelineedit within w_rh428_rpt_neto_bancos
end type
type sle_mes from singlelineedit within w_rh428_rpt_neto_bancos
end type
type st_4 from statictext within w_rh428_rpt_neto_bancos
end type
type rb_detalle from radiobutton within w_rh428_rpt_neto_bancos
end type
type rb_resumen from radiobutton within w_rh428_rpt_neto_bancos
end type
type sle_cencos from singlelineedit within w_rh428_rpt_neto_bancos
end type
type cb_cencos from commandbutton within w_rh428_rpt_neto_bancos
end type
type sle_desc_cencos from singlelineedit within w_rh428_rpt_neto_bancos
end type
type cbx_cencos from checkbox within w_rh428_rpt_neto_bancos
end type
type st_5 from statictext within w_rh428_rpt_neto_bancos
end type
type em_tipo_planilla from editmask within w_rh428_rpt_neto_bancos
end type
type cb_tipo_planilla from commandbutton within w_rh428_rpt_neto_bancos
end type
type em_desc_tipo_planilla from editmask within w_rh428_rpt_neto_bancos
end type
type gb_1 from groupbox within w_rh428_rpt_neto_bancos
end type
type gb_3 from groupbox within w_rh428_rpt_neto_bancos
end type
type gb_2 from groupbox within w_rh428_rpt_neto_bancos
end type
end forward

global type w_rh428_rpt_neto_bancos from w_report_smpl
integer width = 5358
integer height = 1500
string title = "(RH428) Netos por Bancos"
string menuname = "m_impresion"
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
em_fecha em_fecha
st_1 st_1
sle_origen sle_origen
sle_desc_origen sle_desc_origen
sle_tipo sle_tipo
sle_desc_tipo sle_desc_tipo
rb_boletas rb_boletas
rb_grati rb_grati
rb_cts rb_cts
st_2 st_2
st_3 st_3
rb_quincena rb_quincena
sle_year sle_year
sle_mes sle_mes
st_4 st_4
rb_detalle rb_detalle
rb_resumen rb_resumen
sle_cencos sle_cencos
cb_cencos cb_cencos
sle_desc_cencos sle_desc_cencos
cbx_cencos cbx_cencos
st_5 st_5
em_tipo_planilla em_tipo_planilla
cb_tipo_planilla cb_tipo_planilla
em_desc_tipo_planilla em_desc_tipo_planilla
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_rh428_rpt_neto_bancos w_rh428_rpt_neto_bancos

on w_rh428_rpt_neto_bancos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_fecha=create em_fecha
this.st_1=create st_1
this.sle_origen=create sle_origen
this.sle_desc_origen=create sle_desc_origen
this.sle_tipo=create sle_tipo
this.sle_desc_tipo=create sle_desc_tipo
this.rb_boletas=create rb_boletas
this.rb_grati=create rb_grati
this.rb_cts=create rb_cts
this.st_2=create st_2
this.st_3=create st_3
this.rb_quincena=create rb_quincena
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.st_4=create st_4
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.sle_cencos=create sle_cencos
this.cb_cencos=create cb_cencos
this.sle_desc_cencos=create sle_desc_cencos
this.cbx_cencos=create cbx_cencos
this.st_5=create st_5
this.em_tipo_planilla=create em_tipo_planilla
this.cb_tipo_planilla=create cb_tipo_planilla
this.em_desc_tipo_planilla=create em_desc_tipo_planilla
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.em_fecha
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_origen
this.Control[iCurrent+7]=this.sle_desc_origen
this.Control[iCurrent+8]=this.sle_tipo
this.Control[iCurrent+9]=this.sle_desc_tipo
this.Control[iCurrent+10]=this.rb_boletas
this.Control[iCurrent+11]=this.rb_grati
this.Control[iCurrent+12]=this.rb_cts
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.rb_quincena
this.Control[iCurrent+16]=this.sle_year
this.Control[iCurrent+17]=this.sle_mes
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.rb_detalle
this.Control[iCurrent+20]=this.rb_resumen
this.Control[iCurrent+21]=this.sle_cencos
this.Control[iCurrent+22]=this.cb_cencos
this.Control[iCurrent+23]=this.sle_desc_cencos
this.Control[iCurrent+24]=this.cbx_cencos
this.Control[iCurrent+25]=this.st_5
this.Control[iCurrent+26]=this.em_tipo_planilla
this.Control[iCurrent+27]=this.cb_tipo_planilla
this.Control[iCurrent+28]=this.em_desc_tipo_planilla
this.Control[iCurrent+29]=this.gb_1
this.Control[iCurrent+30]=this.gb_3
this.Control[iCurrent+31]=this.gb_2
end on

on w_rh428_rpt_neto_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_fecha)
destroy(this.st_1)
destroy(this.sle_origen)
destroy(this.sle_desc_origen)
destroy(this.sle_tipo)
destroy(this.sle_desc_tipo)
destroy(this.rb_boletas)
destroy(this.rb_grati)
destroy(this.rb_cts)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rb_quincena)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.st_4)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.sle_cencos)
destroy(this.cb_cencos)
destroy(this.sle_desc_cencos)
destroy(this.cbx_cencos)
destroy(this.st_5)
destroy(this.em_tipo_planilla)
destroy(this.cb_tipo_planilla)
destroy(this.em_desc_tipo_planilla)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_tiptra, ls_descripcion, ls_desc_tipo, ls_nom_empresa, ls_cencos, &
			ls_tipo_planilla
date 		ld_fecha
Integer	li_year, li_mes

try 
	ls_origen 			= string(sle_origen.text)
	ld_fecha 			= date(em_fecha.text)
	ls_tiptra 			= string(sle_tipo.text)
	ls_descripcion 	= string(sle_desc_tipo.text)
	li_year				= Integer(sle_year.text)
	li_mes				= Integer(sle_mes.text)
	
	if not cbx_cencos.checked then
		ls_cencos = '%%'
	else
		if trim(sle_cencos.text) = '' then
			MessageBox('Error', 'Debe seleccionar un centro de costos', StopSign!)
			cb_cencos.SetFocus()
			return
		end if
		
		ls_cencos = trim(sle_cencos.text) + '%'
	end if
	
	if rb_boletas.checked then
		if IsNull(em_tipo_planilla.text) or trim(em_tipo_planilla.text) = '' then
			MessageBox('Error', 'Debe seleccionar un tipo de planilla, por favor verifique!', StopSign!)
			em_tipo_planilla.setFocus()
			return
		end if
		
		ls_tipo_planilla = em_tipo_planilla.text
		
		if rb_detalle.checked then
			dw_report.DataObject = 'd_rpt_netos_x_bancos_tbl'
		elseif rb_resumen.checked  then
			dw_report.DataObject = 'd_rpt_resumen_plla_cst'
		end if
		
	elseif rb_grati.checked then
		if rb_detalle.checked then
			dw_report.DataObject = 'd_rpt_netos_x_bancos_grati_tbl'
		elseif rb_resumen.checked  then
			dw_report.DataObject = 'd_rpt_resumen_plla_grati_cst'
		end if
	elseif rb_cts.checked then
		if rb_detalle.checked then
			dw_report.DataObject = 'd_rpt_netos_x_bancos_cts_tbl'
		elseif rb_resumen.checked  then
			dw_report.DataObject = 'd_rpt_resumen_plla_cts_cst'
		end if
	elseif rb_quincena.checked then
		if rb_detalle.checked then
			dw_report.DataObject = 'd_rpt_netos_x_bancos_quincena_tbl'
		elseif rb_resumen.checked  then
			dw_report.DataObject = 'd_rpt_resumen_plla_quincena_cst'
		end if
	end if
	
	dw_report.SetTransObject(SQLCA)
	ib_preview = false
	event ue_preview()
	
	dw_report.object.DataWindow.Print.Orientation = 1
	
	if rb_detalle.checked then
		
		if rb_quincena.checked then
			dw_report.retrieve(ls_origen, ls_tiptra, li_year, li_mes)
		else
			dw_report.retrieve(ls_origen, ls_tiptra, ld_fecha, ls_tipo_planilla)
		end if
		
	elseif rb_resumen.checked then
		
		//Empresa
		select nombre
			into :ls_nom_empresa
		from 	empresa e,
				genparam g
		where e.cod_empresa = g.cod_empresa
		  and g.reckey = '1';
		
		//Tipo Trabajador
		select DESC_TIPO_TRA
			into :ls_desc_tipo
		from 	tipo_trabajador
		where tipo_trabajador = :ls_tiptra;
		
		if rb_quincena.checked then
			dw_report.retrieve(ls_origen, ls_tiptra, li_year, li_mes, ls_nom_empresa, ls_desc_tipo)
		else
			dw_report.retrieve(ls_origen, ls_tiptra, ld_fecha, ls_nom_empresa, ls_desc_tipo, ls_tipo_planilla)
		end if
		
	end if
	
	dw_report.object.p_logo.filename = gs_logo
	
	if rb_detalle.checked then
		dw_report.object.t_empresa.text 	= gs_empresa
		dw_report.object.t_user.text 		= gs_user
	end if
	

catch ( Exception ex )
	
end try



end event

event ue_open_pre;call super::ue_open_pre;Date	ld_now

ld_now = Date(gnvo_app.of_fecha_actual())

sle_year.text = string(ld_now, 'yyyy')
sle_mes.text = string(ld_now, 'mm')

em_tipo_planilla.text = 'N'
em_desc_tipo_planilla.text = 'Planilla normal'
end event

type dw_report from w_report_smpl`dw_report within w_rh428_rpt_neto_bancos
integer x = 0
integer y = 468
integer width = 3369
integer height = 816
integer taborder = 50
string dataobject = "d_rpt_netos_x_bancos_tbl"
end type

type cb_3 from commandbutton within w_rh428_rpt_neto_bancos
integer x = 718
integer y = 60
integer width = 87
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_origen.text      = sl_param.field_ret[1]
	sle_desc_origen.text = sl_param.field_ret[2]
END IF

end event

type cb_2 from commandbutton within w_rh428_rpt_neto_bancos
integer x = 718
integer y = 148
integer width = 87
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_tipo.text      = sl_param.field_ret[1]
	sle_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type cb_1 from commandbutton within w_rh428_rpt_neto_bancos
integer x = 3602
integer y = 36
integer width = 293
integer height = 180
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_fecha from editmask within w_rh428_rpt_neto_bancos
integer x = 2094
integer y = 192
integer width = 384
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_1 from statictext within w_rh428_rpt_neto_bancos
integer x = 2094
integer y = 56
integer width = 384
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 475
integer y = 60
integer width = 242
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type sle_desc_origen from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 805
integer y = 60
integer width = 773
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type sle_tipo from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 475
integer y = 148
integer width = 242
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type sle_desc_tipo from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 805
integer y = 148
integer width = 773
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type rb_boletas from radiobutton within w_rh428_rpt_neto_bancos
integer x = 1609
integer y = 52
integer width = 475
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pago de Boletas"
boolean checked = true
end type

event clicked;if this.checked then
	sle_year.enabled 	= false
	sle_mes.enabled 	= false
	em_fecha.enabled	= true
	
	em_tipo_planilla.enabled = true
	cb_tipo_planilla.enabled = true
	em_desc_tipo_planilla.enabled = true
end if
end event

type rb_grati from radiobutton within w_rh428_rpt_neto_bancos
integer x = 1609
integer y = 116
integer width = 475
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Gratificación"
end type

event clicked;if this.checked then
	sle_year.enabled 	= false
	sle_mes.enabled 	= false
	em_fecha.enabled	= true
	
	em_tipo_planilla.enabled = false
	cb_tipo_planilla.enabled = false
	em_desc_tipo_planilla.enabled = false
end if
end event

type rb_cts from radiobutton within w_rh428_rpt_neto_bancos
integer x = 1609
integer y = 180
integer width = 475
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CTS"
end type

event clicked;if this.checked then
	sle_year.enabled 	= false
	sle_mes.enabled 	= false
	em_fecha.enabled	= true
	
	em_tipo_planilla.enabled = false
	cb_tipo_planilla.enabled = false
	em_desc_tipo_planilla.enabled = false
end if
end event

type st_2 from statictext within w_rh428_rpt_neto_bancos
integer x = 37
integer y = 64
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh428_rpt_neto_bancos
integer x = 37
integer y = 152
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo Trab. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_quincena from radiobutton within w_rh428_rpt_neto_bancos
integer x = 2496
integer y = 56
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Adelanto quincena"
end type

event clicked;if this.checked then
	sle_year.enabled 	= true
	sle_mes.enabled 	= true
	em_fecha.enabled	= false
	
	em_tipo_planilla.enabled = false
	cb_tipo_planilla.enabled = false
	em_desc_tipo_planilla.enabled = false
end if
end event

type sle_year from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 2519
integer y = 188
integer width = 274
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 2798
integer y = 188
integer width = 155
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_rh428_rpt_neto_bancos
integer x = 2519
integer y = 132
integer width = 439
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_detalle from radiobutton within w_rh428_rpt_neto_bancos
integer x = 3118
integer y = 64
integer width = 411
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
boolean checked = true
end type

type rb_resumen from radiobutton within w_rh428_rpt_neto_bancos
integer x = 3118
integer y = 156
integer width = 411
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

type sle_cencos from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 475
integer y = 324
integer width = 242
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type cb_cencos from commandbutton within w_rh428_rpt_neto_bancos
integer x = 718
integer y = 324
integer width = 87
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;String 	ls_sql, ls_codigo, ls_data
boolean 	lb_ret

ls_sql = "select cc.cencos as cencos, " &
		+ "cc.desc_cencos as desc_cencos " &
		+ "from centros_costo cc " &
		+ "where cc.flag_estado = '1'" 

		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	sle_cencos.text				= ls_codigo
	sle_desc_cencos.text		= ls_data
end if

end event

type sle_desc_cencos from singlelineedit within w_rh428_rpt_neto_bancos
integer x = 805
integer y = 324
integer width = 773
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type cbx_cencos from checkbox within w_rh428_rpt_neto_bancos
integer x = 37
integer y = 328
integer width = 434
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Centro Costo :"
end type

event clicked;if this.checked then
	sle_cencos.enabled = true
	sle_desc_cencos.enabled = true
	cb_cencos.enabled = true
else
	sle_cencos.enabled = false
	sle_desc_cencos.enabled = false
	cb_cencos.enabled = false
end if
	
end event

type st_5 from statictext within w_rh428_rpt_neto_bancos
integer x = 37
integer y = 248
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo Planilla :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_tipo_planilla from editmask within w_rh428_rpt_neto_bancos
integer x = 475
integer y = 236
integer width = 242
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;//string ls_data, ls_tipo_planilla, ls_origen
//
//ls_origen = em_origen.text
//
//if IsNull(ls_origen) or trim(ls_origen) = '' then
//	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
//	em_origen.setFocus()
//	return
//end if
//
//ls_tipo_planilla = this.text
//
//select usp_sigre_rrhh.of_tipo_planilla(:ls_tipo_planilla)
//	into :ls_data
//from dual;
//
//em_desc_tipo_planilla.text = ls_data
//
//
end event

type cb_tipo_planilla from commandbutton within w_rh428_rpt_neto_bancos
integer x = 718
integer y = 236
integer width = 87
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabaj
Date		ld_fec_proceso

if IsNull(sle_origen.text) or trim(sle_origen.text) = '' then
	gnvo_app.of_message_error( "Debe especificar primero el origen. Por favor verifique!")
	sle_origen.SetFocus()
	return
end if

if IsNull(sle_tipo.text) or trim(sle_tipo.text) = '' then
	gnvo_app.of_message_error( "Debe especificar Tipo de Trabajador. Por favor verifique!")
	sle_tipo.SetFocus()
	return
end if


ls_origen = sle_origen.text

ls_tipo_trabaj = trim(sle_tipo.text) + '%'

ls_sql = "select distinct " &
		 + "       r.tipo_planilla as tipo_planilla, " &
		 + "       usp_sigre_rrhh.of_tipo_planilla(r.tipo_planilla) as desc_tipo_planilla " &
		 + "from rrhh_param_org r " &
		 + "where r.origen = '" + ls_origen + "'" &
		 + "  and r.tipo_trabajador like '" + ls_tipo_trabaj + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo_planilla.text = ls_codigo
	em_desc_tipo_planilla.text = ls_data
end if
end event

type em_desc_tipo_planilla from editmask within w_rh428_rpt_neto_bancos
integer x = 805
integer y = 236
integer width = 773
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_1 from groupbox within w_rh428_rpt_neto_bancos
integer x = 3058
integer width = 507
integer height = 420
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Reporte"
end type

type gb_3 from groupbox within w_rh428_rpt_neto_bancos
integer x = 1591
integer width = 1458
integer height = 420
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fuente"
end type

type gb_2 from groupbox within w_rh428_rpt_neto_bancos
integer width = 1591
integer height = 420
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Datos para el reporte"
end type

