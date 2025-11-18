$PBExportHeader$w_rh496_perfiles_consulta.srw
forward
global type w_rh496_perfiles_consulta from w_abc
end type
type tv_estructura from u_tv_estructura within w_rh496_perfiles_consulta
end type
end forward

global type w_rh496_perfiles_consulta from w_abc
integer width = 2117
integer height = 1004
string title = "Estructura de perfiles (RH496)"
string menuname = "m_abc_prc"
windowstate windowstate = maximized!
event ue_modificar ( )
tv_estructura tv_estructura
end type
global w_rh496_perfiles_consulta w_rh496_perfiles_consulta

type variables
String			is_padre, is_cod_maq, is_desc_maq, is_maq_padre, is_old_padre, &
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

//OpenWithParm(w_maq_estructura, lstr_param)
OpenWithParm(w_rh492_perfiles_structura, lstr_param)

if IsNull(Message.PowerObjectParm) or &
	Not IsValid(Message.PowerObjectParm) then
	
	return
	
end if

lstr_param = Message.PowerObjectParm

if lstr_param.titulo = 'n' then return

ll_cantidad = lstr_param.ll_cantidad

select desc_cargo
  into :ls_Desc
  from cargo
 where cod_cargo = :ls_hijo;

ltvi_item.Label = ls_hijo + ' - ' + trim(ls_desc) + "(" + String(ll_cantidad) + ")"

tv_estructura.SetItem(ll_handle_hijo, ltvi_item)




end event

public subroutine of_iconos ();// Verifica estado de acceso
/*
Long    ll_j, ll_total_iconos
String  ls_icono, ls_profile_ini

ls_profile_ini = "/sigre_exe/rrhh.ini"

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
*/
end subroutine

on w_rh496_perfiles_consulta.create
int iCurrent
call super::create
if this.MenuName = "m_abc_prc" then this.MenuID = create m_abc_prc
this.tv_estructura=create tv_estructura
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_estructura
end on

on w_rh496_perfiles_consulta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tv_estructura)
end on

event ue_open_pre;call super::ue_open_pre;SetPointer(hourglass!)
//im_tv = CREATE m_rButton_tv
tv_estructura.EVENT ue_open_pre()

this.of_iconos()

// Help
//ii_help = 16    



end event

event resize;call super::resize;tv_estructura.width  = newwidth  - tv_estructura.x - 10
tv_estructura.height = newheight - tv_estructura.y - 10
//dw_list.height  		= newheight  - dw_list.y - 10

end event

event ue_popm;//Overrride
im_tv.PopMenu(ai_pointerx, ai_pointery)
end event

event ue_delete;//Override
treeviewitem	ltvi_item, ltvi_padre
long				ll_handle, ll_count, ll_handle_hijo, ll_i,ll_padre
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
			
			ls_padre = lds_data.object.cargo_padre [ll_i]
			ls_hijo 	= lds_data.object.cargo_hijo	[ll_i]
			
			delete cargo_estructura
			where cargo_padre = :ls_padre
			  and cargo_hijo  = :ls_hijo;
			
			if SQLCA.SQlCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error al eliminar item', ls_mensaje)
				return
			end if
			
			Commit;
		next
		
		ls_hijo = ls_padre
		
	   ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo)
		tv_estructura.GetItem (ll_handle, ltvi_padre)
		ls_padre = ltvi_padre.data
		
		delete cargo_estructura
		where cargo_padre = :ls_padre
		  and cargo_hijo  = :ls_hijo;
		
	else

		ll_handle = tv_estructura.FindItem (ParentTreeItem!, ll_handle_hijo) 
		if tv_estructura.GetItem (ll_handle, ltvi_padre) = -1 then return
		ls_padre = ltvi_padre.data
	
		delete cargo_estructura
		where cargo_padre = :ls_padre
		  and cargo_hijo  = :ls_hijo;
		
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

	delete cargo_estructura
	 where cargo_padre = :ls_padre
      and cargo_hijo  = :ls_hijo;
	
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

