$PBExportHeader$w_al329_despacho_simplificado_popup.srw
forward
global type w_al329_despacho_simplificado_popup from w_abc
end type
type cb_cancelar from commandbutton within w_al329_despacho_simplificado_popup
end type
type cb_aceptar from commandbutton within w_al329_despacho_simplificado_popup
end type
type tab_1 from tab within w_al329_despacho_simplificado_popup
end type
type tabpage_1 from userobject within tab_1
end type
type dw_master from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_master dw_master
end type
type tabpage_2 from userobject within tab_1
end type
type uo_search from n_cst_search within tabpage_2
end type
type dw_pallets1 from u_dw_abc within tabpage_2
end type
type pb_1 from picturebutton within tabpage_2
end type
type pb_2 from picturebutton within tabpage_2
end type
type dw_pallets2 from u_dw_abc within tabpage_2
end type
type dw_detail from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
uo_search uo_search
dw_pallets1 dw_pallets1
pb_1 pb_1
pb_2 pb_2
dw_pallets2 dw_pallets2
dw_detail dw_detail
end type
type tabpage_3 from userobject within tab_1
end type
type dw_packing_list from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_packing_list dw_packing_list
end type
type tab_1 from tab within w_al329_despacho_simplificado_popup
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_al329_despacho_simplificado_popup from w_abc
integer width = 4567
integer height = 2444
string title = "[AL329] Despacho Simplificado"
string menuname = "m_salir"
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
tab_1 tab_1
end type
global w_al329_despacho_simplificado_popup w_al329_despacho_simplificado_popup

type variables
String 			is_tipo_mov_dev, is_cencos_vta, is_clase_mov, is_solicita_ref

u_dw_abc 		idw_master, idw_detail, idw_pallets1, idw_pallets2, idw_packing_list

PictureButton	ipb_1, ipb_2

n_cst_utilitario 		invo_utility
n_Cst_contabilidad	invo_contabilidad
n_cst_search			iuo_search
end variables

forward prototypes
public subroutine of_asigna_dws ()
public subroutine of_referencia_mov (string as_tipo_mov)
public subroutine of_mov_devol_alm (string as_tipo_mov)
public function integer of_set_numera ()
end prototypes

public subroutine of_asigna_dws ();idw_master  		= tab_1.tabpage_1.dw_master
idw_detail			= tab_1.tabpage_2.dw_detail
idw_pallets1		= tab_1.tabpage_2.dw_pallets1
idw_pallets2		= tab_1.tabpage_2.dw_pallets2
idw_packing_list 	= tab_1.tabpage_3.dw_packing_list

ipb_1				= tab_1.tabpage_2.pb_1
ipb_2				= tab_1.tabpage_2.pb_2
iuo_search		= tab_1.tabpage_2.uo_search
end subroutine

