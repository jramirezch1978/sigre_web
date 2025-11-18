$PBExportHeader$w_sig711_stock_pptt_x_origen_detalle.srw
forward
global type w_sig711_stock_pptt_x_origen_detalle from w_rpt
end type
type dw_report from u_dw_rpt within w_sig711_stock_pptt_x_origen_detalle
end type
end forward

global type w_sig711_stock_pptt_x_origen_detalle from w_rpt
integer x = 256
integer y = 348
integer width = 3154
integer height = 1796
string title = "(SIG711) Detalle"
string menuname = "m_rpt_simple"
long backcolor = 12632256
dw_report dw_report
end type
global w_sig711_stock_pptt_x_origen_detalle w_sig711_stock_pptt_x_origen_detalle

on w_sig711_stock_pptt_x_origen_detalle.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig711_stock_pptt_x_origen_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
idw_1.object.p_logo.filename = gs_logo
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_tipo, ls_cod_art, ls_mov_tipo
Long ll_factor, ln_count
Date ld_fec_ini, ld_fec_fin
DateTime ldt_fec_ini, ldt_fec_fin
//Date ldt_fec_ini, ldt_fec_fin

sg_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_origen = lstr_rep.string1
ls_cod_art = lstr_rep.string2
ls_mov_tipo = lstr_rep.string3
ls_tipo = lstr_rep.tipo

If IsNull(ls_mov_tipo) then
	ls_mov_tipo =''
end if

ld_fec_ini = lstr_rep.date1
ld_fec_fin = lstr_rep.date2

select count(*)
  into :ln_count
  from calendario_produccion cc 
 where fecha_prod = :ld_fec_ini ;

IF ln_count > 0 THEN
	// Inicio
	select del_dia
	  into :ldt_fec_ini 
	  from calendario_produccion cc 
	 where fecha_prod = :ld_fec_ini ;
	 
	// Fin
	select al_dia 
	  into :ldt_fec_fin
	  from calendario_produccion cc 
	 where fecha_prod = :ld_fec_fin ;
else
	ldt_fec_ini = datetime( ld_fec_ini, time('00:00:00') )
	ldt_fec_fin = datetime( ld_fec_fin, time('00:00:00') )
end if
	
idw_1.ii_zoom_actual = 110
ib_preview = false
event ue_preview()

idw_1.Visible = True
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.windows_t.text = this.classname()

messagebox('Tipo',ls_tipo)
messagebox('Fecha Ini',string(ldt_fec_ini))
messagebox('Fecha Fin',string(ldt_fec_fin))
messagebox('Origen',string(ls_origen))
messagebox('Articulo',string(ls_cod_art))
messagebox('Mov Tipo',string(ls_mov_tipo))

if ls_tipo = 'PROD' then

   idw_1.dataobject = 'd_rpt_sig_stock_pptt_x_origen_prod'
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve( ldt_fec_ini, ldt_fec_fin, ls_origen, ls_cod_art, ls_mov_tipo)
	idw_1.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)
	idw_1.title = '(SIG711) Detalle Movimientos de Ingresos de Producciòn'
	
elseif ls_tipo = 'VENT' then
	
   idw_1.dataobject = 'd_rpt_sig_stock_pptt_x_origen_ventas'
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ld_fec_ini, ld_fec_fin, ls_origen, ls_cod_art)
	idw_1.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)
	idw_1.title = '(SIG711) Detalle Ventas x Producto ' 

elseif ls_tipo = 'DESP' then
	
	idw_1.dataobject = 'd_rpt_sig_stock_pptt_x_origen_desp'
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ld_fec_ini, ld_fec_fin, ls_origen, ls_cod_art, ls_mov_tipo)
	idw_1.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)
	idw_1.title = '(SIG711) Detalle Movimientos de Despachos de Ventas'

elseif ls_tipo = 'TRAS' then	
	
	idw_1.dataobject = 'd_rpt_sig_stock_pptt_x_origen_tras'
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ld_fec_ini, ld_fec_fin, ls_origen, ls_cod_art, ls_mov_tipo)
	idw_1.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)
	idw_1.title = '(SIG711) Detalle Movimientos de Traslado de Almacen'

elseif ls_tipo = 'STKF' then	
	
	idw_1.dataobject = 'd_rpt_sig_stock_pptt_x_origen_stkf'
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ls_origen, ls_cod_art)
	idw_1.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)
	idw_1.title = '(SIG711) Stock Fisico por Almacen'

elseif ls_tipo = 'PEND' then	
	
	idw_1.dataobject = 'd_rpt_sig_stock_pptt_x_origen_pend'
	idw_1.SetTransObject(sqlca)
	idw_1.Retrieve(ls_origen, ls_cod_art)
	idw_1.Object.t_texto.text = 'Desde: '+ string(lstr_rep.date1)+ ' Al: '+ string(lstr_rep.date2)
	idw_1.title = '(SIG711) Articulos Pendientes de Entrega'


end if

	


end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

type dw_report from u_dw_rpt within w_sig711_stock_pptt_x_origen_detalle
integer y = 4
integer width = 2921
integer height = 1468
boolean bringtotop = true
string dataobject = "d_rpt_sig_stock_pptt_x_origen_prod"
boolean hscrollbar = true
boolean vscrollbar = true
end type

