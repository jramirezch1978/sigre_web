$PBExportHeader$n_xls_colinfo.sru
forward
global type n_xls_colinfo from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_colinfo from nonvisualobject
end type
global n_xls_colinfo n_xls_colinfo

type variables
public uint ii_firstcol
public uint ii_lastcol
public double id_width = 8.43
public n_xls_format invo_format
public boolean ib_hidden = false

end variables

forward prototypes

end prototypes

on n_xls_colinfo.create
TriggerEvent( this, "constructor" )
end on

on n_xls_colinfo.destroy
TriggerEvent( this, "destructor" )
end on

