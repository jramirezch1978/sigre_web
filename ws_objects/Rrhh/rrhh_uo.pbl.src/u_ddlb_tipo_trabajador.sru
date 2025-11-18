$PBExportHeader$u_ddlb_tipo_trabajador.sru
forward
global type u_ddlb_tipo_trabajador from userobject
end type
type cbx_todos from checkbox within u_ddlb_tipo_trabajador
end type
type ddlb_tipo_trabaj from u_ddlb_lista within u_ddlb_tipo_trabajador
end type
type gb_1 from groupbox within u_ddlb_tipo_trabajador
end type
end forward

global type u_ddlb_tipo_trabajador from userobject
integer width = 905
integer height = 212
long backcolor = 67108864
string text = "none"
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
cbx_todos cbx_todos
ddlb_tipo_trabaj ddlb_tipo_trabaj
gb_1 gb_1
end type
global u_ddlb_tipo_trabajador u_ddlb_tipo_trabajador

forward prototypes
public function string of_get_value ()
end prototypes

public function string of_get_value ();if cbx_todos.checked then
	return '%%'
else
	return trim(string(ddlb_tipo_trabaj.ia_key[ddlb_tipo_trabaj.ii_index])) + '%'
end if
end function

on u_ddlb_tipo_trabajador.create
this.cbx_todos=create cbx_todos
this.ddlb_tipo_trabaj=create ddlb_tipo_trabaj
this.gb_1=create gb_1
this.Control[]={this.cbx_todos,&
this.ddlb_tipo_trabaj,&
this.gb_1}
end on

on u_ddlb_tipo_trabajador.destroy
destroy(this.cbx_todos)
destroy(this.ddlb_tipo_trabaj)
destroy(this.gb_1)
end on

type cbx_todos from checkbox within u_ddlb_tipo_trabajador
integer x = 507
integer width = 238
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_tipo_trabaj.enabled = false
else
	ddlb_tipo_trabaj.enabled = true
end if
end event

type ddlb_tipo_trabaj from u_ddlb_lista within u_ddlb_tipo_trabajador
integer x = 64
integer y = 76
integer height = 464
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_list_tipo_trabajador_user_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 3							// Longitud del campo 2

//event ue_populate()

end event

event ue_populate;//Override
SetPointer(HourGlass!)

// crear datastore para el ddlb
ids_data = Create DataStore
ids_data.DataObject = is_dataobject
ids_data.SetTransObject(sqlca)

THIS.Event ue_item_add()

this.selectitem(1)
end event

event ue_item_add;//Override
Integer	li_index, li_x
Any  		la_id
String	ls_item

ids_Data.Retrieve(gs_user)

if ids_data.RowCount() = 0 then
	MessageBox('Error', 'El usuario ' + gs_user + ' no tiene especificado ningun tipo de trabajador, por favor verifique!', StopSign!)	
	return
end if


FOR li_x = 1 TO ids_data.RowCount()
	la_id 	= ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item 	= of_cut_string(la_id, ii_lc1, '.')
	la_id 	= ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item 	= ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

ii_index = 1




end event

type gb_1 from groupbox within u_ddlb_tipo_trabajador
integer width = 896
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Tipo de Trabajador                  "
end type

