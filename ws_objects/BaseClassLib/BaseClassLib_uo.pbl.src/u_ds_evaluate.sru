$PBExportHeader$u_ds_evaluate.sru
$PBExportComments$Datastore para Evualuar Formulas
forward
global type u_ds_evaluate from datastore
end type
end forward

global type u_ds_evaluate from datastore
string DataObject="d_evaluate"
end type
global u_ds_evaluate u_ds_evaluate

event constructor;insertRow(0)
end event

on u_ds_evaluate.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on u_ds_evaluate.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

