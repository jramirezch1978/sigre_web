$PBExportHeader$w_ope309_estruct_ot.srw
forward
global type w_ope309_estruct_ot from w_abc
end type
type cb_1 from commandbutton within w_ope309_estruct_ot
end type
type sle_descripcion from singlelineedit within w_ope309_estruct_ot
end type
type pb_1 from picturebutton within w_ope309_estruct_ot
end type
type st_1 from statictext within w_ope309_estruct_ot
end type
type em_ot_adm from editmask within w_ope309_estruct_ot
end type
type cb_refrescar from commandbutton within w_ope309_estruct_ot
end type
type dw_3 from datawindow within w_ope309_estruct_ot
end type
type st_campo from statictext within w_ope309_estruct_ot
end type
type cb_colapse from commandbutton within w_ope309_estruct_ot
end type
type cb_expand from commandbutton within w_ope309_estruct_ot
end type
type tv_estructura from u_tv_estructura within w_ope309_estruct_ot
end type
type dw_list from u_dw_list_tbl within w_ope309_estruct_ot
end type
end forward

global type w_ope309_estruct_ot from w_abc
integer width = 3643
integer height = 2324
string title = "Estructura de Ordenes de Trabajo (OPE309)"
string menuname = "m_master_sin_lista"
cb_1 cb_1
sle_descripcion sle_descripcion
pb_1 pb_1
st_1 st_1
em_ot_adm em_ot_adm
cb_refrescar cb_refrescar
dw_3 dw_3
st_campo st_campo
cb_colapse cb_colapse
cb_expand cb_expand
tv_estructura tv_estructura
dw_list dw_list
end type
global w_ope309_estruct_ot w_ope309_estruct_ot

type variables
String			is_padre, is_cod_maq, is_desc_maq, is_maq_padre, is_old_padre, &
					is_col, is_tipo, is_flag_estruc
String 			is_nro_orden, is_ot_adm, is_descripcion			
Long				il_xhandle, il_rama, il_handl, il_DragSource, il_DragParent, il_DropTarget
m_rbutton_tv  	im_tv

end variables

on w_ope309_estruct_ot.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.cb_1=create cb_1
this.sle_descripcion=create sle_descripcion
this.pb_1=create pb_1
this.st_1=create st_1
this.em_ot_adm=create em_ot_adm
this.cb_refrescar=create cb_refrescar
this.dw_3=create dw_3
this.st_campo=create st_campo
this.cb_colapse=create cb_colapse
this.cb_expand=create cb_expand
this.tv_estructura=create tv_estructura
this.dw_list=create dw_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_descripcion
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_ot_adm
this.Control[iCurrent+6]=this.cb_refrescar
this.Control[iCurrent+7]=this.dw_3
this.Control[iCurrent+8]=this.st_campo
this.Control[iCurrent+9]=this.cb_colapse
this.Control[iCurrent+10]=this.cb_expand
this.Control[iCurrent+11]=this.tv_estructura
this.Control[iCurrent+12]=this.dw_list
end on

on w_ope309_estruct_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_descripcion)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.em_ot_adm)
destroy(this.cb_refrescar)
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
		lds_data = create u_ds_base
		lds_data.DataObject = 'ds_estructura_tbl'
		lds_data.SetTransObject(SQLCA)
		lds_data.Retrieve(ls_hijo)
		
		for ll_i = 1 to lds_data.RowCount()
			ls_padre = lds_data.object.ot_padre[ll_i]
			ls_hijo 	= lds_data.object.ot_hijo	[ll_i]
			
			// Eliminando de la Estructura de la OT
			delete ot_estructura
			where ot_padre = :ls_padre
			  and ot_hijo  = :ls_hijo;
			
			if SQLCA.SQlCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error al eliminar item', ls_mensaje)
				return
			end if
			
			// Eliminando de la distribucion de costos
			delete ot_distribucion_costo
			where nro_orden 	 = :ls_hijo
			  and nro_ot_cargo = :ls_padre;
			
			if SQLCA.SQlCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error al eliminar item de OT_ESTRUCTURA', ls_mensaje)
				return
			end if
		next
		
	else
		
		ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
		if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
		ls_padre = ltvi_padre.data
	
		// Eliminando la estructura
		delete ot_estructura
		where ot_padre = :ls_padre
		  and ot_hijo  = :ls_hijo;
		
		if SQLCA.SQlCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error al eliminar item', ls_mensaje)
			return
		end if

		// Eliminando de la distribucion de costos
		delete ot_distribucion_costo
		where nro_orden 	 = :ls_hijo
		  and nro_ot_cargo = :ls_padre;
		
		if SQLCA.SQlCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error al eliminar item de OT_ESTRUCTURA', ls_mensaje)
			return
		end if

	end if
