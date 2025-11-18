$PBExportHeader$w_pr026_estruct_cebe.srw
forward
global type w_pr026_estruct_cebe from w_abc
end type
type cb_1 from commandbutton within w_pr026_estruct_cebe
end type
type dw_3 from datawindow within w_pr026_estruct_cebe
end type
type st_campo from statictext within w_pr026_estruct_cebe
end type
type cb_colapse from commandbutton within w_pr026_estruct_cebe
end type
type cb_expand from commandbutton within w_pr026_estruct_cebe
end type
type tv_estructura from u_tv_estructura within w_pr026_estruct_cebe
end type
type dw_list from u_dw_list_tbl within w_pr026_estruct_cebe
end type
end forward

global type w_pr026_estruct_cebe from w_abc
integer width = 4009
integer height = 4124
string title = "Estructuras de Centro de Beneficio( PR026)"
string menuname = "m_salir"
event ue_modificar ( )
cb_1 cb_1
dw_3 dw_3
st_campo st_campo
cb_colapse cb_colapse
cb_expand cb_expand
tv_estructura tv_estructura
dw_list dw_list
end type
global w_pr026_estruct_cebe w_pr026_estruct_cebe

type variables
String			is_padre, is_old_padre, &
					is_col, is_tipo, is_nodo
String 			is_hijo, is_desc_centro, is_cen_bef			
Long				il_xhandle, il_rama, il_handl, il_DragSource, &
					il_DragParent, il_DropTarget
m_rbutton_tv  	im_tv
boolean			ib_move

end variables

event ue_modificar();//Override
treeviewitem	ltvi_item, ltvi_padre
long				ll_handle, ll_count, ll_handle_hijo, ll_i
String			ls_mensaje, ls_padre, ls_hijo, ls_usuario, ls_flag_fijo_var
DateTime			ldt_fecha
DataWindow		ldw_list
u_ds_base 		lds_data
Decimal			ldc_ratio
str_parametros	lstr_param

if tv_estructura.FindItem (CurrentTreeItem!, 0) = -1 then 
	MessageBox('Aviso', 'No existe Item seleccionado')
	return
end if	

ll_handle_hijo = tv_estructura.FindItem (CurrentTreeItem!, 0)
if tv_estructura.GetItem (ll_handle_hijo, ltvi_item) = -1 then return
ls_hijo = ltvi_item.data
	
if tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) = -1 then 
	MessageBox('Aviso', 'No puede modificar este item ya que es la RAIZ (ROOT)')
	return
end if	

// Si un hijo y no tiene descendientes, entonces simplemente lo borro
ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
ls_padre = ltvi_padre.data

// Elimino el item de la estructura
lstr_param.string1 = ls_padre
lstr_param.string2 = ls_hijo

OpenWithParm(w_estructura_pop_preg, lstr_param)

if IsNull(Message.Powerobjectparm) or &
	not isvalid(Message.PowerObjectParm) then return

lstr_param = Message.powerobjectparm
if lstr_param.titulo = 'n' then return

ldt_fecha  			= lstr_param.datetime1 
ls_usuario 			= lstr_param.string3 	
ldc_ratio  			= lstr_param.dec1		
ls_flag_fijo_var 	= lstr_param.string4	

//	Name          Type        Nullable Default Comments      
//	------------- ----------- -------- ------- ------------- 
//	CENBEF_PADRE  CHAR(12)                     CENBEF_PADRE  
//	CENBEF_HIJO   CHAR(12)                     CENBEF_HIJO   
//	FEC_REGISTRO  DATE        Y        sysdate FEC_REGISTRO  
//	COD_USR       CHAR(6)     Y                cod usuario   
//	RATIO         NUMBER(7,4) Y                RATIO         
//	FLAG_FIJO_VAR CHAR(1)     Y                flag_fijo_var 

// Inserto el registro en CENTRO_BENEF ESTRUCTURA
update CENTRO_BENEF_PLANT_DISTR 
	set ratio = :ldc_ratio,
		 flag_fijo_var = :ls_flag_fijo_var
 where cenbef_padre = :ls_padre
   and cenbef_hijo  = :ls_hijo;

IF SQLCA.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', 'Error al modificar registro en CENTRO_BENEF_PLANT_DISTR ' + ls_mensaje &
					+ char(13) + "OT PADRE " + ls_padre &
					+ char(13) + "OT HIJO "  + is_cen_bef)
	return
end if

// Grabo todos los cambios
commit;
end event

