$PBExportHeader$jaguarexception.sru
$PBExportComments$Proxy imported from EAServer via EAServer Proxy generator.
forward
global type JaguarException from CORBAUserException
end type
end forward

global type JaguarException from CORBAUserException
end type
global JaguarException JaguarException

type variables
  public:
    Long		errorCode
    String		reason
end variables

on JaguarException.create
call super::create
TriggerEvent( this, "constructor" )
end on

on JaguarException.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

