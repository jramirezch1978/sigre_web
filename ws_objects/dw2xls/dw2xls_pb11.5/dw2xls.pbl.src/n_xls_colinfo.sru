$PBExportHeader$n_xls_colinfo.sru
forward
global type n_xls_colinfo from nonvisualobject
end type
end forward

global type n_xls_colinfo from nonvisualobject
end type
global n_xls_colinfo n_xls_colinfo

type variables
PUBLIC UINT ii_firstcol

PUBLIC UINT ii_lastcol
PUBLIC DOUBLE id_width = 8.43

PUBLIC n_xls_format invo_format
PUBLIC BOOLEAN ib_hidden



end variables

on n_xls_colinfo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_colinfo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