on w_pr026_estruct_cebe.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_1=create cb_1
this.dw_3=create dw_3
this.st_campo=create st_campo
this.cb_colapse=create cb_colapse
this.cb_expand=create cb_expand
this.tv_estructura=create tv_estructura
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.st_campo
this.Control[iCurrent+4]=this.cb_colapse
this.Control[iCurrent+5]=this.cb_expand
this.Control[iCurrent+6]=this.tv_estructura
this.Control[iCurrent+7]=this.dw_list
end on

on w_pr026_estruct_cebe.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_3)
destroy(this.st_campo)
destroy(this.cb_colapse)
destroy(this.cb_expand)
destroy(this.tv_estructura)
destroy(this.dw_list)
end on

event ue_open_pre;call super::ue_open_pre;dw_list.SetTransObject(sqlca)
SetPointer(hourglass!)
im_tv = CREATE m_rButton_tv

tv_estructura.EVENT ue_open_pre()

// Help
ii_help = 16    

end event

event resize;call super::resize;tv_estructura.width  = newwidth  - tv_estructura.x - 10
tv_estructura.height = newheight - tv_estructura.y - 10
dw_list.height  		= newheight  - dw_list.y - 10

end event

event ue_popm;//Overrride
im_tv.PopMenu(ai_pointerx, ai_pointery)
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
	// Si es un padre entonces pongo la opcion de borrar el cascada
	if MessageBox('Aviso', 'Desea usted hacer una eliminacion en cascada ?', &
			Question!, YesNo!, 2) = 1 then
		lds_data.DataObject = 'ds_cenbef_estruct'
		lds_data.SetTransObject( SQLCA )
		lds_data.Retrieve(ls_hijo)
		
		for ll_i = 1 to lds_data.RowCount()
			ls_padre = lds_data.object.cenbef_padre[ll_i]
			ls_hijo 	= lds_data.object.cenbef_hijo	[ll_i]
			
			// Eliminando de la Estructura de la OT
			delete CENTRO_BENEF_PLANT_DISTR
			where cenbef_padre = :ls_padre
			  and cenbef_hijo  = :ls_hijo;
			
			if SQLCA.SQlCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error al eliminar item', ls_mensaje)
				return
			end if
			
		next
		
	else
		
		ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
		if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
		ls_padre = ltvi_padre.data
	
		// Eliminando la estructura
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
	// Si un hijo y no tiene descendientes, entonces simplemente lo borro
	ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
	if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
	ls_padre = ltvi_padre.data
	
	// Elimino el item de la estructura
	delete CENTRO_BENEF_PLANT_DISTR
	where cenbef_padre = :ls_padre
	  and cebef_hijo  = :ls_hijo;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al eliminar item', ls_mensaje)
		return
	end if
	
end if	

// Grabo todos los cambios
commit;

tv_estructura.DeleteItem(ll_handle_hijo)
end event

type cb_1 from commandbutton within w_pr026_estruct_cebe
integer x = 1920
integer y = 8
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;dw_list.Retrieve(gs_user)	
end event

type dw_3 from datawindow within w_pr026_estruct_cebe
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 672
integer y = 16
integer width = 1029
integer height = 80
integer taborder = 30
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

type st_campo from statictext within w_pr026_estruct_cebe
integer x = 9
integer y = 20
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

type cb_colapse from commandbutton within w_pr026_estruct_cebe
integer x = 1778
integer y = 436
integer width = 320
integer height = 112
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Contraer"
end type

event clicked;tv_estructura.CollapseItem(1)
end event

type cb_expand from commandbutton within w_pr026_estruct_cebe
integer x = 1778
integer y = 284
integer width = 320
integer height = 112
integer taborder = 50
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

type tv_estructura from u_tv_estructura within w_pr026_estruct_cebe
event keydown pbm_tvnkeydown
integer x = 2094
integer y = 128
integer width = 1454
integer height = 1772
integer taborder = 80
integer textsize = -8
integer weight = 700
boolean disabledragdrop = false
string picturename[] = {"Application5!","Custom092!"}
end type

event keydown;treeviewitem	ltvi_item, ltvi_padre
long				ll_handle, ll_count, ll_handle_hijo
String			ls_mensaje, ls_padre, ls_hijo
DataWindow		ldw_list

if key <> KeyDElete! then return

parent.event dynamic ue_delete()
end event

event dragdrop;TreeViewItem	ltvi_Target, ltvi_Source, ltvi_Parent, ltvi_New, &
					ltvi_item, ltvi_padre
Long				ll_count, ll_NewItem
String			ls_mensaje, ls_padre, ls_hijo, ls_flag_estado, &
					ls_flag_fijo_var, ls_usuario
