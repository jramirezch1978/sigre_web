$PBExportHeader$w_ve736_seguimiento_ov.srw
forward
global type w_ve736_seguimiento_ov from w_report_smpl
end type
type cb_1 from commandbutton within w_ve736_seguimiento_ov
end type
type uo_1 from u_ingreso_rango_fechas within w_ve736_seguimiento_ov
end type
type dw_detalle from datawindow within w_ve736_seguimiento_ov
end type
type gb_1 from groupbox within w_ve736_seguimiento_ov
end type
end forward

global type w_ve736_seguimiento_ov from w_report_smpl
integer width = 3767
integer height = 2856
string title = "[VE736] Seguimiento General a OV"
string menuname = "m_reporte"
boolean ib_preview = true
cb_1 cb_1
uo_1 uo_1
dw_detalle dw_detalle
gb_1 gb_1
end type
global w_ve736_seguimiento_ov w_ve736_seguimiento_ov

on w_ve736_seguimiento_ov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.uo_1=create uo_1
this.dw_detalle=create dw_detalle
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.dw_detalle
this.Control[iCurrent+4]=this.gb_1
end on

on w_ve736_seguimiento_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.dw_detalle)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;date ad_inicio, ad_fin
Integer li_x, li_width, li_end
long ll_retrieve

ad_inicio = uo_1.of_get_fecha1()
ad_fin    = uo_1.of_get_fecha2()

li_x = Integer(dw_report.Describe('cod_art.x'))
li_width = Integer(dw_report.Describe('cod_art.width'))
li_end = li_x + li_width

dw_report.Object.datawindow.horizontalscrollsplit = li_end

dw_report.settransobject(sqlca)
ll_retrieve = dw_report.retrieve(ad_inicio, ad_fin, gs_empresa, gs_user)
dw_detalle.visible = true

if ll_retrieve > 0 then
	
	string ls_origen, ls_nro_ov
	
	ls_origen = dw_report.object.org_ov[1]
	ls_nro_ov = dw_report.object.nro_ov[1]
	
	dw_detalle.retrieve(ls_origen, ls_nro_ov)
	
end if
end event

event resize;//override
dw_report.width = newwidth - dw_report.x

dw_report.height = newheight * 0.8 - dw_report.y

dw_detalle.y = dw_report.y + dw_report.height + 10

dw_detalle.height = newheight - dw_detalle.y - 10

dw_detalle.width = dw_report.width
end event

type dw_report from w_report_smpl`dw_report within w_ve736_seguimiento_ov
integer x = 0
integer y = 208
integer width = 2505
integer height = 1280
string dataobject = "D_RPT_SEGUIMIENTO_OV"
boolean hsplitscroll = true
integer ii_zoom_actual = 100
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_report::clicked;call super::clicked;string ls_origen, ls_nro_ov

if row = 0 then return

ls_origen = this.object.org_ov	[row]
ls_nro_ov = this.object.nro_ov 	[row]

dw_detalle.retrieve( ls_origen, ls_nro_ov )
end event

event dw_report::doubleclicked;call super::doubleclicked;str_parametros lstr_param
w_cns_general	lw_cns

choose case lower(dwo.name)
		
	case "saldo_actual"
		
		//cod_art
		lstr_param.string1 	= this.object.cod_art [row]
		lstr_param.dw1 	 	= 'd_cns_saldo_almacen_pallet_tbl'
		lstr_param.tipo 	 	= '1S'
		lstr_param.titulo	 	= 'Saldo del articulo por almacen'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
					
		
end choose
end event

type cb_1 from commandbutton within w_ve736_seguimiento_ov
integer x = 1390
integer y = 96
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

type uo_1 from u_ingreso_rango_fechas within w_ve736_seguimiento_ov
integer x = 32
integer y = 76
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(Date('01/'+string(today(),'mm/yyyy')), date(gd_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/2002')) // rango inicial
of_set_rango_fin(date(gd_fecha)) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_detalle from datawindow within w_ve736_seguimiento_ov
boolean visible = false
integer y = 1932
integer width = 1723
integer height = 420
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_rpt_seguimiento_ov_det"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;settransobject(sqlca)

end event

event rowfocuschanged;f_select_current_row (this)
end event

type gb_1 from groupbox within w_ve736_seguimiento_ov
integer width = 1358
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

