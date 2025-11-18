$PBExportHeader$n_dwr_service_base.sru
forward
global type n_dwr_service_base from nonvisualobject
end type
end forward

shared variables

end variables

global type n_dwr_service_base from nonvisualobject
event ue_process_work ( )
event ue_cancel ( )
end type
global n_dwr_service_base n_dwr_service_base

type variables

end variables

forward prototypes
public function integer of_process_work ()
public function integer of_process ()
public function integer of_close ()
public function integer of_cancel ()
public function boolean of_is_newpage (long al_row)
public function string of_describe (readonly string as_expr)
public function integer of_create (powerobject apo_requestor, n_xls_workbook anvo_writer, string as_filename)
public function integer of_create (powerobject apo_requestor, n_xls_workbook anvo_writer, string as_filename, n_dwr_service_parm anvo_parm, n_dwr_nested_service_parm anvo_nested_parm)
public function integer of_analyse_dw (integer ai_percent_of_analyse)
public function integer of_register_dynamic (powerobject apo_requestor)
public function integer of_set_col_width ()
public function string of_modify (readonly string as_expr)
public function long of_rowcount ()
end prototypes

event ue_process_work;of_process_work()
end event

event ue_cancel;of_cancel()
end event

public function integer of_process_work ();any la_ret
Return la_ret

end function

public function integer of_process ();any la_ret
Return la_ret

end function

public function integer of_close ();any la_ret
Return la_ret

end function

public function integer of_cancel ();any la_ret
Return la_ret

end function

public function boolean of_is_newpage (long al_row);any la_ret
Return la_ret

end function

public function string of_describe (readonly string as_expr);any la_ret
Return la_ret

end function

public function integer of_create (powerobject apo_requestor, n_xls_workbook anvo_writer, string as_filename);any la_ret
Return la_ret

end function

public function integer of_create (powerobject apo_requestor, n_xls_workbook anvo_writer, string as_filename, n_dwr_service_parm anvo_parm, n_dwr_nested_service_parm anvo_nested_parm);any la_ret
Return la_ret

end function

public function integer of_analyse_dw (integer ai_percent_of_analyse);any la_ret
Return la_ret

end function

public function integer of_register_dynamic (powerobject apo_requestor);any la_ret
Return la_ret

end function

public function integer of_set_col_width ();any la_ret
Return la_ret

end function

public function string of_modify (readonly string as_expr);any la_ret
Return la_ret

end function

public function long of_rowcount ();any la_ret
Return la_ret

end function

on n_dwr_service_base.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwr_service_base.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

