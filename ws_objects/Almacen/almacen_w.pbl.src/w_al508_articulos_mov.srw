$PBExportHeader$w_al508_articulos_mov.srw
forward
global type w_al508_articulos_mov from w_abc
end type
type dw_lista from u_dw_abc within w_al508_articulos_mov
end type
type uo_search from n_cst_search within w_al508_articulos_mov
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
type tabpage_5 from userobject within tab_1
end type
type dw_devoluciones from u_dw_cns within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_devoluciones dw_devoluciones
end type
type tabpage_6 from userobject within tab_1
end type
type dw_prestamo from u_dw_cns within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_prestamo dw_prestamo
end type
type tabpage_4 from userobject within tab_1
end type
type dw_consignacion from u_dw_cns within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_consignacion dw_consignacion
end type
type tabpage_7 from userobject within tab_1
end type
type dw_saldo_alm from u_dw_cns within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_saldo_alm dw_saldo_alm
end type
type tabpage_8 from userobject within tab_1
end type
type dw_equivalencias from u_dw_cns within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_equivalencias dw_equivalencias
end type
type tabpage_9 from userobject within tab_1
end type
type dw_oc from u_dw_cns within tabpage_9
end type
type tabpage_9 from userobject within tab_1
dw_oc dw_oc
end type
type tabpage_10 from userobject within tab_1
end type
type dw_reservacion from u_dw_cns within tabpage_10
end type
type tabpage_10 from userobject within tab_1
dw_reservacion dw_reservacion
end type
type tabpage_12 from userobject within tab_1
end type
type dw_transport from u_dw_cns within tabpage_12
end type
type tabpage_12 from userobject within tab_1
dw_transport dw_transport
end type
type tab_1 from tab within w_al508_articulos_mov
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_4 tabpage_4
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
tabpage_10 tabpage_10
tabpage_12 tabpage_12
end type
type dw_master from u_dw_abc within w_al508_articulos_mov
end type
end forward

global type w_al508_articulos_mov from w_abc
integer x = 9
integer y = 4
integer width = 5787
integer height = 2768
string title = "[AL508] Consulta Especializada de Articulos "
string menuname = "m_impresion"
event ue_saveas ( )
event ue_saveas_excel ( )
event ue_saveas_pdf ( )
dw_lista dw_lista
uo_search uo_search
tab_1 tab_1
dw_master dw_master
end type
global w_al508_articulos_mov w_al508_articulos_mov

type variables
Integer 	ii_tabpos
Decimal	idc_saldo_fisico
u_dw_cns	idw_saldos, idw_hist, idw_proy, idw_consignacion, idw_devoluciones, &
			idw_prestamo, idw_saldo_alm, idw_equivalencias, idw_oc, idw_reservacion, &
			idw_transport

end variables

forward prototypes
public subroutine wf_reset_dw ()
public function integer of_get_parametros (ref string as_doc_tipo)
public subroutine of_retrieve (string as_cod_art)
public subroutine of_reset ()
public subroutine of_asigna_dws ()
end prototypes

event ue_saveas;idw_query.Saveas()
end event

event ue_saveas_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_query, ls_file )
End If
end event

event ue_saveas_pdf();string 		ls_path, ls_file
int 			li_rc
n_cst_email	lnv_email

