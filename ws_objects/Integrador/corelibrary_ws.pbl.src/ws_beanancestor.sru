$PBExportHeader$ws_beanancestor.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type ws_beanAncestor from nonvisualobject
    end type
end forward

global type ws_beanAncestor from nonvisualobject
end type

type variables
end variables

on ws_beanAncestor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ws_beanAncestor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

