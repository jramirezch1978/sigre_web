$PBExportHeader$n_xls_panes.sru
forward
global type n_xls_panes from nonvisualobject
end type
end forward

global type n_xls_panes from nonvisualobject
end type
global n_xls_panes n_xls_panes

type variables
PUBLIC DOUBLE id_x
PUBLIC DOUBLE id_y

PUBLIC UINT ii_rowtop
PUBLIC UINT ii_colleft


end variables

on n_xls_panes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_panes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

