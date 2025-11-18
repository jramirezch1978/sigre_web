$PBExportHeader$n_xls_panes.sru
forward
global type n_xls_panes from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_panes from nonvisualobject
end type
global n_xls_panes n_xls_panes

type variables
public double id_x
public double id_y
public uint ii_rowTop
public uint ii_colLeft

end variables

forward prototypes

end prototypes

on n_xls_panes.create
TriggerEvent(this, "constructor" )
end on

on n_xls_panes.destroy
TriggerEvent(this, "destructor" )
end on

