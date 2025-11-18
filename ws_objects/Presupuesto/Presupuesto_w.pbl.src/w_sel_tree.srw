$PBExportHeader$w_sel_tree.srw
forward
global type w_sel_tree from w_abc
end type
type cb_1 from commandbutton within w_sel_tree
end type
type sle_1 from singlelineedit within w_sel_tree
end type
type st_1 from statictext within w_sel_tree
end type
type tv_1 from treeview within w_sel_tree
end type
end forward

global type w_sel_tree from w_abc
integer width = 1659
integer height = 1944
string menuname = "m_mantenimiento_sl"
event ue_populate ( )
event ue_save ( )
cb_1 cb_1
sle_1 sle_1
st_1 st_1
tv_1 tv_1
end type
global w_sel_tree w_sel_tree

type variables
DataStore		ids_Data[4], ids_buscar
String is_data[4], is_cnta
Long		il_handle, il_nivel = 1  
end variables

forward prototypes
public function integer of_add_items (long al_parent, integer ai_level, integer ai_rows)
public subroutine of_set_item (integer ai_level, integer ai_row, ref treeviewitem atvi_new)
end prototypes

event ue_populate();Integer	li_Rows

SetPointer(HourGlass!)
This.SetRedraw(False)

ids_Data[1].Reset()
li_Rows = ids_Data[1].Retrieve()

This.SetRedraw(True)

// Add the items to the TreeView
of_add_items(0, 1, li_Rows)
end event

public function integer of_add_items (long al_parent, integer ai_level, integer ai_rows);// Function to add the items to the TreeView using the data in the DataStore

Integer				li_Cnt
TreeViewItem		ltvi_New

// Add each item to the TreeView
For li_Cnt = 1 To ai_Rows
	// Call a function to set the values of the TreeView item from 
	// the DataStore data
	of_set_item(ai_Level, li_Cnt, ltvi_New)
	
	// Add the item after the last child
	If tv_1.InsertItemLast(al_Parent, ltvi_New) < 1 Then
		// Error
		MessageBox("Error", "Error inserting item", Exclamation!)
		Return -1
	End If
Next

Return ai_Rows
end function

public subroutine of_set_item (integer ai_level, integer ai_row, ref treeviewitem atvi_new);// Set the Lable and Data attributes for the new item from the data in the DataStore

Integer	li_Picture
Choose Case ai_Level
   Case 1
		atvi_New.Label = "[" + TRIM( ids_Data[1].Object.niv1[ai_Row] )+ "] " + &
									TRIM( ids_Data[1].Object.descripcion[ai_Row])
		atvi_New.Data = ids_Data[1].Object.niv1[ai_Row]
	Case 2
		atvi_New.Label = "[" + TRIM( ids_Data[2].Object.niv2[ai_Row]) + "] " + &
   						  TRIM( ids_Data[2].Object.descripcion[ai_Row])
		atvi_New.Data = ids_Data[2].Object.niv1[ai_Row] + ',' + &
		  					 ids_Data[2].Object.niv2[ai_Row]
	Case 3
		atvi_New.Label = "[" + TRIM( ids_Data[3].Object.niv3[ai_Row]) + "] " + &
   						  TRIM( ids_Data[3].Object.descripcion[ai_Row]	)
		atvi_New.Data = ids_Data[3].Object.niv1[ai_Row] + ',' + &
		  					 ids_Data[3].Object.niv2[ai_Row] + ',' + &
							 ids_Data[3].Object.niv3[ai_Row]
	Case 4
		atvi_New.Label = "[" + TRIM( ids_Data[4].Object.cnta_prsp[ai_Row]) + "] " + &							  
   						  TRIM( ids_Data[4].Object.descripcion[ai_Row])
		atvi_New.Data = ids_Data[4].Object.cnta_prsp[ai_Row] 

