$PBExportHeader$winsock.sra
$PBExportComments$Generated Application Object
forward
global type winsock from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_winsock gn_ws

end variables

global type winsock from application
string appname = "winsock"
end type
global winsock winsock

on winsock.create
appname="winsock"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on winsock.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;// initialize Winsock
gn_ws.of_Startup()

Open(w_main)

end event

event close;// Shutdown Winsock
gn_ws.of_Cleanup()

end event

