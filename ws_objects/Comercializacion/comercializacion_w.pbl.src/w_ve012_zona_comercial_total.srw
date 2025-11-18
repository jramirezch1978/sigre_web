$PBExportHeader$w_ve012_zona_comercial_total.srw
forward
global type w_ve012_zona_comercial_total from w_abc_master
end type
type cb_refrescar from commandbutton within w_ve012_zona_comercial_total
end type
type tv_estructura from u_tv_estructura within w_ve012_zona_comercial_total
end type
type pb_zona from picturebutton within w_ve012_zona_comercial_total
end type
type cb_zona from commandbutton within w_ve012_zona_comercial_total
end type
type cb_vendedor from commandbutton within w_ve012_zona_comercial_total
end type
type cb_distrito from commandbutton within w_ve012_zona_comercial_total
end type
type cb_cliente from commandbutton within w_ve012_zona_comercial_total
end type
type pb_vendedor from picturebutton within w_ve012_zona_comercial_total
end type
type pb_distrito from picturebutton within w_ve012_zona_comercial_total
end type
type pb_cliente from picturebutton within w_ve012_zona_comercial_total
end type
type tv_distrito from treeview within w_ve012_zona_comercial_total
end type
type tv_vendedor from treeview within w_ve012_zona_comercial_total
end type
type cb_mover from commandbutton within w_ve012_zona_comercial_total
end type
type st_campo from statictext within w_ve012_zona_comercial_total
end type
type dw_1 from datawindow within w_ve012_zona_comercial_total
end type
type dw_cliente from u_dw_abc within w_ve012_zona_comercial_total
end type
end forward

global type w_ve012_zona_comercial_total from w_abc_master
integer width = 3291
integer height = 2092
string title = "ZONA COMERCIAL (VE012)"
string menuname = "m_salir"
windowstate windowstate = maximized!
event ue_delete_tv ( )
cb_refrescar cb_refrescar
tv_estructura tv_estructura
pb_zona pb_zona
cb_zona cb_zona
cb_vendedor cb_vendedor
cb_distrito cb_distrito
cb_cliente cb_cliente
pb_vendedor pb_vendedor
pb_distrito pb_distrito
pb_cliente pb_cliente
tv_distrito tv_distrito
tv_vendedor tv_vendedor
cb_mover cb_mover
st_campo st_campo
dw_1 dw_1
dw_cliente dw_cliente
end type
global w_ve012_zona_comercial_total w_ve012_zona_comercial_total

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

event ue_delete_tv();treeviewitem ltvi_item, ltvi_sub_canal, ltvi_canal, ltvi_vendedor, ltvi_zona, ltvi_distrito
string		 ls_sub_canal, ls_canal, ls_vendedor, ls_zona, ls_distrito, ls_desc_distrito, ls_cliente
long			 ll_sub_canal, ll_canal, ll_vendedor, ll_zona, ll_distrito, ll_handle

if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return

ll_handle = tv_estructura.FindItem (CurrentTreeItem!, 0)
if tv_estructura.GetItem (ll_handle, ltvi_item) = -1 then return

