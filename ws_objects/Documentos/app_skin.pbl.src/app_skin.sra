$PBExportHeader$app_skin.sra
$PBExportComments$Generated Application Object
forward
global type app_skin from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type app_skin from application
string appname = "app_skin"
end type
global app_skin app_skin

on app_skin.create
appname="app_skin"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on app_skin.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open (w_login)
end event

