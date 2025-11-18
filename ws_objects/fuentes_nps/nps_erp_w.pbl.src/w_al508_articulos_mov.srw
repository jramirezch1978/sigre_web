$PBExportHeader$w_al508_articulos_mov.srw
forward
global type w_al508_articulos_mov from w_abc
end type
type cb_2 from commandbutton within w_al508_articulos_mov
end type
type tab_1 from tab within w_al508_articulos_mov
end type
type tabpage_1 from userobject within tab_1
end type
type dw_saldos from u_dw_cns within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_saldos dw_saldos
end type
type tabpage_2 from userobject within tab_1
end type
type dw_hist from u_dw_cns within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_hist dw_hist
end type
type tabpage_3 from userobject within tab_1
end type
type dw_proy from u_dw_cns within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_proy dw_proy
end type
type tabpage_7 from userobject within tab_1
end type
type dw_saldo_alm from u_dw_cns within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_saldo_alm dw_saldo_alm
end type
type tab_1 from tab within w_al508_articulos_mov
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_7 tabpage_7
end type
type dw_master from u_dw_abc within w_al508_articulos_mov
end type
end forward

global type w_al508_articulos_mov from w_abc
integer x = 9
integer y = 4
integer width = 3675
integer height = 2228
string title = "Consulta Especializada de Articulos [AL508]"
string menuname = "m_impresion"
event ue_saveas ( )
cb_2 cb_2
tab_1 tab_1
dw_master dw_master
end type
global w_al508_articulos_mov w_al508_articulos_mov

type variables
Integer 	ii_tabpos
Long		il_tab2, il_tab3, il_tab4, il_tab5, il_tab6, il_tab7, il_tab8, il_tab9, il_tab10, il_tab11, il_tab12
String	is_articulo, is_doc_oc, is_nro_serie
Decimal	idc_saldo_fisico
end variables

forward prototypes
public subroutine wf_reset_dw ()
public subroutine of_get_codigo (string as_cod_art)
public function integer of_get_parametros (ref string as_doc_tipo)
end prototypes

event ue_saveas;idw_query.Saveas()
end event

public subroutine wf_reset_dw ();
tab_1.tabpage_1.dw_saldos.Reset()
tab_1.tabpage_2.dw_hist.Reset()
tab_1.tabpage_3.dw_proy.Reset()
tab_1.tabpage_7.dw_saldo_alm.Reset()
tab_1.tabpage_1.dw_saldos.Insertrow(0)


end subroutine

public subroutine of_get_codigo (string as_cod_art);// Verifica si articulo existe
Long ll_count

Select count( cod_art) 
	into :ll_count 
from articulo 
where cod_art = :as_cod_art;

if ll_count = 0 then
	Messagebox( "Error", "Codigo no existe")		
	dw_master.object.cod_art[dw_master.getrow()] = ''
	dw_master.SetColumn('cod_art')
	dw_master.SetFocus()
	Return
end if

is_articulo = as_cod_art

tab_1.SelectTab(1)
dw_master.Retrieve(as_cod_art)
dw_master.ShareData(tab_1.tabpage_1.dw_saldos)

idc_saldo_fisico = dw_master.GetItemDecimal(1,'articulo_sldo_total')

il_tab2 = 0
il_tab3 = 0
il_tab4 = 0


end subroutine

public function integer of_get_parametros (ref string as_doc_tipo);Long		ll_rc = 0

SELECT DOC_OC
  INTO :as_doc_tipo
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

IF IsNull(as_doc_tipo) THEN
	MessageBox('Error', 'No ha registrado el Doc OC en PARAM')
	lL_rc = -3
END IF

RETURN ll_rc

end function

on w_al508_articulos_mov.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_2=create cb_2
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_al508_articulos_mov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_saldos.width  = newwidth  - tab_1.tabpage_1.dw_saldos.x - 10
tab_1.tabpage_1.dw_saldos.height = newheight - tab_1.tabpage_1.dw_saldos.y - 10

tab_1.tabpage_2.dw_hist.width  = tab_1.tabpage_2.width  - 50
tab_1.tabpage_2.dw_hist.height = tab_1.tabpage_2.height - 50  

tab_1.tabpage_3.dw_proy.width  = tab_1.tabpage_3.width  - 50
tab_1.tabpage_3.dw_proy.height = tab_1.tabpage_3.height - 50  

