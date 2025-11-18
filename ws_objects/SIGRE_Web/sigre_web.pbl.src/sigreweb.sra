$PBExportHeader$sigreweb.sra
$PBExportComments$Generated Application Object
forward
global type sigreweb from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type sigreweb from application
string appname = "sigreweb"
end type
global sigreweb sigreweb

type variables

end variables

on sigreweb.create
appname="sigreweb"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on sigreweb.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)
end event