/*
   Case 1
		atvi_New.Label = TRIM( ids_Data[1].Object.descripcion[ai_Row])
		atvi_New.Data  = ids_Data[1].Object.niv1[ai_Row]
	Case 2
		atvi_New.Label = TRIM( ids_Data[2].Object.descripcion[ai_Row])
		atvi_New.Data  = ids_Data[2].Object.niv2[ai_Row]
	Case 3
		atvi_New.Label = TRIM( ids_Data[3].Object.descripcion[ai_Row]	)
		atvi_New.Data  = ids_Data[3].Object.niv3[ai_Row]
	Case 4
		atvi_New.Label = TRIM( ids_Data[4].Object.descripcion[ai_Row])
		atvi_New.Data  = ids_Data[4].Object.cnta_prsp[ai_Row]
		
   Case 1
		atvi_New.Label = "[" + TRIM( ids_Data[1].Object.niv1[ai_Row] )+ "] " + &
									TRIM( ids_Data[1].Object.descripcion[ai_Row])
		atvi_New.Data = ids_Data[1].Object.niv1[ai_Row]
	Case 2
		atvi_New.Label = "[" + TRIM( ids_Data[2].Object.niv1[ai_Row]) + &
							  TRIM( ids_Data[2].Object.niv2[ai_Row]) + "] " + &
   						  TRIM( ids_Data[2].Object.descripcion[ai_Row])
		atvi_New.Data = ids_Data[2].Object.niv2[ai_Row]
	Case 3
		atvi_New.Label = "[" + TRIM( ids_Data[3].Object.niv1[ai_Row] )+  &
							  TRIM( ids_Data[3].Object.niv2[ai_Row]) +  &
							  TRIM( ids_Data[3].Object.niv3[ai_Row]) + "] " + &
   						  TRIM( ids_Data[3].Object.descripcion[ai_Row]	)
		atvi_New.Data = ids_Data[3].Object.niv3[ai_Row]
	Case 4
		atvi_New.Label = "[" + TRIM( ids_Data[4].Object.cnta_prsp[ai_Row]) + "] " + &							  
   						  TRIM( ids_Data[4].Object.descripcion[ai_Row])
		atvi_New.Data = ids_Data[4].Object.cnta_prsp[ai_Row] */
End Choose

If ai_Level < 4 Then
	atvi_New.Children = True
	atvi_New.PictureIndex = ai_Level 
	atvi_New.SelectedPictureIndex = 4
Else
	atvi_New.Children = False	
	// Set the picture to be the product picture	
//	li_Picture = tv_1.AddPicture(ids_Data[4].Object.cnta_prsp[ai_Row])
	atvi_New.PictureIndex = 4  //li_Picture
	atvi_New.SelectedPictureIndex = 4
End If
end subroutine

on w_sel_tree.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.cb_1=create cb_1
this.sle_1=create sle_1
this.st_1=create st_1
this.tv_1=create tv_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.tv_1
end on

on w_sel_tree.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.tv_1)
end on

event close;call super::close;Integer	li_Cnt

// Destroy DataStores used by this example
For li_Cnt = 1 To 4
	Destroy ids_Data[li_Cnt]
Next



end event

event ue_open_pre();Integer	li_Cnt
String lds[]

SetPointer(HourGlass!)
// Set DataWindow objects in array
lds[1] = 'd_abc_presupuesto_cuenta_n1'
lds[2] = 'd_abc_presupuesto_cuenta_n2'
lds[3] = 'd_abc_presupuesto_cuenta_n3'
lds[4] = 'd_sel_presupuesto_cuenta'

// Create DataStores used by this example
For li_Cnt = 1 To 4
	ids_Data[li_Cnt] = Create DataStore
	ids_Data[li_Cnt].DataObject = lds[li_Cnt]  //.DataObject
	ids_Data[li_Cnt].SetTransObject(sqlca)
Next

LONG ll_row
// Datastore para busqueda
ids_buscar = Create DataStore
ids_buscar.dataobject = "d_abc_presupuesto_cuenta"
ids_buscar.SettransObject( sqlca)
ll_row = ids_buscar.retrieve()

// Populate first level
Post Event ue_populate()
end event

event resize;call super::resize;tv_1.height = newheight - tv_1.y - 10
tv_1.width = newwidth - tv_1.x - 10
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

