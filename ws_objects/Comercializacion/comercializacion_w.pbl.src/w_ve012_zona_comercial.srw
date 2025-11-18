$PBExportHeader$w_ve012_zona_comercial.srw
forward
global type w_ve012_zona_comercial from w_abc_master
end type
type cb_refrescar from commandbutton within w_ve012_zona_comercial
end type
type tv_estructura from u_tv_estructura within w_ve012_zona_comercial
end type
type pb_zona from picturebutton within w_ve012_zona_comercial
end type
type cb_zona from commandbutton within w_ve012_zona_comercial
end type
type cb_cliente from commandbutton within w_ve012_zona_comercial
end type
type pb_cliente from picturebutton within w_ve012_zona_comercial
end type
type cb_mover from commandbutton within w_ve012_zona_comercial
end type
type st_campo from statictext within w_ve012_zona_comercial
end type
type dw_1 from datawindow within w_ve012_zona_comercial
end type
type dw_cliente from u_dw_abc within w_ve012_zona_comercial
end type
end forward

global type w_ve012_zona_comercial from w_abc_master
integer width = 3328
integer height = 1296
string title = "[VE012] Zonas Comerciales"
string menuname = "m_mantenimiento_sl"
windowstate windowstate = maximized!
event ue_delete_tv ( )
cb_refrescar cb_refrescar
tv_estructura tv_estructura
pb_zona pb_zona
cb_zona cb_zona
cb_cliente cb_cliente
pb_cliente pb_cliente
cb_mover cb_mover
st_campo st_campo
dw_1 dw_1
dw_cliente dw_cliente
end type
global w_ve012_zona_comercial w_ve012_zona_comercial

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
string		 ls_sub_canal, ls_canal, ls_zona, ls_desc_distrito, ls_cliente
long			 ll_sub_canal, ll_canal, ll_zona, ll_handle

if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return

ll_handle = tv_estructura.FindItem (CurrentTreeItem!, 0)
if tv_estructura.GetItem (ll_handle, ltvi_item) = -1 then return

choose case ltvi_item.level
	
	//**********************
	//   Zonas Comerciales
	//**********************
	case 3
		ls_zona = ltvi_item.data
		
		//Obteniendo SubCanal
		ll_sub_canal = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
		if tv_estructura.GetItem(ll_sub_canal,ltvi_sub_canal) = -1 then return
		ls_sub_canal = ltvi_sub_canal.data
		
		//Obteniendo Canal
		ll_canal	= tv_estructura.FindItem (ParentTreeItem!, ll_sub_canal)
		if tv_estructura.GetItem(ll_canal,ltvi_canal) = -1 then return
		ls_canal = ltvi_canal.data
		
		delete from cliente
		 where canal 	  = :ls_canal
		   and sub_canal = :ls_sub_canal
		   and zona_com  = :ls_zona;
		
		if SQLCA.SQlCode < 0 then
			rollback;
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext)+' '+'Error al Eliminar Zona Comercial')
			return
		else
			commit;
		end if
		
		delete from sub_canal_zona
		 where canal     = :ls_canal
			and sub_canal = :ls_sub_canal
			and zona_com  = :ls_zona;

		if SQLCA.SQlCode < 0 then
			rollback;
			messagebox('Aviso','Existen Vendedores que tienen Asignada esta zona para venta, Elimine y vuelva a INtentarlo!')
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext)+' '+'Error al Eliminar Zona Comercial')
			return
		else
			commit;
		end if

		tv_estructura.DeleteItem(ll_handle)
		
	//**********************
	//      CLIENTES
	//**********************
	case 4
		
		ls_cliente = ltvi_item.data
		
		delete from cliente where cliente = :ls_cliente;
		
		if SQLCA.SQlCode < 0 then
			rollback;
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext)+' '+'Error al Eliminar Cliente')
			return
		else
			commit;
		end if		
		
		tv_estructura.DeleteItem(ll_handle)
		
end choose
end event