ls_file = idw_query.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( 	"Select File", &
   								ls_path, ls_file, "PDF", &
   								"Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( idw_query, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path &
					+ ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento ' &
					+ 'de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' &
					+ ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

public subroutine wf_reset_dw ();
tab_1.tabpage_1.dw_saldos.Reset()
tab_1.tabpage_2.dw_hist.Reset()
tab_1.tabpage_3.dw_proy.Reset()
tab_1.tabpage_4.dw_consignacion.Reset()
tab_1.tabpage_5.dw_devoluciones.Reset()
tab_1.tabpage_6.dw_prestamo.Reset()
tab_1.tabpage_7.dw_saldo_alm.Reset()
tab_1.tabpage_1.dw_saldos.Insertrow(0)


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

public subroutine of_retrieve (string as_cod_art);// Verifica si articulo existe
Long ll_count

tab_1.SelectTab(1)
dw_master.Retrieve(as_cod_art)
dw_master.ShareData(tab_1.tabpage_1.dw_saldos)

tab_1.tabpage_1.dw_saldos.Retrieve(as_cod_Art)
tab_1.tabpage_2.dw_hist.Retrieve(as_cod_Art)
tab_1.tabpage_3.dw_proy.Retrieve(as_cod_Art)
tab_1.tabpage_5.dw_devoluciones.Retrieve(as_cod_Art)
tab_1.tabpage_6.dw_prestamo.Retrieve(as_cod_Art)
tab_1.tabpage_4.dw_consignacion.Retrieve(as_cod_Art)
tab_1.tabpage_7.dw_saldo_alm.retrieve(as_cod_Art)
tab_1.tabpage_8.dw_equivalencias.retrieve(as_cod_Art)
tab_1.tabpage_9.dw_oc.retrieve(as_cod_Art)
tab_1.tabpage_10.dw_reservacion.retrieve(as_cod_Art)
tab_1.tabpage_12.dw_transport.retrieve(as_cod_Art)


end subroutine

public subroutine of_reset ();// Verifica si articulo existe
Long ll_count

tab_1.SelectTab(1)
dw_master.Reset()
tab_1.tabpage_1.dw_saldos.Reset()

tab_1.tabpage_2.dw_hist.Reset()
tab_1.tabpage_3.dw_proy.Reset()
tab_1.tabpage_5.dw_devoluciones.Reset()
tab_1.tabpage_6.dw_prestamo.Reset()
tab_1.tabpage_4.dw_consignacion.Reset()
tab_1.tabpage_7.dw_saldo_alm.Reset()
tab_1.tabpage_8.dw_equivalencias.Reset()
tab_1.tabpage_9.dw_oc.Reset()
tab_1.tabpage_10.dw_reservacion.Reset()
tab_1.tabpage_12.dw_transport.Reset()

end subroutine

public subroutine of_asigna_dws ();idw_saldos 			= tab_1.tabpage_1.dw_saldos
idw_hist				= tab_1.tabpage_2.dw_hist
idw_proy				= tab_1.tabpage_3.dw_proy
idw_consignacion 	= tab_1.tabpage_4.dw_consignacion
idw_devoluciones	= tab_1.tabpage_5.dw_devoluciones
idw_prestamo		= tab_1.tabpage_6.dw_prestamo
idw_saldo_alm		= tab_1.tabpage_7.dw_saldo_alm
idw_equivalencias	= tab_1.tabpage_8.dw_equivalencias
idw_oc				= tab_1.tabpage_9.dw_oc
idw_reservacion	= tab_1.tabpage_10.dw_reservacion
idw_transport		= tab_1.tabpage_12.dw_transport

end subroutine

on w_al508_articulos_mov.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_lista=create dw_lista
this.uo_search=create uo_search
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.uo_search
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_al508_articulos_mov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.uo_search)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

dw_lista.height  = newHeight  - dw_lista.y - 10

uo_search.width  = dw_lista.width  - uo_search.x - 10
uo_search.event ue_resize(sizetype, uo_search.width, uo_search.height)

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_saldos.width  		= tab_1.tabpage_1.width  - idw_saldos.x - 10
idw_saldos.height 		= tab_1.tabpage_1.height - idw_saldos.y - 10

idw_hist.width  			= tab_1.tabpage_2.width  - idw_hist.x - 10
idw_hist.height 			= tab_1.tabpage_2.height - idw_hist.y - 10  

idw_proy.width  			= tab_1.tabpage_3.width  - idw_proy.x - 10
idw_proy.height 			= tab_1.tabpage_3.height - idw_proy.y - 10  

idw_consignacion.width  = tab_1.tabpage_4.width - idw_consignacion.x - 10  
idw_consignacion.height = tab_1.tabpage_4.height - idw_consignacion.y - 10  

idw_devoluciones.width  = tab_1.tabpage_5.width - idw_devoluciones.x - 10  
idw_devoluciones.height = tab_1.tabpage_5.height - idw_devoluciones.y - 10  

idw_prestamo.width  		= tab_1.tabpage_6.width - idw_prestamo.x - 10  
idw_prestamo.height 		= tab_1.tabpage_6.height - idw_prestamo.y - 10  

idw_saldo_alm.width 	 	= tab_1.tabpage_7.width - idw_saldo_alm.x - 10  
idw_saldo_alm.height 	= tab_1.tabpage_7.height - idw_saldo_alm.y - 10  

idw_equivalencias.width  = tab_1.tabpage_8.width - idw_equivalencias.x - 10  
idw_equivalencias.height = tab_1.tabpage_8.height - idw_equivalencias.y - 10  

idw_oc.width  				= tab_1.tabpage_9.width - idw_oc.x - 10  
idw_oc.height 				= tab_1.tabpage_9.height - idw_oc.y - 10  

idw_reservacion.width  	= tab_1.tabpage_10.width - idw_reservacion.x - 10  
idw_reservacion.height 	= tab_1.tabpage_10.height - idw_reservacion.y - 10  

