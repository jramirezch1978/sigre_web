$PBExportHeader$controlpanel.sra
$PBExportComments$Generated Application Object
forward
global type controlpanel from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type controlpanel from application
string appname = "controlpanel"
end type
global controlpanel controlpanel

on controlpanel.create
appname="controlpanel"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on controlpanel.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

