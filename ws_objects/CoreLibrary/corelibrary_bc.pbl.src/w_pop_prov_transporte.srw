$PBExportHeader$w_pop_prov_transporte.srw
forward
global type w_pop_prov_transporte from w_cns
end type
type cb_aceptar from commandbutton within w_pop_prov_transporte
end type
type cb_cancelar from commandbutton within w_pop_prov_transporte
end type
type st_1 from statictext within w_pop_prov_transporte
end type
type uo_search from n_cst_search within w_pop_prov_transporte
end type
type dw_vehiculos from u_dw_abc within w_pop_prov_transporte
end type
type dw_master from u_dw_cns within w_pop_prov_transporte
end type
end forward

global type w_pop_prov_transporte from w_cns
integer width = 3941
integer height = 1972
string title = "Proveedores de Transporte"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_filtro ( string as_filtro )
event ue_aceptar ( )
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
st_1 st_1
uo_search uo_search
dw_vehiculos dw_vehiculos
dw_master dw_master
end type
global w_pop_prov_transporte w_pop_prov_transporte

type variables
str_prov_transporte 		istr_prov_transporte
String 						is_opcion, is_par, is_campo, is_almacen
end variables

forward prototypes
public function string wf_condicion_sql (string as_cadena)
public subroutine of_carga_datos ()
end prototypes

event ue_filtro(string as_filtro);dw_master.Retrieve(as_filtro)
end event

event ue_aceptar();if dw_master.RowCount() = 0 then
	cb_aceptar.enabled = false
	return
end if

if dw_vehiculos.RowCount() = 0 or dw_vehiculos.getRow() = 0 then
	
	MessageBox('Informacion', &
				  'No hay ningun vehiculo o no hay ninguno seleccionado. Por favor confirme!', &
				  StopSign!)
				  
	return
end if

istr_prov_transporte.b_return = true

/*
global type str_prov_transporte from structure
	string		proveedor
	string		nom_proveedor
	string		direccion
	string		cert_insc_mtc
	string		marca
	string		modelo
	string		color
	string		desc_color
	string		tipo_carroceria
	string		desc_carroceria
	string		nro_autor_especial
	string		cod_entidad_autorizada
	string		desc_entidad_autorizada
	boolean		b_return
	string		nro_placa
end type
*/

istr_prov_transporte.proveedor 					= dw_master.object.proveedor 						[dw_master.GetRow()]
istr_prov_transporte.nom_proveedor				= dw_master.object.nom_proveedor 				[dw_master.GetRow()]
istr_prov_transporte.direccion					= dw_master.object.direccion 						[dw_master.GetRow()]
istr_prov_transporte.nro_autor_especial 		= dw_master.object.nro_autor_especial 			[dw_master.GetRow()]
istr_prov_transporte.cod_entidad_autorizada	= dw_master.object.cod_entidad_autorizada 	[dw_master.GetRow()]
istr_prov_transporte.desc_entidad_autorizada	= dw_master.object.desc_entidad_autorizada 	[dw_master.GetRow()]


istr_prov_transporte.cert_insc_mtc 		= dw_vehiculos.object.cert_insc_mtc 	[dw_vehiculos.GetRow()]
istr_prov_transporte.nro_placa			= dw_vehiculos.object.nro_placa 			[dw_vehiculos.GetRow()]
istr_prov_transporte.marca					= dw_vehiculos.object.marca 				[dw_vehiculos.GetRow()]
istr_prov_transporte.modelo				= dw_vehiculos.object.modelo 				[dw_vehiculos.GetRow()]
istr_prov_transporte.color 				= dw_vehiculos.object.color 				[dw_vehiculos.GetRow()]
istr_prov_transporte.desc_color			= dw_vehiculos.object.desc_color 		[dw_vehiculos.GetRow()]
istr_prov_transporte.tipo_carroceria	= dw_vehiculos.object.tipo_carroceria 	[dw_vehiculos.GetRow()]
istr_prov_transporte.desc_carroceria	= dw_vehiculos.object.desc_carroceria 	[dw_vehiculos.GetRow()]


CloseWithReturn( this, istr_prov_transporte)

end event

public function string wf_condicion_sql (string as_cadena);//****************************************************************************************//
// Permite Crear el Criterio de Filtro dentro del Where
//****************************************************************************************//
//String  ls_descripcion
//
//ls_descripcion = "'"+TRIM(dw_1.object.campo[1])+'%'+"'"
//if Pos(UPPER(dw_master.GetSQLSelect()),'WHERE',1) > 0 then
//	as_cadena = ' AND ( '+ as_cadena +' LIKE '+ls_descripcion+' )'
//ELSE
//	as_cadena = ' WHERE ( ' + as_cadena +' LIKE '+ls_descripcion+' )' 
//END IF	
//
Return as_cadena
end function

