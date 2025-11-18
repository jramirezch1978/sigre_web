$PBExportHeader$w_cam390_control_contenedor.srw
forward
global type w_cam390_control_contenedor from w_abc_master
end type
type dw_detalle from u_dw_abc within w_cam390_control_contenedor
end type
end forward

global type w_cam390_control_contenedor from w_abc_master
integer width = 3337
integer height = 3280
string title = "[CAM390] Control de Contenedor"
string menuname = "m_abc_anular_lista"
dw_detalle dw_detalle
end type
global w_cam390_control_contenedor w_cam390_control_contenedor

type variables
u_dw_abc idw_detalle
end variables

forward prototypes
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
public subroutine of_retrieve_productor (datawindow ad_dw, string as_nro_certif, long al_row)
end prototypes

public subroutine of_asigna_dws ();idw_detalle 		= dw_detalle

end subroutine

public function integer of_set_numera ();// Numera documento
Long 	ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE NUM_SIC_CONTROL_CONT IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from NUM_SIC_CONTROL_CONT
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into NUM_SIC_CONTROL_CONT (cod_origen, ult_nro)
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

	dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update NUM_SIC_CONTROL_CONT 
		set ult_nro = ult_nro + 1
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_registro[dw_master.getrow()] 
end if

// Asigna numero a detalle
dw_master.object.nro_registro[dw_master.getrow()] = ls_nro
for ll_j = 1 to idw_detalle.RowCount()	
	idw_detalle.object.nro_registro		[ll_j] = ls_nro	
next

return 1
end function

public subroutine of_retrieve (string as_nro);Long ll_row, ll_ano, ll_mes

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

if ll_row > 0 then
	// Fuerza a leer detalle
	idw_detalle.retrieve(as_nro)

	dw_master.ii_protect = 0
	dw_master.ii_update	= 0
	dw_master.of_protect()
	dw_master.ResetUpdate()
	
	idw_detalle.ii_protect = 0
	idw_detalle.ii_update	= 0
	idw_detalle.of_protect()
	idw_detalle.ResetUpdate()
	
	
	// Para no dar click sobre la cabecera al adicionar items
	dw_master.il_row = dw_master.getrow()	
	is_action = 'open'
end if

return 
end subroutine

public subroutine of_retrieve_productor (datawindow ad_dw, string as_nro_certif, long al_row);String ls_desc_base, ls_nom_productor, ls_nro_doc_ident, ls_grado_inst, ls_estado_civil 
String	ls_caserio, ls_distrito, ls_provincia, ls_departamento, ls_nombre_conyuge, ls_dni_conyuge 
Integer li_edad_conyuge, li_nro_hijos

select p.nom_proveedor, p.nro_doc_ident, 
       apm.distrito, apm.provincia, apm.departamento, apm.caserio, apm.grado_instruccion, apm.flag_estado_civil, 
       apm.nombre_conyuge, apm.dni_conyuge, apm.edad, apm.nro_hijos, apb.desc_base
into :ls_nom_productor, :ls_nro_doc_ident, :ls_distrito, :ls_provincia, :ls_departamento, :ls_caserio, :ls_grado_inst,
	  :ls_estado_civil, :ls_nombre_conyuge, :ls_dni_conyuge, :li_edad_conyuge, :li_nro_hijos, :ls_desc_base
from ap_proveedor_certif    apc,
     proveedor              p,
     ap_proveedor_mp        apm,
     ap_bases               apb
where apc.nro_certificacion = :as_nro_certif
  and apc.proveedor         = p.proveedor     
  and apc.proveedor         = apm.proveedor
  and apc.cod_base          = apb.cod_base;
  
ad_dw.object.nom_proveedor[al_row] 		= ls_nom_productor
ad_dw.object.nro_doc_ident[al_row] 			= ls_nro_doc_ident
ad_dw.object.distrito[al_row] 					= ls_distrito
ad_dw.object.provincia[al_row] 				= ls_provincia
ad_dw.object.departamento[al_row] 			= ls_departamento
ad_dw.object.caserio[al_row] 					= ls_caserio
ad_dw.object.grado_instruccion[al_row] 	= ls_grado_inst
ad_dw.object.flag_estado_civil[al_row] 		= ls_estado_civil
ad_dw.object.nombre_conyuge[al_row] 		= ls_nombre_conyuge
ad_dw.object.dni_conyuge[al_row] 			= ls_dni_conyuge
ad_dw.object.edad[al_row]		 				= li_edad_conyuge
ad_dw.object.nro_hijos[al_row] 				= li_nro_hijos
ad_dw.object.desc_base[al_row] 				= ls_desc_base
end subroutine

event resize;//Override
of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

idw_detalle.width  = newwidth  - idw_detalle.x - 10
idw_detalle.height = newheight  - idw_detalle.y - 10


end event

on w_cam390_control_contenedor.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.dw_detalle=create dw_detalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detalle
end on

on w_cam390_control_contenedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detalle)
end on

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_detalle.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_detalle.of_create_log()

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

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = idw_detalle.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detalle.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_detalle.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_detalle.ResetUpdate()

	if dw_master.getRow() > 0 then
		of_retrieve(dw_master.object.nro_registro[dw_master.getRow()])
	end if
	
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detalle, idw_detalle.is_dwform) <> true then	return

//AutoNumeración de Registro
if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_detalle.of_set_flag_replicacion()
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_sic_control_cont_tbl'
sl_param.titulo = 'Registro de Control de Contenedor'
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
		MessageBox('Error', 'No esta permitido insertar un detalle sin antes haber insertado la cabecera, por favor verifique')
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

