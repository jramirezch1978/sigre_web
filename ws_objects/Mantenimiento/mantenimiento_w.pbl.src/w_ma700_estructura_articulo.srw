$PBExportHeader$w_ma700_estructura_articulo.srw
forward
global type w_ma700_estructura_articulo from w_rpt
end type
type dw_rpt from u_dw_rpt within w_ma700_estructura_articulo
end type
type htb_1 from u_htb_rpt within w_ma700_estructura_articulo
end type
type tv_estructura from u_tv_estructura within w_ma700_estructura_articulo
end type
type dw_list from u_dw_list_tbl within w_ma700_estructura_articulo
end type
end forward

global type w_ma700_estructura_articulo from w_rpt
integer width = 3026
integer height = 2124
string title = "Reporte de Estructuras (MA700)"
string menuname = "m_rpt_smpl"
event ue_create_report ( )
dw_rpt dw_rpt
htb_1 htb_1
tv_estructura tv_estructura
dw_list dw_list
end type
global w_ma700_estructura_articulo w_ma700_estructura_articulo

type variables
String	is_padre, is_articulo, is_descripcion
Long		il_handle, il_del_handle
end variables

event ue_create_report();String			ls_articulo[], ls_nombre[], ls_temp, ls_indent
Integer			li_nivel[], li_x = 1, li_y = 1, li_pos, li_pos2
Long				ll_handle, ll_row
TreeviewItem	ltvi_item

dw_rpt.Reset()
tv_estructura.ExpandAll(1)
ll_handle = tv_estructura.FindItem(RootTreeItem!, 0)

DO WHILE ll_handle > 0
	tv_estructura.GetItem (ll_handle, ltvi_item)
	ll_row = dw_rpt.InsertRow(0)
	dw_rpt.SetItem(ll_row, 'codigo', ltvi_item.Data)
	dw_rpt.SetItem(ll_row, 'nivel', ltvi_item.Level)
	ls_indent = Fill('-', (ltvi_item.Level -1) * 2)
	IF ll_handle = 1 THEN
		dw_rpt.SetItem(ll_row, 'nombre', ltvi_item.Label)
	ELSE
		li_pos  = POS(ltvi_item.label, '(')
		li_pos2 = POS(ltvi_item.label, ')')
		ls_temp =Mid(ltvi_item.Label, li_pos +1, li_pos2 - li_pos -1)
		dw_rpt.SetItem(ll_row, 'nombre', ls_indent + Left(ltvi_item.Label, li_pos - 2))
		dw_rpt.SetItem(ll_row, 'cantidad', Integer(ls_temp))
	END IF
	ll_handle = tv_estructura.FindItem(NextVisibleTreeItem!, ll_handle)
LOOP

end event

on w_ma700_estructura_articulo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_rpt=create dw_rpt
this.htb_1=create htb_1
this.tv_estructura=create tv_estructura
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rpt
this.Control[iCurrent+2]=this.htb_1
this.Control[iCurrent+3]=this.tv_estructura
this.Control[iCurrent+4]=this.dw_list
end on

on w_ma700_estructura_articulo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rpt)
destroy(this.htb_1)
destroy(this.tv_estructura)
destroy(this.dw_list)
end on

event ue_open_pre();call super::ue_open_pre;of_position(0,0)
dw_list.SetTransObject(sqlca)
//Help
ii_help = 700

//idw_1 = dw_rpt
SetPointer(hourglass!)

dw_list.Retrieve()	

tv_estructura.EVENT ue_open_pre()
idw_1 = dw_rpt
idw_1.Object.p_logo.filename = gs_logo

end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_rpt.width  = newwidth  - dw_rpt.x
dw_rpt.height = newheight - dw_rpt.y
dw_list.height = newheight - dw_list.y
end event

type dw_rpt from u_dw_rpt within w_ma700_estructura_articulo
integer x = 1033
integer y = 152
integer width = 1920
integer height = 1728
integer taborder = 30
string dataobject = "d_estructura_ext"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type htb_1 from u_htb_rpt within w_ma700_estructura_articulo
integer x = 1038
integer y = 28
integer width = 1920
integer height = 96
end type

event constructor;call super::constructor;idw_report = dw_rpt
end event

type tv_estructura from u_tv_estructura within w_ma700_estructura_articulo
integer x = 1070
integer y = 244
integer width = 421
integer height = 240
integer taborder = 20
boolean disabledragdrop = false
end type

event clicked;call super::clicked;// lectura de datos del articulo y su detalle
IF handle < 1 THEN RETURN

treeviewitem	ltvi_item
Long				ll_handle
String			ls_codigo
 
//Parametros del Target item 
THIS.GetItem (handle, ltvi_item)
ls_codigo = ltvi_item.data



end event

type dw_list from u_dw_list_tbl within w_ma700_estructura_articulo
integer x = 27
integer y = 20
integer width = 978
integer height = 1860
string dataobject = "d_articulo_tbl"
end type

event clicked;call super::clicked;If row = 0 then Return					// si el click no ha sido a un registro retorna
long ll_row

// Iniciar el Drag and drop
this.DragIcon = 'C:\Source\ICO\row2.ico'
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

Parent.Event ue_create_report()


end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