on w_ve012_zona_comercial.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.cb_refrescar=create cb_refrescar
this.tv_estructura=create tv_estructura
this.pb_zona=create pb_zona
this.cb_zona=create cb_zona
this.cb_cliente=create cb_cliente
this.pb_cliente=create pb_cliente
this.cb_mover=create cb_mover
this.st_campo=create st_campo
this.dw_1=create dw_1
this.dw_cliente=create dw_cliente
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refrescar
this.Control[iCurrent+2]=this.tv_estructura
this.Control[iCurrent+3]=this.pb_zona
this.Control[iCurrent+4]=this.cb_zona
this.Control[iCurrent+5]=this.cb_cliente
this.Control[iCurrent+6]=this.pb_cliente
this.Control[iCurrent+7]=this.cb_mover
this.Control[iCurrent+8]=this.st_campo
this.Control[iCurrent+9]=this.dw_1
this.Control[iCurrent+10]=this.dw_cliente
end on

on w_ve012_zona_comercial.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_refrescar)
destroy(this.tv_estructura)
destroy(this.pb_zona)
destroy(this.cb_zona)
destroy(this.cb_cliente)
destroy(this.pb_cliente)
destroy(this.cb_mover)
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.dw_cliente)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()

tv_estructura.EVENT ue_open_pre()

dw_cliente.retrieve( )
end event

event resize;//Override
tv_estructura.width  = (newwidth  - tv_estructura.x) - 10
tv_estructura.height = (newheight - tv_estructura.y) - 10

cb_mover.height = (newheight - tv_estructura.y) - 10

//Resize y ubicacion de Cliente
cb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)
pb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)

//Resize y ubicacion de DW MASTER
dw_master.height = (cb_cliente.y - (cb_zona.y - cb_zona.height)) - 240

end event

