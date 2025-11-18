$PBExportHeader$emailpop3.sra
$PBExportComments$Generated Application Object
forward
global type emailpop3 from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_pop3 gn_pop3

end variables

global type emailpop3 from application
string appname = "emailpop3"
end type
global emailpop3 emailpop3

on emailpop3.create
appname="emailpop3"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on emailpop3.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

