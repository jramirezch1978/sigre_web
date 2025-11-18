$PBExportHeader$w_ve015_cliente_distrito.srw
forward
global type w_ve015_cliente_distrito from w_abc_master
end type
type cb_cliente from commandbutton within w_ve015_cliente_distrito
end type
type pb_cliente from picturebutton within w_ve015_cliente_distrito
end type
type tv_distrito from treeview within w_ve015_cliente_distrito
end type
type st_campo from statictext within w_ve015_cliente_distrito
end type
type dw_1 from datawindow within w_ve015_cliente_distrito
end type
type cb_refrescar from commandbutton within w_ve015_cliente_distrito
end type
end forward

global type w_ve015_cliente_distrito from w_abc_master
integer width = 3255
integer height = 1392
string title = "]VE015] Distritos por Clientes"
string menuname = "m_salir"
windowstate windowstate = maximized!
event ue_delete_tv ( )
cb_cliente cb_cliente
pb_cliente pb_cliente
tv_distrito tv_distrito
st_campo st_campo
dw_1 dw_1
cb_refrescar cb_refrescar
end type
global w_ve015_cliente_distrito w_ve015_cliente_distrito

type variables
Long	  il_handle = 0, il_nivel = 1, il_row_cliente

Integer ii_ik[]
str_parametros ist_datos

//Variables usadas para el drag & drop
string is_vendedor, is_desc_vendedor, is_cod_zona, is_desc_zona, &
		 is_pais, is_dpto, is_prov, is_distrito, is_desc_distrito, &
		 is_source = 'V', is_proveedor, is_desc_proveedor, is_col, is_cliente, is_distr

//Variable usada en la lista de vendedores para arrastrar
datastore ids_data_vendedor, ids_data_distrito
end variables

