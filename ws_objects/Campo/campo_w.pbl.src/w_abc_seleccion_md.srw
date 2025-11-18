$PBExportHeader$w_abc_seleccion_md.srw
$PBExportComments$Seleccion con master detalle
forward
global type w_abc_seleccion_md from w_abc_list
end type
type st_campo from statictext within w_abc_seleccion_md
end type
type dw_text from datawindow within w_abc_seleccion_md
end type
type cb_1 from commandbutton within w_abc_seleccion_md
end type
type dw_master from u_dw_abc within w_abc_seleccion_md
end type
end forward

global type w_abc_seleccion_md from w_abc_list
integer x = 539
integer y = 364
integer width = 2990
integer height = 2112
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_text dw_text
cb_1 cb_1
dw_master dw_master
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
public function integer of_opcion15 ()
end prototypes

public function integer of_opcion15 ();Long 		ll_row_mas, ll_row, ll_j, ll_count
u_dw_abc ldw_master, ldw_detail

ldw_master = ist_datos.dw_m
ldw_detail = ist_datos.dw_d

ll_row_mas = ldw_master.GetRow()
if ll_row_mas = 0 then return 0

For ll_j = 1 to dw_2.RowCount()
				 
	ll_row = ldw_detail.event dynamic ue_insert()
	
	if ll_row > 0 then	
		ldw_detail.object.nro_test					[ll_row] = ldw_master.object.nro_test			[ll_row_mas]
		ldw_detail.object.cod_modulo				[ll_row] = dw_2.object.cod_modulo				[ll_j]
		ldw_detail.object.desc_modulo				[ll_row] = dw_2.object.desc_modulo				[ll_j]
		ldw_detail.object.cod_req					[ll_row] = dw_2.object.cod_req					[ll_j]
		ldw_detail.object.desc_nivel_pregunta	[ll_row] = dw_2.object.desc_nivel_pregunta	[ll_j]
		ldw_detail.object.criterio						[ll_row] = dw_2.object.criterio						[ll_j]
		ldw_detail.object.flag_pregunta			[ll_row] = dw_2.object.flag_pregunta				[ll_j]
		ldw_detail.object.id_req						[ll_row] = dw_2.object.id_req						[ll_j]
		ldw_detail.object.flag_si						[ll_row] = '0'
		ldw_detail.object.flag_no						[ll_row] = '0'
		ldw_detail.object.flag_na						[ll_row] = '0'
		ldw_detail.ii_update = 1
		
	end if
	ldw_detail.GroupCalc()
	
Next

return 1
end function

on w_abc_seleccion_md.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_text=create dw_text
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_abc_seleccion_md.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre;Long ll_row

ii_access = 1   // sin menu

// Recoge parametro enviado
is_tipo 					= ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1

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
			 CASE '11' //**Orden de Compra (Cuentas x Pagar)**///
					ll_row = dw_master.Retrieve(ist_datos.string1)
			 CASE '12' //**Orden de Servicio (Cuentas x Pagar)**//
					ll_row = dw_master.Retrieve(ist_datos.string1)		
  		 	 CASE	'13' //**Detalle de Warrant Pendientes**//
					ll_row = dw_master.Retrieve(ist_datos.string1)		
			CASE '15' // Guia de Recepción de Materia Prima
				  ll_row = dw_master.Retrieve(ist_datos.string1)
	END CHOOSE
END IF
	
This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col

end event

event open;//override
THIS.EVENT ue_open_pre()

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

pb_1.x = newwidth / 2 - pb_1.width/2
pb_2.x = newwidth / 2 - pb_2.width/2

//dw_master.width  = newwidth  - dw_master.x - 10

dw_1.height = newheight - dw_1.y - 10
dw_1.width  = newwidth/2 - pb_1.width/2 - 10

dw_2.height = newheight - dw_2.y - 10
dw_2.x  = newwidth/2 + pb_1.width/2 + 10
dw_2.width  = newwidth  - dw_2.x - 10

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 956
integer width = 1362
integer height = 808
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

