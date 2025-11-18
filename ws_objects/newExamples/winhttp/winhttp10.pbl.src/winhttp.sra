$PBExportHeader$winhttp.sra
$PBExportComments$Generated Application Object
forward
global type winhttp from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type winhttp from application
string appname = "winhttp"
end type
global winhttp winhttp

on winhttp.create
appname="winhttp"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on winhttp.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