Decimal			ldc_ratio
DateTime			ldt_fecha
str_parametros	lstr_param

il_DropTarget = handle					

If source = THIS THEN 
	
	If GetItem(il_DropTarget, ltvi_Target) = -1 Then Return
	If GetItem(il_DragSource, ltvi_Source) = -1 Then Return
	
	// Verify move
	if this.GetItem(il_DragParent, ltvi_Parent) = -1 then return

	// Verifico antes de mover el Item
	ls_padre = trim(ltvi_Target.Data)
	ls_hijo	= trim(ltvi_Source.Data)
	
	// Valido no se duplico el padre con el hijo
	select count (*)
		into :ll_count
	from CENTRO_BENEF_PLANT_DISTR
	where cenbef_padre 	= :ls_padre
	  and cenbef_hijo		= :ls_hijo;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Centro de Beneficio hijo ya pertenece al Centro de Beneficio Padre')
		return
	end if
	
	// Lanzo la pregunta al usuario si desea mover el item
	If MessageBox("Transferencia", "Esta seguro de mover " + &
							ltvi_Source.Label + " de " + ltvi_Parent.label + " a " + ltvi_Target.label + &
							"?", Question!, YesNo!, 1) = 2 Then Return
	
	
	//Verifico que el centro de beneficio este activo
	select  NVL(flag_estado,'0')
		into :ls_flag_estado
	from centro_beneficio
	where centro_benef = :ls_padre;
	
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		MessageBox('Error', "Centro de Beneficio PADRE '" + ls_padre + "' no existe " )
		return
	end if

	if ls_flag_estado = '0' then
		ROLLBACK;
		MessageBox('Error', "Centro de Beneficio PADRE '" + ls_padre + "' se encuentra anulado")
		return
	end if

	// Actualizo la estructura de la OT
	update CENTRO_BENEF_PLANT_DISTR
	   set cenbef_padre = :ls_padre
    where cenbef_padre = :is_old_padre
	   and cenbef_hijo  = :ls_hijo;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al momento de mover el centro de beneficio ', ls_mensaje &
					 + char(13) + "CeBe PADRE: " + ls_padre &
					 + char(13) + "CeBe HIJO : " + ls_hijo)
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
	
	// Grabo los cambios
	commit;
	
	// First delete the first item from the TreeView
	this.DeleteItem(il_DragSource)
	
	// Insert the item under the proper parent
	SetNull(ltvi_Source.ItemHandle)
	
	this.SelectItem(il_DropTarget)
	
	/*  Turn off drop highlighting  */
	this.SetDropHighlight (0)
	
	ll_NewItem = this.InsertItemSort(il_DropTarget, ltvi_Source)

	// Select the new item
	ib_move = TRUE
	this.SelectItem(ll_NewItem)
	ib_move = FALSE
	
	//CAmbio la imagen de ser necesario
	// Verifico si es un padre o un nodo para ponerle la imagen correcta
	if this.GetItem(il_DragParent, ltvi_Parent) = -1 then return
		
	select count(*)
		into :ll_count
	from CENTRO_BENEF_PLANT_DISTR t
	START WITH cenbef_padre = :is_old_padre
	CONNECT BY PRIOR cenbef_hijo = cenbef_padre;
	
	if ll_count > 0 then  // es un nodo padre
		ltvi_Parent.PictureIndex = 1
		ltvi_Parent.selectedpictureindex = 1
	else
		ltvi_Parent.PictureIndex = 2
		ltvi_Parent.selectedpictureindex = 2
	end if
	
	//Grabos los cambios
	if this.Setitem( il_DragParent, ltvi_Parent ) = -1 then
		MessageBox('Aviso ltvi_Parent', 'Ha habido un error al momento de cambiar la imagen al padre')
		return
	end if
	
	//CAmbio la imagen de ser necesario
	// Verifico si es un padre o un nodo para ponerle la imagen correcta
	If GetItem(il_DropTarget, ltvi_Target) = -1 Then Return
		
	select count(*)
		into :ll_count
	from CENTRO_BENEF_PLANT_DISTR t
	START WITH cenbef_padre = :ls_padre
	CONNECT BY PRIOR cenbef_hijo = cenbef_padre;
	
	if ll_count > 0 then  // es un nodo padre
		ltvi_Target.PictureIndex = 1
		ltvi_Target.selectedpictureindex = 1
	else
		ltvi_Target.PictureIndex = 2
		ltvi_Target.selectedpictureindex = 2
	end if
	
	//Grabos los cambios
	if this.Setitem( il_DropTarget, ltvi_Target ) = -1 then
		MessageBox('Aviso ltvi_Target', 'Ha habido un error al momento de cambiar la imagen al padre')
		return
	end if