CHOOSE CASE ist_datos.opcion 
	 	 CASE 1    // Guia de Remisión
				ii_dk[1] = 1				// Deploy key
				ii_dk[2] = 2				
				ii_dk[3] = 3				
				ii_dk[4] = 4
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4				
		CASE  2,3,4,5,8
				ii_dk[1] = 1				// Deploy key
				ii_dk[2] = 2				
				ii_dk[3] = 3				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
			
		CASE  7								//ORDEN COMPRA POR (NOTA DE INGRESOS)
				ii_dk[1] = 1
				ii_dk[2] = 2
				ii_dk[3] = 3
				ii_dk[4] = 4
				ii_dk[5] = 5
				ii_dk[6] = 6
				ii_dk[7] = 7
				ii_dk[8] = 8
			  
			   ii_rk[1] = 1
				ii_rk[2] = 2
				ii_rk[3] = 3
				ii_rk[4] = 4
				ii_rk[5] = 5
				ii_rk[6] = 6
				ii_rk[7] = 7
				ii_rk[8] = 8
		CASE	9							  //Articulo Movimiento Proyectado	
				ii_dk[1]  = 1				// Deploy key
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
				ii_dk[12] = 12
				ii_rk[1]  = 1				
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
				ii_rk[12] = 12
				
		CASE	10							  //Articulo Movimiento Proyectado
											  //x Orden de Compra
			   ii_dk[1]  = 1			  //cod art
				ii_dk[2]  = 2			  //nom articulo
				ii_dk[3]  = 3			  //descuento	
				ii_dk[4]  = 4			  //impuesto
				ii_dk[5]  = 5			  //cod moneda
				ii_dk[6]  = 6			  //precio unit
				ii_dk[7]  = 7			  //cant_pendiente
				ii_dk[8]  = 8			  //cencos	
				ii_dk[9]  = 9			  //cnta prsp
				ii_dk[10]  = 10			  //centro beneficio
				
				ii_rk[1]  = 1				
				ii_rk[2]  = 2				
				ii_rk[3]  = 3
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6								
				ii_rk[7]  = 7
				ii_rk[8]  = 8
				ii_rk[9]  = 9
				ii_rk[10]  = 10
				
		CASE 	11								//Orden de Servicio Detalle (Cuentas x Pagar)			
				ii_dk[1]   = 1  //COD_ORIGEN
				ii_dk[2]   = 2  //NRO_OS
				ii_dk[3]   = 3  //NRO_ITEM
				ii_dk[4]   = 4  //FLAG_ESTADO
				ii_dk[5]   = 5  //FEC_REGISTRO
				ii_dk[6]   = 6  //FEC_PROYECT
				ii_dk[7]   = 7  //DESCRIPCION
				ii_dk[8]   = 8  //IMPORTE   
				ii_dk[9]   = 9  //IMPUESTO 
				ii_dk[10]  = 10 //descuento
				ii_dk[11]  = 11 //CENCOS
				ii_dk[12]  = 12 //COD_SUB_CAT
				ii_dk[13]  = 13 //CNTA_PRSP
				ii_dk[14]  = 14 //OPER_SEC
				ii_dk[15]  = 15 //OPER_SEC
				

				ii_rk[1]   = 1   //COD_ORIGEN
				ii_rk[2]   = 2   //NRO_OS
				ii_rk[3]   = 3   //NRO_ITEM
				ii_rk[4]   = 4   //FLAG_ESTADO
				ii_rk[5]   = 5   //FEC_REGISTRO
				ii_rk[6]   = 6   //FEC_PROYECT
				ii_rk[7]   = 7   //DESCRIPCION
				ii_rk[8]   = 8   //IMPORTE   
				ii_rk[9]   = 9   //IMPUESTO 
				ii_rk[10]  = 10 //descuento
				ii_rk[11]  = 11 //CENCOS
				ii_rk[12]  = 12 //COD_SUB_CAT
				ii_rk[13]  = 13 //CNTA_PRSP
				ii_rk[14]  = 14 //OPER_SEC				
				ii_rk[15]  = 15
				
	 	 CASE 12    // Embarque
            ii_dk[1] = 1				// 
				ii_dk[2] = 2				// 
				ii_dk[3] = 3				// 
				ii_dk[4] = 4				// 
				ii_dk[5] = 5				// 
				ii_dk[6] = 6				// 
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				
	 	 CASE 13    // Deuda Financiera
            ii_dk[1]  = 1 // NRO_CUOTA
				ii_dk[2]  = 2 // TIPO_DEUDA_CONCEPTO
				ii_dk[3]  = 3 // DESCRIPCION
				ii_dk[4]  = 4 // TIPO_DOC_REF
				ii_dk[5]  = 5 // NRO_DOC_REF
				ii_dk[6]  = 6 // MONTO_PROY
				ii_dk[7]  = 7 // FEC_VCTO_PROY
				ii_dk[8]  = 8 // FLAG_ESTADO
				ii_dk[9]  = 9 // NRO REGISTRO
				ii_dk[10] = 10 // CENCOS
				ii_dk[11] = 11 // CNTA PRSP
				
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9 // NRO REGISTRO
				ii_rk[10] = 10 // CENCOS
				ii_rk[11] = 11 // CNTA PRSP
		 
		CASE 14  // Guia de Recepción de Materia Prima
				ii_dk[1] = 1
				ii_dk[2] = 2
				ii_dk[3] = 3
				ii_dk[4] = 4
				ii_dk[5] = 5
				ii_dk[6] = 6
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				ii_dk[10] = 10
 				ii_dk[11] = 11
			  
			   ii_rk[1] = 1
				ii_rk[2] = 2
				ii_rk[3] = 3
				ii_rk[4] = 4
				ii_rk[5] = 5
				ii_rk[6] = 6
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				ii_rk[10] = 10
				ii_rk[11] = 11
				
				