type tv_estructura from u_tv_estructura within w_rh496_perfiles_consulta
event keydown pbm_tvnkeydown
integer x = 41
integer y = 36
integer width = 2007
integer height = 764
integer taborder = 20
integer textsize = -8
boolean disabledragdrop = false
string picturename[] = {"H:\source\Ico\CLIENT.ICO","H:\source\Ico\FACE.ICO","H:\source\Ico\PERSON.ICO","SelectTable!"}
string statepicturename[] = {"Start!","Custom026!","run!","","","","","","","","",""}
end type

event keydown;//treeviewitem	ltvi_item, ltvi_padre
//long				ll_handle, ll_count, ll_handle_hijo
//String			ls_mensaje, ls_padre, ls_hijo
//DataWindow		ldw_list
//
//if key <> KeyDElete! then return
//
//parent.event dynamic ue_delete()

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

event dragdrop;TreeViewItem	ltvi_Target, ltvi_Source, ltvi_Parent, ltvi_New, &
					ltvi_item, ltvi_padre
Long				ll_count, ll_cantidad, ll_NewItem, ll_icono
String			ls_mensaje, ls_cod_maq, ls_desc_maq, ls_padre, ls_hijo
DataWindow		ldw_list

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
	  from cargo_estructura
	 where cargo_padre 	= :ls_padre
	   and cargo_hijo		= :is_cod_maq;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Codigo de cargo hijo ya pertenece al Padre')
		return
	end if

	update cargo_estructura
	   set cargo_padre = :ls_padre
    where cargo_padre = :is_old_padre
	   and cargo_hijo  = :ls_hijo;
	
	if SQLCA.SQlCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al momento de mover un cargo', ls_mensaje)
		RETURN
	end if
	
	// Valido que no exista referencia circular
	select count(*)
     into :ll_count
	  from cargo_estructura
	START WITH cargo_padre = :is_padre
	CONNECT BY PRIOR cargo_hijo = cargo_padre;
		
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

	//Parametros del Target item 
	if THIS.GetItem (handle, ltvi_padre) = -1 then return
	ls_padre = ltvi_padre.data
	
	//Open(w_estructura_pop_preg)
	//if IsNull(Message.DoubleParm) or Message.DoubleParm = 0 then return
	
	ll_cantidad = 1
	
	// Insertar Registro en TAbla Estructura
	select count (*)
		into :ll_count
	from cargo_estructura
	where cargo_padre 	= :ls_padre
	  and cargo_hijo		= :is_cod_maq;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Error', 'Codigo de cargo hijo ya pertenece al Padre')
		return
	end if
	  
	INSERT INTO cargo_ESTRUCTURA ( 
		cargo_PADRE, cargo_HIJO, CANTIDAD, Flag_replicacion )  
	VALUES ( 
		:ls_padre, :is_cod_maq, :ll_cantidad, '1' )  ;
	
	// Insertar en Arbol
	IF SQLCA.SQLCODE = 0 THEN
		select count(*)
			into :ll_count
		from cargo_estructura
		START WITH cargo_padre = :is_padre
		CONNECT BY PRIOR cargo_hijo = cargo_padre;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', 'POSIBLE referencia circular ' + ls_mensaje)
			return
		end if
		
		Commit ;
		IF THIS.finditem(ChildTreeItem!, il_DropTarget) <> -1 THEN
			ltvi_item.PictureIndex = 3
			ltvi_item.selectedpictureindex = 2
			ltvi_item.Children = TRUE 
			ltvi_item.Label = is_cod_maq + ' - ' + is_desc_maq + "(" + String(ll_cantidad) + ")"
			ltvi_item.data  = is_cod_maq 
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
ltvi_Root.PictureIndex 			 = 1//il_icono
ltvi_Root.SelectedPictureIndex = 2//il_icono
ll_handle = THIS.InsertItemLast(0, ltvi_Root)
end event

event ue_item_set;// Override
// Colocar el label y atributos para el nuevo item

Integer	li_Picture, li_max
string 	ls_cod_maq, ls_desc
Integer	li_cantidad, li_icono

ls_cod_maq 		= trim(ids_Data.Object.cargo_hijo		[ai_Row])
ls_desc			= trim(ids_Data.Object.desc_cargo		[ai_Row])
li_cantidad		= Int(ids_Data.Object.cantidad		   [ai_Row])
li_icono			= 3 //Int(ids_Data.Object.icono			[ai_Row])

