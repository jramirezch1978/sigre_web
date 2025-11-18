$PBExportHeader$n_cst_wait.sru
forward
global type n_cst_wait from nonvisualobject
end type
end forward

global type n_cst_wait from nonvisualobject
end type
global n_cst_wait n_cst_wait

type variables
w_wait  iw_wait
end variables

forward prototypes
public subroutine of_wait (boolean ab_visible)
public function boolean of_mensaje (string as_mensaje)
public subroutine of_close ()
end prototypes

public subroutine of_wait (boolean ab_visible);if ab_visible then
	if IsNull(iw_wait) or not isValid(iw_wait) then
		Open(iw_wait)
	end if
	//iw_wait.show()
	
else
	Close(iw_wait)
	setNull(iw_wait)
end if
end subroutine

public function boolean of_mensaje (string as_mensaje);try
	yield()
	
	this.of_wait(true)
	
	if IsNull(iw_wait) or not isValid(iw_wait) then return false
		
	iw_wait.of_mensaje(as_mensaje)
	
	return true

catch(Exception ex)
	MessageBox('Error', 'Ha ocurrido una excepción: ' + ex.getMessage(), StopSign!)
	
finally
	yield()
	
end try


end function

public subroutine of_close ();this.of_wait(false)
end subroutine

on n_cst_wait.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_wait.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;destroy iw_wait
end event

