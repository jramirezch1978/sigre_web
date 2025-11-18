$PBExportHeader$w_af023_software.srw
forward
global type w_af023_software from w_abc_master_smpl
end type
end forward

global type w_af023_software from w_abc_master_smpl
integer width = 2743
integer height = 1804
string title = "(AF023) Mantenimiento de Software"
string menuname = "m_master_mantenimiento"
long backcolor = 67108864
end type
global w_af023_software w_af023_software

type variables
string ls_dato
end variables

forward prototypes
public subroutine of_retrieve (string as_cod_licencia)
end prototypes

public subroutine of_retrieve (string as_cod_licencia);// Funcion para recuperar datos de los activos

dw_master.retrieve( as_cod_licencia )

dw_master.ii_protect  = 0
dw_master.of_protect	( )
dw_master.ii_update 	= 0

//is_Action = 'open'

//of_set_status_menu(dw_master)


end subroutine

on w_af023_software.create
call super::create
if this.MenuName = "m_master_mantenimiento" then this.MenuID = create m_master_mantenimiento
end on

on w_af023_software.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;string ls_protect

ls_protect=dw_master.Describe("nro_licencia.protect")

IF ls_protect='0' THEN
   dw_master.of_column_protect('nro_licencia')
END IF

end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

ii_lec_mst = 0

long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 250
This.move(ll_x,ll_y)

ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)


end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_master, "form") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE


end event

event ue_retrieve_list;call super::ue_retrieve_list;Sg_parametros sl_param

sl_param.dw1 = "dw_seleccion_software_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm(w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF

end event

event ue_update;// Override  Ancester
Boolean lbo_ok = TRUE
Integer	li_rc
String	ls_msg

dw_master.AcceptText()
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

