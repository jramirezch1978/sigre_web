$PBExportHeader$n_cst_hash_long_entry.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_cst_hash_long_entry from n_cst_hash_entry
end type
end forward

global type n_cst_hash_long_entry from n_cst_hash_entry
end type
global n_cst_hash_long_entry n_cst_hash_long_entry

type variables
public long il_value
end variables

on n_cst_hash_long_entry.create
triggerevent("constructor")
end on

on n_cst_hash_long_entry.destroy
triggerevent("destructor")
end on

