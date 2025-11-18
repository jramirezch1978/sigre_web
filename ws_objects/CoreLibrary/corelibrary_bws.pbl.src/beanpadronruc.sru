$PBExportHeader$beanpadronruc.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type beanPadronRuc from beanAncestorWS
    end type
end forward

    global type beanPadronRuc from beanAncestorWS
end type

type variables
    string ruc
    string razonSocial
    string estado
    string condicion
    string ubigeo
    string tipoVia
    string nombreVia
    string codigoZona
    string tipoZona
    string numero
    string interior
    string lote
    string departamento
    string manzana
    string kilometro
    string codProvincia
    string descProvincia
    string codDepartamento
    string descDepartamento
    string descDistrito
    boolean isOk
    string mensaje
end variables

on beanPadronRuc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on beanPadronRuc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

