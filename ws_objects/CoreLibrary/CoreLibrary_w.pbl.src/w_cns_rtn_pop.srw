$PBExportHeader$w_cns_rtn_pop.srw
forward
global type w_cns_rtn_pop from w_cns_pop
end type
end forward

global type w_cns_rtn_pop from w_cns_pop
end type
global w_cns_rtn_pop w_cns_rtn_pop

on w_cns_rtn_pop.create
call super::create
end on

on w_cns_rtn_pop.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_cns_pop`dw_master within w_cns_rtn_pop
end type

event dw_master::clicked;call super::clicked;// Seleccionar Fila
This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.SetRow(row)


end event

event dw_master::doubleclicked;// Override
String	ls_value

IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
END IF

IF row = 0 THEN 
	This.SelectRow(0, False)
	RETURN
END IF

ls_value = TRIM(THIS.GetItemString(row, istr_1.rtn_field))

IF IsValid(istr_1.dw) THEN
	istr_1.dw.SetText(ls_value)
	Close(Parent)
END IF

IF IsValid(istr_1.sle) THEN
	istr_1.sle.Text = ls_value
	Close(Parent)
END IF

end event

