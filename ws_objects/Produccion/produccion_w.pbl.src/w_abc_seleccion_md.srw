$PBExportHeader$w_abc_seleccion_md.srw
$PBExportComments$Seleccion con master detalle
forward
global type w_abc_seleccion_md from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_md
end type
type dw_master from u_dw_abc within w_abc_seleccion_md
end type
type uo_search from n_cst_search within w_abc_seleccion_md
end type
end forward

global type w_abc_seleccion_md from w_abc_list
integer x = 539
integer y = 364
integer width = 3895
integer height = 2428
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
dw_master dw_master
uo_search uo_search
end type
global w_abc_seleccion_md w_abc_seleccion_md

type variables
String is_col = '', is_tipo
integer ii_ik[]
str_parametros ist_datos
Boolean ib_sel = false
Datastore ids_art_a_vender
end variables

forward prototypes
public function boolean of_opcion2 ()
public function boolean of_opcion3 ()
public function boolean of_opcion4 ()
end prototypes

public function boolean of_opcion2 ();Long 		ll_j, ll_row
u_dw_abc  ldw_detail

// Asigna datos a ldw master
ldw_detail = ist_datos.dw_d

For ll_j = 1 to dw_2.RowCount()						
	ll_row = ldw_detail.event dynamic ue_insert()
	IF ll_row > 0 THEN
		ldw_detail.Object.ap_nro_parte     [ll_row] = dw_2.Object.nro_parte	   	[ll_j]				
		ldw_detail.Object.ap_nro_item      [ll_row] = dw_2.Object.item	 	   		[ll_j]
		ldw_detail.Object.nom_proveedor    [ll_row] = dw_2.object.nom_proveedor		[ll_j]				
		ldw_detail.Object.inicio_descarga  [ll_row] = dw_2.Object.inicio_descarga  [ll_j]
		ldw_detail.Object.descr_especie	  [ll_row] = dw_2.Object.descr_especie		[ll_j]				
		ldw_detail.Object.peso_neto	 	  [ll_row] = dw_2.Object.peso_neto			[ll_j]				
		ldw_detail.Object.nro_placa	 	  [ll_row] = dw_2.Object.nro_placa			[ll_j]				
		ldw_detail.Object.observacion 	  [ll_row] = 'NINGUNA'
	end if
NEXT

return true
end function

public function boolean of_opcion3 ();Long 			ll_j, ll_row
u_dw_abc  	ldw_detail, ldw_master
decimal		ldc_monto

// Asigna datos a ldw master
ldw_detail = ist_datos.dw_d
ldw_master = ist_datos.dw_m

ldc_monto = 0
For ll_j = 1 to dw_2.RowCount()						
	ll_row = ldw_detail.event dynamic ue_insert()
	IF ll_row > 0 THEN
		ldw_detail.Object.codigo_cu	[ll_row] = dw_2.Object.codigo_cu	[ll_j]				
		ldw_detail.Object.cod_Art		[ll_row] = dw_2.Object.cod_art	[ll_j]
		ldw_detail.Object.desc_art		[ll_row] = dw_2.Object.desc_art	[ll_j]
		ldw_detail.Object.nro_pallet	[ll_row] = dw_2.Object.nro_pallet[ll_j]
		
		ldc_monto += Dec(dw_2.Object.peso_prom[ll_j])
	end if
NEXT

ldw_master.object.cant_recibida [1] = ldc_monto
return true
end function

public function boolean of_opcion4 ();Long 			ll_j, ll_row
u_dw_abc  	ldw_detail, ldw_master
decimal		ldc_monto

// Asigna datos a ldw master
ldw_detail = ist_datos.dw_d
ldw_master = ist_datos.dw_m

ldc_monto = 0
For ll_j = 1 to dw_2.RowCount()						
	ll_row = ldw_detail.event dynamic ue_insert()
	IF ll_row > 0 THEN
		ldw_detail.Object.codigo_cu	[ll_row] = dw_2.Object.codigo_cu			[ll_j]				
		ldw_detail.Object.cod_Art		[ll_row] = dw_2.Object.cod_art			[ll_j]
		ldw_detail.Object.desc_art		[ll_row] = dw_2.Object.desc_art			[ll_j]
		ldw_detail.Object.peso_prom	[ll_row] = dw_2.Object.cant_procesada	[ll_j]
		
		ldc_monto += Dec(dw_2.Object.cant_procesada[ll_j])
	end if
