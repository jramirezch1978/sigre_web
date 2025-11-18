$PBExportHeader$w_cam304_creditos.srw
forward
global type w_cam304_creditos from w_abc_mastdet_smpl
end type
end forward

global type w_cam304_creditos from w_abc_mastdet_smpl
integer width = 2629
integer height = 2268
string title = "[CM304] Créditos"
string menuname = "m_abc_anular_lista"
end type
global w_cam304_creditos w_cam304_creditos

type variables
String	is_soles, is_salir
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_set_base (long al_row, string as_productor)
public subroutine of_retrieve (string as_nro)
public function integer of_get_param ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_j, ll_count
string	ls_mensaje, ls_nro

if is_action = 'new' then

	Select count(*) 
		into :ll_count
	from num_cam_creditos 
	where cod_origen = :gs_origen;
	
	IF ll_count = 0 then
		Insert into num_cam_creditos (cod_origen, ult_nro)
			values( :gs_origen, 1);
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_cam_creditos 
	where cod_origen = :gs_origen for update;
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	select count(*)
		into :ll_count
	from cam_creditos
	where nro_credito = :ls_nro;
	
	do while ll_count > 0 
		ll_ult_nro ++
		
		// Asigna numero a cabecera
		ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
		
		select count(*)
			into :ll_count
		from cam_creditos
		where nro_credito = :ls_nro;
		
	loop
	
	dw_master.object.nro_credito[dw_master.getrow()] = ls_nro
	
	// Incrementa contador
	Update num_cam_creditos 
		set ult_nro = :ll_ult_nro + 1 
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_Credito[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()	
	dw_detail.object.nro_credito[ll_j] = ls_nro	
next
return 1
end function

public subroutine of_set_base (long al_row, string as_productor);string	ls_base, ls_Desc_base

select distinct ab.cod_base, ab.desc_base
	into :ls_base, :ls_desc_base
from ap_bases ab,
     ap_proveedor_certif apc
where ab.cod_base = apc.cod_base  
  and apc.proveedor = :as_productor;

dw_master.object.cod_base [al_row] = ls_base
dw_master.object.desc_base [al_row] = ls_desc_base
end subroutine

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	dw_detail.retrieve(as_nro)
	
	if dw_detail.RowCount() > 0 then
		dw_detail.il_row = 1
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(dw_detail.il_Row, true)
		dw_detail.SetRow(1)
	end if
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	dw_detail.ii_protect = 0
	dw_detail.ii_update	= 0
	dw_detail.of_protect()
	dw_detail.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

public function integer of_get_param ();String ls_mensaje

// busca tipos de movimiento definidos
SELECT 	cod_soles
	INTO 	:is_soles
FROM logparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en Logparam")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if

// busca doc. prog. compras
if ISNULL( is_soles ) or TRIM( is_soles ) = '' then
	Messagebox("Error", "Defina Moneda Soles en logparam")
	return 0
end if


return 1

end function

on w_cam304_creditos.create
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
end on

on w_cam304_creditos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_lec_mst = 0 
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, dw_detail.is_dwform) <> true then	return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_creditos_campo_tbl'
sl_param.titulo = 'Creditos de Campo'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_credito[dw_master.getRow()])
	end if
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
END IF

end event

event ue_anular;call super::ue_anular;String	ls_estado
Long		ll_i

if dw_master.getRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.getRow()] 

if ls_estado <> '1' then
	MessageBox('Error', 'No se puede anular el documento porque no esta ACTIVO, por favor verifique')
	return
end if

IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF

if MessageBox('Aviso', 'Desea anular el documento?', Information!, YesNo!, 2) = 2 then return

dw_master.object.flag_estado [dw_master.getRow()] = '0'
dw_master.ii_update = 1

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[ll_i] = '0'
	dw_detail.ii_update = 1
next
end event

