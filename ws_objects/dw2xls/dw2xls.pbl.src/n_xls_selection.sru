$PBExportHeader$n_xls_selection.sru
forward
global type n_xls_selection from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_selection from nonvisualobject
end type
global n_xls_selection n_xls_selection

type variables
public uint ii_first_row
public int ii_first_col
public uint ii_last_row
public int ii_last_col

end variables

forward prototypes

end prototypes

on n_xls_selection.create
TriggerEvent(this, "constructor" )
end on

on n_xls_selection.destroy
TriggerEvent(this, "destructor" )
end on

