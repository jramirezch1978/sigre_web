$PBExportHeader$w_cam309_liquidacion_cosecha.srw
forward
global type w_cam309_liquidacion_cosecha from w_abc_master_smpl
end type
type tab_1 from tab within w_cam309_liquidacion_cosecha
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_trans_cana from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_trans_cana dw_trans_cana
end type
type tabpage_3 from userobject within tab_1
end type
type dw_gastos_mol from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_gastos_mol dw_gastos_mol
end type
type tab_1 from tab within w_cam309_liquidacion_cosecha
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_cam309_liquidacion_cosecha from w_abc_master_smpl
integer width = 2587
integer height = 2204
string title = "[CAM309] Liquidacion de Cosecha"
string menuname = "m_abc_anular_lista"
boolean maxbox = false
boolean resizable = false
tab_1 tab_1
end type
global w_cam309_liquidacion_cosecha w_cam309_liquidacion_cosecha

type variables
String is_soles, is_salir

u_dw_abc	idw_detail, idw_gastos_mol, idw_trans_cana
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public function integer of_get_param ()
public subroutine of_asigna_dws ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE num_cam_liq_cosecha IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_cam_liq_cosecha
 	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_cam_liq_cosecha (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		ll_ult_nro = 1
	end if
	
	//	 Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_liquidacion[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update num_cam_liq_cosecha 
		set ult_nro = :ll_ult_nro + 1 
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_liquidacion[dw_master.getrow()] 
end if

// Asigna numero a detalle
dw_master.object.nro_liquidacion[dw_master.getrow()] = ls_nro

for ll_j = 1 to idw_detail.RowCount()	
	idw_detail.object.nro_liquidacion[ll_j] = ls_nro	
next

for ll_j = 1 to idw_trans_cana.RowCount()	
	idw_trans_cana.object.nro_liquidacion[ll_j] = ls_nro	
next

for ll_j = 1 to idw_gastos_mol.RowCount()	
	idw_gastos_mol.object.nro_liquidacion[ll_j] = ls_nro	
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_nro)

if dw_master.getRow() > 0 then
	idw_detail.Retrieve(as_nro)
	idw_trans_cana.Retrieve(as_nro)
	idw_gastos_mol.Retrieve(as_nro)
end if

is_action = 'open'

return 
end subroutine

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

//// busca tipos de movimiento definidos
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

if ISNULL( is_soles ) or TRIM( is_soles ) = '' then
	Messagebox("Error", "Defina Codigo de Moneda Soles en logparam")
	return 0
end if

return 1
end function

public subroutine of_asigna_dws ();idw_detail 		= tab_1.tabpage_1.dw_detail
idw_trans_cana = tab_1.tabpage_2.dw_trans_cana
idw_gastos_mol = tab_1.tabpage_3.dw_gastos_mol
end subroutine

on w_cam309_liquidacion_cosecha.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_cam309_liquidacion_cosecha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

if f_row_Processing( idw_detail, idw_detail.is_dwform) <> true then return
if f_row_Processing( idw_trans_cana, idw_trans_cana.is_dwform) <> true then return
if f_row_Processing( idw_gastos_mol, idw_gastos_mol.is_dwform) <> true then return

ib_update_check = true

if of_set_numera() = 0 then return

dw_master.of_set_flag_replicacion()


end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_cam_liq_cosecha_tbl'
sl_param.titulo = 'Liquidaciones de Cosecha'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_lec_mst = 0 
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width	= tab_1.tabpage_1.width - idw_detail.x - 10
idw_detail.height	= tab_1.tabpage_1.height - idw_detail.y - 10

idw_trans_cana.width	 = tab_1.tabpage_2.width - idw_trans_cana.x - 10
idw_trans_cana.height = tab_1.tabpage_2.height - idw_trans_cana.y - 10

idw_gastos_mol.width	 = tab_1.tabpage_3.width - idw_gastos_mol.x - 10
idw_gastos_mol.height = tab_1.tabpage_3.height - idw_gastos_mol.y - 10
end event

event ue_insert;//Override
Long  ll_row

if idw_1 = idw_trans_cana or idw_1 = idw_detail then
	MessageBox('Error', 'No esta permitido insertar registros en la pestaña seleccionada')
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update;//override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()
idw_detail.AcceptText()
idw_trans_cana.AcceptText()
idw_gastos_mol.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

