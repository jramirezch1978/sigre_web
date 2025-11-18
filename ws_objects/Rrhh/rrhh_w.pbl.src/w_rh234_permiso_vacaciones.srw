$PBExportHeader$w_rh234_permiso_vacaciones.srw
forward
global type w_rh234_permiso_vacaciones from w_abc_master
end type
end forward

global type w_rh234_permiso_vacaciones from w_abc_master
integer width = 3689
integer height = 1920
string title = "[RH234] Boleta de permiso de vacaciones"
string menuname = "m_master_con_lista"
end type
global w_rh234_permiso_vacaciones w_rh234_permiso_vacaciones

type variables
n_cst_rrhh invo_rrhh
end variables

forward prototypes
public function boolean of_retrieve_trab (string as_cod_trabaj)
public function boolean of_update_vacac ()
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_permiso)
end prototypes

public function boolean of_retrieve_trab (string as_cod_trabaj);string 	ls_nro_doc_ident, ls_desc_seccion, ls_desc_area, ls_tipo_trabaj, ls_desc_tipo_trabaj
date		ld_fec_ingreso

if dw_master.RowCount() = 0 then return false

select 	vw.fec_ingreso, vw.desc_seccion, vw.desc_area, vw.nro_doc_ident_rtps,
			vw.tipo_trabajador, tt.desc_tipo_tra
	into 	:ld_fec_ingreso, :ls_desc_seccion, :ls_desc_area, :ls_nro_doc_ident,
			:ls_tipo_trabaj, :ls_desc_tipo_trabaj
from 	vw_pr_trabajador 	vw,
		tipo_trabajador	tt
where vw.tipo_trabajador = tt.tipo_trabajador
  and vw.cod_trabajador = :as_cod_trabaj;

dw_master.object.fec_ingreso 				[dw_master.getRow()] = ld_fec_ingreso
dw_master.object.desc_seccion 			[dw_master.getRow()] = ls_desc_seccion
dw_master.object.desc_area 				[dw_master.getRow()] = ls_desc_area
dw_master.object.nro_doc_ident_rtps 	[dw_master.getRow()] = ls_nro_doc_ident
dw_master.object.tipo_trabajador 		[dw_master.getRow()] = ls_tipo_trabaj
dw_master.object.desc_tipo_trabajador 	[dw_master.getRow()] = ls_desc_tipo_trabaj


return true
end function

public function boolean of_update_vacac ();update rrhh_vacaciones_trabaj t
   set t.dias_gozados = (select nvl(sum(i.dias_inasist),0)
                           from inasistencia i 
                          where i.cod_trabajador = t.cod_trabajador 
                            and i.periodo_inicio = t.periodo_inicio
                            and i.concep         = t.concep)
where t.dias_gozados <> (select nvl(sum(i.dias_inasist),0)
                           from inasistencia i 
                          where i.cod_trabajador = t.cod_trabajador 
                            and i.periodo_inicio = t.periodo_inicio
                            and i.concep         = t.concep); 

if not gnvo_app.of_existserror( SQLCA, 'Update rrhh_vacaciones_trabaj') then 
	ROLLBACK;
	return false
end if

COMMIT;
return true
end function

