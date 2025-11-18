$PBExportHeader$w_ve737_ventas_anuales.srw
forward
global type w_ve737_ventas_anuales from w_report_smpl
end type
type cb_1 from commandbutton within w_ve737_ventas_anuales
end type
type dw_ano from datawindow within w_ve737_ventas_anuales
end type
type rb_ov from radiobutton within w_ve737_ventas_anuales
end type
type rb_vs from radiobutton within w_ve737_ventas_anuales
end type
type rb_fa from radiobutton within w_ve737_ventas_anuales
end type
type rb_kgr from radiobutton within w_ve737_ventas_anuales
end type
type rb_ton from radiobutton within w_ve737_ventas_anuales
end type
type rb_sol from radiobutton within w_ve737_ventas_anuales
end type
type rb_dol from radiobutton within w_ve737_ventas_anuales
end type
type cbx_igv from checkbox within w_ve737_ventas_anuales
end type
type gb_1 from groupbox within w_ve737_ventas_anuales
end type
type gb_2 from groupbox within w_ve737_ventas_anuales
end type
type gb_3 from groupbox within w_ve737_ventas_anuales
end type
end forward

global type w_ve737_ventas_anuales from w_report_smpl
integer width = 2414
integer height = 1076
string title = "(VE737) Ventas Anuales por Articulos"
string menuname = "m_reporte"
long backcolor = 67108864
cb_1 cb_1
dw_ano dw_ano
rb_ov rb_ov
rb_vs rb_vs
rb_fa rb_fa
rb_kgr rb_kgr
rb_ton rb_ton
rb_sol rb_sol
rb_dol rb_dol
cbx_igv cbx_igv
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_ve737_ventas_anuales w_ve737_ventas_anuales

on w_ve737_ventas_anuales.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.dw_ano=create dw_ano
this.rb_ov=create rb_ov
this.rb_vs=create rb_vs
this.rb_fa=create rb_fa
this.rb_kgr=create rb_kgr
this.rb_ton=create rb_ton
this.rb_sol=create rb_sol
this.rb_dol=create rb_dol
this.cbx_igv=create cbx_igv
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ano
this.Control[iCurrent+3]=this.rb_ov
this.Control[iCurrent+4]=this.rb_vs
this.Control[iCurrent+5]=this.rb_fa
this.Control[iCurrent+6]=this.rb_kgr
this.Control[iCurrent+7]=this.rb_ton
this.Control[iCurrent+8]=this.rb_sol
this.Control[iCurrent+9]=this.rb_dol
this.Control[iCurrent+10]=this.cbx_igv
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
end on

on w_ve737_ventas_anuales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ano)
destroy(this.rb_ov)
destroy(this.rb_vs)
destroy(this.rb_fa)
destroy(this.rb_kgr)
destroy(this.rb_ton)
destroy(this.rb_sol)
destroy(this.rb_dol)
destroy(this.cbx_igv)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;long ll_ano, ll_factor
string ls_sol, ls_dol

dw_ano.accepttext( )

ll_ano = long(dw_ano.object.ano[1])

select cod_soles, cod_dolares
  into :ls_sol, :ls_dol
  from logparam
 where reckey = '1';

if rb_ov.checked = true then
	
	if rb_kgr.checked or rb_ton.checked then
		dw_report.dataobject = 'd_rpt_ventas_anual_ov_cant'
	else
		if rb_sol.checked = true then
			dw_report.dataobject = 'd_rpt_ventas_anual_ov_sol'
		else
			dw_report.dataobject = 'd_rpt_ventas_anual_ov_dol'
		end if
	end if
	
elseif rb_vs.checked = true then
	
	if rb_kgr.checked or rb_ton.checked then
		dw_report.dataobject = 'd_rpt_ventas_anual_vs_cant'
	else
		if rb_sol.checked = true then
			dw_report.dataobject = 'd_rpt_ventas_anual_vs_sol'
		else
			dw_report.dataobject = 'd_rpt_ventas_anual_vs_dol'
		end if
	end if
	
elseif rb_fa.checked = true then
	
	if rb_kgr.checked or rb_ton.checked then
		dw_report.dataobject = 'd_rpt_ventas_anual_fac_cant'
	else
		if rb_sol.checked = true then
			dw_report.dataobject = 'd_rpt_ventas_anual_fac_sol'
		else
			dw_report.dataobject = 'd_rpt_ventas_anual_fac_dol'
		end if
	end if
	
end if

dw_report.settransobject(sqlca)

// Factor para obtener kilos o toneladas (solo cuando es KILOS o TONELADAS, ver select)
if rb_kgr.checked = true then
	
	ll_factor = 1
	
	dw_report.object.t_titulo.text = dw_report.object.t_titulo.text + ' - KGR'
	
