$PBExportHeader$w_cm785_pend_cmp_xcomprador.srw
forward
global type w_cm785_pend_cmp_xcomprador from w_report_smpl
end type
type cb_lectura from commandbutton within w_cm785_pend_cmp_xcomprador
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm785_pend_cmp_xcomprador
end type
type ddlb_almacen from u_ddlb within w_cm785_pend_cmp_xcomprador
end type
type st_registros from statictext within w_cm785_pend_cmp_xcomprador
end type
type rb_tipo_art_todos from radiobutton within w_cm785_pend_cmp_xcomprador
end type
type rb_tipo_art_pedido from radiobutton within w_cm785_pend_cmp_xcomprador
end type
type rb_tipo_art_reposicion from radiobutton within w_cm785_pend_cmp_xcomprador
end type
type cbx_todos_alm from checkbox within w_cm785_pend_cmp_xcomprador
end type
type st_1 from statictext within w_cm785_pend_cmp_xcomprador
end type
type cb_1 from commandbutton within w_cm785_pend_cmp_xcomprador
end type
type gb_1 from groupbox within w_cm785_pend_cmp_xcomprador
end type
type gb_tipo_art from groupbox within w_cm785_pend_cmp_xcomprador
end type
type gb_2 from groupbox within w_cm785_pend_cmp_xcomprador
end type
type gb_3 from groupbox within w_cm785_pend_cmp_xcomprador
end type
end forward

global type w_cm785_pend_cmp_xcomprador from w_report_smpl
integer width = 3365
integer height = 1360
string title = "Req de Articulos Pendiente de Compra por Comprador (CM785)"
string menuname = "m_impresion"
long backcolor = 67108864
event ue_enviar_oc ( )
event ue_enviar_prog ( )
cb_lectura cb_lectura
uo_fecha uo_fecha
ddlb_almacen ddlb_almacen
st_registros st_registros
rb_tipo_art_todos rb_tipo_art_todos
rb_tipo_art_pedido rb_tipo_art_pedido
rb_tipo_art_reposicion rb_tipo_art_reposicion
cbx_todos_alm cbx_todos_alm
st_1 st_1
cb_1 cb_1
gb_1 gb_1
gb_tipo_art gb_tipo_art
gb_2 gb_2
gb_3 gb_3
end type
global w_cm785_pend_cmp_xcomprador w_cm785_pend_cmp_xcomprador

type variables
String 	is_doc_ot, is_doc_oc, is_oper_cons, is_almacen, is_reposicion[], &
			is_ot_adm, is_comprador[]
Integer	ii_ss, il_LastRow
Boolean	ib_action_on_buttonup
dwobject	idwo_clicked
end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons)
end prototypes

event ue_enviar_oc();string	ls_org_amp, ls_cadena, ls_cod_art, ls_desc_art, &
			ls_und, ls_almacen, ls_org_ref, ls_tipo_ref, &
			ls_nro_ref, ls_oper_sec, ls_moneda, ls_proveedor
Long		ll_nro_amp, ll_row, ll_find, ll_row_det, ll_dias_rep
Decimal	ldc_cant_proyect, ldc_cant_pendiente, ldc_sldo, &
			ldc_precio
Boolean	lb_new_cab_oc
Date		ld_fec_reg
u_dw_abc ldw_master, ldw_detail
window	lw_window

If Not IsValid(w_cm311_orden_compra) or IsNull(w_cm311_orden_compra) then
	MessageBox('Aviso', 'No existe ninguna Ventana de Orden de Compra Abierta', Exclamation!)
	return
end if

lw_window  = w_cm311_orden_compra
ldw_master = w_cm311_orden_compra.dw_master
ldw_detail = w_cm311_orden_compra.dw_detail

if ldw_master.GetRow() = 0 then 
	MessageBox('Aviso', 'Debe haber ingresado una cabecera de OC previamente')
	return
end if