END CHOOSE
ii_ss = 1
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;f_Select_current_row(this)
end event

event dw_1::ue_selected_row_pro;Long	  ll_row, ll_rc, ll_count
Any	  la_id
Integer li_x


// Si todo esta ok se procede a pasar el registro al otro dw
ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)


Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = 0
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1573
integer y = 956
integer width = 1362
integer height = 808
integer taborder = 60
boolean hscrollbar = true
boolean vscrollbar = true
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
				ii_rk[12] = 12
				
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
				ii_dk[12] = 12
				
		CASE	10							  //Articulo Movimiento Proyectado
											  //x Orden de Compra
				
				ii_rk[1]  = 1				
				ii_rk[2]  = 2				
				ii_rk[3]  = 3
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6								
				ii_rk[7]  = 7
				ii_rk[8]  = 8
				ii_rk[9]  = 9			
				ii_rk[10]  = 10
				
				
	   		ii_dk[1]  = 1			  //cod art
				ii_dk[2]  = 2			  //nom articulo
				ii_dk[3]  = 3			  //descuento	
				ii_dk[4]  = 4			  //impuesto
				ii_dk[5]  = 5			  //cod moneda
				ii_dk[6]  = 6			  //precio unit
				ii_dk[7]  = 7			  //cant_pendiente
				ii_dk[8]  = 8			  //cencos	
				ii_dk[9]  = 9			  //cnta prsp
				ii_dk[10]  = 10		  //centro beneficio
				
		CASE 	11								//Orden de Servicio Detalle (Cuentas x Pagar)			

				ii_rk[1]   = 1   //COD_ORIGEN
				ii_rk[2]   = 2   //NRO_OS
				ii_rk[3]   = 3   //NRO_ITEM
				ii_rk[4]   = 4   //FLAG_ESTADO
				ii_rk[5]   = 5   //FEC_REGISTRO
				ii_rk[6]   = 6   //FEC_PROYECT
				ii_rk[7]   = 7   //DESCRIPCION
				ii_rk[8]   = 8   //IMPORTE   
				ii_rk[9]   = 9   //IMPUESTO 
				ii_rk[10]  = 10 //descuento
				ii_rk[11]  = 11 //CENCOS
				ii_rk[12]  = 12 //COD_SUB_CAT
				ii_rk[13]  = 13 //CNTA_PRSP
				ii_rk[14]  = 14 //OPER_SEC		
				ii_rk[15]  = 15 //CENTRO BENEF
				
				ii_dk[1]   = 1  //COD_ORIGEN
				ii_dk[2]   = 2  //NRO_OS
				ii_dk[3]   = 3  //NRO_ITEM
				ii_dk[4]   = 4  //FLAG_ESTADO
				ii_dk[5]   = 5  //FEC_REGISTRO
				ii_dk[6]   = 6  //FEC_PROYECT
				ii_dk[7]   = 7  //DESCRIPCION
				ii_dk[8]   = 8  //IMPORTE   
				ii_dk[9]   = 9  //IMPUESTO 
				ii_dk[10]  = 10 //descuento
				ii_dk[11]  = 11 //CENCOS
				ii_dk[12]  = 12 //COD_SUB_CAT
				ii_dk[13]  = 13 //CNTA_PRSP
				ii_dk[14]  = 14 //OPER_SEC				
				ii_dk[15]  = 15 //CENTRO BENEF
				
		 CASE 12    // Embarque
				ii_dk[1] = 1				// 
				ii_dk[2] = 2				// 
				ii_dk[3] = 3				// 
				ii_dk[4] = 4				// 
				ii_dk[5] = 5				// 
				ii_dk[6] = 6				// 
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				
	 	 CASE 13    // Deuda Financiera
            ii_dk[1] = 1 // NRO_CUOTA
				ii_dk[2] = 2 // TIPO_DEUDA_CONCEPTO
				ii_dk[3] = 3 // DESCRIPCION
				ii_dk[4] = 4 // TIPO_DOC_REF
				ii_dk[5] = 5 // NRO_DOC_REF
				ii_dk[6] = 6 // MONTO_PROY
				ii_dk[7] = 7 // FEC_VCTO_PROY
				ii_dk[8] = 8 // FLAG_ESTADO
				ii_dk[9] = 9 // NRO REGISTRO
				ii_dk[10] = 10 // CENCOS
				ii_dk[11] = 11 // CNTA PRSP
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8				
				ii_rk[9] = 9 // NRO REGISTRO
				ii_rk[10] = 10 // CENCOS
				ii_rk[11] = 11 // CNTA PRSP
		
		CASE 14  // Guia de Recepción de Materia Prima
				ii_dk[1] = 1
				ii_dk[2] = 2
				ii_dk[3] = 3
				ii_dk[4] = 4
				ii_dk[5] = 5
				ii_dk[6] = 6
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				ii_dk[11] = 11
			  
			   ii_rk[1] = 1
				ii_rk[2] = 2
				ii_rk[3] = 3
				ii_rk[4] = 4
				ii_rk[5] = 5
				ii_rk[6] = 6
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				ii_rk[10] = 10
				ii_rk[11] = 11