else
	// Si un padre, entonces simplemente lo borro
	ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
	if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
	ls_padre = ltvi_padre.data
	
	// Elimino el item de la estructura
	delete ot_estructura
	where ot_padre = :ls_padre
	  and ot_hijo  = :ls_hijo;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al eliminar item', ls_mensaje)
		return
	end if
	
	// Eliminando de la distribucion de costos
	delete ot_distribucion_costo
	where nro_orden 	 = :ls_hijo
	  and nro_ot_cargo = :ls_padre;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al eliminar item de OT_ESTRUCTURA', ls_mensaje)
		return
	end if

end if	

// Grabo todos los cambios
commit;

tv_estructura.DeleteItem(ll_handle_hijo)
end event

type cb_1 from commandbutton within w_ope309_estruct_ot
integer x = 2761
integer y = 28
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

event clicked;String ls_ot_adm

ls_ot_adm = TRIM(em_ot_adm.text)
dw_list.Retrieve(ls_ot_adm)	
end event

type sle_descripcion from singlelineedit within w_ope309_estruct_ot
integer x = 1243
integer y = 32
integer width = 1371
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ope309_estruct_ot
integer x = 1065
integer y = 20
integer width = 128
integer height = 104
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_sql, ls_codigo, ls_data

ls_sql = 'SELECT OT.OT_ADM AS CODIGO,'&
		 + 'OT.DESCRIPCION AS DESCR_OT_ADM '&     	
		 + 'FROM OT_ADMINISTRACION OT, OT_ADM_USUARIO OA ' &
		 + 'WHERE OT.OT_ADM = OA.OT_ADM AND OA.COD_USR = '+"'"+gs_user+"'"
//ADM = '+"'"+ls_ot_adm+"'"	
f_lista(ls_sql, ls_codigo, ls_data, '1')

IF ls_codigo <> '' THEN
	em_ot_adm.text 		= ls_codigo
	sle_descripcion.text = ls_data
END IF												 

end event

type st_1 from statictext within w_ope309_estruct_ot
integer x = 55
integer y = 44
integer width = 562
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Administrador de OT :"
boolean focusrectangle = false
end type

type em_ot_adm from editmask within w_ope309_estruct_ot
integer x = 695
integer y = 32
integer width = 343
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!"
end type

event modified;string ls_desc, ls_ot_adm

ls_ot_adm = this.text

select descripcion
	into :ls_desc
from ot_administracion
where ot_adm = :ls_ot_adm;

sle_descripcion.text = ls_desc
end event

type cb_refrescar from commandbutton within w_ope309_estruct_ot
integer x = 1774
integer y = 588
integer width = 306
integer height = 112
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refrescar"
end type

event clicked;String ls_ot_adm

ls_ot_adm = TRIM(em_ot_adm.text)
dw_list.Retrieve(ls_ot_adm)

end event

type dw_3 from datawindow within w_ope309_estruct_ot
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 695
integer y = 160
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

type st_campo from statictext within w_ope309_estruct_ot
integer x = 32
integer y = 164
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

type cb_colapse from commandbutton within w_ope309_estruct_ot
integer x = 1774
integer y = 436
integer width = 306
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

type cb_expand from commandbutton within w_ope309_estruct_ot
integer x = 1774
integer y = 284
integer width = 306
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

type tv_estructura from u_tv_estructura within w_ope309_estruct_ot
event keydown pbm_tvnkeydown
integer x = 2094
integer y = 260
integer width = 1454
integer height = 1656
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
Long				ll_count, ll_cantidad, ll_NewItem
String			ls_mensaje, ls_cod_maq, ls_desc_maq, ls_padre, ls_hijo, &
					ls_flag_estructura, ls_flag_estado
DataWindow		ldw_list
Decimal			ldc_factor

il_DropTarget = handle					

Open(w_estructura_pop_preg)
ldc_factor = Message.DoubleParm

if IsNull(ldc_factor) then return

