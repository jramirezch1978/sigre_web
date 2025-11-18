$PBExportHeader$n_connection.sru
forward
global type n_connection from connection
end type
end forward

global type n_connection from connection
end type
global n_connection n_connection

type prototypes

end prototypes

type variables

end variables

forward prototypes
public function string of_errmsg (long al_errcode)
public subroutine of_disconnect ()
public function long of_connect (string as_host, string as_userid, string as_passwd)
end prototypes

public function string of_errmsg (long al_errcode);// return message for the error code

String ls_errmsg

choose case al_errcode
	case 0
		ls_errmsg = ""
	case 50
		ls_errmsg = "Distributed service error"
	case 52
		ls_errmsg = "Distributed communications error"
	case 53
		ls_errmsg = "Requested server not active"
	case 54
		ls_errmsg = "Server not accepting requests"
	case 55
		ls_errmsg = "Request terminated abnormally"
	case 56
		ls_errmsg = "Response to request incomplete"
	case 57
		ls_errmsg = "Not connected"
	case 58
		ls_errmsg = "Object instance does not exist"
	case 62
		ls_errmsg = "Server busy"
	case 75
		ls_errmsg = "Server forced client to disconnect"
	case 80
		ls_errmsg = "Server timed out client connection"
	case 87
		ls_errmsg = "Connection to server has been lost"
	case 92
		ls_errmsg = "Required property is missing or invalid"
	case else
		ls_errmsg = "Unknown error: " + String(al_errcode)
end choose

Return ls_errmsg

end function

public subroutine of_disconnect ();// disconnect from jaguar server

this.DisconnectServer()

end subroutine

public function long of_connect (string as_host, string as_userid, string as_passwd);// connect to jaguar server

this.driver = "jaguar"
this.location = "iiop://" + as_host + ":9000"
this.userid = as_userid
this.password = as_passwd

Return this.ConnectToServer()

end function

on n_connection.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_connection.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

