$PBExportHeader$getfilename.sra
$PBExportComments$Generated Application Object
forward
global type getfilename from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type getfilename from application
string appname = "getfilename"
end type
global getfilename getfilename

on getfilename.create
appname="getfilename"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on getfilename.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