if ldw_master.object.flag_estado[ldw_master.GetRow()] <> '1' then 
	MessageBox('Aviso', 'Orden de Compra no esta activa, por favor verifique')
	return
end if

ls_proveedor 	= ldw_master.object.proveedor	[ldw_master.GetRow()]
ls_moneda		= ldw_master.object.cod_moneda[ldw_master.GetRow()]
ld_fec_reg		= Date(ldw_master.object.fec_registro[ldw_master.GetRow()])

if IsNull(ls_proveedor) or ls_proveedor = '' then 
	MessageBox('Aviso', 'No ha indicado ningun proveedor en la OC')
	return
end if

if IsNull(ls_moneda) or ls_moneda = '' then 
	MessageBox('Aviso', 'No ha indicado ninguna moneda en la OC')
	return
end if

//lb_new_cab_oc = false
//if ldw_master.GetRow() = 0 then 
//	lb_new_cab_oc = true
//else
//	//Verifico el flag de estado de la OC, si esta cerrada creo una nueva
//	if ldw_master.object.flag_estado[ldw_master.GetRow()] = '2' then
//		lb_new_cab_oc = true
//	end if
//
//	if MessageBox('Information', 'Desea Agregar los Articulos seleccionados a la OC existente??', &
//		Information!, YesNo!, 1) = 1 then
//		lb_new_cab_oc = true
//	end if
//end if
//
//if lb_new_cab_oc = true then
//	w_cm311_orden_compra.idw_1 = ldw_master
//	w_cm311_orden_compra.event ue_insert()
//	
//	if ldw_master.GetRow() = 0 then return
//	
//end if

// Ahora recorro el reporte para ver todos los que son seleccionados
ll_row = dw_report.GetSelectedRow(0)
w_cm311_orden_compra.SetFocus()

Do While ll_row <> 0
	ls_org_amp = dw_report.object.cod_origen	[ll_row]
	ll_nro_amp = dw_report.object.nro_mov		[ll_row]	
	ls_almacen = dw_report.object.almacen		[ll_row]	
	ls_cadena  = "org_amp_ref = '" + ls_org_amp + "' and nro_amp_ref = " + string(ll_nro_amp) 
	
	ll_find = ldw_detail.Find( ls_cadena, 1, ldw_detail.RowCount())
	
	// Si el requerimiento no exta en la OC entonces procedo a añadir una nueva fila
	if ll_find = 0 then 
	
		// Obtengo los datos que necesito
		select a.cod_art, a.desc_art, a.und, amp.almacen, amp.cod_origen, amp.tipo_doc, amp.nro_doc,
				 amp.oper_sec, NVL(a.dias_reposicion, 0), 
				 USF_ALM_CANT_LIBRE_OT(amp.cod_origen,amp.nro_mov ) -
				 USF_ALM_CANT_PROG_PEND(amp.cod_origen, amp.nro_mov),
				 NVL(amp.cant_proyect, 0) - NVL(amp.cant_procesada,0),
				 usf_alm_saldo_total_alm(amp.cod_Art, amp.almacen),
				 usf_cmp_prec_compra_artic(:ls_cod_art, :ls_proveedor, :ld_fec_reg, amp.almacen, :ls_moneda)
		into 	:ls_cod_art, :ls_desc_art, :ls_und, :ls_almacen, :ls_org_ref, :ls_tipo_ref, :ls_nro_ref,
				:ls_oper_sec, :ll_dias_rep, 
				:ldc_cant_proyect, :ldc_cant_pendiente, :ldc_sldo,
				:ldc_precio
		from articulo a,
			  articulo_mov_proy amp
		where a.cod_art = amp.cod_art
		  and amp.cod_origen = :ls_org_amp
		  and amp.nro_mov		= :ll_nro_amp;
		
		if SQLCA.SQLCode = -1 then
			MessageBox('Aviso', SQLCA.SQLErrtext)
			return
		end if
		
		if ldc_cant_proyect > 0 then
			// Inserto el detalle en la OC
			ll_row_det = ldw_detail.event ue_insert( )
			if ll_row_det > 0 then
				ldw_detail.object.cod_art 			[ll_row_det] = ls_cod_art
				ldw_detail.object.desc_art 		[ll_row_det] = ls_desc_art
				ldw_detail.object.und 				[ll_row_det] = ls_und
				ldw_detail.object.org_amp_ref 	[ll_row_det] = ls_org_amp
				ldw_detail.object.nro_amp_ref 	[ll_row_det] = ll_nro_amp
				ldw_detail.object.fec_proyect 	[ll_row_det] = Relativedate(DAte(f_fecha_actual()), ll_dias_rep)
				ldw_detail.object.cant_proyect 	[ll_row_det] = ldc_Cant_proyect
				ldw_detail.object.cant_pendiente	[ll_row_det] = ldc_Cant_pendiente
				ldw_detail.object.precio_unit		[ll_row_det] = ldc_precio
				ldw_detail.object.saldo_almacen 	[ll_row_det] = ldc_sldo
				ldw_detail.object.almacen 			[ll_row_det] = ls_almacen
				ldw_detail.object.cod_usr 			[ll_row_det] = gs_user
				ldw_detail.object.origen_ref		[ll_row_det] = ls_org_ref
				ldw_detail.object.tipo_ref			[ll_row_det] = ls_tipo_ref
				ldw_detail.object.referencia		[ll_row_det] = ls_nro_ref
				ldw_detail.object.oper_sec			[ll_row_det] = ls_oper_sec
				
			end if
		end if
	end if
	
	ll_row = dw_report.GetSelectedRow(ll_row)
