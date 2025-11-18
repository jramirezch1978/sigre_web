$PBExportHeader$ws_beanmodulo.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type ws_beanModulo from nonvisualobject
    end type
end forward

global type ws_beanModulo from nonvisualobject
end type

type variables
    string codigo
    string descripcion
    string flagEstado
    string flag_acceso
    string icono
    long moduloId
    boolean moduloIdSpecified
end variables

on ws_beanModulo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ws_beanModulo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

