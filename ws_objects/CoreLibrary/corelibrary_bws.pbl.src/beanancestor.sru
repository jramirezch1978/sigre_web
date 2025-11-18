$PBExportHeader$beanancestor.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type beanAncestor from nonvisualobject
    end type
end forward

global type beanAncestor from nonvisualobject
end type

type variables
    boolean isOk
    string mensaje
end variables

on beanAncestor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on beanAncestor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