If source = THIS THEN 
	
	If GetItem(il_DropTarget, ltvi_Target) = -1 Then Return
	If GetItem(il_DragSource, ltvi_Source) = -1 Then Return
	
	// Verify move
	if this.GetItem(il_DragParent, ltvi_Parent) = -1 then return

	// Verifico antes de mover el Item
	ls_padre = ltvi_Target.Data
	ls_hijo	= ltvi_Source.Data
	
	// Valido no se duplico el padre con el hijo
	select count (*)
		into :ll_count
	from ot_estructura
	where ot_padre 	= :ls_padre
	  and ot_hijo		= :is_cod_maq;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Nro de orden hijo ya pertenece al Padre')
		return
	end if
	
	// Lanzo la pregunta al usuario si desea mover el item
	If MessageBox("Transferencia", "Esta seguro de mover " + &
							ltvi_Source.Label + " de " + ltvi_Parent.label + " a " + ltvi_Target.label + &
							"?", Question!, YesNo!, 1) = 2 Then Return
	
	
	//Verifico que el padre sea de tipo estructura
	select NVL(flag_estructura, '0'), NVL(flag_estado,'0')
		into :ls_flag_Estructura, :ls_flag_estado
	from orden_trabajo
	where nro_orden = :ls_padre;
	
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		MessageBox('Error', "Nro de orden PADRE '" + ls_padre + "' no existe " &
				+ "en la tabla ORDEN_TRABAJO")
		return
	end if

	if ls_flag_estado = '0' then
		ROLLBACK;
		MessageBox('Error', "Nro de orden PADRE '" + ls_padre + "' se encuentra anulado")
		return
	end if

	if ls_flag_estructura = '0' then
		ROLLBACK;
		MessageBox('Error', "Nro de orden PADRE '" + ls_padre + "' no es de tipo Estructura")
		return
	end if

	// Actualizo la estructura de la OT
	update ot_estructura
	   set ot_padre = :ls_padre,
			 factor 	 = :ldc_factor
    where ot_padre = :is_old_padre
	   and ot_hijo  = :ls_hijo;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al momento de mover una orden de trabajo ', ls_mensaje &
					 + char(13) + "NRO ORDEN PADRE: " + ls_padre &
					 + char(13) + "NRO ORDEN HIJO : " + ls_hijo)
		RETURN
	end if
	
	// Valido que no exista referencia circular
	select count(*)
		into :ll_count
	from ot_estructura t
	START WITH ot_padre = :is_padre
	CONNECT BY PRIOR ot_hijo = ot_padre;
		
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
		return
	end if
	
//	//Inserto en el Costo en OT_DISTRIBUCION_COSTO
//	// Primero elimino el registro anterior si lo hubiera
//	update ot_distribucion_costo
//	   set 	nro_ot_cargo = :ls_padre,
//				flag_replicacion = '1'
//	where nro_orden 	 = :ls_hijo
//	  and nro_ot_cargo = :is_old_padre;
//	
//	IF SQLCA.SQLCode = -1 then
//		ls_mensaje = SQLCA.SQLErrText
//		ROLLBACK;
//		MessageBox('Aviso', 'Error al cambiar el registro de OT_DISTRIBUCION_COSTO ' + ls_mensaje &
//					+ char(13) + 'NRO ORDEN HIJO: ' + ls_hijo &
//					+ char(13) + 'NRO ORDEN PADRE: ' + ls_padre )
//		return
//	end if
	
	// Grabo los cambios
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

	//Parametros del Target item 
	if THIS.GetItem (handle, ltvi_padre) = -1 then return
	ls_padre = ltvi_padre.data
	
	//Verifico que el padre sea de tipo estructura
	select NVL(flag_estructura, '0'), NVL(flag_estado,'0')
		into :ls_flag_Estructura, :ls_flag_estado
	from orden_trabajo
	where nro_orden = :ls_padre;
	
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		MessageBox('Error', "Nro de orden PADRE '" + ls_padre + "' no existe " &
				+ "en la tabla ORDEN_TRABAJO")
		return
	end if

	if ls_flag_estado = '0' then
		ROLLBACK;
		MessageBox('Error', "Nro de orden PADRE '" + ls_padre + "' se encuentra anulado")
		return
	end if

	if ls_flag_estructura = '0' then
		ROLLBACK;
		MessageBox('Error', "Nro de orden PADRE '" + ls_padre + "' no es de tipo Estructura")
		return
	end if

	ll_cantidad = 1
	
	// Insertar Registro en TAbla Estructura
	select count (*)
		into :ll_count
	from ot_estructura
	where ot_padre 	= :ls_padre
	  and ot_hijo		= :is_nro_orden;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Número de orden hijo ya pertenece al Padre')
		return
	end if
	  
	// Inserto el registro en OT_estructura
	INSERT INTO OT_ESTRUCTURA ( 
		OT_PADRE, OT_HIJO, factor, Flag_replicacion )  
	VALUES ( 
		:ls_padre, :is_nro_orden, :ldc_factor, '1' )  ;

	IF SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
	MessageBox('Aviso', 'Error al insertar registro en OT_ESTRUCTURA ' + ls_mensaje &
					+ char(13) + "OT PADRE " + ls_padre &
					+ char(13) + "OT HIJO "  + is_nro_orden)
		return
	end if
	
	// Insertar en Arbol
	select count(*)
		into :ll_count
	from ot_estructura t
	START WITH ot_padre = :is_padre
	CONNECT BY PRIOR ot_hijo = ot_padre;
		
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
		return
	end if
	
	//Inserto el registro el OT_DISTRIBUCION_COSTO
