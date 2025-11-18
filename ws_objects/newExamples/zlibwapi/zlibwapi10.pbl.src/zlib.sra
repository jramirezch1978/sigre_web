$PBExportHeader$zlib.sra
$PBExportComments$Generated Application Object
forward
global type zlib from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_zlib gn_zlib

end variables

global type zlib from application
string appname = "zlib"
boolean toolbartext = true
boolean toolbarusercontrol = false
end type
global zlib zlib

on zlib.create
appname="zlib"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on zlib.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

