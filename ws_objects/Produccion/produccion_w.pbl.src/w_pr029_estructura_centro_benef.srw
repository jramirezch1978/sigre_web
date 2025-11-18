$PBExportHeader$w_pr029_estructura_centro_benef.srw
forward
global type w_pr029_estructura_centro_benef from w_abc
end type
type cb_expand from commandbutton within w_pr029_estructura_centro_benef
end type
type cb_colapse from commandbutton within w_pr029_estructura_centro_benef
end type
type cb_refrescar from commandbutton within w_pr029_estructura_centro_benef
end type
type tv_estructura from u_tv_estructura within w_pr029_estructura_centro_benef
end type
type st_campo from statictext within w_pr029_estructura_centro_benef
end type
type dw_3 from datawindow within w_pr029_estructura_centro_benef
end type
type dw_list from u_dw_list_tbl within w_pr029_estructura_centro_benef
end type
type gb_1 from groupbox within w_pr029_estructura_centro_benef
end type
end forward

global type w_pr029_estructura_centro_benef from w_abc
integer width = 3835
integer height = 2152
string title = "Estructura de Centros de Beneficio[PR029]"
string menuname = "m_estructura_cebe"
event ue_modificar ( )
cb_expand cb_expand
cb_colapse cb_colapse
cb_refrescar cb_refrescar
tv_estructura tv_estructura
st_campo st_campo
dw_3 dw_3
dw_list dw_list
gb_1 gb_1
end type
global w_pr029_estructura_centro_benef w_pr029_estructura_centro_benef

type variables
String			is_padre, is_cod_cebe, is_desc_cebe, is_cebe_padre, is_old_padre, &
					is_col, is_tipo
Long				il_xhandle, il_rama, il_handl, il_DragSource, il_DragParent, il_DropTarget, il_icono
m_rbutton_tv  	im_tv

end variables

forward prototypes
public subroutine of_iconos ()
end prototypes

event ue_modificar();//Override
treeviewitem	ltvi_item, ltvi_padre
long				ll_handle, ll_count, ll_handle_hijo, ll_i, ll_cantidad
String			ls_mensaje, ls_padre, ls_hijo, ls_desc
DataWindow		ldw_list
u_ds_base 		lds_data
str_parametros 	lstr_param

if tv_estructura.FindItem (CurrentTreeItem!, 0) = -1 then 
	MessageBox('Aviso', 'No existe Item seleccionado')
	return
end if	

ll_handle_hijo = tv_estructura.FindItem (CurrentTreeItem!, 0)
if tv_estructura.GetItem (ll_handle_hijo, ltvi_item) = -1 then return
ls_hijo = ltvi_item.data
	
ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
ls_padre = ltvi_padre.data

lstr_param.string1 = ls_padre
lstr_param.string2 = ls_hijo

OpenWithParm(w_maq_estructura, lstr_param)

if IsNull(Message.PowerObjectParm) or &
	Not IsValid(Message.PowerObjectParm) then
	
	return
	
end if

lstr_param = Message.PowerObjectParm

if lstr_param.titulo = 'n' then return

ll_cantidad = lstr_param.ll_cantidad

select desc_centro
	into :ls_Desc
from centro_beneficio
where centro_benef = :ls_hijo;

ltvi_item.Label = ls_hijo + ' - ' + trim(ls_desc) + "(" + String(ll_cantidad) + ")"

tv_estructura.SetItem(ll_handle_hijo, ltvi_item)




end event

public subroutine of_iconos ();// Verifica estado de acceso
Long    ll_j, ll_total_iconos
String  ls_icono, ls_profile_ini

ls_profile_ini = "/pb_exe/mantenimiento.ini"

ll_total_iconos = Long(ProfileString(ls_profile_ini, "ICONOS", "TOTAL", "20"))

tv_estructura.DeletePictures()

For ll_j = 1 to ll_total_iconos
	 ls_icono  = ProfileString(ls_profile_ini, "ICONOS", string(ll_j), "")
	 
//	 MessageBox('', ls_icono)
	 //-- Iconos
	 If Trim(ls_icono) <> '' then
	 	 tv_estructura.AddPicture(ls_icono)
	 End if
	 
Next
end subroutine

