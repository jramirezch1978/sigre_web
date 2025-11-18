$PBExportHeader$n_cst_hash_blob_entry.sru
forward
global type n_cst_hash_blob_entry from nonvisualobject
end type
end forward

global type n_cst_hash_blob_entry from nonvisualobject
end type
global n_cst_hash_blob_entry n_cst_hash_blob_entry

type variables
n_cst_hash_blob_entry invo_next
ulong il_hash
blob ib_key

end variables

on n_cst_hash_blob_entry.create
TriggerEvent( this, "constructor" )
end on

on n_cst_hash_blob_entry.destroy
TriggerEvent( this, "destructor" )
end on

