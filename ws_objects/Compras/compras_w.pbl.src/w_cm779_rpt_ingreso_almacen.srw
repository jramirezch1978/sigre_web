$PBExportHeader$w_cm779_rpt_ingreso_almacen.srw
forward
global type w_cm779_rpt_ingreso_almacen from w_report_smpl
end type
type cb_1 from commandbutton within w_cm779_rpt_ingreso_almacen
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm779_rpt_ingreso_almacen
end type
type cbx_origen from checkbox within w_cm779_rpt_ingreso_almacen
end type
type ddlb_origen from u_ddlb within w_cm779_rpt_ingreso_almacen
end type
type st_1 from statictext within w_cm779_rpt_ingreso_almacen
end type
type st_registros from statictext within w_cm779_rpt_ingreso_almacen
end type
type rb_tipo_art_todos from radiobutton within w_cm779_rpt_ingreso_almacen
end type
type rb_tipo_art_pedido from radiobutton within w_cm779_rpt_ingreso_almacen
end type
type rb_tipo_art_reposicion from radiobutton within w_cm779_rpt_ingreso_almacen
end type
type rb_det from radiobutton within w_cm779_rpt_ingreso_almacen
end type
type rb_res from radiobutton within w_cm779_rpt_ingreso_almacen
end type
type cbx_saldo from checkbox within w_cm779_rpt_ingreso_almacen
end type
type gb_1 from groupbox within w_cm779_rpt_ingreso_almacen
end type
type gb_tipo_art from groupbox within w_cm779_rpt_ingreso_almacen
end type
end forward

global type w_cm779_rpt_ingreso_almacen from w_report_smpl
integer width = 3927
integer height = 1964
string title = "Ingresos Almacén (CM779)"
string menuname = "m_impresion"
long backcolor = 67108864
event ue_enviar_oc ( )
event ue_enviar_prog ( )
cb_1 cb_1
uo_fecha uo_fecha
cbx_origen cbx_origen
ddlb_origen ddlb_origen
st_1 st_1
st_registros st_registros
rb_tipo_art_todos rb_tipo_art_todos
rb_tipo_art_pedido rb_tipo_art_pedido
rb_tipo_art_reposicion rb_tipo_art_reposicion
rb_det rb_det
rb_res rb_res
cbx_saldo cbx_saldo
gb_1 gb_1
gb_tipo_art gb_tipo_art
end type
global w_cm779_rpt_ingreso_almacen w_cm779_rpt_ingreso_almacen

type variables
String 	is_doc_ot, is_doc_oc, is_oper_cons, is_origen[], is_reposicion[], &
			is_ot_adm
Integer	ii_ss, il_LastRow
Boolean	ib_action_on_buttonup
dwobject	idwo_clicked
end variables

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

on w_cm779_rpt_ingreso_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.cbx_origen=create cbx_origen
this.ddlb_origen=create ddlb_origen
this.st_1=create st_1
this.st_registros=create st_registros
this.rb_tipo_art_todos=create rb_tipo_art_todos
this.rb_tipo_art_pedido=create rb_tipo_art_pedido
this.rb_tipo_art_reposicion=create rb_tipo_art_reposicion
this.rb_det=create rb_det
this.rb_res=create rb_res
this.cbx_saldo=create cbx_saldo
this.gb_1=create gb_1
this.gb_tipo_art=create gb_tipo_art
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.cbx_origen
this.Control[iCurrent+4]=this.ddlb_origen
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_registros
this.Control[iCurrent+7]=this.rb_tipo_art_todos
this.Control[iCurrent+8]=this.rb_tipo_art_pedido
this.Control[iCurrent+9]=this.rb_tipo_art_reposicion
this.Control[iCurrent+10]=this.rb_det
this.Control[iCurrent+11]=this.rb_res
this.Control[iCurrent+12]=this.cbx_saldo
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_tipo_art
end on

