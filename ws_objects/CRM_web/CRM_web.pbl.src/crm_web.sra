$PBExportHeader$crm_web.sra
$PBExportComments$Generated Application Object
forward
global type crm_web from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String  	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo, gs_cliente,gs_cliente_cotiz_id, gs_nivel, gs_cliente_nombre
String  	gs_sistema, gs_ruc, gs_esquema, gs_lpp, is_action
Integer 	gi_nivel, gi_control_db, gi_feriado[], gi_user, gi_usr_hou_id,gi_user_visita
Date    	gd_fecha
String   gs_db
DateTime gdt_ingreso
Boolean	gb_log_objeto
Integer 	 li_cliente_id, li_seguimiento_id, li_visita_id, ii_categoria_id, ii_sub_categ_id, ii_articulo_id, ii_cotiz_id, gi_cotizacion_id

n_cst_app_obj		gnvo_app
n_cst_utilitario 	gnvo_utility
n_cst_encriptor		gnvo_enc

end variables
global type crm_web from application
string appname = "crm_web"
end type
global crm_web crm_web

on crm_web.create
appname="crm_web"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on crm_web.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Str_parametros	lstr_param
// Profile sigre_sytco
SQLCA.DBMS = "O10 Oracle10g (10.1.0)"
SQLCA.LogPass = "sytco"
SQLCA.ServerName = "horus"
SQLCA.LogId = "sytco"
SQLCA.AutoCommit = False
SQLCA.DBParm = "PBCatalogOwner='sytco',TableCriteria=',sytco'"
CONNECT ;

String   ls_inifile
Integer li_logon, li_multi_emp
Long  ll_rc

// Objetos
gnvo_app = CREATE n_cst_app_obj

// API Functions
n_cst_api lnv_api
lnv_api = CREATE n_cst_api

// Flags
li_logon      = 1    // 0 = desahabilita logon
gi_control_db = 0    // 0 = no hace control de password en Base de Datos

open(w_logon2)
lstr_param = Message.PowerObjectParm

if lstr_param.b_return then
	open(w_cotiza)
end if

end event

event close;// grabar hora de Logout
//gnvo_app.of_set_logout_log()

//DESTROY gnvo_app
//DESTROY gnvo_utility
destroy gnvo_app
DISCONNECT ;

end event

event systemerror;open(w_system_error)
end event

event idle;rollback ;
halt close
end event