else
	
	//Parametros del Target item 
	if THIS.GetItem (handle, ltvi_padre) = -1 then return
	ls_padre = ltvi_padre.data
	
	//Verifico que el padre sea de tipo estructura
	select NVL(flag_estado,'0')
		into :ls_flag_estado
	from centro_beneficio
	where centro_benef = :ls_padre;
	
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		MessageBox('Error', "Centro de Beneficio PADRE '" + ls_padre + "' no existe " )
		return
	end if

	if ls_flag_estado = '0' then
		ROLLBACK;
		MessageBox('Error', "Nro de orden PADRE '" + ls_padre + "' se encuentra anulado")
		return
	end if

	// Insertar Registro en TAbla Estructura
	select count (*)
		into :ll_count
	from CENTRO_BENEF_PLANT_DISTR
	where cenbef_padre 	= :ls_padre
	  and cenbef_hijo		= :is_cen_bef;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Centro de Beneficio hijo ya pertenece al Padre')
		return
	end if

	//Debo obtener los datos que necesito
	lstr_param.string1 = ls_padre
	lstr_param.string2 = is_cen_bef
	
	OpenWithParm(w_estructura_pop_preg, lstr_param)
	
	if IsNull(Message.PowerObjectParm) or &
		Not isvalid(Message.PowerObjectParm) then return
		
	lstr_param = Message.PowerObjectparm
	
	if lstr_param.titulo = 'n' then return
	
	ldt_fecha  			= lstr_param.datetime1 
	ls_usuario 			= lstr_param.string3 	
	ldc_ratio  			= lstr_param.dec1		
	ls_flag_fijo_var 	= lstr_param.string4	

	//	Name          Type        Nullable Default Comments      
	//	------------- ----------- -------- ------- ------------- 
	//	CENBEF_PADRE  CHAR(12)                     CENBEF_PADRE  
	//	CENBEF_HIJO   CHAR(12)                     CENBEF_HIJO   
	//	FEC_REGISTRO  DATE        Y        sysdate FEC_REGISTRO  
	//	COD_USR       CHAR(6)     Y                cod usuario   
	//	RATIO         NUMBER(7,4) Y                RATIO         
	//	FLAG_FIJO_VAR CHAR(1)     Y                flag_fijo_var 

	// Inserto el registro en CENTRO_BENEF ESTRUCTURA
	INSERT INTO CENTRO_BENEF_PLANT_DISTR ( 
		cenbef_padre, cenbef_HIJO, fec_registro, cod_usr, ratio, flag_fijo_var)  
	VALUES ( 
		:ls_padre, :is_cen_bef, :ldt_fecha, :ls_usuario, :ldc_ratio, :ls_flag_fijo_var )  ;

	IF SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'Error al insertar registro en CENTRO_BENEF_PLANT_DISTR ' + ls_mensaje &
						+ char(13) + "OT PADRE " + ls_padre &
						+ char(13) + "OT HIJO "  + is_cen_bef)
		return
	end if
	
	// Insertar en Arbol
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

	// Verifico si es un padre o un nodo para ponerle la imagen correcta
	select count(*)
		into :ll_count
	from CENTRO_BENEF_PLANT_DISTR t
	START WITH cenbef_padre = :ls_padre
	CONNECT BY PRIOR cenbef_hijo = cenbef_padre;
	
	if ll_count > 0 then  // es un nodo padre
		ltvi_padre.PictureIndex = 1
		ltvi_padre.selectedpictureindex = 1
	else
		ltvi_padre.PictureIndex = 2
		ltvi_padre.selectedpictureindex = 2
	end if
	
	//Grabos los cambios
	if this.Setitem( handle, ltvi_padre ) = -1 then
		MessageBox('Aviso', 'Ha habido un error al momento de cambiar la imagen al padre')
		return
	end if
	
	//Grabo los cambios en la base de datos
	Commit ;
	
	IF THIS.finditem(ChildTreeItem!, il_DropTarget) <> -1 THEN
		select count(*)
			into :ll_count
		from CENTRO_BENEF_PLANT_DISTR t
		START WITH cenbef_padre = :is_cen_bef
		CONNECT BY PRIOR cenbef_hijo = cenbef_padre;

		if ll_count > 0 then  // es un nodo padre
			ltvi_item.PictureIndex = 1
			ltvi_item.selectedpictureindex = 1
		else
			ltvi_item.PictureIndex = 2
			ltvi_item.selectedpictureindex = 2
		end if
		
		ltvi_item.Children = TRUE 
		ltvi_item.Label = is_cen_bef + ' - ' + is_desc_centro 
		ltvi_item.data  = is_cen_bef
		ll_NewItem = this.InsertItemSort(il_DropTarget, ltvi_item)

		/*  Turn off drop highlighting  */
		this.SetDropHighlight (0)
		
		// Select the new item
		this.SelectItem(ll_NewItem)
	ELSE
		THIS.ExpandItem(handle)
	END IF
	
	THIS.drag(End!)