event ue_print;call super::ue_print;// vista previa de mov. almacen
sg_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_frm_credito'
lstr_rep.titulo 	= 'Previo de Crédito'
lstr_rep.string1 	= dw_master.object.nro_credito[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_cam304_creditos_frm, lstr_rep, w_main, 0, Layered!)
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cam304_creditos
integer x = 0
integer y = 0
integer width = 2405
integer height = 1096
string dataobject = "d_abc_credito_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_row] = f_fecha_Actual()
this.object.fec_prestamo 	[al_row] = Date(f_fecha_Actual())
this.object.flag_estado		[al_row] = '1'
this.object.tasa_interes	[al_row] = 0.00
this.object.flag_periodo	[al_row] = 'Q'
this.object.cod_origen		[al_row] = gs_origen
this.object.cod_usr			[al_row] = gs_user
this.object.cod_moneda		[al_row] = is_soles

this.object.total_prestamo		[al_row] = 0.00
this.object.total_interes		[al_row] = 0.00
this.object.total_comisiones	[al_row] = 0.00

is_Action = 'new'

end event

event dw_master::constructor;call super::constructor; is_dwform = 'form' // tabular form
 
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "proveedor"

		ls_sql = "SELECT p.proveedor AS codigo_proveedor, " &
				  + "p.nom_proveedor AS razon_social, " &
				  + "p.ruc as ruc " &
				  + "FROM proveedor p " &
				  + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			of_set_base(al_row, ls_codigo)
			this.ii_update = 1
		end if

	case "cod_base"

		ls_sql = "SELECT p.cod_base AS codigo_base, " &
				  + "p.desc_base AS descripcion_base " &
				  + "FROM ap_bases p " &
				  + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_base		[al_row] = ls_codigo
			this.object.desc_base	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_moneda"

		ls_sql = "SELECT p.cod_moneda AS codigo_moneda, " &
				  + "p.descripcion AS descripcion_moneda " &
				  + "FROM moneda p " &
				  + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_prestamo"

		ls_sql = "SELECT p.tipo_prestamo AS tipo_prestamo, " &
				  + "p.desc_tipo_prestamo AS descripcion_tipo_prestamo " &
				  + "FROM cam_tipo_prestamo p " &
				  + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_prestamo			[al_row] = ls_codigo
			this.object.desc_tipo_prestamo	[al_row] = ls_data
			this.ii_update = 1
		end if		
end choose

IF this.object.cod_base	[al_row] <> '' AND this.object.tipo_prestamo [al_row] = 'FM' THEN
	this.object.b_imp_base.enabled = true
ELSE
	this.object.b_imp_base.enabled = false
END IF
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'proveedor'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_desc1
		  from proveedor
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Proveedor o no se encuentra activo, por favor verifique")
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			of_set_base(row, data)
			return 1
		end if

		this.object.nom_proveedor		[row] = ls_desc1

	CASE 'cod_base' 

		// Verifica que codigo ingresado exista			
		Select desc_base
	     into :ls_desc1
		  from ap_bases
		 Where cod_base = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Base o no se encuentra activo, por favor verifique")
			this.object.cod_base		[row] = ls_null
			this.object.desc_base	[row] = ls_null
			return 1
		end if

		this.object.desc_base		[row] = ls_desc1

	CASE 'cod_moneda' 

		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc1
		  from moneda
		 Where cod_moneda = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de MONEDA o no se encuentra activo, por favor verifique")
			this.object.cod_moneda		[row] = ls_null
			return 1
		end if

	case 'tipo_prestamo'
		
		// Verifica que codigo ingresado exista			
		Select desc_tipo_prestamo
	     into :ls_desc1
		  from cam_tipo_prestamo
		 Where tipo_prestamo = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Base o no se encuentra activo, por favor verifique")
			this.object.tipo_prestamo			[row] = ls_null
			this.object.desc_tipo_prestamo	[row] = ls_null
			return 1
		end if

		this.object.desc_tipo_prestamo		[row] = ls_desc1

END CHOOSE

IF this.object.cod_base	[row] <> '' AND this.object.tipo_prestamo [row] = 'FM' THEN
	this.object.b_imp_base.enabled = true
ELSE
	this.object.b_imp_base.enabled = false