atvi_New.Label = ls_cod_maq + ' - ' + ls_desc + " (" + String(li_cantidad, '###,##0') + ")"
atvi_New.Data  = ls_cod_maq

atvi_New.Children = True

atvi_New.PictureIndex 			= li_icono
atvi_New.SelectedPictureIndex = li_icono 

end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'ds_cargo_hijo'

ii_numkey = 1  


string ls_cod,ls_desc

declare busqueda CURSOR FOR
select cs.cargo_padre,c.desc_cargo from 
cargo_estructura cs,cargo c
where cs.cargo_padre = c.cod_cargo and
cs.cargo_padre not in 
(select cargo_hijo from cargo_estructura)
group by cs.cargo_padre,c.desc_cargo;


open busqueda;
FETCH busqueda INTO :ls_cod,:ls_desc ;
DO WHILE sqlca.sqlCode = 0
	
	tv_estructura.EVENT ue_populate(ls_cod,ls_desc)
	
	FETCH busqueda INTO :ls_cod,:ls_desc ;
LOOP
close busqueda;
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
from cargo_estructura
START WITH cargo_padre = :ls_padre
CONNECT BY PRIOR cargo_hijo = cargo_padre;

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

event rightclicked;call super::rightclicked;//THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
//il_handle = handle
//Parent.EVENT Post Dynamic ue_PopM(w_main.PointerX(), w_main.PointerY())
end event

event doubleclicked;call super::doubleclicked;treeviewitem ltv_data
string ls_cod,ls_ruta,ls_Input,ls_exe,ls_adress
integer li_value
long ll_hfile
this.getitem(handle,ltv_data)

ls_cod = ltv_data.data

select perfil_ruta
into :ls_ruta
from cargo
where cod_cargo = :ls_cod;

ls_input = right(ls_ruta,3)

if isnull(ls_ruta) then return

choose case upper(ls_input)
		
	case "DOC"
				ls_exe = "WINWORD.EXE"
				//asignacion de la ruta de instalacion de microsoft word
				li_value = RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\office\12.0\common\Installroot", &
		  			  "path", RegString!, ls_adress)
				if li_value = -1 then
				li_value = RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\office\11.0\common\Installroot", &
							  "path", RegString!, ls_adress)
				end if
				if li_value = -1 then
				li_value = RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\office\10.0\common\Installroot", &
						  "path", RegString!, ls_adress)
				end if
				if li_value = -1 then
				li_value = RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\office\9.0\common\Installroot", &
						  "path", RegString!, ls_adress)
				end if
				if li_value = -1 then
				li_value = RegistryGet("HKEY_LOCAL_MACHINE\Software\Microsoft\office\8.0\common\Installroot", &
						  "path", RegString!, ls_adress)			  
				end if

	case "TXT"
		ls_exe = "NOTEPAD.EXE"
		
	case "PDF"
		ls_exe = "ACRORD32.EXE"

/*		Este codigo no sirve aqui
		ls_ruta = trim ( ls_ruta )
		li_value = ole_1.InsertClass("Acroexch.document")
		li_value = ole_1.LinkTo(ls_ruta)
		ole_1.Activation = ActivateOnGetFocus!
		ole_1.ContentsAllowed = ContainsAny!
		ole_1.show()
		ole_1.open(ls_ruta)
		ole_1.SetFocus()
		return 							*/
		
		li_value = RegistryGet("HKEY_LOCAL_MACHINE\Software\Adobe\Acrobat Reader\6.0\InstallPath", &
					 "",RegString!, ls_adress)
		
		if li_value = -1 then
				li_value = RegistryGet("HKEY_LOCAL_MACHINE\Software\Adobe\Acrobat Reader\5.0\InstallPath", &
					 "",RegString!, ls_adress)
		end if
		
		if li_value = -1 then
				ls_adress = "C:\Archivos de programa\Adobe\Acrobat 4.0\Reader"
		end if
		
		ls_adress = ls_adress + "\"
		
	case else
		messagebox(parent.title,"Extension de archivo desconocido: "+ls_input)
		return

end choose

if run(ls_adress+ls_exe+" "+ls_ruta) <> 1 then
	messagebox(parent.title,"Error al abrir el archivo: "+ls_ruta+" ~t Verifique si tiene instalado el programa")
	return
end if

end event

