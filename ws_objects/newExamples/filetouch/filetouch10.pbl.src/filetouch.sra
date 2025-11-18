$PBExportHeader$filetouch.sra
$PBExportComments$Generated Application Object
forward
global type filetouch from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type filetouch from application
string appname = "filetouch"
end type
global filetouch filetouch

on filetouch.create
appname="filetouch"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on filetouch.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

