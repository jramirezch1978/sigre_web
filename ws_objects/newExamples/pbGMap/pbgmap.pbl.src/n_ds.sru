$PBExportHeader$n_ds.sru
forward
global type n_ds from datastore
end type
end forward

global type n_ds from datastore
end type
global n_ds n_ds

event constructor;//n_ds Ancestor object for Datastore
end event

on n_ds.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ds.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event wserror;w_googlemaps_demo.st_error.text = errormessage
end event