tab_1.tabpage_7.dw_saldo_alm.width  = tab_1.tabpage_7.width - 50  
tab_1.tabpage_7.dw_saldo_alm.height = tab_1.tabpage_7.height - 50  


end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse


dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos

tab_1.tabpage_1.dw_saldos.SetTransObject(sqlca)
tab_1.tabpage_2.dw_hist.SetTransObject(sqlca)
tab_1.tabpage_3.dw_proy.SetTransObject(sqlca)
tab_1.tabpage_7.dw_saldo_alm.SetTransObject(sqlca)

//--
idw_query = tab_1.tabpage_1.dw_saldos
dw_master.TriggerEvent('ue_insert')
wf_reset_dw()
idw_1 = dw_master              		// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija

ll_rc = of_get_parametros(is_doc_oc)
end event

event ue_print;call super::ue_print;//String      ls_cadena
//Str_cns_pop lstr_cns_pop
//
//IF dw_master.getrow() = 0 THEN RETURN
//
//ls_cadena = Trim(String(dw_master.Object.cod_art[1]))
//
//IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN
//
//lstr_cns_pop.arg[1] = ls_cadena
//lstr_cns_pop.arg[2] = Trim(String(ii_tabpos - 1)) 
//lstr_cns_pop.arg[3] = gs_empresa
//lstr_cns_pop.arg[4] = gs_user
//
//lstr_cns_pop.dataobject = 'd_rpt_especializado_x_articulo_com'
//lstr_cns_pop.title = 'Consulta Epecializada Por Articulo'
//lstr_cns_pop.width  = 3650
//lstr_cns_pop.height = 1950
//
//OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)
//
//
PrintSetup()
idw_query.print()
end event

type p_pie from w_abc`p_pie within w_al508_articulos_mov
end type

type ole_skin from w_abc`ole_skin within w_al508_articulos_mov
end type

type uo_h from w_abc`uo_h within w_al508_articulos_mov
end type

type st_box from w_abc`st_box within w_al508_articulos_mov
end type

type phl_logonps from w_abc`phl_logonps within w_al508_articulos_mov
end type

type p_mundi from w_abc`p_mundi within w_al508_articulos_mov
end type

