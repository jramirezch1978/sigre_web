$PBExportHeader$w_cam376_solicitud_ac.srw
forward
global type w_cam376_solicitud_ac from w_abc_master
end type
type tab_1 from tab within w_cam376_solicitud_ac
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detalle from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detalle dw_detalle
end type
type tabpage_2 from userobject within tab_1
end type
type dw_insumos from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_insumos dw_insumos
end type
type tabpage_3 from userobject within tab_1
end type
type dw_registro from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_registro dw_registro
end type
type tab_1 from tab within w_cam376_solicitud_ac
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_cam376_solicitud_ac from w_abc_master
integer width = 3337
integer height = 3280
string title = "[CAM376] RG-45  Solicitud de Acciones Correctivas"
string menuname = "m_abc_anular_lista"
tab_1 tab_1
end type
global w_cam376_solicitud_ac w_cam376_solicitud_ac

type variables
u_dw_abc idw_detalle, idw_insumos, idw_registro
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
end prototypes

public subroutine of_asigna_dws ();idw_detalle 			= tab_1.tabpage_1.dw_detalle
idw_insumos 		= tab_1.tabpage_2.dw_insumos
idw_registro 	= tab_1.tabpage_3.dw_registro

end subroutine

public function integer of_set_numera ();// Numera documento
Long 	ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE NUM_SIC_SOLICITUD_ACC_COR IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from NUM_SIC_SOLICITUD_ACC_COR
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into NUM_SIC_SOLICITUD_ACC_COR (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		ll_ult_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))

	dw_master.object.nro_test[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update NUM_SIC_SOLICITUD_ACC_COR 
		set ult_nro = ult_nro + 1
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_test[dw_master.getrow()] 
end if

// Asigna numero a detalle
dw_master.object.nro_test[dw_master.getrow()] = ls_nro
for ll_j = 1 to idw_detalle.RowCount()	
	idw_detalle.object.nro_test		[ll_j] = ls_nro	
next

for ll_j = 1 to idw_insumos.RowCount()	
	idw_insumos.object.nro_test		[ll_j] = ls_nro	
next
for ll_j = 1 to idw_registro.RowCount()	
	idw_registro.object.nro_test		[ll_j] = ls_nro	
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	idw_detalle.retrieve(as_nro)
	idw_insumos.retrieve(as_nro)
	idw_registro.retrieve(as_nro)
	
	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_detalle.ii_protect = 0
	idw_detalle.ii_update	= 0
	idw_detalle.of_protect()
	idw_detalle.ResetUpdate()
	
	idw_insumos.ii_protect = 0
	idw_insumos.ii_update	= 0
	idw_insumos.of_protect()
	idw_insumos.ResetUpdate()

	idw_registro.ii_protect = 0
	idw_registro.ii_update	= 0
	idw_registro.of_protect()
	idw_registro.ResetUpdate()
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detalle.width  = tab_1.tabpage_1.width  - tab_1.tabpage_1.x - 10
idw_detalle.height = tab_1.tabpage_1.height  - tab_1.tabpage_1.y - 10

idw_insumos.width  = tab_1.tabpage_2.width  - tab_1.tabpage_2.x - 10
idw_insumos.height = tab_1.tabpage_2.height  - tab_1.tabpage_2.y - 10

idw_registro.width  = tab_1.tabpage_3.width  - tab_1.tabpage_3.x - 10
idw_registro.height = tab_1.tabpage_3.height  - tab_1.tabpage_3.y - 10
end event

on w_cam376_solicitud_ac.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_cam376_solicitud_ac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)

dw_master.AcceptText()
idw_detalle.AcceptText()
idw_insumos.AcceptText()
idw_registro.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_detalle.of_create_log()
	idw_insumos.of_create_log()
	idw_registro.of_create_log()
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF idw_detalle.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detalle.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF
IF idw_insumos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_insumos.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de idw_insumos", ls_msg, StopSign!)
	END IF
END IF

IF idw_registro.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_registro.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion registro de idw_registro", ls_msg, StopSign!)
	END IF
END IF


IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_detalle.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_insumos.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_registro.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detalle.ii_update = 0
	idw_insumos.ii_update = 0
	idw_registro.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detalle.il_totdel = 0
	idw_insumos.il_totdel = 0
	idw_registro.il_totdel = 0
		
	dw_master.ResetUpdate()
	idw_detalle.ResetUpdate()
	idw_insumos.ResetUpdate()
	idw_registro.ResetUpdate()

	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_test[dw_master.getRow()])
	end if
	
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detalle, idw_detalle.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_insumos, idw_insumos.is_dwform) <> true then	return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_registro, idw_registro.is_dwform) <> true then	return


//AutoNumeración de Registro
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_detalle.of_set_flag_replicacion()
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_sic_solicitud_acc_cor_tbl'
sl_param.titulo = 'Registro de Solicitud de Acciones Correctivas'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert;//Override
Long  ll_row

if idw_1 <> dw_master then
	if dw_master.getRow() = 0 then
		MessageBox('Error', 'No esta permitido insertar un detalle de Cuaderno del productor sin antes haber insertado la cabecera, por favor verifique')
		return
	elseif f_row_Processing( dw_master, dw_master.is_dwform) <> true then	
		return
	end if
end if


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type dw_master from w_abc_master`dw_master within w_cam376_solicitud_ac
integer width = 3227
integer height = 1008
string dataobject = "d_abc_sic_solicitud_acc_cor_cab_ff"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fec_oracle

ldt_fec_oracle = f_fecha_actual()

this.object.fec_registro 		[al_row] = ldt_fec_oracle
this.object.flag_estado 		[al_row] = '1'
this.object.fec_auditoria		[al_row] = Date(ldt_fec_oracle)
this.object.flag_may_men	[al_row] = '1'
this.SetColumn("proveedor") 

is_action = 'new'
end event

event dw_master::constructor;call super::constructor;of_asigna_dws()

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  idw_detalle

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

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "nro_certificacion"
		ls_sql = "SELECT a.nro_certificacion AS certificacion_productor, " &
				 + "a.has as area_has, " &
				 + "p.nro_doc_ident AS nro_doc_ident, " &
				 + "p.nom_proveedor AS nombre_productor, " &
				 + "p.ruc AS ruc_productor " &
				 + "FROM AP_PROVEEDOR_CERTIF a, " &
				 +"      ap_proveedor_mp mp, " &
				 + "     proveedor p " &
				 + "WHERE a.proveedor = p.proveedor " &
				 + "  and a.proveedor = mp.proveedor " &
				 + "  and p.FLAG_ESTADO = '1' " &
				 + "  and mp.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.nro_certificacion	[al_row] = ls_codigo
			this.object.nom_productor	[al_row] = ls_data3
			this.ii_update = 1
		end if
		
	case "cod_cuadrilla"
		ls_sql = "SELECT a.cod_cuadrilla AS cod_cuadrilla, " &
				 + "a.DESC_cuadrilla as DESC_cuadrilla, " &
				 + "a.FLAG_ESTADO AS FLAG_ESTADO, " &
				 + "a.jefe_cuadrilla AS jefe_cuadrilla " &
				 + "FROM ap_cuadrilla  a " &
				 + "WHERE  a.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.cod_cuadrilla	[al_row] = ls_codigo
			this.object.desc_cuadrilla[al_row] = ls_data

			this.ii_update = 1
		end if

		case "proveedor"
		ls_sql = "SELECT p.proveedor AS codigo, " &
				 + "p.nom_proveedor as nombre, " &
 				 + "p.proveedor AS codigo1, " &
 				 + "p.proveedor AS codigo2 " &
				 + "FROM proveedor p " &
				 + "WHERE  p.FLAG_ESTADO = '1' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.proveedor	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "nro_certificacion"

		SELECT p.nom_proveedor 
				into :ls_desc1
			FROM AP_PROVEEDOR_CERTIF a, 
				 	ap_proveedor_mp mp, 
				     proveedor p 
				 WHERE a.proveedor = p.proveedor 
				 and a.nro_certificacion = :data
				 and a.proveedor = mp.proveedor 
				 and p.FLAG_ESTADO = '1' 
				 and mp.flag_estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Numero de Certificado o el productor no se encuentra activo, por favor verifique")
			this.object.nro_certificacion	[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			return 1
		end if
		
	this.object.nro_certificacion	[row] = data
	this.object.nom_proveedor		[row] = ls_desc1
	
END CHOOSE
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from tab within w_cam376_solicitud_ac
integer y = 1016
integer width = 3232
integer height = 1968
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
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
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
integer y = 16
integer width = 2528
integer height = 1936
long backcolor = 79741120
string text = "Detalles de la ~r~nNo Conformidad"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detalle dw_detalle
end type

on tabpage_1.create
this.dw_detalle=create dw_detalle
this.Control[]={this.dw_detalle}
end on

on tabpage_1.destroy
destroy(this.dw_detalle)
end on

type dw_detalle from u_dw_abc within tabpage_1
integer width = 2153
integer height = 1360
integer taborder = 20
string dataobject = "d_abc_sic_solicitud_ac_nc_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item(this)
this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.cod_usr 		[al_row] = gs_user
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 	dw_master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event clicked;call super::clicked;string ls_sql, ls_codigo , ls_data, ls_data2, ls_data3
boolean 	lb_ret
u_ds_base 	ds_imp
Integer 		li_i, li_row, li_j

choose case lower(dwo.name)
	case 'b_imp'

		ls_sql = "select sgbt.nro_test as codigo, sgbt.fec_realizado as fecha " &
				+ " , sgbt.nro_certificacion as nro_certificacion, sgbt.nro_certificacion_gg as nro_cert_gg " &
				+ " from SIC_GLOBAL_BAP_TEST sgbt " &
				+ " where sgbt.nro_certificacion = '" + dw_master.object.nro_certificacion [dw_master.getRow()] + "'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')			

		if ls_codigo <> '' then
				ds_imp = create u_ds_base
				ds_imp.DataObject = 'd_sic_global_gap_no_just_tbl'
				ds_imp.SetTransObject(SQLCA)
				ds_imp.Retrieve(ls_codigo)
				
				for li_i=1 to ds_imp.RowCount()
						li_row = dw_detalle.event ue_insert()
						if li_row > 0 then
							dw_detalle.object.punto_control 					[li_row] = ds_imp.object.cod_req [li_i]
							dw_detalle.object.descripcion 						[li_row] = ds_imp.object.justificacion [li_i]
						end if
				next
				
				destroy ds_imp		
		end if
end choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2528
integer height = 1936
long backcolor = 79741120
string text = "Acción Correctiva~r~npara Evitar Recurrencia"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_insumos dw_insumos
end type

on tabpage_2.create
this.dw_insumos=create dw_insumos
this.Control[]={this.dw_insumos}
end on

on tabpage_2.destroy
destroy(this.dw_insumos)
end on

type dw_insumos from u_dw_abc within tabpage_2
integer width = 2162
integer height = 1224
string dataobject = "d_abc_sic_solicitud_ac_ac_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item(this)
this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.fecha			[al_row] = date(f_fecha_actual())
this.object.cod_usr 		[al_row] = gs_user
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "und"

		SELECT a.desc_unidad 
				into :ls_desc1
			FROM unidad a
				 WHERE a.und = :data;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Unidad")
			this.object.und		[row] = ls_null
			return 1
		end if
		
	this.object.unidad	[row] = data
	
END CHOOSE
end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
	case "und"
		ls_sql = "SELECT a.und AS codigo_unidad, " &
				 + "a.desc_unidad as desc_unidad, " &
				 + "p.tipo_und AS tipo_und, " &
				 + "p.flag_estado AS flag_estado " &
				 + "FROM unidad a " &
				 + "WHERE a.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.und	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 2528
integer height = 1936
long backcolor = 79741120
string text = "Aceptación de la ~r~nAcción Correctiva"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_registro dw_registro
end type

on tabpage_3.create
this.dw_registro=create dw_registro
this.Control[]={this.dw_registro}
end on

on tabpage_3.destroy
destroy(this.dw_registro)
end on

type dw_registro from u_dw_abc within tabpage_3
integer width = 1664
integer height = 1108
integer taborder = 30
string dataobject = "d_abc_sic_solicitud_ac_aac_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item(this)
this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.fecha			[al_row] = date(f_fecha_actual())
this.object.cod_usr 		[al_row] = gs_user
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

