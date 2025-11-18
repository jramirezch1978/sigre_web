$PBExportHeader$w_ve014_vendedor.srw
forward
global type w_ve014_vendedor from w_abc_master
end type
type cb_refrescar from commandbutton within w_ve014_vendedor
end type
type tv_estructura from u_tv_estructura within w_ve014_vendedor
end type
end forward

global type w_ve014_vendedor from w_abc_master
integer width = 3547
integer height = 2160
string title = "[VE014] Vendedores"
string menuname = "m_mtto_smpl"
event ue_delete_tv ( )
cb_refrescar cb_refrescar
tv_estructura tv_estructura
end type
global w_ve014_vendedor w_ve014_vendedor

type variables
Long	 il_handle = 0
long	 il_DragSource, il_DragParent //Variables usadas para el Drag&Drop dentro del TREEVIEW
string is_col, is_tipo
string is_cod_lista, is_desc_lista
end variables

event ue_delete_tv();treeviewitem ltvi_item, ltvi_padre
DataStore	 lds_data
long			 ll_current_handle, ll_i
string		 ls_codigo, ls_hijo

if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return

ll_current_handle = tv_estructura.FindItem (CurrentTreeItem!, 0)

if tv_estructura.GetItem (ll_current_handle, ltvi_item) = -1 then return
ls_codigo = ltvi_item.data

if tv_estructura.FindItem (ChildTreeItem!, ll_current_handle) <> -1 then 
	
	// Si es un padre entonces debo borrar en casacada
	if MessageBox('Aviso', 'Se procedera a Borrar todos los Vendedores de Este Supervisor, Continuar?', &
		Question!, YesNo!, 2) = 1 then
		
			lds_data = create datastore
			lds_data.DataObject = 'ds_estructura_vendedor'
			lds_data.SetTransObject(SQLCA)
			lds_data.Retrieve(ls_codigo)
		
			for ll_i = 1 to lds_data.RowCount()
			
				ls_hijo 	= lds_data.object.vendedor[ll_i]
			
				update vendedor
				   set supervisor = null
				 where vendedor = :ls_hijo;
			
				if SQLCA.SQlCode < 0 then
					ROLLBACK;
					MessageBox('Error al eliminar item', sqlca.sqlerrtext)
					return
				end if
			
				Commit;

			next
		
			update vendedor
		      set supervisor = null
			 where vendedor = :ls_codigo;
			 
		   if SQLCA.SQlCode < 0 then
				ROLLBACK;
				MessageBox('Error al eliminar item', sqlca.sqlerrtext)
				return
			end if
			
			destroy lds_data

	end if

else

	update vendedor
	   set supervisor = null
	 where vendedor = :ls_codigo;
			 
	if SQLCA.SQlCode < 0 then
	   ROLLBACK;
 		MessageBox('Error al eliminar item', sqlca.sqlerrtext)
		return
	end if
	
end if	

commit;

tv_estructura.DeleteItem(ll_current_handle)
end event

on w_ve014_vendedor.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.cb_refrescar=create cb_refrescar
this.tv_estructura=create tv_estructura
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refrescar
this.Control[iCurrent+2]=this.tv_estructura
end on

on w_ve014_vendedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_refrescar)
destroy(this.tv_estructura)
end on

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gnvo_app.is_user, is_tabla, gnvo_app.invo_empresa.is_empresa)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve()
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
END IF


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()
tv_estructura.event ue_open_pre()
end event

event resize;//Override
uo_h.width		= newwidth
uo_h.of_resize( newwidth )
st_box.height	= newheight -  st_box.y - cii_WindowBorder
dw_master.height = newheight - dw_master.y - cii_WindowBorder

tv_estructura.width  = newwidth  - tv_estructura.x - cii_windowborder
tv_estructura.height = newheight - tv_estructura.y - cii_windowborder

end event

type ole_skin from w_abc_master`ole_skin within w_ve014_vendedor
end type

type uo_h from w_abc_master`uo_h within w_ve014_vendedor
end type