Loop





end event

event ue_enviar_prog();string	ls_org_amp, ls_cadena, ls_cod_art, ls_desc_art, &
			ls_und, ls_almacen, ls_org_ref, ls_tipo_ref, &
			ls_nro_ref, ls_oper_sec
Long		ll_nro_amp, ll_row, ll_find, ll_row_det, ll_dias_rep
Decimal	ldc_cant_proyect, ldc_cant_pendiente, ldc_sldo
Boolean	lb_new_cab_oc
u_dw_abc ldw_master, ldw_detail
window	lw_window

If Not IsValid(w_cm305_programa_compras) or IsNull(w_cm305_programa_compras) then
	MessageBox('Aviso', 'No existe ninguna Ventana de Programa de Compras Abierta', Exclamation!)
	return
end if

lw_window  = w_cm305_programa_compras
ldw_master = w_cm305_programa_compras.dw_master
ldw_detail = w_cm305_programa_compras.dw_detail

if ldw_master.GetRow() = 0 then 
	MessageBox('Aviso', 'Debe haber ingresado una cabecera en el Programa de Compras previamente')
	return
end if

if ldw_master.object.flag_estado[ldw_master.GetRow()] <> '1' then 
	MessageBox('Aviso', 'Programa de Compras no esta activa, por favor verifique')
	return
end if

// Ahora recorro el reporte para ver todos los que son seleccionados
ll_row = dw_report.GetSelectedRow(0)
w_cm305_programa_compras.SetFocus()

