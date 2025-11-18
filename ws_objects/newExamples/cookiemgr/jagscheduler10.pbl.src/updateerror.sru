$PBExportHeader$updateerror.sru
$PBExportComments$Proxy imported from EAServer via EAServer Proxy generator.
forward
global type UpdateError from CORBAUserException
end type
end forward

global type UpdateError from CORBAUserException
end type
global UpdateError UpdateError

type variables
  public:
    String		reason
end variables

on UpdateError.create
call super::create
TriggerEvent( this, "constructor" )
end on

on UpdateError.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

