$PBExportHeader$w_al762_consulta_detalle.srw
forward
global type w_al762_consulta_detalle from w_abc_master_smpl
end type
type cb_cerrar from commandbutton within w_al762_consulta_detalle
end type
type cb_grabar from commandbutton within w_al762_consulta_detalle
end type
end forward

global type w_al762_consulta_detalle from w_abc_master_smpl
integer width = 3593
integer height = 2380
string title = "[AL762] Modificacion de datos por almacen / articulo"
string menuname = "m_impresion"
windowstate windowstate = maximized!
cb_cerrar cb_cerrar
cb_grabar cb_grabar
end type
global w_al762_consulta_detalle w_al762_consulta_detalle

type variables
str_parametros istr_param
end variables

on w_al762_consulta_detalle.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_cerrar=create cb_cerrar
this.cb_grabar=create cb_grabar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cerrar
this.Control[iCurrent+2]=this.cb_grabar
end on

on w_al762_consulta_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_cerrar)
destroy(this.cb_grabar)
end on

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

ib_update_check = true

end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0 

istr_param = Message.PowerObjectParm

if this.is_flag_modificar = '0' and this.is_flag_eliminar = '0' then
	cb_grabar.enabled = false
	
else
	cb_grabar.enabled = true
	
end if




this.event ue_refresh( )



end event

event ue_refresh;call super::ue_refresh;dw_master.Retrieve(istr_param.string1, istr_param.string2, istr_param.string3)

//dw_master.ii_protect = 1



//this.event ue_modify( )

if this.is_flag_modificar = '0' then
	
	//Bloqueo las columnas
	dw_master.object.fec_registro.protect 		= '1'
	dw_master.object.nro_pallet.protect 		= '1'
	dw_master.object.fila.protect 				= '1'
	dw_master.object.columna.protect 			= '1'
	dw_master.object.anaquel.protect 			= '1'
	dw_master.object.cus.protect 					= '1'
	dw_master.object.nro_lote.protect 			= '1'
	dw_master.object.cant_procesada.protect	= '1'
	dw_master.object.cant_proc_und2.protect 	= '1'
else
	
	//Las columnas deben estar activas
	dw_master.object.fec_registro.protect 		= '0'
	dw_master.object.nro_pallet.protect 		= '0'
	dw_master.object.fila.protect 				= '0'
	dw_master.object.columna.protect 			= '0'
	dw_master.object.anaquel.protect 			= '0'
	dw_master.object.cus.protect 					= '0'
	dw_master.object.nro_lote.protect 			= '0'
	dw_master.object.cant_procesada.protect	= '0'
	dw_master.object.cant_proc_und2.protect 	= '0'
end if

if this.is_flag_eliminar = '0' then
	//Bloqueo el boton de eliminar
	dw_master.object.b_eliminar_vale.enabled 	= '0'
else
	//el boton de eliminar esta activo
	dw_master.object.b_eliminar_vale.enabled 	= '1'
end if
end event