choose case ltvi_item.level
	
	//**********************
	//      Vendedores
	//**********************
	case 3
		ls_vendedor = ltvi_item.data
		
		//Obteniendo SubCanal
		ll_sub_canal = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
		if tv_estructura.GetItem(ll_sub_canal,ltvi_sub_canal) = -1 then return
		ls_sub_canal = ltvi_sub_canal.data
		
		//Obteniendo Canal
		ll_canal	= tv_estructura.FindItem (ParentTreeItem!, ll_sub_canal)
		if tv_estructura.GetItem(ll_canal,ltvi_canal) = -1 then return
		ls_canal = ltvi_canal.data
		
		select nvl(zona_com,'')
		  into :ls_zona
		  from vendedor
		 where vendedor = :ls_vendedor;
		
		if ls_zona <> '' then
		
			update vendedor
				set zona_com  = null,
					 canal	  = null,
					 sub_canal = null
			 where vendedor  = :ls_vendedor;
			 
			update tt_vendedor
				set zona_com  = null,
					 canal	  = null,
					 sub_canal = null
			 where vendedor  = :ls_vendedor;
			 
			delete from cliente where zona_com = :ls_zona;
			
			//codigo para borrar en tabla direcciones
			declare c_clientes_v cursor for
			select di.codigo
			  from distrito ds, direcciones di
			 where ds.cod_pais = di.cod_pais
			   and ds.cod_dpto = di.cod_dpto
				and ds.cod_prov = di.cod_prov
				and ds.cod_distr = di.cod_distr
				and ds.zona_com  = :ls_zona
				and di.flag_uso  = '1';
			
			open c_clientes_v;
			
			open c_clientes_v;
			fetch c_clientes_v into :ls_cliente;
			DO WHILE sqlca.sqlCode = 0
				
				update direcciones
				   set cod_pais = null,
						 cod_dpto = null,
						 cod_prov = null,
						 cod_distr = null,
						 flag_dir_comercial = null
				 where codigo = :ls_cliente
				   and flag_uso = '1';
				
				FETCH c_clientes_v INTO :ls_cliente;
			LOOP
			close c_clientes_v;
			//fin de borrado a tabla direcciones
			
			update distrito
		   	set zona_com = null
		 	 where zona_com = :ls_zona;
			
			delete sub_canal_zona
			 where canal 	  = :ls_canal
				and sub_canal = :ls_sub_canal
				and zona_com  = :ls_zona;
			  
		else
			
			update tt_vendedor
				set zona_com  = null,
					 canal	  = null,
					 sub_canal = null
			 where vendedor  = :ls_vendedor;
			 
		end if
		
		if SQLCA.SQlCode < 0 then
			rollback;
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Vendedor')
			return
		else
			commit;
		end if
		
		tv_estructura.DeleteItem(ll_handle)
		
	//**********************
	//   Zonas Comerciales
	//**********************
	case 4 
		ls_zona = ltvi_item.data
		
		//Obteniendo Vendedor
		ll_vendedor = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
		if tv_estructura.GetItem(ll_vendedor,ltvi_vendedor) = -1 then return
		ls_vendedor = ltvi_vendedor.data
		
		//Obteniendo SubCanal
		ll_sub_canal = tv_estructura.FindItem (ParentTreeItem!, ll_vendedor)
		if tv_estructura.GetItem(ll_sub_canal,ltvi_sub_canal) = -1 then return
		ls_sub_canal = ltvi_sub_canal.data
		
		//Obteniendo Canal
		ll_canal	= tv_estructura.FindItem (ParentTreeItem!, ll_sub_canal)
		if tv_estructura.GetItem(ll_canal,ltvi_canal) = -1 then return
		ls_canal = ltvi_canal.data

		update vendedor
		   set zona_com  = null,
				 canal	  = null,
				 sub_canal = null
	    where zona_com  = :ls_zona;

		 update tt_vendedor
		    set zona_com = null
		  where zona_com = :ls_zona;

		delete from cliente where zona_com = :ls_zona;
			
		//codigo para borrar en tabla direcciones
		declare c_clientes_z cursor for
		select di.codigo
		  from distrito ds, direcciones di
		 where ds.cod_pais = di.cod_pais
		   and ds.cod_dpto = di.cod_dpto
			and ds.cod_prov = di.cod_prov
			and ds.cod_distr = di.cod_distr
			and ds.zona_com  = :ls_zona
			and di.flag_uso  = '1';
			
		open c_clientes_z;
			
		open c_clientes_z;
		fetch c_clientes_z into :ls_cliente;
		DO WHILE sqlca.sqlCode = 0
				
			update direcciones
			   set cod_pais = null,
					 cod_dpto = null,
					 cod_prov = null,
					 cod_distr = null,
					 flag_dir_comercial = null
			 where codigo = :ls_cliente
			   and flag_uso = '1';
				
			FETCH c_clientes_z INTO :ls_cliente;
		LOOP
		close c_clientes_z;
		//fin de borrado a tabla direcciones
			
		update distrito
		   set zona_com = null
		 where zona_com = :ls_zona;
		 
		delete sub_canal_zona
		 where canal = :ls_canal
			and sub_canal = :ls_sub_canal
			and zona_com  = :ls_zona;

		if SQLCA.SQlCode < 0 then
			rollback;
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Zona Comercial')
			return
		else
			commit;
		end if

		tv_estructura.DeleteItem(ll_handle)
		
	//**********************
	//      DISTRITOS
	//**********************
	case 5
		ls_distrito 	  = ltvi_item.data
		ls_desc_distrito = ltvi_item.label
		
		//Obteniendo zona
		ll_zona = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
		if tv_estructura.GetItem(ll_zona,ltvi_zona) = -1 then return
		ls_zona = ltvi_zona.data
		
		//codigo para borrar en tabla direcciones
		declare c_cliente_d cursor for
		select di.codigo
		  from distrito ds, direcciones di
		 where ds.cod_pais = di.cod_pais
		   and ds.cod_dpto = di.cod_dpto
			and ds.cod_prov = di.cod_prov
			and ds.cod_distr = di.cod_distr
			and ds.zona_com  = :ls_zona
			and trim(ds.cod_distr) = trim(:ls_distrito)
			and trim(ds.desc_distrito) = trim(:ls_desc_distrito)
			and di.flag_uso  = '1';
			
		open c_cliente_d;
		fetch c_cliente_d into :ls_cliente;
		DO WHILE sqlca.sqlCode = 0
				
			update direcciones
			   set cod_pais = null,
					 cod_dpto = null,
					 cod_prov = null,
					 cod_distr = null,
					 flag_dir_comercial = null
			 where codigo = :ls_cliente
			   and flag_uso = '1';
			
			delete from cliente where cliente = :ls_cliente;
				
			FETCH c_cliente_d INTO :ls_cliente;
		LOOP
		close c_cliente_d;
		//fin de borrado a tabla direcciones
		
		update distrito
		   set zona_com = null
		 where trim(cod_distr) = trim(:ls_distrito)
		   and trim(desc_distrito) = trim(:ls_desc_distrito)
			and zona_com = :ls_zona;
		
		if SQLCA.SQlCode < 0 then
			rollback;
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Distrito')
			return
		else
			commit;
		end if

		tv_estructura.DeleteItem(ll_handle)
		
	//**********************
	//      CLIENTES
	//**********************
	case 6
		ls_cliente = ltvi_item.data
		
		update direcciones
		   set cod_pais   = null,
				 cod_dpto 	= null,
				 cod_prov	= null,
				 cod_distr	= null,
				 flag_dir_comercial = null
		 where codigo 		= :ls_cliente
		   and flag_uso 	= '1';
		
		delete from cliente where cliente = :ls_cliente;
		
		if SQLCA.SQlCode < 0 then
			rollback;
			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Cliente')
			return
		else
			commit;
		end if		
		
		tv_estructura.DeleteItem(ll_handle)
		
end choose
end event

on w_ve012_zona_comercial_total.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_refrescar=create cb_refrescar
this.tv_estructura=create tv_estructura
this.pb_zona=create pb_zona
this.cb_zona=create cb_zona
this.cb_vendedor=create cb_vendedor
this.cb_distrito=create cb_distrito
this.cb_cliente=create cb_cliente
this.pb_vendedor=create pb_vendedor
this.pb_distrito=create pb_distrito
this.pb_cliente=create pb_cliente
this.tv_distrito=create tv_distrito
this.tv_vendedor=create tv_vendedor
this.cb_mover=create cb_mover
this.st_campo=create st_campo
this.dw_1=create dw_1
this.dw_cliente=create dw_cliente
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refrescar
this.Control[iCurrent+2]=this.tv_estructura
this.Control[iCurrent+3]=this.pb_zona
this.Control[iCurrent+4]=this.cb_zona
this.Control[iCurrent+5]=this.cb_vendedor
this.Control[iCurrent+6]=this.cb_distrito
this.Control[iCurrent+7]=this.cb_cliente
this.Control[iCurrent+8]=this.pb_vendedor
this.Control[iCurrent+9]=this.pb_distrito
this.Control[iCurrent+10]=this.pb_cliente
this.Control[iCurrent+11]=this.tv_distrito
this.Control[iCurrent+12]=this.tv_vendedor
this.Control[iCurrent+13]=this.cb_mover
this.Control[iCurrent+14]=this.st_campo
this.Control[iCurrent+15]=this.dw_1
this.Control[iCurrent+16]=this.dw_cliente
end on

on w_ve012_zona_comercial_total.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_refrescar)
destroy(this.tv_estructura)
destroy(this.pb_zona)
destroy(this.cb_zona)
destroy(this.cb_vendedor)
destroy(this.cb_distrito)
destroy(this.cb_cliente)
destroy(this.pb_vendedor)
destroy(this.pb_distrito)
destroy(this.pb_cliente)
destroy(this.tv_distrito)
destroy(this.tv_vendedor)
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

tv_vendedor.EVENT ue_open_pre()

tv_distrito.EVENT ue_open_pre()

delete from tt_vendedor;

commit;

