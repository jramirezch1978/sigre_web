$PBExportHeader$nv_error.sru
forward
global type nv_error from error
end type
end forward

global type nv_error from error
end type
global nv_error nv_error

on nv_error.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_error.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