on w_pr029_estructura_centro_benef.create
int iCurrent
call super::create
if this.MenuName = "m_estructura_cebe" then this.MenuID = create m_estructura_cebe
this.cb_expand=create cb_expand
this.cb_colapse=create cb_colapse
this.cb_refrescar=create cb_refrescar
this.tv_estructura=create tv_estructura
this.st_campo=create st_campo
this.dw_3=create dw_3
this.dw_list=create dw_list
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_expand
this.Control[iCurrent+2]=this.cb_colapse
this.Control[iCurrent+3]=this.cb_refrescar
this.Control[iCurrent+4]=this.tv_estructura
this.Control[iCurrent+5]=this.st_campo
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.gb_1
end on

on w_pr029_estructura_centro_benef.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_expand)
destroy(this.cb_colapse)
destroy(this.cb_refrescar)
destroy(this.tv_estructura)
destroy(this.st_campo)
destroy(this.dw_3)
destroy(this.dw_list)
destroy(this.gb_1)
end on

event resize;call super::resize;tv_estructura.width  = newwidth  - tv_estructura.x - 10
tv_estructura.height = newheight - tv_estructura.y - 10
dw_list.height  		= newheight  - dw_list.y - 10
end event

event ue_delete;//Override
treeviewitem	ltvi_item, ltvi_padre
long				ll_handle, ll_count, ll_handle_hijo, ll_i
String			ls_mensaje, ls_padre, ls_hijo
DataWindow		ldw_list
u_ds_base 		lds_data

//if il_handle = 0 or IsNull(il_handle) then return

if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return

if tv_estructura.FindItem (CurrentTreeItem!, 0) = -1 then 
	MessageBox('Aviso', 'No existe Item seleccionado')
	return
end if	

ll_handle_hijo = tv_estructura.FindItem (CurrentTreeItem!, 0)
if tv_estructura.GetItem (ll_handle_hijo, ltvi_item) = -1 then return
ls_hijo = ltvi_item.data
	
if tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) = -1 then 
	MessageBox('Aviso', 'No puede eliminar este item ya que es la RAIZ (ROOT)')
	return
end if	

if tv_estructura.FindItem (ChildTreeItem!, ll_handle_hijo) <> -1 then 
	// Si es un padre entonces debo borrar en casacada
	if MessageBox('Aviso', 'Desea usted hacer una eliminacion en cascada ?', &
			Question!, YesNo!, 2) = 1 then
		lds_data = create u_ds_base
		lds_data.DataObject = 'ds_estructura_tbl'
		lds_data.SetTransObject(SQLCA)
		lds_data.Retrieve(ls_hijo)
		
		for ll_i = 1 to lds_data.RowCount()
			ls_padre = lds_data.object.cenbef_padre[ll_i]
			ls_hijo 	= lds_data.object.cenbef_hijo	[ll_i]
			
			delete CENTRO_BENEF_PLANT_DISTR
			where cenbef_padre = :ls_padre
			  and cenbef_hijo  = :ls_hijo;
			
			if SQLCA.SQlCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error al eliminar item', ls_mensaje)
				return
			end if
			
			Commit;
		next
	else
		ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
		if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
		ls_padre = ltvi_padre.data
	
		delete CENTRO_BENEF_PLANT_DISTR
		where cenbef_padre = :ls_padre
		  and cenbef_hijo  = :ls_hijo;
		
		if SQLCA.SQlCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error al eliminar item', ls_mensaje)
			return
		end if
		
	end if
else

	ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
	if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
	ls_padre = ltvi_padre.data

	delete CENTRO_BENEF_PLANT_DISTR
	where cenbef_padre = :ls_padre
	  and cenbef_hijo  = :ls_hijo;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al eliminar item', ls_mensaje)
		return
	end if
	
end if	

commit;

tv_estructura.DeleteItem(ll_handle_hijo)
end event

event ue_open_pre;call super::ue_open_pre;dw_list.SetTransObject(sqlca)
SetPointer(hourglass!)
dw_list.Retrieve()	
im_tv = CREATE m_rButton_tv

tv_estructura.EVENT ue_open_pre()

this.of_iconos()

// Help
ii_help = 16
end event

event ue_popm;//Overrride
im_tv.PopMenu(ai_pointerx, ai_pointery)
end event

type cb_expand from commandbutton within w_pr029_estructura_centro_benef
integer x = 1769
integer y = 180
integer width = 288
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

type cb_colapse from commandbutton within w_pr029_estructura_centro_benef
integer x = 1774
integer y = 332
integer width = 288
integer height = 112
integer taborder = 30
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

type cb_refrescar from commandbutton within w_pr029_estructura_centro_benef
integer x = 1778
integer y = 484
integer width = 288
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refrescar"
end type

event clicked;dw_list.Retrieve()

