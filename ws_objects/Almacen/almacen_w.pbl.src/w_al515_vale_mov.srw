$PBExportHeader$w_al515_vale_mov.srw
forward
global type w_al515_vale_mov from w_abc
end type
type st_1 from statictext within w_al515_vale_mov
end type
type sle_1 from u_sle_codigo within w_al515_vale_mov
end type
type cb_2 from commandbutton within w_al515_vale_mov
end type
type tab_1 from tab within w_al515_vale_mov
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
type tabpage_4 from userobject within tab_1
end type
type dw_consignacion from u_dw_cns within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_consignacion dw_consignacion
end type
type tab_1 from tab within w_al515_vale_mov
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type dw_master from u_dw_abc within w_al515_vale_mov
end type
end forward

global type w_al515_vale_mov from w_abc
integer x = 9
integer y = 4
integer width = 3680
integer height = 3152
string title = "[AL515] Consulta de vales de almacen ."
string menuname = "m_impresion"
event ue_saveas ( )
st_1 st_1
sle_1 sle_1
cb_2 cb_2
tab_1 tab_1
dw_master dw_master
end type
global w_al515_vale_mov w_al515_vale_mov

type variables
Integer 	ii_tabpos
Long		il_tab2, il_tab3, il_tab4, il_tab5
String	is_cod_origen, is_nro_vale //, is_articulo, is_doc_oc

end variables

forward prototypes
public subroutine wf_reset_dw ()
public subroutine of_get_codigo (string as_cod_origen, string as_nro_vale)
end prototypes

event ue_saveas;idw_query.Saveas()
end event

public subroutine wf_reset_dw ();dw_master.Reset()
tab_1.tabpage_1.dw_saldos.Reset()
tab_1.tabpage_2.dw_hist.Reset()
tab_1.tabpage_3.dw_proy.Reset()
tab_1.tabpage_4.dw_consignacion.Reset()

end subroutine

public subroutine of_get_codigo (string as_cod_origen, string as_nro_vale);// Verifica si articulo existe
Long ll_count

Select count(*) 
	into :ll_count 
from vale_mov 
where cod_origen = :as_cod_origen and nro_vale = :as_nro_vale ;

if ll_count = 0 then
	Messagebox( "Error", "Vale no existe")		
	Return
end if

is_cod_origen = as_cod_origen
is_nro_vale = as_nro_vale 

tab_1.SelectTab(1)
dw_master.Retrieve(as_cod_origen, as_nro_vale)
tab_1.tabpage_1.dw_saldos.retrieve(as_cod_origen, as_nro_vale) 

il_tab2 = 0
il_tab3 = 0
il_tab4 = 0


end subroutine

on w_al515_vale_mov.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_2=create cb_2
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_master
end on

on w_al515_vale_mov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_1)
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

tab_1.tabpage_4.dw_consignacion.width  = tab_1.tabpage_4.width - 50  
tab_1.tabpage_4.dw_consignacion.height = tab_1.tabpage_4.height - 50  


end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse


dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos

tab_1.tabpage_1.dw_saldos.SetTransObject(sqlca)
tab_1.tabpage_2.dw_hist.SetTransObject(sqlca)
tab_1.tabpage_3.dw_proy.SetTransObject(sqlca)
tab_1.tabpage_4.dw_consignacion.SetTransObject(sqlca)

//--
idw_query = tab_1.tabpage_1.dw_saldos
//dw_master.TriggerEvent('ue_insert')
wf_reset_dw()
idw_1 = dw_master              		// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija


end event

event ue_print;call super::ue_print;PrintSetup()
idw_query.print()
end event

type st_1 from statictext within w_al515_vale_mov
integer x = 27
integer y = 36
integer width = 507
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Número de Vale"
boolean focusrectangle = false
end type

type sle_1 from u_sle_codigo within w_al515_vale_mov
integer x = 594
integer y = 24
integer width = 398
integer taborder = 10
textcase textcase = upper!
integer limit = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type cb_2 from commandbutton within w_al515_vale_mov
integer x = 1042
integer y = 24
integer width = 306
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_nro_vale, ls_cod_origen

ls_nro_vale = TRIM(sle_1.text)
ls_cod_origen = MID(ls_nro_vale,1,2)
of_get_codigo( ls_cod_origen, ls_nro_vale )

end event

type tab_1 from tab within w_al515_vale_mov
integer y = 1168
integer width = 3575
integer height = 1508
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean boldselectedtext = true
tabposition tabposition = tabsontopandbottom!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanging;ii_tabpos = newindex 

CHOOSE CASE ii_tabpos
	CASE 2
		IF il_tab2 < 1 THEN il_tab2 = tab_1.tabpage_2.dw_hist.Retrieve(is_cod_origen, is_nro_vale)
	CASE 3
		IF il_tab3 < 1 THEN il_tab3 = tab_1.tabpage_3.dw_proy.Retrieve(is_cod_origen, is_nro_vale)
	CASE 4
		IF il_tab4 < 1 THEN il_tab4 = tab_1.tabpage_4.dw_consignacion.Retrieve(is_cod_origen, is_nro_vale)
	CASE 5
		//IF il_tab5 < 1 THEN il_tab5 = tab_1.tabpage_5.dw_devoluciones.Retrieve(is_cod_origen, is_nro_vale)
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3538
integer height = 1308
long backcolor = 79741120
string text = "Detalle"
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
integer x = 23
integer y = 36
integer width = 3474
integer height = 1212
boolean bringtotop = true
string dataobject = "d_cns_articulo_mov_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
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
integer width = 3538
integer height = 1308
long backcolor = 79741120
string text = "Guías"
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
integer x = 14
integer y = 64
integer width = 3429
integer height = 936
boolean bringtotop = true
string dataobject = "d_cns_guia_vale_tbl"
boolean livescroll = false
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
integer width = 3538
integer height = 1308
long backcolor = 79741120
string text = "Referencias OT/OC/OV"
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
integer y = 132
integer width = 3493
integer height = 1088
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_referencia_vale_tbl"
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

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3538
integer height = 1308
long backcolor = 79741120
string text = "Facturación"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_consignacion dw_consignacion
end type

on tabpage_4.create
this.dw_consignacion=create dw_consignacion
this.Control[]={this.dw_consignacion}
end on

on tabpage_4.destroy
destroy(this.dw_consignacion)
end on

type dw_consignacion from u_dw_cns within tabpage_4
integer width = 2789
integer height = 768
boolean bringtotop = true
string dataobject = "d_cns_factura_vale_tbl"
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

type dw_master from u_dw_abc within w_al515_vale_mov
integer y = 164
integer width = 3099
integer height = 952
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_cns_vale_mov_ff"
boolean hscrollbar = true
boolean vscrollbar = true
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

event itemerror;call super::itemerror;Return 1
end event

