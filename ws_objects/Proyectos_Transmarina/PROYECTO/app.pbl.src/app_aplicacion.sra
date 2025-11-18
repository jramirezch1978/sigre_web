$PBExportHeader$app_aplicacion.sra
$PBExportComments$Generated Application Object
forward
global type app_aplicacion from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type app_aplicacion from application
string appname = "app_aplicacion"
end type
global app_aplicacion app_aplicacion

on app_aplicacion.create
appname="app_aplicacion"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on app_aplicacion.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// Profile prf_transmarina
SQLCA.DBMS = "O10 Oracle10g (10.1.0)"
SQLCA.LogPass = "transmarina"
SQLCA.ServerName = "HEIMDALL"
SQLCA.LogId = "transmarina"
SQLCA.AutoCommit = False
SQLCA.DBParm = "PBCatalogOwner='transmarina'"

CONNECT USING SQLCA;

IF SQLCA.sqlerrtext <> "" then
	messagebox("Error de Conexion", SQLCA.sqlerrtext)
	HALT CLOSE
END IF

open(form_reporte)

end event

