$PBExportHeader$comctl32.sra
$PBExportComments$Application object
forward
global type comctl32 from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type comctl32 from application
string appname = "comctl32"
end type
global comctl32 comctl32

on comctl32.create
appname="comctl32"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on comctl32.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