idw_transport.width  	= tab_1.tabpage_12.width - idw_transport.x - 10  
idw_transport.height 	= tab_1.tabpage_12.height - idw_transport.y - 10  

end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

of_asigna_dws()

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse


dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos

idw_saldos.SetTransObject(sqlca)
idw_hist.SetTransObject(sqlca)
idw_proy.SetTransObject(sqlca)
idw_consignacion.SetTransObject(sqlca)
idw_devoluciones.SetTransObject(sqlca)
idw_prestamo.SetTransObject(sqlca)
idw_saldo_alm.SetTransObject(sqlca)
idw_equivalencias.SetTransObject(sqlca)
idw_oc.SetTransObject(sqlca)
idw_reservacion.SetTransObject(sqlca)
idw_transport.SetTransObject(sqlca)

//--
idw_query = idw_saldos
idw_saldos.setFocus()

dw_master.event ue_insert()

wf_reset_dw()



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

type dw_lista from u_dw_abc within w_al508_articulos_mov
integer y = 104
integer width = 1673
integer height = 2368
integer taborder = 20
string dataobject = "d_lista_articulos_tbl"
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event ue_output;call super::ue_output;String ls_cod_art

ls_cod_art = this.object.cod_art [al_row]

of_retrieve(ls_cod_art)
end event

type uo_search from n_cst_search within w_al508_articulos_mov
integer width = 1673
integer taborder = 50
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_filtro, ls_cod_art

ls_filtro = this.of_get_filtro()
dw_lista.retrieve(ls_filtro)


if dw_lista.RowCount() > 0 then
	dw_lista.SelectRow(0, false)
	dw_lista.SelectRow(1, true)
	
	ls_cod_art = dw_lista.object.cod_art [1]
	dw_master.Retrieve(ls_cod_art)
	
	of_retrieve(ls_cod_art)
else
	of_reset()
end if
end event

type tab_1 from tab within w_al508_articulos_mov
integer x = 1691
integer y = 908
integer width = 3557
integer height = 1376
integer taborder = 10
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
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_4 tabpage_4
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_9 tabpage_9
tabpage_10 tabpage_10
tabpage_12 tabpage_12
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_4=create tabpage_4
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.tabpage_9=create tabpage_9
this.tabpage_10=create tabpage_10
this.tabpage_12=create tabpage_12
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_4,&
this.tabpage_7,&
this.tabpage_8,&
this.tabpage_9,&
this.tabpage_10,&
this.tabpage_12}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_4)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
destroy(this.tabpage_9)
destroy(this.tabpage_10)
destroy(this.tabpage_12)
end on

event selectionchanging;String 	ls_cod_art
Long 		ll_row

of_asigna_dws()

if dw_lista.RowCount() > 0 then
	ll_row = dw_lista.GetSelectedRow(0)
	
	if ll_row > 0 then
		
		ls_cod_art = dw_lista.object.cod_art [ll_row]
		 
		CHOOSE CASE newindex
			CASE 2
				idw_hist.Retrieve(ls_cod_art)
				idw_hist.setFocus()
				idw_query = idw_hist
			CASE 3
				idw_proy.Retrieve(ls_cod_art)
				idw_proy.setFocus()
				idw_query = idw_proy
			CASE 4
				idw_consignacion.Retrieve(ls_cod_art)
				idw_consignacion.setFocus()
				idw_query = idw_consignacion
			CASE 5
				idw_devoluciones.Retrieve(ls_cod_art)
				idw_devoluciones.setFocus()
				idw_query = idw_devoluciones
			CASE 6
				idw_prestamo.Retrieve(ls_cod_art)
				idw_prestamo.setFocus()
				idw_query = idw_prestamo
			CASE 7
				idw_saldo_alm.retrieve(ls_cod_art)
				idw_saldo_alm.setFocus()
				idw_query = idw_saldo_alm
			CASE 8
				idw_equivalencias.retrieve(ls_cod_art)
				idw_equivalencias.setFocus()
				idw_query = idw_equivalencias
			CASE 9
				idw_oc.retrieve(ls_cod_art, gnvo_app.is_doc_oc)
				idw_oc.setFocus()
				idw_query = idw_oc
			CASE 10
				idw_reservacion.retrieve(ls_cod_art)
				idw_reservacion.setFocus()
				idw_query = idw_reservacion
			CASE 12
				idw_transport.retrieve(ls_cod_art)
				idw_transport.setFocus()
				idw_query = idw_transport
		END CHOOSE
	end if