//	Select count(*)
//		into :ll_count
//	from ot_distribucion_costo
//	where nro_orden = :is_nro_orden;
//	
//	ll_count ++
//	
//	insert into ot_distribucion_costo(nro_orden, item, porcentaje, nro_ot_cargo, 
//					cod_usr, FECHA_APL_CNTBL)
//	values(:is_nro_orden, :ll_count, 100, :is_padre, :gs_user, sysdate);
//	
//	IF SQLCA.SQLCode = -1 then
//		ls_mensaje = SQLCA.SQLErrText
//		ROLLBACK;
//		MessageBox('Aviso', 'Error al insertar registro de OT_DISTRIBUCION_COSTO ' + ls_mensaje)
//		return
//	end if
	
	//Grabo los cambios en la base de datos
	Commit ;
	
	IF THIS.finditem(ChildTreeItem!, il_DropTarget) <> -1 THEN
		if is_flag_estruc = '1' then
			ltvi_item.PictureIndex = 1
			ltvi_item.selectedpictureindex = 1
		else
			ltvi_item.PictureIndex = 2
			ltvi_item.selectedpictureindex = 2
		end if
		
		
		ltvi_item.Children = TRUE 
		ltvi_item.Label = is_nro_orden + ' - ' + is_descripcion + "(" + is_ot_adm + ")"
		ltvi_item.data  = is_nro_orden
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
if is_flag_estruc = '1' then
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
string 	ls_nro_orden, ls_descripcion, ls_ot_adm, ls_flag_estruc
Integer	li_cantidad, li_icono

ls_nro_orden	= ids_Data.Object.ot_hijo			[ai_Row]
ls_descripcion	= ids_Data.Object.descripcion		[ai_Row]
ls_flag_estruc	= ids_Data.Object.flag_estructura[ai_Row]

if IsNull(ls_descripcion) then ls_descripcion = ''

atvi_New.Label = ls_nro_orden + ' - ' + ls_descripcion //+ " (" + ls_ot_adm + ")"
atvi_New.Data  = ls_nro_orden

atvi_New.Children = True

if ls_flag_estruc = '1' then
	atvi_New.PictureIndex 			= 1
	atvi_New.SelectedPictureIndex = 1
else
	atvi_New.PictureIndex 			= 2
	atvi_New.SelectedPictureIndex = 2
end if
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'ds_maquina_hijo'

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
from ot_estructura t
START WITH ot_padre = :ls_padre
CONNECT BY PRIOR ot_hijo = ot_padre;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
	return
end if

ll_Rows = ids_Data.Retrieve(ls_padre)

THIS.Event ue_item_add(handle, li_next, ll_Rows)
end event

event clicked;call super::clicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
end event

event rightclicked;call super::rightclicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
il_handle = handle
Parent.EVENT Post Dynamic ue_PopM(w_main.PointerX(), w_main.PointerY())
end event

type dw_list from u_dw_list_tbl within w_ope309_estruct_ot
integer y = 272
integer width = 1751
integer height = 1628
integer taborder = 40
string dragicon = "H:\Source\Ico\row2.ico"
string dataobject = "d_list_ord_trab_estruc_tbl"
end type

event clicked;call super::clicked;If row = 0 or is_padre = '' then Return	// si el click no ha sido a un registro retorna
long ll_row

// Iniciar el Drag and drop
//this.DragIcon = 'H:\Source\ICO\row2.ico'
this.drag(begin!)

// Conseguir la llave del registro
if row > 0 then
	is_nro_orden	= this.object.nro_orden   		[row]
	is_descripcion = this.object.titulo		 		[row]
	is_flag_estruc	= this.object.flag_estructura [row]
	
	il_DragSource = 0
	il_DragParent = 0
	il_dropTarget = 0
else
	MessageBox('Error', 'No existen ordenes de trabajo')
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
	is_padre 	= trim(this.object.nro_orden 	    [row])

	select flag_estructura 
	  into :is_flag_estruc
	  from orden_trabajo 
	 where nro_orden = :is_padre ;
	
	IF is_flag_estruc = '1' then
		is_descripcion = trim(this.object.titulo 	[row])
		is_ot_adm		= trim(this.object.ot_adm	[row])
		
		tv_estructura.of_clear()
		tv_estructura.EVENT ue_populate(is_padre, is_descripcion)
	else
		messagebox('Aviso', 'Orden de trabajo no es tipo estructura')
	end if
end if

end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

