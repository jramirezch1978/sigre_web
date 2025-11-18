$PBExportHeader$n_cst_hash_entry.sru
forward
global type n_cst_hash_entry from nonvisualobject
end type
end forward

global type n_cst_hash_entry from nonvisualobject
end type
global n_cst_hash_entry n_cst_hash_entry

type variables
n_cst_hash_entry invo_next
STRING is_key
UNSIGNEDLONG il_hash

end variables

on n_cst_hash_entry.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash_entry.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

