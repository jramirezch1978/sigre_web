$PBExportHeader$u_ddlb_ot_adm_user.sru
$PBExportComments$ddlb que carga desde datawindow
forward
global type u_ddlb_ot_adm_user from u_ddlb_mc
end type
end forward

global type u_ddlb_ot_adm_user from u_ddlb_mc
end type
global u_ddlb_ot_adm_user u_ddlb_ot_adm_user

on u_ddlb_ot_adm_user.create
call super::create
end on

on u_ddlb_ot_adm_user.destroy
call super::destroy
end on

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve(gs_user)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, ' ')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,' ')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT


if ll_rows > 0 then this.selectitem(1)
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_ot_adm_user_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 300                     // Longitud del campo 1
ii_lc2 = 10							// Longitud del campo 2


end event

