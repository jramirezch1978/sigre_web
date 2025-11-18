$PBExportHeader$n_cst_errorlogging.sru
forward
global type n_cst_errorlogging from error
end type
end forward

global type n_cst_errorlogging from error
end type
global n_cst_errorlogging n_cst_errorlogging

type variables
Boolean 	ib_Log
Integer  ii_FileNumber
String	is_FileName
String	is_ErrorLog = '1', is_TraceLog = '0', is_WarningLog = '1'
end variables

forward prototypes
public function boolean raiseerror (string as_errortext, long al_errornumber)
public function boolean initializelogging (string as_logfilename, boolean ab_loggingon)
public function boolean initializelogging (string as_filename)
public function boolean initializelogging (boolean ab_loggingon)
public function boolean initializelogging ()
public function boolean setlogging (boolean ab_logmode)
public function boolean raiseerror ()
public function string of_mensajedb (string as_mensaje)
public function boolean of_warninglog (string as_mensaje)
public function boolean of_tracelog (string as_mensaje)
public function boolean of_errorlog (string as_mensaje)
protected function boolean of_errorlog ()
public function boolean of_errorlog (datetime adt_fecha, string as_mensaje)
public function boolean of_tracelog (datetime adt_fecha, string as_mensaje)
public subroutine of_parametros ()
public function string of_mensajedb (string as_mensaje, transaction atr_trans)
end prototypes

public function boolean raiseerror (string as_errortext, long al_errornumber);// Mostrar la informacion contenida en el objeto error ancestral

ERROR.Text	=	as_errortext
ERROR.Number	=	al_errornumber
ERROR.WindowMenu	=	"UNKNNOWN"
ERROR.OBJECT	=	"UNKNOWN"
ERROR.OBJECTEVENT	=	"UNKNOWN"

RETURN of_errorLog()

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

public function boolean initializelogging (boolean ab_loggingon);STRING ls_FileName, ls_dir
APPLICATION lap_Target

lap_Target = GetApplication()

if IsNull(gnvo_app) or not IsValid(gnvo_app) then 
	ls_FileName = lap_Target.AppName + ".log"
elseif gnvo_app.is_Logname = '' then
	ls_FileName = lap_Target.AppName + ".log"
else
	if right(gnvo_app.is_Logname, 4) <> '.log' then
		ls_FileName = gnvo_app.is_Logname + '.log'
	else
		ls_FileName = gnvo_app.is_Logname
	end if
	
end if


// Directorio de la aplicacion
ls_dir=GetCurrentDirectory ( )

if IsNull(gnvo_app) or not IsValid(gnvo_app) then
	ls_FileName = ls_dir + '\\' + ls_FileName	//-------- Direccion Local de la misma aplicación
elseif gnvo_app.is_locallog = '0' then  
	ls_FileName = ls_dir + '\\' + ls_FileName	//-------- Direccion de Red
else	
	if gnvo_app.is_logpath = '' then
		ls_FileName = "c:\\"	+ ls_FileName	 //--------Local o Unidad de red 
	else
		if right(gnvo_app.is_logpath,1) <> "\\" then
			ls_FileName = gnvo_app.is_logpath + "\\" + ls_FileName	 //--------Local o Unidad de red 
		else
			ls_FileName = gnvo_app.is_logpath + ls_FileName	 //--------Local o Unidad de red 
		end if
	end if
	
end if

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

public function boolean raiseerror ();RETURN of_errorLog()
end function

public function string of_mensajedb (string as_mensaje);String ls_mensaje = '', ls_errText
integer li_SQLCode

if as_mensaje <> '' then
	ls_mensaje += as_mensaje + "~r~n"
end if

li_SQLCode = SQLCA.SQlCode


if li_SQLCode = 100 then
	ls_mensaje += "SQLErrText: No se ha encontrado ninguna fila~r~n" + &
						 "SQLCode: " + String(SQLCA.SQLCode) + "~r~n" 

elseif li_SQLCOde < 0 then
	ls_errText = SQLCA.SQLErrText
	if pos(ls_errText, '~n') > 0 then ls_errText = left(ls_errText, pos(ls_errText,'~n') - 1) 
	if pos(ls_errText, '~r') > 0 then ls_errText = left(ls_errText, pos(ls_errText,'~r') - 1) 

	ls_mensaje += "SQLErrText: " + ls_errText + "~r~n" + &
						 "SQLCode: " + String(SQLCA.SQLCode) + "~r~n" + &
						"SQLDBCode: " + String(SQLCA.SQLDBCode)
else
	ls_mensaje = ""
