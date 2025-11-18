$PBExportHeader$n_cst_hash_long_entry.sru
forward
global type n_cst_hash_long_entry from n_cst_hash_entry
end type
end forward

global type n_cst_hash_long_entry from n_cst_hash_entry
end type
global n_cst_hash_long_entry n_cst_hash_long_entry

type variables
long il_value
end variables

on n_cst_hash_long_entry.create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash_long_entry.destroy
TriggerEvent( this, "destructor" )
end on