type st_box from w_abc_master`st_box within w_ve014_vendedor
end type

type st_filter from w_abc_master`st_filter within w_ve014_vendedor
end type

type uo_filter from w_abc_master`uo_filter within w_ve014_vendedor
end type

type dw_master from w_abc_master`dw_master within w_ve014_vendedor
integer x = 526
integer y = 396
integer width = 1600
integer height = 740
string dragicon = "H:\source\Ico\row2.ico"
string dataobject = "d_abc_vendedor"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = 	dw_master

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::doubleclicked;call super::doubleclicked;if row = 0 then return

str_seleccionar lstr_seleccionar

if long(this.object.vendedor.protect) = 0 then
	
	choose case dwo.name
	
		case 'vendedor'
			
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = "SELECT COD_USR AS CODIGO, " &
											 +"NOMBRE AS NOMBRE " &
											 +"FROM USUARIO " &
											 +"WHERE FLAG_ESTADO = '1'"
	
			OpenWithParm(w_seleccionar,lstr_seleccionar)
					
			if isvalid(message.PowerObjectParm) then lstr_seleccionar = message.PowerObjectParm
			
			if lstr_seleccionar.s_action = "aceptar" then
				Setitem(row,'vendedor',lstr_seleccionar.param1[1])
				Setitem(row,'nombre',lstr_seleccionar.param2[1])
				ii_update = 1
			end if
					
	end choose
	
else

	is_cod_lista  = this.object.vendedor[row]
	is_desc_lista = this.object.nombre[row]

	tv_estructura.EVENT ue_populate(is_cod_lista, is_desc_lista)
	
end if
end event

event dw_master::itemchanged;call super::itemchanged;string ls_nombre

choose case dwo.name
		
	case 'vendedor'
		
		select nombre
		  into :ls_nombre
		  from usuario
		 where cod_usr = :data;
		
		if isnull(ls_nombre) or ls_nombre = '' then
			messagebox('Aviso','Codigo Ingresado No Existe, Verifique!')
			SetNull(ls_nombre)
			this.object.vendedor[row] = ls_nombre
			return 1
		end if
		
		this.object.nombre[row] = ls_nombre
		
end choose
end event

event dw_master::clicked;call super::clicked;if row = 0 then return // si el click no ha sido a un registro retorna

if long(this.object.vendedor.protect) = 0 then return

// Iniciar el Drag and drop
this.drag(begin!)

if this.object.flag_estado[row] = '0' then
	messagebox('Aviso','El vendedor debe de estar Activo para poder Arrastrarlo')
	this.drag(End!)
	return
end if

changemenu(m_mtto_smpl)

// Conseguir la llave del registro
is_cod_lista  = this.object.vendedor[row]
is_desc_lista = this.object.nombre[row]
end event

event dw_master::getfocus;call super::getfocus;uo_filter.of_set_dw( this )
uo_filter.of_retrieve_fields( )
uo_h.of_set_title( parent.title + ". ~t Nro de Registros: " + string(dw_master.RowCount()))

end event

type cb_refrescar from commandbutton within w_ve014_vendedor
integer x = 1815
integer y = 276
integer width = 325
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Refrescar"
boolean default = true
end type

event clicked;do while tv_estructura.FindItem(RootTreeItem!, 0) > 0
	tv_estructura.of_clear()
loop

tv_estructura.event ue_open_pre()

dw_master.retrieve()
end event

type tv_estructura from u_tv_estructura within w_ve014_vendedor
event keydown pbm_tvnkeydown
integer x = 2149
integer y = 276
integer width = 1797
integer height = 868
integer taborder = 20
string dragicon = "H:\source\Ico\row2.ico"
boolean bringtotop = true
integer textsize = -8
boolean disabledragdrop = false
grsorttype sorttype = userdefinedsort!
string picturename[] = {"H:\source\Ico\CLIENT.ICO","H:\source\Ico\PERSON.ICO","","",""}
string statepicturename[] = {"","","","","","","","","","","",""}
end type

event keydown;if key <> KeyDElete! then return

if isnull(il_handle) or il_handle = 0 then return

parent.event ue_delete_tv()
end event