public subroutine of_carga_datos ();//Decimal ld_stock_disp
//Long ll_row
//
//ll_row = dw_detail_2.getrow( )
//
//if ll_row=0 then
//	MessageBox('Aviso', 'No hay stock disponible en ningun almacen para este articulo, por favor verifique')
//	return
//end if
//	
//ld_stock_disp = dw_detail_2.object.sldo_total[ll_row]
//if ld_stock_disp = 0 then
//	MessageBox('Aviso', 'Se esta seleccionando un almacen en el cual no hay stock disponible, por favor verifique')
//	return
//end if
//	
//ist_datos.field_ret[1] = dw_detail_2.object.cod_art[ll_row]
//ist_datos.field_ret[2] = dw_detail_2.object.desc_Art[ll_row]
//ist_datos.field_ret[3] = dw_detail_2.object.und[ll_row]
//ist_datos.field_ret[4] = String(dw_detail_2.object.costo_ult_compra[ll_row])	
//ist_datos.field_ret[5] = String(dw_detail_2.object.dias_reposicion [ll_row])
//ist_datos.field_ret[6] = String(dw_detail_2.object.dias_rep_import [ll_row])
//ist_datos.field_ret[7] = String(dw_detail_2.object.cnta_prsp_ingreso [ll_row])
//ist_datos.field_ret[8] = dw_detail_2.object.almacen[ll_row]
//ist_datos.field_ret[9] = String(ld_stock_disp)
//ist_datos.field_ret[10] = String(dw_detail_2.object.precio_minorista[ll_row])
//
end subroutine

event ue_open_pre;str_parametros lstr_param

try 
	lstr_param = Message.PowerObjectParm
	
	dw_master.SetTransObject(sqlca)
	dw_vehiculos.SetTransObject(sqlca)
	
	uo_search.of_set_dw_cns(dw_master)
	
	this.event dynamic ue_filtro( '%%' )
	
	uo_search.setFocus()
	uo_search.set_focus_dw( )

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al abrir el listado de Proveedor de Transporte")
	
finally
	/*statementBlock*/
end try

end event

on w_pop_prov_transporte.create
int iCurrent
call super::create
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
this.st_1=create st_1
this.uo_search=create uo_search
this.dw_vehiculos=create dw_vehiculos
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.uo_search
this.Control[iCurrent+5]=this.dw_vehiculos
this.Control[iCurrent+6]=this.dw_master
end on

on w_pop_prov_transporte.destroy
call super::destroy
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
destroy(this.st_1)
destroy(this.uo_search)
destroy(this.dw_vehiculos)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width		= newwidth  - dw_master.x - 10

dw_vehiculos.width		= newwidth  - dw_vehiculos.x - 10
dw_vehiculos.height		= newheight - dw_vehiculos.y - 10
st_1.width					= dw_vehiculos.width


end event

type cb_aceptar from commandbutton within w_pop_prov_transporte
integer x = 2939
integer width = 283
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Aceptar"
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type cb_cancelar from commandbutton within w_pop_prov_transporte
integer x = 3223
integer width = 283
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;istr_prov_transporte.b_Return = false
CloseWithReturn( parent, istr_prov_transporte)

end event

type st_1 from statictext within w_pop_prov_transporte
integer y = 1308
integer width = 3602
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Vehiculos Autorizados"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_search from n_cst_search within w_pop_prov_transporte
event destroy ( )
integer taborder = 30
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

parent.event dynamic ue_filtro( ls_buscar)
end event

type dw_vehiculos from u_dw_abc within w_pop_prov_transporte
integer y = 1392
integer width = 3602
integer height = 472
integer taborder = 20
string dataobject = "d_sel_vehiculos_transporte_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular' 
end event

type dw_master from u_dw_cns within w_pop_prov_transporte
integer y = 100
integer width = 3602
integer height = 1196
boolean bringtotop = true
string dataobject = "d_sel_proveedor_transporte_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

f_Select_current_row(this)

this.event ue_output(currentrow)
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	parent.event ue_aceptar( )
end if
end event

event ue_output;call super::ue_output;dw_vehiculos.retrieve( this.object.proveedor	[al_row])
dw_vehiculos.SelectRow(0, False)

cb_aceptar.enabled = true
end event

event clicked;call super::clicked;if row > 0 then
	this.event ue_output(row)
end if
end event