event ue_delete_tv();//treeviewitem ltvi_item, ltvi_sub_canal, ltvi_canal, ltvi_vendedor, ltvi_zona, ltvi_distrito
//string		 ls_sub_canal, ls_canal, ls_vendedor, ls_zona, ls_distrito, ls_desc_distrito, ls_cliente
//long			 ll_sub_canal, ll_canal, ll_vendedor, ll_zona, ll_distrito, ll_handle
//
//if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return
//
//ll_handle = tv_estructura.FindItem (CurrentTreeItem!, 0)
//if tv_estructura.GetItem (ll_handle, ltvi_item) = -1 then return
//
//choose case ltvi_item.level
//	
//	//**********************
//	//      Vendedores
//	//**********************
//	case 3
//		ls_vendedor = ltvi_item.data
//		
//		//Obteniendo SubCanal
//		ll_sub_canal = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
//		if tv_estructura.GetItem(ll_sub_canal,ltvi_sub_canal) = -1 then return
//		ls_sub_canal = ltvi_sub_canal.data
//		
//		//Obteniendo Canal
//		ll_canal	= tv_estructura.FindItem (ParentTreeItem!, ll_sub_canal)
//		if tv_estructura.GetItem(ll_canal,ltvi_canal) = -1 then return
//		ls_canal = ltvi_canal.data
//		
//		select nvl(zona_com,'')
//		  into :ls_zona
//		  from vendedor
//		 where vendedor = :ls_vendedor;
//		
//		if ls_zona <> '' then
//		
//			update vendedor
//				set zona_com  = null,
//					 canal	  = null,
//					 sub_canal = null
//			 where vendedor  = :ls_vendedor;
//			 
//			update tt_vendedor
//				set zona_com  = null,
//					 canal	  = null,
//					 sub_canal = null
//			 where vendedor  = :ls_vendedor;
//			 
//			delete from cliente where zona_com = :ls_zona;
//			
//			//codigo para borrar en tabla direcciones
//			declare c_clientes_v cursor for
//			select di.codigo
//			  from distrito ds, direcciones di
//			 where ds.cod_pais = di.cod_pais
//			   and ds.cod_dpto = di.cod_dpto
//				and ds.cod_prov = di.cod_prov
//				and ds.cod_distr = di.cod_distr
//				and ds.zona_com  = :ls_zona
//				and di.flag_uso  = '1';
//			
//			open c_clientes_v;
//			
//			open c_clientes_v;
//			fetch c_clientes_v into :ls_cliente;
//			DO WHILE sqlca.sqlCode = 0
//				
//				update direcciones
//				   set cod_pais = null,
//						 cod_dpto = null,
//						 cod_prov = null,
//						 cod_distr = null,
//						 flag_dir_comercial = null
//				 where codigo = :ls_cliente
//				   and flag_uso = '1';
//				
//				FETCH c_clientes_v INTO :ls_cliente;
//			LOOP
//			close c_clientes_v;
//			//fin de borrado a tabla direcciones
//			
//			update distrito
//		   	set zona_com = null
//		 	 where zona_com = :ls_zona;
//			
//			delete sub_canal_zona
//			 where canal 	  = :ls_canal
//				and sub_canal = :ls_sub_canal
//				and zona_com  = :ls_zona;
//			  
//		else
//			
//			update tt_vendedor
//				set zona_com  = null,
//					 canal	  = null,
//					 sub_canal = null
//			 where vendedor  = :ls_vendedor;
//			 
//		end if
//		
//		if SQLCA.SQlCode < 0 then
//			rollback;
//			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Vendedor')
//			return
//		else
//			commit;
//		end if
//		
//		tv_estructura.DeleteItem(ll_handle)
//		
//	//**********************
//	//   Zonas Comerciales
//	//**********************
//	case 4 
//		ls_zona = ltvi_item.data
//		
//		//Obteniendo Vendedor
//		ll_vendedor = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
//		if tv_estructura.GetItem(ll_vendedor,ltvi_vendedor) = -1 then return
//		ls_vendedor = ltvi_vendedor.data
//		
//		//Obteniendo SubCanal
//		ll_sub_canal = tv_estructura.FindItem (ParentTreeItem!, ll_vendedor)
//		if tv_estructura.GetItem(ll_sub_canal,ltvi_sub_canal) = -1 then return
//		ls_sub_canal = ltvi_sub_canal.data
//		
//		//Obteniendo Canal
//		ll_canal	= tv_estructura.FindItem (ParentTreeItem!, ll_sub_canal)
//		if tv_estructura.GetItem(ll_canal,ltvi_canal) = -1 then return
//		ls_canal = ltvi_canal.data
//
//		update vendedor
//		   set zona_com  = null,
//				 canal	  = null,
//				 sub_canal = null
//	    where zona_com  = :ls_zona;
//
//		 update tt_vendedor
//		    set zona_com = null
//		  where zona_com = :ls_zona;
//
//		delete from cliente where zona_com = :ls_zona;
//			
//		//codigo para borrar en tabla direcciones
//		declare c_clientes_z cursor for
//		select di.codigo
//		  from distrito ds, direcciones di
//		 where ds.cod_pais = di.cod_pais
//		   and ds.cod_dpto = di.cod_dpto
//			and ds.cod_prov = di.cod_prov
//			and ds.cod_distr = di.cod_distr
//			and ds.zona_com  = :ls_zona
//			and di.flag_uso  = '1';
//			
//		open c_clientes_z;
//			
//		open c_clientes_z;
//		fetch c_clientes_z into :ls_cliente;
//		DO WHILE sqlca.sqlCode = 0
//				
//			update direcciones
//			   set cod_pais = null,
//					 cod_dpto = null,
//					 cod_prov = null,
//					 cod_distr = null,
//					 flag_dir_comercial = null
//			 where codigo = :ls_cliente
//			   and flag_uso = '1';
//				
//			FETCH c_clientes_z INTO :ls_cliente;
//		LOOP
//		close c_clientes_z;
//		//fin de borrado a tabla direcciones
//			
//		update distrito
//		   set zona_com = null
//		 where zona_com = :ls_zona;
//		 
//		delete sub_canal_zona
//		 where canal = :ls_canal
//			and sub_canal = :ls_sub_canal
//			and zona_com  = :ls_zona;
//
//		if SQLCA.SQlCode < 0 then
//			rollback;
//			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Zona Comercial')
//			return
//		else
//			commit;
//		end if
//
//		tv_estructura.DeleteItem(ll_handle)
//		
//	//**********************
//	//      DISTRITOS
//	//**********************
//	case 5
//		ls_distrito 	  = ltvi_item.data
//		ls_desc_distrito = ltvi_item.label
//		
//		//Obteniendo zona
//		ll_zona = tv_estructura.FindItem (ParentTreeItem!, ll_handle)
//		if tv_estructura.GetItem(ll_zona,ltvi_zona) = -1 then return
//		ls_zona = ltvi_zona.data
//		
//		//codigo para borrar en tabla direcciones
//		declare c_cliente_d cursor for
//		select di.codigo
//		  from distrito ds, direcciones di
//		 where ds.cod_pais = di.cod_pais
//		   and ds.cod_dpto = di.cod_dpto
//			and ds.cod_prov = di.cod_prov
//			and ds.cod_distr = di.cod_distr
//			and ds.zona_com  = :ls_zona
//			and trim(ds.cod_distr) = trim(:ls_distrito)
//			and trim(ds.desc_distrito) = trim(:ls_desc_distrito)
//			and di.flag_uso  = '1';
//			
//		open c_cliente_d;
//		fetch c_cliente_d into :ls_cliente;
//		DO WHILE sqlca.sqlCode = 0
//				
//			update direcciones
//			   set cod_pais = null,
//					 cod_dpto = null,
//					 cod_prov = null,
//					 cod_distr = null,
//					 flag_dir_comercial = null
//			 where codigo = :ls_cliente
//			   and flag_uso = '1';
//			
//			delete from cliente where cliente = :ls_cliente;
//				
//			FETCH c_cliente_d INTO :ls_cliente;
//		LOOP
//		close c_cliente_d;
//		//fin de borrado a tabla direcciones
//		
//		update distrito
//		   set zona_com = null
//		 where trim(cod_distr) = trim(:ls_distrito)
//		   and trim(desc_distrito) = trim(:ls_desc_distrito)
//			and zona_com = :ls_zona;
//		
//		if SQLCA.SQlCode < 0 then
//			rollback;
//			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Distrito')
//			return
//		else
//			commit;
//		end if
//
//		tv_estructura.DeleteItem(ll_handle)
//		
//	//**********************
//	//      CLIENTES
//	//**********************
//	case 6
//		ls_cliente = ltvi_item.data
//		
//		update direcciones
//		   set cod_pais   = null,
//				 cod_dpto 	= null,
//				 cod_prov	= null,
//				 cod_distr	= null,
//				 flag_dir_comercial = null
//		 where codigo 		= :ls_cliente
//		   and flag_uso 	= '1';
//		
//		delete from cliente where cliente = :ls_cliente;
//		
//		if SQLCA.SQlCode < 0 then
//			rollback;
//			MessageBox('Aviso', string(sqlca.sqlcode)+' '+sqlca.sqlerrtext+' '+'Error al Eliminar Cliente')
//			return
//		else
//			commit;
//		end if		
//		
//		tv_estructura.DeleteItem(ll_handle)
//		
//end choose
end event

