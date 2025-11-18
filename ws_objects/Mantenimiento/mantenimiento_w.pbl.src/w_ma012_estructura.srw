$PBExportHeader$w_ma012_estructura.srw
forward
global type w_ma012_estructura from w_abc
end type
type uo_basket from u_cst_basket within w_ma012_estructura
end type
type cb_colapse from commandbutton within w_ma012_estructura
end type
type cb_expand from commandbutton within w_ma012_estructura
end type
type tv_estructura from u_tv_estructura within w_ma012_estructura
end type
type dw_list from u_dw_list_tbl within w_ma012_estructura
end type
end forward

global type w_ma012_estructura from w_abc
integer width = 3799
integer height = 2260
string title = "Estructura de Articulos (MA012)"
string menuname = "m_abc_prc"
uo_basket uo_basket
cb_colapse cb_colapse
cb_expand cb_expand
tv_estructura tv_estructura
dw_list dw_list
end type
global w_ma012_estructura w_ma012_estructura

type variables
String	is_padre, is_articulo, is_descripcion
Long		il_xhandle, il_rama
end variables

on w_ma012_estructura.create
int iCurrent
call super::create
if this.MenuName = "m_abc_prc" then this.MenuID = create m_abc_prc
this.uo_basket=create uo_basket
this.cb_colapse=create cb_colapse
this.cb_expand=create cb_expand
this.tv_estructura=create tv_estructura
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_basket
this.Control[iCurrent+2]=this.cb_colapse
this.Control[iCurrent+3]=this.cb_expand
this.Control[iCurrent+4]=this.tv_estructura
this.Control[iCurrent+5]=this.dw_list
end on

on w_ma012_estructura.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_basket)
destroy(this.cb_colapse)
destroy(this.cb_expand)
destroy(this.tv_estructura)
destroy(this.dw_list)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
dw_list.SetTransObject(sqlca)
SetPointer(hourglass!)
dw_list.Retrieve()	

tv_estructura.EVENT ue_open_pre()

//uo_basket.of_set_dragobject(tv_estructura)

of_position_window(0,0)    

// Help
ii_help = 16    

end event

event resize;call super::resize;tv_estructura.width  = newwidth  - tv_estructura.x - 10
tv_estructura.height = newheight - tv_estructura.y - 10
dw_list.height  		= newheight  - dw_list.y - 10

end event

type uo_basket from u_cst_basket within w_ma012_estructura
integer x = 1687
integer y = 940
integer taborder = 50
end type

on uo_basket.destroy
call u_cst_basket::destroy
end on

event dragdrop;call super::dragdrop;this.of_efecto_visual()
end event

type cb_colapse from commandbutton within w_ma012_estructura
integer x = 1701
integer y = 224
integer width = 288
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Colapsar"
end type

event clicked;tv_estructura.CollapseItem(1)
end event

type cb_expand from commandbutton within w_ma012_estructura
integer x = 1701
integer y = 28
integer width = 283
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Expandir"
end type

event clicked;tv_estructura.ExpandAll(1)
end event

type tv_estructura from u_tv_estructura within w_ma012_estructura
integer x = 2025
integer y = 20
integer width = 1714
integer height = 2036
integer taborder = 20
integer textsize = -8
boolean disabledragdrop = false
end type

event dragdrop;If DraggedObject() = THIS THEN RETURN	  // si el drag no ha sido del otro datawindow

treeviewitem	ltvi_item, ltvi_padre
Long				ll_handle
Double			ldb_cantidad
 
//Parametros del Target item 
THIS.GetItem (handle, ltvi_padre)
is_padre = ltvi_padre.data

Open(w_estructura_pop_preg)
ldb_cantidad = Message.DoubleParm

// Insertar Registro en TAbla Estructura
    INSERT INTO "articulo_estructura" ( "ARTICULO_PADRE", "ARTICULO_HIJO", "CANTIDAD" )  
    VALUES ( :is_padre, :is_articulo, :ldb_cantidad )  ;

// Insertar en Arbol
IF SQLCA.SQLCODE = 0 THEN
	Commit ;
	IF THIS.finditem(ChildTreeItem!, handle) > 1 THEN
		ltvi_item.PictureIndex = 1
		ltvi_item.selectedpictureindex = 2
		ltvi_item.Children = TRUE 
		ltvi_item.Label = is_descripcion + "(" + String(ldb_cantidad) + ")"
		ltvi_item.data  = is_articulo 
		ll_handle = THIS.InsertItemFirst(handle, ltvi_item)
	ELSE
		THIS.ExpandItem(handle)
	END IF
ELSE
	Rollback ;
END IF

THIS.drag(End!)
end event

event dragwithin;call super::dragwithin;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
end event

event begindrag;TreeViewItem		ltvi_item
Long		ll_handle

il_rama = handle
This.GetItem(handle, ltvi_item)

is_articulo = ltvi_item.data
uo_basket.idragobject = this
// Iniciar el Drag and drop
this.DragIcon = 'h:\source\ico\row3.ico'

this.drag(begin!)



end event

type dw_list from u_dw_list_tbl within w_ma012_estructura
integer x = 27
integer y = 20
integer width = 1637
integer height = 2036
string dragicon = "H:\Source\Ico\row2.ico"
string dataobject = "d_articulo_tbl"
end type

event clicked;call super::clicked;If row = 0 or is_padre = '' then Return	// si el click no ha sido a un registro retorna
long ll_row

// Iniciar el Drag and drop
//this.DragIcon = 'H:\Source\ICO\row2.ico'
this.drag(begin!)

// Conseguir la llave del registro
if row > 0 then
	is_articulo = this.GetItemString(row, 'cod_art')
	is_descripcion = this.GetItemString(row, 'nom_articulo')
else
	MessageBox('Error No existe el articulo', row)
end if

end event

event doubleclicked;call super::doubleclicked;If row = 0 then Return  		// si el click no ha sido a un registro retorna


is_padre = this.GetItemString(row, "cod_art")
is_descripcion = this.GetItemString(row, "nom_articulo")	
tv_estructura.of_clear()
tv_estructura.EVENT ue_populate(is_padre, is_descripcion)


end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