event begindrag;TreeViewItem	ltvi_Source, ltvi_Parent

if this.GetItem(handle, ltvi_Source) = -1 then return

//Evita que se Arrastre el ROOT
If ltvi_Source.Level = 1 Then
	This.Drag(Cancel!)
Else
	// Guardar los HANDLE de item a arrastrar y su padre
	this.Drag(Begin!)
	il_DragSource = handle
	il_DragParent = FindItem(ParentTreeItem!, handle)
	if this.GetItem(il_DragParent, ltvi_Parent) = -1 then return
End If
end event

event clicked;call super::clicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
il_handle = handle

w_ve014_vendedor.changemenu(m_mantenimiento_eliminar_tv)
end event

event dragdrop;TreeViewItem	ltvi_padre, ltvi_item, ltvi_target, ltvi_source, ltvi_parent
Long				ll_count, ll_NewItem, ll_canal
String			ls_supervisor, ls_padre, ls_hijo, ls_ex_padre


if dw_master.ii_update = 1 then
	
	if messagebox('Aviso','Debe de Guardar la Informacion antes de Arrastrar, Desea Guardarla Ahora?', Question!, YesNo!, 1) = 2 then return
	parent.event ue_update()
	return

end if

if source = this then
	
	If GetItem(handle, ltvi_Target) 			= -1 Then Return
	If GetItem(il_DragSource, ltvi_Source) = -1 Then Return
	if GetItem(il_DragParent, ltvi_Parent) = -1 then return
	
	If MessageBox("Transferencia", "Esta seguro de mover " + ltvi_Source.Label + & 
					  " de " + ltvi_Parent.label + " a " + ltvi_Target.label + &
					  "?", Question!, YesNo!, 1) = 2 Then Return
	
	// Move the item
	ls_padre    = ltvi_Target.Data
	ls_hijo	   = ltvi_Source.Data
	ls_ex_padre = ltvi_Parent.Data
		
	if ls_ex_padre = ls_padre then return
		
	update vendedor
	   set supervisor = :ls_padre
	 where vendedor = :ls_hijo;
		
	if SQLCA.SQlCode < 0 then
		ROLLBACK;
		MessageBox('Aviso', 'Error al momento de Actualizar Nuevo Supervisor para Vendedor' + &
					  string(ltvi_source.Data)+' - '+string(ltvi_source.label))
		RETURN
	end if
		
	// Valido que no exista referencia circular
	select count(*)
	  into :ll_count
	  from vendedor
	 START WITH supervisor = :ls_hijo
  CONNECT BY PRIOR vendedor = supervisor;
			
	if SQLCA.SQLCode < 0 then
		ROLLBACK;
		MessageBox('Aviso', 'POSIBLE referencia circular ' + sqlca.sqlerrtext)
		return
	end if
	
	commit;
	
	//Se borra item del treeview
	this.DeleteItem(il_DragSource)
	//Se Inserta Item debajo del Nuevo Padre
	SetNull(ltvi_Source.ItemHandle)
	
	IF THIS.finditem(ChildTreeItem!, handle) <> -1 THEN
		ll_NewItem = this.InsertItemLast(handle, ltvi_Source)
		this.SetDropHighlight (0)
		this.SelectItem(ll_NewItem)
	ELSE
		THIS.ExpandItem(handle)
	END IF
	