type dw_master from w_abc_master`dw_master within w_cam390_control_contenedor
integer width = 3150
integer height = 548
string dataobject = "d_abc_sic_control_cont_cab_ff"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fec_oracle

ldt_fec_oracle = f_fecha_actual()

this.object.fec_registro 			[al_row] = ldt_fec_oracle
this.object.cod_usr 				[al_row] = gs_user
this.object.flag_estado			[al_row] = '1'

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

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, &
			ls_nro_ot, ls_labor, ls_null
SetNull(ls_null)			

choose case lower(as_columna)
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
		
	case "tipo_funda"
		ls_sql = "SELECT p.tipo_funda AS tipo_funda, " &
				 + "p.DESC_TIPO_FUNDA as DESC_TIPO_FUNDA, " &
 				 + "p.COD_ART AS COD_ART, " &
 				 + "p.FLAG_ESTADO AS FLAG_ESTADO " &
				 + "FROM AP_TIPO_FUNDA p " &
				 + "WHERE  p.FLAG_ESTADO = '1' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.tipo_funda	[al_row] = ls_codigo
			this.object.desc_tipo_funda	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "nro_guia"
		ls_sql = "SELECT p.cod_origen AS cod_origen, " &
				 + "p.NRO_GUIA as NRO_GUIA, " &
 				 + "p.DESTINATARIO AS DESTINATARIO, " &
 				 + "p.FLAG_ESTADO AS FLAG_ESTADO " &
				 + "FROM GUIA p " &
				 + "WHERE  p.FLAG_ESTADO = '1' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.org_guia	[al_row] = ls_codigo
			this.object.nro_guia	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose

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

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
decimal	ldc_has
Long 		ll_count
Date		ld_fecha

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name

	case "proveedor"

		SELECT p.proveedor, p.nom_proveedor
				into :ls_desc1, :ls_desc2
			FROM proveedor p 
				 WHERE p.proveedor = :data
				 and p.FLAG_ESTADO = '1' ;
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Códigoo o no se encuentra activo, por favor verifique")
			this.object.proveedor	[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			return 1
		end if
		
			this.object.proveedor				[row] = ls_desc1
			this.object.nom_proveedor		[row] = ls_desc2
	
	case "fec_salida"

		this.object.inicio_llenado			[row]	= DateTime(Date(data), Time("08:00:00"))
		this.object.fin_llenado				[row]	= DateTime(Date(data), Time("16:00:00"))
		this.object.hora_llegada_cont	[row]	= DateTime(Date(data), Time("10:00:00"))
		
END CHOOSE
end event

type dw_detalle from u_dw_abc within w_cam390_control_contenedor
integer x = 5
integer y = 572
integer width = 3136
integer height = 1816
boolean bringtotop = true
string dataobject = "d_abc_sic_control_cont_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

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

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 	[al_row] = of_nro_item(this)

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

event ue_display;call super::ue_display;string 	ls_codigo, ls_data, ls_data2, ls_data3, ls_sql, ls_ot_adm, ls_nro_ot, ls_labor, ls_null
boolean 	lb_ret
SetNull(ls_null)			

choose case lower(as_columna)
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
		
	case "tipo_certificacion"
		ls_sql = "SELECT p.TIPO_CERTIFICACION AS codigo, " &
				 + "p.DESC_CERTIFICACION as nombre, " &
 				 + "p.TIPO_CERTIFICACION AS codigo1, " &
 				 + "p.flag_estado AS Estado " &
				 + "FROM AP_TIPO_CERTIFICACION p " &
				 + "WHERE  p.FLAG_ESTADO = '1' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.tipo_certificacion	[al_row] = ls_codigo
			this.object.DESC_CERTIFICACION	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_art"
		ls_sql = "select distinct a.cod_art as codigo, a.desc_art as descripcion, " &
			+ " a.nom_articulo as nombre, a.flag_estado  as estado " &
 			+ " from AP_TIPO_CERTIFICACION_det p, " &
      	+ " articulo a " &
		+ "  where a.cod_art = p.cod_art_pptt "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.ii_update = 1
		end if

END CHOOSE
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc1
decimal	ldc_has
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE lower(dwo.name)

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
	
	case "pallet_01"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_01 [row] = 0
				return 1
			end if		
	case "pallet_02"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_02 [row] = 0
				return 1
			end if		
	case "pallet_03"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_03 [row] = 0
				return 1
			end if		
	case "pallet_04"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_04 [row] = 0
				return 1
			end if		
	case "pallet_05"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_05 [row] = 0
				return 1
			end if		
	case "pallet_06"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_06 [row] = 0
				return 1
			end if		
	case "pallet_07"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_07 [row] = 0
				return 1
			end if		
	case "pallet_08"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_08 [row] = 0
				return 1
			end if		
	case "pallet_09"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_09 [row] = 0
				return 1
			end if		
	case "pallet_10"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_10 [row] = 0
				return 1
			end if		
	case "pallet_11"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_11 [row] = 0
				return 1
			end if		
	case "pallet_12"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_12 [row] = 0
				return 1
			end if		
	case "pallet_13"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_13 [row] = 0
				return 1
			end if		
	case "pallet_14"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_14 [row] = 0
				return 1
			end if		
	case "pallet_15"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_15 [row] = 0
				return 1
			end if		
	case "pallet_16"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_16 [row] = 0
				return 1
			end if		
	case "pallet_17"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_17 [row] = 0
				return 1
			end if		
	case "pallet_18"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_18 [row] = 0
				return 1
			end if		
	case "pallet_19"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_19 [row] = 0
				return 1
			end if		
	case "pallet_20"
			if this.object.cajas_max [row ]< this.object.nro_cajas [row] then
				Messagebox("Aviso", "La Cantidad Máxima de Cajas Totales es de "+string(this.object.cajas_max [row ]))
				this.object.pallet_20 [row] = 0
				return 1
			end if		

END CHOOSE


end event