elseif rb_ton.checked = true then
	
	ll_factor = 1000
	
	dw_report.object.t_titulo.text = dw_report.object.t_titulo.text + ' - TON'
	
end if

// Factor para determinar calculo en select y calcular IGV (solo cuando es SOLES o DOLARES, ver select)
if rb_sol.checked = true or rb_dol.checked = true then
	
	if rb_sol.checked = true then
		dw_report.object.t_titulo.text = dw_report.object.t_titulo.text + ' - '+ls_sol
	else
		dw_report.object.t_titulo.text = dw_report.object.t_titulo.text + ' - '+ls_dol
	end if
	
	//****************************************
	// igv
	//****************************************
	if rb_fa.checked = true then //facturacion
		
		//Facturacion se calcula diferente el impuesto debido a la tabla CC_DOC_DET_IMP
		//VER EL SELECT PARA MAYOR CONSULTA DE FACTURACION
		if cbx_igv.checked = true then
			ll_factor = 1 //con igv
		else
			ll_factor = 0 //sin igv
		end if
	
	
	elseif rb_ov.checked or rb_vs.checked then
		
		//FACTORES EN BASE A LA COLUMNA IMPUESTO (19.00)
		if cbx_igv.checked = true then
			ll_factor = 0 //con igv
		else
			ll_factor = 1 //sin igv
		end if
		
	end if
	
end if

// Retrieve
if ( rb_kgr.checked or rb_ton.checked ) then
	
	dw_report.retrieve(ll_ano, ll_factor, gs_empresa, gs_user)
	
elseif rb_sol.checked then
	
	dw_report.retrieve(ll_ano, ll_factor, ls_sol, gs_empresa, gs_user)
	
elseif rb_dol.checked then
	
	dw_report.retrieve(ll_ano, ll_factor, ls_dol, gs_empresa, gs_user)
	
end if

dw_report.object.p_logo.filename = gs_logo

ib_preview = false

this.event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_ve737_ventas_anuales
integer x = 37
integer y = 448
integer width = 2272
integer height = 324
integer ii_zoom_actual = 100
end type

type cb_1 from commandbutton within w_ve737_ventas_anuales
integer x = 1975
integer y = 320
integer width = 334
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type dw_ano from datawindow within w_ve737_ventas_anuales
integer x = 55
integer y = 96
integer width = 457
integer height = 104
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_ext_ano"
boolean border = false
boolean livescroll = true
end type

event constructor;insertrow(0)

this.object.ano[1] = long(string(today(),'yyyy'))
end event

type rb_ov from radiobutton within w_ve737_ventas_anuales
integer x = 603
integer y = 120
integer width = 503
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ordenes de Venta"
boolean checked = true
end type

type rb_vs from radiobutton within w_ve737_ventas_anuales
integer x = 1120
integer y = 120
integer width = 439
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Vales de Salida"
end type

type rb_fa from radiobutton within w_ve737_ventas_anuales
integer x = 1563
integer y = 120
integer width = 347
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Facturacion"
end type

type rb_kgr from radiobutton within w_ve737_ventas_anuales
integer x = 73
integer y = 336
integer width = 338
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Kilos"
boolean checked = true
end type

event clicked;if this.checked = true then
	cbx_igv.enabled = false
end if
end event

type rb_ton from radiobutton within w_ve737_ventas_anuales
integer x = 343
integer y = 336
integer width = 338
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Toneladas"
end type

event clicked;if this.checked = true then
	cbx_igv.enabled = false
end if
end event

type rb_sol from radiobutton within w_ve737_ventas_anuales
integer x = 731
integer y = 336
integer width = 247
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Soles"
end type

event clicked;if this.checked = true then
	cbx_igv.enabled = true
end if
end event

type rb_dol from radiobutton within w_ve737_ventas_anuales
integer x = 1038
integer y = 336
integer width = 279
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Dolares"
end type

event clicked;if this.checked = true then
	cbx_igv.enabled = true
end if
end event

type cbx_igv from checkbox within w_ve737_ventas_anuales
integer x = 1426
integer y = 320
integer width = 512
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
string text = "Montos con IGV"
boolean checked = true
end type

type gb_1 from groupbox within w_ve737_ventas_anuales
integer x = 37
integer y = 32
integer width = 517
integer height = 196
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_ve737_ventas_anuales
integer x = 585
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

type gb_3 from groupbox within w_ve737_ventas_anuales
integer x = 37
integer y = 256
integer width = 1358
integer height = 164
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Opciones"
end type

