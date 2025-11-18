$PBExportHeader$jagscheduler.sra
$PBExportComments$Generated Application Object
forward
global type jagscheduler from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_connection gn_jag

end variables

global type jagscheduler from application
string appname = "jagscheduler"
end type
global jagscheduler jagscheduler

type variables

end variables

on jagscheduler.create
appname="jagscheduler"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on jagscheduler.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Long ll_rc
String ls_jaghost, ls_jaguser, ls_jagpass, ls_errmsg

// jaguar connection properties
ls_jaghost = ProfileString("jaguar.ini", "Settings", "Host", "")
ls_jaguser = ProfileString("jaguar.ini", "Settings", "UID", "")
ls_jagpass = ProfileString("jaguar.ini", "Settings", "PWD", "")

// connect to jaguar server
gn_jag = CREATE n_connection
ll_rc = gn_jag.of_Connect(ls_jaghost, ls_jaguser, ls_jagpass)

If ll_rc = 0 Then
	OpenWithParm(w_main, ls_jaghost)
Else
	ls_errmsg = gn_jag.of_errmsg(ll_rc)
	MessageBox("Jaguar Error", ls_errmsg)
End If

end event

event close;// disconnect from jaguar server
gn_jag.of_Disconnect()

DESTROY gn_jag

end event

