$PBExportHeader$n_dwr_nested_service_parm.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_nested_service_parm from nonvisualobject
end type
end forward

global type n_dwr_nested_service_parm from nonvisualobject
end type
global n_dwr_nested_service_parm n_dwr_nested_service_parm

type variables
public n_dwr_grid invo_global_vgrid
public n_dwr_grid invo_dynamic_hgrid
public n_xls_worksheet invo_cur_sheet
public n_dwr_worksheet inv_sheet
public n_dwr_colors invo_colors
public powerobject ipo_dynamic_requestor
public long il_nested_x
public long il_nested_y
public string is_parent_band_id = "1"
public long il_writer_row = -1
public long il_parent_row = -1
public n_dwr_progress ipo_progress
end variables

on n_dwr_nested_service_parm.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_nested_service_parm.destroy
triggerevent("destructor")
call super::destroy
end on

