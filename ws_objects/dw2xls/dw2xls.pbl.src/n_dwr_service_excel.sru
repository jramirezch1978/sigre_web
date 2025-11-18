$PBExportHeader$n_dwr_service_excel.sru
forward
global type n_dwr_service_excel from nonvisualobject
end type
end forward

global type n_dwr_service_excel from nonvisualobject
end type
global n_dwr_service_excel n_dwr_service_excel

type variables
private n_dwr_service invo_dwr
public n_xls_workbook invo_writer
private string is_filename
private boolean ib_init = false
end variables

forward prototypes
public function integer of_close_wb ()
public function integer of_create_wb (string as_filename, ref n_dwr_service_parm anvo_parm)
public function integer of_save_dw2sheet (ref datawindow adw_dw, ref n_dwr_service_parm anvo_parm)
public function integer of_save_ds2sheet (ref datastore ads_ds, ref n_dwr_service_parm anvo_parm)
end prototypes

public function integer of_close_wb ();integer li_ret = 1

if ib_init then
	li_ret = invo_dwr.of_close()
	
	destroy invo_writer
	destroy invo_dwr
	
	if li_ret <> 1 then FileDelete(is_filename)
	ib_init = false
else
	messagebox('DW2XLS-Error', 'Workbook was not created!')
end if

return li_ret
end function

public function integer of_create_wb (string as_filename, ref n_dwr_service_parm anvo_parm);integer li_ret = 1

if not(ib_init) then
	if isNull(anvo_parm) and not isValid(anvo_parm) then anvo_parm = create n_dwr_service_parm
	
	invo_dwr = create n_dwr_service
	
	invo_dwr.ib_modemultisheet = true
	if anvo_parm.is_version = '97' then
		invo_writer = create n_xls_workbook_v97
	else
		invo_writer = create n_xls_workbook_v5
	end if
	
	is_filename = as_filename
	
	ib_init = true
else
	messagebox('DW2XLS-Error', 'Workbook already created!')
end if

return li_ret
end function

public function integer of_save_dw2sheet (ref datawindow adw_dw, ref n_dwr_service_parm anvo_parm);integer li_ret = 1
n_dwr_nested_service_parm lnvo_nested_parm

if ib_init then 
	li_ret = invo_dwr.of_create(adw_dw, invo_writer, is_filename, anvo_parm, lnvo_nested_parm)
	
	if li_ret = 1 then
		li_ret = invo_dwr.of_process()
	end if
else
	messagebox('DW2XLS-Error', 'There is no created Workbook!')
	li_ret = -1
end if

return li_ret
end function

public function integer of_save_ds2sheet (ref datastore ads_ds, ref n_dwr_service_parm anvo_parm);integer li_ret = 1
n_dwr_nested_service_parm lnvo_nested_parm

if ib_init then 
	open(w_ds2xls)
	li_ret = w_ds2xls.of_register_ds(ads_ds)
	
	if li_ret = 1 then li_ret = invo_dwr.of_create(w_ds2xls.dw_1, invo_writer, is_filename, anvo_parm, lnvo_nested_parm)
	
	if li_ret = 1 then
		li_ret = invo_dwr.of_process()
	end if
	
	w_ds2xls.of_unregister_ds(ads_ds)
	close(w_ds2xls)
else
	messagebox('DW2XLS-Error', 'There is no created Workbook!')
	li_ret = -1
end if

return li_ret
end function

on n_dwr_service_excel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_service_excel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