Do While ll_row <> 0
	ls_org_amp = dw_report.object.cod_origen	[ll_row]
	ll_nro_amp = dw_report.object.nro_mov		[ll_row]	
	ls_cadena  = "org_amp_ot_ref = '" + ls_org_amp + "' and nro_amp_ot_ref = " + string(ll_nro_amp) 
	
	ll_find = ldw_detail.Find( ls_cadena, 1, ldw_detail.RowCount())
	
	// Si el requerimiento no exta en la OC entonces procedo a añadir una nueva fila
	if ll_find = 0 then 
	
		// Obtengo los datos que necesito
		select a.cod_art, a.desc_art, a.und, amp.almacen, amp.cod_origen, amp.tipo_doc, amp.nro_doc,
				 amp.oper_sec, NVL(a.dias_reposicion, 0), 
				 USF_ALM_CANT_LIBRE_OT(amp.cod_origen,amp.nro_mov ) -
				 USF_ALM_CANT_PROG_PEND(amp.cod_origen, amp.nro_mov),
				 NVL(amp.cant_proyect, 0) - NVL(amp.cant_procesada,0),
				 usf_alm_saldo_total_alm(amp.cod_Art, amp.almacen)
		into 	:ls_cod_art, :ls_desc_art, :ls_und, :ls_almacen, :ls_org_ref, :ls_tipo_ref, :ls_nro_ref,
				:ls_oper_sec, :ll_dias_rep, 
				:ldc_cant_proyect, :ldc_cant_pendiente, :ldc_sldo
		from articulo a,
			  articulo_mov_proy amp
		where a.cod_art = amp.cod_art
		  and amp.cod_origen = :ls_org_amp
		  and amp.nro_mov		= :ll_nro_amp;
		
		if SQLCA.SQLCode = -1 then
			MessageBox('Aviso', SQLCA.SQLErrtext)
			return
		end if
		
		if ldc_cant_proyect > 0 then
			// Inserto el detalle en la OC
			ll_row_det = ldw_detail.event ue_insert( )
			if ll_row_det > 0 then
				ldw_detail.object.cod_art 			[ll_row_det] = ls_cod_art
				ldw_detail.object.desc_art 		[ll_row_det] = ls_desc_art
				ldw_detail.object.und 				[ll_row_det] = ls_und
				ldw_detail.object.fec_requerida 	[ll_row_det] = Relativedate(DAte(f_fecha_actual()), ll_dias_rep)
				ldw_detail.object.cant_proyect 	[ll_row_det] = ldc_Cant_proyect
				ldw_detail.object.almacen 			[ll_row_det] = ls_almacen
				ldw_detail.object.org_amp_ot_ref	[ll_row_det] = ls_org_amp
				ldw_detail.object.nro_amp_ot_ref	[ll_row_det] = ll_nro_amp
				ldw_detail.object.nro_doc			[ll_row_det] = ls_nro_ref
			end if
		end if
	end if
	
	ll_row = dw_report.GetSelectedRow(ll_row)
Loop





end event

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_oc, ref string as_oper_cons);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OT", "LOGPARAM"."DOC_OC", "LOGPARAM"."OPER_CONS_INTERNO"  
    INTO :as_doc_ot, :as_doc_oc, :as_oper_cons
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm785_pend_cmp_xcomprador.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_lectura=create cb_lectura
this.uo_fecha=create uo_fecha
this.ddlb_almacen=create ddlb_almacen
this.st_registros=create st_registros
this.rb_tipo_art_todos=create rb_tipo_art_todos
this.rb_tipo_art_pedido=create rb_tipo_art_pedido
this.rb_tipo_art_reposicion=create rb_tipo_art_reposicion
this.cbx_todos_alm=create cbx_todos_alm
this.st_1=create st_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_tipo_art=create gb_tipo_art
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.ddlb_almacen
this.Control[iCurrent+4]=this.st_registros
this.Control[iCurrent+5]=this.rb_tipo_art_todos
this.Control[iCurrent+6]=this.rb_tipo_art_pedido
this.Control[iCurrent+7]=this.rb_tipo_art_reposicion
this.Control[iCurrent+8]=this.cbx_todos_alm
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_tipo_art
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_cm785_pend_cmp_xcomprador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.uo_fecha)
destroy(this.ddlb_almacen)
destroy(this.st_registros)
destroy(this.rb_tipo_art_todos)
destroy(this.rb_tipo_art_pedido)
destroy(this.rb_tipo_art_reposicion)
destroy(this.cbx_todos_alm)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_tipo_art)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_cod_art, ls_almacen[], ls_tipo_art[], ls_sql, ls_subtitulo
String	ls_st_origen, ls_st_tipo_art, ls_alm_text
Decimal	ldec_pendiente
Long		ll_rc, ll_saldomin, ll_x, ll_row, ll_pos
Datastore	lds_saldomin

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

