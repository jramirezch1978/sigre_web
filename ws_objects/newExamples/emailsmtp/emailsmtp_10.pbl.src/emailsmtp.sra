$PBExportHeader$emailsmtp.sra
$PBExportComments$Generated Application Object
forward
global type emailsmtp from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_smtp gn_smtp

end variables

global type emailsmtp from application
string appname = "emailsmtp"
end type
global emailsmtp emailsmtp

on emailsmtp.create
appname="emailsmtp"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on emailsmtp.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

