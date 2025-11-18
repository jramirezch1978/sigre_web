$PBExportHeader$bitmap.sra
$PBExportComments$Generated Application Object
forward
global type bitmap from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type bitmap from application
string appname = "bitmap"
end type
global bitmap bitmap

on bitmap.create
appname="bitmap"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on bitmap.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

