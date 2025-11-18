$PBExportHeader$webbrowser.sra
$PBExportComments$Generated Application Object
forward
global type webbrowser from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type webbrowser from application
string appname = "webbrowser"
boolean toolbarusercontrol = false
end type
global webbrowser webbrowser

on webbrowser.create
appname="webbrowser"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on webbrowser.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

