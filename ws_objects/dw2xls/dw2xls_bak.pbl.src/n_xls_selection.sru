$PBExportHeader$n_xls_selection.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_xls_selection from nonvisualobject
end type
end forward

global type n_xls_selection from nonvisualobject
end type
global n_xls_selection n_xls_selection

type variables
public uint ii_first_row
public integer ii_first_col
public uint ii_last_row
public integer ii_last_col
end variables

on n_xls_selection.create
triggerevent("constructor")
end on

on n_xls_selection.destroy
triggerevent("destructor")
end on

