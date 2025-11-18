$PBExportHeader$w_base.srw
forward
global type w_base from window
end type
end forward

global type w_base from window
integer width = 2533
integer height = 1408
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
end type
global w_base w_base

type variables
Integer    ii_x = 1, ii_help, ii_list = 0, ii_error = 0
window     iw_sheet[]
menu		  im_1

//Opciones de restriccion
String 	is_flag_insertar, is_flag_eliminar, is_flag_modificar, is_flag_consultar, is_flag_anular, &
			is_flag_cancelar, is_flag_duplicar, is_flag_cerrar
			
Public:
Boolean	ib_log = true
end variables

forward prototypes
public subroutine of_position_window (integer ai_x, integer ai_y)
public subroutine of_center_window ()
public subroutine of_center_up_window (integer ai_x)
public function integer of_new_sheet (str_cns_pop astr_1)
public function boolean of_access (string as_usuario, string as_objeto)
end prototypes

public subroutine of_position_window (integer ai_x, integer ai_y);THIS.x = ai_x
THIS.y = ai_y
end subroutine

public subroutine of_center_window ();Long ll_x, ll_y


ll_x = ( w_main.workSpaceWidth()/2) - (THIS.Width/2)  
ll_y = ( w_main.WorkSpaceHeight()/2) - (THIS.Height/2)

of_position_window( ll_x, ll_y)	
end subroutine

public subroutine of_center_up_window (integer ai_x);Long ll_x, ll_y, ll_h

ll_h = (ai_x/100) * w_main.WorkSpaceHeight()

ll_x = (w_main.workSpaceWidth()/2) - (THIS.Width/2)  
ll_y = (w_main.WorkSpaceHeight()/2) - (THIS.Height/2) - ll_h 

of_position_window( ll_x, ll_y)
end subroutine

public function integer of_new_sheet (str_cns_pop astr_1);Integer 			li_rc
w_abc_pop		lw_sheet_abc
w_cns_pop		lw_sheet_cns
w_rpt_pop		lw_sheet_rpt
w_grf_pop		lw_sheet_grf
w_cns_rtn_pop	lw_sheet_rtn

