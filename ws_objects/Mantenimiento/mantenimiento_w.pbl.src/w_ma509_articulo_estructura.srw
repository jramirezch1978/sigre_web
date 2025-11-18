$PBExportHeader$w_ma509_articulo_estructura.srw
forward
global type w_ma509_articulo_estructura from w_cns
end type
type dw_artfile from datawindow within w_ma509_articulo_estructura
end type
type dw_proveedor from u_dw_cns within w_ma509_articulo_estructura
end type
type dw_articulo from u_dw_cns within w_ma509_articulo_estructura
end type
type cb_colapse from commandbutton within w_ma509_articulo_estructura
end type
type cb_expand from commandbutton within w_ma509_articulo_estructura
end type
type tv_estructura from u_tv_estructura within w_ma509_articulo_estructura
end type
type dw_list from u_dw_list_tbl within w_ma509_articulo_estructura
end type
end forward

global type w_ma509_articulo_estructura from w_cns
integer width = 3639
integer height = 2020
string title = "Estructura de Articulos (MA509) "
string menuname = "m_abc_prc"
dw_artfile dw_artfile
dw_proveedor dw_proveedor
dw_articulo dw_articulo
cb_colapse cb_colapse
cb_expand cb_expand
tv_estructura tv_estructura
dw_list dw_list
end type
global w_ma509_articulo_estructura w_ma509_articulo_estructura

type variables
String	is_padre, is_articulo, is_descripcion
Long		il_handle, il_del_handle
end variables

on w_ma509_articulo_estructura.create
int iCurrent
call super::create
if this.MenuName = "m_abc_prc" then this.MenuID = create m_abc_prc
this.dw_artfile=create dw_artfile
this.dw_proveedor=create dw_proveedor
this.dw_articulo=create dw_articulo
this.cb_colapse=create cb_colapse
this.cb_expand=create cb_expand
this.tv_estructura=create tv_estructura
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_artfile
this.Control[iCurrent+2]=this.dw_proveedor
this.Control[iCurrent+3]=this.dw_articulo
this.Control[iCurrent+4]=this.cb_colapse
this.Control[iCurrent+5]=this.cb_expand
this.Control[iCurrent+6]=this.tv_estructura
this.Control[iCurrent+7]=this.dw_list
end on

on w_ma509_articulo_estructura.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_artfile)
destroy(this.dw_proveedor)
destroy(this.dw_articulo)
destroy(this.cb_colapse)
destroy(this.cb_expand)
destroy(this.tv_estructura)
destroy(this.dw_list)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
//Help
ii_help = 509

dw_list.SetTransObject(sqlca)
dw_articulo.SetTransObject(sqlca)
dw_proveedor.SetTransObject(sqlca)

SetPointer(hourglass!)
dw_list.Retrieve()	

tv_estructura.EVENT ue_open_pre()
end event

type dw_artfile from datawindow within w_ma509_articulo_estructura
boolean visible = false
integer x = 649
integer y = 712
integer width = 1166
integer height = 864
integer taborder = 30
boolean titlebar = true
string dataobject = "d_articulo_file_imagen"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SettransObject(sqlca)

end event

type dw_proveedor from u_dw_cns within w_ma509_articulo_estructura
integer x = 1851
integer y = 1080
integer width = 1714
integer height = 724
integer taborder = 30
string dataobject = "d_articulo_x_proveedor_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_mastdet = 'd'
end event

type dw_articulo from u_dw_cns within w_ma509_articulo_estructura
integer x = 1851
integer y = 28
integer width = 1719
integer height = 1024
integer taborder = 30
string dataobject = "d_articulo_ff"
end type

event constructor;ii_ck[1] = 1
ii_dk[1] = 1
is_dwform = 'form'
is_mastdet = 'md'
end event

type cb_colapse from commandbutton within w_ma509_articulo_estructura
integer x = 1522
integer y = 12
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

type cb_expand from commandbutton within w_ma509_articulo_estructura
integer x = 1083
integer y = 16
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

type tv_estructura from u_tv_estructura within w_ma509_articulo_estructura
integer x = 1024
integer y = 140
integer width = 814
integer height = 1668
integer taborder = 20
boolean disabledragdrop = false
end type

event dragdrop;//If DraggedObject() = THIS THEN RETURN	  // si el drag no ha sido del otro datawindow
//
//treeviewitem	ltvi_nivel, ltvi_padre
//Long				ll_handle
//Double			ldb_cantidad
// 
////Parametros del Target item 
//THIS.GetItem (handle, ltvi_padre)
//is_padre = ltvi_padre.data
//
//Open(w_estructura_pop_preg)
//ldb_cantidad = Message.DoubleParm
//
//// Insertar Registro en TAbla Estructura
//  INSERT INTO "Estructura" ( "articulo_padre", "articulo_hijo", "cantidad" )  
//  						  VALUES ( :is_padre, :is_articulo, :ldb_cantidad )  ;
//
//// Insertar en Arbol
//IF SQLCA.SQLCODE = 0 THEN
//	Commit ;
//	IF THIS.finditem(ChildTreeItem!, handle) > 1 THEN
//		ltvi_nivel.PictureIndex = 1
//		ltvi_nivel.selectedpictureindex = 2
//		ltvi_nivel.Children = TRUE 
//		ltvi_nivel.Label = is_descripcion + "(" + String(ldb_cantidad) + ")"
//		ltvi_nivel.data  = is_articulo 
//		ll_handle = THIS.InsertItemFirst(handle, ltvi_nivel)
//	ELSE
//		THIS.ExpandItem(handle)
//	END IF
//ELSE
//	Rollback ;
//END IF
//
//THIS.drag(End!)
end event

event dragwithin;call super::dragwithin;//THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
end event

event begindrag;//TreeViewItem		ltvi_item
//Long		ll_handle
//
//il_del_handle = handle
//This.GetItem(handle, ltvi_item)
//is_articulo = ltvi_item.data
//
//// Iniciar el Drag and drop
//this.DragIcon = 'row3.ico'
//this.drag(begin!)



end event

event clicked;call super::clicked;// lectura de datos del articulo y su detalle
IF handle < 1 THEN RETURN

treeviewitem	ltvi_item
Long				ll_handle
String			ls_codigo,ls_file
 
//Parametros del Target item 
THIS.GetItem (handle, ltvi_item)
ls_codigo = ltvi_item.data

dw_articulo.Retrieve(ls_codigo)
dw_proveedor.Retrieve(ls_codigo)
dw_artfile.Retrieve(ls_codigo)
ls_file = dw_artfile.object.file_imagen[1]
IF Len(ls_file) > 0 THEN
	dw_artfile.Title = ls_codigo
	dw_artfile.Visible = True
ELSE
	dw_artfile.Visible = False
END IF

end event

type dw_list from u_dw_list_tbl within w_ma509_articulo_estructura
integer x = 27
integer y = 20
integer width = 978
integer height = 1788
string dataobject = "d_articulo_tbl"
end type

event clicked;call super::clicked;If row = 0 then Return					// si el click no ha sido a un registro retorna
long ll_row

// Iniciar el Drag and drop
this.DragIcon = '\Source\ICO\row2.ico'
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