end if
			
return ls_mensaje
end function

public function boolean of_warninglog (string as_mensaje);// Graba el error en archivo

INTEGER	li_FileReturn = -1
STRING	ls_ErrorText

this.of_parametros( )

if is_Warninglog = '0' then return true

if not ib_log then
	this.initializelogging( )
end if

IF ib_Log and ii_FileNumber > 0 THEN
	ls_ErrorText = "[" + String(Today(), 'dd/mm/yyyy') + " " + &
						String(Now(), 'hh:mm:ss') + "] " + &
						"[Warning] " + &
						"[AppName: " + GetApplication().AppName + "] " + &
						"[User S.O.: " + gnvo_app.is_user_so + "] " + & 
						"[Estacion: " + gnvo_app.is_estacion + "] " + & 
						as_mensaje
						
	li_FileReturn = FileWrite(ii_FileNumber, ls_ErrorText)

	// Cierro el archivo una vez escrito el log en él
	FileClose(ii_FileNumber)
	ib_log = false

END IF

// Retorna TRUE si se ha grabado el error

RETURN li_FileReturn > 0
end function

public function boolean of_tracelog (string as_mensaje);// Graba el error en archivo

INTEGER	li_FileReturn = -1
STRING	ls_ErrorText

this.of_parametros( )

if is_Tracelog = '0' then return true

if not ib_log then
	this.initializelogging( )
end if

IF ib_Log and ii_FileNumber > 0 THEN
	ls_ErrorText = "[" + String(Today(), 'dd/mm/yyyy') + " " + &
						String(Now(), 'hh:mm:ss') + "] " + &
						"[Trace] " + &
						"[AppName: " + GetApplication().AppName + "] " + &
						"[User S.O.: " + gnvo_app.is_user_so + "] " + & 
						"[Estacion: " + gnvo_app.is_estacion + "] " + & 
						as_mensaje
						
	li_FileReturn = FileWrite(ii_FileNumber, ls_ErrorText)

	// Cierro el archivo una vez escrito el log en él
	FileClose(ii_FileNumber)
	ib_log = false

END IF

// Retorna TRUE si se ha grabado el error

RETURN li_FileReturn > 0
end function

public function boolean of_errorlog (string as_mensaje);// Graba el error en archivo

INTEGER	li_FileReturn = -1
STRING	ls_ErrorText

if IsNull(gnvo_app) or not IsValid(gnvo_app) then return false

this.of_parametros( )

if is_errorlog = '0' then return true

if not ib_log then
	this.initializelogging( )
end if

IF ib_Log and ii_FileNumber > 0 THEN
	ls_ErrorText = "[" + String(Today(), 'dd/mm/yyyy') + " " + &
						String(Now(), 'hh:mm:ss') + "] " + &
						"[Error] " + &						
						"[AppName: " + GetApplication().AppName + "] " + &
						"[User S.O.: " + gnvo_app.is_user_so + "] " + & 
						"[Estacion: " + gnvo_app.is_estacion + "]~t" + & 
						as_mensaje
						
	li_FileReturn = FileWrite(ii_FileNumber, ls_ErrorText)

	// Cierro el archivo una vez escrito el log en él
	FileClose(ii_FileNumber)
	ib_log = false

END IF

// Retorna TRUE si se ha grabado el error

RETURN li_FileReturn > 0
end function

protected function boolean of_errorlog ();// Graba el error en archivo

INTEGER	li_FileReturn = -1
STRING	ls_ErrorText

if IsNull(gnvo_app) or not IsValid(gnvo_app) then return false

this.of_parametros( )

if is_errorlog = '0' then return true

if not ib_log then
	//Abro el archivo para lectura y escritura
	this.initializelogging( )
end if

IF ib_Log and ii_FileNumber > 0 THEN
	ls_ErrorText = "[" + String(Today()) + " " + String(Now()) + "] " + &
						"[Error] " + & 
						"[AppName:" + GetApplication().AppName + "] " + &
						"[User S.O.: " + gnvo_app.is_user_so + "] " + & 
						"[Estacion: " + gnvo_app.is_estacion + "]~t" + & 
						"SQLCA.UserID: " + SQLCA.UserID + "~r~n" + &
						"Error.Number: " + String(Error.Number) + "~r~n" + &
						"Error.Text" + Error.Text + "~r~n" + &
						"Error.WindowMenu: " + Error.WindowMenu + "~r~n" + &
						"Error.Object: " + Error.Object + "~r~n" + &
						"Error.ObjectEvent: " + Error.ObjectEvent + "~r~n" + &
						"SQLCode: " + String(SQLCA.SQLCode) + "~r~n" + &
						"SQLDBCode: " + String(SQLCA.SQLDBCode) + "~r~n" + &
						"SQLErrText: " + SQLCA.SQLErrText + "~r~n" + &	
						"Error.Line: " + String(Error.Line)
						
	li_FileReturn = FileWrite(ii_FileNumber, ls_ErrorText)
	
	// Cierro el archivo una vez escrito el log en él
	FileClose(ii_FileNumber)
	ib_log = false