public function integer of_set_numera (); 
//Numera documento
Long 		ll_ult_nro, ll_j
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	Select ult_nro 
		into :ll_ult_nro 
	from num_rrhh_permiso_vacac 
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		ll_ult_nro = 1
		
		Insert into num_rrhh_permiso_vacac (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error al insertar registro en num_rrhh_permiso_vacac', ls_mensaje)
			return 0
		end if
	end if
	
	//Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_permiso[dw_master.getrow()] = ls_nro
	
	//Incrementa contador
	Update num_rrhh_permiso_vacac 
		set ult_nro = :ll_ult_nro + 1 
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al actualizar num_rrhh_permiso_vacac', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_permiso[dw_master.getrow()] 
end if

return 1
end function

public subroutine of_retrieve (string as_nro_permiso);event ue_update_request()

dw_master.retrieve(as_nro_permiso)
is_action = 'open'

	
dw_master.ii_protect = 0
dw_master.ii_update	= 0
dw_master.of_protect()
dw_master.ResetUpdate()
	
return 
end subroutine

on w_rh234_permiso_vacaciones.create
call super::create
if this.MenuName = "m_master_con_lista" then this.MenuID = create m_master_con_lista
end on

on w_rh234_permiso_vacaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;invo_rrhh = create n_cst_rrhh

this.of_update_vacac( )
invo_rrhh.load_param( )

end event

event close;call super::close;destroy invo_rrhh
end event

event ue_update_pre;call super::ue_update_pre;integer li_dias_pendientes

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

li_dias_pendientes = Integer(dw_master.object.dias_pendientes[dw_master.GetRow()])

if li_dias_pendientes < 0 then
	MessageBox('Error', 'No se permite tener días pendientes de vacaciones en negativo, por favor verifique!')
	return
end if

if of_set_numera() = 0 then return	

dw_master.of_set_flag_replicacion()

ib_update_check = true



end event

event ue_insert;//Override
Long  ll_row

this.event ue_update_request( )

idw_1.Reset()
idw_1.ResetUpdate()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_list_permiso_vacac_tbl'
sl_param.titulo = 'Permisos por Vacaciones'
sl_param.field_ret_i[1] = 1


OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_print;// vista previa de mov. almacen
str_parametros lstr_rep
String ls_nro_permiso, ls_flag_estado

if dw_master.rowcount() = 0 then return

ls_flag_estado = dw_master.object.flag_estado[dw_master.GetRow()]
ls_nro_permiso = dw_master.object.nro_permiso[dw_master.GetRow()]

if ls_flag_estado = '0' then
	MessageBox('Aviso', 'El permiso ' + ls_nro_permiso + ' esta anulado, no puede imprimirse, por favor verifique!')
	return
end if

lstr_rep.dw1 		= 'd_frm_permiso_vacaciones_ff'
lstr_rep.titulo 	= 'Previo de Boleta de permiso de vacaciones'
lstr_rep.string1 	= ls_nro_permiso
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

event ue_delete;//Override
Long  	ll_count, ll_row
String	ls_nro_permiso

if is_Action = 'new' then return

if dw_master.getRow() = 0 then return

ls_nro_permiso = dw_master.object.nro_permiso[dw_master.GetRow()]

if IsNull(ls_nro_permiso) or ls_nro_permiso = '' then 
	MessageBox('Error', 'No existe un numero de permiso de vacaciones, por favor verifique!')
	return
end if

select count(*)
	into :ll_count
from inasistencia
where nro_permiso = :ls_nro_permiso;

if ll_count > 0 then
	MessageBox('Error', "Permiso de Vacaciones " + ls_nro_permiso + "ya ha sido pasado a la planilla, imposible eliminarlo, por favor verififque!")
	return
end if

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro de eliminar el permiso de vacaciones " + ls_nro_permiso + " ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_anular;//Override
Long  	ll_count, ll_row
String	ls_nro_permiso, ls_estado

if is_Action = 'new' then return

if dw_master.getRow() = 0 then return

ls_nro_permiso = dw_master.object.nro_permiso	[dw_master.GetRow()]
ls_estado		= dw_master.object.flag_estado	[dw_master.GetRow()]

if IsNull(ls_nro_permiso) or ls_nro_permiso = '' then 
	MessageBox('Error', 'No existe un numero de permiso de vacaciones, por favor verifique!')
	return
end if

select count(*)
	into :ll_count
from inasistencia
where nro_permiso = :ls_nro_permiso;

if ll_count > 0 then
	MessageBox('Error', "Permiso de Vacaciones " + ls_nro_permiso + " ya ha sido pasado a la planilla, imposible anularlo, por favor verififque!")
	return
end if

if ls_estado <> '3' then
	MessageBox('Error', "Permiso de Vacaciones " + ls_nro_permiso + " no esta disponible para ser anulado, por favor verififque!")
	return
end if

IF MessageBox("Anulación de Registro", "Esta Seguro de anular el permiso de vacaciones " + ls_nro_permiso + " ?", Question!, YesNo!, 2) <> 1 THEN return

dw_master.object.flag_estado [dw_master.GetRow()] = '0'
dw_master.ii_update = 1
end event

event ue_retrieve;call super::ue_retrieve;is_action = 'open'
end event

type dw_master from w_abc_master`dw_master within w_rh234_permiso_vacaciones
integer width = 3529
string dataobject = "d_abc_permiso_vacaciones_ff"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	[al_row] = '3'
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_Actual()
this.object.fec_movimiento	[al_row] = Date(gnvo_app.of_fecha_Actual())
this.object.fecha_inicio	[al_row] = Date(gnvo_app.of_fecha_Actual())
this.object.fecha_fin		[al_row] = Date(gnvo_app.of_fecha_Actual())
this.object.cod_empresa		[al_row] = gnvo_app.empresa.is_empresa
this.object.nom_empresa		[al_row]	= gnvo_app.empresa.is_nom_empresa
this.object.cod_usr			[al_row] = gs_user
this.object.dias_totales	[al_row] = 0
this.object.dias_gozados	[al_row] = 0

is_action='new'

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_dias_totales, ls_dias_gozados, ls_concep, ls_desc_concepto, &
			ls_cod_trabaj, ls_periodo_inicio

choose case lower(as_columna)
	case "cod_trabajador"
		ls_sql = "SELECT v.cod_trabajador AS CODIGO_trabajador, " &
				  + "v.nom_trabajador AS nombre_trabajador " &
				  + "FROM vw_pr_trabajador v " &
				  + "WHERE v.FLAG_ESTADO = '1' " &
				  + "and v.fec_cese is null " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			
		 	of_retrieve_trab(ls_codigo)
			this.ii_update = 1
		end if
		
	case "periodo_inicio"
		ls_cod_trabaj = this.object.cod_trabajador [al_row]
		
		if IsNull(ls_cod_trabaj) or ls_cod_trabaj = '' then
			MessageBox('Error', 'Debe seleccionar un codigo de trabajador primero')
			this.Setcolumn('cod_trabajador')
			return
		end if
		
		ls_sql = "SELECT v.periodo_inicio AS periodo_inicio, " &
				  + "v.periodo_fin AS periodo_fin, " &
				  + "v.dias_totales as dias_totales, " &
				  + "v.dias_gozados as dias_gozados, " &
				  + "v.concep as concepto " &
				  + "FROM rrhh_vacaciones_trabaj v " &
				  + "WHERE v.FLAG_ESTADO = '1' " &
				  + "and v.dias_totales > v.dias_gozados " &
				  + "and v.cod_trabajador = '" + ls_cod_trabaj + "' " &
				  + "order by v.periodo_inicio desc"

		lb_ret = f_lista_5ret(ls_sql, ls_codigo, ls_data, ls_dias_totales, ls_dias_gozados, ls_concep, '2')

		if ls_codigo <> '' then
			this.object.periodo_inicio	[al_row] = Long(ls_codigo)
			this.object.periodo_fin		[al_row] = Long(ls_data)
			this.object.dias_totales	[al_row] = Long(ls_dias_totales)
			this.object.dias_gozados	[al_row] = Long(ls_dias_gozados)
			this.object.concep			[al_row] = ls_concep
			
			select desc_concep
				into :ls_desc_concepto
			from concepto
			where concep = :ls_concep;
			this.object.desc_concep		[al_row] = ls_desc_concepto
			
			this.ii_update = 1
		end if		

	case "periodo_fin"
		ls_cod_trabaj = this.object.cod_trabajador [al_row]
		
		if IsNull(ls_cod_trabaj) or ls_cod_trabaj = '' then
			MessageBox('Error', 'Debe seleccionar un codigo de trabajador primero, por favor verifique')
			this.Setcolumn('cod_trabajador')
			return
		end if
		
		ls_periodo_inicio = String(this.object.periodo_inicio [al_row])
		if IsNull(ls_periodo_inicio) or ls_periodo_inicio = '' then
			MessageBox('Error', 'Debe ingresar periodo de inicio, por favor verifique!')
			this.Setcolumn('periodo_inicio')
			return
		end if
		
		ls_sql = "SELECT v.periodo_inicio AS periodo_inicio, " &
				  + "v.periodo_fin AS periodo_fin, " &
				  + "v.dias_totales as dias_totales, " &
				  + "v.dias_gozados as dias_gozados, " &
				  + "v.concep as concepto " &
				  + "FROM rrhh_vacaciones_trabaj v " &
				  + "WHERE v.FLAG_ESTADO = '1' " &
				  + "and v.dias_totales > v.dias_gozados " &
				  + "and v.cod_trabajador = '" + ls_cod_trabaj + "' " &
				  + "and v.periodo_inicio = '" + ls_periodo_inicio + "' " &
				  + "order by v.periodo_inicio desc"

		lb_ret = f_lista_5ret(ls_sql, ls_codigo, ls_data, ls_dias_totales, ls_dias_gozados, ls_concep, '2')

		if ls_codigo <> '' then
			this.object.periodo_fin		[al_row] = ls_data
			this.object.dias_totales	[al_row] = Long(ls_dias_totales)
			this.object.dias_gozados	[al_row] = Long(ls_dias_gozados)
			this.object.concep			[al_row] = ls_concep
			
			select desc_concep
				into :ls_desc_concepto
			from concepto
			where concep = :ls_concep;
			this.object.desc_concep		[al_row] = ls_desc_concepto
			
			this.ii_update = 1
		end if	

	case "concep"
		ls_sql = "select concep as concepto, " &
				 + "desc_concep as descripcion_concepto " &
				 + "from concepto " &
				 + "WHERE FLAG_ESTADO = '1' " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.concep		[al_row] = ls_codigo
			this.object.desc_concep	[al_row] = ls_data
			
		 	of_retrieve_trab(ls_codigo)
			this.ii_update = 1
		end if		

end choose

end event

event dw_master::itemchanged;call super::itemchanged;Integer 	li_periodo_inicio, li_dias_totales, li_dias_gozados, li_dias_vacac
String	ls_cod_trabaj, ls_concep, ls_desc_concepto, ls_desc, ls_tipo_trabaj
Date		ld_fecha_inicio, ld_fecha_fin

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

CHOOSE CASE lower(dwo.name)
	CASE 'cod_trabajador'

		SELECT nom_trabajador
			INTO :ls_desc
		FROM vw_pr_trabajador
   	WHERE  cod_trabajador = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Codigo de Trabajador no existe, ' &
					+ 'no esta activo, por favor verifique!')
			else
				MessageBox('Error en ejecución', SQLCA.SQLErrText)
			end if
			
			this.Object.cod_trabajador		[row] = gnvo_app.is_null
			this.object.nom_trabajador		[row] = gnvo_app.is_null
			this.setcolumn( "cod_trabajador" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		this.object.nom_trabajador [row] = ls_desc
		of_retrieve_trab(data)
		
	CASE 'concep'

		SELECT desc_concep
			INTO :ls_desc
		FROM concepto
   	WHERE  concep = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Codigo de Concepto no existe, o no esta activo, por favor verifique!')
			else
				MessageBox('Error en ejecución', SQLCA.SQLErrText)
			end if
			
			this.Object.concep			[row] = gnvo_app.is_null
			this.object.desc_concep		[row] = gnvo_app.is_null
			this.setcolumn( "concep" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		this.object.desc_concep [row] = ls_desc

		
	CASE 'periodo_fin'
		ls_cod_trabaj = this.object.cod_trabajador [row]
		
		if IsNull(ls_cod_trabaj) or ls_cod_trabaj = '' then
			MessageBox('Error', 'Debe seleccionar un codigo de trabajador primero, por favor verifique')
			this.Setcolumn('cod_trabajador')
			return 1
		end if
		
		ls_tipo_trabaj = this.object.tipo_trabajador [row]
		
		li_periodo_inicio = Integer(this.object.periodo_inicio [row])
		if IsNull(li_periodo_inicio) or li_periodo_inicio = 0 then
			MessageBox('Error', 'Debe ingresar periodo de inicio, por favor verifique!')
			this.Setcolumn('periodo_inicio')
			return 1
		end if
		
		SELECT v.dias_totales, v.dias_gozados, v.concep
			into :li_dias_totales, :li_dias_gozados, :ls_concep
			FROM rrhh_vacaciones_trabaj v 
		WHERE v.FLAG_ESTADO = '1' 
		  and v.dias_totales > v.dias_gozados 
		  and v.cod_trabajador = :ls_cod_trabaj
		  and v.periodo_inicio = :li_periodo_inicio
		order by v.periodo_inicio desc;

		if SQLCA.SQLCode <> 100 then
			this.object.dias_totales	[row] = li_dias_totales
			this.object.dias_gozados	[row] = li_dias_gozados
			this.object.concep			[row] = ls_concep
			
			select desc_concep
				into :ls_desc_concepto
			from concepto
			where concep = :ls_concep;
			this.object.desc_concep		[row] = ls_desc_concepto
			
			
		else
			
			if invo_rrhh.of_sector_agrario(ls_tipo_trabaj) then
				this.object.dias_totales	[row] = 15
			else
				this.object.dias_totales	[row] = 30
			end if
			
			this.object.dias_gozados	[row] = 0
			this.object.concep			[row] = invo_rrhh.is_cnc_vacac
			
			select desc_concep
				into :ls_desc_concepto
			from concepto
			where concep = :invo_rrhh.is_cnc_vacac;
			this.object.desc_concep		[row] = ls_desc_concepto
		end if		
		
		this.ii_update = 1
		
		
	CASE 'fecha_inicio'
		
		li_dias_totales = Integer(this.object.dias_totales[row])
		li_dias_gozados = Integer(this.object.dias_gozados[row])
		
		if li_dias_gozados > li_dias_totales or li_dias_totales = 0 then
			MessageBox('Error', 'Debe especificar los días totales de vacaciones, o los días gozados son mayores que los días en el periodo, por favor verifique!')
			return 1
		end if
		
		li_dias_vacac = li_dias_totales - li_dias_gozados 
		ld_fecha_inicio = Date(this.object.fecha_inicio[row])
		
		if  li_dias_vacac > 0 then
		
			ld_fecha_fin = RelativeDate(ld_fecha_inicio, li_dias_vacac - 1)
			
			this.object.fecha_fin [row] = ld_fecha_fin
		else
			this.object.fecha_fin [row] = ld_fecha_inicio
		end if
		
		
END CHOOSE

end event

