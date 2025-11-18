$PBExportHeader$w_ve016_zona_vendedores.srw
forward
global type w_ve016_zona_vendedores from w_abc_master
end type
type cb_refrescar from commandbutton within w_ve016_zona_vendedores
end type
type tv_estructura from u_tv_estructura within w_ve016_zona_vendedores
end type
type cb_vendedor from commandbutton within w_ve016_zona_vendedores
end type
type pb_vendedor from picturebutton within w_ve016_zona_vendedores
end type
type tv_vendedor from treeview within w_ve016_zona_vendedores
end type
end forward

global type w_ve016_zona_vendedores from w_abc_master
integer width = 3287
integer height = 1104
string title = "[VE016] Vendedores por Zonas"
string menuname = "m_salir"
windowstate windowstate = maximized!
event ue_delete_tv ( )
cb_refrescar cb_refrescar
tv_estructura tv_estructura
cb_vendedor cb_vendedor
pb_vendedor pb_vendedor
tv_vendedor tv_vendedor
end type
global w_ve016_zona_vendedores w_ve016_zona_vendedores

type variables
Long	  il_handle = 0, il_nivel = 1, il_row_cliente

Integer ii_ik[]
str_parametros ist_datos

//Variables usadas para el drag & drop
string is_vendedor, is_desc_vendedor, is_cod_zona, is_desc_zona, &
		 is_pais, is_dpto, is_prov, is_distrito, is_desc_distrito, &
		 is_source = 'V', is_proveedor, is_desc_proveedor, is_col

//Variable usada en la lista de vendedores para arrastrar
datastore ids_data_vendedor, ids_data_distrito
end variables

event ue_delete_tv();treeviewitem ltvi_item, ltvi_sub_canal, ltvi_canal, ltvi_zona
string		 ls_sub_canal, ls_canal, ls_zona, ls_desc_distrito, ls_vendedor
long			 ll_sub_canal, ll_canal, ll_zona, ll_handle

if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return

ll_handle = tv_estructura.FindItem (CurrentTreeItem!, 0)
if tv_estructura.GetItem (ll_handle, ltvi_item) = -1 then return

choose case ltvi_item.level
	
	//**********************
	//***** Vendedores *****
	//**********************
	case 4
		ls_vendedor = ltvi_item.data
		
		//Obteniendo Zona
		ll_zona = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
		if tv_estructura.GetItem(ll_zona,ltvi_zona) = -1 then return
		ls_zona = ltvi_zona.data
		
		//Obteniendo SubCanal
		ll_sub_canal = tv_estructura.FindItem (ParentTreeItem!, ll_zona)
		if tv_estructura.GetItem(ll_sub_canal,ltvi_sub_canal) = -1 then return
		ls_sub_canal = ltvi_sub_canal.data
		
		//Obteniendo Canal
		ll_canal	= tv_estructura.FindItem (ParentTreeItem!, ll_sub_canal)
		if tv_estructura.GetItem(ll_canal,ltvi_canal) = -1 then return
		ls_canal = ltvi_canal.data
		
		delete from vendedor_zona
		 where canal 	  = :ls_canal
		   and sub_canal = :ls_sub_canal
		   and zona_com  = :ls_zona
			and vendedor  = :ls_Vendedor;
		
		if SQLCA.SQlCode < 0 then
			rollback;
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext)+' '+'Error al Eliminar Zona Comercial')
			return
		else
			commit;
		end if

		tv_estructura.DeleteItem(ll_handle)

end choose
end event

on w_ve016_zona_vendedores.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_refrescar=create cb_refrescar
this.tv_estructura=create tv_estructura
this.cb_vendedor=create cb_vendedor
this.pb_vendedor=create pb_vendedor
this.tv_vendedor=create tv_vendedor
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refrescar
this.Control[iCurrent+2]=this.tv_estructura
this.Control[iCurrent+3]=this.cb_vendedor
this.Control[iCurrent+4]=this.pb_vendedor
this.Control[iCurrent+5]=this.tv_vendedor
end on

on w_ve016_zona_vendedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_refrescar)
destroy(this.tv_estructura)
destroy(this.cb_vendedor)
destroy(this.pb_vendedor)
destroy(this.tv_vendedor)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;//Override
THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton     

tv_estructura.EVENT ue_open_pre()

tv_vendedor.event ue_open_pre()
end event

event resize;//Override
tv_estructura.width  = (newwidth  - tv_estructura.x) - 10
tv_estructura.height = (newheight - tv_estructura.y) - 10

//Resize y ubicacion de DW MASTER
tv_vendedor.height = newheight - tv_vendedor.y

