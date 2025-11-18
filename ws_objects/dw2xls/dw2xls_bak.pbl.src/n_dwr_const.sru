$PBExportHeader$n_dwr_const.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_const from nonvisualobject
end type
end forward

global type n_dwr_const from nonvisualobject
end type
global n_dwr_const n_dwr_const

type variables
public long s_ok
public long e_failed = 1
public long e_workbookfailed = 2
public long e_workbookaccessdenied = 3
public long e_workbookalreadyexists = 4
public long e_workbookformatnotsupported = 5
public string e_message[]={"Failed","Workbook: creation failed","Workbook: access denied","Workbook: already exists","Workbook: format not supported"}
public long align_left
public long align_right = 1
public long align_center = 2
public long align_justified = 3
public long align_bottom = 2
public long align_top
public long align_vcenter = 1
public long landscape
public long portrait = 1
end variables

on n_dwr_const.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_const.destroy
triggerevent("destructor")
call super::destroy
end on

