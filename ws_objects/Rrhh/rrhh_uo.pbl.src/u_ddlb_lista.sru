$PBExportHeader$u_ddlb_lista.sru
forward
global type u_ddlb_lista from u_ddlb
end type
end forward

global type u_ddlb_lista from u_ddlb
integer width = 800
integer height = 412
integer textsize = -8
end type
global u_ddlb_lista u_ddlb_lista

on u_ddlb_lista.create
call super::create
end on

on u_ddlb_lista.destroy
call super::destroy
end on

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve()

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, ' ')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

if ll_rows >= 1 then this.selectitem(1)
end event

