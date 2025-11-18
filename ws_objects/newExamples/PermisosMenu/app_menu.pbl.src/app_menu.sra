$PBExportHeader$app_menu.sra
$PBExportComments$Generated Application Object
forward
global type app_menu from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

end variables

global type app_menu from application
string appname = "app_menu"
end type
global app_menu app_menu

on app_menu.create
appname="app_menu"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on app_menu.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_1)
end event

