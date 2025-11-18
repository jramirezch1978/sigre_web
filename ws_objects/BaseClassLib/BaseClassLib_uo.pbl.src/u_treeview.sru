$PBExportHeader$u_treeview.sru
$PBExportComments$treeview que se carga con datawindows
forward
global type u_treeview from treeview
end type
end forward

global type u_treeview from treeview
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
string picturename[] = {"Custom039!"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event ue_open_pre ( )
event ue_close_pos ( )
event type integer ue_item_add ( long al_handle,  integer ai_nivel,  integer ai_rows )
event ue_item_set ( integer ai_nivel,  integer ai_row,  ref treeviewitem atvi_new )
event ue_item_set_label ( ref treeviewitem atvi_new,  integer ai_row,  integer ai_nivel )
event ue_populate ( )
event ue_output ( integer ai_nivel,  any aa_parm )
event ue_constructor ( )
event ue_selectionchanged_pre ( )
end type
global u_treeview u_treeview

type variables
Datastore	ids_data[]
Integer     ii_numkey[]
String      is_dataobject[]
Long        il_handle, il_active[]
end variables

forward prototypes
public function integer of_selected_item_delete ()
public function long of_get_item_parent (long al_handle)
public function long of_get_item_previous (long al_handle)
public function long of_get_item_next (long al_handle)
public function long of_recreate_child (long al_handle)
public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2)
public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2, ref string as_k3)
public function integer of_get_key (string as_parm, ref string as_k1, ref string as_k2, ref string as_k3, ref string as_k4)
public function long of_get_item_level (long al_handle)
end prototypes

event ue_open_pre;// personalizar en herencia

//is_dataobject[1] = 'd_adm_tbl'
//is_dataobject[2] = 'd_zona_tbl'
//is_dataobject[3] = 'd_campo_tbl'
//is_dataobject[4] = 'd_correlativo_tbl'

//ii_numkey[1] = 1        // numero de campos que se guardan en el data de ese nivel
//ii_numkey[2] = 1
//ii_numkey[3] = 1
//ii_numkey[4] = 1






end event

event ue_close_pos;Integer	li_x

// Destruir DataStores
For li_x = 1 To UpperBound(ids_data)
	Destroy ids_data[li_x]
Next

end event

event ue_item_add;// Introducir los items al treeview

Integer				li_cnt
TreeViewItem		ltvi_new

For li_cnt = 1 To ai_Rows
	// colocar el label y data al treeview item
	THIS.Event ue_Item_set(ai_nivel, li_cnt, ltvi_new)
	
	If THIS.InsertItemLast(al_handle, ltvi_New) < 1 Then
		// Error
		MessageBox("Error", "Error al introducir el item")
		Return -1
	End If
Next

Return ai_Rows
end event

event ue_item_set;// Colocar el label y atributos para el nuevo item

Integer	li_Picture, li_max

li_max = UpperBound(ids_data)

THIS.Event ue_item_set_label(atvi_new,ai_row,ai_nivel)

If ai_nivel < li_max Then
	atvi_New.Children = True
Else
	atvi_New.Children = False
End if

atvi_New.PictureIndex = ai_nivel
atvi_New.SelectedPictureIndex = 10    //picture de abierto

end event

event ue_item_set_label;// personalizar en herencia

//Choose Case ai_nivel
//	Case 1
//		atvi_New.Label = ids_Data[1].Object.cod_adm[ai_Row] + ", " + &
//							  ids_Data[1].Object.desc_adm[ai_Row]
//		atvi_New.Data  = ids_Data[1].Object.cod_adm[ai_Row]
//	Case 2
//		atvi_New.Label = ids_Data[2].Object.cod_zona[ai_Row] + ", " + &
//							  ids_Data[2].Object.desc_zona[ai_Row]
//		atvi_New.Data  = ids_Data[2].Object.cod_zona[ai_Row]
//	Case 3
//		atvi_New.Label = ids_Data[3].Object.cod_campo[ai_Row] + ", " + &
//							  ids_Data[3].Object.desc_campo[ai_Row]
//		atvi_New.Data  = ids_Data[3].Object.cod_campo[ai_Row]
//	Case 4
//		atvi_New.Label = ids_Data[4].Object.corr_corte[ai_Row] + ", " + &
//							  String(ids_Data[4].Object.fec_inicio[ai_Row], 'dd/mm/yy')
//		atvi_New.Data  = ids_Data[4].Object.corr_corte[ai_Row]
//End Choose
end event