ls_msg = "Se ha procedido al Rollback"

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		Rollback;
		messagebox("Error en Grabacion Master", ls_msg, exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
//	ls_cod_licencia = dw_master.object.nro_licencia[dw_master.getrow()]
//	of_retrieve(ls_cod_licencia)
	dw_master.ii_update  = 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
END IF
end event

event ue_insert;Long  ll_row

IF idw_1 = dw_master THEN
	if idw_1.ii_update = 1 then
		MessageBox('Error', 'Tiene cambios pendientes, no puede insertar otro registro')
		RETURN
	END IF
END IF

IF idw_1 = dw_master THEN
  dw_master.Reset()
END IF


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
END IF


end event

type dw_master from w_abc_master_smpl`dw_master within w_af023_software
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 28
integer width = 2683
integer height = 1488
string dataobject = "dw_software_ff"
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate

ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE 'instalador'
		ls_sql = "select cod_usr as codigo, " &
				  +"nombre as descripcion " &
				  +"from usuario " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.instalador	[al_row] = ls_codigo
			This.object.nombre		[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'cencos'
		ls_sql = "select cencos as codigo, " &
				 +"desc_cencos as descripcion " &
				 +"from centros_costo " &
				 +"where flag_estado = '1' "
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cencos	  [al_row] = ls_codigo
			This.object.desc_cencos[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'proveedor'
		ls_sql = "select proveedor as codigo, " &
				  +"nom_proveedor as descripcion " &
				  +"from proveedor " & 
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.proveedor	 [al_row] = ls_codigo
			This.object.nom_proveedor[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE 'cod_moneda'
		ls_sql = "select cod_moneda as codigo, " &
				  +"descripcion as nombre "  &
				  +"from moneda where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_moneda	[al_row] = ls_codigo
			This.object.desc_moneda [al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE 'doc_tipo_adq'
		ls_sql = "select tipo_doc as codigo, " &
				  +"desc_tipo_doc as descripcion " &
				  +"from doc_tipo " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.doc_tipo_adq	[al_row] = ls_codigo
			This.object.desc_tipo_doc	[al_row] = ls_data
			This.ii_update = 1
		END IF

	
END CHOOSE


end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;
//dw_master.Modify("nro_licencia.Protect='1~tIf(IsRowNew(),0,1)'")

This.object.flag_estado [al_row] = '1'

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 


THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF

//string ls_col, ls_cod_area, ls_sql, ls_return1, ls_return2, ls_null
//
//integer li_file
//string ls_docname, ls_named
//
//if this.ii_protect = 1 or row < 1 then return
//
//ls_col = lower(trim(string(dwo.name)))
//setnull(ls_null)
//
//choose case ls_col
//		
//	case 'instalador'
//		ls_sql = "select cod_usr as codigo, nombre as descripcion from usuario where flag_estado = '1' "
//		f_lista(ls_sql, ls_return1, ls_return2, '2')
//		if isnull(ls_return1) or trim(ls_return1) = '' then return
//		this.object.instalador[row] = ls_return1
//		this.object.nombre[row]     = ls_return2
//		this.ii_update = 1
//	case 'cencos'
//		ls_sql = "select cencos as codigo, desc_cencos as descripcion from centros_costo where flag_estado = '1' "
//		f_lista(ls_sql, ls_return1, ls_return2, '2')
//		if isnull(ls_return1) or trim(ls_return1) = '' then return
//		this.object.cencos[row]      = ls_return1
//		this.object.desc_cencos[row] = ls_return2
//		this.ii_update = 1
//	case 'proveedor'
//		ls_sql = "select proveedor as codigo, nom_proveedor as descripcion from proveedor where flag_estado = '1' "
//		f_lista(ls_sql, ls_return1, ls_return2, '2')
//		if isnull(ls_return1) or trim(ls_return1) = '' then return
//		this.object.proveedor[row]     = ls_return1
//		this.object.nom_proveedor[row] = ls_return2
//		this.ii_update = 1
//	case 'cod_moneda'
//		ls_sql = "select cod_moneda as codigo, descripcion as nombre from moneda where flag_estado = '1' "
//		f_lista(ls_sql, ls_return1, ls_return2, '2')
//		if isnull(ls_return1) or trim(ls_return1) = '' then return
//		this.object.cod_moneda[row]         = ls_return1
//		this.object.moneda_descripcion[row] = ls_return2
//		this.ii_update = 1
//	case 'doc_tipo_adq'
//		ls_sql = "select tipo_doc as codigo, desc_tipo_doc as descripcion from doc_tipo where flag_estado = '1' "
//		f_lista(ls_sql, ls_return1, ls_return2, '2')
//		if isnull(ls_return1) or trim(ls_return1) = '' then return
//		this.object.doc_tipo_adq[row]  = ls_return1
//		this.ii_update = 1
//
//end choose

end event

event dw_master::buttonclicked;call super::buttonclicked;string ls_observacion

ls_observacion = this.object.obs[row]

openwithparm(w_af_observacion,ls_observacion)

if not isnull(Message.StringParm) then
	
	this.object.obs[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_data, ls_null
Long		ll_found


SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
		
	CASE 'nro_licencia'
		SELECT count(nro_licencia)
		  INTO :ll_found
		FROM af_software
		WHERE nro_licencia = :data;
		
		IF ll_found > 0 then
   		messagebox("Aviso","Ya existe registro, Verifique")
			This.object.nro_licencia[row] = ls_null
   		RETURN 1
		END IF
		
	CASE 'instalador'
		SELECT nombre
		 INTO :ls_data
		FROM usuario
		WHERE cod_usr = :data 
		  AND flag_estado = '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.instalador[row] = ls_null
			This.object.nombre	 [row] = ls_null
			RETURN 1
		END IF
	   
		This.object.nombre[row] = ls_data
	
	CASE 'cencos'
		SELECT desc_cencos
		 INTO :ls_data
		FROM centros_costo
		WHERE cencos = :data
		  AND flag_estado = '1';
			 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'CENCOS NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.cencos		[row] = ls_null
			This.object.desc_cencos	[row] = ls_null
			RETURN 1
		END IF
		
		This.object.desc_cencos[row] = ls_data
	
	CASE 'proveedor'
		SELECT nom_proveedor
		  INTO :ls_data
		FROM proveedor
		WHERE proveedor = :data
		  AND flag_estado = '1';
			 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.proveedor		[row] = ls_null
			This.object.nom_proveedor	[row] = ls_null
			RETURN 1
		END IF
		
	   This.object.nom_proveedor[row] = ls_data
		  
	CASE 'cod_moneda'
		SELECT descripcion
		  INTO :ls_data
		FROM  moneda
		WHERE cod_moneda = :data
		  AND flag_estado = '1';
			  
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.cod_moneda	[row] = ls_null
			This.object.desc_moneda	[row] = ls_null
			RETURN 1
		END IF
		
		This.object.desc_moneda [row] = ls_data
	
	CASE 'doc_tipo_adq'
		SELECT desc_tipo_doc
		 INTO :ls_data
		FROM doc_tipo
		WHERE tipo_doc = :data
		 AND flag_estado = '1' ;
		  
	 	IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.doc_tipo_adq  [row] = ls_null
			This.object.desc_tipo_doc [row] = ls_null
			RETURN 1
		END IF
		
		This.object.desc_tipo_doc [row] = ls_data

END CHOOSE


end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

