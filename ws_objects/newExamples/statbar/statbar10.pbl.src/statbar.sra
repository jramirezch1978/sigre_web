$PBExportHeader$statbar.sra
forward
global type statbar from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
w_main gw_frame
end variables

global type statbar from application
string appname = "statbar"
end type
global statbar statbar

type prototypes
Function ulong CreateMutex ( &
	ulong lpMutexAttributes, &
	int bInitialOwner, &
	Ref string lpName &
	) Library "kernel32.dll" Alias For "CreateMutexW"

Function ulong GetLastError ( &
	) Library "kernel32.dll"

end prototypes

type variables

end variables

on statbar.create
appname="statbar"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on statbar.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Application la_app
Ulong lul_mutex, lul_error
String ls_mutexname
Boolean lb_prev

// get application
la_app = GetApplication()

// disable user control of toolbar
//la_app.ToolbarUserControl = False

// check if prev instance
If Handle(la_app, False) = 0 Then
	// running Powerbuilder environment
	lb_prev = False
Else
	// running executable
	ls_mutexname = la_app.AppName
	lul_mutex = CreateMutex(0, 0, ls_mutexname)
	lul_error = GetLastError()
	If lul_error = 183 Then
		lb_prev = True
	Else
		lb_prev = False
	End If
End If

If lb_prev Then
	MessageBox("System Check", "Only one copy of the application is allowed!")
	Halt
Else
	Open(w_main)
End If

end event