//Para efectos de insercion de vendedores
insert into tt_vendedor (VENDEDOR, FLAG_ESTADO, SUPERVISOR, CANAL, 
  		 		SUB_CANAL, ZONA_COM, FLAG_REPLICACION)
	  select VENDEDOR, FLAG_ESTADO, SUPERVISOR, CANAL, 
  		 		SUB_CANAL, ZONA_COM, FLAG_REPLICACION
  		 from vendedor;

dw_cliente.retrieve( )
end event

event resize;//Override
tv_estructura.width  = (newwidth  - tv_estructura.x) - 10
tv_estructura.height = (newheight - tv_estructura.y) - 10

cb_mover.height = (newheight - tv_estructura.y) - 10

//Resize y ubicacion de Cliente
cb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)
pb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)

//Resize y ubicacion de Distrito
cb_distrito.y = (cb_cliente.y - cb_distrito.height) - 10 
pb_distrito.y = (cb_cliente.y - cb_distrito.height) - 10 

//Resize y ubicacion de Vendedores
cb_zona.y = (cb_distrito.y - cb_zona.height) - 10
pb_zona.y = (cb_distrito.y - cb_zona.height) - 10

//Resize y ubicacion de DW MASTER
tv_vendedor.height = (cb_zona.y - (cb_vendedor.y - cb_vendedor.height)) - 240

end event

event close;call super::close;DELETE FROM TT_VENDEDOR;
commit;
end event

