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
ulong il_hash
string is_key

end variables

on n_cst_hash_entry.create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash_entry.destroy
TriggerEvent( this, "destructor" )
end on