event ue_populate;Integer	li_Rows, li_cnt

SetPointer(HourGlass!)

// crear datastores para el treeview
For li_cnt = 1 To UpperBound(is_dataobject)
	ids_data[li_cnt] = Create DataStore
	ids_data[li_cnt].DataObject = is_dataobject[li_cnt]
	ids_data[li_cnt].SetTransObject(sqlca)
Next

// leer primer nivel
li_Rows = ids_Data[1].Retrieve()

THIS.Event ue_item_add(0, 1, li_Rows)

end event

event ue_output(integer ai_nivel, any aa_parm);//dw_master.Retrieve(aa_parm)
//dw_master.il_totdel = 0
//dw_detail.Retrieve(aa_parm)
//dw_detail.il_totdel = 0
end event

event ue_constructor;//This.PictureHeight = 15
//This.PictureWidth = 16
//
//This.AddPicture("Library5!")
//This.AddPicture("Picture1!")
//This.AddPicture("Environment!")
//This.AddPicture("Custom091!")
//This.AddStatePicture("Custom073!")
//
//This.AddPicture("Custom087!")
//This.AddPicture("Custom076!")
//This.AddPicture("Custom070!")
//This.AddPicture("Custom069!")
//This.AddStatePicture("Custom050!")
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
ids_Data[li_next].Reset()
ll_Rows = ids_Data[li_next].Retrieve(la_parm)
THIS.Event ue_item_add(al_handle, li_next, ll_Rows)
THIS.ExpandItem(al_handle)               // expandir items

RETURN 1
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

public function long of_get_item_level (long al_handle);Integer			li_level
TreeViewItem	ltvi_Target

li_level = GetItem(al_handle, ltvi_Target)

IF li_level = 1 THEN
	li_level = ltvi_Target.level
END IF

RETURN li_level
end function

event constructor;THIS.Event ue_constructor()

THIS.Event ue_open_pre()

THIS.Event ue_populate()
end event

event itempopulate;// Poblar el arbol con sus hijos
String         ls_k1, ls_k2, ls_k3, ls_k4
Integer			li_next,li_Rows, li_rc
Any				la_parm
TreeViewItem	ltvi_nivel

SetPointer(HourGlass!)

THIS.GetItem(handle, ltvi_nivel)
li_next = ltvi_nivel.Level + 1       // Determinar el nivel siguiente

la_parm = ltvi_nivel.Data            // Determinar los argumentos de lectura

// lectura de data
ids_Data[li_next].Reset()

CHOOSE CASE ii_numkey[ltvi_nivel.Level]
	CASE 1
		li_Rows = ids_Data[li_next].Retrieve(la_parm)
	CASE 2
		li_rc = of_get_key(la_parm, ls_k1, ls_k2)
		li_Rows = ids_Data[li_next].Retrieve(ls_k1, ls_k2)
	CASE 3
		li_rc = of_get_key(la_parm, ls_k1, ls_k2, ls_k3)
		li_Rows = ids_Data[li_next].Retrieve(ls_k1, ls_k2, ls_k3)
	CASE 4
		li_rc = of_get_key(la_parm, ls_k1, ls_k2, ls_k3, ls_k4)
		li_Rows = ids_Data[li_next].Retrieve(ls_k1, ls_k2, ls_k3, ls_k4)
	CASE ELSE
		MessageBox("Error", "Se ha violado el numero de llaves")
END CHOOSE

THIS.Event ue_item_add(handle, li_next, li_Rows)

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

on u_treeview.create
end on

on u_treeview.destroy
end on