public subroutine of_referencia_mov (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/
String 	ls_almacen, ls_tipo_doc, ls_nro_doc, ls_opcion, ls_tipo_mov
Date 		ld_fecha
Long		ll_row_mas, ll_factor_sldo_total
str_parametros lstr_param, lstr_datos

ll_row_mas = idw_master.GetRow()
if ll_row_mas <= 0 then return

ls_almacen 	 = idw_master.object.almacen [ll_row_mas]	
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen', StopSign!)
	RETURN
END IF

// Si el Tipo de Movimiento es una venta a Terceros entonces 
// Extraigo el Centro de Costo del Vale de Salida
if as_tipo_mov = gnvo_app.almacen.is_oper_vnta_terc then
	select cencos_vale_salida
	  into :is_cencos_vta
	  from logparam
	 where reckey = '1';
end if

// SI existe detalle y ya tiene seleccionado un documento
// Entonces lo selecciono
if NOT IsNull(idw_master.object.tipo_refer[ll_row_mas]) and &
	trim(idw_master.object.tipo_refer[ll_row_mas]) <> '' and &
	idw_pallets2.RowCount() <> 0 then 
	
	ls_tipo_doc = idw_master.object.tipo_refer[ll_row_mas] 
else
	ls_tipo_doc = ''
end if

if NOT IsNull(idw_master.object.nro_refer[ll_row_mas]) and &
	trim(idw_master.object.nro_refer[ll_row_mas]) <> '' and &
	idw_pallets2.RowCount() <> 0 then 
	
	ls_nro_doc = idw_master.object.nro_refer[ll_row_mas]
else
	ls_nro_doc = ''
end if

ls_tipo_mov = idw_master.object.tipo_mov [1]
	
//Obtengo el factor
select factor_sldo_total	
	into :ll_factor_sldo_total
from articulo_mov_tipo amt
where amt.tipo_mov = :ls_tipo_mov;

// Evalua campos
IF trim(ls_tipo_mov) = 'S02'  THEN	// ORDEN DE VENTAS
	
	//Movimiento para Orden de Traslado
	lstr_param.dw1      		= 'd_sel_ov_pendientes'
	lstr_param.titulo    	= 'Ordenes de Ventas Pendientes '
	lstr_param.tipo		 	= '1S'     // con un parametro del tipo string
	lstr_param.string1   	= ls_almacen
	lstr_param.opcion    	= 14
	lstr_param.dw_m			= idw_master
		
	OpenWithParm( w_abc_seleccion, lstr_param)
	
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.titulo <> 's' then return
	
	ls_nro_doc 	= idw_master.object.nro_refer [1]
	ls_almacen	= idw_master.object.almacen [1]
	
	idw_detail.Retrieve(ls_nro_doc, ls_almacen)
	
END IF

end subroutine

public subroutine of_mov_devol_alm (string as_tipo_mov);/*
   Funcion que muestra ayuda segun tipo de movimiento
*/
String 	ls_almacen, ls_tipo_doc, ls_nro_doc, ls_nro_vale
Date 		ld_fecha1, ld_fecha2
Long		ll_row_mas
str_parametros lstr_param

ll_row_mas = idw_master.GetRow()
if ll_row_mas <= 0 then return

//Obtengo información de la cabecera
ls_almacen 	= idw_master.object.almacen 		[ll_row_mas]	
ls_nro_vale	= idw_master.object.nro_doc_int 	[ll_row_mas]	

//Valido código de almacen
IF Isnull(ls_almacen) OR Trim(ls_almacen) = '' THEN 
	Messagebox('Aviso','Debe Seleccionar Algun Almacen', StopSign!)
	RETURN
END IF

if IsNull(ls_nro_vale) or trim(ls_nro_vale) = '' then
	//Primero obtengo el rango de fechas de los movimientos de almacen
	Open(w_get_rango_Fechas)
	
	if IsNull(Message.PowerObjectParm) or &
		not IsValid(Message.PowerObjectParm) then return
		
	lstr_param = Message.PowerObjectParm
	if lstr_param.titulo = 'n' then return
else
	lstr_param.string1 = ls_nro_vale
end if

	
//Ahora le agrego el tipo de movimiento y el almacen
lstr_param.tipo_mov_dev	= is_tipo_mov_dev
lstr_param.tipo	  	= 'DEVOL_ALM'
lstr_param.dw_or_m 	= idw_master
lstr_param.dw_or_d   = idw_detail	
lstr_param.w1			= this
lstr_param.titulo    = 'Movimientos de Almacen'
lstr_param.dw_master = 'd_abc_vale_mov_devol_tbl'      
lstr_param.dw1       = 'd_abc_articulo_mov_devol_tbl'  
lstr_param.opcion    = 6
	
OpenWithParm( w_abc_seleccion_md, lstr_param)


if Not IsValid(Message.Powerobjectparm) or IsNull(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectparm
if lstr_param.titulo = 'n' then return

//idc_cant_proc 		 = lstr_param.cant_procesada
//idc_cant_proc_und2 = lstr_param.cant_proc_und2
end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if idw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_vale_mov
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE NUM_VALE_MOV IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_vale_mov(origen, ult_nro)
		values( :gs_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_vale_mov
	where origen = :gs_origen for update;
	
	update num_vale_mov
		set ult_nro = ult_nro + 1
	where origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje, StopSign!)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	idw_master.object.nro_vale[idw_master.getrow()] = ls_next_nro
	idw_master.ii_update = 1
else
	ls_next_nro = idw_master.object.nro_vale[idw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to idw_detail.RowCount()
	idw_detail.object.nro_vale[ll_j] = ls_next_nro
next

return 1
end function

on w_al329_despacho_simplificado_popup.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancelar
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.tab_1
end on

on w_al329_despacho_simplificado_popup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.tab_1)
end on

event resize;call super::resize;of_Asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_master.width  = tab_1.tabpage_1.width  - idw_master.x - 10
idw_master.height  = tab_1.tabpage_1.height  - idw_master.y - 10

idw_detail.width  = tab_1.tabpage_2.width  - idw_detail.x - 10


idw_pallets1.height  = tab_1.tabpage_2.height  - idw_pallets1.y - 10
idw_pallets2.height  = tab_1.tabpage_2.height  - idw_pallets2.y - 10

ipb_1.x = tab_1.tabpage_2.width / 2 - ipb_1.width / 2
ipb_2.x = ipb_1.x

idw_pallets1.width  = ipb_1.x  - idw_pallets1.x - 10
idw_pallets2.x  	  = ipb_1.x  + ipb_1.width + 10
idw_pallets2.width  = tab_1.tabpage_2.width   - idw_pallets2.x - 10

iuo_search.width 	= tab_1.tabpage_2.width - 10 - iuo_search.x
iuo_Search.event ue_resize(sizetype, tab_1.tabpage_2.width - 10 - iuo_search.x, newheight)

idw_packing_list.width  = tab_1.tabpage_3.width  - idw_packing_list.x - 10
idw_packing_list.height  = tab_1.tabpage_3.height  - idw_packing_list.y - 10

//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

invo_contabilidad = create n_cst_contabilidad

event ue_insert()

iuo_search.of_set_dw(idw_pallets1)
end event

event ue_insert;call super::ue_insert;idw_master.event ue_insert()
end event

event ue_aceptar;call super::ue_aceptar;//Evento cuando se hace click en el boton aceptar
end event

event ue_update;call super::ue_update;
//Variables para vale_mov
String 	ls_nro_Vale, ls_almacen, ls_tipo_mov, ls_proveedor, ls_tipo_doc_int, ls_nro_doc_int, ls_tipo_doc_ext, &
			ls_nro_doc_ext, ls_nom_receptor, ls_origen_refer, ls_tipo_refer, ls_nro_refer, ls_observaciones

//Variables para articulo_mov
String	ls_cod_Art, ls_nro_pallet, ls_nro_lote, ls_anaquel, ls_fila, ls_columna, ls_org_amp, ls_cencos, &
			ls_cnta_prsp, ls_matriz
Long		ll_nro_amp

//Otras variables
String	ls_mensaje
Long		ll_i

try 
	if idw_master.getRow() = 0 then return
	
	if idw_pallets2.RowCount() = 0 then return
	
	//Primer paso obtengo el numerador del vale_mov
	ls_nro_vale	= idw_master.object.nro_Vale	[1]
	
	if is_action = 'new' or IsNull(ls_nro_Vale) or trim(ls_nro_vale) = '' then
		//Si es nuevo entonces genero un nuevo numero
		ls_nro_vale = gnvo_App.almacen.of_nro_vale_mov( gs_origen )
		idw_master.object.nro_Vale	[1] = ls_nro_vale
	end if
	
	if IsNull(ls_nro_Vale) or trim(ls_nro_Vale) = '' then return
	
	//Obtengo los datos ingresados en el panel
	ls_almacen 			= idw_master.object.almacen 			[1]
	ls_tipo_mov 		= idw_master.object.tipo_mov 			[1]
	ls_proveedor 		= idw_master.object.cliente	 		[1]
	ls_nom_receptor 	= idw_master.object.nom_receptor 	[1]
	ls_origen_refer 	= idw_master.object.origen_refer 	[1]
	ls_tipo_refer 		= idw_master.object.tipo_refer 		[1]
	ls_nro_refer 		= idw_master.object.nro_refer			[1]
	ls_tipo_doc_ext 	= idw_master.object.tipo_doc_ext 	[1]
	ls_nro_doc_ext 	= idw_master.object.nro_Doc_ext 		[1]
	ls_tipo_doc_int 	= idw_master.object.tipo_doc_int 	[1]
	ls_nro_doc_int 	= idw_master.object.nro_Doc_int 		[1]
	ls_observaciones 	= idw_master.object.observaciones 	[1]
	
	//Inserto la cabecera el vale_mov
	if is_action = 'new' then
		insert into vale_mov(
				cod_origen, nro_Vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, proveedor, 
				nom_receptor, origen_refer, tipo_refer, nro_Refer, observaciones, 
				tipo_doc_int, nro_doc_int, tipo_doc_ext, nro_doc_ext)
		values(
				:gs_origen, :ls_nro_Vale, :ls_almacen, '1', sysdate, :ls_tipo_mov, :gs_user, :ls_proveedor,
				:ls_nom_receptor, :ls_origen_refer, :ls_tipo_refer, :ls_nro_refer, :ls_observaciones, 
				:ls_tipo_doc_int, :ls_nro_doc_int, :ls_tipo_doc_ext, :ls_nro_doc_ext);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al insertar registro en tabla VALE_MOV. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
	end if
	
	for ll_i = 1 to idw_pallets2.RowCount()
		//Obtengo los variables necesarios
		ls_cod_Art		= idw_pallets2.object.cod_art 		[ll_i]
		ls_nro_pallet	= idw_pallets2.object.nro_pallet 	[ll_i]
		ls_nro_lote		= idw_pallets2.object.nro_lote	 	[ll_i]
		ls_anaquel		= idw_pallets2.object.anaquel 		[ll_i]
		ls_fila			= idw_pallets2.object.fila 			[ll_i]
		ls_columna		= idw_pallets2.object.columna 		[ll_i]
		ls_org_amp		= idw_pallets2.object.org_amp 		[ll_i]
		ll_nro_amp		= Long(idw_pallets2.object.nro_amp 	[ll_i])
		ls_cencos		= gnvo_app.of_get_parametro("CENCOS_VTA_DEFAULT", "70101002")
		ls_cnta_prsp	= gnvo_app.of_get_parametro("CNTA_PRSP_VTA_DEFAULT", "VENTAEXP01")
		ls_matriz		= invo_contabilidad.of_Get_matriz(ls_tipo_mov, ls_cencos, ls_cod_art)
		
		insert into articulo_mov(
			cod_origen, origen_mov_proy, nro_mov_proy, nro_vale, flag_estado, cod_art, cant_procesada,
       	precio_unit, decuento, impuesto, cod_moneda, cencos, cnta_prsp,
       	matriz, nro_lote, cant_proc_und2, fec_registro, anaquel, fila, 
			columna, cus, nro_pallet)
		select 	:gs_origen, :ls_org_amp, :ll_nro_amp, :ls_nro_vale, '1', vw.cod_art, vw.saldo,
					0, 0, 0, :gnvo_app.is_soles, :ls_cencos, :ls_cnta_prsp,
					:ls_matriz, vw.nro_lote, vw.saldo_und2, sysdate, vw.anaquel, vw.fila, 
					vw.columna, vw.cus, vw.nro_pallet
		  from vw_alm_saldo_pallet vw
		 where vw.almacen		= :ls_almacen
		   and vw.anaquel		= :ls_anaquel
			and vw.fila			= :ls_fila
			and vw.columna		= :ls_columna
			and vw.cod_Art		= :ls_cod_art
			and vw.nro_pallet	= :ls_nro_pallet
			and vw.nro_lote	= :ls_nro_lote
			and vw.saldo	   > 0;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al insertar registro en tabla ARTICULO_MOV. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
	
	next
	
	
	//Guardo los cambios requeridos
	commit;
	
	//HAgo un retrieve
	ls_nro_refer = idw_master.object.nro_refer 	[1]
	ls_almacen	 = idw_master.object.almacen 		[1]
	
	idw_detail.Retrieve(ls_nro_refer, ls_almacen)
	
	if idw_detail.RowCount() > 0 then
		idw_detail.SetRow(1)
		idw_detail.ScrollToRow(1)
		idw_detail.SelectRow(0, false)
		idw_detail.SelectRow(1, true)
		
		idw_detail.event ue_output( 1)
	else
		idw_pallets1.Reset()
	end if
	
	//Recupero los datos del paking List
	idw_packing_list.Retrieve(ls_nro_Vale)
	
	//Elimino los registros seleccionados
	idw_pallets2.Reset()
	is_Action = 'open'
	
	MessageBox('Aviso', 'Datos Guardados Satisfactoriamente', Information!)
	
	

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al momento de guardar despacho simplificado")
	
finally
	/*statementBlock*/
end try

end event

event closequery;call super::closequery;destroy invo_contabilidad
end event

type cb_cancelar from commandbutton within w_al329_despacho_simplificado_popup
integer x = 416
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_aceptar from commandbutton within w_al329_despacho_simplificado_popup
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_update( )

end event

type tab_1 from tab within w_al329_despacho_simplificado_popup
integer y = 116
integer width = 4448
integer height = 2028
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4411
integer height = 1900
long backcolor = 79741120
string text = "Cabecera"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_master dw_master
end type

on tabpage_1.create
this.dw_master=create dw_master
this.Control[]={this.dw_master}
end on

on tabpage_1.destroy
destroy(this.dw_master)
end on

type dw_master from u_dw_abc within tabpage_1
integer width = 4361
integer height = 1768
string dataobject = "d_abc_despacho_simpilificado_cab_ff"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_data2, ls_factor_saldo_total, ls_mensaje
Long		ll_count

this.AcceptText()

choose case lower(as_columna)
		
	case "almacen"
		select count(*)
			into :ll_count
		from almacen_user
		where cod_usr = :gs_user;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			gnvo_app.of_mensaje_error('Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje)
			return
		end if
		
		if ll_count = 0 then
			ls_sql = "SELECT al.almacen AS CODIGO_almacen, " &
					  + "al.desc_almacen AS descripcion_almacen, " &
					  + "al.flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen al, " &
					  + "almacen_tipo_mov l " &
					  + "where al.almacen = l.almacen " & 
					  + "and al.cod_origen = '" + gs_origen + "' " &
					  + "and l.tipo_mov = '" + gnvo_app.almacen.is_oper_vnta_terc + "' " &
					  + "and al.flag_estado = '1' " &
					  + "and al.flag_tipo_almacen <> 'O' " &
					  + "order by al.almacen " 
		else
			ls_sql = "SELECT al.almacen AS CODIGO_almacen, " &
					  + "al.desc_almacen AS descripcion_almacen, " &
					  + "al.flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen al, " &
					  + "     almacen_user au, " &
					  + "	 	 almacen_tipo_mov l " &
					  + "where al.almacen = au.almacen " &
					  + "  and al.almacen = l.almacen " &
					  + "  and l.tipo_mov = '" + gnvo_app.almacen.is_oper_vnta_terc + "' " &
					  + "  and au.cod_usr = '" + gs_user + "'" &
					  + "  and al.cod_origen = '" + gs_origen + "' " &
					  + "  and al.flag_estado = '1' " &
					  + "  and al.flag_tipo_almacen <> 'O' " &
					  + "order by al.almacen " 
		end if			
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.almacen				[al_row] = ls_codigo
			this.object.desc_almacen		[al_row] = ls_data
			this.object.flag_tipo_almacen	[al_row] = ls_data2
			this.ii_update = 1
		end if
		
		return
	
	case "vendedor"

		ls_sql = "select t.cod_usr as codigo_vendedor, " &
				 + "t.nombre as nombre_vendedor " &
				 + "from usuario t, " &
				 + "vendedor v " &
				 + "where t.cod_usr = v.vendedor " &
				 + "  and t.flag_estado = '1' " &
				 + "  and v.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.vendedor			[al_row] = ls_codigo
			this.object.nom_vendedor	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_mov"
		ls_almacen = this.object.almacen[al_row]
		
		if IsNull(ls_almacen) or ls_almacen = '' then
			MessageBox('Aviso', 'No ha ingresado el almacen', StopSign!)
			this.SetColumn('almacen')
			return
		end if
		
		ls_sql = "select a.tipo_mov as codigo_tipo_mov, " &
				 + "a.desc_tipo_mov as descripcion_tipo_mov, " &
				 + "a.tipo_mov_dev as tipo_mov_devolucion, " &
				 + "a.factor_sldo_total as factor_saldo_total " &
				 + "from articulo_mov_tipo a, " &
				 + "almacen_tipo_mov b " &
				 + "where a.tipo_mov = b.tipo_mov " &
				 + "and a.flag_estado = '1' " &
				 + "and nvl(a.factor_sldo_consig,0) = 0 " &
				 + "and nvl(a.factor_sldo_pres,0) = 0 " &
				 + "and nvl(a.factor_sldo_dev,0) = 0 " &
				 + "and nvl(a.flag_ajuste_valorizacion,'0') = '0' " &
 				 + "and b.almacen = '" + ls_almacen + "' " &
				 + "order by a.tipo_mov"
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, is_tipo_mov_dev, ls_factor_saldo_total, '2') then
			
			this.object.tipo_mov  [al_row] = ls_codigo
			
			if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
				if is_tipo_mov_dev = ls_codigo then
					Messagebox('Aviso','Tipo de movimiento no puede ser devolucion de si mismo ' &
						+ '~r~nTipo de Mov	 : ' + ls_codigo &
						+ '~r~nTipo de Mov Dev: ' + is_tipo_mov_dev )
						
					this.Object.tipo_mov				[al_row] = gnvo_app.is_null
					this.object.desc_tipo_mov 		[al_row] = gnvo_app.is_null
					this.object.factor_sldo_total [al_row] = gnvo_app.il_null
					this.setcolumn( "tipo_mov" )
					this.setfocus()
					RETURN 
				end if
			end if
		
			// Evalua datos segun tipo de mov.
//			if of_tipo_mov(ls_codigo)  = 0 then 
//				this.object.tipo_mov 		[al_row] = gnvo_app.is_null
//				this.object.desc_tipo_mov 	[al_row] = gnvo_app.is_null
//				return 
//			end if
			
			this.object.tipo_mov				[al_row] = ls_codigo
			this.object.desc_tipo_mov		[al_row] = ls_data
			this.object.factor_sldo_total	[al_row] = Long(ls_factor_saldo_total)
			this.ii_update = 1

			this.object.tipo_mov.background.color = RGB(192,192,192)   
			this.object.tipo_mov.protect = 1

		end if
		
		return
	
	case "cliente"
		ls_sql = "SELECT p.proveedor AS CODIGO_cliente, " &
				  + "p.nom_proveedor AS nombre_cliente, " &
				  + "decode(p.tipo_doc_ident, '6', p.RUC, p.nro_doc_ident) AS RUC_dni " &
				  + "FROM proveedor p, " &
				  + "     vale_mov  vm " &
				  + "where p.proveedor = vm.proveedor " &
				  + "  and vm.flag_estado = '1' " &
				  + "  and vm.tipo_mov like 'S%'" &
				  + "  and p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cliente			[al_row] = ls_codigo
			this.object.nom_cliente		[al_row] = ls_data
			//of_set_cliente( ls_codigo )
			this.ii_update = 1
		end if
		
	case "tipo_doc_int"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_int	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_doc_ext"
		ls_sql = "SELECT tipo_doc AS codigo_tipo_doc, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_ext	[al_row] = ls_codigo
			this.ii_update = 1
		end if
	
	
	//DAtos para guia de remision
	case "serie"
		if is_action = 'new' then
			ls_sql = "SELECT b.desc_tipo_doc as descripcion_tipo_doc, " &
					  + "a.nro_serie AS Numero_serie " &
					  + "FROM doc_tipo_usuario a, " &
					  + "doc_tipo b " &
					  + "WHERE a.tipo_doc = b.tipo_doc " &
					  + "AND a.cod_usr = '" + gs_user + "' " &
					  + "AND a.tipo_doc  = '" + gnvo_app.is_doc_gr + "'"
					 
			lb_ret = f_lista(ls_sql, ls_data, ls_codigo, '1')
			
			if ls_codigo <> '' then
				this.object.serie[1] = invo_utility.of_get_serie(ls_codigo + '-')
			end if
		end if		
		
	case "prov_transp"
		ls_sql = "SELECT proveedor AS CODIGO_transportista, " &
				  + "nom_proveedor AS nombre_transportista, " &
				  + "RUC AS RUC " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.prov_transp					[al_row] = ls_codigo
			this.object.nom_prov_transportista	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "motivo_traslado"
		ls_sql = "SELECT motivo_traslado AS motivo_traslado, " &
				  + "descripcion AS descripcion_motivo_traslado " &
				  + "FROM motivo_traslado " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.motivo_traslado		[al_row] = ls_codigo
			this.object.desc_motivo_traslado	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event ue_insert_pre;call super::ue_insert_pre;String	ls_desc_mov

select desc_tipo_mov
	into :ls_desc_mov
from articulo_mov_tipo
where tipo_mov = :gnvo_app.almacen.is_oper_vnta_terc;


this.object.tipo_mov 		[al_row] = gnvo_app.almacen.is_oper_vnta_terc
this.object.desc_tipo_mov 	[al_row] = ls_desc_mov
this.object.flag_guia	 	[al_row] = '0'
this.object.fec_registro	[al_Row] = gnvo_App.of_fecha_Actual()
this.object.cod_usr			[al_Row] = gs_user

is_Action = 'new'

end event

event buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 

String          ls_boton, ls_nro_vale, ls_origen, ls_tipo_mov
long				 ll_row
DateTime			 ldt_fec_reg	
str_parametros 	 sl_param

ls_boton = dwo.name

if ls_boton = 'b_ref' then	
	
	IF is_solicita_ref = '0' then
		MessageBox('Aviso', 'El tipo de Movimiento no piede referencia')
		Return
	END IF	
	
	of_referencia_mov(ls_tipo_mov)	

elseif ls_boton = 'b_destino' then
	
	sl_param.dw1 = "d_dddw_direcciones"
	sl_param.titulo = "Direcciones"
	sl_param.field_ret_i[1] = 3
	sl_param.tipo = '1S'
	sl_param.string1 = this.object.cliente[row]

	OpenWithParm( w_search, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.destino[row] = sl_param.field_ret[1]
		this.ii_update = 1
	END IF
	
end if

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4411
integer height = 1900
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
uo_search uo_search
dw_pallets1 dw_pallets1
pb_1 pb_1
pb_2 pb_2
dw_pallets2 dw_pallets2
dw_detail dw_detail
end type

on tabpage_2.create
this.uo_search=create uo_search
this.dw_pallets1=create dw_pallets1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_pallets2=create dw_pallets2
this.dw_detail=create dw_detail
this.Control[]={this.uo_search,&
this.dw_pallets1,&
this.pb_1,&
this.pb_2,&
this.dw_pallets2,&
this.dw_detail}
end on

on tabpage_2.destroy
destroy(this.uo_search)
destroy(this.dw_pallets1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_pallets2)
destroy(this.dw_detail)
end on

type uo_search from n_cst_search within tabpage_2
integer y = 716
integer taborder = 40
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type dw_pallets1 from u_dw_abc within tabpage_2
event type integer ue_selected_row_now ( long al_row )
integer y = 800
integer width = 1691
integer height = 1004
integer taborder = 20
string dataobject = "d_abc_despacho_simplificado_pallets_tbl"
end type

event type integer ue_selected_row_now(long al_row);Long 		ll_row, ll_count, ll_rc
Integer	li_x
Any		la_id

ll_row = idw_pallets2.EVENT ue_insert()

if ll_row > 0 then
	ll_count = Long(this.object.Datawindow.Column.Count)
	
	FOR li_x = 1 to ll_count
		la_id = THIS.object.data.primary.current[al_row, li_x]	
		ll_rc = idw_pallets2.SetItem(ll_row, li_x, la_id)
	NEXT
	
	
	idw_pallets2.ScrollToRow(ll_row)
	
	return 1
	
else
	
	return -1
	
end if
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_selected_row;//
Long	ll_row

idw_pallets2.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	
	if THIS.EVENT ue_selected_row_now(ll_row) = -1 then
		return
	end if
	
	ll_row = THIS.GetSelectedRow(ll_row)
	
Loop

THIS.EVENT ue_selected_row_pos()


end event

event ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop
end event

type pb_1 from picturebutton within tabpage_2
integer x = 1733
integer y = 940
integer width = 146
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = " >"
alignment htextalign = left!
end type

event clicked;
idw_pallets1.EVENT ue_selected_row()

//// ordenar ventana derecha
//of_sort_dw_2()
//
end event

type pb_2 from picturebutton within tabpage_2
integer x = 1733
integer y = 1188
integer width = 146
integer height = 120
integer taborder = 40
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
alignment htextalign = left!
end type

event clicked;
idw_pallets2.EVENT ue_selected_row()

//// ordenar ventana izquierda
//of_sort_dw_1()
end event

type dw_pallets2 from u_dw_abc within tabpage_2
event type integer ue_selected_row_now ( long al_row )
integer x = 1952
integer y = 800
integer width = 1691
integer height = 1004
integer taborder = 30
string dataobject = "d_abc_despacho_simplificado_pallets_tbl"
end type

event type integer ue_selected_row_now(long al_row);Long 		ll_row, ll_count, ll_rc
Integer	li_x
Any		la_id

ll_row = idw_pallets1.EVENT ue_insert()

if ll_row > 0 then
	ll_count = Long(this.object.Datawindow.Column.Count)
	
	FOR li_x = 1 to ll_count
		la_id = THIS.object.data.primary.current[al_row, li_x]	
		ll_rc = idw_pallets1.SetItem(ll_row, li_x, la_id)
	NEXT
	
	
	idw_pallets1.ScrollToRow(ll_row)
	
	return 1
	
else
	
	return -1
	
end if
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop
end event

event ue_selected_row;//
Long	ll_row

idw_pallets1.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	
	if THIS.EVENT ue_selected_row_now(ll_row) = -1 then
		return
	end if
	
	ll_row = THIS.GetSelectedRow(ll_row)
	
Loop

THIS.EVENT ue_selected_row_pos()


end event

type dw_detail from u_dw_abc within tabpage_2
integer width = 4361
integer height = 712
string dataobject = "d_abc_despacho_simplificado_det_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

event ue_output;call super::ue_output;string 	ls_nro_doc, ls_almacen, ls_org_amp
Long		ll_nro_amp

ls_nro_doc = this.object.nro_doc  [al_row]
ls_almacen = this.object.almacen  [al_row]
ls_org_amp = this.object.cod_origen  [al_row]
ll_nro_amp = Long(this.object.nro_mov  [al_row])

idw_pallets1.Retrieve(ls_nro_doc, ls_almacen, ls_org_amp, ll_nro_amp)
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4411
integer height = 1900
long backcolor = 79741120
string text = "Packing List"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_packing_list dw_packing_list
end type

on tabpage_3.create
this.dw_packing_list=create dw_packing_list
this.Control[]={this.dw_packing_list}
end on

on tabpage_3.destroy
destroy(this.dw_packing_list)
end on

type dw_packing_list from u_dw_abc within tabpage_3
integer width = 4361
integer height = 1400
string dataobject = "d_lista_packing_list_ds_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

event ue_output;call super::ue_output;string 	ls_nro_doc, ls_almacen, ls_org_amp
Long		ll_nro_amp

ls_nro_doc = this.object.nro_doc  [al_row]
ls_almacen = this.object.almacen  [al_row]
ls_org_amp = this.object.cod_origen  [al_row]
ll_nro_amp = Long(this.object.nro_mov  [al_row])

idw_pallets1.Retrieve(ls_nro_doc, ls_almacen, ls_org_amp, ll_nro_amp)
end event