st_registros.text = ''

IF upperbound(is_comprador[]) = 0 THEN 
	ls_subtitulo = 'Todos los compradores - '
ELSE
	ls_subtitulo = 'Rango de compradores - '	
END IF

// Determinar Tipo Articulo
IF rb_tipo_art_todos.checked = True THEN
	ls_tipo_art = is_reposicion
	ls_st_tipo_art = 'Todos los Articulos'
ELSEIF rb_tipo_art_pedido.checked = True THEN
	ls_tipo_art[1] = '0' 
	ls_st_tipo_art = 'Articulos solo de Pedido'
ELSEIF rb_tipo_art_reposicion.checked = True THEN
	ls_tipo_art[1] = '1' 
	ls_st_tipo_art = 'Articulos solo de Reposicion'	
END IF

IF cbx_todos_alm.checked THEN
	ls_almacen = ddlb_almacen.ia_key
	ls_alm_text = 'Todos los Almacenes'
ELSE
	ls_almacen[1] = ddlb_almacen.ia_id
	ls_alm_text = ddlb_almacen.text
END IF

if upperbound(is_comprador[]) = 0 then
	//idw_1.dataobject = 'd_art_mov_proy_pend_comp_sug_log_comp'
	idw_1.dataobject = 'd_art_mov_proy_pend_comp_sug_log'
else
	//idw_1.dataobject = 'd_art_mov_proy_pend_comp_sug_log_comp_if'
	idw_1.dataobject = 'd_art_mov_proy_pend_comp_sug_log_if'
end if

idw_1.settransobject( sqlca )
idw_1.Retrieve(is_doc_ot, is_doc_oc, is_oper_cons, uo_fecha.of_get_fecha1(), uo_fecha.of_get_fecha2(), ls_almacen, ls_tipo_art, is_comprador) 
idw_1.object.t_subtitulo_1.text = 'Fecha Registro Del:  ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + '  AL:  ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') 
idw_1.object.t_subtitulo_2.text =  ls_subtitulo + ls_alm_text + '  ' + 	ls_st_tipo_art	

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM754'
st_registros.text = String(idw_1.RowCount())

ib_preview = false
event ue_preview()

end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

// Leer tipo doc OT, cod operacion consumo interno
ll_rc = of_get_parametros(is_doc_ot, is_doc_oc, is_oper_cons)

// Cargar arreglo de tipos de articulo

is_reposicion[1] = '0' // los de pedido
is_reposicion[2] = '1' // Los de reposicion


end event

