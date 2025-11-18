$PBExportHeader$ping.sra
$PBExportComments$Application Object
forward
global type ping from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_ping gn_ping
end variables

global type ping from application
string appname = "ping"
end type
global ping ping

on ping.create
appname="ping"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on ping.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

