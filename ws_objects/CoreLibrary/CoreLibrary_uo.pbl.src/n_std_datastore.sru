$PBExportHeader$n_std_datastore.sru
forward
global type n_std_datastore from datastore
end type
end forward

global type n_std_datastore from datastore
end type
global n_std_datastore n_std_datastore

event dberror;Messagebox("Error: "+String(sqldbcode),"Detalle: "+sqlerrtext )
return -1
end event

on n_std_datastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_std_datastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