on w_cm779_rpt_ingreso_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.cbx_origen)
destroy(this.ddlb_origen)
destroy(this.st_1)
destroy(this.st_registros)
destroy(this.rb_tipo_art_todos)
destroy(this.rb_tipo_art_pedido)
destroy(this.rb_tipo_art_reposicion)
destroy(this.rb_det)
destroy(this.rb_res)
destroy(this.cbx_saldo)
destroy(this.gb_1)
destroy(this.gb_tipo_art)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_cod_art, ls_almacen, ls_origen[], ls_tipo_art[], ls_sql, ls_subtitulo
String	ls_st_origen, ls_st_tipo_art, ls_flag_saldo
Decimal	ldec_pendiente
Long		ll_rc, ll_saldomin, ll_x, ll_row, ll_pos
Datastore	lds_saldomin

//DebugBreak()
Date ld_fec_ini, ld_fec_fin
ld_fec_ini = uo_fecha.of_get_fecha1()
ld_fec_fin = uo_fecha.of_get_fecha2()
		
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

st_registros.text = ''

// Determinar Origen
IF cbx_origen.checked = False THEN
	ls_origen = ddlb_origen.ia_key //is_origen
	ls_st_origen = 'Todos los Origenes'
ELSE
	ls_origen[1] = ddlb_origen.ia_id //ddlb_origen.text
	ls_st_origen = 'Origen: ' + ddlb_origen.text
END IF

if cbx_saldo.Checked = true then
	ls_flag_saldo = '1'
else
	ls_flag_saldo = '0'
end if
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

DECLARE pb_rpt_ingreso_almacen PROCEDURE FOR usp_alm_rpt_ingreso_almacen
	  (:ld_fec_ini, :ld_fec_fin);
EXECUTE pb_rpt_ingreso_almacen;

IF sqlca.sqlcode = -1 Then
	Rollback ;
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	Return
End If

IF rb_res.Checked THEN
	idw_1.DataObject = 'd_rpt_ingreso_almacen_res'
ELSEif rb_det.checked then
	idw_1.DataObject = 'd_rpt_ingreso_almacen'
END IF
idw_1.SetTransObject(SQLCA)
idw_1.Retrieve(ls_origen, ls_tipo_art, ls_flag_saldo) 
idw_1.object.t_texto.text = 'Ingresos Del: ' + String(uo_fecha.of_get_fecha1(), 'dd/mm/yy') + ' Al: ' + String(uo_fecha.of_get_fecha2(), 'dd/mm/yy') + '  ' + ls_st_origen		

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM779'
st_registros.text = String(idw_1.RowCount())


end event

event ue_open_pre;call super::ue_open_pre;//Long	ll_rc
//
//// Leer tipo doc OT, cod operacion consumo interno
//ll_rc = of_get_parametros(is_doc_ot, is_doc_oc, is_oper_cons)

// Cargar arreglo de tipos de articulo

is_reposicion[1] = '0' // los de pedido
is_reposicion[2] = '1' // Los de reposicion


end event