END IF
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::buttonclicked;call super::buttonclicked;String 		ls_base, ls_ot_adm, ls_trabajador, ls_labor, ls_desc_labor, ls_und
Date 			ld_fec_parte
Integer 		li_i, li_row, li_j
u_ds_base 	ds_provbase_det

CHOOSE CASE lower(dwo.name)
		
	CASE "b_imp_base"

		ls_base = dw_master.object.cod_base[row]

		if ls_base = '' or IsNull(ls_base) then
			MessageBox('Error', 'Debe elegir una Base primero')
			return
		end if
	
		ds_provbase_det = create u_ds_base
		ds_provbase_det.DataObject = 'd_list_provbase_det_tbl'
		ds_provbase_det.SetTransObject(SQLCA)
		ds_provbase_det.Retrieve(ls_base)
		for li_i=1 to ds_provbase_det.RowCount()
				li_row = dw_detail.event ue_insert()
				if li_row > 0 then
					dw_detail.object.nro_item 					[li_row] = li_i
					dw_detail.object.proveedor					[li_row] = ds_provbase_det.object.proveedor [li_i]
					dw_detail.object.nom_proveedor 			[li_row] = ds_provbase_det.object.nom_proveedor [li_i]
					dw_detail.object.fec_inicio_pago 			[li_row] = this.object.fec_prestamo [1]
					dw_detail.object.cencos 						[li_row] = 'ADMSULL'
					dw_detail.object.cnta_prsp					[li_row] = 'FONDPREST'
					dw_detail.object.centro_benef				[li_row] = 'CEPIBO'
					dw_detail.object.nro_cuotas					[li_row] = 1
				end if
		next
		
		destroy ds_provbase_det

END CHOOSE
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cam304_creditos
integer x = 0
integer y = 1112
integer width = 2542
integer height = 888
string dataobject = "d_abc_creditos_det_tbl"
end type

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 			[al_row] = of_nro_item(this)
this.object.flag_estado 		[al_row] = '1'
this.object.fec_registro		[al_row] = f_fecha_actual()
this.object.cod_usr				[al_row] = gs_user



this.object.monto_prestamo		[al_row] = 0.00
this.object.monto_interes		[al_row] = 0.00
this.object.monto_comisiones	[al_row] = 0.00
this.object.monto_cuota			[al_row] = 0.00

this.object.nro_cuotas			[al_row] = 0.00

if dw_master.getRow() = 0 then return

this.object.proveedor			[al_row] = dw_master.object.proveedor				[dw_master.getRow()]
this.object.nom_proveedor		[al_row] = dw_master.object.nom_proveedor			[dw_master.getRow()]
this.object.fec_inicio_pago	[al_row] = Date(dw_master.object.fec_prestamo	[dw_master.getRow()])
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_base, ls_cencos
date		ld_fec_inicio
Integer	li_year

if dw_master.getRow() = 0 then return