parent.of_iconos()
end event

type tv_estructura from u_tv_estructura within w_pr029_estructura_centro_benef
event keydown pbm_tvnkeydown
integer x = 2139
integer y = 136
integer width = 1595
integer height = 1788
integer taborder = 20
integer textsize = -8
boolean disabledragdrop = false
string picturename[]
boolean righttoleft = true
end type

event keydown;treeviewitem	ltvi_item, ltvi_padre
long				ll_handle, ll_count, ll_handle_hijo
String			ls_mensaje, ls_padre, ls_hijo
DataWindow		ldw_list

if key <> KeyDElete! then return

parent.event dynamic ue_delete()

//if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return
//
//if THIS.FindItem (CurrentTreeItem!, 0) = -1 then 
//	MessageBox('Aviso', 'No existe Item seleccionado')
//	return
//end if	
//
//ll_handle_hijo = THIS.FindItem (CurrentTreeItem!, 0)
//if THIS.GetItem (ll_handle_hijo, ltvi_item) = -1 then return
//ls_hijo = ltvi_item.data
//	
//if THIS.FindItem (ParentTreeItem!, ll_handle_hijo) = -1 then 
//	MessageBox('Aviso', 'No puede eliminar este item ya que es el ROOT')
//	return
//end if	
//
//if THIS.FindItem (ChildTreeItem!, ll_handle_hijo) <> -1 then 
//	MessageBox('Aviso', 'No puede eliminar un padre')
//	return
//end if	
//
//ll_handle = THIS.FindItem (ParentTreeItem!, ll_handle_hijo) 
//if THIS.GetItem (ll_handle, ltvi_padre) = -1 then return
//ls_padre = ltvi_padre.data
//
//delete maq_estructura
//where maq_padre = :ls_padre
//  and maq_hijo  = :ls_hijo;
//
//if SQLCA.SQlCode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	MessageBox('Error al eliminar item', ls_mensaje)
//	return
//end if
//
//Commit;
//this.DeleteItem(ll_handle_hijo)
end event

event begindrag;TreeViewItem	ltvi_Source, ltvi_Parent
Long				ll_handle

if this.GetItem(handle, ltvi_Source) = -1 then return

// Make sure only employees are being dragged
If ltvi_Source.Level = 1 Then
	This.Drag(Cancel!)
Else
	// Save the handle of the item that is being dragged and its parent (department)
	this.Drag(Begin!)
	il_DragSource = handle
	il_DragParent = FindItem(ParentTreeItem!, handle)
	if this.GetItem(il_DragParent, ltvi_Parent) = -1 then return
	
	is_old_padre  = ltvi_Parent.Data
End If


end event

event clicked;call super::clicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
end event

event dragdrop;TreeViewItem	ltvi_Target, ltvi_Source, ltvi_Parent, ltvi_New, &
					ltvi_item, ltvi_padre
Long				ll_count, ll_cantidad, ll_NewItem, ll_icono
String			ls_mensaje, ls_cod_cebe, ls_desc_cebe, ls_padre, ls_hijo
DataWindow		ldw_list
datetime       ld_fecha_actual

il_DropTarget = handle					

If source = THIS THEN 
	
	If GetItem(il_DropTarget, ltvi_Target) = -1 Then Return
	If GetItem(il_DragSource, ltvi_Source) = -1 Then Return
	
	// Verify move
	if this.GetItem(il_DragParent, ltvi_Parent) = -1 then return
	If MessageBox("Transferencia", "Esta seguro de mover " + &
							ltvi_Source.Label + " de " + ltvi_Parent.label + " a " + ltvi_Target.label + &
							"?", Question!, YesNo!, 1) = 2 Then Return
	
	// Move the item
	ls_padre = ltvi_Target.Data
	ls_hijo	= ltvi_Source.Data
	
	// Valido no se duplico el padre con el hijo
	select count (*)
	  into :ll_count
	  from CENTRO_BENEF_PLANT_DISTR
	 where cenbef_padre 	= :ls_padre
	   and cenbef_hijo	= :is_cod_cebe;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Codigo de CentBenef hijo ya pertenece al Padre')
		return
	end if

	update CENTRO_BENEF_PLANT_DISTR
	   set cenbef_padre = :ls_padre
    where cenbef_hijo  = :is_old_padre
	   and cenbef_hijo  = :ls_hijo;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al momento de mover un CentBenef', ls_mensaje)
		RETURN
	end if
	
	// Valido que no exista referencia circular
	select count(*)
	  into :ll_count
	  from CENTRO_BENEF_PLANT_DISTR t
	 START WITH cenbef_padre = :is_padre
  CONNECT BY PRIOR cenbef_hijo = cenbef_padre;
		
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
		return
	end if
	
	commit;
	
	// First delete the first item from the TreeView
	this.DeleteItem(il_DragSource)
	
	// Insert the item under the proper parent
	SetNull(ltvi_Source.ItemHandle)
	ll_NewItem = this.InsertItemSort(il_DropTarget, ltvi_Source)
	
	/*  Turn off drop highlighting  */
	this.SetDropHighlight (0)
	
	// Select the new item
	this.SelectItem(ll_NewItem)

