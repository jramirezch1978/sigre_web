$PBExportHeader$n_cst_hash_blob_entry.sru
forward
global type n_cst_hash_blob_entry from nonvisualobject
end type
end forward

global type n_cst_hash_blob_entry from nonvisualobject
end type
global n_cst_hash_blob_entry n_cst_hash_blob_entry

type variables
blob ib_key
n_cst_hash_blob_entry invo_next
unsignedlong il_hash
end variables

on n_cst_hash_blob_entry.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash_blob_entry.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