CHOOSE CASE Upper(astr_1.Tipo_Cascada)
	CASE 'A' // ABC
		li_rc = OpenSheetWithParm(lw_sheet_abc, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_abc	
	CASE 'R' // Reporte
		li_rc = OpenSheetWithParm(lw_sheet_rpt, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_rpt
	CASE 'G' // Grafico
		li_rc = OpenSheetWithParm(lw_sheet_grf, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_grf
	CASE 'T' // Consulta con Retorno
		li_rc = OpenSheetWithParm(lw_sheet_rtn, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_rtn
	CASE ELSE // Consulta
		li_rc = OpenSheetWithParm(lw_sheet_cns, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_cns
END CHOOSE

RETURN li_rc     						//	Valores de Retorno: 1 = exito, -1 = error
end function

public function boolean of_access (string as_usuario, string as_objeto);// Funcion de Control de Acceso a Ventanas
// Argumentos:	as_usuario	codigo del usuario
//					as_objeto	objeto a validar el acceso
//             as_niveles  retorna los niveles de acceso al objeto

String 		ls_objeto, ls_temp, ls_grupo, ls_mensaje
Boolean 		lbo_retorno = FALSE 
Long			ll_count
DateTime		ldt_fecha

try 
	ldt_fecha = gnvo_app.of_fecha_actual()
	
	SELECT count(*)
		INTO :ll_count 
	FROM objeto_sis
	WHERE objeto_sis.objeto = :as_objeto ;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox("Error", "Se ha producido un error al momento de obtener una consulta " &
								+ "de la tabla OBJETO_SIS. Mensaje: " + ls_mensaje , StopSign!)
		HALT
	END IF
		
			
	IF ll_count = 0 THEN		// si el objeto no se encuentra no tiene control de acceso
		is_flag_insertar 	= '1'
		is_flag_eliminar 	= '1'
		is_flag_modificar = '1'
		is_flag_consultar = '1'
		is_flag_anular		= '1'
		is_flag_cancelar	= '1'
		is_flag_duplicar	= '1'
		is_flag_cerrar		= '1'
		
		return true
		
	end if
	
	//Primero Valido el acceso por objeto
	SELECT 	count(*)
		INTO 	:ll_count
	FROM usuario_obj
	WHERE cod_usr = :as_usuario 
	  AND objeto = :as_objeto ;  
	
	if ll_count > 0 then
	  	//Si tiene registro por objeto, entonces prima esta configuracion al del rol
		SELECT 	nvl(flag_insertar, '0'),
					nvl(flag_eliminar, '0'),
					nvl(flag_modificar, '0'),
					nvl(flag_consultar, '0'),
					nvl(flag_anular, '0'),
					nvl(flag_cancelar, '0'),
					nvl(flag_duplicar, '0'),
					nvl(flag_cerrar, '0')
			 
			INTO 	:is_flag_insertar, 
					:is_flag_eliminar, 
					:is_flag_modificar, 
					:is_flag_consultar, 
					:is_flag_anular, 
					:is_flag_cancelar, 
					:is_flag_duplicar, 
					:is_flag_cerrar
		FROM usuario_obj
		WHERE cod_usr = :as_usuario 
		  AND objeto = :as_objeto ;  
		  
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox("Error", "Se ha producido un error al momento de obtener una consulta " &
									+ "de la tabla usuario_obj. Mensaje: " + ls_mensaje , StopSign!)
			HALT
		END IF	
		
		return true
	end if
	
	//Si no tiene acceso por objeto, entonces reviso el acceso por Grupo
	SELECT 	MAX(nvl(go.FLAG_INSERTAR, '0')), 
				MAX(nvl(go.FLAG_ELIMINAR, '0')),   
			 	MAX(nvl(go.FLAG_MODIFICAR, '0')), 
				MAX(nvl(go.FLAG_CONSULTAR, '0')),
			 	MAX(nvl(go.FLAG_ANULAR, '0')), 
				MAX(nvl(go.FLAG_CANCELAR, '0')),
				MAX(nvl(go.flag_duplicar, '0')),
				MAX(nvl(go.flag_cerrar, '0')), 
				count(*)
	  INTO 	:is_flag_insertar, 
				:is_flag_eliminar, 
				:is_flag_modificar, 
				:is_flag_consultar, 
				:is_flag_anular, 
				:is_flag_cancelar, 
				:is_flag_duplicar, 
				:is_flag_cerrar,
				:ll_count
	FROM 		GRP_OBJ  go, 
	  			USR_GRP	ug  
	WHERE 	go.GRUPO 	= ug.GRUPO 
	  and  	ug.COD_USR 	= :as_usuario 
	  AND  	go.OBJETO 	= :as_objeto ;
	  
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox("Error", "Se ha producido un error al momento de obtener una consulta " &
								+ "de la tabla GRP_OBJ y USR_GRP. Mensaje: " + ls_mensaje , StopSign!)
		HALT
	END IF	
	
	//Si todo salio bien, entonces simplemente busco por objeto
	IF ll_count > 0 then return true;
	
	//Si no tiene acceso por objeto ni por grupo entonces muestro mensaje de error 
	//que no tiene acceso
	MessageBox("Acceso Denegado", "Acceso denegado del usuario " +as_usuario + " al objeto " &
										 + as_objeto + ", por favor coordine con su jefe superior para " &
										 + "que le brinde el acceso a esta Ventana", StopSign!)
	
	RETURN false
	

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception. Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
finally
	// Grabar en Log_Objeto
	IF gb_log_objeto THEN
		
		select count(*)
		  into :ll_count
		from LOG_OBJETO
		where OBJETO 	= :as_objeto
		  and FECHA	 	= :ldt_fecha
		  and COD_USR 	= :gs_user;
		
		if ll_count = 0 then
		
			INSERT INTO LOG_OBJETO ( OBJETO, FECHA, COD_USR )  
				  VALUES ( :as_objeto, :ldt_fecha, :gs_user )  ;
			
			IF SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Ha ocurrido un error al insertar en tabla LOG_OBJETO. Mensaje: ' + ls_mensaje, StopSign!)
				return false
			end if
			
			COMMIT;
			
		end if
		
		
	END IF
end try


end function

on w_base.create
end on

on w_base.destroy
end on