dw_master.of_create_log()
idw_detail.of_create_log()
idw_trans_cana.of_create_log()
idw_gastos_mol.of_create_log()

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	idw_detail.ii_update = 1 THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Detalle de Molienda')
	END IF
END IF

IF	idw_gastos_mol.ii_update = 1 THEN
	IF idw_gastos_mol.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Gastos de molienda')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_detail.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_trans_cana.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_gastos_mol.of_save_log()
	END IF


END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	idw_detail.ii_update = 0
	idw_detail.il_totdel = 0
	
	idw_trans_cana.ii_update = 0
	idw_trans_cana.il_totdel = 0
	
	idw_gastos_mol.ii_update = 0
	idw_gastos_mol.il_totdel = 0
	
	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_liquidacion[dw_master.getRow()])
	end if
	
END IF

end event

event ue_delete;//Override
Long  	ll_row
String	ls_nro_ticket, ls_mensaje

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

if idw_1 = idw_trans_cana and idw_trans_cana.RowCount() > 0 then
	ls_nro_ticket = idw_1.object.nro_ticket [idw_1.getRow()]
	update cam_transporte_cana
	   set nro_liquidacion = null
	where nro_ticket = :ls_nro_ticket;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al actualizar cam_transporte_cana', ls_mensaje)
		return
	end if
	
	idw_trans_cana.REtrieve(dw_master.object.nro_liquidacion[dw_master.getRow()])
	idw_trans_Cana.ii_update = 0
	return
end if

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_cam309_liquidacion_cosecha
integer x = 0
integer y = 0
integer width = 2551
integer height = 716
string dataobject = "d_abc_cam_liq_cosecha_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro		[al_row] = f_fecha_Actual()
this.object.fec_liquidacion	[al_row] = Date(f_fecha_Actual())
this.object.cod_usr				[al_row] = gs_user
this.object.cod_moneda			[al_row] = is_soles
this.object.flag_estado			[al_row] = '1'
this.object.cod_origen			[al_row] = gs_origen

this.setColumn('fec_liquidacion')

