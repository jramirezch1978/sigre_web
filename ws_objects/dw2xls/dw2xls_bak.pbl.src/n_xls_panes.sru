$PBExportHeader$n_xls_panes.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_xls_panes from nonvisualobject
end type
end forward

global type n_xls_panes from nonvisualobject
end type
global n_xls_panes n_xls_panes

type variables
public double id_x
public double id_y
public uint ii_rowtop
public uint ii_colleft
end variables

on n_xls_panes.create
triggerevent("constructor")
end on

on n_xls_panes.destroy
triggerevent("destructor")
end on