else
	
	ld_fecha_actual = f_fecha_actual()
	
	//Parametros del Target item 
	if THIS.GetItem (handle, ltvi_padre) = -1 then return
	ls_padre = ltvi_padre.data
	
	//Open(w_estructura_pop_preg)
	//if IsNull(Message.DoubleParm) or Message.DoubleParm = 0 then return
	
	ll_cantidad = 1
	
	// Insertar Registro en TAbla Estructura
	select count (*)
	 into :ll_count
	 from CENTRO_BENEF_PLANT_DISTR
	where cenbef_padre 	= :ls_padre
	  and cenbef_hijo		= :is_cod_cebe;
	  
	  	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Codigo de CentBenef hijo ya pertenece al Padre')
		return
	end if
	
	INSERT INTO CENTRO_BENEF_PLANT_DISTR ( 
		CENBEF_PADRE, CENBEF_HIJO, FEC_REGISTRO, COD_USR, RATIO )  
	VALUES ( 
		:ls_padre, :is_cod_cebe, :ld_fecha_actual, :gs_user, :ll_cantidad)  ;
	
	// Insertar en Arbol
	IF SQLCA.SQLCODE = 0 THEN
		select count(*) into :ll_count
		from CENTRO_BENEF_PLANT_DISTR
		START WITH cenbef_padre = :is_padre
		CONNECT BY PRIOR cenbef_hijo = cenbef_padre;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
			return
		end if
		
		Commit ;
		IF THIS.finditem(ChildTreeItem!, il_DropTarget) <> -1 THEN
			ltvi_item.PictureIndex = 1
			ltvi_item.selectedpictureindex = 1
			ltvi_item.Children = TRUE 
			ltvi_item.Label = is_cod_cebe + ' - ' + is_desc_cebe + "(" + String(ll_cantidad) + ")"
			ltvi_item.data  = is_cod_cebe 
			ll_NewItem = this.InsertItemSort(il_DropTarget, ltvi_item)
	
			/*  Turn off drop highlighting  */
			this.SetDropHighlight (0)
			
			// Select the new item
			this.SelectItem(ll_NewItem)

		ELSE
			THIS.ExpandItem(handle)
		END IF
	ELSE
		ls_mensaje = SQLCA.SQLErrText
		Rollback ;
		MessageBox('Aviso' + this.ClassName(), ls_mensaje) 
	END IF
	
	THIS.drag(End!)
end if	
end event

event dragwithin;call super::dragwithin;//TreeViewItem		ltvi_Over
//
//If GetItem(handle, ltvi_Over) = -1 Then
//	SetDropHighlight(0)
//	il_DropTarget = 0
//	Return
//End If
//
//if il_dragSource = 0 then 
//	// Proviene del DataWindow
//	SetDropHighlight(handle)
//	il_DropTarget = handle
//else
//	If handle <> il_DragParent Then
//		SetDropHighlight(handle)
//		il_DropTarget = handle
//	Else
//		SetDropHighlight(0)
//		il_DropTarget = 0
//	End If
//end if

//this.SetDropHighlight(0)
this.SetDropHighlight(handle)


end event

event itempopulate;//select maq_padre, maq_hijo, LEVEL from maq_estructura t
//START WITH maq_padre = '44010120'
//CONNECT BY PRIOR maq_hijo = maq_padre;

// Override
// Poblar el arbol con sus hijos
Integer			li_next
Long				ll_rows, ll_count
string			ls_padre, ls_mensaje
TreeViewItem	ltvi_nivel

SetPointer(HourGlass!)

THIS.GetItem(handle, ltvi_nivel)
li_next = ltvi_nivel.Level + 1       // Determinar el nivel siguiente

ls_padre = string(ltvi_nivel.Data)            // Determinar los argumentos de lectura

select count(*)
	into :ll_count