end if	
end event

event dragwithin;call super::dragwithin;this.SetDropHighlight(handle)
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

event ue_populate;// Override
Integer			li_Rows, li_cnt
Long				ll_handle, ll_count
TreeViewItem	ltvi_Root
String			ls_root, ls_mensaje, ls_codigo

SetPointer(HourGlass!)

// crear datastores para el treeview
ids_data = Create DataStore
ids_data.DataObject = is_dataobject
ids_data.SetTransObject(sqlca)
	
ltvi_Root.Label = string(aa_codigo) + ' - ' + as_descripcion
ltvi_Root.Data  = string(aa_codigo)
ltvi_Root.Children = True

ls_codigo = string(aa_codigo)

select count(*)
	into :ll_count
from CENTRO_BENEF_PLANT_DISTR t
START WITH cenbef_padre = :ls_codigo
CONNECT BY PRIOR cenbef_hijo = cenbef_padre;
	
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
	return
end if
	
if ll_count > 0 then
	ltvi_Root.PictureIndex 			 = 1
	ltvi_Root.SelectedPictureIndex = 1
else
	ltvi_Root.PictureIndex 			 = 2
	ltvi_Root.SelectedPictureIndex = 2
end if
ll_handle = THIS.InsertItemLast(0, ltvi_Root)
end event

event ue_item_set;// Override
// Colocar el label y atributos para el nuevo item

Integer	li_Picture, li_max
string 	ls_cenbef, ls_descripcion
Integer	li_cantidad, li_icono, li_count

ls_cenbef		= ids_Data.Object.cenbef_hijo		[ai_Row]
ls_descripcion	= ids_Data.Object.desc_centro		[ai_Row]

if IsNull(ls_descripcion) then ls_descripcion = ''

atvi_New.Label = ls_cenbef + ' - ' + ls_descripcion //+ " (" + ls_ot_adm + ")"
atvi_New.Data  = ls_cenbef

atvi_New.Children = True

select count(*)
	into :li_count
from CENTRO_BENEF_PLANT_DISTR t
START WITH cenbef_padre = :ls_cenbef
CONNECT BY PRIOR cenbef_hijo = cenbef_padre;

if li_count > 0 then
	atvi_New.PictureIndex 			= 1
	atvi_New.SelectedPictureIndex = 1
else
	atvi_New.PictureIndex 			= 2
	atvi_New.SelectedPictureIndex = 2
end if
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'ds_cenbef_estruct'

ii_numkey = 1  
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

if not ib_move then
	THIS.Event ue_item_add(handle, li_next, ll_Rows)
end if
end event

event clicked;call super::clicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
end event

event rightclicked;call super::rightclicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
il_handle = handle
Parent.EVENT Post Dynamic ue_PopM(w_main.PointerX(), w_main.PointerY())
end event

event selectionchanged;//Ancestor Overriding
end event

type dw_list from u_dw_list_tbl within w_pr026_estruct_cebe
integer y = 128
integer width = 1774
integer height = 1772
integer taborder = 40
string dragicon = "H:\Source\Ico\row2.ico"
string dataobject = "d_lista_cebe_tbl"
end type

event clicked;call super::clicked;If row = 0 or is_padre = '' then Return	// si el click no ha sido a un registro retorna

long ll_row

// Conseguir la llave del registro
if row > 0 then
	// Iniciar el Drag and drop
	//this.DragIcon = 'H:\Source\ICO\row2.ico'
	this.drag(begin!)
	
	is_cen_bef		= this.object.centro_benef		[row]
	is_desc_centro = this.object.desc_centro 		[row]
	
	il_DragSource = 0
	il_DragParent = 0
	il_dropTarget = 0
end if

end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

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
	is_padre 	   = trim(this.object.centro_benef[row])
	is_desc_centro = trim(this.object.desc_centro [row])
	tv_estructura.of_clear()
	tv_estructura.EVENT ue_populate(is_padre, is_desc_centro)
end if

end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