END IF


// Retorna TRUE si se ha grabado el error
RETURN li_FileReturn > 0

end function

public function boolean of_errorlog (datetime adt_fecha, string as_mensaje);// Graba el error en archivo

INTEGER	li_FileReturn = -1
STRING	ls_ErrorText

if IsNull(gnvo_app) or not IsValid(gnvo_app) then return false
this.of_parametros( )

if is_errorlog = '0' then return true

if not ib_log then
	this.initializelogging( )
end if

IF ib_Log THEN
	ls_ErrorText = "[" + String(adt_fecha, 'dd/mm/yyyy hh:mm:ss') + "] " + &
						"[Error] " + &
						"[AppName: " + GetApplication().AppName + "] " + &
						"[User S.O.: " + gnvo_app.is_user_so + "] " + & 
						"[Estacion: " + gnvo_app.is_estacion + "]~t" + & 
						as_mensaje
						
	li_FileReturn = FileWrite(ii_FileNumber, ls_ErrorText)
	
	// Cierro el archivo una vez escrito el log en él
	FileClose(ii_FileNumber)
	ib_log = false

END IF

// Retorna TRUE si se ha grabado el error

RETURN li_FileReturn > 0
end function

public function boolean of_tracelog (datetime adt_fecha, string as_mensaje);// Graba el error en archivo

INTEGER	li_FileReturn = -1
STRING	ls_ErrorText

this.of_parametros( )

if is_Tracelog = '0' then return true

if not ib_log then
	this.initializelogging( )
end if

IF ib_Log THEN
	ls_ErrorText = "[" + String(adt_fecha, 'dd/mm/yyyy hh:mm:ss') + "] " + &
						"[Trace] " + &
						"[AppName: " + GetApplication().AppName + "] " + &
						"[User S.O.: " + gnvo_app.is_user_so + "] " + & 
						"[Estacion: " + gnvo_app.is_estacion + "]~t" + & 
						as_mensaje
						
	li_FileReturn = FileWrite(ii_FileNumber, ls_ErrorText)
	
	// Cierro el archivo una vez escrito el log en él
	FileClose(ii_FileNumber)
	ib_log = false

END IF

// Retorna TRUE si se ha grabado el error

RETURN li_FileReturn > 0
end function

public subroutine of_parametros ();if Not IsNull(gnvo_app) and IsValid(gnvo_app) then
	is_Errorlog = gnvo_app.is_errorlog
	is_Tracelog = gnvo_app.is_TraceLog
	is_Warninglog = gnvo_app.is_WarningLog	
else
	is_ErrorLog = ''
	is_TraceLog = ''
	is_WarningLog = ''
end if
end subroutine

public function string of_mensajedb (string as_mensaje, transaction atr_trans);String ls_mensaje = '', ls_errText
integer li_SQLCode

if as_mensaje <> '' then
	ls_mensaje += as_mensaje + "~r~n"
end if

li_SQLCode = atr_trans.SQlCode


if li_SQLCode = 100 then
	ls_mensaje += "SQLErrText: No se ha encontrado ninguna fila~r~n" + &
						 "SQLCode: " + String(atr_trans.SQLCode) + "~r~n" 

elseif li_SQLCOde < 0 then
	ls_errText = SQLCA.SQLErrText
	if pos(ls_errText, '~n') > 0 then ls_errText = left(ls_errText, pos(ls_errText,'~n') - 1) 
	if pos(ls_errText, '~r') > 0 then ls_errText = left(ls_errText, pos(ls_errText,'~r') - 1) 

	ls_mensaje += "SQLErrText: " + ls_errText + "~r~n" + &
					  "SQLCode: " + String(atr_trans.SQLCode) + "~r~n" + &
					  "SQLDbCode: " + String(atr_trans.SQLDbCode)
else
	ls_mensaje = ""
end if
			
return ls_mensaje
end function

on n_cst_errorlogging.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_errorlogging.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;IF ii_FileNumber > 0 THEN
	FileClose(ii_FileNumber)
END IF

end event

