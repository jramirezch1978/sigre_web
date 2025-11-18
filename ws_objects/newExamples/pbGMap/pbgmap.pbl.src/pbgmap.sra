$PBExportHeader$pbgmap.sra
$PBExportComments$Generated Application Object
forward
global type pbgmap from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type pbgmap from application
string appname = "pbgmap"
end type
global pbgmap pbgmap

on pbgmap.create
appname="pbgmap"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbgmap.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_googlemaps_demo)



end event

