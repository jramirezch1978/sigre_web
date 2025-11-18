$PBExportHeader$w_cam354_monitoreo_roedores.srw
forward
global type w_cam354_monitoreo_roedores from w_abc_master
end type
type dw_detalle from u_dw_abc within w_cam354_monitoreo_roedores
end type
end forward

global type w_cam354_monitoreo_roedores from w_abc_master
integer width = 3337
integer height = 3280
string title = "[CM354] RG-38 Monitoreo de Roedores"
string menuname = "m_abc_anular_lista"
dw_detalle dw_detalle
end type
global w_cam354_monitoreo_roedores w_cam354_monitoreo_roedores

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

	ls_table = 'LOCK TABLE NUM_SIC_REG_MONIT_ROEDORES IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_ult_nro 
	from NUM_SIC_REG_MONIT_ROEDORES
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into NUM_SIC_REG_MONIT_ROEDORES (cod_origen, ult_nro)
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
	Update NUM_SIC_REG_MONIT_ROEDORES 
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

on w_cam354_monitoreo_roedores.create
int iCurrent
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
this.dw_detalle=create dw_detalle
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detalle
end on

on w_cam354_monitoreo_roedores.destroy
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

sl_param.dw1    = 'd_list_sic_reg_monit_roed_tbl'
sl_param.titulo = 'Registro de Monitoreo de Roedores'
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

type dw_master from w_abc_master`dw_master within w_cam354_monitoreo_roedores
integer width = 3150
integer height = 844
string dataobject = "d_abc_sic_reg_monit_roed_cab_ff"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dateTime ldt_fec_oracle

ldt_fec_oracle = f_fecha_actual()

this.object.fec_registro 		[al_row] = ldt_fec_oracle
this.object.cod_usr 			[al_row] = gs_user
this.object.fec_limpieza 		[al_row] = Date(ldt_fec_oracle)
this.object.flag_estado		[al_row] = '1'
this.object.mes					[al_row] = 1
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
	case "almacen"
		ls_sql = "SELECT a.almacen AS codigo_almacen, " &
				 + "a.DESC_ALMACEN as DESC_ALMACEN, " &
				 + "a.FLAG_ESTADO AS FLAG_ESTADO, " &
				 + "a.COD_ORIGEN AS COD_ORIGEN " &
				 + "FROM almacen  a " &
				 + "WHERE  a.flag_estado = '1'"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '1')

		if ls_codigo <> '' then
			this.object.almacen	[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data

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

	case "almacen"
		SELECT a.desc_almacen
				into :ls_desc1
			FROM almacen a
				 WHERE a.almacen = :data
				 and a.flag_estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Almacen no se encuentra activo, por favor verifique")
			this.object.almacen	[row] = ls_null
			this.object.desc_almacen			[row] = ls_null
			return 1
			
		end if
		
			this.object.almacen	[row] = data
			this.object.desc_almacen			[row] = ls_desc1
		
END CHOOSE
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detalle from u_dw_abc within w_cam354_monitoreo_roedores
integer x = 5
integer y = 880
integer width = 3136
integer height = 1508
boolean bringtotop = true
string dataobject = "d_abc_sic_reg_monit_roed_det_tbl"
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
this.object.fecha 		[al_row] = date(f_fecha_actual())
this.object.semana	[al_row] = 0
this.object.trmp_1		[al_row] = 'S'
this.object.trmp_2		[al_row] = 'S'
this.object.trmp_3		[al_row] = 'S'
this.object.trmp_4		[al_row] = 'S'
this.object.trmp_5		[al_row] = 'S'
this.object.trmp_6		[al_row] = 'S'
end event

