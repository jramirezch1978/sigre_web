$PBExportHeader$w_abc_seleccion_lista.srw
forward
global type w_abc_seleccion_lista from w_abc_list
end type
type cb_1 from commandbutton within w_abc_seleccion_lista
end type
end forward

global type w_abc_seleccion_lista from w_abc_list
integer x = 50
integer width = 1403
integer height = 1384
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
end type
global w_abc_seleccion_lista w_abc_seleccion_lista

type variables
String is_tipo
sg_parametros is_param
end variables

forward prototypes
public function long wf_verifica_doc (string as_origen_doc, string as_tipo_doc, string as_nro_doc)
public function string wf_flag_estado (string as_origen, string as_nro_og)
public function long wf_verifica_ce (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_dev_og (long al_item, long al_inicio, long al_row)
public function long wf_verifica_doc_ref (string as_origen_doc, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_liquidacion (long al_row, long al_item, long al_inicio)
public function integer of_opcion17 ()
end prototypes

public function long wf_verifica_doc (string as_origen_doc, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_doc = '+"'"+as_origen_doc+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function string wf_flag_estado (string as_origen, string as_nro_og);String ls_flag_estado_og


SELECT flag_estado
  INTO :ls_flag_estado_og
  FROM solicitud_giro sg
 WHERE ((sg.origen        = :as_origen ) AND
 		  (sg.nro_solicitud = :as_nro_og )) ;
			
			

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

Return ls_flag_estado_og
end function

public function long wf_verifica_ce (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'proveedor = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'cod_relacion = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_dev_og (long al_item, long al_inicio, long al_row);is_param.dw_m.object.item		       [al_row] = al_item
is_param.dw_m.object.proveedor       [al_row] = dw_2.object.cod_relacion    [al_inicio]
is_param.dw_m.object.tipo_doc        [al_row] = dw_2.object.tipo_doc        [al_inicio]
is_param.dw_m.object.nro_doc         [al_row] = dw_2.object.nro_doc         [al_inicio]
is_param.dw_m.object.fecha_doc       [al_row] = dw_2.object.fecha_emision   [al_inicio]
is_param.dw_m.object.cod_moneda      [al_row] = dw_2.object.cod_moneda      [al_inicio]
is_param.dw_m.object.cod_moneda_cab  [al_row] = is_param.string2
is_param.dw_m.object.tasa_cambio     [al_row] = dw_2.object.tasa_cambio     [al_inicio]
is_param.dw_m.object.importe         [al_row] = dw_2.object.saldo			    [al_inicio]
is_param.dw_m.object.descripcion     [al_row] = dw_2.object.descripcion     [al_inicio]	 	
is_param.dw_m.object.nom_proveedor	 [al_row] = dw_2.object.nombre		    [al_inicio]	
is_param.dw_m.Object.flag_tipo_gasto [al_row] = dw_2.object.flag_tipo_gasto [al_inicio]	
is_param.dw_m.object.cencos          [al_row] = dw_2.object.cencos          [al_inicio]
is_param.dw_m.object.cnta_prsp       [al_row] = dw_2.object.cnta_prsp       [al_inicio]

end subroutine

public function long wf_verifica_doc_ref (string as_origen_doc, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_doc_ref = '+"'"+as_origen_doc+"'"+' AND tipo_doc_ref = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc_ref ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_liquidacion (long al_row, long al_item, long al_inicio);String ls_soles,ls_dolares


select cod_soles,cod_dolares into :ls_soles,:ls_dolares FROM logparam where reckey = '1' ;
is_param.dw_m.object.item 			   [al_row] = al_item
is_param.dw_m.object.origen_doc_ref [al_row] = dw_2.object.origen     [al_inicio]
is_param.dw_m.object.tipo_doc_ref   [al_row] = dw_2.object.tipo_doc   [al_inicio]
is_param.dw_m.object.nro_doc_ref	   [al_row] = dw_2.object.nro_doc    [al_inicio]
is_param.dw_m.object.cod_moneda     [al_row] = dw_2.object.cod_moneda [al_inicio]
is_param.dw_m.object.flag_tabla	   [al_row] = dw_2.object.flag_tabla [al_inicio]
	 
IF is_param.string2 = ls_soles THEN
	is_param.dw_m.object.importe_liq [al_row] = dw_2.object.sldo_sol  [al_inicio]
ELSE
   is_param.dw_m.object.importe_liq [al_row] = dw_2.object.saldo_dol [al_inicio]
END IF

end subroutine

public function integer of_opcion17 ();//codigo

long ll_inicio

for ll_inicio = 1 to dw_2.rowcount( )
 	 is_param.field_ret_s[ll_inicio] = trim(dw_2.object.nombre[ll_inicio])
	 is_param.field_ret[ll_inicio] = trim(dw_2.object.email[ll_inicio])
next

return 1
end function

on w_abc_seleccion_lista.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_abc_seleccion_lista.destroy
call super::destroy
destroy(this.cb_1)
end on

event ue_open_pre;// Overr

String ls_null
Long ll_row

// Recoge parametro enviado

	This.Title = is_param.titulo
	dw_1.DataObject = is_param.dw1
	dw_2.Dataobject = is_param.dw1
	
	dw_1.SetTransObject( SQLCA)
	dw_2.SetTransObject( SQLCA)
	//Posiciones 
	dw_1.width = is_param.db1
	pb_1.x 	  = dw_1.width + 50
	pb_2.x 	  = pb_1.x
	dw_2.x 	  = pb_1.x + pb_1.width + 50
	dw_2.width = is_param.db1
	This.width = dw_1.width + pb_1.width + dw_2.width + 200
	cb_1.x	  = This.width - 400
	//
	
	
	IF TRIM(is_param.tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
	ELSE		// caso contrario hace un retrieve con parametros
		CHOOSE CASE is_param.tipo
				 CASE '1CP' //cartera de pagos
						dw_1.Retrieve(is_param.string1) 
				 CASE '1CC' //cartera de cobro 
						dw_1.Retrieve(is_param.string1) 						
				 CASE	'1CLF'	//CIERRA LIQUIDACION FONDO FIJO
					   dw_1.Retrieve(is_param.string1,is_param.string2) 
				 CASE	'1OC'	   //ADELANTOS DE ORDEN DE COMPRA
						dw_1.Retrieve(is_param.string1) 
				 CASE '1OS'		//ADELANTOS DE ORDEN DE SERVICIO
						dw_1.Retrieve(is_param.string1) 
				 CASE '1AP'    //APLICACION DE DOCUMENTO
						dw_1.Retrieve(is_param.string1) 
				 CASE '1PM'    //PAGOS MASIVOS
						dw_1.Retrieve(is_param.string1,is_param.string2) 						
				 CASE '1POG'    //PRE LIQUIDACION ORDEN_GIRO
						dw_1.Retrieve(is_param.string1) 						
				 CASE '1PDXG'    //DOC. X PAGAR EN FONDO FIJO
						dw_1.Retrieve(is_param.string1,is_param.string2) 												
				 CASE '1DPOG'    //PRE LIQUIDACION ORDEN_GIRO DOC X PAGAR
						dw_1.Retrieve(is_param.string1)
				 CASE '1OG'		  //ORDEN DE GIRO		
						dw_1.Retrieve(is_param.string1)
				 CASE '1LQ'		  //LIQUIDACION DE PAGO
						dw_1.Retrieve(is_param.string1)						
		END CHOOSE
	END IF

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista
integer x = 9
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

CHOOSE CASE is_param.opcion 
		
	 	 CASE 1,15    // Cartera de Pagos
										// Deploy key
				ii_dk[1] = 1		//Tipo de Documento		
				ii_dk[2] = 2		//Nro de Documento		
				ii_dk[3] = 3		//Moneda
				ii_dk[4] = 4		//Total a Pagar
				ii_dk[5] = 5		//Codigo de Relacion
				ii_dk[6] = 6		//Flag Tabla
				ii_dk[7] = 7      //tipo origen de doc / P PAGAR C COBRAR
				ii_dk[8] = 8      //Signo
				ii_dk[9] = 9      //Origen
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4				
				ii_rk[5] = 5								
				ii_rk[6] = 6
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				
	 	 CASE 2    // Proveedores Programa de Pagos
			   ii_dk[1] = 1		//Codigo	
				ii_dk[2] = 2		//Nombres
				ii_rk[1] = 1		//Codigo	
				ii_rk[2] = 2		//Nombres
		 CASE 3 //cierre liquidacion fondo fijo
				ii_dk[1] = 1   //origen
				ii_dk[2] = 2   //nro solicitud
				ii_dk[3] = 3   //item
				ii_dk[4] = 4   //proveedor
				ii_dk[5] = 5   //tipo documento
				ii_dk[6] = 6   //nro documento
				ii_dk[7] = 7   //fecha documento
				ii_dk[8] = 8   //moneda
				ii_dk[9] = 9   //tasa cambio
				ii_dk[10] = 10 //descripcion
				ii_dk[11] = 11 //importe
				ii_dk[12] = 12 //confin 1
				ii_dk[13] = 13 //confin 2
				ii_dk[14] = 14 //cencos
				ii_dk[15] = 15 //cnta prsp
				ii_dk[16] = 16 //flag_tipo_gasto
				ii_dk[17] = 17 //nom_proveedor
				/*	          */
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
				ii_rk[12] = 12
				ii_rk[13] = 13
				ii_rk[14] = 14
				ii_rk[15] = 15
				ii_rk[16] = 16 //flag_tipo_gasto 
				ii_rk[16] = 17 //nom_proveedor
		 CASE 4,5,16	//ORDEN DE COMPRA ADELANTOS,ORDEN DE SERVICIO ADELANTOS,LIQUIDACION DE PAGO
			
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
				
		CASE	6		//APLICACION DE DOCUMENTOS
			 
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
				ii_dk[13] = 13
				
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
				ii_rk[13] = 13
				
		CASE	7,8,9		//PRE LIQUIDACION DE FONDO FIJO,ORDEN GIRO,EGRESO DIRECTO
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo doc
				ii_dk[3]  = 3  //nro doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //tasa cambio
				ii_dk[6]  = 6  //total pagar
				ii_dk[7]  = 7  //fecha doc
				ii_dk[8]  = 8  //Cencos
				ii_dk[9]  = 9  //Cuenta Presupuestal
				ii_dk[10] = 10 //Descripcion
				ii_dk[11] = 11 //Proveedor
				ii_dk[12] = 12 //Origen
				
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo doc
				ii_rk[3]  = 3  //nro doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //tasa cambio
				ii_rk[6]  = 6  //total pagar
				ii_rk[7]  = 7  //fecha doc
				ii_rk[8]  = 8  //Cencos
				ii_rk[9]  = 9  //Cuenta Presupuestal
				ii_rk[10] = 10 //Descripcion
				ii_rk[11] = 11 //Proveedor
				ii_rk[12] = 12 //Origen					
				
		CASE	10		//PAGOS MASIVOS
				ii_dk[1]  = 1  //tipo_doc
				ii_dk[2]  = 2  //nro_doc
				ii_dk[3]  = 3  //cod_moneda
				ii_dk[4]  = 4  //sldo_sol
				ii_dk[5]  = 5  //saldo_dol
				ii_dk[6]  = 6  //cod_relacion
				ii_dk[7]  = 7  //flag_tabla
				ii_dk[8]  = 8  //origen
				ii_dk[9]  = 9  //flag cxp
				
				ii_rk[1]  = 1  //tipo_doc
				ii_rk[2]  = 2  //nro_doc
				ii_rk[3]  = 3  //cod_moneda
				ii_rk[4]  = 4  //sldo_sol
				ii_rk[5]  = 5  //saldo_dol
				ii_rk[6]  = 6  //cod_relacion
				ii_rk[7]  = 7  //flag_tabla
				ii_rk[8]  = 8  //origen
				ii_rk[9]  = 9  //flag cxp
				
		 CASE 11 //pre liquidacion de orden de giro
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //CENCOS
				ii_dk[10]  = 10  //CNTA PRSP
				
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //CENCOS
				ii_rk[10]  = 10  //CNTA PRSP
				
				
		 CASE	12  //pre liquidacion CNTAS X PAGAR de orden de giro
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //nombre proveedor
				ii_dk[10]  = 10  //cencos
				ii_dk[11]  = 11  //cnta prsp
				
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //nombre proveedor
				ii_rk[10]  = 10  //cencos
				ii_rk[11]  = 11  //cnta prsp
				
			
		 CASE 13 //pre liquidacion CNTAS X PAGAR de orden de giro,Ordenes de Giro
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //nombre proveedor
				ii_dk[10]  = 10  //cencos
				ii_dk[11]  = 11  //cnta presup
				
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //nombre proveedor
				ii_rk[10]  = 10  //cencos
				ii_rk[11]  = 11  //cnta presup
				
		 CASE 14 //devolucion de orden de giro
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //nombre proveedor
				ii_dk[10]  = 10  //cencos
				ii_dk[11]  = 11  //cnta presup
				ii_dk[12]  = 12  //Tipo Gasto
				
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //nombre proveedor
				ii_rk[10]  = 10  //cencos
				ii_rk[11]  = 11  //cnta presup
				ii_rk[12]  = 12  //Tipo Gasto				
		
		case  17 //seleccion usuario
				ii_dk[1]  = 1  //codigo
				ii_dk[2]  = 2  //nombre
				ii_dk[3]  = 3  //email
				
				ii_rk[1]  = 1  //codigo
				ii_rk[2]  = 2  //nombre
				ii_rk[3]  = 3  //email
END CHOOSE
ii_ss = 0
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)


Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = 0
Loop

end event

event dw_1::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x


ll_row = dw_2.EVENT ue_insert()


FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista
integer x = 699
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
CHOOSE CASE is_param.opcion 
		 CASE 1,15 //Cartera de Pagos
								//Deploy Key
				ii_rk[1] = 1		//Tipo de Documento		
				ii_rk[2] = 2		//Nro de Documento		
				ii_rk[3] = 3		//Moneda
				ii_rk[4] = 4		//Total a Pagar
				ii_rk[5] = 5		//Codigo de Relacion
				ii_rk[6] = 6		//Flag Tabla
				ii_rk[7] = 7      //tipo origen de doc / P PAGAR C COBRAR
				ii_rk[8] = 8      //Signo
				ii_rk[9] = 9      //Origen
								//Receive Key
				ii_dk[1] = 1				
				ii_dk[2] = 2				
				ii_dk[3] = 3				

				ii_dk[4] = 4				
				ii_dK[5] = 5								
				ii_dk[6] = 6
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
								
		 CASE 2 //Proveedores Programa de Pagos
				ii_rk[1] = 1		//Codigo
				ii_rk[2] = 2		//Nombres
				ii_dk[1] = 1		//Codigo
				ii_dk[2] = 2		//Nombres
		 CASE 3 //cierre liquidacion fondo fijo
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
				ii_rk[12] = 12
				ii_rk[13] = 13
				ii_rk[14] = 14
				ii_rk[15] = 15
				ii_rk[16] = 16 //flag_tipo_gasto
				ii_rk[17] = 17 //nom proveedor
				/*          */
 				ii_dk[1] = 1   //origen
				ii_dk[2] = 2   //nro solicitud
				ii_dk[3] = 3   //item
				ii_dk[4] = 4   //proveedor
				ii_dk[5] = 5   //tipo documento
				ii_dk[6] = 6   //nro documento
				ii_dk[7] = 7   //fecha documento
				ii_dk[8] = 8   //moneda
				ii_dk[9] = 9   //tasa cambio
				ii_dk[10] = 10 //descripcion
				ii_dk[11] = 11 //importe
				ii_dk[12] = 12 //confin 1
				ii_dk[13] = 13 //confin 2
				ii_dk[14] = 14 //cencos
				ii_dk[15] = 15 //cnta prsp
				ii_dk[16] = 16 //flag_tipo_gasto
				ii_dk[17] = 17 //nom proveedor				
				
		 CASE 4,5,16	//ORDEN DE COMPRA ADELANTOS,ORDEN DE SERVICIO ADELANTOS,LIQUIDACION DE PAGO

				ii_rk[1] = 1
				ii_rk[2] = 2
				ii_rk[3] = 3
				ii_rk[4] = 4
				ii_rk[5] = 5
				ii_rk[6] = 6
				ii_rk[7] = 7
				ii_rk[8] = 8

				ii_dk[1] = 1
				ii_dk[2] = 2
				ii_dk[3] = 3
				ii_dk[4] = 4
				ii_dk[5] = 5
				ii_dk[6] = 6
				ii_dk[7] = 7
				ii_dk[8] = 8
				
		CASE	6		//APLICACION DE DOCUMENTOS
			 
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
				ii_rk[13] = 13
				
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
				ii_dk[13] = 13
				
		CASE	7,8,9		//PRE LIQUIDACION DE FONDO FIJO,ORDEN GIRO,EGRESO DIRECTO
				ii_rk[1]  = 1 //cod_relacion
				ii_rk[2]  = 2 //tipo doc
				ii_rk[3]  = 3 //nro doc
				ii_rk[4]  = 4 //cod_moneda
				ii_rk[5]  = 5 //tasa cambio
				ii_rk[6]  = 6 //total pagar
				ii_rk[7]  = 7 //fecha doc
				ii_rk[8]  = 8 //cencos
				ii_rk[9]  = 9 //cuenta presupuestal
				ii_rk[10] = 10 //Descripcion
				ii_rk[11] = 11 //
				ii_rk[12] = 12 //
				
				ii_dk[1]  = 1 //cod_relacion
				ii_dk[2]  = 2 //tipo doc
				ii_dk[3]  = 3 //nro doc
				ii_dk[4]  = 4 //cod_moneda
				ii_dk[5]  = 5 //tasa cambio
				ii_dk[6]  = 6 //total pagar				
				ii_dk[7]  = 7 //fecha doc
				ii_dk[8]  = 8 //cencos
				ii_dk[9]  = 9 //cuenta presupuestal
				ii_dk[10] = 10 //Descripcion
				ii_dk[11] = 11 //
				ii_dk[12] = 12 //
		CASE	10	//PAGOS MASIVOS		
				
				ii_rk[1]  = 1  //tipo_doc
				ii_rk[2]  = 2  //nro_doc
				ii_rk[3]  = 3  //cod_moneda
				ii_rk[4]  = 4  //sldo_sol
				ii_rk[5]  = 5  //saldo_dol
				ii_rk[6]  = 6  //cod_relacion
				ii_rk[7]  = 7  //flag_tabla
				ii_rk[8]  = 8  //origen
				ii_rk[9]  = 9  //origen
				
				ii_dk[1]  = 1  //tipo_doc
				ii_dk[2]  = 2  //nro_doc
				ii_dk[3]  = 3  //cod_moneda
				ii_dk[4]  = 4  //sldo_sol
				ii_dk[5]  = 5  //saldo_dol
				ii_dk[6]  = 6  //cod_relacion
				ii_dk[7]  = 7  //flag_tabla
				ii_dk[8]  = 8  //origen
				ii_dk[9]  = 9  //origen				
		 CASE 11
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //CENCOS
				ii_rk[10]  = 10  //CNTA PRESUP
								
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //CENCOS
				ii_dk[10] = 10  //CNTA PRESUP
				
				
		 CASE	12 //PRE LIQUIDACION CNTAS X PAGAR
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //NOMBRE PROVEEDOR
				ii_rk[10]  = 10  //cencos
				ii_rk[11]  = 11  //cnta prsp
								
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //NOMBRE PROVEEDOR
				ii_dk[10]  = 10  //cencos
				ii_dk[11]  = 11  //cnta prsp
				
		 CASE	13 //orden de giro
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //NOMBRE PROVEEDOR
				ii_rk[10]  = 10  //CENCOS
				ii_rk[11]  = 11  //CNTA PRESUP
								
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //NOMBRE PROVEEDOR
				ii_dk[10]  = 10  //CENCOS
				ii_dk[11]  = 11  //CNTA PRESUP

		 CASE 14 //devolucion de orden de giro
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo_doc
				ii_rk[3]  = 3  //nro_doc
				ii_rk[4]  = 4  //cod_moneda
				ii_rk[5]  = 5  //fecha emision
				ii_rk[6]  = 6  //tasa cambio
				ii_rk[7]  = 7  //descripcion
				ii_rk[8]  = 8  //saldo
				ii_rk[9]  = 9  //nombre proveedor
				ii_rk[10]  = 10  //cencos
				ii_rk[11]  = 11  //cnta presup
				ii_rk[12]  = 12  //Tipo Gasto											
				
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo_doc
				ii_dk[3]  = 3  //nro_doc
				ii_dk[4]  = 4  //cod_moneda
				ii_dk[5]  = 5  //fecha emision
				ii_dk[6]  = 6  //tasa cambio
				ii_dk[7]  = 7  //descripcion
				ii_dk[8]  = 8  //saldo
				ii_dk[9]  = 9  //nombre proveedor
				ii_dk[10]  = 10  //cencos
				ii_dk[11]  = 11  //cnta presup
				ii_dk[12]  = 12  //Tipo Gasto

		case  17 //seleccion usuario
			
				ii_dk[1]  = 1  //codigo
				ii_dk[2]  = 2  //nombre
				ii_dk[3]  = 3  //email
				
				ii_rk[1]  = 1  //codigo
				ii_rk[2]  = 2  //nombre
				ii_rk[3]  = 3  //email
				
				
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

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_lista
integer x = 539
integer y = 456
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista
integer x = 539
integer y = 704
end type

type cb_1 from commandbutton within w_abc_seleccion_lista
integer x = 919
integer y = 20
integer width = 297
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;Long    ll_inicio,ll_found = 0,ll_row,ll_item
String  ls_tipo_doc,ls_nro_doc,ls_let_x_pag,ls_doc_sol_giro,ls_flag_edit,&
		  ls_expresion,ls_doc_oc,ls_doc_os,ls_origen,ls_flag_estado,ls_flag_estado_og,&
		  ls_cod_relacion,ls_cod_moneda,ls_soles,ls_dolares
Integer li_item,li_nro_sol_pend,li_nro_max
Decimal {2} ldc_importe,ldc_importe_cab,ldc_importe_det,ldc_saldo

dw_2.Accepttext()

CHOOSE CASE is_param.opcion
		 CASE 1,15 //Cartera de Pagos
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 /*Documento de Letras x Pagar*/
					 SELECT doc_letra_pagar,doc_sol_giro INTO :ls_let_x_pag,:ls_doc_sol_giro FROM finparam WHERE reckey = '1' ;
					 /**/
 					 ls_origen   	  = dw_2.object.origen       [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc     [ll_inicio]
					 ls_nro_doc  	  = dw_2.object.nro_doc      [ll_inicio]
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 
					 IF ls_tipo_doc = ls_doc_sol_giro  AND is_param.tipo = '1CP' THEN
						 /*verificar contador de solcitud de giro*/
						 SELECT Nvl(nro_solicitudes_pend,0),Nvl(nro_maximo_sol_pend,0) INTO :li_nro_sol_pend,:li_nro_max FROM maestro_param_autoriz WHERE (cod_relacion = :ls_cod_relacion) ;	 
							 
					 	 IF li_nro_sol_pend >= li_nro_max  THEN
						 	 Messagebox('Aviso','Verifique su maximo de Pendientes de Ordenes de Giro')					
						 	 Return
					 	 END IF
					END IF
					 
					 IF is_param.dw_m.Rowcount() > 0 THEN
                   IF ls_tipo_doc = ls_doc_sol_giro AND is_param.tipo = '1CP'  THEN
							 ls_flag_estado_og = wf_flag_estado(ls_origen,ls_nro_doc)
							 IF ls_flag_estado_og = '2' THEN
								 Messagebox('Aviso','No puede Insertar Esta Solicitud de Giro , Verifique!')					
								 Return
							 END IF
						 END IF
					 END IF
					 
					 ll_found = wf_verifica_doc (ls_origen,ls_tipo_doc,ls_nro_doc)
					 
					 IF ll_found = 0 THEN
						 ll_row = is_param.dw_m.Insertrow(0)
						 is_param.bret = TRUE
						 is_param.dw_m.object.item            [ll_row] = ll_row	
						 is_param.dw_m.object.cod_relacion    [ll_row] = dw_2.object.cod_relacion [ll_inicio]
						 is_param.dw_m.object.origen_doc      [ll_row] = ls_origen
						 is_param.dw_m.object.tipo_doc        [ll_row] = ls_tipo_doc
						 is_param.dw_m.object.nro_doc         [ll_row] = ls_nro_doc
						 is_param.dw_m.object.importe         [ll_row] = dw_2.object.total_pagar  [ll_inicio]
						 is_param.dw_m.object.importe_det     [ll_row] = dw_2.object.total_pagar  [ll_inicio]
						 is_param.dw_m.object.tasa_cambio     [ll_row] = is_param.db2
						 is_param.dw_m.object.cod_moneda_cab  [ll_row] = is_param.string2
						 
						 if is_param.opcion = 15 then
							 is_param.dw_m.object.cod_moneda     [ll_row] = dw_2.object.cod_moneda   [ll_inicio]
						 else 
							 is_param.dw_m.object.cod_moneda_det [ll_row] = dw_2.object.cod_moneda   [ll_inicio]
						 end if
						 
						 is_param.dw_m.object.flab_tabor		  [ll_row] = dw_2.object.flag_tabla   [ll_inicio]
						 is_param.dw_m.object.flag_cxp	     [ll_row] = dw_2.object.flag_cxp	  [ll_inicio]
			          is_param.dw_m.object.t_tipdoc 		  [ll_row] = '1'						 
						 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'	//ACTIVO					 
						  
						 IF ls_tipo_doc = ls_doc_sol_giro AND is_param.tipo = '1CP'  THEN	//Solicitud de Giro,Importe No Editable
						    /* VERIFICAR ESTADO DE SOLICITUD_GIRO */
							 ls_flag_estado = wf_flag_estado(ls_origen,ls_nro_doc)
							 IF ls_flag_estado = '2' THEN
								 SetNull(ls_flag_edit)
 					          is_param.dw_m.object.t_tipdoc 		[ll_row] = ls_flag_edit
							 END IF	
						 END IF

					 END IF
				NEXT	
		 CASE 3  //CIERRE LIQUIDACION FONDO FIJO
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ll_row = is_param.dw_m.Insertrow(0)
					 is_param.bret = TRUE
					 li_item = Integer(Trim(String(dw_2.object.item [ll_inicio])))
					 is_param.dw_m.object.origen			  [ll_row] = dw_2.object.origen          [ll_inicio]
					 is_param.dw_m.object.nro_solicitud   [ll_row] = dw_2.object.nro_solicitud   [ll_inicio]
					 is_param.dw_m.object.item				  [ll_row] = li_item
					 is_param.dw_m.object.proveedor		  [ll_row] = dw_2.object.proveedor       [ll_inicio]
					 is_param.dw_m.object.nom_proveedor	  [ll_row] = dw_2.object.nom_proveedor   [ll_inicio]
					 is_param.dw_m.object.tipo_doc		  [ll_row] = dw_2.object.tipo_doc        [ll_inicio]
					 is_param.dw_m.object.nro_doc			  [ll_row] = dw_2.object.nro_doc         [ll_inicio]
					 is_param.dw_m.object.fecha_doc		  [ll_row] = dw_2.object.fecha_doc       [ll_inicio]
					 is_param.dw_m.object.cod_moneda		  [ll_row] = dw_2.object.cod_moneda      [ll_inicio]
					 is_param.dw_m.object.tasa_cambio	  [ll_row] = dw_2.object.tasa_cambio     [ll_inicio]
					 is_param.dw_m.object.descripcion	  [ll_row] = dw_2.object.descripcion     [ll_inicio]
					 is_param.dw_m.object.importe			  [ll_row] = dw_2.object.importe         [ll_inicio]
					 is_param.dw_m.object.confin			  [ll_row] = dw_2.object.confin          [ll_inicio]
					 is_param.dw_m.object.confin2			  [ll_row] = dw_2.object.confin2         [ll_inicio]
					 is_param.dw_m.object.cencos			  [ll_row] = dw_2.object.cencos          [ll_inicio]
					 is_param.dw_m.object.cnta_prsp		  [ll_row] = dw_2.object.cnta_prsp       [ll_inicio]
					 is_param.dw_m.object.flag_tipo_gasto [ll_row] = dw_2.object.flag_tipo_gasto [ll_inicio]
				NEXT
				ls_expresion = 'item'
				is_param.dw_m.SetSort(ls_expresion)
				is_param.dw_m.Sort()
		 CASE 4 //Adelantos de Orden de Compra
				IF is_param.dw_m.Rowcount() > 0 THEN
					Messagebox('Aviso','No se Puede Ingresar Mas de Un Documento de compra Verifique Documento Ingresados')
					Return
				ELSE
					IF dw_2.Rowcount() > 1 THEN
						Messagebox('Aviso','Solamente Puede Seleccionar Una Orden de Compra , Verifique!')	
						Return
					END IF
					FOR ll_inicio = 1 TO dw_2.Rowcount()
						 /*Tipo de Orden de Compra*/
						 SELECT doc_oc
						   INTO :ls_doc_oc
						   FROM logparam 
					 	  WHERE (reckey = '1') ;
					 
						 ll_row = is_param.dw_m.Insertrow(0)
				   	 is_param.bret = TRUE
						 is_param.dw_m.object.item            [ll_row] = ll_row	
	   				 is_param.dw_m.object.cod_relacion    [ll_row] = dw_2.object.cod_relacion [ll_inicio]
						 is_param.dw_m.object.origen_doc      [ll_row] = dw_2.object.cod_origen   [ll_inicio]
					    is_param.dw_m.object.tipo_doc        [ll_row] = ls_doc_oc
				    	 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_oc		  [ll_inicio]
  					    is_param.dw_m.object.importe         [ll_row] = 0.00
					    is_param.dw_m.object.importe_det     [ll_row] = 0.00
					    is_param.dw_m.object.tasa_cambio     [ll_row] = is_param.db2
					    is_param.dw_m.object.cod_moneda_cab  [ll_row] = is_param.string2
					    is_param.dw_m.object.cod_moneda      [ll_row] = dw_2.object.cod_moneda   [ll_inicio]
					    is_param.dw_m.object.flab_tabor		  [ll_row] = '7'
					    is_param.dw_m.object.flag_cxp	     [ll_row] = '+'
			          is_param.dw_m.object.t_tipdoc 		  [ll_row] = '1'	/*Importe editable de Adelanto*/					 
						 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'	//ACTIVO	
					NEXT 
				END IF

		 CASE 5 //Adelantos de Orden de Servicio
			   
					IF dw_2.Rowcount() > 1 THEN
						Messagebox('Aviso','Solamente Puede Seleccionar Una Orden de Servicio , Verifique!')	
						Return
					END IF
					FOR ll_inicio = 1 TO dw_2.Rowcount()
						 /*Tipo de Orden de Compra*/
						 SELECT doc_os
						   INTO :ls_doc_os
						   FROM logparam 
					 	  WHERE (reckey = '1') ;
						 ll_row = is_param.dw_m.Insertrow(0)
				   	 is_param.bret = TRUE
						 is_param.dw_m.object.item            [ll_row] = ll_row	
	   				 is_param.dw_m.object.cod_relacion    [ll_row] = dw_2.object.cod_relacion [ll_inicio]
						 is_param.dw_m.object.origen_doc      [ll_row] = dw_2.object.cod_origen   [ll_inicio]
					    is_param.dw_m.object.tipo_doc        [ll_row] = ls_doc_os
				    	 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_os		  [ll_inicio]
  					    is_param.dw_m.object.importe         [ll_row] = 0.00
					    is_param.dw_m.object.importe_det     [ll_row] = 0.00
					    is_param.dw_m.object.tasa_cambio     [ll_row] = is_param.db2
					    is_param.dw_m.object.cod_moneda_cab  [ll_row] = is_param.string2
					    is_param.dw_m.object.cod_moneda      [ll_row] = dw_2.object.cod_moneda   [ll_inicio]
					    is_param.dw_m.object.flab_tabor		  [ll_row] = '8'
					    is_param.dw_m.object.flag_cxp	     [ll_row] = '+'
			          is_param.dw_m.object.t_tipdoc 		  [ll_row] = '1'	/*Importe editable de Adelanto*/					 
						 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'	//ACTIVO	
					NEXT 

				
		 CASE 6		/*Aplicación de Documentos*/		
				FOR ll_inicio = 1 TO dw_2.Rowcount()
			   	 is_param.bret = TRUE
					 ll_row = is_param.dw_m.InsertRow(0)
					 is_param.dw_m.object.item            [ll_row] = ll_row
					 is_param.dw_m.object.cod_relacion    [ll_row] = is_param.string1
					 is_param.dw_m.object.origen_doc      [ll_row] = dw_2.object.origen      [ll_inicio]
				    is_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc    [ll_inicio]
			    	 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc     [ll_inicio]
				    is_param.dw_m.object.importe         [ll_row] = dw_2.object.total_pagar [ll_inicio]
				    is_param.dw_m.object.tasa_cambio     [ll_row] = is_param.db2
				    is_param.dw_m.object.cod_moneda_doc  [ll_row] = dw_2.object.cod_moneda  [ll_inicio]
				    is_param.dw_m.object.cod_moneda		  [ll_row] = is_param.string2
				    is_param.dw_m.object.flab_tabor		  [ll_row] = dw_2.object.flag_tabla  [ll_inicio]
				    is_param.dw_m.object.flag_cxp	     [ll_row] = dw_2.object.flag_cxp    [ll_inicio]
					 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'
				NEXT
				
		 CASE	7 /*Comprobantes de Egresos Fondo Fijo*/	
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 /*Verificar si Comprobante de Egreso ya fue ingresado*/
					 ldc_importe_cab = is_param.field_ret_d2 [1]
					 ldc_importe_det = is_param.field_ret_d2 [2]
					 ldc_importe 	  = dw_2.object.total_pagar  [ll_inicio] 
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
					 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
					 ls_cod_moneda	  = dw_2.object.cod_moneda   [ll_inicio]
					 ldc_importe_det = ldc_importe_det + ldc_importe 
					 IF ls_cod_moneda <> is_param.string2 THEN
						 Messagebox('Aviso','Comprobante de Egreso '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' Tiene Moneda Diferente a Fondo Fijo , Verifique!')
						 Return
					 END IF
					 IF ldc_importe_det > ldc_importe_cab THEN
						 Messagebox('Aviso','Importe del Documento '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' Ha Sobrepasado el Monto del Fondo Fijo')
						 Return	 
					 END IF
					 ll_found = wf_verifica_ce (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
					 IF ll_found > 0 THEN
						 Messagebox('Aviso','Comprobante de Egreso '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					 ELSE	 
						 is_param.bret = TRUE
						 ll_row = is_param.dw_m.InsertRow(0)
						 IF is_param.dw_m.Rowcount()  > 1 THEN
							 ll_item = is_param.dw_m.object.item	[is_param.dw_m.Rowcount() - 1] + 1
						 ELSE
							 ll_item = 1
						 END IF
 					 	  
						 is_param.dw_m.object.item		        [ll_row] = ll_item
						 is_param.dw_m.object.proveedor       [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
					 	 is_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
						 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc       [ll_inicio]
						 is_param.dw_m.object.fecha_doc       [ll_row] = dw_2.object.fecha_emision [ll_inicio]
						 is_param.dw_m.object.cod_moneda      [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
					 	 is_param.dw_m.object.tasa_cambio     [ll_row] = dw_2.object.tasa_cambio   [ll_inicio]
						 is_param.dw_m.object.importe         [ll_row] = dw_2.object.total_pagar   [ll_inicio]
  					 	 is_param.dw_m.object.cencos          [ll_row] = dw_2.object.cencos        [ll_inicio]
  					 	 is_param.dw_m.object.cnta_prsp       [ll_row] = dw_2.object.cnta_prsp     [ll_inicio]
						 is_param.dw_m.Object.flag_tipo_gasto [ll_row] = 'P'
						 is_param.dw_m.object.descripcion     [ll_row] = dw_2.object.descripcion   [ll_inicio]	 	
						 is_param.dw_m.Object.flag_estado     [ll_row] = '1'
					 END IF
				NEXT	
				
		 CASE	8 /*Comprobantes de Egresos Orden de Giro*/	
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 /*Verificar si Comprobante de Egreso ya fue ingresado*/
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
					 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
					 ll_found = wf_verifica_ce (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
					 IF ll_found > 0 THEN
						 Messagebox('Aviso','Comprobante de Egreso '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					 ELSE	 
						 is_param.bret = TRUE
  					 	 ll_row = is_param.dw_m.InsertRow(0) 
 						 IF is_param.dw_m.Rowcount()  > 1 THEN
							 ll_item = is_param.dw_m.object.item	[is_param.dw_m.Rowcount() - 1] + 1
						 ELSE
							 ll_item = 1
						 END IF

						 is_param.dw_m.object.item		       [ll_row] = ll_item
						 is_param.dw_m.object.proveedor      [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
					 	 is_param.dw_m.object.tipo_doc       [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
						 is_param.dw_m.object.nro_doc        [ll_row] = dw_2.object.nro_doc       [ll_inicio]
						 is_param.dw_m.object.fecha_doc      [ll_row] = dw_2.object.fecha_emision [ll_inicio]
						 is_param.dw_m.object.cod_moneda     [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
						 is_param.dw_m.object.cod_moneda_cab [ll_row] = is_param.string2
					 	 is_param.dw_m.object.tasa_cambio    [ll_row] = dw_2.object.tasa_cambio   [ll_inicio]
						 is_param.dw_m.object.importe        [ll_row] = dw_2.object.total_pagar   [ll_inicio]
 					 	 is_param.dw_m.object.cencos         [ll_row] = dw_2.object.cencos        [ll_inicio]
  					 	 is_param.dw_m.object.cnta_prsp      [ll_row] = dw_2.object.cnta_prsp     [ll_inicio]
						 is_param.dw_m.object.descripcion    [ll_row] = dw_2.object.descripcion   [ll_inicio]	 	
						 is_param.dw_m.object.nom_proveedor	 [ll_row] = dw_2.object.nombre		  [ll_inicio]	
					 END IF
					 
				NEXT

		 CASE	9 /*Comprobantes de Egresos (Egresos Directos)*/	
				
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 /*Verificar si Comprobante de Egreso ya fue ingresado*/
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
					 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
					 
					 ll_found = wf_verifica_ed (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
					 IF ll_found > 0 THEN
						 Messagebox('Aviso','Comprobante de Egreso '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					 ELSE	 
						 is_param.bret = TRUE
 					 	 ll_row = is_param.dw_m.InsertRow(0) 
						 is_param.dw_m.object.item		       [ll_row] = ll_row
						 is_param.dw_m.object.origen_doc     [ll_row] = dw_2.object.origen	     [ll_inicio]
						 is_param.dw_m.object.cod_relacion   [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
					 	 is_param.dw_m.object.tipo_doc       [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
						 is_param.dw_m.object.nro_doc        [ll_row] = dw_2.object.nro_doc       [ll_inicio]
						 is_param.dw_m.object.cod_moneda_det [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
						 is_param.dw_m.object.cod_moneda_cab [ll_row] = is_param.string2
					 	 is_param.dw_m.object.tasa_cambio    [ll_row] = is_param.field_ret_d3	  [1]
						 is_param.dw_m.object.importe        [ll_row] = dw_2.object.total_pagar   [ll_inicio]
						 is_param.dw_m.object.flab_tabor     [ll_row] = 'C'						 
						 
					 END IF
					 
				NEXT	
				
		 CASE	10 /*Pagos Masivos*/	
				SELECT cod_soles,cod_dolares
				  INTO :ls_soles,:ls_dolares
				  FROM logparam
				 WHERE reckey = '1' ;
				
				IF dw_2.Rowcount() > 1 THEN
					Messagebox('Aviso','Debe Selecionar Solo Un Documento')	
					Return
				END IF
				
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 
					 /*Verificar si Comprobante de Egreso ya fue ingresado*/
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
					 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
					 
					 
					 ll_found = wf_verifica_ed (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
					 
					 IF ll_found > 0 THEN
						 Messagebox('Aviso','Documento ya Ha Sido Ingresado '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					 ELSE	 
						 is_param.bret = TRUE
						 
						 ls_cod_moneda = dw_2.object.cod_moneda [ll_inicio]

					    IF ls_cod_moneda = ls_soles THEN
							 ldc_saldo = dw_2.object.sldo_sol  [ll_inicio]
						 ELSE
							 ldc_saldo = dw_2.object.saldo_dol [ll_inicio]
						 END IF

						 is_param.dw_m.object.origen_doc     [is_param.long1] = dw_2.object.origen	    [ll_inicio]
					 	 is_param.dw_m.object.tipo_doc       [is_param.long1] = dw_2.object.tipo_doc   [ll_inicio]
						 is_param.dw_m.object.nro_doc        [is_param.long1] = dw_2.object.nro_doc    [ll_inicio]
						 is_param.dw_m.object.importe        [is_param.long1] = ldc_saldo
						 is_param.dw_m.object.flab_tabor     [is_param.long1] = dw_2.object.flag_tabla [ll_inicio]
 						 is_param.dw_m.object.flag_cxp       [is_param.long1] = dw_2.object.flag_cxp   [ll_inicio]
					 END IF
				NEXT					
				
		 CASE 11 //PAGOS MASIVOS FONDO FIJO
				FOR ll_inicio = 1 TO dw_2.Rowcount()
		 			/*Verificar si Comprobante de Egreso ya fue ingresado*/
					ldc_importe_cab = is_param.field_ret_d2 [1]
					ldc_importe_det = is_param.field_ret_d2 [2]
					 
					ldc_importe 	 = dw_2.object.saldo		    [ll_inicio] 
					ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					ls_tipo_doc 	 = dw_2.object.tipo_doc	    [ll_inicio]
					ls_nro_doc	 	 = dw_2.object.nro_doc      [ll_inicio]
					ldc_importe_det = ldc_importe_det + ldc_importe 
				   IF ldc_importe_det > ldc_importe_cab THEN
					   Messagebox('Aviso','Importe del Documento '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' Ha Sobrepasado el Monto del Fondo Fijo')
						Return	 
   	         END IF
					 
					ll_found = wf_verifica_ce (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
				
					IF ll_found > 0 THEN
					   Messagebox('Aviso','Documento '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					ELSE	

						//*se insertara en fondo fijo*//
						ll_row = is_param.dw_m.InsertRow(0)
						 
					   IF is_param.dw_m.Rowcount()  > 1 THEN
						   ll_item = is_param.dw_m.object.item	[is_param.dw_m.Rowcount() - 1] + 1
						ELSE
						   ll_item = 1
						END IF
						
						is_param.dw_m.object.item		       [ll_row] = ll_item
						is_param.dw_m.object.proveedor       [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
					 	is_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
						is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc       [ll_inicio]
						is_param.dw_m.object.fecha_doc       [ll_row] = dw_2.object.fecha_emision [ll_inicio]
						is_param.dw_m.object.cod_moneda      [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
					 	is_param.dw_m.object.tasa_cambio     [ll_row] = dw_2.object.tasa_cambio   [ll_inicio]
						is_param.dw_m.object.importe         [ll_row] = dw_2.object.saldo		     [ll_inicio]
					   is_param.dw_m.object.descripcion     [ll_row] = dw_2.object.descripcion   [ll_inicio]	 	
 					 	is_param.dw_m.object.cencos          [ll_row] = dw_2.object.cencos        [ll_inicio]
				 	   is_param.dw_m.object.cnta_prsp       [ll_row] = dw_2.object.cnta_prsp     [ll_inicio]
						is_param.dw_m.Object.flag_estado     [ll_row] = '1'						 
						is_param.dw_m.Object.flag_tipo_gasto [ll_row] = 'P'						 
					END IF
				NEXT
				
		 CASE 12
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 /*Verificar si documento x pagar ya fue ingresado*/
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
					 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
					 
					 ll_found = wf_verifica_ce (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
					 
					 IF ll_found > 0 THEN
						 Messagebox('Aviso','Documento Provisionado '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					 ELSE	 
						 is_param.bret = TRUE
						 ll_row = is_param.dw_m.InsertRow(0) 
					    IF is_param.dw_m.Rowcount()  > 1 THEN
							 ll_item = is_param.dw_m.object.item	[is_param.dw_m.Rowcount() - 1] + 1
						 ELSE
							 ll_item = 1
						 END IF

						 is_param.dw_m.object.item		        [ll_row] = ll_item
						 is_param.dw_m.object.proveedor       [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
 					    is_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
						 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc       [ll_inicio]
						 is_param.dw_m.object.fecha_doc       [ll_row] = dw_2.object.fecha_emision [ll_inicio]
						 is_param.dw_m.object.cod_moneda      [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
						 is_param.dw_m.object.cod_moneda_cab  [ll_row] = is_param.string2
					    is_param.dw_m.object.tasa_cambio     [ll_row] = dw_2.object.tasa_cambio   [ll_inicio]
						 is_param.dw_m.object.importe         [ll_row] = dw_2.object.saldo			  [ll_inicio]
						 is_param.dw_m.object.descripcion     [ll_row] = dw_2.object.descripcion   [ll_inicio]	 	
						 is_param.dw_m.object.nom_proveedor	  [ll_row] = dw_2.object.nombre		  [ll_inicio]	
						 is_param.dw_m.object.cencos          [ll_row] = dw_2.object.cencos        [ll_inicio]
				 	    is_param.dw_m.object.cnta_prsp       [ll_row] = dw_2.object.cnta_prsp     [ll_inicio]						 
						 is_param.dw_m.Object.flag_tipo_gasto [ll_row] = 'P'
					 END IF
				NEXT
				
		 CASE 13 //Ordenes de Giro
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 /*Verificar si documento x pagar ya fue ingresado*/
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
					 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
					 
					 ll_found = wf_verifica_ce (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
					 
					 IF ll_found > 0 THEN
						 Messagebox('Aviso','Orden Giro  '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					 ELSE	 
						 is_param.bret = TRUE
						 //*se insertara en fondo fijo*//
						 ll_row = is_param.dw_m.InsertRow(0)
						 
					    IF is_param.dw_m.Rowcount()  > 1 THEN
						    ll_item = is_param.dw_m.object.item	[is_param.dw_m.Rowcount() - 1] + 1
						 ELSE
						    ll_item = 1
						 END IF
						 
						 is_param.dw_m.object.item		        [ll_row] = ll_item
						 is_param.dw_m.object.proveedor       [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
 					    is_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
						 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc       [ll_inicio]
						 is_param.dw_m.object.fecha_doc       [ll_row] = dw_2.object.fecha_emision [ll_inicio]
						 is_param.dw_m.object.cod_moneda      [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
						 is_param.dw_m.object.cod_moneda_cab  [ll_row] = is_param.string2
					    is_param.dw_m.object.tasa_cambio     [ll_row] = dw_2.object.tasa_cambio   [ll_inicio]
						 is_param.dw_m.object.importe         [ll_row] = dw_2.object.saldo			[ll_inicio]
						 is_param.dw_m.object.descripcion     [ll_row] = dw_2.object.descripcion   [ll_inicio]	 	
						 is_param.dw_m.object.nom_proveedor	  [ll_row] = dw_2.object.nombre		   [ll_inicio]	
						 is_param.dw_m.Object.flag_tipo_gasto [ll_row] = 'G'
 					 	 is_param.dw_m.object.cencos          [ll_row] = dw_2.object.cencos        [ll_inicio]
  					 	 is_param.dw_m.object.cnta_prsp       [ll_row] = dw_2.object.cnta_prsp     [ll_inicio]
					 END IF
				NEXT

		 CASE 14 //Ordenes de Giro
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 /*Verificar si documento x pagar ya fue ingresado*/
					 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
					 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
					 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
					 
					 ll_found = wf_verifica_ce (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
					 
					 IF ll_found > 0 THEN
						 Messagebox('Aviso','Orden Giro  '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
					 ELSE	 

						 is_param.bret = TRUE
						 //*se insertara en fondo fijo*//
						 ll_row = is_param.dw_m.InsertRow(0)
						 
					    IF is_param.dw_m.Rowcount()  > 1 THEN
						    ll_item = is_param.dw_m.object.item	[is_param.dw_m.Rowcount() - 1] + 1
						 ELSE
						    ll_item = 1
						 END IF
						 wf_insert_dev_og (ll_item,ll_inicio,ll_row)
					 END IF
				NEXT
				
		 CASE 16 //Liquidaciones de pesca y pago
				/*Verificar si documento ya fue ingresado*/
				For ll_inicio = 1 TO dw_2.Rowcount()
					  ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
				 	  ls_tipo_doc 	   = dw_2.object.tipo_doc	   [ll_inicio]
				 	  ls_nro_doc	 	= dw_2.object.nro_doc      [ll_inicio]
				 
				     ll_found = wf_verifica_doc_ref (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
				 
					  IF ll_found > 0 THEN
					 	  Messagebox('Aviso','Documento '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
				 	  ELSE	 
					 	  is_param.bret = TRUE

					    ll_row = is_param.dw_m.InsertRow(0)	
							
						 IF is_param.dw_m.Rowcount()  > 1 THEN
							 ll_item = is_param.dw_m.object.item	[is_param.dw_m.Rowcount() - 1] + 1
						 ELSE
							 ll_item = 1

						 END IF
						  wf_insert_liquidacion (ll_row,ll_item,ll_inicio)
    				  END IF	 		
				Next		
		
		  case 17 //seleccion usuarios de SIG711 (ENVIO DE EMAIL)
				 of_opcion17()

END CHOOSE

Closewithreturn(parent,is_param)
end event

