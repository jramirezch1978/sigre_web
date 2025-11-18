$PBExportHeader$sendsms.sra
$PBExportComments$Generated Application Object
forward
global type sendsms from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type sendsms from application
string appname = "sendsms"
end type
global sendsms sendsms

on sendsms.create
appname="sendsms"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on sendsms.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