END CHOOSE
end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1399
integer y = 1188
integer taborder = 40
string text = ">"
alignment htextalign = center!
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1390
integer y = 1376
integer taborder = 50
alignment htextalign = center!
end type

type st_campo from statictext within w_abc_seleccion_md
integer x = 23
integer y = 20
integer width = 713
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_abc_seleccion_md
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 28
integer width = 1449
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;// Adiciona registro en dw1
Long ll_reg

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
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_abc_seleccion_md
integer x = 2578
integer y = 28
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
Long   j, ll_row_master, ll_ind_guia, ll_count_det, ll_row, ll_found, ll_x
String ls_guia_rem,ls_cod_origen,ls_orden_venta,ls_tipo_doc,ls_expresion,&
		 ls_orden_compra,ls_cod_moneda,ls_orden_serv,ls_forma_pago,ls_obs ,&
		 ls_moneda_fap  ,ls_fpago_fap ,ls_obs_fap,ls_flag_cntr, ls_cod_grmp
		 
u_dw_abc ldw_refer


ldw_refer = ist_datos.dw_c	// Referencias de Cuentas por Pagar

CHOOSE CASE ist_datos.opcion
	CASE 3		//CASO PARTICULAR DE CONFIN
	
		ll_count_det = dw_2.Rowcount()
		IF ll_count_det > 1 THEN
			Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero')
			Return
		ELSE
		
			IF ll_count_det = 1 THEN
				ll_row = ist_datos.dw_m.GetRow()
				IF ll_row = 0 THEN RETURN
				ist_datos.dw_m.object.confin 		  [ll_row] = dw_2.Object.confin		  [1]
				ist_datos.titulo = 's'
			END IF
		END IF
		
	CASE 15
		if of_opcion15() = 0 then return		
			
END CHOOSE
CloseWithReturn( parent, ist_datos)


end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 140
integer width = 2894
integer height = 796
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form

end event

event clicked;call super::clicked;// Muestra detalle
IF dw_2.Rowcount() = 0 THEN
	
	IF row > 0 THEN
		CHOOSE CASE ist_datos.opcion 
				 CASE 1,9 				// Guias de remisión, Articulo Mov Proy
						dw_1.Retrieve(this.object.cod_origen[row],this.object.nro_ov[row])
				 CASE 2,3,4,5,8 
						dw_1.Retrieve(this.object.grupo[row])
				 CASE 10 //ORDEN COMPRA		(Cuentas x Pagar)
					   dw_1.Retrieve(This.object.cod_origen[row],This.object.nro_oc[row])
				 CASE 11 //ORDEN SERVICIO 	(Cuentas x Pagar)
					   dw_1.Retrieve(This.object.cod_origen[row],This.object.nro_os[row])	
				 CASE 12 //Detalle de Embarque
					   dw_1.Retrieve(This.object.cod_art[row],This.object.item_prod[row])	
				 CASE	13	
						dw_1.Retrieve(This.object.nro_registro[row])	
  				 CASE 14 //Guia de Recepcion de Materia Prima
						dw_1.Retrieve(ist_datos.string1, This.object.cod_guia_rec[row])
				CASE 15//Inspección Global GAP
						dw_1.Retrieve(This.object.cod_modulo[row])
		END CHOOSE
	END IF
ELSE
	if ist_datos.opcion <> 12 then
		Messagebox( "Error", "no puede seleccionar otro documento", Exclamation!)
	end if
END IF
end event

event ue_output;call super::ue_output;		
Choose case ist_datos.opcion 
	Case 15 	// Orden trabajo genera orden de compra
		dw_1.Retrieve(this.object.cod_modulo[al_row])
						  
 end Choose
end event

