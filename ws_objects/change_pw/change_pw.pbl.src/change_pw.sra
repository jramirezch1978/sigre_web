$PBExportHeader$change_pw.sra
$PBExportComments$Generated Application Object
forward
global type change_pw from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type change_pw from application
string appname = "change_pw"
integer highdpimode = 0
string appruntimeversion = "25.0.0.3711"
end type
global change_pw change_pw

on change_pw.create
appname="change_pw"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on change_pw.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w_change)
end event