end event

type dw_master from w_abc_master`dw_master within w_ve016_zona_vendedores
boolean visible = false
integer x = 37
integer y = 32
integer width = 114
integer height = 100
string dragicon = "H:\source\Ico\row2.ico"
boolean hscrollbar = true
boolean vscrollbar = true
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

event dw_master::clicked;call super::clicked;If row = 0 then return // si el click no ha sido a un registro retorna

if long(this.object.zona_com.protect) = 0 then return

// Iniciar el Drag and drop
this.drag(begin!)

if this.ii_update = 1 then
	
	if messagebox('Aviso','Debe de Guardar la Informacion antes de Arrastrar, Desea Guardarla Ahora?', Question!, YesNo!, 1) = 2 then return
	parent.event ue_update()

end if

// Conseguir la llave del registro
is_cod_zona  = this.object.zona_com[row]
is_desc_zona = this.object.descripcion[row]

end event

type cb_refrescar from commandbutton within w_ve016_zona_vendedores
integer x = 1353
integer y = 32
integer width = 334
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
end type

event clicked;do while tv_estructura.FindItem(RootTreeItem!, 0) > 0
	tv_estructura.of_clear()
loop

long ll_handle

do while tv_vendedor.FindItem(RootTreeItem!, 0) > 0
	
	ll_handle = tv_vendedor.FindItem(RootTreeItem!, 0)
	tv_vendedor.DeleteItem(ll_handle)
	
loop

tv_estructura.event ue_open_pre()

tv_vendedor.event ue_open_pre()

end event

type tv_estructura from u_tv_estructura within w_ve016_zona_vendedores
event keydown pbm_tvnkeydown
integer x = 1714
integer y = 32
integer width = 1472
integer height = 804
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean disabledragdrop = false
boolean trackselect = true
grsorttype sorttype = userdefinedsort!
string picturename[] = {"Structure5!","Project!","H:\source\Ico\PERSON.ICO","picture1!","H:\source\Bmp\distrito.bmp","H:\source\Gif\cliente_distrito.gif"}
string statepicturename[] = {"","","","","","","","","","","",""}
end type

event keydown;if key <> KeyDElete! then return

TreeViewItem ltvi_actual

if this.getitem(il_handle,ltvi_actual) = -1 then return

/* Evita eliminar Canales y Sub Canales 
  Niveles 1 y 2 correspondientemente */
if ltvi_actual.level <= 3 then return

parent.event ue_delete_tv()
end event

event begindrag;This.Drag(Cancel!)
end event

event clicked;call super::clicked;THIS.SetDropHighlight(handle) 		//para senalizar el item a dropear
il_handle = handle

changemenu(m_mantenimiento_eliminar_tv)
end event

event dragdrop;TreeViewItem	ltvi_hijo, ltvi_padre, ltvi_item
Long				ll_count, ll_NewItem, ll_canal, ll_sub_canal, ll_zona
String			ls_sub_canal, ls_canal, ls_zona, ls_aux_1, ls_aux_2, ls_aux_3

//Verificando que se haga el drop sobre un objeto valido
if THIS.GetItem (handle, ltvi_hijo) = -1 then return

choose case source
		
	//=============================================
	//***************** VENDEDOR ******************
	//=============================================
	case tv_vendedor
		ls_zona      = ltvi_hijo.data
	
		//Verificando que Vendedor se encuentren debajo de las Zonas
		if ltvi_hijo.level <> 3 then 
			messagebox('Aviso','Los Vendedores solamente pueden ser ingresados dentro de las ZONAS')
			THIS.drag(End!)
			return
		end if
	
		//Obteniendo sub - canal
		ll_sub_canal = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_sub_canal, ltvi_padre) = -1 then return
		ls_sub_canal = ltvi_padre.data

		//Obteniendo canal
		ll_canal = FindItem(ParentTreeItem!, ll_sub_canal)
		if this.GetItem(ll_canal, ltvi_padre) = -1 then return
		ls_canal	= ltvi_padre.data

		select count(*)
		  into :ll_count
		  from vendedor_zona
		 where vendedor = :is_vendedor
		   and canal     = :ls_canal
			and sub_canal = :ls_sub_canal
			and zona_com  = :ls_zona;
		
		if ll_count > 0 then
			messagebox('Aviso','Este Vendedor ya Pertenece a una ZONA, Verifique!')
			this.drag( End! )
			return

		end if
		
		Insert into vendedor_zona (vendedor, canal, sub_canal, zona_com)
			  values (:is_vendedor, :ls_canal, :ls_sub_canal, :ls_zona);
		
		if sqlca.sqlcode = 0 then
			
			commit;
			
			ltvi_item.PictureIndex = 3
			ltvi_item.selectedpictureindex = 3
			ltvi_item.Children = TRUE 
			ltvi_item.Label = trim(is_desc_vendedor)
			ltvi_item.data  = is_vendedor
			ll_NewItem = this.InsertItemLast(handle, ltvi_item)
		
			this.SetDropHighlight (0)
			this.SelectItem(ll_NewItem)
			il_handle = ll_NewItem
			
		else
			
			Rollback ;
			MessageBox('Aviso',string(sqlca.sqlcode)+' '+sqlca.sqlerrtext)
			
		end if
				
end choose

THIS.drag(End!)

end event

event dragwithin;call super::dragwithin;this.SetDropHighlight(handle)


end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'ds_canal_distribucion_det'

ii_numkey = 1  


string ls_cod,ls_desc

declare busqueda CURSOR FOR
 select canal, descripcion 
   from canal_distribucion
  where flag_estado = '1';

open busqueda;
FETCH busqueda INTO :ls_cod,:ls_desc;
DO WHILE sqlca.sqlCode = 0
	
	tv_estructura.EVENT ue_populate(ls_cod,ls_desc)
	
	FETCH busqueda INTO :ls_cod,:ls_desc ;
LOOP
close busqueda;
end event

event ue_item_add;// Override
// Introducir los items al treeview
long			 ll_canal, ll_sub_canal, ll_rows, ll_zona, ll_distrito, ll_vendedor
Integer		 li_cnt, li_zona,  li_vendedor
string		 ls_canal, ls_sub_canal
TreeViewItem ltvi_new, ltvi_canal, ltvi_zona, ltvi_vendedor
DataStore    lds_zonas, lds_Vendedor

For li_cnt = 1 To ai_Rows
	THIS.Event ue_Item_set(ai_nivel, li_cnt, ltvi_new)
	
	ll_sub_canal = THIS.InsertItemLast(al_handle, ltvi_New)
	
	IF ll_sub_canal < 1 Then
		MessageBox("Error", "Error al introducir el item (sub - canal)")
		Return -1
		
	else
		//***************************************
		//*************** ZONAS *****************
		//***************************************
		
		//Sub Canal
		ls_sub_canal = ltvi_new.data
		
		//Canal
		ll_canal = FindItem(ParentTreeItem!, ll_sub_canal)
		if this.GetItem(ll_canal, ltvi_canal) = -1 then return(0)
		ls_canal = ltvi_canal.data
		
		//codigo para insertar Vendedores
		lds_zonas = Create DataStore
		lds_zonas.DataObject = 'ds_canales_zona'
		lds_zonas.SetTransObject(sqlca)
					
		ll_rows = lds_zonas.Retrieve(ls_canal, ls_sub_canal)
					
		if ll_rows > 0 then
			ltvi_zona.PictureIndex = 4
			ltvi_zona.selectedpictureindex = 4
			ltvi_zona.Children = true
						
			for li_zona = 1 to lds_zonas.RowCount()
				ltvi_zona.data  = lds_zonas.object.zona_com[li_zona]
				ltvi_zona.label = lds_zonas.object.descripcion[li_zona]
				ll_zona = this.InsertItemLast(ll_sub_canal, ltvi_zona)
							
				if ll_zona < 1 then
					MessageBox("Error","Error al INtroducir el item (Zona)")
					return -1
					
				else
					//***************************************
					//************** VENDEDOR ***************
					//***************************************
					
					//codigo para insertar Vendedor
					lds_Vendedor = Create DataStore
					lds_Vendedor.DataObject = 'ds_zona_vendedor'
					lds_Vendedor.SetTransObject(sqlca)
					
					ll_rows = lds_Vendedor.Retrieve(ls_canal, ls_sub_canal, lds_zonas.object.zona_com[li_zona])
					
					if ll_rows > 0 then
						ltvi_vendedor.PictureIndex = 3
						ltvi_vendedor.selectedpictureindex = 3
						ltvi_vendedor.Children = TRUE
						
						for li_vendedor = 1 to lds_Vendedor.RowCount()
							ltvi_vendedor.data  = lds_Vendedor.object.vendedor[li_vendedor]
							ltvi_vendedor.label = trim(lds_Vendedor.object.nombre[li_vendedor])
							ll_vendedor = this.InsertItemLast(ll_zona, ltvi_vendedor)
							
							if ll_vendedor < 1 then
								MessageBox("Error", "Error al introducir el item (Vendedor)")
								Return -1
								
							end if
							
						next
						
					end if 
					
					destroy lds_Vendedor
					
				end if //FIN DE ZONAS
							
			next
						
		end if
		
		destroy lds_zonas
		
	end if //Fin de Vendedores

Next

Return ai_Rows
end event

event ue_item_set;// Override
// Colocar el label y atributos para el nuevo item

Integer	li_Picture, li_max
string 	ls_sub_canal, ls_desc_sub_canal

ls_sub_canal      = trim(ids_Data.Object.sub_canal[ai_Row])
ls_desc_sub_canal = trim(ids_Data.Object.descripcion[ai_Row])

atvi_New.Label = ls_desc_sub_canal
atvi_New.Data  = ls_sub_canal

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

type cb_vendedor from commandbutton within w_ve016_zona_vendedores
integer x = 151
integer y = 160
integer width = 1536
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Vendedores"
end type

type pb_vendedor from picturebutton within w_ve016_zona_vendedores
integer x = 37
integer y = 160
integer width = 114
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\GIF\PERSON.GIF"
alignment htextalign = left!
end type

type tv_vendedor from treeview within w_ve016_zona_vendedores
event ue_open_pre ( )
event ue_populate ( any aa_codigo,  string as_descripcion )
event ue_item_set ( integer ai_nivel,  integer ai_row,  ref treeviewitem atvi_new )
event type integer ue_item_add ( long al_handle,  integer ai_nivel,  integer ai_rows )
integer x = 37
integer y = 288
integer width = 1650
integer height = 548
integer taborder = 40
string dragicon = "H:\source\Ico\row2.ico"
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean disabledragdrop = false
string picturename[] = {"H:\source\Ico\CLIENT.ICO","H:\source\Ico\PERSON.ICO"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event ue_open_pre();//Codigo de Inicializacion
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
	
	tv_vendedor.EVENT ue_populate(ls_cod,ls_desc)
	
	FETCH busqueda INTO :ls_cod,:ls_desc ;
LOOP
close busqueda;

end event

event ue_populate(any aa_codigo, string as_descripcion);Long				ll_handle
TreeViewItem	ltvi_Root

SetPointer(HourGlass!)

// crear datastores para el treeview Vendedores
ids_data_vendedor = Create DataStore
ids_data_vendedor.DataObject = 'ds_vendedor_supervisor'
ids_data_vendedor.SetTransObject(sqlca)

ltvi_Root.Label = as_descripcion
ltvi_Root.Data  = string(aa_codigo)
ltvi_Root.Children = True
ltvi_Root.PictureIndex 			 = 1
ltvi_Root.SelectedPictureIndex = 1

ll_handle = THIS.InsertItemLast(0, ltvi_Root)
THIS.ExpandAll(ll_handle)
end event

event ue_item_set(integer ai_nivel, integer ai_row, ref treeviewitem atvi_new);// Colocar el label y atributos para el nuevo item
string 	ls_cod_hijo, ls_desc_hijo

ls_cod_hijo  = trim(ids_Data_vendedor.Object.vendedor[ai_Row])
ls_desc_hijo = trim(ids_Data_vendedor.Object.nombre[ai_Row])

atvi_New.Label = ls_desc_hijo
atvi_New.Data  = ls_cod_hijo

atvi_New.Children = True

atvi_New.PictureIndex 			= 2
atvi_New.SelectedPictureIndex = 2 
end event

event type integer ue_item_add(long al_handle, integer ai_nivel, integer ai_rows);// Introducir los items al treeview
Integer				li_cnt
TreeViewItem		ltvi_new

For li_cnt = 1 To ai_Rows
	THIS.Event ue_Item_set(ai_nivel, li_cnt, ltvi_new)  
	IF THIS.InsertItemLast(al_handle, ltvi_New) < 1 Then
		MessageBox("Error", "Error al introducir el item")
		Return -1
	End If
Next
Return ai_Rows
end event

event begindrag;treeviewitem ltvi_source

if this.GetItem(handle, ltvi_Source) = -1 then return

//Evita que se Arrastre el ROOT
If ltvi_Source.Level = 1 Then
	This.Drag(Cancel!)
	
Else
	this.Drag(Begin!)

	is_vendedor      = ltvi_source.data
	is_desc_vendedor = ltvi_source.label

end if


end event

event clicked;//para senalizar el item a dropear
THIS.SetDropHighlight(handle)

changemenu(m_salir)
end event

event itempopulate;// Poblar el arbol con sus hijos
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

ll_Rows = ids_Data_vendedor.Retrieve(ls_parm)

THIS.Event ue_item_add(handle, li_next, ll_Rows)
end event

