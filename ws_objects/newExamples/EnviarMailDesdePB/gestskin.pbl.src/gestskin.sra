$PBExportHeader$gestskin.sra
$PBExportComments$Generated Application Object
forward
global type gestskin from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
Long   Color_Inicial
end variables

global type gestskin from application
string appname = "gestskin"
end type
global gestskin gestskin

on gestskin.create
appname="gestskin"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on gestskin.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open(w)
end event