choose case lower(as_columna)
		
	case "proveedor"
		
		ls_base = dw_master.object.cod_base [dw_master.getRow()]
		
		if ls_base = '' or IsNull(ls_base) then
			//MessageBox('Aviso', 'Debe Especificar una base primero, por favor verifique')
			//dw_master.setFocus()
			//dw_master.setColumn('cod_base')
			//return
			ls_base = '%%'
		else
			ls_base = trim(ls_base) + '%'
		end if

		ls_sql = "select distinct p.proveedor as proveedor, " &
				 + "p.nom_proveedor as nombre_proveedor " &
				 + "from ap_proveedor_certif  apc, " &
				 + "     proveedor            p " &
				 + "where p.proveedor = apc.proveedor " &
				 + "  and (apc.cod_base like '" + ls_base + "' or apc.cod_base is null)" &
				 + "  and p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cencos"
		
		ld_fec_inicio = Date(this.object.fec_inicio_pago [al_row])
		
		li_year = year(ld_fec_inicio)

		ls_sql = "select distinct cc.cencos as codigo_cencos, " &
			    + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo       cc, " &
				 + "     presupuesto_partida pp " &
				 + "where cc.cencos          = pp.cencos   " &
				 + "  and pp.ano = " + string(li_year)
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.ii_update = 1
		end if
	
	case "centro_benef"
		
		ls_sql = "select cb.centro_benef as centro_benef, " &
				 + "cb.desc_centro as descripcion_centro " &
				 + "from centro_beneficio cb, " &
				 + "     centro_benef_usuario cbu " &
				 + "where cb.centro_benef = cbu.centro_benef " &
				 + "  and cbu.cod_usr = '" + gs_user + "' " &
				 + "  and cb.flag_estado = '1' " &
				 + "order by cb.centro_benef"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cnta_prsp"
		
		ld_fec_inicio = Date(this.object.fec_inicio_pago [al_row])
		li_year = year(ld_fec_inicio)
		
		ls_Cencos = this.object.cencos [al_row]
		
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('AViso', 'Debe especificar un centro de costo primero, por favor verifique')
			this.SetColumn('cencos')
			return
		end if

		ls_sql = "select distinct pc.cnta_prsp as cuenta_presupuestal, " &
				 + "pc.descripcion as descripcion_cnta_prsp " &
				 + "from presupuesto_cuenta  pc, " &
				 + "     presupuesto_partida pp " &
				 + "where pc.cnta_prsp = pp.cnta_prsp  " &
				 + "  and pp.cencos = '" + ls_cencos + "' " &
				 + "  and pp.ano = " + string(li_year)
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count, ll_cuotas
decimal	ldc_interes, ldc_tasa_interes, ldc_capital_final, &
			ldc_capital_inicial, ldc_valor_cuota, ldc_comision

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'proveedor'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_desc1
		  from proveedor
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de proveedor o no se encuentra activo, por favor verifique")
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			return 1
		end if

		this.object.nom_proveedor		[row] = ls_desc1

	CASE 'cencos' 

		// Verifica que codigo ingresado exista			
		Select desc_Cencos
	     into :ls_desc1
		  from centros_Costo
		 Where cencos = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo o no se encuentra activo, por favor verifique")
			this.object.cencos		[row] = ls_null
			return 1
			
		end if

	CASE 'cnta_prsp' 

		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc1
		  from presupuesto_cuenta
		 Where cnta_prsp = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Cuenta Presupuestal o no se encuentra activo, por favor verifique")
			this.object.cnta_prsp		[row] = ls_null
			return 1
		end if

	CASE 'centro_benef' 

		// Verifica que codigo ingresado exista			
		Select desc_centro
	     into :ls_desc1
		  from 	centro_beneficio 		cb,
		  			centro_benef_usuario cbu
		 Where cb.centro_benef 	= cbu.centro_benef
		   and cb.centro_benef 	= :data  
		   and cb.flag_estado 	= '1'
			and cbu.cod_usr 	 	= :gs_user;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Beneficio, no esta asignado a su usuario o no se encuentra activo, por favor verifique")
			this.object.centro_benef		[row] = ls_null
			return 1
		end if
		
	case 'monto_prestamo'
		
		ldc_tasa_interes 	= Dec(dw_master.object.tasa_interes [dw_master.getRow()])
		ldc_comision 		= Dec(this.object.monto_comisiones [row])
		
		if IsNull(ldc_tasa_interes) then ldc_tasa_interes = 0
		
		dw_master.object.total_prestamo 	 [dw_master.getRow()] = this.object.total_monto_prestamo 	[row]
		
		//calculo los intereses
		ll_cuotas = long(this.object.nro_cuotas [row])

		if ll_cuotas > 0 then
			ldc_capital_inicial = round(Dec(data),2)
			ldc_capital_final = round(ldc_capital_inicial * ((1 + ldc_tasa_interes / 100) ^ ll_cuotas),2)
			
			ldc_interes = ldc_capital_final - ldc_capital_inicial
			
			ldc_valor_cuota = round((ldc_capital_inicial + ldc_interes + ldc_comision) / ll_cuotas,2)
		else
			ldc_valor_cuota = 0
			ldc_interes = 0
		end if
		
		this.object.monto_interes 	[row] = ldc_interes
		this.object.monto_cuota 	[row] = ldc_valor_cuota
		dw_master.object.total_interes 	 [dw_master.getRow()] = this.object.total_monto_interes 		[row]
		
		dw_master.ii_update = 1
		this.ii_update = 1
	
	case 'monto_interes'
		
		ldc_capital_inicial = Dec(this.object.monto_prestamo [row])
		
		if ldc_capital_inicial = 0 or IsNull(ldc_capital_inicial) then
			MessageBox('Aviso', 'No ha espcificado importe del prestamo!!!, por favor verifique')
			this.SetColumn('monto_prestamo')
			return 
		end if
		
		dw_master.object.total_interes 	 [dw_master.getRow()] = this.object.total_monto_interes 		[row]
		
		ldc_comision 		= Dec(this.object.monto_comisiones [row])
		ldc_interes 		= Dec(data)
		
		//calculo los intereses
		ll_cuotas = long(this.object.nro_cuotas [row])
		
		if ll_cuotas > 0 then
			ldc_valor_cuota = round((ldc_capital_inicial + ldc_interes + ldc_comision) / ll_cuotas,2)
		else
			ldc_valor_cuota = 0
		end if
		
		this.object.monto_cuota 	[row] = ldc_valor_cuota
		
		dw_master.ii_update = 1
		this.ii_update = 1

	case 'monto_comisiones'
		
		ldc_capital_inicial = Dec(this.object.monto_prestamo [row])
		
		if ldc_capital_inicial = 0 or IsNull(ldc_capital_inicial) then
			MessageBox('Aviso', 'No ha espcificado importe del prestamo!!!, por favor verifique')
			this.SetColumn('monto_prestamo')
			return 
		end if
		
		dw_master.object.total_comisiones [dw_master.getRow()] = this.object.total_monto_comisiones	[row]
		
		ldc_comision 		= Dec(data)
		ldc_interes 		= Dec(this.object.monto_interes [row])
		
		//calculo los intereses
		ll_cuotas = long(this.object.nro_cuotas [row])
		
		if ll_cuotas > 0 then
			ldc_valor_cuota = round((ldc_capital_inicial + ldc_interes + ldc_comision) / ll_cuotas,2)
		else
			ldc_valor_cuota = 0
		end if

		this.object.monto_cuota 	[row] = ldc_valor_cuota
		
		dw_master.ii_update = 1
		this.ii_update = 1

	case 'nro_cuotas'
		
		ldc_capital_inicial = Dec(this.object.monto_prestamo [row])
		
		if ldc_capital_inicial = 0 or IsNull(ldc_capital_inicial) then
			MessageBox('Aviso', 'No ha espcificado importe del prestamo!!!, por favor verifique')
			this.SetColumn('monto_prestamo')
			return 
		end if
		
		ldc_comision 		= Dec(this.object.monto_comisiones [row])
		ldc_tasa_interes 	= Dec(dw_master.object.tasa_interes [dw_master.getRow()])
		
		//calculo los intereses
		ll_cuotas = long(data)
		
		if ll_cuotas > 0 then
			
			ldc_capital_final = round(ldc_capital_inicial * ((1 + ldc_tasa_interes / 100) ^ ll_cuotas),2)
			
			ldc_interes = ldc_capital_final - ldc_capital_inicial
			
			ldc_valor_cuota = round((ldc_capital_inicial + ldc_interes + ldc_comision) / ll_cuotas,2)
		else
			ldc_valor_cuota = 0
			ldc_interes		 = 0
		end if

		this.object.monto_interes 	[row] = ldc_interes
		this.object.monto_cuota 	[row] = ldc_valor_cuota
		dw_master.object.total_interes 	 [dw_master.getRow()] = this.object.total_monto_interes 		[row]
		
		dw_master.ii_update = 1
		this.ii_update = 1
END CHOOSE
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

