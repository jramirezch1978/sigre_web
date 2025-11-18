$PBExportHeader$n_found_column.sru
forward
global type n_found_column from exception
end type
end forward

global type n_found_column from exception
end type
global n_found_column n_found_column

on n_found_column.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_found_column.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