type dw_master from w_abc_master_smpl`dw_master within w_al762_consulta_detalle
integer y = 116
integer width = 3520
integer height = 2056
string dataobject = "d_abc_detalle_movimiento_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
end event

event dw_master::ue_display;call super::ue_display;string 	ls_almacen, ls_nro_Vale, ls_mensaje
Long		ll_row
choose case lower(as_columna)
		
	case "almacen"

		ls_almacen 	= this.object.almacen 	[al_row]
		ls_nro_vale = this.object.nro_vale 	[al_row]
		
		ls_almacen = gnvo_app.of_get_message( "Escriba el almacen", ls_almacen)
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then return
		
		update vale_mov vm
		   set vm.almacen = :ls_almacen
		where vm.nro_Vale = :ls_nro_vale;
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			rollback;
			MessageBox('Error', 'Ha ocurrido un error: ' + ls_mensaje, StopSign!)
			return
		end if
		
		commit;
		
		for ll_row = 1 to this.RowCount() 
			if this.object.nro_Vale [ll_Row] = ls_nro_Vale then
				this.object.almacen [ll_row] = ls_almacen
			end if
		next
		
		this.Sort()
		this.groupcalc( )
		
		
	

end choose



end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::buttonclicked;call super::buttonclicked;Str_parametros		lstr_param
string				ls_almacen, ls_nro_pallet, ls_org_am, ls_org_mov_proy, ls_mensaje, ls_nro_vale
Long					ll_nro_am, ll_nro_mov_proy, ll_row, ll_deleted_rows

choose case lower(dwo.name)
	
		
	case "b_enlazar"
		
		ls_nro_pallet 	= this.object.nro_pallet	[row]
		ls_almacen		= this.object.almacen		[row]	 	
		
		ls_org_am		= this.object.cod_origen	[row]
		ll_nro_am		= Long(this.object.nro_mov	[row])
		//

		lstr_param.dw1      		= 'd_lista_cus_pallet_pendientes_tbl'
		lstr_param.titulo    	= 'Lista de CUS pendientes'
		lstr_param.tipo		 	= '1S2S'     // con un parametro del tipo string
		lstr_param.string1   	= ls_nro_pallet
		lstr_param.string2	 	= ls_almacen
		lstr_param.string3		= ls_org_am
		lstr_param.long1			= ll_nro_am
		lstr_param.dw_d			= dw_master
		lstr_param.opcion    	= 13

		OpenWithParm( w_abc_seleccion, lstr_param)

	case "b_eliminar"
		
		if MessageBox('Informacion', 'Desea eliminar el registro?', Information!, YesNo!, 2) = 2 then return
		
		
		ls_org_mov_proy 	= this.object.origen_mov_proy	[row]
		ll_nro_mov_proy 	= this.object.nro_mov_proy		[row]
		
		ls_org_am		 	= this.object.cod_origen		[row]
		ll_nro_am		 	= Long(this.object.nro_mov		[row])
		
		//Actualizo la cantidad procesada e ingresada en cero
	
		update articulo_mov_proy amp
			set amp.cant_facturada = 0
		where amp.cod_origen = :ls_org_mov_proy
		  and amp.nro_mov		= :ll_nro_mov_proy;
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCa.SQLErrText
			rollback;
			gnvo_app.of_mensaje_error( "Error al ejecutar al actualizar articulo_mov_proy: " + ls_mensaje)
			return
		end if
		
		//Elimino el item innecesario
		delete articulo_mov am
		where am.cod_origen 	= :ls_org_am
		  and am.nro_mov		= :ll_nro_am;
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCa.SQLErrText
			rollback;
			gnvo_app.of_mensaje_error( "Error al eliminar articulo_mov: " + ls_mensaje)
			return
		end if
		
		commit;
		
		this.deleteRow( row )
		  
		f_mensaje("Eliminacion realizada correctamente", "")

	case "b_eliminar_vale"
		
		ls_nro_vale = this.object.nro_vale [row]
		
		if MessageBox('Informacion', 'Desea eliminar el vale ' + ls_nro_vale + '?', Information!, YesNo!, 2) = 2 then return
		
		ll_deleted_rows = 0
		
		for ll_row = 1 to this.RowCount()
			if this.object.nro_vale [ll_Row] = ls_nro_vale then
				ls_org_mov_proy 	= this.object.origen_mov_proy	[ll_Row]
				ll_nro_mov_proy 	= this.object.nro_mov_proy		[ll_Row]
				
				ls_org_am		 	= this.object.cod_origen		[ll_Row]
				ll_nro_am		 	= Long(this.object.nro_mov		[ll_Row])
				
				//Actualizo la cantidad procesada e ingresada en cero
			
				update articulo_mov_proy amp
					set amp.cant_facturada = 0
				where amp.cod_origen = :ls_org_mov_proy
				  and amp.nro_mov		= :ll_nro_mov_proy;
				
				if SQLCA.SQLCode = -1 then
					ls_mensaje = SQLCa.SQLErrText
					rollback;
					gnvo_app.of_mensaje_error( "Error al ejecutar al actualizar articulo_mov_proy: " + ls_mensaje)
					return
				end if
				
				//Elimino el item innecesario
				delete articulo_mov am
				where am.cod_origen 	= :ls_org_am
				  and am.nro_mov		= :ll_nro_am;
				
				if SQLCA.SQLCode = -1 then
					ls_mensaje = SQLCa.SQLErrText
					rollback;
					gnvo_app.of_mensaje_error( "Error al eliminar articulo_mov: " + ls_mensaje)
					return
				end if
				
				commit;				
			end if

		next
		
		ll_row = this.Find("nro_vale='" + ls_nro_vale + "'", 1, this.RowCount())
		
		DO WHILE ll_row > 0
			this.deleterow( ll_row )
			ll_row = this.Find("nro_vale='" + ls_nro_vale + "'", 1, this.RowCount())
		LOOP
  
		

		
		f_mensaje("Eliminacion realizada correctamente", "")
		
		
end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_anaquel, ls_nro_vale
Long 		ll_row

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'anaquel'
		
		if MessageBox('Aviso', 'Desea colocar el mismo anaquel ' + data + ' a todos los registros', Information!, Yesno!, 2) = 2 then return
		
		for ll_row = 1 to this.RowCount()
			this.object.anaquel [ll_row] = data
		next

	CASE 'fila'
		
		if MessageBox('Aviso', 'Desea colocar la misma fila ' + data + ' a todos los registros', Information!, Yesno!, 2) = 2 then return
		
		for ll_row = 1 to this.RowCount()
			this.object.fila [ll_row] = data
		next
		
	CASE 'columna'
		
		if MessageBox('Aviso', 'Desea colocar la misma columna ' + data + ' a todos los registros', Information!, Yesno!, 2) = 2 then return
		
		for ll_row = 1 to this.RowCount()
			this.object.columna [ll_row] = data
		next

	CASE 'cant_proc_und2'
		
		if MessageBox('Aviso', 'Desea colocar el mismo dato en todos los registros ' + data + ' a todos los registros', Information!, Yesno!, 2) = 2 then return
		
		ls_nro_vale = this.object.nro_Vale [row]
		
		for ll_row = 1 to this.RowCount()
			if this.object.nro_vale [ll_row] = ls_nro_Vale then
				this.object.cant_proc_und2 [ll_row] = Dec(data)
			end if
		next	
		
	CASE 'cant_procesada'
		
		if MessageBox('Aviso', 'Desea colocar el mismo dato en todos los registros ' + data + ' a todos los registros', Information!, Yesno!, 2) = 2 then return
		
		ls_nro_vale = this.object.nro_Vale [row]
		
		for ll_row = 1 to this.RowCount()
			if this.object.nro_vale [ll_row] = ls_nro_Vale then
				this.object.cant_procesada [ll_row] = Dec(data)
			end if
		next		
END CHOOSE
end event

type cb_cerrar from commandbutton within w_al762_consulta_detalle
integer x = 407
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
boolean cancel = true
end type

event clicked;Close(parent)

end event

type cb_grabar from commandbutton within w_al762_consulta_detalle
integer width = 402
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar"
boolean cancel = true
end type

event clicked;Parent.event ue_update( )
end event