else

	//Obteniendo Padre
	if THIS.GetItem (handle, ltvi_padre) = -1 then return
	ls_supervisor = ltvi_padre.data
	
	//Verificacion de Duplicado
	select count (*)
	  into :ll_count
	  from vendedor
	 where supervisor = :ls_supervisor
		and vendedor   = :is_cod_lista;
	
	if ll_count > 0 then
		ROLLBACK;
		MessageBox('Aviso', 'Vendedor Ya Pertenece a este Supervisor, Verifique!')
		return
	end if
	
	select count(*)
	  into :ll_count
	  from vendedor
	 where supervisor is not null
		and vendedor = :is_cod_lista;
	
	if ll_count > 0 then
		rollback;
		messagebox('Aviso','Vendedor Ya tiene un Supervisor, Elimine y Luego Arrastre')
		return
	end if
	
	//Actualiza maestro de vendedores
	update vendedor
		set supervisor = :ls_supervisor
	 where vendedor   = :is_cod_lista;
	 
	// Insertar en Arbol
	IF SQLCA.SQLCODE = 0 THEN
		
		select count(*)
		  into :ll_count
		  from vendedor
		 start with supervisor = :is_cod_lista
	  connect by prior vendedor = supervisor;
			
		if SQLCA.SQLCode < 0 then
			ROLLBACK;
			MessageBox('Aviso', 'POSIBLE referencia circular ' + ' ' + sqlca.sqlerrtext)
			return
		end if
	
		Commit ;
	
		IF THIS.finditem(ChildTreeItem!, handle) <> -1 THEN
			ltvi_item.PictureIndex = 2
			ltvi_item.selectedpictureindex = 2
			ltvi_item.Children = TRUE 
			ltvi_item.Label = is_desc_lista
			ltvi_item.data  = is_cod_lista
			ll_NewItem = this.InsertItemLast(handle, ltvi_item)
		
			this.SetDropHighlight (0)
			this.SelectItem(ll_NewItem)
			il_handle = ll_NewItem
		ELSE
			THIS.ExpandItem(handle)
		END IF
	
	ELSE
	
		Rollback ;
		MessageBox('Aviso',string(sqlca.sqlcode)+' '+sqlca.sqlerrtext) 
	
	END IF

end if //Fin General

THIS.drag(End!)

end event

event dragwithin;call super::dragwithin;this.SetDropHighlight(handle)


end event

event itempopulate;// Override
// Poblar el arbol con sus hijos
Integer			li_next
Long				ll_rows
string			ls_parm
TreeViewItem	ltvi_nivel

SetPointer(HourGlass!)

THIS.GetItem(handle, ltvi_nivel)
li_next = ltvi_nivel.Level + 1       // Determinar el nivel siguiente

ls_parm = string(ltvi_nivel.Data)

select count(*)
  into :ll_rows
  from vendedor
 start with supervisor = :ls_parm
connect by prior vendedor = supervisor;

if ll_rows < 0 then
	ROLLBACK;
	return
end if

ll_Rows = ids_Data.Retrieve(ls_parm)

THIS.Event ue_item_add(handle, li_next, ll_Rows)
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'ds_vendedor_supervisor'

ii_numkey = 1  

string ls_cod,ls_desc

declare busqueda CURSOR FOR
select v.supervisor, u.nombre
  from vendedor v, usuario u, vendedor a
 where v.supervisor = a.vendedor
   And v.supervisor = u.cod_usr
   And a.supervisor Is null
 group by v.supervisor, u.nombre;

open busqueda;
FETCH busqueda INTO :ls_cod,:ls_desc;
DO WHILE sqlca.sqlCode = 0
	
	tv_estructura.EVENT ue_populate(ls_cod,ls_desc)
	
	FETCH busqueda INTO :ls_cod,:ls_desc ;
LOOP
close busqueda;
end event

event ue_item_set;// Override
// Colocar el label y atributos para el nuevo item

Integer	li_Picture, li_max
string 	ls_cod_hijo, ls_desc_hijo

ls_cod_hijo  = trim(ids_Data.Object.vendedor[ai_Row])
ls_desc_hijo = trim(ids_Data.Object.nombre[ai_Row])

atvi_New.Label = ls_desc_hijo
atvi_New.Data  = ls_cod_hijo

atvi_New.Children = True

atvi_New.PictureIndex 			= 2
atvi_New.SelectedPictureIndex = 2 


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

ltvi_Root.Label = as_descripcion
ltvi_Root.Data  = string(aa_codigo)
ltvi_Root.Children = True
ltvi_Root.PictureIndex 			 = 1
ltvi_Root.SelectedPictureIndex = 1
ll_handle = THIS.InsertItemLast(0, ltvi_Root)
THIS.ExpandAll(ll_handle)
end event