NEXT

ldw_master.object.cantidad 	[1] = ldc_monto
ldw_master.object.nro_Cajas 	[1] = ldw_detail.Rowcount()
return true
end function

on w_abc_seleccion_md.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.dw_master=create dw_master
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.uo_search
end on

on w_abc_seleccion_md.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.dw_master)
destroy(this.uo_search)
end on

event ue_open_pre;Long ll_row

ii_access = 1   // sin menu

// Recoge parametro enviado
is_tipo 					= ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1

uo_search.of_set_dw(dw_master)

//**DataStore de Artciuclos Por Orden de Venta**//
ids_art_a_vender            = Create DataStore
ids_art_a_vender.DataObject = 'd_tt_fin_art_a_vender_tbl'
ids_art_a_vender.Settransobject(sqlca)
//****//

dw_master.SetTransObject(SQLCA)
dw_1.SetTransObject		(SQLCA)
dw_2.SetTransObject		(SQLCA)	

IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1O'
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '1S'
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '1S2S'
			ll_row = dw_master.Retrieve(ist_datos.string1, ist_datos.string2)
		CASE '11' //**Orden de Compra (Cuentas x Pagar)**/
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '12' //**Orden de Servicio (Cuentas x Pagar)**/
			ll_row = dw_master.Retrieve(ist_datos.string1)		
		CASE '1D2D'	
			ll_row = dw_master.Retrieve(ist_datos.fecha1, ist_datos.fecha2)		
	END CHOOSE
END IF
	
This.Title = ist_datos.titulo


end event

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - 10
dw_1.height 		= newheight - dw_1.y - 10
dw_1.width			= newwidth/2 - dw_1.x - pb_1.width/2 - 20

dw_2.x				= newwidth/2 + pb_1.width/2 + 20
dw_2.height 		= newheight - dw_2.y - 10
dw_2.width   		= newwidth  - dw_2.x - 10

pb_1.x				= newwidth/2 - pb_1.width/2
pb_2.x				= newwidth/2 - pb_2.width/2

cb_transferir.x	= newwidth - cb_transferir.width - 10
uo_search.width 	= cb_transferir.x - 10 - uo_Search.x

uo_Search.event ue_resize(sizetype, cb_transferir.x - 10 - uo_Search.x, newheight)
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 812
integer width = 1362
integer height = 808
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0
end event

event dw_1::ue_selected_row_pro;Long	  ll_row, ll_rc
Any	  la_id
Integer li_x, li_totcol


if dw_2.RowCount() > 0 and ist_datos.opcion = 1 then
	MessageBox('Aviso', 'no puede seleccionar mas de un concepto financiero', StopSign!)
	return
end if

ll_row = dw_2.EVENT ue_insert()

// Esta opcion es mas general
li_totcol = Integer(this.Describe("DataWindow.Column.Count"))
	
FOR li_x = 1 to li_totcol
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT




end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)


Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row;//Overriding

Long	ll_row, ll_y

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.EVENT ue_selected_row_pro(ll_row)
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.EVENT ue_selected_row_pos()


