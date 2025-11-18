$PBExportHeader$osversion.sra
$PBExportComments$Generated Application Object
forward
global type osversion from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type osversion from application
string appname = "osversion"
end type
global osversion osversion

on osversion.create
appname="osversion"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on osversion.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

