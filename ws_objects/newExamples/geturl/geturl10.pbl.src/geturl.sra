$PBExportHeader$geturl.sra
$PBExportComments$Generated Application Object
forward
global type geturl from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type geturl from application
string appname = "geturl"
end type
global geturl geturl

on geturl.create
appname="geturl"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on geturl.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