type dw_report from w_report_smpl`dw_report within w_cm785_pend_cmp_xcomprador
event rbuttondown pbm_dwnrbuttondown
event type integer ue_seleccionar ( long al_row )
integer x = 37
integer y = 480
integer width = 3259
integer height = 580
string dataobject = "d_art_mov_proy_pend_comp_sug_log"
integer ii_zoom_actual = 100
end type

event dw_report::rbuttondown;call super::rbuttondown;m_rbutton_cm750 lm_1
lm_1 = CREATE m_rbutton_cm750
lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1
end event

event type integer dw_report::ue_seleccionar(long al_row);integer	li_Idx

THIS.setredraw(false)   // deselecciona todo
THIS.selectrow(0,false)

If il_lastrow = 0 then				// selecciona fila si no existe seleccion anterior
	THIS.SelectRow(al_row,TRUE)
	THIS.setredraw(true)
	Return 1
end if

if il_lastrow > al_row then  
	For li_Idx = il_lastrow to al_row STEP -1		// seleccionar rango hacia atras
		THIS.selectrow(li_Idx,TRUE)	
	end for	
else
	For li_Idx = il_lastrow to al_row 				// seleccionar rango hacia adelante
		THIS.selectrow(li_Idx,TRUE)	
	next	
end if

THIS.setredraw(true)
Return 1
end event

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "pend_cmp"
		lstr_1.DataObject = 'd_amp_cantidades_ff'
		lstr_1.Width = 2000
		lstr_1.Height= 850
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Arg[3] = String(GetItemDecimal(row,'qnt_comp'))
		lstr_1.Arg[4] = String(GetItemDecimal(row,'qnt_recib'))
		lstr_1.Title = 'Informacion Del Requerimiento'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)	
	CASE "nro_doc_oc" 
		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'cod_origen')
		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'OC Asociadas a este Requerimiento'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "nro_doc" 
		lstr_1.DataObject = 'd_amp_pendiente_ot_cascada_tbl'
		lstr_1.Width = 4300
		lstr_1.Height= 1000
		lstr_1.Arg[1] = is_doc_ot
		lstr_1.Arg[2] = is_doc_oc
		lstr_1.Arg[3] = is_oper_cons
		lstr_1.Arg[4] = GetItemString(row,'nro_doc')
		lstr_1.Title = 'Movimientos Pendientes por OT'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "sldo_fisico"
		lstr_1.DataObject = 'd_art_mov_almacen_tbl'
		lstr_1.Width = 2850
		lstr_1.Height= 900
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Arg[2] = GetItemString(row,'almacen')
		lstr_1.Title = 'Ultimos Movimientos del Articulo en este Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)	
	CASE "articulo_almacen_sldo_solicitado" 
		lstr_1.DataObject = 'd_amp_pendiente_alm_tbl'
		lstr_1.Width = 4400
		lstr_1.Height= 1100
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = is_oper_cons
		lstr_1.Arg[3] = GetItemString(row,'almacen')
		lstr_1.Arg[4] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Movimientos Pendientes por ALMACEN'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)	
	CASE "articulo_almacen_sldo_por_llegar" 
		lstr_1.DataObject = 'd_oc_almacen_articulo_pend_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'almacen')
		lstr_1.Arg[3] = GetItemString(row,'cod_art')
		lstr_1.Title = 'OC Pendientes por ALMACEN'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)	
	CASE "fec_proyect" 
		lstr_1.DataObject = 'd_articulo_desc_ff'
		lstr_1.Width = 3200
		lstr_1.Height= 700		
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Datos del Articulo'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "cant_procesada"
		lstr_1.DataObject = 'd_art_mov_amp_tbl'
		lstr_1.Width = 3000
		lstr_1.Height= 700
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Retiros de Almacen'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "qnt_comp" 
		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
		lstr_1.Width = 4400
		lstr_1.Height= 900
		lstr_1.Arg[1] = is_doc_oc
		lstr_1.Arg[2] = GetItemString(row,'cod_origen')
		lstr_1.Arg[3] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'OC Asociadas a este Requerimiento'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "qnt_recib"
		lstr_1.DataObject = 'd_art_mov_oc_amp_tbl'
		lstr_1.Width = 3000
		lstr_1.Height= 700
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Ingresos al Almacen'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)	
END CHOOSE

end event

event dw_report::clicked;call super::clicked;IF row = 0 OR is_dwform = 'form' THEN RETURN

il_row = row              // fila corriente

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	idwo_clicked = dwo        // dwo corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	RETURN
END IF


string	  ls_KeyDownType	 //  solo para seleccion multiple

If Keydown(KeyShift!) then  // seleccionar multiples filas usando la tecla shift
	this.event ue_seleccionar(row)	
Else
	If this.IsSelected(row) Then
		il_LastRow = row
		ib_action_on_buttonup = true
	Else
		If Keydown(KeyControl!) then  // mantiene las otras filas seleccionadas y selecciona
			il_LastRow = row				// o deselecciona a clicada
			this.SelectRow(row,TRUE)
		Else
			il_LastRow = row
			this.SelectRow(0,FALSE)
			this.SelectRow(row,TRUE)
		End If
	END IF
END if	
end event

type cb_lectura from commandbutton within w_cm785_pend_cmp_xcomprador
integer x = 2706
integer y = 352
integer width = 334
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;
IF ddlb_almacen.text = "" AND cbx_todos_alm.checked = False THEN
	MessageBox('Error', 'Tiene que seleccionar Almacen')
	RETURN
END IF

PARENT.Event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm785_pend_cmp_xcomprador
integer x = 73
integer y = 104
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(Today(),-90), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type ddlb_almacen from u_ddlb within w_cm785_pend_cmp_xcomprador
integer x = 73
integer y = 320
integer width = 1371
integer height = 972
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;Long	ll_x

is_dataobject = 'd_almacen_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 8                     // Longitud del campo 1
ii_lc2 = 35							// Longitud del campo 2


end event

event constructor;call super::constructor;//Long	ll_x
//
//FOR ll_x = 1 TO THIS.ids_data.RowCount()
//	is_origen[ll_x] = ids_data.GetItemString(ll_x, 'cod_origen')
//NEXT

end event

event ue_output;call super::ue_output;is_almacen = aa_key
end event

type st_registros from statictext within w_cm785_pend_cmp_xcomprador
integer x = 2907
integer y = 192
integer width = 224
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type rb_tipo_art_todos from radiobutton within w_cm785_pend_cmp_xcomprador
integer x = 1454
integer y = 116
integer width = 251
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

type rb_tipo_art_pedido from radiobutton within w_cm785_pend_cmp_xcomprador
integer x = 1719
integer y = 116
integer width = 425
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo a Pedido"
boolean checked = true
end type

type rb_tipo_art_reposicion from radiobutton within w_cm785_pend_cmp_xcomprador
integer x = 2121
integer y = 116
integer width = 553
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo Reposicion Aut"
end type

type cbx_todos_alm from checkbox within w_cm785_pend_cmp_xcomprador
integer x = 1509
integer y = 332
integer width = 590
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los almacenes"
end type

event clicked;IF THIS.checked THEN
	ddlb_almacen.enabled = False
ELSE
	ddlb_almacen.enabled = True
END IF

end event

type st_1 from statictext within w_cm785_pend_cmp_xcomprador
integer x = 2706
integer y = 48
integer width = 599
integer height = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Cantidad de Registros encontrados"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cm785_pend_cmp_xcomprador
integer x = 2249
integer y = 332
integer width = 352
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccion..."
end type

event clicked;long ll_i = 1
string is_null[]
str_parametros lstr_parametros

lstr_parametros.titulo = 'Lista de Compradores'
lstr_parametros.dw1    = 'd_lista_comprador'
lstr_parametros.tipo   = ''
lstr_parametros.opcion = 2

is_comprador[] = is_null[]

openwithparm(w_abc_seleccion,lstr_parametros)

if isvalid(message.powerobjectparm) then
	
	lstr_parametros = message.powerobjectparm
	
	is_comprador[] = lstr_parametros.field_ret_s[]
	
end if
end event

type gb_1 from groupbox within w_cm785_pend_cmp_xcomprador
integer x = 37
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 30
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

type gb_tipo_art from groupbox within w_cm785_pend_cmp_xcomprador
integer x = 1426
integer y = 32
integer width = 1257
integer height = 196
integer taborder = 30
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

type gb_2 from groupbox within w_cm785_pend_cmp_xcomprador
integer x = 37
integer y = 256
integer width = 2126
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
string text = "Almacen"
end type

type gb_3 from groupbox within w_cm785_pend_cmp_xcomprador
integer x = 2194
integer y = 256
integer width = 480
integer height = 196
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Compradores"
end type