type dw_master from w_abc_master`dw_master within w_ve012_zona_comercial_total
boolean visible = false
integer x = 37
integer y = 704
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

type cb_refrescar from commandbutton within w_ve012_zona_comercial_total
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
dw_cliente.retrieve( )

delete from tt_vendedor;

commit;

//Para efectos de insercion de vendedores
insert into tt_vendedor (VENDEDOR, FLAG_ESTADO, SUPERVISOR, CANAL, 
  		 		SUB_CANAL, ZONA_COM, FLAG_REPLICACION)
	  select VENDEDOR, FLAG_ESTADO, SUPERVISOR, CANAL, 
  		 		SUB_CANAL, ZONA_COM, FLAG_REPLICACION
  		 from vendedor;
end event

type tv_estructura from u_tv_estructura within w_ve012_zona_comercial_total
event keydown pbm_tvnkeydown
integer x = 1829
integer y = 32
integer width = 1358
integer height = 1828
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
Long				ll_count, ll_NewItem, ll_canal, ll_sub_canal, ll_vendedor, ll_zona
integer		   li_item
String			ls_sub_canal, ls_canal, ls_vendedor, ls_zona, ls_distrito, ls_desc_distrito, &
					ls_aux_1, ls_aux_2, ls_aux_3

//Verificando que se haga el drop sobre un objeto valido
if THIS.GetItem (handle, ltvi_hijo) = -1 then return

choose case source
	
	//=============================================
	//***************** VENDEDORES ****************
	//=============================================
	case tv_vendedor //TreeView de Vendedores
		
		ls_sub_canal = ltvi_hijo.data
		
		//Verificando que Vendedor solamente se ingrese debajo de zonas comerciales
		if ltvi_hijo.level <> 2 then 
			messagebox('Aviso','Los vendedores solamente puede ser ingresados dentro de los Sub Canales')
			THIS.drag(End!)
			return
		end if

		//Obteniendo canal
		ll_canal = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_canal, ltvi_padre) = -1 then return
		ls_canal		 = ltvi_padre.data
		
		//Verificando que Vendedor no Exista en otra parte y que no sea del mismo canal y sub canal
		select nvl(canal,''), nvl(sub_canal,'')
		  into :ls_aux_1, :ls_aux_2
		  from tt_vendedor
		 where vendedor = :is_vendedor;
		
		if ls_canal = trim(ls_aux_1) and ls_sub_canal = trim(ls_aux_2) then
			messagebox('Aviso','Vendedor Ya Existe para Canal y Sub Canal')
			This.Drag(End!)
			return
		
		elseif not( ls_aux_1 = '' or isnull(ls_aux_1) ) then
			messagebox('Aviso','Vendedor Ya Existe en otro Sub - Canal, Eliminelo y Vuelva a Arrastrar!')
			This.Drag(End!)
			return
		
		end if
		
		update tt_vendedor
		   set canal     = :ls_canal,
			    sub_canal = :ls_sub_canal
		 where vendedor  = :is_vendedor;
		
		ltvi_item.PictureIndex = 3
		ltvi_item.selectedpictureindex = 3
		ltvi_item.Children = TRUE 
		ltvi_item.Label = is_desc_vendedor
		ltvi_item.data  = is_vendedor
		ll_NewItem = this.InsertItemLast(handle, ltvi_item)
			
		this.SetDropHighlight (0)
		this.SelectItem(ll_NewItem)
		il_handle = ll_NewItem
		
	//=============================================
	//*********** ZONAS COMERCIALES ***************
	//=============================================
	case dw_master //DataWindow de Zonas

		ls_vendedor = ltvi_hijo.data

		//Verificando que Zonas se ingresen debajo de vendedores
		if ltvi_hijo.level <> 3 then 
			messagebox('Aviso','Las Zonas Comerciales solamente pueden ser ingresadas dentro de los VENDEDORES')
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
		
		select nvl(vendedor,'')
		  into :ls_aux_1
		  from tt_vendedor
		 where zona_com  = :is_cod_zona;
		
		if ls_aux_1 = ls_vendedor then
			MessageBox('Aviso', 'Zona Comercial ya pertenece al Vendedor Actual, Verifique!')
			This.Drag(End!)
			return
		
		elseif ls_aux_1 <> '' then
			MessageBox('Aviso', 'Zona Comercial Ya Tiene Asignado un Vendedor, Verifique!')
			This.Drag(End!)
			return
			
		end if
		
		select nvl(zona_com,'')
		  into :ls_aux_2
		  from tt_vendedor
		 where vendedor = :ls_vendedor;
		
		if ls_aux_2 <> '' then
			MessageBox('Aviso', 'Vendedor ya tiene una zona asignada, eliminela y vuelva a arrastrar, Verifique!')
			This.Drag(End!)
			return
			
		end if
		
		//Tabla de uso para insercion de vendedores
		Update tt_vendedor
		   set canal     = :ls_canal,
			    sub_canal = :ls_sub_canal,
				 zona_com  = :is_cod_zona
		 where vendedor  = :ls_vendedor;

		INSERT INTO sub_canal_zona ( canal, sub_canal, zona_com )  
			  VALUES ( :ls_canal, :ls_sub_canal, :is_cod_zona )  ;

		Update vendedor
		   set canal     = :ls_canal,
			    sub_canal = :ls_sub_canal,
				 zona_com  = :is_cod_zona
		 where vendedor  = :ls_vendedor;

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
	//**************** DISTRITOs ******************
	//=============================================
	case tv_distrito
		ls_zona = ltvi_hijo.data

		//Verificando que Distritos se encuentren debajo de las Zonas
		if ltvi_hijo.level <> 4 then 
			messagebox('Aviso','Los distritos solamente pueden ser ingresados dentro de las Zonas Comerciales')
			THIS.drag(End!)
			return
		end if
		
		//Obteniendo vendedor
		ll_vendedor = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_vendedor, ltvi_padre) = -1 then return
		ls_vendedor = ltvi_padre.data
		
		//Obteniendo sub - canal
		ll_sub_canal = FindItem(ParentTreeItem!, ll_vendedor)
		if this.GetItem(ll_sub_canal, ltvi_padre) = -1 then return
		ls_sub_canal = ltvi_padre.data

		//Obteniendo canal
		ll_canal = FindItem(ParentTreeItem!, ll_sub_canal)
		if this.GetItem(ll_canal, ltvi_padre) = -1 then return
		ls_canal	= ltvi_padre.data
		
		select nvl(zona_com,'')
		  into :ls_aux_1
		  from distrito
		 where cod_pais  = :is_pais
		   and cod_dpto  = :is_dpto
			and cod_prov  = :is_prov
			and cod_distr = :is_distrito;
		
		if ls_aux_1 = ls_zona then
			MessageBox('Aviso', 'Distrito ya Pertenece a la Zona Comercial Actual, Verifique!')
			This.Drag(End!)
			return
			
		elseif ls_aux_1 <> '' then
			MessageBox('Aviso', 'Distrito ya Pertenece a una Zona Comercial, Eliminelo y vuelva a Arrastrar, Verifique!')
			This.Drag(End!)
			return
			
		end if
		
		update distrito
		   set zona_com = :ls_zona
		 where cod_pais  = :is_pais
		   and cod_dpto  = :is_dpto
			and cod_prov  = :is_prov
			and cod_distr = :is_distrito;
		
		IF SQLCA.SQLCODE = 0 THEN
			Commit ;
		
			ltvi_item.PictureIndex = 5
			ltvi_item.selectedpictureindex = 5
			ltvi_item.Children = TRUE 
			ltvi_item.Label = is_desc_distrito
			ltvi_item.data  = is_distrito
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
		ls_distrito      = ltvi_hijo.data
		ls_desc_distrito = ltvi_hijo.label
		
		//Verificando que Distritos se encuentren debajo de las Zonas
		if ltvi_hijo.level <> 5 then 
			messagebox('Aviso','Los clientes solamente pueden ser ingresados dentro de los Distritos')
			THIS.drag(End!)
			return
		end if
		
		//Obteniendo Distrito
		ll_zona = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_zona, ltvi_padre) = -1 then return
		ls_zona = ltvi_padre.data
		
		//Obteniendo vendedor
		ll_vendedor = FindItem(ParentTreeItem!, ll_zona)
		if this.GetItem(ll_vendedor, ltvi_padre) = -1 then return
		ls_vendedor = ltvi_padre.data
		
		//Obteniendo sub - canal
		ll_sub_canal = FindItem(ParentTreeItem!, ll_vendedor)
		if this.GetItem(ll_sub_canal, ltvi_padre) = -1 then return
		ls_sub_canal = ltvi_padre.data

		//Obteniendo canal
		ll_canal = FindItem(ParentTreeItem!, ll_sub_canal)
		if this.GetItem(ll_canal, ltvi_padre) = -1 then return
		ls_canal	= ltvi_padre.data
		
		select nvl(di.cod_distr,'')
		  into :ls_aux_1
		  from distrito ds, direcciones di
		 where ds.cod_pais  = di.cod_pais
		   and ds.cod_dpto  = di.cod_dpto
			and ds.cod_prov  = di.cod_prov
			and ds.cod_distr = di.cod_distr
			and ds.zona_com  = :ls_zona
			and di.codigo	  = :is_proveedor
			and di.flag_uso  = '1'; //direccion de facturacion
		
		if ls_aux_1 = ls_distrito then
			messagebox('Aviso','Este Cliente ya Pertenece a este Distrito, Verifique!')
			this.drag( End! )
			return
			
		elseif ls_aux_1 <> '' then
			messagebox('Aviso','Este Cliente ya Pertenece a otro Distrito, Elimine y Arrastre Denuevo!')
			this.drag( End! )
			return
		
		end if
		
		//Verificando que solamente tenga una direcciones de facturacion
		select count(*)
		  into :ll_count
		  from direcciones 
		 where codigo = :is_proveedor
		   and flag_uso = '1';
		
		if ll_count > 1 then
			
			openwithparm(w_ve012_zona_comercial_direcciones,is_proveedor)
			
			if string(message.stringparm) = '' or isnull(string(message.stringparm)) then
				messagebox('Aviso','Debe de EScoger una direccion de Facturacion')
			end if
			
			li_item = integer(message.stringparm)

		else
			
			select item
			  into :li_item
			  from direcciones 
			 where codigo = :is_proveedor
			   and flag_uso = '1';
			
		end if
		
		delete from cliente where cliente = :is_proveedor;
			
		Insert into cliente (cliente, canal, sub_canal, zona_com)
			  values (:is_proveedor, :ls_canal, :ls_sub_canal, :ls_zona);
		
		select nvl(cod_pais,''), nvl(cod_dpto,''), nvl(cod_prov,'')
		  into :ls_aux_1, :ls_aux_2, :ls_aux_3
		  from distrito
		 where trim(cod_distr)	   = trim(:ls_distrito)
		   and trim(desc_distrito) = trim(:ls_desc_distrito)
			and trim(zona_com)		= trim(:ls_zona);
		
		update direcciones
		   set cod_pais  = :ls_aux_1,
				 cod_dpto  = :ls_aux_2,
				 cod_prov  = :ls_aux_3,
				 cod_distr = :ls_distrito,
				 flag_dir_comercial = '1'
		 where codigo    = :is_proveedor
		   and flag_uso  = '1'
			and item		  = :li_item;
		
		if sqlca.sqlnrows = 0 then
			
			messagebox('Aviso','Cliente No Tiene una Direccion de Facturacion Asignada, ~n Para Continuar se Tiene que Crear una')
			Rollback;
			this.drag( End! )
			return
			
		else
			
			commit;
			
			ltvi_item.PictureIndex = 6
			ltvi_item.selectedpictureindex = 6
			ltvi_item.Children = TRUE 
			ltvi_item.Label = is_desc_proveedor
			ltvi_item.data  = is_proveedor
			ll_NewItem = this.InsertItemLast(handle, ltvi_item)
		
			this.SetDropHighlight (0)
			this.SelectItem(ll_NewItem)
			il_handle = ll_NewItem
			
			dw_cliente.object.flag_dir_comercial[il_row_cliente] = '1'
			
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
long			 ll_canal, ll_sub_canal, ll_rows, ll_vendedor, ll_zona, ll_distrito, ll_cliente
Integer		 li_cnt, li_vendedor, li_zona, li_distrito, li_cliente
string		 ls_canal, ls_sub_canal
TreeViewItem ltvi_new, ltvi_canal, ltvi_vendedor, ltvi_zona, ltvi_distrito, ltvi_cliente
DataStore    lds_zonas, lds_vendedor, lds_distrito, lds_cliente

For li_cnt = 1 To ai_Rows
	THIS.Event ue_Item_set(ai_nivel, li_cnt, ltvi_new)
	
	ll_sub_canal = THIS.InsertItemLast(al_handle, ltvi_New)
	
	IF ll_sub_canal < 1 Then
		MessageBox("Error", "Error al introducir el item (sub - canal)")
		Return -1
		
	else
		//***************************************
		//************* VENDEDORES **************
		//***************************************
		
		//Sub Canal
		ls_sub_canal = ltvi_new.data
		
		//Canal
		ll_canal = FindItem(ParentTreeItem!, ll_sub_canal)
		if this.GetItem(ll_canal, ltvi_canal) = -1 then return(0)
		ls_canal = ltvi_canal.data
		
		//codigo para insertar Vendedores
		lds_vendedor = Create DataStore
		lds_vendedor.DataObject = 'ds_canales_vendedor'
		lds_vendedor.SetTransObject(sqlca)
					
		ll_rows = lds_vendedor.Retrieve(ls_canal, ls_sub_canal)
					
		if ll_rows > 0 then
			ltvi_vendedor.PictureIndex = 3
			ltvi_vendedor.selectedpictureindex = 3
			ltvi_vendedor.Children = true
						
			for li_vendedor = 1 to lds_vendedor.RowCount()
				ltvi_vendedor.Label = lds_vendedor.object.nombre[li_Vendedor]
				ltvi_vendedor.data  = lds_vendedor.object.vendedor[li_Vendedor]
				ll_vendedor = this.InsertItemLast(ll_sub_canal, ltvi_vendedor)
							
				if ll_vendedor < 1 then
					MessageBox("Error","Error al INtroducir el item (Vendedor)")
					return -1
					
				else
					//***************************************
					//**************** ZONAS ****************
					//***************************************
					
					//codigo para insertar Zonas
					lds_zonas = Create DataStore
					lds_zonas.DataObject = 'ds_vendedor_zona'
					lds_zonas.SetTransObject(sqlca)
					
					ll_rows = lds_zonas.Retrieve(lds_vendedor.object.vendedor[li_Vendedor])
					
					if ll_rows > 0 then
						ltvi_zona.PictureIndex = 4
						ltvi_zona.selectedpictureindex = 4
						ltvi_zona.Children = TRUE
						
						for li_zona = 1 to lds_zonas.RowCount()
							ltvi_zona.Label = lds_zonas.object.descripcion[li_zona]
							ltvi_zona.data  = lds_zonas.object.zona_com[li_zona]
							ll_zona = this.InsertItemLast(ll_vendedor, ltvi_zona)
							
							if ll_zona < 1 then
								MessageBox("Error", "Error al introducir el item (zona)")
								Return -1
								
							else
								//***************************************
								//************* DISTRITOS ***************
								//***************************************
								
								//codigo para insertar Distritos
								lds_distrito = Create DataStore
								lds_distrito.DataObject = 'ds_zona_distrito'
								lds_distrito.SetTransObject(sqlca)
								
								ll_rows = lds_distrito.Retrieve(lds_zonas.object.zona_com[li_zona])
								
								if ll_rows > 0 then
									ltvi_distrito.PictureIndex = 5
									ltvi_distrito.selectedpictureindex = 5
									ltvi_distrito.Children = TRUE
									
									for li_distrito = 1 to lds_distrito.Rowcount( )
										ltvi_distrito.label = lds_distrito.object.desc_distrito[li_distrito]
										ltvi_distrito.data  = lds_distrito.object.cod_distr[li_distrito]
										ll_distrito = this.insertitemlast( ll_zona, ltvi_distrito)
										
										if ll_distrito < 1 then
											MessageBox("Error", "Error al introducir el item (Distrito)")
											Return -1
											
										else
											//***************************************
											//************** CLIENTES ***************
											//***************************************
											lds_cliente = Create DataStore
											lds_cliente.DataObject = 'ds_distrito_clientes'
											lds_cliente.SetTransObject(sqlca)
											
											ll_rows = lds_cliente.retrieve(trim(lds_zonas.object.zona_com[li_zona]),trim(lds_distrito.object.cod_distr[li_distrito]))
											
											if ll_rows > 0 then
												ltvi_cliente.pictureindex = 6
												ltvi_cliente.selectedpictureindex = 6
												ltvi_cliente.Children = TRUE
												
												for li_cliente = 1 to lds_cliente.rowcount( )
													ltvi_cliente.label = lds_cliente.object.nom_proveedor[li_cliente]
													ltvi_cliente.data  = lds_cliente.object.codigo[li_cliente]
													ll_cliente = this.insertitemlast( ll_distrito, ltvi_cliente)
													
													if ll_cliente < 1 then
														MessageBox("Error", "Error al introducir el item (Cliente)")
														Return -1
													end if
													
												next
												
											end if
											
											destroy lds_cliente
											
										end if //FIN DE CLIENTES
										
									next
									
								end if
								
								destroy lds_distrito
								
							end if //FIN DE DISTRITOS
							
						next
						
					end if 
					
					destroy lds_zonas
					
				end if //FIN DE ZONAS
							
			next
						
		end if
		
		destroy lds_vendedor
		
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

type pb_zona from picturebutton within w_ve012_zona_comercial_total
integer x = 37
integer y = 576
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

type cb_zona from commandbutton within w_ve012_zona_comercial_total
integer x = 151
integer y = 576
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

tv_vendedor.visible = false
dw_master.visible = true
tv_distrito.visible = false
dw_cliente.visible = false

st_campo.visible = false
dw_1.visible	  = false

cb_zona.y = ( cb_vendedor.y + cb_vendedor.height ) + 10
pb_zona.y = ( cb_vendedor.y + cb_vendedor.height ) + 10

//Resize y ubicacion de Cliente
cb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)
pb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)

//Resize y ubicacion de Distrito
cb_distrito.y = (cb_cliente.y - cb_distrito.height) - 10 
pb_distrito.y = (cb_cliente.y - cb_distrito.height) - 10 

dw_master.y = ( cb_zona.y + cb_zona.height ) + 20

dw_master.height = (cb_distrito.y - (cb_zona.y - cb_zona.height)) - 240
end event

type cb_vendedor from commandbutton within w_ve012_zona_comercial_total
integer x = 151
integer y = 160
integer width = 1536
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Vendedores"
end type

event clicked;is_source = 'V' //Vendedor

changemenu(m_salir)

tv_vendedor.visible = true
dw_master.visible = false
tv_distrito.visible = false
dw_cliente.visible = false

st_campo.visible = false
dw_1.visible	  = false

//Resize y ubicacion de Cliente
cb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)
pb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)

//Resize y ubicacion de Distrito
cb_distrito.y = (cb_cliente.y - cb_distrito.height) - 10 
pb_distrito.y = (cb_cliente.y - cb_distrito.height) - 10 

//Resize y ubicacion de Vendedores
cb_zona.y = (cb_distrito.y - cb_zona.height) - 10
pb_zona.y = (cb_distrito.y - cb_zona.height) - 10

tv_vendedor.height = (cb_zona.y - (cb_vendedor.y - cb_vendedor.height)) - 240
end event

type cb_distrito from commandbutton within w_ve012_zona_comercial_total
integer x = 151
integer y = 1024
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
string text = "Distritos"
end type

event clicked;is_source = 'D' //Distrito

changemenu(m_salir)

tv_vendedor.visible = false
dw_master.visible = false
tv_distrito.visible = true
dw_cliente.visible = false

st_campo.visible = false
dw_1.visible	  = false

cb_zona.y = ( cb_vendedor.y + cb_vendedor.height ) + 10
pb_zona.y = ( cb_vendedor.y + cb_vendedor.height ) + 10

//Resize y ubicacion de Cliente
cb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)
pb_cliente.y = ((tv_estructura.height + tv_estructura.y) - cb_cliente.height)

//Resize y ubicacion de Distrito
cb_distrito.y = (cb_zona.y + cb_zona.height) + 10 
pb_distrito.y = (cb_zona.y + cb_zona.height) + 10 

tv_distrito.y = ( cb_distrito.y + cb_distrito.height ) + 20

tv_distrito.height = (cb_cliente.y - (cb_distrito.y - cb_distrito.height)) - 240
end event

type cb_cliente from commandbutton within w_ve012_zona_comercial_total
integer x = 151
integer y = 1440
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

tv_vendedor.visible = false
dw_master.visible = false
tv_distrito.visible = false
dw_cliente.visible = true

st_campo.visible = true
dw_1.visible	  = true

cb_zona.y = ( cb_vendedor.y + cb_vendedor.height ) + 10
pb_zona.y = ( cb_vendedor.y + cb_vendedor.height ) + 10

//Resize y ubicacion de Distrito
cb_distrito.y = (cb_zona.y + cb_zona.height) + 10 
pb_distrito.y = (cb_zona.y + cb_zona.height) + 10 

//Resize y ubicacion de Cliente
cb_cliente.y = (cb_distrito.y + cb_distrito.height) + 10
pb_cliente.y = (cb_distrito.y + cb_distrito.height) + 10

st_campo.y	 = ( cb_cliente.y + cb_cliente.height ) + 10
dw_1.y	    = ( cb_cliente.y + cb_cliente.height ) + 10

dw_cliente.y = ( st_campo.y + st_campo.height ) + 10
dw_cliente.height = tv_estructura.height - dw_cliente.y
end event

type pb_vendedor from picturebutton within w_ve012_zona_comercial_total
integer x = 37
integer y = 160
integer width = 114
integer height = 100
integer taborder = 30
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

type pb_distrito from picturebutton within w_ve012_zona_comercial_total
integer x = 37
integer y = 1024
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
string picturename = "H:\source\Bmp\distrito.bmp"
alignment htextalign = left!
end type

type pb_cliente from picturebutton within w_ve012_zona_comercial_total
integer x = 37
integer y = 1440
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

type tv_distrito from treeview within w_ve012_zona_comercial_total
event ue_open_pre ( )
event ue_populate ( any aa_codigo,  string as_descripcion )
event type integer ue_item_add ( long al_handle,  integer ai_nivel,  integer ai_rows )
event ue_item_set ( integer ai_nivel,  integer ai_row,  ref treeviewitem atvi_new )
event ue_delete ( )
event ue_insert ( )
boolean visible = false
integer x = 37
integer y = 1152
integer width = 1650
integer height = 260
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
grsorttype sorttype = ascending!
string picturename[] = {"Start!","Start!","Start!","H:\source\Bmp\distrito.bmp"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event ue_open_pre();//Codigo de INicializacion
string ls_cod,ls_desc

declare busqueda CURSOR FOR
 select cod_pais, nom_pais
   from pais;

open busqueda;
FETCH busqueda INTO :ls_cod,:ls_desc;
DO WHILE sqlca.sqlCode = 0

	tv_distrito.EVENT ue_populate(ls_cod,ls_desc)
	
	FETCH busqueda INTO :ls_cod,:ls_desc ;
LOOP
close busqueda;

long ll_handle

ll_handle = finditem(roottreeitem!,0)
this.SelectItem ( ll_handle )
end event

event ue_populate(any aa_codigo, string as_descripcion);Long				ll_handle
TreeViewItem	ltvi_Root

SetPointer(HourGlass!)

// crear datastores para el treeview Vendedores
ids_data_distrito = Create DataStore
ids_data_distrito.DataObject = 'ds_pais_departamento'
ids_data_distrito.SetTransObject(sqlca)

ltvi_Root.Label = as_descripcion
ltvi_Root.Data  = string(aa_codigo)
ltvi_Root.Children = True
ltvi_Root.PictureIndex 			 = 1
ltvi_Root.SelectedPictureIndex = 1

ll_handle = THIS.InsertItemLast(0, ltvi_Root)
THIS.ExpandAll(ll_handle)


end event

event type integer ue_item_add(long al_handle, integer ai_nivel, integer ai_rows);// Introducir los items al treeview
string		 ls_dpto, ls_pais, ls_prov
long		    ll_rows, ll_dpto, ll_pais, ll_prov, ll_distr
Integer		 li_cnt, li_provincia, li_distrito
TreeViewItem ltvi_new, ltvi_pais, ltvi_provincia, ltvi_departamento, ltvi_distrito
datastore	 lds_provincia, lds_distrito

For li_cnt = 1 To ai_Rows
	THIS.Event ue_Item_set(ai_nivel, li_cnt, ltvi_new)
	
	ll_dpto = THIS.InsertItemLast(al_handle, ltvi_New)
	
	IF ll_dpto < 1 Then
		MessageBox("Error", "Error al introducir el item (Departamento)")
		Return -1
		
	else
		//***************************************
		//************* PROVINCIA ***************
		//***************************************
		
		//Departamento
		ls_dpto = ltvi_new.data
		
		//Pais
		ll_pais = FindItem(ParentTreeItem!, ll_dpto)
		if this.GetItem(ll_pais, ltvi_pais) = -1 then return(0)
		ls_pais = ltvi_pais.data
		
		//codigo para insertar Provincia
		lds_provincia = Create DataStore
		lds_provincia.DataObject = 'ds_departamento_provincia'
		lds_provincia.SetTransObject(sqlca)
					
		ll_rows = lds_provincia.Retrieve(ls_pais, ls_dpto)
		
		if ll_rows > 0 then
			ltvi_provincia.PictureIndex = 3
			ltvi_provincia.selectedpictureindex = 3
			ltvi_provincia.Children = true
						
			for li_provincia = 1 to lds_provincia.RowCount()
				ltvi_provincia.Label = lds_provincia.object.desc_prov[li_provincia]
				ltvi_provincia.data  = lds_provincia.object.cod_prov[li_provincia]
				ll_prov = this.InsertItemLast(ll_dpto, ltvi_provincia)
							
				if ll_prov < 1 then
					MessageBox("Error","Error al INtroducir el item (Provincia)")
					return -1
				else
					//***************************************
					//************* DISTRITOS ***************
					//***************************************
					
					//codigo para insertar Distritos
					lds_distrito = Create DataStore
					lds_distrito.DataObject = 'ds_provincia_distrito'
					lds_distrito.SetTransObject(sqlca)
					
					ll_rows = lds_distrito.Retrieve( ls_pais, ls_dpto, lds_provincia.object.cod_prov[li_provincia] )
					
					if ll_rows > 0 then
						ltvi_distrito.PictureIndex = 4
						ltvi_distrito.selectedpictureindex = 4
						ltvi_distrito.Children = true
						
						for li_distrito = 1 to lds_distrito.rowcount()
							ltvi_distrito.Label = lds_distrito.object.desc_distrito[li_distrito]
							ltvi_distrito.data  = lds_distrito.object.cod_distr[li_distrito]
							ll_distr = this.InsertItemLast(ll_prov, ltvi_distrito)
							
							if ll_prov < 1 then
								MessageBox("Error","Error al INtroducir el item (Provincia)")
								return -1
								
							end if
							
						next
						
					end if
					
					destroy lds_distrito
					
				end if//FIN DE DISTRITOS
				
			next
			
		end if
		
		destroy lds_provincia
		
	End If //FIN DE PROVINCIA
	
Next

Return ai_Rows
end event

event ue_item_set(integer ai_nivel, integer ai_row, ref treeviewitem atvi_new);//Codigo para setear nuevo item
string 	ls_cod_hijo, ls_desc_hijo

ls_cod_hijo  = trim(ids_Data_distrito.Object.cod_dpto[ai_Row])
ls_desc_hijo = trim(ids_Data_distrito.Object.desc_dpto[ai_Row])

atvi_New.Label = ls_desc_hijo
atvi_New.Data  = ls_cod_hijo

atvi_New.Children = True

atvi_New.PictureIndex 			= 2
atvi_New.SelectedPictureIndex = 2 
end event

event ue_delete();//Borrar handle
string ls_zona

if il_nivel = 3 or il_nivel = 2 then
	messagebox('Aviso','No se pueden eliminar Provincias, solamente distritos por medidas de seguridad')
	return
end if

if messagebox('Pregunta','Desea eliminar este Item?', Question!, YesNo!, 1) = 2 then return

select nvl(zona_com ,'')
  into :ls_zona
  from distrito
 where cod_pais = :is_pais
   and cod_dpto = :is_dpto
	and cod_prov = :is_prov
	and cod_distr = :is_distrito;

if ls_zona <> '' then
	messagebox('Aviso','Este Distrito ya ha sido asignado a una Zona, ~n por lo tanto no se puede eliminar')
	return
end if

delete from distrito
 where cod_pais = :is_pais
   and cod_dpto = :is_dpto
	and cod_prov = :is_prov
	and cod_distr = :is_distrito;

if sqlca.sqlcode = 0 then
	commit;
else
	rollback;
	messagebox('Error',string(sqlca.sqlcode)+' - ' +sqlca.sqlerrtext)
	return
end if

//Borrar del TreeView
this.deleteitem( il_handle )
end event

event ue_insert();//Codigo de insercion
str_parametros sgt_parametros
string ls_cod, ls_desc
long	 ll_handle
treeviewitem ltvi_item

choose case il_nivel
		
	case 1//departamento
		
		sgt_parametros.dw_master = 'ds_pais_departamento'
		
	case 2//provincia
		
		sgt_parametros.dw_master = 'ds_departamento_provincia'
		
	case 3//distrito
		
		sgt_parametros.dw_master = 'ds_provincia_distrito'
		
	case else
		
		messagebox('Aviso','Solamente se puede hacer el ingreso de Distritos')
		return
		
end choose

sgt_parametros.long1   = il_nivel
sgt_parametros.string1 = is_pais
sgt_parametros.string2 = is_dpto
sgt_parametros.string3 = is_prov

openwithparm(w_ve012_zona_comercial_popup, sgt_parametros)

if isvalid(Message.POWEROBJECTPARM) then
	
	sgt_parametros = Message.POWEROBJECTPARM
	
	ls_cod  = trim(sgt_parametros.string1)
	ls_desc = trim(sgt_parametros.string2)
	
	ltvi_item.label = ls_desc
	ltvi_item.data  = ls_cod
	ltvi_item.pictureindex = ( il_nivel + 1 )
	ltvi_item.selectedpictureindex = ( il_nivel + 1 )
	ltvi_item.Children = true
	
	this.insertitemlast( il_handle, ltvi_item)
	this.selectitem( il_handle )
		
end if
end event

event itempopulate;// Poblar el arbol con sus hijos
Integer			li_next
Long				ll_rows
string			ls_parm
TreeViewItem	ltvi_nivel

SetPointer(HourGlass!)

THIS.GetItem(handle, ltvi_nivel)

//solamente departamentos
if ltvi_nivel.level >= 2 then return

li_next = ltvi_nivel.Level + 1       // Determinar el nivel siguiente

ls_parm = string(ltvi_nivel.Data)

ll_Rows = ids_Data_distrito.Retrieve(ls_parm)

THIS.Event ue_item_add(handle, li_next, ll_Rows)
end event

event clicked;//para senalizar el item a dropear
THIS.SetDropHighlight(handle)

end event

event begindrag;treeviewitem ltvi_source, ltvi_padre
long ll_prov, ll_dpto, ll_pais

if this.GetItem(handle, ltvi_Source) = -1 then return

//Evita que sea pais, dpto y provincia
If ltvi_Source.Level <> 4 Then
	This.Drag(Cancel!)
	
Else
	this.Drag(Begin!)
	
	//Obteniendo provincia
	ll_prov = FindItem(ParentTreeItem!, handle)
	if this.GetItem(ll_prov, ltvi_padre) = -1 then return
	is_prov	= ltvi_padre.data //Variable que va al TV_ESTRUCTURA para el DROP
	
	//Obteniendo departamento
	ll_dpto = FindItem(ParentTreeItem!, ll_prov)
	if this.GetItem(ll_dpto, ltvi_padre) = -1 then return
	is_dpto = ltvi_padre.data //Variable que va al TV_ESTRUCTURA para el DROP
	
	//Obteniendo pais
	ll_pais = FindItem(ParentTreeItem!, ll_dpto)
	if this.GetItem(ll_pais, ltvi_padre) = -1 then return
	is_pais = ltvi_padre.data //Variable que va al TV_ESTRUCTURA para el DROP
	
	is_distrito      = ltvi_source.data
	is_desc_distrito = ltvi_source.label

end if


end event

event rightclicked;treeviewitem ltvi_item, ltvi_padre
long ll_prov, ll_dpto, ll_pais

//Codigo para mantenimiento
THIS.SetDropHighlight(handle)

this.getitem( handle, ltvi_item)

il_handle = handle
il_nivel  = ltvi_item.level

/* Evita que se modifiquen los paises (ROOT) y por seguridad
de datos ya que estos mantenimientos se encuentran en el 
modulo de recursos Humanos solamente se dejara manipular
los distritos */
if il_nivel = 1 then
	return
end if

//*******************************************
//Obteniendo pais, dpto, provincia y distrito 
//*******************************************
setnull(is_pais) ; setnull(is_dpto)
setnull(is_prov) ; setnull(is_distrito)

choose case il_nivel
		
	case 2 //Departamento
		
		is_dpto = ltvi_item.data
		
		//Obteniendo pais
		ll_pais = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_pais, ltvi_padre) = -1 then return
		is_pais = ltvi_padre.data
		
	case 3 //Provincia
		
		is_prov = ltvi_item.data
		
		//Obteniendo departamento
		ll_dpto = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_dpto, ltvi_padre) = -1 then return
		is_dpto = ltvi_padre.data
				
		//Obteniendo pais
		ll_pais = FindItem(ParentTreeItem!, ll_dpto)
		if this.GetItem(ll_pais, ltvi_padre) = -1 then return
		is_pais = ltvi_padre.data
		
	case 4 //Distrito
		
		is_distrito = ltvi_item.data
		
		//Obteniendo provincia
		ll_prov = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_prov, ltvi_padre) = -1 then return
		is_prov	= ltvi_padre.data
	
		//Obteniendo departamento
		ll_dpto = FindItem(ParentTreeItem!, ll_prov)
		if this.GetItem(ll_dpto, ltvi_padre) = -1 then return
		is_dpto = ltvi_padre.data
				
		//Obteniendo pais
		ll_pais = FindItem(ParentTreeItem!, ll_dpto)
		if this.GetItem(ll_pais, ltvi_padre) = -1 then return
		is_pais = ltvi_padre.data
				
	case else
				
		return
		
end choose

gtv_actual = this

//Displaya menu contextual
menu lm_rbuton
lm_rbuton = CREATE m_rbutton_tv_distritos
lm_rbuton.popmenu(w_main.PointerX(),w_main.Pointery())
end event

type tv_vendedor from treeview within w_ve012_zona_comercial_total
event ue_open_pre ( )
event ue_populate ( any aa_codigo,  string as_descripcion )
event ue_item_set ( integer ai_nivel,  integer ai_row,  ref treeviewitem atvi_new )
event type integer ue_item_add ( long al_handle,  integer ai_nivel,  integer ai_rows )
integer x = 37
integer y = 288
integer width = 1650
integer height = 260
integer taborder = 30
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

event clicked;//para senalizar el item a dropear
THIS.SetDropHighlight(handle)

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

type cb_mover from commandbutton within w_ve012_zona_comercial_total
integer x = 1719
integer y = 32
integer width = 78
integer height = 1828
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
	
	pb_vendedor.visible = false
	cb_vendedor.visible = false
	tv_vendedor.visible = false
	
	pb_zona.visible = false
	cb_zona.visible = false
	dw_master.visible = false
	
	pb_distrito.visible = false
	cb_distrito.visible = false
	tv_distrito.visible = false
	
	pb_cliente.visible = false
	cb_cliente.visible = false
	dw_cliente.visible = false
	
	this.x = 37
	tv_estructura.x = (37+110)
	
	tv_estructura.width = parent.width - ( this.x + 150 )
	
else
	
	THIS.TExt = '<'
	
	cb_refrescar.visible = true
	
	pb_vendedor.visible = true
	cb_vendedor.visible = true
	
	pb_zona.visible = true
	cb_zona.visible = true
	
	pb_distrito.visible = true
	cb_distrito.visible = true
	
	pb_cliente.visible = true
	cb_cliente.visible = true
		
	if is_source = 'V' then
		tv_vendedor.visible = true
		
	elseif is_source = 'Z' then
		dw_master.visible = true
		
	elseif is_source = 'D' then
		tv_distrito.visible = true
		
	elseif is_source = 'C' then
		dw_cliente.visible = true
		
	end if
	
	this.x = 1719
	tv_estructura.x = (1719+110)
	
	tv_estructura.width = parent.width - ( this.x + 150 )
	
end if
end event

type st_campo from statictext within w_ve012_zona_comercial_total
boolean visible = false
integer x = 37
integer y = 1560
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

type dw_1 from datawindow within w_ve012_zona_comercial_total
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
boolean visible = false
integer x = 750
integer y = 1560
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

type dw_cliente from u_dw_abc within w_ve012_zona_comercial_total
boolean visible = false
integer x = 37
integer y = 1664
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

