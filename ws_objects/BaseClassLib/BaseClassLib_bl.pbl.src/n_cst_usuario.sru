$PBExportHeader$n_cst_usuario.sru
forward
global type n_cst_usuario from nonvisualobject
end type
end forward

global type n_cst_usuario from nonvisualobject
end type
global n_cst_usuario n_cst_usuario

type variables
string is_user, is_nom_usuario, is_flag_estado
end variables

forward prototypes
public function string of_nom_usuario (string as_cod_usr)
public function boolean of_load_usuario (string as_cod_usr)
end prototypes

public function string of_nom_usuario (string as_cod_usr);string ls_nom_user
if gnvo_app.ib_new_struct then
	
else
	select nombre
	  into :ls_nom_user
	from usuario
	where cod_usr = :gnvo_app.is_user;
end if

if not gnvo_app.of_valida_transaccion( "No se pudo Consultar el maestro de usuarios", SQLCA) then
	ls_nom_user = ''
	gnvo_log.of_Tracelog("No se pudo Consultar el maestro de usuarios: " +	gnvo_app.is_user)
end if

return ls_nom_user
end function

public function boolean of_load_usuario (string as_cod_usr);is_user = as_cod_usr

if gnvo_app.ib_new_struct then
	// Por implementar
else
	//SQL> desc usuario
	//Name                 Type         Nullable Default    Comments         
	//-------------------- ------------ -------- ---------- ---------------- 
	//COD_USR              CHAR(6)                          cod usuario      
	//NOMBRE               VARCHAR2(60) Y                   Nombre           
	//USR_CLAVE            VARCHAR2(30) Y        'password' Clave            
	//PERFIL               CHAR(8)      Y                   perfil           
	//EMAIL                VARCHAR2(40) Y                   email            
	//FLAG_ESTADO          CHAR(1)      Y        '1'        flag_estado      
	//ORIGEN_ALT           CHAR(2)      Y                   origen alt       
	//FLAG_ORIGEN          CHAR(1)      Y        'S'        flag_origen      
	//TIMEOUT              NUMBER(5)    Y        600        timeout          
	//NIVEL_LOG_OBJETO     NUMBER(1)    Y        5          nivel log objeto 
	//FLAG_REPLICACION     CHAR(1)      Y        '1'        flag_replicacion 
	//TELEMOBIL            VARCHAR2(15) Y                   telemobil        
	//FLAG_TELEMOBIL       CHAR(1)      Y                   flag_telemobil   
	//FECHA_UCC            DATE         Y                   fecha ucc        
	//COD_PRECIO           CHAR(3)      Y                   cod_precio       
	//NRO_CLAVES_REPETIDAS NUMBER(2)    Y                    

	select nombre, flag_estado
	  into :is_nom_usuario, :is_flag_estado
	from usuario
	where cod_usr = :is_user;
end if



if not gnvo_app.of_valida_transaccion( "No se pudo Consultar el maestro de usuarios", SQLCA) then
	SetNull(is_nom_usuario)
	SetNull(is_flag_estado)
	setNull(gnvo_app.is_user)
	
	gnvo_log.of_Tracelog("No se pudo Consultar el maestro de usuarios: " +	is_user)
	return false
end if

return true

end function

on n_cst_usuario.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_usuario.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