end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
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
integer width = 3255
integer height = 1156
boolean bringtotop = true
string dataobject = "d_cns_art_saldos_ff"
boolean livescroll = false
borderstyle borderstyle = styleraised!
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
integer height = 1176
long backcolor = 79741120
string text = "Mov.Historico"
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
integer width = 2830
integer height = 1120
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
integer height = 1176
long backcolor = 79741120
string text = "Mov.Proyectado"
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
integer width = 1477
integer height = 552
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_movimiento_proy_tbl"
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

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
long backcolor = 79741120
string text = "Devoluciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
dw_devoluciones dw_devoluciones
end type

on tabpage_5.create
this.dw_devoluciones=create dw_devoluciones
this.Control[]={this.dw_devoluciones}
end on

on tabpage_5.destroy
destroy(this.dw_devoluciones)
end on

type dw_devoluciones from u_dw_cns within tabpage_5
integer width = 1687
integer height = 656
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_devoluciones_tbl"
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

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row( this)
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
long backcolor = 79741120
string text = "Prestamos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
dw_prestamo dw_prestamo
end type

on tabpage_6.create
this.dw_prestamo=create dw_prestamo
this.Control[]={this.dw_prestamo}
end on

on tabpage_6.destroy
destroy(this.dw_prestamo)
end on

type dw_prestamo from u_dw_cns within tabpage_6
integer width = 2985
integer height = 692
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_articulo_prestamo_tbl"
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

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row( this)
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
long backcolor = 79741120
string text = "Consignaciones"
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
integer width = 2167
integer height = 768
boolean bringtotop = true
string dataobject = "d_cns_consignacion"
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

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row( this)
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
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

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
long backcolor = 79741120
string text = "Equivalencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_equivalencias dw_equivalencias
end type

on tabpage_8.create
this.dw_equivalencias=create dw_equivalencias
this.Control[]={this.dw_equivalencias}
end on

on tabpage_8.destroy
destroy(this.dw_equivalencias)
end on

type dw_equivalencias from u_dw_cns within tabpage_8
integer width = 2661
integer height = 1240
integer taborder = 20
string dataobject = "d_articulo_equivalencias_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; ii_ck[1] = 1
end event

type tabpage_9 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
long backcolor = 79741120
string text = "Ultimas OC"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_oc dw_oc
end type

on tabpage_9.create
this.dw_oc=create dw_oc
this.Control[]={this.dw_oc}
end on

on tabpage_9.destroy
destroy(this.dw_oc)
end on

type dw_oc from u_dw_cns within tabpage_9
integer width = 3461
integer height = 1084
integer taborder = 20
string dataobject = "d_articulo_ultimas_oc_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;if row= 0 then return
str_parametros lstr_rep
w_rpt_preview lw_1

if lower(dwo.name) = 'nro_doc' then
	lstr_rep.dw1 	  = 'd_rpt_orden_compra_cab'
	lstr_rep.titulo  = 'Previo de Orden de compra'
	lstr_rep.string1 = this.object.cod_origen[row]
	lstr_rep.string2 = this.object.nro_doc	  [row]
	lstr_rep.tipo	  = '1S2S'	
	
	OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)			
end if
end event

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row( this)
end event

type tabpage_10 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
long backcolor = 79741120
string text = "Reservaciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_reservacion dw_reservacion
end type

on tabpage_10.create
this.dw_reservacion=create dw_reservacion
this.Control[]={this.dw_reservacion}
end on

on tabpage_10.destroy
destroy(this.dw_reservacion)
end on

type dw_reservacion from u_dw_cns within tabpage_10
integer width = 2546
integer height = 1132
integer taborder = 20
string dataobject = "d_cns_articulo_reservacion"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row( this)
end event

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type tabpage_12 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3520
integer height = 1176
long backcolor = 79741120
string text = "Mov Transportados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_transport dw_transport
end type

on tabpage_12.create
this.dw_transport=create dw_transport
this.Control[]={this.dw_transport}
end on

on tabpage_12.destroy
destroy(this.dw_transport)
end on

type dw_transport from u_dw_cns within tabpage_12
integer width = 3410
integer height = 1196
integer taborder = 20
string dataobject = "d_cns_articulo_transito_grd"
borderstyle borderstyle = styleraised!
end type

event rowfocuschanged;call super::rowfocuschanged;f_Select_current_row( this)
end event

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type dw_master from u_dw_abc within w_al508_articulos_mov
integer x = 1691
integer y = 4
integer width = 3543
integer height = 888
integer taborder = 20
string dataobject = "d_cns_art_especializado_ff"
boolean hscrollbar = false
boolean vscrollbar = false
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