type dw_master from w_abc_master`dw_master within w_ve012_zona_comercial
integer x = 37
integer y = 288
integer width = 1650
integer height = 292
string dragicon = "H:\source\Ico\row2.ico"
string dataobject = "d_abc_zona_comercial"
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

type cb_refrescar from commandbutton within w_ve012_zona_comercial
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

tv_estructura.event ue_open_pre()

dw_master.retrieve()
dw_cliente.retrieve()

end event

type tv_estructura from u_tv_estructura within w_ve012_zona_comercial
event keydown pbm_tvnkeydown
integer x = 1829
integer y = 32
integer width = 1358
integer height = 1000
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
if ltvi_actual.level <= 2 then return

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
	//*********** ZONAS COMERCIALES ***************
	//=============================================
	case dw_master //DataWindow de Zonas

		ls_sub_canal = ltvi_hijo.data

		//Verificando que Zonas se ingresen debajo de los sub = canales
		if ltvi_hijo.level <> 2 then 
			messagebox('Aviso','Las Zonas Comerciales solamente pueden ser ingresadas dentro de los SUB - CANALES')
			THIS.drag(End!)
			return
		end if
		
		//Obteniendo canal
		ll_canal = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_canal, ltvi_padre) = -1 then return
		ls_canal = ltvi_padre.data
		
		select count(*)
		  into :ll_count
		  from sub_canal_zona
		 where canal	  = :ls_canal
		   and sub_canal = :ls_sub_canal
			and zona_com  = :is_cod_zona;
		
		if ll_count > 0 then
			MessageBox('Aviso', 'Zona Comercial ya pertenece al SUB - CANAL Actual, Verifique!')
			This.Drag(End!)
			return
		end if

		INSERT INTO sub_canal_zona ( canal, sub_canal, zona_com )  
			  VALUES ( :ls_canal, :ls_sub_canal, :is_cod_zona )  ;

		IF SQLCA.SQLCODE = 0 THEN
			Commit ;
		
			ltvi_item.PictureIndex = 4
			ltvi_item.selectedpictureindex = 4
			ltvi_item.Children = TRUE 
			ltvi_item.Label = is_desc_zona
			ltvi_item.data  = is_cod_zona
			ll_NewItem = this.InsertItemLast(handle, ltvi_item)
		
			this.SetDropHighlight (0)
			this.SelectItem(ll_NewItem)
			il_handle = ll_NewItem

		ELSE
			
			Rollback ;
			MessageBox('Aviso',string(sqlca.sqlcode)+' '+sqlca.sqlerrtext) 
		
		END IF
		
	//=============================================
	//***************** CLIENTES ******************
	//=============================================
	case dw_cliente
		ls_zona      = ltvi_hijo.data
		
		//Verificando que Clientes se encuentren debajo de las Zonas
		if ltvi_hijo.level <> 3 then 
			messagebox('Aviso','Los clientes solamente pueden ser ingresados dentro de las ZONAS')
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
		
		select nvl(canal,''), nvl(sub_canal,''), nvl(zona_com,'')
		  into :ls_aux_1, :ls_aux_2, :ls_aux_3
		  from cliente
		 where cliente = :is_proveedor;
		
		if trim(ls_aux_3) = trim(ls_zona) then
			messagebox('Aviso','Este Cliente ya Pertenece a esta ZONA, Verifique!')
			this.drag( End! )
			return
			
		elseif ls_aux_3 <> '' then
			messagebox('Aviso','Este Cliente Pertenece a otra ZONA, Elimine y Arrastre Denuevo!')
			this.drag( End! )
			return
		
		end if
		
		Insert into cliente (cliente, canal, sub_canal, zona_com)
			  values (:is_proveedor, :ls_canal, :ls_sub_canal, :ls_zona);
		
		if sqlca.sqlcode = 0 then
			
			commit;
			
			ltvi_item.PictureIndex = 6
			ltvi_item.selectedpictureindex = 6
			ltvi_item.Children = TRUE 
			ltvi_item.Label = trim(is_desc_proveedor)
			ltvi_item.data  = is_proveedor
			ll_NewItem = this.InsertItemLast(handle, ltvi_item)
		
			this.SetDropHighlight (0)
			this.SelectItem(ll_NewItem)
			il_handle = ll_NewItem
			
			dw_cliente.object.canal[il_row_cliente] = ls_canal
			
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
long			 ll_canal, ll_sub_canal, ll_rows, ll_zona, ll_distrito, ll_cliente
Integer		 li_cnt, li_zona,  li_cliente
string		 ls_canal, ls_sub_canal
TreeViewItem ltvi_new, ltvi_canal, ltvi_zona, ltvi_cliente
DataStore    lds_zonas, lds_cliente

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
					//************** CLIENTES ***************
					//***************************************
					
					//codigo para insertar Zonas
					lds_cliente = Create DataStore
					lds_cliente.DataObject = 'ds_zona_cliente'
					lds_cliente.SetTransObject(sqlca)
					
					ll_rows = lds_cliente.Retrieve(lds_zonas.object.zona_com[li_zona])
					
					if ll_rows > 0 then
						ltvi_cliente.PictureIndex = 6
						ltvi_cliente.selectedpictureindex = 6
						ltvi_cliente.Children = TRUE
						
						for li_cliente = 1 to lds_cliente.RowCount()
							ltvi_cliente.data  = lds_cliente.object.cliente[li_cliente]
							ltvi_cliente.label = trim(lds_cliente.object.nom_proveedor[li_cliente])
							ll_cliente = this.InsertItemLast(ll_zona, ltvi_cliente)
							
							if ll_cliente < 1 then
								MessageBox("Error", "Error al introducir el item (cliente)")
								Return -1
								
							end if
							
						next
						
					end if 
					
					destroy lds_cliente
					
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

type pb_zona from picturebutton within w_ve012_zona_comercial
integer x = 37
integer y = 160
integer width = 114
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Picture1!"
alignment htextalign = left!
end type

type cb_zona from commandbutton within w_ve012_zona_comercial
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
string text = "Zona Comercial"
end type

event clicked;is_source = 'Z' //Zona

changemenu(m_mantenimiento_sl)

dw_master.visible = true
dw_cliente.visible = false

st_campo.visible = false
dw_1.visible	  = false

//Resize y ubicacion de Cliente
cb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)
pb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)

dw_master.height = (cb_cliente.y - (cb_zona.y - cb_zona.height)) - 240
end event

type cb_cliente from commandbutton within w_ve012_zona_comercial
integer x = 151
integer y = 608
integer width = 1536
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clientes"
end type

event clicked;is_source = 'C' //Cliente

changemenu(m_salir)

dw_master.visible = false
dw_cliente.visible = true

st_campo.visible = true
dw_1.visible	  = true

//Resize y ubicacion de Cliente
cb_cliente.y = (cb_zona.y + cb_zona.height) + 10
pb_cliente.y = (cb_zona.y + cb_zona.height) + 10

st_campo.y	 = ( cb_cliente.y + cb_cliente.height ) + 10
dw_1.y	    = ( cb_cliente.y + cb_cliente.height ) + 10

dw_cliente.y = ( st_campo.y + st_campo.height ) + 10
dw_cliente.height = tv_estructura.height - dw_cliente.y
end event

type pb_cliente from picturebutton within w_ve012_zona_comercial
integer x = 37
integer y = 608
integer width = 114
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\Gif\cliente_distrito.gif"
alignment htextalign = left!
end type

type cb_mover from commandbutton within w_ve012_zona_comercial
integer x = 1719
integer y = 32
integer width = 78
integer height = 1000
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
boolean default = true
end type

event clicked;if this.text = '<' then
	
	THIS.TExt = '>'
	
	cb_refrescar.visible = false
	
	pb_zona.visible = false
	cb_zona.visible = false
	dw_master.visible = false
	
	pb_cliente.visible = false
	cb_cliente.visible = false
	dw_cliente.visible = false
	
	DW_1.VISIble = FALSE
	st_campo.visible = false
	
	this.x = 37
	tv_estructura.x = (37+110)
	
	tv_estructura.width = parent.width - ( this.x + 150 )
	
else
	
	THIS.TExt = '<'
	
	cb_refrescar.visible = true
	
	pb_zona.visible = true
	cb_zona.visible = true
	
		DW_1.VISIble = true
	st_campo.visible = true
	
	pb_cliente.visible = true
	cb_cliente.visible = true
		
	if is_source = 'Z' then
		dw_master.visible = true
		
	elseif is_source = 'C' then
		dw_cliente.visible = true
		
	end if
	
	this.x = 1719
	tv_estructura.x = (1719+110)
	
	tv_estructura.width = parent.width - ( this.x + 150 )
	
end if
end event

type st_campo from statictext within w_ve012_zona_comercial
boolean visible = false
integer x = 37
integer y = 728
integer width = 699
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_ve012_zona_comercial
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
boolean visible = false
integer x = 750
integer y = 728
integer width = 937
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_cliente.triggerevent(doubleclicked!)
Return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_cliente.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_cliente.scrollnextrow()	
end if
ll_row = dw_cliente.Getrow()

Return ll_row
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
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_cliente.find(ls_comando, 1, dw_cliente.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_cliente.selectrow(0, false)
			dw_cliente.selectrow(ll_fila,true)
			dw_cliente.scrolltorow(ll_fila)
			this.setfocus()
		end if
	End if	
end if

SetPointer(arrow!)
end event

type dw_cliente from u_dw_abc within w_ve012_zona_comercial
boolean visible = false
integer x = 37
integer y = 832
integer width = 1650
integer height = 196
integer taborder = 30
string dragicon = "H:\source\Ico\row2.ico"
boolean bringtotop = true
string dataobject = "d_cns_proveedor"
boolean vscrollbar = true
end type

event clicked;call super::clicked;

If row = 0 then return // si el click no ha sido a un registro retorna

// Iniciar el Drag and drop
this.drag(begin!)

// Conseguir la llave del registro
is_proveedor  		= this.object.proveedor[row]
is_desc_proveedor = this.object.nom_proveedor[row]
il_row_cliente	= row
end event

event constructor;call super::constructor;settransobject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_ss = 1 
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row


li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col    = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color  = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
ELSE
	ll_row = this.GetRow()
	
	if ll_row > 0 then		
		Any     la_id
		Integer li_x, li_y
		String  ls_tipo

		FOR li_x = 1 TO UpperBound(ii_ik)			
			la_id = dw_master.object.data.primary.current[dw_master.getrow(), ii_ik[li_x]]
			// tipo del dato
			ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")

			IF LEFT( ls_tipo,1) = 'd' THEN
				ist_datos.field_ret[li_x] = string ( la_id)
			ELSEIF LEFT( ls_tipo,1) = 'c'  THEN
				ist_datos.field_ret[li_x] = la_id
			END IF
			
		NEXT
		
		ist_datos.titulo = "s"		

	END IF
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

