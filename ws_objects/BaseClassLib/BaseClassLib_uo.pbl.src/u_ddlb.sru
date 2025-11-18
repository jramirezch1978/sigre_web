$PBExportHeader$u_ddlb.sru
$PBExportComments$ddlb que carga desde datawindow
forward
global type u_ddlb from dropdownlistbox
end type
end forward

global type u_ddlb from dropdownlistbox
integer width = 256
integer height = 228
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
event ue_close_pos ( )
event ue_constructor ( )
event ue_open_pre ( )
event ue_output ( any aa_key )
event ue_populate ( )
event ue_item_add ( )
end type
global u_ddlb u_ddlb

type variables
Datastore     ids_data
Any               ia_key[], ia_id
Integer          ii_lc1, ii_lc2, ii_cn1, ii_cn2, ii_ck
String            is_dataobject

end variables

forward prototypes
public function string of_cut_string (any aa_data, integer ai_long, character as_char)
end prototypes

event ue_close_pos;Destroy ids_data


end event

event ue_open_pre;//is_dataobject = 'd_adm_tbl'

//ii_cn1 = 1                     // Nro del campo 1
//ii_cn2 = 2                     // Nro del campo 2
//ii_ck  = 1                     // Nro del campo key
//ii_lc1 = 1                     // Longitud del campo 1
//ii_lc2 = 1							// Longitud del campo 2

end event

event ue_output;//dw_master.Retrieve(aa_key)
end event

event ue_populate;
SetPointer(HourGlass!)

// crear datastore para el ddlb
ids_data = Create DataStore
ids_data.DataObject = is_dataobject
ids_data.SetTransObject(sqlca)

THIS.Event ue_item_add()

end event

event ue_item_add();Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve()

IF ll_rows < 1 THEN	MessageBox('Error', 'Este DDLB no tiene Registros')

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT




end event

public function string of_cut_string (any aa_data, integer ai_long, character as_char);String	ls_string
Integer	li_long, li_dif

IF IsNull(aa_data) THEN	aa_data = '--NULL--'

ls_string = String(aa_data)

li_long = Len(ls_string)

IF li_long > ai_long THEN
	ls_string = Left(ls_string, ai_long)
ELSE
	IF li_long < ai_long THEN
		li_dif = ai_long - li_long
		ls_string = ls_string + Fill(as_char, li_dif)
	END IF
END IF

RETURN ls_string
end function

event constructor;THIS.Event ue_constructor()

THIS.Event ue_open_pre()

THIS.Event ue_populate()
end event

event selectionchanged;IF index < 1 OR index > UpperBound(ia_key) THEN RETURN

ia_id = ia_key[index]

THIS.Event ue_output(ia_id)


end event

on u_ddlb.create
end on

on u_ddlb.destroy
end on

