$PBExportHeader$dynamicmenus.sra
$PBExportComments$Generated Application Object
forward
global type dynamicmenus from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type dynamicmenus from application
string appname = "dynamicmenus"
end type
global dynamicmenus dynamicmenus

on dynamicmenus.create
appname="dynamicmenus"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on dynamicmenus.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

