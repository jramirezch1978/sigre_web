$PBExportHeader$pbchat.sra
$PBExportComments$Generated Application Object
forward
global type pbchat from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_winsock gn_ws
Constant UInt LISTENPORT = 4000

end variables

global type pbchat from application
string appname = "pbchat"
end type
global pbchat pbchat

on pbchat.create
appname="pbchat"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbchat.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

