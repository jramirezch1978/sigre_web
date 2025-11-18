$PBExportHeader$w_ve014_vendedor.srw
forward
global type w_ve014_vendedor from w_abc_master
end type
type dw_almacen_venta from u_dw_abc within w_ve014_vendedor
end type
type st_1 from statictext within w_ve014_vendedor
end type
type st_2 from statictext within w_ve014_vendedor
end type
end forward

global type w_ve014_vendedor from w_abc_master
integer width = 3547
integer height = 2680
string title = "[VE014] Maestro de vendedores"
string menuname = "m_mantenimiento_sl"
event ue_delete_tv ( )
dw_almacen_venta dw_almacen_venta
st_1 st_1
st_2 st_2
end type
global w_ve014_vendedor w_ve014_vendedor

type variables
Long	 il_handle = 0
long	 il_DragSource, il_DragParent //Variables usadas para el Drag&Drop dentro del TREEVIEW
string is_col, is_tipo
string is_cod_lista, is_desc_lista
end variables

event ue_delete_tv();//treeviewitem ltvi_item, ltvi_padre
//DataStore	 lds_data
//long			 ll_current_handle, ll_i
//string		 ls_codigo, ls_hijo
//
//if MessageBox('Aviso', 'Desea eliminar este item?', Information!, YesNo!, 2) = 2 then return
//
//ll_current_handle = tv_estructura.FindItem (CurrentTreeItem!, 0)
//
//if tv_estructura.GetItem (ll_current_handle, ltvi_item) = -1 then return
//ls_codigo = ltvi_item.data
//
//if tv_estructura.FindItem (ChildTreeItem!, ll_current_handle) <> -1 then 
//	
//	// Si es un padre entonces debo borrar en casacada
//	if MessageBox('Aviso', 'Se procedera a Borrar todos los Vendedores de Este Supervisor, Continuar?', &
//		Question!, YesNo!, 2) = 1 then
//		
//			lds_data = create datastore
//			lds_data.DataObject = 'ds_estructura_vendedor'
//			lds_data.SetTransObject(SQLCA)
//			lds_data.Retrieve(ls_codigo)
//		
//			for ll_i = 1 to lds_data.RowCount()
//			
//				ls_hijo 	= lds_data.object.vendedor[ll_i]
//			
//				update vendedor
//				   set supervisor = null
//				 where vendedor = :ls_hijo;
//			
//				if SQLCA.SQlCode < 0 then
//					ROLLBACK;
//					MessageBox('Error al eliminar item', sqlca.sqlerrtext)
//					return
//				end if
//			
//				Commit;
//
//			next
//		
//			update vendedor
//		      set supervisor = null
//			 where vendedor = :ls_codigo;
//			 
//		   if SQLCA.SQlCode < 0 then
//				ROLLBACK;
//				MessageBox('Error al eliminar item', sqlca.sqlerrtext)
//				return
//			end if
//			
//			destroy lds_data
//
//	end if
//
//else
//
//	update vendedor
//	   set supervisor = null
//	 where vendedor = :ls_codigo;
//			 
//	if SQLCA.SQlCode < 0 then
//	   ROLLBACK;
// 		MessageBox('Error al eliminar item', sqlca.sqlerrtext)
//		return
//	end if
//	
//end if	
//
//commit;
//
//tv_estructura.DeleteItem(ll_current_handle)
end event

on w_ve014_vendedor.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_almacen_venta=create dw_almacen_venta
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_almacen_venta
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
end on

on w_ve014_vendedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_almacen_venta)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()


dw_almacen_venta.setTransObject(SQLCA)
end event

event resize;//Override
dw_master.width  	= newwidth  - dw_master.x
st_1.width  		= dw_master.width

st_2.y 				= newheight * 0.60
st_2.width  		= dw_master.width
dw_master.height	= st_2.y - dw_master.y - 10

dw_almacen_venta.y 		= st_2.y + st_2.height + 10
dw_almacen_venta.width	= newWidth - dw_almacen_venta.x - 10
dw_almacen_venta.height	= newHeight - dw_almacen_venta.y - 10
end event