type p_logo from w_abc`p_logo within w_al508_articulos_mov
end type

type cb_2 from commandbutton within w_al508_articulos_mov
integer x = 3026
integer y = 44
integer width = 306
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_cod

ls_cod = dw_master.object.cod_art[dw_master.getrow()]
of_Get_codigo( ls_cod )
end event

type tab_1 from tab within w_al508_articulos_mov
integer x = 503
integer y = 732
integer width = 3557
integer height = 1292
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean boldselectedtext = true
tabposition tabposition = tabsontopandbottom!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_7)
end on

event selectionchanging;ii_tabpos = newindex 

CHOOSE CASE ii_tabpos
	CASE 2
		IF il_tab2 < 1 THEN il_tab2 = tab_1.tabpage_2.dw_hist.Retrieve(is_articulo)
	CASE 4
		IF il_tab7 < 1 THEN il_tab7 = tab_1.tabpage_7.dw_saldo_alm.retrieve(is_articulo)
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1092
long backcolor = 79741120
string text = "Saldos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
dw_saldos dw_saldos
end type

on tabpage_1.create
this.dw_saldos=create dw_saldos
this.Control[]={this.dw_saldos}
end on

on tabpage_1.destroy
destroy(this.dw_saldos)
end on

type dw_saldos from u_dw_cns within tabpage_1
integer x = 14
integer y = 36
integer width = 3474
integer height = 1212
boolean bringtotop = true
string dataobject = "d_cns_art_saldos_ff"
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1092
long backcolor = 79741120
string text = "Mov del Artículo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
dw_hist dw_hist
end type

on tabpage_2.create
this.dw_hist=create dw_hist
this.Control[]={this.dw_hist}
end on

on tabpage_2.destroy
destroy(this.dw_hist)
end on

type dw_hist from u_dw_cns within tabpage_2
integer width = 2702
integer height = 1064
boolean bringtotop = true
string dataobject = "d_cns_articulo_movimiento_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event doubleclicked;call super::doubleclicked;String ls_tipo, ls_nro
str_parametros lstr_rep

if dwo.name = 'nro_vale' then
	
	// vista previa de mov. almacen
	lstr_rep.dw1 = 'd_frm_movimiento_almacen'
	lstr_rep.titulo = 'Previo de Movimiento de almacen'
	lstr_rep.string1 = this.object.cod_origen[row]
	lstr_rep.string2 = this.object.nro_vale[row]
	lstr_rep.tipo	  = '1S2S'

	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end if

if dwo.name = 'nro_doc' then
	ls_tipo = TRIM( this.object.tipo_doc[row])
	choose case ls_tipo
		case 'OC'			
			lstr_rep.dw1 = 'd_rpt_orden_compra_cab'
			lstr_rep.titulo = 'Previo de Orden de compra'
			lstr_rep.string1 = this.object.cod_origen	[row]
			lstr_rep.string2 = this.object.nro_doc		[row]

			OpenSheetWithParm(w_cm311_orden_compra_frm, lstr_rep, w_main, 0, Layered!)			
		case 'SL'
			lstr_rep.dw1 = 'd_rpt_sol_salida'
			lstr_rep.titulo = 'Previo de Solicitud de Salida'
			lstr_rep.string1 = this.object.cod_origen[row]
			lstr_rep.string2 = this.object.nro_doc[row]

			OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)			
	end choose	

end if
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1092
long backcolor = 79741120
string text = "Movimiento x Serie"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
dw_proy dw_proy
end type

on tabpage_3.create
this.dw_proy=create dw_proy
this.Control[]={this.dw_proy}
end on

on tabpage_3.destroy
destroy(this.dw_proy)
end on

type dw_proy from u_dw_cns within tabpage_3
integer width = 2821
integer height = 1032
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_movimiento_serie_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event doubleclicked;call super::doubleclicked;String ls_tipo, ls_nro
str_parametros lstr_rep
w_rpt_preview lw_1

if dwo.name = 'nro_doc' then
	ls_tipo = TRIM( this.object.tipo_doc[row])

	choose case ls_tipo
		case 'OC'			
			lstr_rep.dw1 = 'd_rpt_orden_compra_cab'
			lstr_rep.titulo = 'Previo de Orden de compra'
			lstr_rep.string1 = this.object.cod_origen[row]
			lstr_rep.string2 = this.object.nro_doc[row]

			OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)			
		case 'SL'
			lstr_rep.dw1 = 'd_rpt_sol_salida'
			lstr_rep.titulo = 'Previo de Solicitud de Salida'
			lstr_rep.string1 = this.object.cod_origen[row]
			lstr_rep.string2 = this.object.nro_doc[row]

			OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)
		case 'SC'
			lstr_rep.dw1 = 'd_rpt_solicitud_compra'
			lstr_rep.titulo = 'Previo de Solicitud de Salida'
			lstr_rep.string1 = this.object.cod_origen[row]
			lstr_rep.string2 = this.object.nro_doc[row]

			OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)			
	end choose	

end if
end event

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row( this)
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1092
long backcolor = 79741120
string text = "Datos x Almacen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_saldo_alm dw_saldo_alm
end type

on tabpage_7.create
this.dw_saldo_alm=create dw_saldo_alm
this.Control[]={this.dw_saldo_alm}
end on

on tabpage_7.destroy
destroy(this.dw_saldo_alm)
end on

type dw_saldo_alm from u_dw_cns within tabpage_7
integer width = 2967
integer height = 800
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_saldos"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type dw_master from u_dw_abc within w_al508_articulos_mov
integer x = 498
integer y = 236
integer width = 3003
integer height = 488
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_art_especializado_ff"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master				// dw_master
//idw_det  =  				// dw_detail
end event

event itemchanged;call super::itemchanged;Accepttext()
double ln_dec

ln_dec = double( data) / 3.482
CHOOSE CASE dwo.name
		 CASE 'cod_art'			 
			 of_get_codigo( data )
		case 'articulo_costo_prom_sol'
			this.object.articulo_costo_prom_dol[row] = ln_dec
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 
str_parametros sl_param
String 		ls_nro_serie

sl_param.almacen = '%%'
	
OpenWithParm (w_pop_articulos_total, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM


IF sl_param.titulo <> 'n' then
	this.object.cod_art[this.getrow()] = sl_param.field_ret[1]
	of_Get_codigo( sl_param.field_ret[1] )
	
	
	ls_nro_serie = sl_param.field_ret[7]	
	
	if IsNull(ls_nro_serie) or ls_nro_serie = '' then
		ls_nro_Serie = '%%'
	end if

	tab_1.tabpage_3.dw_proy.Retrieve(is_articulo, ls_nro_serie)
	
END IF

end event

