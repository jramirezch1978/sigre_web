$PBExportHeader$ldapquery.sra
$PBExportComments$Generated Application Object
forward
global type ldapquery from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type ldapquery from application
string appname = "ldapquery"
end type
global ldapquery ldapquery

on ldapquery.create
appname="ldapquery"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on ldapquery.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

