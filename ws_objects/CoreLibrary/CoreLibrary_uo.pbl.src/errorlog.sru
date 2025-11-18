$PBExportHeader$errorlog.sru
forward
global type errorlog from error
end type
end forward

global type errorlog from error
end type
global errorlog errorlog

type variables
Boolean  ib_Log
Integer    ii_FileNumber
String      is_FileName
end variables

forward prototypes
protected function boolean uf_logerror ()
public function boolean raiseerror (string as_errortext, long al_errornumber)
public function boolean initializelogging (string as_logfilename, boolean ab_loggingon)
public function boolean initializelogging (string as_filename)
public function boolean initializelogging (boolean ab_loggingon)
public function boolean initializelogging ()
public function boolean setlogging (boolean ab_logmode)
public function boolean raiseerror ()
end prototypes

protected function boolean uf_logerror ();// Graba el error en archivo

INTEGER	li_FileReturn = -1
STRING	ls_ErrorText

IF ib_Log THEN
	ls_ErrorText = String(Today()) + " " + String(Now()) + "~t" + &
						GetApplication().AppName + "~t" + &
						SQLCA.UserID + "~t" + &
						String(Error.Number) + "~t" + &
						Error.Text + "~t" + &
						Error.WindowMenu + "~t" + &
						Error.Object + "~t" + &
						Error.ObjectEvent + "~t" + &
						"SQLCode: " + String(SQLCA.SQLCode) + "~t" + &
						"SQLDBCode: " + String(SQLCA.SQLDBCode) + "~t" + &
						"SQLErrText: " + SQLCA.SQLErrText + "~t" + &	
						String(Error.Line)
						
	li_FileReturn = FileWrite(ii_FileNumber, ls_ErrorText)
END IF

// Retorna TRUE si se ha grabado el error

RETURN li_FileReturn > 0

end function

public function boolean raiseerror (string as_errortext, long al_errornumber);// Mostrar la informacion contenida en el objeto error ancestral

ERROR.Text	=	as_errortext
ERROR.Number	=	al_errornumber
ERROR.WindowMenu	=	"UNKNNOWN"
ERROR.OBJECT	=	"UNKNOWN"
ERROR.OBJECTEVENT	=	"UNKNOWN"

RETURN uf_LogError()
end function

public function boolean initializelogging (string as_logfilename, boolean ab_loggingon);BOOLEAN	lb_Success = FALSE

ib_Log = ab_LoggingOn
is_FileName= as_LogFileName

IF ib_Log THEN
	ii_FileNumber = FileOpen(is_FileName, LineMode!, Write!, LockReadWrite!, Append!)
	lb_Success = (ii_FileNumber > 0)
ELSE
	lb_Success = TRUE
END IF

RETURN lb_Success
end function

public function boolean initializelogging (string as_filename);RETURN THIS.InitializeLogging(as_filename, TRUE)
end function

public function boolean initializelogging (boolean ab_loggingon);STRING ls_FileName
APPLICATION lap_Target

lap_Target = GetApplication()
ls_FileName = lap_Target.AppName + ".TXT"
RETURN THIS.InitializeLogging(ls_FileName, ab_loggingon)

end function

public function boolean initializelogging ();RETURN THIS.InitializeLogging(TRUE)
end function

public function boolean setlogging (boolean ab_logmode);Boolean lb_Success = FALSE
Integer li_FileReturn


IF ib_Log AND NOT ab_LogMode THEN
	li_FileReturn = FileClose(ii_FileNumber)
	lb_Success = li_FileReturn > 0
	ii_FileNumber = -1
ELSE
	IF NOT ib_Log AND ab_LogMode THEN
		  lb_Success = THIS.InitializeLogging(is_FileName, TRUE)
	END IF
END IF

RETURN lb_Success

end function

public function boolean raiseerror ();RETURN uf_LogError()
end function

on errorlog.create
call error::create
TriggerEvent( this, "constructor" )
end on

on errorlog.destroy
call error::destroy
TriggerEvent( this, "destructor" )
end on

event destructor;IF ii_FileNumber > 0 THEN
	FileClose(ii_FileNumber)
END IF

end event

