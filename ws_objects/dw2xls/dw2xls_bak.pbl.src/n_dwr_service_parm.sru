$PBExportHeader$n_dwr_service_parm.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_service_parm from nonvisualobject
end type
end forward

global type n_dwr_service_parm from nonvisualobject
end type
global n_dwr_service_parm n_dwr_service_parm

type variables
public boolean ib_header = true
public boolean ib_foreground = true
public boolean ib_background = true
public boolean ib_detail = true
public boolean ib_summary = true
public boolean ib_footer = true
public boolean ib_group_header = true
public boolean ib_group_trailer = true
public boolean ib_keep_band_height = false
public boolean ib_enable_merge_cells = true
public boolean ib_show_progress = true
public boolean ib_hide_grid = false
public string is_version = "97"
public string is_sheet_name = "Sheet1"
public boolean ib_group_pagebreak = false
public boolean ib_group_pageheader = true
public boolean ib_nested = true
public double id_min_width = 0.5
public double id_min_height = 4
public long il_nested_instance_count
public integer ii_nested_extract_method = 1
end variables

on n_dwr_service_parm.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_service_parm.destroy
triggerevent("destructor")
call super::destroy
end on

