$PBExportHeader$u_tv_estructura.sru
$PBExportComments$treeview que se carga con datawindows
forward
global type u_tv_estructura from treeview
end type
end forward

global type u_tv_estructura from treeview
integer width = 494
integer height = 360
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
string picturename[] = {"Custom039!","Custom050!"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event ue_open_pre ( )
event ue_close_pos ( )
event type integer ue_item_add ( long al_handle,  integer ai_nivel,  integer ai_rows )
event ue_item_set ( integer ai_nivel,  integer ai_row,  ref treeviewitem atvi_new )
event ue_populate ( any aa_codigo,  string as_descripcion )
event ue_output ( integer ai_nivel,  any aa_parm )
event ue_constructor ( )
event ue_selectionchanged_pre ( )
end type
global u_tv_estructura u_tv_estructura

type variables
Datastore	ids_data
Integer     ii_numkey
String      is_dataobject
Long        il_handle, il_active[]
end variables

forward prototypes
public function integer of_selected_item_delete ()
public function long of_get_item_parent (long al_handle)
public function long of_get_item_previous (long al_handle)
public function long of_get_item_next (long al_handle)
public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2)
public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2, ref string as_k3)
public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2, ref string as_k3, ref string as_k4)
public function long of_recreate_child (long al_handle)
public function long of_get_item_level (long al_handle)
public subroutine of_clear ()
public subroutine of_set_dataobject (string as_dataobject)
end prototypes

event ue_open_pre();is_dataobject = 'd_estructura_ds'

ii_numkey = 1  






end event

event ue_close_pos();Destroy ids_data

end event

event type integer ue_item_add(long al_handle, integer ai_nivel, integer ai_rows);// Introducir los items al treeview

Integer				li_cnt
TreeViewItem		ltvi_new

For li_cnt = 1 To ai_Rows
	THIS.Event ue_Item_set(ai_nivel, li_cnt, ltvi_new)  	// colocar el label y data al treeview item
	IF THIS.InsertItemLast(al_handle, ltvi_New) < 1 Then
		MessageBox("Error", "Error al introducir el item")
		Return -1
	End If
Next

Return ai_Rows
end event

event ue_item_set(integer ai_nivel, integer ai_row, ref treeviewitem atvi_new);// Colocar el label y atributos para el nuevo item

Integer	li_Picture, li_max

atvi_New.Label = ids_Data.Object.nom_articulo[ai_Row] + " (" + String(Truncate(ids_Data.Object.cantidad[ai_Row],0)) + ")"
atvi_New.Data  = ids_Data.Object.articulo_hijo[ai_Row]

atvi_New.Children = True

atvi_New.PictureIndex = 1
atvi_New.SelectedPictureIndex = 2    //picture de abierto

end event

event ue_populate(any aa_codigo, string as_descripcion);Integer			li_Rows, li_cnt
Long				ll_handle
TreeViewItem	ltvi_Root
String			ls_root

SetPointer(HourGlass!)

// crear datastores para el treeview
ids_data = Create DataStore
ids_data.DataObject = is_dataobject
ids_data.SetTransObject(sqlca)
	
ltvi_Root.Label = as_descripcion
ltvi_Root.Data  = aa_codigo
ltvi_Root.Children = True
ltvi_Root.PictureIndex = 1
ltvi_Root.SelectedPictureIndex = 2
ll_handle = THIS.InsertItemLast(0, ltvi_Root)


end event

public function integer of_selected_item_delete ();IF IsNull(il_handle) THEN	RETURN -1

IF THIS.DeleteItem(il_handle) = -1 THEN RETURN -1

il_handle = THIS.FindItem(NextTreeItem!, il_handle)

IF il_handle = -1 THEN
	il_handle = THIS.FindItem(ParentTreeItem!, il_handle)
END IF
	
RETURN 1

end function

public function long of_get_item_parent (long al_handle);Long		ll_parent

ll_parent = THIS.FindItem(ParentTreeItem!, al_handle)

RETURN ll_parent

end function

public function long of_get_item_previous (long al_handle);Long		ll_handle

ll_handle = THIS.FindItem(PreviousTreeItem! , al_handle)

RETURN ll_handle

end function

public function long of_get_item_next (long al_handle);Long		ll_handle

ll_handle = THIS.FindItem(NextTreeItem!  , al_handle)

RETURN ll_handle

end function

public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2);Integer	li_pos, li_p2, li_len
	