end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1573
integer y = 812
integer width = 1362
integer height = 808
integer taborder = 60
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
CHOOSE CASE ist_datos.opcion 
		 CASE 1 //Guias de Remision
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_rk[4] = 4
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				ii_dk[4] = 4
		CASE 2,3,4,5,8 //Concepto Financiero
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				
		
		CASE	9							  //Articulo Movimiento Proyectado	
				ii_rk[1]  = 1				// Deploy key
				ii_rk[2]  = 2				
				ii_rk[3]  = 3				
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6			
				ii_rk[7]  = 7
				ii_rk[8]  = 8				
				ii_rk[9]  = 9				
				ii_rk[10] = 10
				ii_rk[11] = 11
				
				ii_dk[1]  = 1				
				ii_dk[2]  = 2				
				ii_dk[3]  = 3				
				ii_dk[4]  = 4								
				ii_dk[5]  = 5				
				ii_dk[6]  = 6			
				ii_dk[7]  = 7
				ii_dk[8]  = 8				
				ii_dk[9]  = 9				
				ii_dk[10] = 10
				ii_dk[11] = 11
		CASE	10							  //Articulo Movimiento Proyectado
											  //x Orden de Compra
			   ii_rk[1]  = 1 			  //Codigo de Articulo
			  	ii_rk[2]  = 2 			  //Nombre de Articulo
				ii_rk[3]  = 5			  //Codigo de Moneda	  
				ii_rk[4]	 = 6			  //Precio Unitario
				ii_rk[5]  = 7			  //Cantidad Pendiente
				ii_rk[6]  = 8			  //Centro de Costo
				ii_rk[7]	 = 9			  //Cuenta Presupuestal
				
				ii_dk[1]  = 1				
				ii_dk[2]  = 2				
				ii_dk[3]  = 5				
				ii_dk[4]  = 6				
				ii_dk[5]  = 7								
				ii_dk[6]  = 8				
				ii_dk[7]  = 9				
		CASE 	11								//Orden de Servicio Detalle (Cuentas x Pagar)			
			
				ii_rk[1]  = 3 				//Nro Item
				ii_rk[2]  = 7				//Descripción
				ii_rk[3]  = 8				//Importe
				ii_rk[4]  = 11				//Cencos
				ii_rk[5]  = 13				//Cuenta Presupuestal
				
				ii_dk[1]  = 3 				//Nro Item
				ii_dk[2]  = 7				//Descripción
				ii_dk[3]  = 8				//Importe
				ii_dk[4]  = 11				//Cencos
				ii_dk[5]  = 13				//Cuenta Presupuestal
END CHOOSE
end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x, li_totcol

ll_row = idw_det.EVENT ue_insert()

// Esta opcion es mas general
li_totcol = Integer(this.Describe("DataWindow.Column.Count"))
	
FOR li_x = 1 to li_totcol
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT



end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1399
integer y = 1044
integer taborder = 40
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1390
integer y = 1232
integer taborder = 50
end type

type cb_transferir from commandbutton within w_abc_seleccion_md
integer x = 2939
integer width = 338
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;// Transfiere campos 
long ll_count_det, ll_row

CHOOSE CASE ist_datos.opcion
	CASE 1		//CASO PARTICULAR DE CONFIN
			
		ll_count_det = dw_2.Rowcount()
		IF ll_count_det > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		ELSE
		
			IF ll_count_det = 1 THEN
				ll_row = ist_datos.dw_m.GetRow()
				IF ll_row = 0 THEN RETURN
				ist_datos.dw_m.object.confin 		  	[ll_row] = dw_2.Object.confin		  [1]
				ist_datos.dw_m.object.desc_confin 	[ll_row] = dw_2.Object.descripcion [1]
				ist_datos.titulo = 's'
			END IF
		END IF
	
	CASE 2  // Orden de compra Pendientes/consignacion	
		if of_opcion2() then
			ist_datos.Titulo = 's'
		else
			return
		end if
			   	
	CASE 3  // Parte de Recepcion
		if of_opcion3() then
			ist_datos.Titulo = 's'
		else
			return
		end if
	
			   	
	CASE 4  // Parte de Transferencia
		if of_opcion4() then
			ist_datos.Titulo = 's'
		else
			return
		end if
END CHOOSE

CloseWithReturn( parent, ist_datos)
end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 88
integer width = 3040
integer height = 704
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form

end event

event clicked;call super::clicked;// Muestra detalle
	
IF row > 0 THEN
	CHOOSE CASE ist_datos.opcion 
		CASE 1
			IF dw_2.Rowcount() = 0 THEN
				dw_1.Retrieve(this.object.grupo[row])
			ELSE
				Messagebox( "Error", "no puede seleccionar otro documento", Exclamation!)
			END IF

		CASE 2
			dw_1.Retrieve(ist_datos.fecha1, ist_datos.fecha2, this.object.proveedor[row])
			
		CASE 3
			dw_1.Retrieve(this.object.almacen_pptt[row], this.object.nro_pallet[row])
			
		CASE 4
			dw_1.Retrieve(this.object.almacen[row], this.object.nro_pallet[row], this.object.cod_art[row])
	END CHOOSE
END IF

end event

type uo_search from n_cst_search within w_abc_seleccion_md
event destroy ( )
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