from CENTRO_BENEF_PLANT_DISTR t
START WITH cenbef_padre = :ls_padre
CONNECT BY PRIOR cenbef_hijo = cenbef_padre;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
	return
end if

ll_Rows = ids_Data.Retrieve(ls_padre)

THIS.Event ue_item_add(handle, li_next, ll_Rows)
end event

event rightclicked;call super::rightclicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
il_handle = handle
Parent.EVENT Post Dynamic ue_PopM(w_main.PointerX(), w_main.PointerY())
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'ds_cenbef_hijo'

ii_numkey = 1
end event

event ue_item_set;// Override
// Colocar el label y atributos para el nuevo item

Integer	li_Picture, li_max
string 	ls_cod_cebe, ls_desc
Integer	li_cantidad, li_icono

ls_cod_cebe		= trim(ids_Data.Object.cenbef_hijo		[ai_Row])
ls_desc			= trim(ids_Data.Object.desc_centro		[ai_Row])
li_cantidad		= Int(ids_Data.Object.ratio		      [ai_Row])

atvi_New.Label = ls_cod_cebe + ' - ' + ls_desc + " (" + String(li_cantidad, '###,##0') + ")"
atvi_New.Data  = ls_cod_cebe

atvi_New.Children = True

atvi_New.PictureIndex 			= li_icono
atvi_New.SelectedPictureIndex = li_icono 
end event

event ue_populate;// Override
Integer			li_Rows, li_cnt
Long				ll_handle
TreeViewItem	ltvi_Root
String			ls_root

SetPointer(HourGlass!)

// crear datastores para el treeview
ids_data = Create DataStore
ids_data.DataObject = is_dataobject
ids_data.SetTransObject(sqlca)
	
ltvi_Root.Label = string(aa_codigo) + ' - ' + as_descripcion
ltvi_Root.Data  = string(aa_codigo)
ltvi_Root.Children = True
ltvi_Root.PictureIndex 			 = il_icono
ltvi_Root.SelectedPictureIndex = il_icono
ll_handle = THIS.InsertItemLast(0, ltvi_Root)
end event

type st_campo from statictext within w_pr029_estructura_centro_benef
integer x = 32
integer y = 44
integer width = 599
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda :"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_pr029_estructura_centro_benef
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 699
integer y = 40
integer width = 1029
integer height = 80
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;//Send(Handle(this),256,9,Long(0,0))
dw_list.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_list.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_list.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_list.find(ls_comando, 1, dw_list.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_list.selectrow(0, false)
			dw_list.selectrow(ll_fila,true)
			dw_list.scrolltorow(ll_fila)
			this.Setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type dw_list from u_dw_list_tbl within w_pr029_estructura_centro_benef
integer x = 32
integer y = 144
integer width = 1687
integer height = 1788
string dragicon = "H:\Source\Ico\row2.ico"
string dataobject = "d_abc_estructura_centbenef_tbl"
end type

event clicked;call super::clicked;If row = 0 or is_padre = '' then Return	// si el click no ha sido a un registro retorna
long ll_row

// Iniciar el Drag and drop
//this.DragIcon = 'H:\Source\ICO\row2.ico'
this.drag(begin!)

// Conseguir la llave del registro
if row > 0 then
	is_cod_cebe	  = this.object.centro_benef  [row]
	is_desc_cebe  = this.object.desc_centro	[row]
	il_DragSource = 0
	il_DragParent = 0
	il_dropTarget = 0
else
	MessageBox('Error', 'No existen Centros de Beneficio')
end if

end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row, icoco

If row = 0 then 

	li_col 	 = this.GetColumn()
	ls_column = THIS.GetObjectAtPointer()
	
	li_pos = pos(upper(ls_column),'_T')
	
	IF li_pos > 0 THEN
		is_col  = UPPER( mid(ls_column,1,li_pos - 1) )	
		is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
		ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
		ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
		st_campo.text = "Orden: " + is_col
		dw_3.reset()
		dw_3.InsertRow(0)
		dw_3.SetFocus()
	END IF
else	
	is_padre 	 = trim(this.object.centro_benef 	[row])
	is_desc_cebe = trim(this.object.desc_centro	   [row])
	il_icono		 = 1
	
	tv_estructura.of_clear()
	tv_estructura.EVENT ue_populate(is_padre, is_desc_cebe)
end if

end event

type gb_1 from groupbox within w_pr029_estructura_centro_benef
integer x = 1746
integer y = 116
integer width = 347
integer height = 520
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

