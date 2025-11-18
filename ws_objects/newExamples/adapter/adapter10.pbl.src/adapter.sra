$PBExportHeader$adapter.sra
$PBExportComments$Generated Application Object
forward
global type adapter from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type adapter from application
string appname = "adapter"
end type
global adapter adapter

on adapter.create
appname="adapter"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on adapter.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

