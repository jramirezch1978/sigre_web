$PBExportHeader$n_cst_hash_blob_entry.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_cst_hash_blob_entry from nonvisualobject
end type
end forward

global type n_cst_hash_blob_entry from nonvisualobject
end type
global n_cst_hash_blob_entry n_cst_hash_blob_entry

type variables
public n_cst_hash_blob_entry invo_next
public ulong il_hash
public blob ib_key
end variables

on n_cst_hash_blob_entry.create
triggerevent("constructor")
end on

on n_cst_hash_blob_entry.destroy
triggerevent("destructor")
end on