is_action = "new"

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ruc, ls_sembrador, ls_cencos, ls_desc_cencos
choose case lower(as_columna)
	case "sembrador"
		ls_sql = "SELECT distinct p.proveedor AS proveedor, " &
				  + "p.nom_proveedor AS razon_social, " &
				  + "p.ruc AS ruc " &
				  + "FROM proveedor p, " &
				  + "		 campo_Sembradores cs, " &
				  + "     campo_molienda    cm, " &
				  + "(select cod_molienda from campo_molienda minus select cod_molienda from cam_liq_cosecha_mol) qry " & 
				  + "WHERE cm.cod_campo = cs.cod_campo " &
				  + "  and qry.cod_molienda = cm.cod_molienda " &
				  + "  and cs.proveedor = p.proveedor " &
				  + "  and p.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')

		if ls_codigo <> '' then
			this.object.sembrador			[al_row] = ls_codigo
			this.object.nom_sembrador		[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_campo"
		ls_sembrador = this.object.sembrador [al_Row]
		
		
		if IsNull(ls_sembrador) or ls_sembrador = '' then
			MessageBox('Error', 'Debe Seleccionar primero un sembrador, por favor verifique')
			this.setColumn('sembrador')
			return
		end if
		
		ls_sql = "SELECT distinct c.cod_campo AS codigo_campo, " &
				  + "c.desc_campo AS descripcion_campo, " &
				  + "cc.cencos as codigo_Cencos, " &
				  + "cc.desc_cencos as descripcion_cencos " &
				  + "FROM campo c, " &
				  + "     campo_sembradores cs, " &
				  + "     centros_costo		 cc, " &
				  + "     campo_molienda    cm, " &
				  + "(select cod_molienda from campo_molienda minus select cod_molienda from cam_liq_cosecha_mol) qry " & 
				  + "WHERE cm.cod_campo = cs.cod_campo " &
				  + "  and qry.cod_molienda = cm.cod_molienda " &
				  + "  and cs.cod_campo = c.cod_Campo " &
				  + "  and c.cencos     = cc.cencos " &
				  + "  and cs.proveedor = '" + ls_sembrador + "'" &
				  + "  and c.FLAG_ESTADO = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_cencos, ls_desc_Cencos, '2')

		if ls_codigo <> '' then
			this.object.cod_campo	[al_row] = ls_codigo
			this.object.desc_campo	[al_row] = ls_data
			this.object.cencos		[al_row] = ls_cencos
			this.object.desc_Cencos	[al_row] = ls_Desc_Cencos
			this.ii_update = 1
		end if


	case "cencos"
		ls_sql = "SELECT cc.cencos AS centro_costo, " &
				  + "desc_cencos AS descripcion_centro_Costo " &
				  + "FROM centros_costo cc " &
				  + "WHERE cc.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_Data
			this.ii_update = 1
		end if

	case "cod_moneda"
		ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
				  + "descripcion AS descripcion_moneda " &
				  + "FROM moneda " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_campo'
		
		// Verifica que codigo ingresado exista			
		Select desc_campo
	     into :ls_desc1
		  from campo
		 Where cod_campo = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Campo o no se encuentra activo, por favor verifique")
			this.object.cod_campo	[row] = ls_null
			this.object.desc_campo	[row] = ls_null
			return 1
			
		end if

		this.object.desc_campo		[row] = ls_desc1

	CASE 'sembrador'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor, ruc
	     into :ls_desc1, :ls_desc2
		  from proveedor
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de proveedor o no se encuentra activo, por favor verifique")
			this.object.sembrador		[row] = ls_null
			this.object.nom_sembrador	[row] = ls_null
			return 1
		end if

		this.object.nom_sembrador		[row] = ls_desc1

	CASE 'cencos'
		
		// Verifica que codigo ingresado exista			
		Select desc_cencos
	     into :ls_desc1
		  from centros_Costo
		 Where cencos = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Centro de Costo no existe o no se encuentra activo, por favor verifique")
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if

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
			MessageBox("Error", "No existe Codigo de Moneda o no se encuentra activo, por favor verifique")
			this.object.cod_moneda	[row] = ls_null
			return 1
		end if

END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::buttonclicked;call super::buttonclicked;String 		ls_null, ls_campo, ls_texto, ls_nro_ticket, ls_nro_liquidacion, ls_mensaje
Integer		li_row, li_find
u_ds_base 	lds_datos
		
this.Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'b_molienda'
		
		ls_campo = this.object.cod_campo [row]
		
		if IsNull(ls_campo) or ls_campo = '' then
			MessageBox("Error", "Debe especificar un codigo de campo, por favor verifique")
			this.setcolumn("cod_campo")
			return
		end if
		
		// Verifica que codigo ingresado exista			
		lds_datos = create u_ds_base
		lds_datos.DataObject = 'd_list_campo_molienda_grd'
		lds_datos.setTransObject(SQLCA)
		lds_datos.retrieve(ls_campo)
		
		if lds_datos.RowCount() = 0 then
			MessageBox('Error', 'No hay partes de cosecha sin liquidar, por favor verifique')
		else
			for li_row = 1 to lds_datos.RowCount() 
				ls_texto = "cod_molienda='" + lds_datos.object.cod_molienda[li_row] +"'"
				li_find = idw_Detail.Find(ls_texto, 1, idw_detail.Rowcount())
				
				if li_find = 0 then
					li_find = idw_detail.event ue_insert()
					if li_find > 0 then
						idw_detail.object.cod_molienda[li_find] = lds_datos.object.cod_molienda	[li_row]
						idw_detail.object.fec_molienda[li_find] = lds_datos.object.fec_molienda	[li_row]
						idw_detail.object.cant_bruta	[li_find] = lds_datos.object.cant_bruta	[li_row]
						idw_detail.object.cant_neta	[li_find] = lds_datos.object.cant_neta		[li_row]
						idw_detail.object.impureza		[li_find] = lds_datos.object.impureza		[li_row]
						idw_detail.object.brix			[li_find] = lds_datos.object.brix			[li_row]
						idw_detail.object.bolsas_netas[li_find] = lds_datos.object.bolsas_netas	[li_row]
						idw_detail.object.kg_tmc		[li_find] = lds_datos.object.kg_tmc			[li_row]
						idw_detail.object.cod_usr		[li_find] = gs_user
						idw_detail.object.precio_unit	[li_find] = 0.00
					end if
					
				end if
				
			next
		end if
		
		
		destroy lds_datos

	CASE 'b_transporte'
		
		ls_campo = this.object.cod_campo [row]
		
		if IsNull(ls_campo) or ls_campo = '' then
			MessageBox("Error", "Debe especificar un codigo de campo, por favor verifique")
			this.setcolumn("cod_campo")
			return
		end if
		
		ls_nro_liquidacion = this.object.nro_liquidacion [row]
		if IsNull(ls_nro_liquidacion) or ls_nro_liquidacion = '' then
			MessageBox("Error", "Debe grabar primero el documento de liquidacion antes de jalar los tickets, por favor verifique")
			return
		end if
		
		lds_datos = create u_ds_base
		lds_datos.DataObject = 'd_list_cam_trans_cana_grd'
		lds_datos.setTransObject(SQLCA)
		lds_datos.retrieve(ls_campo)
		
		if lds_datos.RowCount() = 0 then
			MessageBox('Error', 'No hay tickets de transporte sin liquidar, por favor verifique')
		else
			for li_row = 1 to lds_datos.RowCount() 
				ls_nro_ticket = lds_datos.object.nro_Ticket [li_row]
				
				update cam_transporte_cana
				   set nro_liquidacion = :ls_nro_liquidacion
				 where nro_ticket = :ls_nro_ticket;
				
				IF SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MEssageBox('Error al actualizar cam_transporte_cana', ls_mensaje)
					exit
				end if
				
			next
			of_Retrieve(ls_nro_liquidacion)
		end if
		
		destroy lds_datos

END CHOOSE
end event

type tab_1 from tab within w_cam309_liquidacion_cosecha
integer y = 728
integer width = 2409
integer height = 1208
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
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
integer width = 2373
integer height = 1080
long backcolor = 79741120
string text = "Partes de Molienda"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer width = 2446
integer height = 1004
integer taborder = 20
string dataobject = "d_abc_cam_liq_cosecha_mol_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
is_dwform = 'tabular'

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_row] = f_fecha_Actual()
this.object.cod_usr			[al_row] = gs_user
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2373
integer height = 1080
long backcolor = 79741120
string text = "Transporte Caña"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_trans_cana dw_trans_cana
end type

