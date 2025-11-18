$PBExportHeader$beanancestorws.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type beanAncestorWS from beanAncestor
    end type
end forward

    global type beanAncestorWS from beanAncestor
end type

type variables
    boolean isOk
    string mensaje
end variables

on beanAncestorWS.create
call super::create
TriggerEvent( this, "constructor" )
end on

on beanAncestorWS.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

