$PBExportHeader$uo_dddw_seleccion.sru
forward
global type uo_dddw_seleccion from userobject
end type
type dw_1 from datawindow within uo_dddw_seleccion
end type
end forward

global type uo_dddw_seleccion from userobject
integer width = 1431
integer height = 116
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_seleccion ( )
dw_1 dw_1
end type
global uo_dddw_seleccion uo_dddw_seleccion

type variables
Long irow
datawindowChild idw

end variables

forward prototypes
public function integer of_set_dw (string as_dw1)
public function datawindow of_get_data ()
end prototypes

public function integer of_set_dw (string as_dw1);dw_1.dataobject = as_dw1
dw_1.SetTransObject( sqlca)
dw_1.insertrow(0)

//// Construye datastore
//ids = CREATE datastore
//ids.DataObject = 'd_user_delete'
//l_ds_delete.SetTransObject(SQLCA)
//li_cnt = l_ds_delete.Retrieve(lstr_data.name)

Return 1
end function

public function datawindow of_get_data ();this.triggerevent( "ue_seleccion")
return dw_1

end function

on uo_dddw_seleccion.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on uo_dddw_seleccion.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within uo_dddw_seleccion
integer x = 14
integer y = 8
integer width = 1399
integer height = 96
integer taborder = 10
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;this.AcceptText()
irow = getrow()

DataWindowChild state_child

integer rtncode
rtncode = dw_1.GetChild('campo', state_child)

IF rtncode = -1 THEN MessageBox( &
		"Error", "Not a DataWindowChild")

irow = state_child.getrow()
idw = state_child

of_get_data ()

//uo_dddw_seleccion.triggerevent ue_seleccion()
return 1
end event

event itemerror;return 1
end event

