$PBExportHeader$n_dwr_progress.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_progress from nonvisualobject
end type
end forward

global type n_dwr_progress from nonvisualobject
end type
global n_dwr_progress n_dwr_progress

type variables
public w_n_dwr_service_progress iw_progress
public long il_progress_rown
public long il_change_progress_each = 1
public long il_cur_change_progress
public long il_progress_row
public long il_percent_of_process = 100
public long il_percent_of_analyse
end variables

on n_dwr_progress.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_progress.destroy
triggerevent("destructor")
call super::destroy
end on

