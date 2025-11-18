$PBExportHeader$n_dwr_service_excel.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_service_excel from nonvisualobject
end type
end forward

global type n_dwr_service_excel from nonvisualobject
end type
global n_dwr_service_excel n_dwr_service_excel

type variables
private n_dwr_service invo_dwr
public n_dwr_workbook invo_writer
public n_dwr_workbook inv_book
private string is_filename
private boolean ib_init = false
end variables

forward prototypes
public function integer of_close_wb ()
public function integer of_create_wb (string as_filename,ref n_dwr_service_parm anvo_parm)
public function integer of_save_ds2sheet (ref datastore ads_ds,ref n_dwr_service_parm anvo_parm)
public function integer of_save_dw2sheet (ref datawindow adw_dw,ref n_dwr_service_parm anvo_parm)
end prototypes

public function integer of_close_wb ();integer li_ret = 1

if ib_init then
	li_ret = invo_dwr.of_close()
	destroy(invo_writer)
	destroy(invo_dwr)

	if li_ret <> 1 then
		filedelete(is_filename)
	end if

	ib_init = false
else
	messagebox("DW2XLS-Error","Workbook was not created!")
end if

return li_ret
end function

public function integer of_create_wb (string as_filename,ref n_dwr_service_parm anvo_parm);integer li_ret = 1
long ll_error

if not ib_init then

	if isnull(anvo_parm) and ( not isvalid(anvo_parm)) then
		anvo_parm = create n_dwr_service_parm
	end if

	invo_dwr = create n_dwr_service
	invo_dwr.ib_multisheet = true
	inv_book = create n_dwr_workbook
	invo_writer = inv_book
	ll_error = inv_book.of_create(anvo_parm.is_version,as_filename,true)

	if ll_error <> 0 then
		return -1
	end if

	is_filename = as_filename
	ib_init = true
else
	messagebox("DW2XLS Error","Workbook already created!")
end if

return li_ret
end function

public function integer of_save_ds2sheet (ref datastore ads_ds,ref n_dwr_service_parm anvo_parm);integer li_ret = 1
n_dwr_nested_service_parm lnvo_nested_parm

if ib_init then
	li_ret = invo_dwr.of_create(ads_ds,inv_book,is_filename,anvo_parm,lnvo_nested_parm)

	if li_ret = 1 then
		li_ret = invo_dwr.of_process()
	end if

else
	messagebox("DW2XLS-Error","There is no created Workbook!")
	li_ret = -1
end if

return li_ret
end function

public function integer of_save_dw2sheet (ref datawindow adw_dw,ref n_dwr_service_parm anvo_parm);integer li_ret = 1
n_dwr_nested_service_parm lnvo_nested_parm

if ib_init then
	li_ret = invo_dwr.of_create(adw_dw,inv_book,is_filename,anvo_parm,lnvo_nested_parm)

	if li_ret = 1 then
		li_ret = invo_dwr.of_process()
	end if

else
	messagebox("DW2XLS-Error","There is no created Workbook!")
	li_ret = -1
end if

return li_ret
end function

on n_dwr_service_excel.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_service_excel.destroy
triggerevent("destructor")
call super::destroy
end on

