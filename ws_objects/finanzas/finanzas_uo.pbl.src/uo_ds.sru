$PBExportHeader$uo_ds.sru
forward
global type uo_ds from datastore
end type
end forward

global type uo_ds from datastore
end type
global uo_ds uo_ds

event dberror;MESSAGEBOX('SQLDBCODE',SQLERRTEXT)
end event

on uo_ds.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_ds.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

