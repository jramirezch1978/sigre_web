$PBExportHeader$ejemplo.sra
$PBExportComments$Generated Application Object
forward
global type ejemplo from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
String  	gs_estacion, gs_user, gs_help, gs_origen, gs_empresa, gs_logo
String		gs_sistema
Integer 	gi_nivel, gi_control_db
Date		gd_fecha
end variables

global type ejemplo from application
string appname = "ejemplo"
end type
global ejemplo ejemplo

on ejemplo.create
appname="ejemplo"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on ejemplo.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
end event

event idle;Rollback ;
DISCONNECT ;
HALT CLOSE

end event

event systemerror;Open(w_system_error)
end event

