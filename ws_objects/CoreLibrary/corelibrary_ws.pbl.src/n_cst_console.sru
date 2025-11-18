$PBExportHeader$n_cst_console.sru
forward
global type n_cst_console from nonvisualobject
end type
end forward

global type n_cst_console from nonvisualobject
end type
global n_cst_console n_cst_console

type prototypes
FUNCTION boolean AttachConsole(long ProcID) LIBRARY "kernel32.dll"
FUNCTION long GetStdHandle(long nStdHandle) LIBRARY "kernel32.dll"
FUNCTION int FreeConsole() LIBRARY "Kernel32.dll"
FUNCTION ulong WriteConsole(long Handle, String OutPut, long NumCharsToWrite, &
     REF long NumCharsWritten, long reserved) LIBRARY "Kernel32.dll" ALIAS FOR "WriteConsoleW"
SUBROUTINE keybd_event( int bVk, int bScan, int dwFlags, int dwExtraInfo) LIBRARY "user32.dll"
SUBROUTINE ExitProcess(ulong uExitCode) LIBRARY "kernel32.dll"
end prototypes
type variables
CONSTANT long ATTACH_PARENT_PROCESS = -1

CONSTANT long STD_OUTPUT_HANDLE = -11
CONSTANT long STD_ERROR_HANDLE = -12
CONSTANT long STD_INPUT_HANDLE = -10
long hwnd
end variables
forward prototypes
public subroutine println (string as_mensaje)
end prototypes

public subroutine println (string as_mensaje);string ls_mensaje
long 	ll_result

IF Handle(GetApplication()) = 0 OR IsNull(hwnd) THEN
   MessageBox("Debug", as_mensaje, StopSign!)
ELSE
   ls_mensaje = as_mensaje + "~r~n"
   WriteConsole(hwnd, ls_mensaje, len(ls_mensaje), ll_result, 0)
END IF
end subroutine

on n_cst_console.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_console.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;IF Handle(GetApplication()) > 0 THEN
   IF AttachConsole(ATTACH_PARENT_PROCESS) THEN
      hwnd = GetStdHandle(STD_OUTPUT_HANDLE)
   ELSE
      SetNull(hwnd)
   END IF
END IF
end event

event destructor;IF Handle(GetApplication()) > 0 THEN
   keybd_event( 13, 1, 0, 0 )
   FreeConsole()
   ExitProcess(1)
END IF
end event

