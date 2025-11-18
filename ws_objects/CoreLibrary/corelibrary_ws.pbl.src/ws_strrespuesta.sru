$PBExportHeader$ws_strrespuesta.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type ws_strRespuesta from nonvisualobject
    end type
end forward

global type ws_strRespuesta from nonvisualobject
end type

type variables
    long contador
    boolean contadorSpecified
    long count
    boolean countSpecified
    long id
    boolean idSpecified
    boolean isOk
    boolean isOkSpecified
    string lista[]
    string mensaje
    ws_beanModulo modulos[]
end variables

on ws_strRespuesta.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ws_strRespuesta.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