type dw_master from w_abc_master`dw_master within w_ve014_vendedor
integer y = 100
integer width = 3483
integer height = 1020
string dragicon = "H:\source\Ico\row2.ico"
string dataobject = "d_abc_vendedor_tbl"
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_data

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

CHOOSE CASE lower(dwo.name)
	case 'vendedor'
		
		select nombre
		  into :ls_data
		  from usuario
		 where cod_usr = :data;
		
		IF SQLCA.SQLCODE = 100 then
			return 1
		end if
		
		this.object.nom_vendedor[row] = ls_data
		
	CASE 'cod_trabajador'

		SELECT nom_trabajador 
			INTO :ls_data
		FROM vw_pr_trabajador
   	WHERE cod_trabajador = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 THEN
			Messagebox('Aviso','Codigo de trabajador no existe o no se encuenta activo, por favor verifique!', StopSign!)
				
			this.Object.cod_trabajador	[row] = gnvo_app.is_null
			this.object.nom_trabajador	[row] = gnvo_app.is_null
			this.setcolumn( "cod_trabajador" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		this.object.nom_trabajador [row] = ls_data
		
	CASE 'cod_origen'

		SELECT nombre 
			INTO :ls_data
		FROM origen
   	WHERE cod_origen = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 THEN
			Messagebox('Aviso','Codigo de Origen/Sucursal no existe o no se encuenta activo, por favor verifique!', StopSign!)
				
			this.Object.cod_origen	[row] = gnvo_app.is_null
			this.object.nom_origen	[row] = gnvo_app.is_null
			this.setcolumn( "cod_origen" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		this.object.nom_origen [row] = ls_data

	CASE 'supervisor'

		SELECT nom_vendedor 
			INTO :ls_data
		FROM vendedor
   	WHERE vendedor = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 THEN
			Messagebox('Aviso','Codigo de Origen/Sucursal no existe o no se encuenta activo, por favor verifique!', StopSign!)
				
			this.Object.supervisor		[row] = gnvo_app.is_null
			this.object.nom_supervisor	[row] = gnvo_app.is_null
			this.setcolumn( "supervisor" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		this.object.nom_supervisor [row] = ls_data

		
END CHOOSE

end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "vendedor"
		ls_sql = "select u.cod_usr as codigo_usuario, " &
				 + "u.nombre as nom_usuario " &
				 + "from usuario u " &
				 + "where u.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.vendedor			[al_row] = ls_codigo
			this.object.nom_vendedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_trabajador"
		ls_sql = "select m.COD_TRABAJADOR as codigo_trabajador, " &
				 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
				 + "m.NRO_DOC_IDENT_RTPS as dni " &
				 + "from vw_pr_trabajador m " &
				 + "where m.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_origen"
		ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
				  + "nombre AS descripcion_origen " &
				  + "FROM origen " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.nom_origen	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "supervisor"
		ls_sql = "select v.vendedor as vendedor, " &
				 + "v.nom_vendedor as nombre_vendedor " &
				 + "from vendedor v " &
				 + "where v.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.supervisor		[al_row] = ls_codigo
			this.object.nom_supervisor	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::ue_output;call super::ue_output;if al_row = 0 then return

dw_almacen_venta.Retrieve(this.object.vendedor [al_row])
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_almacen_venta from u_dw_abc within w_ve014_vendedor
integer y = 1220
integer width = 2935
integer height = 832
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_almacen_venta_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;
is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr [al_row] = dw_master.object.vendedor [dw_master.GetRow()]
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_data2
choose case lower(as_columna)
	case "almacen"
		ls_sql = "select al.almacen as almacen, " &
				 + "al.desc_almacen as descripcion_almacen, " &
				 + "al.cod_origen as cod_origen " &
				 + "from almacen al " &
				 + "where al.flag_estado = '1' " &
				 + "  and al.flag_tipo_almacen = 'T'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			this.object.almacen			[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.object.cod_origen		[al_row] = ls_data2
			this.ii_update = 1
		end if
		
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_data2

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

CHOOSE CASE lower(dwo.name)
	case 'almacen'
		
		select desc_almacen, cod_origen
		  into :ls_data, :ls_data2
		  from almacen
		 where almacen = :data
		   and flag_estado = '1';
		
		IF SQLCA.SQLCODE = 100 THEN
			Messagebox('Aviso','Almacen ' + data + ' no existe o no se encuenta activo, por favor verifique!', StopSign!)
				
			this.Object.almacen			[row] = gnvo_app.is_null
			this.object.desc_almacen	[row] = gnvo_app.is_null
			this.object.cod_origen		[row] = gnvo_app.is_null
			this.setcolumn( "almacen" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		this.object.desc_almacen[row] = ls_data
		this.object.cod_origen	[row] = ls_data2
		
	
END CHOOSE

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type st_1 from statictext within w_ve014_vendedor
integer width = 3049
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Maestro de Vendedores"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ve014_vendedor
integer y = 1120
integer width = 3049
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Almacén por defecto (para Ventas)"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