li_pos = pos(as_parm,'|')
li_p2 = pos(as_parm, '|', li_pos + 1)

as_k1 = Left(as_parm, li_pos - 1)

IF li_p2 < li_pos THEN
	as_k2 = Mid(as_parm, li_pos + 1)
ELSE
	li_len = li_p2 - li_pos - 1
	as_k2 = Mid(as_parm, li_pos + 1, li_len)
END IF

RETURN li_pos
end function

public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2, ref string as_k3);Integer	li_pos, li_p2, li_p3, li_len

li_pos = of_get_key(as_parm, as_k1, as_k2)
	
li_p2 = li_pos + len(as_k2) + 1
li_p3 = pos(as_parm, '|', li_p2 + 1)

IF li_p3 < li_p2 THEN
	as_k3 = Mid(as_parm, li_p2 + 1)
ELSE
	li_len = li_p3 - li_p2 - 1
	as_k3 = Mid(as_parm, li_p2 + 1, li_len)
END IF

RETURN li_p2


end function

public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2, ref string as_k3, ref string as_k4);Integer	li_pos, li_p3, li_p4, li_len

li_pos = of_get_key(as_parm, as_k1, as_k2, as_k3)
	
li_p3 = li_pos + len(as_k3) + 1
li_p4 = pos(as_parm, '|', li_p3 + 1)

IF li_p4 < li_p3 THEN
	as_k4 = Mid(as_parm, li_p3 + 1)
ELSE
	li_len = li_p4 - li_p3 - 1
	as_k4 = Mid(as_parm, li_p3 + 1, li_len)
END IF

RETURN li_p3


end function

public function long of_recreate_child (long al_handle);long 		ll_rows, ll_child,  ll_rc
Integer	li_next
Any    	la_parm
Treeviewitem ltvi_current


li_next = of_get_Item_level(al_handle) + 1

ll_rc = THIS.GetItem(al_handle, ltvi_Current)

IF ll_rc = -1 THEN RETURN ll_rc

// eliminar items
THIS.CollapseItem(al_handle)              // colapsar items
ll_Child = THIS.FindItem(ChildTreeItem!, al_handle)

DO WHILE ll_Child <> -1
  	THIS.DeleteItem ( ll_Child )
  	ll_Child = THIS.FindItem(ChildTreeItem!, al_handle)
LOOP

// cargar items
la_parm = ltvi_Current.Data
ids_Data.Reset()
ll_Rows = ids_Data.Retrieve(la_parm)
THIS.Event ue_item_add(al_handle, li_next, ll_Rows)
THIS.ExpandItem(al_handle)               // expandir items

RETURN 1
end function

public function long of_get_item_level (long al_handle);Integer			li_level
TreeViewItem	ltvi_Target

li_level = GetItem(al_handle, ltvi_Target)

IF li_level = 1 THEN
	li_level = ltvi_Target.level
END IF

RETURN li_level
end function

public subroutine of_clear ();long 		ll_rows, ll_child,  ll_rc, ll_handle
Integer	li_next
Any    	la_parm
Treeviewitem ltvi_current

ll_handle = THIS.FindItem(RootTreeItem!, 0)
ll_rc = THIS.DeleteItem(ll_handle)

end subroutine

public subroutine of_set_dataobject (string as_dataobject);is_dataobject = as_dataobject
end subroutine

event itempopulate;// Poblar el arbol con sus hijos
Integer			li_next
Long				ll_rows
Any				la_parm
TreeViewItem	ltvi_nivel

SetPointer(HourGlass!)

THIS.GetItem(handle, ltvi_nivel)
li_next = ltvi_nivel.Level + 1       // Determinar el nivel siguiente

la_parm = ltvi_nivel.Data            // Determinar los argumentos de lectura

ll_Rows = ids_Data.Retrieve(la_parm)

THIS.Event ue_item_add(handle, li_next, ll_Rows)

end event

event selectionchanged;Integer			li_nivel
Any				la_parm
TreeViewItem	ltvi_item

il_handle = newhandle		// handle del item señalado
// Determinar el nivel
THIS.GetItem(newhandle, ltvi_item)
li_nivel = ltvi_item.Level

il_active[li_nivel] = il_handle   // guardar el handle activo de acuerdo al nivel

// Determinar los argumentos de lectura
la_parm = ltvi_item.Data

THIS.Event ue_selectionchanged_pre()

THIS.Event ue_output(li_nivel,la_parm)


end event

on u_tv_estructura.create
end on

on u_tv_estructura.destroy
end on

