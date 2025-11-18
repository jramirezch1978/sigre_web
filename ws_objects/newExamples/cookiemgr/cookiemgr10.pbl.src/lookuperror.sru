$PBExportHeader$lookuperror.sru
$PBExportComments$Proxy imported from EAServer via EAServer Proxy generator.
forward
global type LookupError from CORBAUserException
end type
end forward

global type LookupError from CORBAUserException
end type
global LookupError LookupError

type variables
  public:
    String		reason
end variables

on LookupError.create
call super::create
TriggerEvent( this, "constructor" )
end on

on LookupError.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