on tabpage_2.create
this.dw_trans_cana=create dw_trans_cana
this.Control[]={this.dw_trans_cana}
end on

on tabpage_2.destroy
destroy(this.dw_trans_cana)
end on

type dw_trans_cana from u_dw_abc within tabpage_2
integer width = 1783
integer height = 848
integer taborder = 20
string dataobject = "d_abc_cam_liq_cosecha_trans_cana_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1	
is_dwform = 'tabular'
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2373
integer height = 1080
long backcolor = 79741120
string text = "Gastos Molienda"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_gastos_mol dw_gastos_mol
end type

on tabpage_3.create
this.dw_gastos_mol=create dw_gastos_mol
this.Control[]={this.dw_gastos_mol}
end on

on tabpage_3.destroy
destroy(this.dw_gastos_mol)
end on

type dw_gastos_mol from u_dw_abc within tabpage_3
integer width = 2336
integer height = 1016
integer taborder = 20
string dataobject = "d_abc_cam_liq_cosecha_gastos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1	
ii_ck[2] = 2	
is_dwform = 'tabular'
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_Row] = f_fecha_actual()
this.object.cod_usr			[al_row] = gs_user
this.object.nro_item			[al_row] = of_nro_item(this)

this.object.factor			[al_row] = 1
this.object.km					[al_row] = 0.00
this.object.tm					[al_row] = 0.00
this.object.costo				[al_row] = 0.00

this.object.flag_incluye_igv	[al_row] = '0'

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ruc
choose case lower(as_columna)
	case "servicio"
		ls_sql = "SELECT servicio AS codigo_Servicio, " &
				  + "descripcion AS descripcion_servicio " &
				  + "FROM servicios " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.servicio			[al_row] = ls_codigo
			this.object.desc_servicio	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "proveedor"
		ls_sql = "SELECT proveedor AS proveedor, " &
				  + "nom_proveedor AS razon_social, " &
				  + "ruc AS ruc " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')

		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.ruc				[al_row] = ls_ruc
			this.ii_update = 1
		end if
		
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'servicio'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc1
		  from servicios
		 Where servicio = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Servicio o no se encuentra activo, por favor verifique")
			this.object.servicio			[row] = ls_null
			this.object.desc_Servicio	[row] = ls_null
			return 1
			
		end if

		this.object.desc_Servicio		[row] = ls_desc1

	CASE 'proveedor'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor, ruc
	     into :ls_desc1, :ls_desc2
		  from proveedor
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de proveedor de Transporte o no se encuentra activo, por favor verifique")
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			this.object.ruc				[row] = ls_null
			return 1
		end if

		this.object.nom_sembrador		[row] = ls_desc1
		this.object.ruc					[row] = ls_desc2

END CHOOSE
end event