type cb_1 from commandbutton within w_sel_tree
integer x = 1362
integer y = 44
integer width = 238
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Buscar"
end type

event clicked;// busca por descripcion
String ls_des
long ll_found

ls_des = TRIM( sle_1.text)

ll_found = ids_buscar.Find( "MID( descripcion,1," + & 
    STRING( len( ls_des)) + ") = '" + ls_des + "'", 1, &
	 ids_buscar.RowCount())
if ll_found = 0 then
	messagebox("no encontrado", '')
else
//	messagebox("encontrado", '')
	long ll_tvi

ll_tvi = tv_1.FindItem(Parenttreeitem!, 0)


tv_1.ExpandItem(ll_tvi)
tv_1.SelectItem(ll_tvi)
	
//	tv_1.post event itemexpanding()
//Long    ll_oper_prog,ll_row
//Integer li_nivel
//TreeViewItem	ltvi_item
//String  ls_data
//
//// Determinar el nivel
//tv_1.GetItem(handle, ltvi_item)
//li_nivel = ltvi_item.Level
//
//
//IF li_nivel = 4 THEN
//	ll_row = ids_data[5].rowcount()	
//	
////		ii_nro_oper = ll_oper_prog
////		ls_data = is_corr_corte+'|'+Trim(String(ii_nro_oper))
////		//Busqueda de Item en TreeView
////	   Parent.Post Event ue_find(ls_data)	
//END IF 
end if
end event

type sle_1 from singlelineedit within w_sel_tree
integer x = 352
integer y = 44
integer width = 946
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sel_tree
integer x = 69
integer y = 60
integer width = 279
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Descripcion:"
boolean focusrectangle = false
end type

type tv_1 from treeview within w_sel_tree
integer y = 188
integer width = 1582
integer height = 1440
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 41943040
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
long picturemaskcolor = 12632256
long statepicturemaskcolor = 12632256
end type

event constructor;// Add the pictures to be used.
// This is done in this script rather than the painter to allow the
// picture size to be set.  Otherwise it gets set to be equal to the
// size of the first picture added.

This.PictureHeight = 15
This.PictureWidth = 16

//This.AddPicture("emp.ico")
//This.AddPicture("Library!")
//This.AddPicture("DosEdit!")
//This.AddPicture("Custom050!")
This.AddPicture("custom039!")
This.AddPicture("custom039!")
This.AddPicture("custom039!")
This.AddPicture("custom050!")
This.AddStatePicture("custom050!")
end event

event itempopulate;// Populate the tree with this item's children

Integer				li_Level, li_Rows 
TreeViewItem		ltvi_Current

SetPointer(HourGlass!)

// Determine the level
GetItem(handle, ltvi_Current)
li_Level = ltvi_Current.Level + 1

// Retrieve the data
ids_Data[li_Level].Reset()
CHOOSE CASE li_level
	CASE 2,5
		li_rows = ids_Data[li_Level].Retrieve(ltvi_current.data)
	CASE 3
		li_rows = ids_Data[li_Level].Retrieve(left( ltvi_current.data,2), &
		  Mid( ltvi_current.data,4,2))	
	CASE 4
		li_rows = ids_Data[li_Level].Retrieve(left( ltvi_current.data,2), &
		  Mid( ltvi_current.data,4,2), Right( ltvi_current.data,2))
END CHOOSE
of_add_items(handle, li_Level, li_Rows)
end event

event itemexpanding;Long    ll_oper_prog,ll_row
Integer li_nivel
TreeViewItem	ltvi_item
String  ls_data

// Determinar el nivel
THIS.GetItem(handle, ltvi_item)
li_nivel = ltvi_item.Level

IF li_nivel = 4 THEN
//	messagebox( "nivel 4", '')
	ll_row = ids_data[5].rowcount()	
	
//		ii_nro_oper = ll_oper_prog
//		ls_data = is_corr_corte+'|'+Trim(String(ii_nro_oper))
//		//Busqueda de Item en TreeView
//	   Parent.Post Event ue_find(ls_data)	
END IF
end event