on w_ve015_cliente_distrito.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cb_cliente=create cb_cliente
this.pb_cliente=create pb_cliente
this.tv_distrito=create tv_distrito
this.st_campo=create st_campo
this.dw_1=create dw_1
this.cb_refrescar=create cb_refrescar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cliente
this.Control[iCurrent+2]=this.pb_cliente
this.Control[iCurrent+3]=this.tv_distrito
this.Control[iCurrent+4]=this.st_campo
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.cb_refrescar
end on

on w_ve015_cliente_distrito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_cliente)
destroy(this.pb_cliente)
destroy(this.tv_distrito)
destroy(this.st_campo)
destroy(this.dw_1)
destroy(this.cb_refrescar)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()

tv_distrito.EVENT ue_open_pre()


end event

event resize;//Override
tv_distrito.width  = (newwidth  - tv_distrito.x) - 10
tv_distrito.height = (newheight - tv_distrito.y) - 10

dw_master.height = (newheight - dw_master.y) - 10

end event

type dw_master from w_abc_master`dw_master within w_ve015_cliente_distrito
integer x = 37
integer y = 384
integer width = 1650
integer height = 708
string dragicon = "H:\source\Ico\row2.ico"
string dataobject = "d_cns_cliente"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

settransobject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_ss = 1 

idw_mst  = 	dw_master

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::clicked;call super::clicked;If row = 0 then return // si el click no ha sido a un registro retorna

// Iniciar el Drag and drop
this.drag(begin!)

// Conseguir la llave del registro
is_proveedor  		= this.object.cliente[row]
is_desc_proveedor = this.object.nom_proveedor[row]
il_row_cliente	= row
end event

event dw_master::doubleclicked;//Override
Integer li_pos, li_col, j
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

type cb_cliente from commandbutton within w_ve015_cliente_distrito
integer x = 151
integer y = 160
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

type pb_cliente from picturebutton within w_ve015_cliente_distrito
integer x = 37
integer y = 160
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

type tv_distrito from treeview within w_ve015_cliente_distrito
event ue_open_pre ( )
event ue_populate ( any aa_codigo,  string as_descripcion )
event type integer ue_item_add ( long al_handle,  integer ai_nivel,  integer ai_rows )
event ue_item_set ( integer ai_nivel,  integer ai_row,  ref treeviewitem atvi_new )
event ue_delete ( )
event ue_insert ( )
integer x = 1719
integer y = 32
integer width = 1431
integer height = 1060
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
boolean linesatroot = true
boolean disabledragdrop = false
boolean trackselect = true
grsorttype sorttype = ascending!
string picturename[] = {"Start!","Start!","Start!","H:\source\Bmp\distrito.bmp","H:\source\Gif\cliente_distrito.gif"}
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
long		    ll_rows, ll_dpto, ll_pais, ll_prov, ll_distr, ll_cliente
Integer		 li_cnt, li_provincia, li_distrito, li_cliente
TreeViewItem ltvi_new, ltvi_pais, ltvi_provincia, ltvi_departamento, ltvi_distrito, ltvi_cliente
datastore	 lds_provincia, lds_distrito, lds_cliente

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
								
							else
								//***************************************
								//************* CLIENTES ****************
								//***************************************
								
								//codigo para insertar Clientes
								lds_cliente = Create DataStore
								lds_cliente.DataObject = 'ds_distrito_clientes_2'
								lds_cliente.SetTransObject(sqlca)
								
								ll_rows = lds_cliente.retrieve( ls_pais, ls_dpto, lds_provincia.object.cod_prov[li_provincia], lds_distrito.object.cod_distr[li_distrito] )
								
								if ll_rows > 0 then
									ltvi_cliente.pictureindex = 5
									ltvi_cliente.selectedpictureindex = 5
									ltvi_cliente.children = true
									
									for li_cliente = 1 to lds_cliente.rowcount( )
										ltvi_cliente.label = trim(lds_cliente.object.nom_proveedor[li_cliente])
										ltvi_cliente.data  = lds_cliente.object.codigo[li_cliente]
										ll_cliente = this.insertitemlast(ll_distr, ltvi_cliente)
										
										if ll_cliente < 1 then
											messagebox('Error','Error al Introducir el item (cliente)')
											return -1
										end if
										
									next
									
								end if
								
								destroy lds_cliente
								
							end if // FIN DE CLIENTES 
							
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
	messagebox('Aviso','No se pueden eliminar Provincias, solamente distritos o clientes por medidas de seguridad')
	return
end if

if messagebox('Pregunta','Desea eliminar este Item?', Question!, YesNo!, 1) = 2 then return

if il_nivel = 4 then //Borrando Distritos

	update direcciones
	   set cod_pais = null,
		 	 cod_dpto = null, 
			 cod_prov = null,
			 cod_distr = null,
			 flag_dir_comercial = null
	 where cod_pais = :is_pais
		and cod_dpto = :is_dpto
		and cod_prov = :is_prov
		and cod_distr = :is_distrito;
	
	delete from distrito
	 where cod_pais = :is_pais
		and cod_dpto = :is_dpto
		and cod_prov = :is_prov
		and cod_distr = :is_distrito;

	if sqlca.sqlcode = 0 then
		commit;
		dw_master.retrieve( )
	else
		rollback;
		messagebox('Error',string(sqlca.sqlcode)+' - ' +sqlca.sqlerrtext)
		return
	end if
	
elseif il_nivel = 5 then
	
	update direcciones
	   set cod_pais = null,
		 	 cod_dpto = null, 
			 cod_prov = null,
			 cod_distr = null,
			 flag_dir_comercial = null
	 where codigo = :is_cliente;
	
	if sqlca.sqlcode = 0 then
		commit;
		dw_master.retrieve( )
	else
		rollback;
		messagebox('Error',string(sqlca.sqlcode)+' - ' +string(sqlca.sqlerrtext))
		return
	end if
	
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
		
		messagebox('Aviso','Solamente se puede hacer el ingreso de Departamentos, Provincias o Distritos')
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

il_handle = handle
end event

event begindrag;This.Drag(Cancel!)

end event

event rightclicked;treeviewitem ltvi_item, ltvi_padre
long ll_prov, ll_dpto, ll_pais, ll_distr

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
		
	case 5
		
		is_cliente = ltvi_item.data
		
		//Obteniendo distrito
		ll_distr = FindItem(ParentTreeItem!, handle)
		if this.GetItem(ll_distr, ltvi_padre) = -1 then return
		is_distr	= ltvi_padre.data
		
		//Obteniendo provincia
		ll_prov = FindItem(ParentTreeItem!, ll_distr)
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

event dragdrop;integer 		 li_item
long			 ll_pais, ll_dpto, ll_prov, ll_distr, ll_count, ll_newitem
string		 ls_pais, ls_dpto, ls_prov, ls_distr, ls_aux_1
treeviewitem ltvi_padre, ltvi_hijo, ltvi_item

//Verificando que se haga el drop sobre un objeto valido
if THIS.GetItem (handle, ltvi_hijo) = -1 then return

ls_distr = ltvi_hijo.data

//Verificando que Distritos se encuentren debajo de las Zonas
if ltvi_hijo.level <> 4 then 
	messagebox('Aviso','Los clientes solamente pueden ser ingresados dentro de los Distritos')
	THIS.drag(End!)
	return
end if

//Obteniendo Provincia
ll_prov = FindItem(ParentTreeItem!, handle)
if this.GetItem(ll_prov, ltvi_padre) = -1 then return
ls_prov = ltvi_padre.data

//Obteniendo Departamento
ll_dpto = FindItem(ParentTreeItem!, ll_prov)
if this.GetItem(ll_dpto, ltvi_padre) = -1 then return
ls_dpto = ltvi_padre.data

//Obteniendo sub - canal
ll_pais = FindItem(ParentTreeItem!, ll_dpto)
if this.GetItem(ll_pais, ltvi_padre) = -1 then return
ls_pais = ltvi_padre.data

select nvl(di.cod_distr,'')
  into :ls_aux_1
  from direcciones di
 where di.codigo	  = :is_proveedor
	and di.flag_uso  = '1'
	and di.flag_dir_comercial = '1'; //direccion de facturacion

if ls_aux_1 = ls_distr then
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

update direcciones
   set cod_pais  = :ls_pais,
		 cod_dpto  = :ls_dpto,
		 cod_prov  = :ls_prov,
		 cod_distr = :ls_distr
 where codigo    = :is_proveedor
   and flag_uso  = '1';

if sqlca.sqlnrows > 0 then
	commit;
else
	messagebox('Aviso','Cliente No Tiene una Direccion de Facturacion Asignada, ~n Para Continuar se Tiene que Crear una')
	Rollback;
	this.drag( End! )
	return
end if

update direcciones
   set flag_dir_comercial = '1'
 where codigo   = :is_proveedor
   and flag_uso = '1'
	and item		 = :li_item;

if sqlca.sqlnrows = 0 then
	messagebox('Aviso','Cliente No Tiene una Direccion de Facturacion Asignada, ~n Para Continuar se Tiene que Crear una')
	Rollback;
	this.drag( End! )
	return
			
else
			
	commit;
			
	ltvi_item.PictureIndex = 5
	ltvi_item.selectedpictureindex = 5
	ltvi_item.Children = TRUE 
	ltvi_item.Label = trim(is_desc_proveedor)
	ltvi_item.data  = is_proveedor
	ll_NewItem = this.InsertItemLast(handle, ltvi_item)
		
	this.SetDropHighlight (0)
	this.SelectItem(ll_NewItem)
	il_handle = ll_NewItem
	
	dw_master.object.dir[il_row_cliente] = 1
	
end if
end event

event dragwithin;this.SetDropHighlight(handle)

end event

type st_campo from statictext within w_ve015_cliente_distrito
integer x = 37
integer y = 280
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

type dw_1 from datawindow within w_ve015_cliente_distrito
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 750
integer y = 280
integer width = 937
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_master.triggerevent(doubleclicked!)
Return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_master.Getrow()

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
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			this.setfocus()
		end if
	End if	
end if

SetPointer(arrow!)
end event

type cb_refrescar from commandbutton within w_ve015_cliente_distrito
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

event clicked;long ll_handle

do while tv_distrito.FindItem(RootTreeItem!, 0) > 0
	
	ll_handle = tv_distrito.FindItem(RootTreeItem!, 0)
	tv_distrito.DeleteItem(ll_handle)
	
loop

tv_distrito.event ue_open_pre()

dw_master.retrieve()
end event

