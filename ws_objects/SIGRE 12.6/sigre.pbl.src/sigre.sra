$PBExportHeader$sigre.sra
$PBExportComments$Generated Application Object
forward
global type sigre from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type sigre from application
string appname = "sigre"
end type
global sigre sigre

on sigre.create
appname="sigre"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on sigre.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_main)
end event

