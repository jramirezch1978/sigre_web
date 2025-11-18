$PBExportHeader$n_xls_selection.sru
forward
global type n_xls_selection from nonvisualobject
end type
end forward

global type n_xls_selection from nonvisualobject
end type
global n_xls_selection n_xls_selection

type variables
PUBLIC UINT ii_first_row
PUBLIC INTEGER ii_first_col

PUBLIC UINT ii_last_row
PUBLIC INTEGER ii_last_col

end variables

on n_xls_selection.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_selection.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

