$PBExportHeader$usps4cb.sra
$PBExportComments$Generated Application Object
forward
global type usps4cb from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type usps4cb from application
string appname = "usps4cb"
end type
global usps4cb usps4cb

on usps4cb.create
appname="usps4cb"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on usps4cb.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