type dw_report from w_report_smpl`dw_report within w_cm779_rpt_ingreso_almacen
event rbuttondown pbm_dwnrbuttondown
event type integer ue_seleccionar ( long al_row )
integer x = 18
integer y = 364
integer width = 3785
integer height = 1132
string dataobject = "d_rpt_ingreso_almacen"
integer ii_zoom_actual = 150
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
	CASE "cod_art"
		lstr_1.DataObject = 'd_rpt_articulo_almacen'
		lstr_1.Width = 3000
		lstr_1.Height= 850
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
//		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
//		lstr_1.Arg[3] = String(GetItemDecimal(row,'qnt_comp'))
//		lstr_1.Arg[4] = String(GetItemDecimal(row,'qnt_recib'))
		lstr_1.Title = 'Informacion De Articulo'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)	
	CASE "cant_pendiente"
		lstr_1.DataObject = 'd_amp_cantidades_ff'
		lstr_1.Width = 3000
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
		lstr_1.Width = 4500
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

type cb_1 from commandbutton within w_cm779_rpt_ingreso_almacen
integer x = 2341
integer y = 276
integer width = 238
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;
IF cbx_origen.enabled AND cbx_origen.checked THEN
	IF ddlb_origen.text = "" THEN
		MessageBox('Error', 'Tiene que seleccionar Origen')
		RETURN
	END IF
END IF

PARENT.Event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm779_rpt_ingreso_almacen
integer x = 617
integer y = 36
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

type cbx_origen from checkbox within w_cm779_rpt_ingreso_almacen
integer x = 622
integer y = 132
integer width = 288
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
string text = "Origen"
end type

event clicked;IF THIS.checked THEN
	ddlb_origen.enabled = true
ELSE
	ddlb_origen.enabled = false
END IF
end event

type ddlb_origen from u_ddlb within w_cm779_rpt_ingreso_almacen
integer x = 869
integer y = 136
integer width = 718
integer height = 352
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;Long	ll_x

is_dataobject = 'd_origen_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
ii_lc2 = 20							// Longitud del campo 2


end event

event constructor;call super::constructor;Long	ll_x

FOR ll_x = 1 TO THIS.ids_data.RowCount()
	is_origen[ll_x] = ids_data.GetItemString(ll_x, 'cod_origen')
NEXT

end event

type st_1 from statictext within w_cm779_rpt_ingreso_almacen
integer x = 2167
integer y = 276
integer width = 151
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Req."
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_registros from statictext within w_cm779_rpt_ingreso_almacen
integer x = 1938
integer y = 276
integer width = 219
integer height = 72
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

type rb_tipo_art_todos from radiobutton within w_cm779_rpt_ingreso_almacen
integer x = 1966
integer y = 52
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

type rb_tipo_art_pedido from radiobutton within w_cm779_rpt_ingreso_almacen
integer x = 1966
integer y = 116
integer width = 571
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo a Pedido"
boolean checked = true
end type

type rb_tipo_art_reposicion from radiobutton within w_cm779_rpt_ingreso_almacen
integer x = 1966
integer y = 180
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo Reposicion Aut"
end type

type rb_det from radiobutton within w_cm779_rpt_ingreso_almacen
integer x = 46
integer y = 120
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

event clicked;//IF THIS.checked THEN
//	uo_fecha.enabled = true
//	cbx_x_ot.enabled = false
//	cbx_sin_oc.enabled = False
//	cbx_sin_oc.checked = False
//	cbx_con_oc.enabled = False
//	cbx_con_oc.checked = False
//	sle_ot.enabled = false
//	sle_maquina.enabled = false
//	cbx_origen.enabled = True
//	ddlb_origen.enabled = True
//	ddlb_ot_adm.enabled = false
//	rb_tipo_art_todos.enabled = True
//	rb_tipo_art_pedido.enabled = True
//	rb_tipo_art_reposicion.enabled = True
//	cb_lista_maq.enabled = False
//END IF
end event

type rb_res from radiobutton within w_cm779_rpt_ingreso_almacen
integer x = 46
integer y = 56
integer width = 357
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

event clicked;//IF THIS.checked THEN
//	uo_fecha.enabled = true
//	cbx_x_ot.enabled = True
//	cbx_sin_oc.enabled = False
//	cbx_sin_oc.checked = False
//	cbx_con_oc.enabled = False
//	cbx_con_oc.checked = False
//	sle_ot.enabled = false
//	sle_maquina.enabled = false
//	cbx_origen.enabled = True
//	ddlb_origen.enabled = True
//	ddlb_ot_adm.enabled = false
//	rb_tipo_art_todos.enabled = True
//	rb_tipo_art_pedido.enabled = True
//	rb_tipo_art_reposicion.enabled = True
//	cb_lista_maq.enabled = False
//END IF
end event

type cbx_saldo from checkbox within w_cm779_rpt_ingreso_almacen
integer x = 622
integer y = 228
integer width = 791
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
string text = "Pendiente retirar Almacén > 0"
boolean checked = true
end type

type gb_1 from groupbox within w_cm779_rpt_ingreso_almacen
integer x = 23
integer y = 4
integer width = 466
integer height = 204
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte:"
end type

type gb_tipo_art from groupbox within w_cm779_rpt_ingreso_almacen
integer x = 1938
integer width = 640
integer height = 264
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipos de Articulos"
end type

