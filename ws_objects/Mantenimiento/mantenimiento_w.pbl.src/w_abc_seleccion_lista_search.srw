$PBExportHeader$w_abc_seleccion_lista_search.srw
forward
global type w_abc_seleccion_lista_search from w_abc_list
end type
type cb_1 from commandbutton within w_abc_seleccion_lista_search
end type
type st_campo from statictext within w_abc_seleccion_lista_search
end type
type dw_3 from datawindow within w_abc_seleccion_lista_search
end type
end forward

global type w_abc_seleccion_lista_search from w_abc_list
integer x = 50
integer width = 1797
integer height = 1380
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
st_campo st_campo
dw_3 dw_3
end type
global w_abc_seleccion_lista_search w_abc_seleccion_lista_search

type variables
String is_tipo,is_col
sg_parametros is_param
DataStore ids_cntas_pagar_det,ids_imp_x_pagar,ids_cntas_cobrar_det,ids_imp_x_cobrar,&
			 ids_imp_x_cobrar_x_doc,ids_art_a_vender
end variables

forward prototypes
public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc)
public function long wf_find_guias (string as_cod_origen, string as_nro_guia)
public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio)
end prototypes

public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_find_guias (string as_cod_origen, string as_nro_guia);String ls_expresion,ls_tipo_doc
Long   ll_found = 0,ll_row

//
////***SELECCION DE TIPO DE DOC GUIA***//
//SELECT doc_gr
//  INTO :ls_tipo_doc
//  FROM logparam
// WHERE reckey = '1' ;
////***********************************//
//
//ls_expresion = 'origen_ref = '+"'"+as_cod_origen+"'"+'  AND  nro_ref = '+"'"+as_nro_guia+"'"
//ll_found = is_param.dw_c.Find(ls_expresion, 1,is_param.dw_c.RowCount())	 
//
//IF ll_found > 0 THEN
//	Return ll_found
//ELSE
//
//	IF is_param.dw_c.triggerevent ('ue_insert') > 0 THEN
//      ll_row = w_fi300_cnts_x_cobrar.tab_1.tabpage_2.dw_detail_referencias.il_row
//		/*Datos del Registro Modificado*/
//		w_fi300_cnts_x_cobrar.ib_estado_prea = TRUE
//	   /**/
//		is_param.dw_c.Object.tipo_mov	    [ll_row] = 'C'
//	   is_param.dw_c.Object.origen_ref 	 [ll_row] = as_cod_origen
//	   is_param.dw_c.Object.tipo_ref		 [ll_row] = ls_tipo_doc
//	   is_param.dw_c.Object.nro_ref		 [ll_row] = as_nro_guia
//		is_param.dw_c.Object.flab_tabor	 [ll_row] = '9' //Guias de Remision
Return ll_found
//	END IF
//END IF
//


end function

public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'cod_relacion = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio);//Long   ll_fdw_d,j,ll_found
//String ls_soles, ls_dolares,ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc,&
//		 ls_item
//
//Rollback;
//DECLARE PB_USP_FIN_ADD_ART_X_GUIA_X_VALE PROCEDURE FOR USP_FIN_ADD_ART_X_GUIA_X_VALE
//(:as_cod_origen,:as_nro_guia,:as_cod_moneda,:adc_tasa_cambio);
//EXECUTE PB_USP_FIN_ADD_ART_X_GUIA_X_VALE ;
//
//
//IF SQLCA.SQLCode = -1 THEN 
//	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_ADD_ART_X_GUIA_X_VALE , Comunicar en Area de Sistemas' )
//	RETURN
//END IF
//
//
//ids_art_a_vender.Retrieve()
//
//
//
////* Codigo de Moneda Soles y Dolares *//
//SELECT cod_soles,cod_dolares
//  INTO :ls_soles,:ls_dolares
//  FROM logparam   
// WHERE reckey = '1'   ;
////***********************************// 
//
//
//FOR j=1 TO ids_art_a_vender.Rowcount()
//	 
//	 IF is_param.dw_d.Rowcount () = w_fi300_cnts_x_cobrar.ii_lin_x_doc	THEN
//		 Messagebox('Aviso','No Puede Exceder de '+Trim(String(w_fi300_cnts_x_cobrar.ii_lin_x_doc))+' Items x Documento')	
//		 Return 
//	 END IF
//	 
//	 ls_cod_art    = ids_art_a_vender.object.cod_art    [j] 
//	 ls_cod_moneda = ids_art_a_vender.object.cod_moneda [j] 
//	 
//	 ls_expresion  = 'cod_art ='+"'"+ls_cod_art+"'"
//	 ll_found      = is_param.dw_d.find(ls_expresion,1,is_param.dw_d.rowcount())
//	 
//	 IF ll_found > 0 THEN 
//		 is_param.dw_d.Object.cantidad        [ll_found] = is_param.dw_d.Object.cantidad     [ll_found] + ids_art_a_vender.Object.cant_procesada [j]
//		 is_param.dw_d.Object.cant_proyect    [ll_found] = is_param.dw_d.Object.cant_proyect [ll_found] + ids_art_a_vender.Object.cant_proyect   [j]
//	 ELSE
//	    IF is_param.dw_d.triggerevent ('ue_insert') > 0 THEN
//          ll_fdw_d = w_fi300_cnts_x_cobrar.tab_1.tabpage_1.dw_detail.il_row
//			 /*Datos del Registro Modificado*/
//			 w_fi300_cnts_x_cobrar.ib_estado_prea = TRUE
//		    /**/			 
//			  
//			 IF ls_cod_moneda = ls_soles      THEN
//				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_soles   [j]
//			 ELSEIF ls_cod_moneda = ls_dolares    THEN
//				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_dolares [j]
//			 END IF
//			 
//			 is_param.dw_d.Object.cod_art         [ll_fdw_d] = ids_art_a_vender.Object.cod_art 			 [j]
//			 is_param.dw_d.Object.descripcion     [ll_fdw_d] = ids_art_a_vender.Object.nom_articulo    [j]
//			 is_param.dw_d.Object.cantidad        [ll_fdw_d] = ids_art_a_vender.Object.cant_procesada  [j]
//			 is_param.dw_d.Object.cant_proyect    [ll_fdw_d] = ids_art_a_vender.Object.cant_proyect    [j]
//			 is_param.dw_m.Object.moneda_det	     [1] 		 = is_param.string3
//			 is_param.dw_m.Object.tasa_cambio_det [1] 		 = is_param.db2
//			 is_param.dw_m.Object.cod_relacion_det[1] 	    = is_param.string2
//			 is_param.dw_d.Object.confin			  [ll_fdw_d] = ids_art_a_vender.Object.confin 			 [j]
//			 is_param.dw_d.Object.matriz_cntbl	  [ll_fdw_d] = ids_art_a_vender.object.matriz_cntbl    [j]
//			 is_param.dw_d.Object.flag				  [ll_fdw_d] = 'G'	
//			 is_param.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = ids_art_a_vender.object.tipo_cred_fiscal[j]
//			 
//			 //Recalculo de Impuesto				 
//			 ls_item = Trim(String(is_param.dw_d.Object.item  [ll_fdw_d]))
//			 w_fi300_cnts_x_cobrar.wf_generacion_imp (ls_item)
//			 
//			 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
//			 
//		    //Asigno total
//			 w_fi300_cnts_x_cobrar.dw_master.object.importe_a_cobrar [w_fi300_cnts_x_cobrar.dw_master.getrow()] = w_fi300_cnts_x_cobrar.wf_totales ()
//			 w_fi300_cnts_x_cobrar.dw_master.ii_update = 1
//		 END IF	
//	 END IF	
//NEXT
//




end subroutine

on w_abc_seleccion_lista_search.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_campo=create st_campo
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_campo
this.Control[iCurrent+3]=this.dw_3
end on

on w_abc_seleccion_lista_search.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_campo)
destroy(this.dw_3)
end on

event ue_open_pre;// Overr
String ls_null
Long   ll_row

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
	//Inicializar Variable de Busqueda //
	
	CHOOSE CASE is_param.String1
			 CASE '1RPP'
					is_col = 'codigo'
			 CASE	'1BCO'
					is_col = 'cod_banco'
			 CASE '1HNV'
					is_col = 'tipo_doc'
			 CASE '1AJCP' //Ajuste x Cantidad y/o precio de nc,nd x cobrar
					is_col = 'cod_art'
			 CASE	'1RNDC' //Por reversion de Doc. de Nota de Credito	
					is_col = 'tipo_doc'
			 CASE	'1INDC' //Por Interes de Fac, Bol , Let x Cobrar
					is_col = 'tipo_doc'
			 CASE	'1DNCC' //Por Descuento por Pronto Pago
					is_col = 'tipo_doc'
			 CASE	'1RPL'  //Reporte de Libro Bancos	
			 CASE '1GR'   //Guia de remision
					is_col = 'nro_guia'
			 CASE	'1PED'	//Comprobante de Egreso
					is_col = 'nro_doc'
			 CASE	'1CHC'  //Cheques a Conciliar	
					is_col = 'cheque_emitir_cod_ctabco'
			 CASE	'1ART'  //Articulo
					is_col = 'cod_art'
			 CASE	'1DCC'  //Documento a Conciliar
					is_col = 'caja_bancos_tipo_doc'
			 CASE	'1CCOS' //Centro de Costo	
			 		is_col = 'cencos'
			 CASE	'1MAQ'  //MAQUINA
					is_col = 'cod_maquina'
 			 CASE	'1CLI'  //CLIENTE
					is_col = 'cod_relacion'
			 CASE	'1OADM' //ADM DE OT
					is_col = 'ot_adm'
			 CASE	'1CTA'  //CUENTA PRESUPUESTAL
					is_col = 'cnta_prsp'
			 CASE	'1OTIP'  //TIPO DE OT
					is_col = 'ot_tipo'					
	END CHOOSE

	
	
	IF Trim(is_param.tipo) = '' OR Isnull(is_param.tipo) THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
	ELSE		// caso contrario hace un retrieve con parametros
		CHOOSE CASE is_param.tipo
			    CASE '1NVP' //Nota de Ventas Por Pagar
						dw_1.Retrieve(is_param.string2) 
			 	 CASE '1AJCP' //Ajuste x Cantidad y/o precio de nc,nd x cobrar
						dw_1.Retrieve(is_param.string2) 
				 CASE	'1RNDC' //Por Reversion de Doc. de Nota de Credito		
						dw_1.Retrieve(is_param.string2) 
				 CASE	'1INDC' //Por Interes de Fac, Bol , Let x Cobrar
						dw_1.Retrieve(is_param.string2) 						
				 CASE	'1DNCC' //Por Descuento por Pronto Pago
						dw_1.Retrieve(is_param.string2)
				 CASE	'1GR'	  //Guias de Remision sin Orden de Venta
						dw_1.Retrieve(is_param.string2)
				 CASE	'1PED'  //Comprobante de Egreso
						dw_1.Retrieve(is_param.string3)
				 CASE	'1CHC'  //Cheques a Conciliar
						dw_1.Retrieve(is_param.string2)	
				 CASE	'1DCC'  //Documentos a Conciliar		
						dw_1.Retrieve(is_param.string2)	
				 CASE	'1NVP'  //nota debito credito x pagar
						dw_1.Retrieve(is_param.string4)	
							
		END CHOOSE
	END IF





end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista_search
integer x = 9
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
end if

ii_ss 	  = 0
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form
idw_det  = dw_2 				// dw_detail 

ii_ck[1] = 1         // columnas de lectrua de este dw

CHOOSE CASE is_param.opcion 
	 	 CASE 1    // Proveedores Programa de Pagos
			   ii_dk[1] = 1		//Codigo	
				ii_dk[2] = 2		//Nombres
				ii_rk[1] = 1		//Codigo	
				ii_rk[2] = 2		//Nombres
	 	 CASE 2    // Bancos
			   ii_dk[1] = 1		//Codigo	
				ii_dk[2] = 2		//Nombres
				ii_rk[1] = 1		//Codigo	
				ii_rk[2] = 2		//Nombres				
				
		 CASE 3    //Documentos x Pagar
				ii_dk[1] = 1		//
				ii_dk[2] = 2		//
				ii_dk[3] = 3		//
				ii_dk[4] = 4		//
				ii_dk[5] = 5		//
				ii_dk[6] = 6		//
				ii_dk[7] = 7		//
				///////
				ii_rk[1] = 1		//
				ii_rk[2] = 2		//
				ii_rk[3] = 3		//
				ii_rk[4] = 4		//
				ii_rk[5] = 5		//
				ii_rk[6] = 6		//
				ii_rk[7] = 7		//
				
		 CASE 4    //Ajuste x Cantidad y/o precio de nc,nd x cobrar
				ii_dk[1] = 1		//Tipo Doc
				ii_dk[2] = 2		//Nro Doc 
				ii_dk[3] = 3		//Item
				ii_dk[4] = 4		//Confin
				ii_dk[5] = 5		//Descripcion
				ii_dk[6] = 6		//Codigo Articulo
				ii_dk[7] = 7		//Codigo Moneda
				ii_dk[8] = 8		//Precio Unitario
				ii_dk[9] = 9		//Matriz Contable
				
				//////
				ii_rk[1] = 1		//Tipo Doc
				ii_rk[2] = 2		//Nro Doc 
				ii_rk[3] = 3		//Item
				ii_rk[4] = 4		//Confin
				ii_rk[5] = 5		//Descripcion
				ii_rk[6] = 6		//Codigo Articulo
				ii_rk[7] = 7		//Codigo Moneda				
				ii_rk[8] = 8		//Precio Unitario
				ii_dk[9] = 9		//Matriz Contable
				
		 CASE 5,6,7    //Reversión de de Documentos
							//de nota de credito x cobrar y
							//anulacion de facturas,boletas, nota de debito , nota de credito
							//Por Interes de Fac,Bol,Let x Cobrar
							//Por Descuento por Pronto Pago
							
				ii_dk[1] = 1		//Tipo Doc
				ii_dk[2] = 2		//Nro doc
				ii_dk[3] = 3		//Codigo Relacion
				ii_dk[4] = 4		//Moneda
				ii_dk[5] = 5		//Origen
				ii_dk[6] = 6      //Año
				ii_dk[7] = 7      //Mes
				ii_dk[8] = 8		//Nro Libro
				ii_dk[9] = 9		//Nro Asiento
				/**/
				ii_rk[1] = 1		//Tipo Doc
				ii_rk[2] = 2		//Nro doc
				ii_rk[3] = 3		//Codigo Relacion
				ii_rk[4] = 4		//Moneda
				ii_rk[5] = 5		//Origen
				ii_rk[6] = 6		//Año
				ii_rk[7] = 7		//Mes
				ii_rk[8] = 8		//Nro Libro
				ii_rk[9] = 9		//Nro Asiento
							

		 CASE 8 //REPORTE DE LIBRO BANCOS
				ii_dk[1] = 1 //Cuenta de Banco 
				ii_dk[2] = 2 //Descripcion
				ii_dk[3] = 3 //Cuenta Contable
				ii_dk[4] = 4 //Origen
				
				ii_rk[1] = 1 //Cuenta de Banco 
				ii_rk[2] = 2 //Descripcion
				ii_rk[3] = 3 //Cuenta Contable
				ii_rk[4] = 4 //Origen
		CASE	10 //origenes
				ii_dk[1]  = 1  //codigo
				ii_dk[2]  = 2  //descripcion
				
				ii_rk[1]  = 1  //codigo
				ii_rk[2]  = 2  //descripcion							
      CASE  11
				ii_dk[1] = 1 //NRO DE GUIA
				ii_dk[2] = 2 //ORIGEN
				ii_dk[3] = 3 //FECHA DE REGISTRO
				ii_dk[4] = 4 //USUARIO
				
				ii_rk[1] = 1 //NRO DE GUIA 
				ii_rk[2] = 2 //ORIGEN
				ii_rk[3] = 3 //FECHA DE REGISTRO
				ii_rk[4] = 4 //USUARIO
				
		CASE	12 //Comprobantes de Egresos
				ii_dk[1]  = 1	//cod_relacion
				ii_dk[2]  = 2	//tipo_doc
				ii_dk[3]  = 3	//nro_doc
				ii_dk[4]  = 4	//total_pagar
				ii_dk[5]  = 5	//cod_moneda
				ii_dk[6]  = 6	//nombre
				ii_dk[7]  = 7	//origen
					
				ii_rk[1]  = 1  //cod_relacion
				ii_rk[2]  = 2  //tipo doc
				ii_rk[3]  = 3  //nro doc
				ii_rk[4]  = 4  //total_pagar
				ii_rk[5]  = 5  //cod_moneda
				ii_rk[6]  = 6  //nombre
				ii_rk[7]  = 7  //origen

		CASE	13 ,15 //Cheques a Conciliar,Documentos a Conciliar
				ii_dk [1] = 1 //Nro Reg cheque
				ii_dk [2] = 2 //Cuenta de Banco	
				ii_dk [3] = 3 //Nro de Cheque
				ii_dk [4] = 4 //Importe
				ii_dk [5] = 5 //Origen Caja Bancos
				ii_dk [6] = 6 //Nro Registro Caja Bancos
				ii_dk [7] = 7 //Cheque Afavor
				ii_dk [8] = 8 //Fecha Emision
				ii_dk [9] = 9 //Voucher
				
				ii_rk [1] = 1 //Nro Reg cheque
				ii_rk [2] = 2 //Cuenta de Banco	
				ii_rk [3] = 3 //Nro de Cheque
				ii_rk [4] = 4 //Importe
				ii_rk [5] = 5 //Origen Caja Bancos
				ii_rk [6] = 6 //Nro Registro Caja Bancos
				ii_rk [7] = 7 //Cheque Afavor
				ii_rk [8] = 8 //Fecha Emision
				ii_rk [9] = 9 //Voucher				
				
		CASE	14,16,17,18,19,20,21,22,23,24,25,26,27//Articulo,Concepto Finanaciero,centro de costo,maquina,cliente,ot_adm,cnta prsp,ot_tipo
				ii_dk [1] = 1 //Codigo
				ii_dk [2] = 2 //Nombre
				
				ii_rk [1] = 1 //Codigo
				ii_rk [2] = 2 //Nombre
				
END CHOOSE
ii_ss = 0
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_1::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	   ll_row, ll_rc
Any	   la_id
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

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
//	is_tipo = 
	is_col  = UPPER( mid(ls_column,1,li_pos - 1) )	
	is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_3.reset()
	dw_3.InsertRow(0)
	dw_3.SetFocus()

END IF
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista_search
integer x = 699
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1
CHOOSE CASE is_param.opcion 
		 CASE 1 //Proveedores Programa de Pagos
				ii_rk[1] = 1		//Codigo
				ii_rk[2] = 2		//Nombres
				ii_dk[1] = 1		//Codigo
				ii_dk[2] = 2		//Nombres
		 CASE 2 //Bancos
				ii_rk[1] = 1		//Codigo
				ii_rk[2] = 2		//Nombres
				ii_dk[1] = 1		//Codigo
				ii_dk[2] = 2		//Nombres
		 CASE 3    //Documentos x Pagar
			
				ii_rk[1] = 1		//
				ii_rk[2] = 2		//
				ii_rk[3] = 3		//
				ii_rk[4] = 4		//
				ii_rk[5] = 5		//
				ii_rk[6] = 6		//
				ii_rk[7] = 7		//
				////////
				ii_dk[1] = 1		//
				ii_dk[2] = 2		//
				ii_dk[3] = 3		//
				ii_dk[4] = 4		//
				ii_dk[5] = 5		//
				ii_dk[6] = 6		//
				ii_dk[7] = 7		//
		 CASE 4    //Ajuste x Cantidad y/o precio de nc,nd x cobrar
				ii_rk[1] = 1		//Tipo Doc
				ii_rk[2] = 2		//Nro Doc 
				ii_rk[3] = 3		//Item
				ii_rk[4] = 4		//Confin
				ii_rk[5] = 5		//Descripcion
				ii_rk[6] = 6		//Codigo Articulo
				ii_rk[7] = 7		//Codigo Moneda
				ii_rk[8] = 8		//Codigo Moneda
				ii_rk[9] = 9		//Matriz Contable
				//////
				ii_dk[1] = 1		//Tipo Doc
				ii_dk[2] = 2		//Nro Doc 
				ii_dk[3] = 3		//Item
				ii_dk[4] = 4		//Confin
				ii_dk[5] = 5		//Descripcion
				ii_dk[6] = 6		//Codigo Articulo
				ii_dk[7] = 7		//Codigo Moneda				
				ii_dk[8] = 8		//Codigo Moneda	
				ii_dk[9] = 9		//Matriz Contable
				
		 CASE 5,6,7			//Por Reversion de Documento 
								//Por Interes de Fac,Bol,Let x Cobrar
								//Por Descuento por Pronto Pago
								
				ii_rk[1] = 1		//Tipo Doc
				ii_rk[2] = 2		//Nro doc
				ii_rk[3] = 3		//Codigo Relacion
				ii_rk[4] = 4		//Moneda
				ii_rk[5] = 5		//Origen
				ii_rk[6] = 6		//Año
				ii_rk[7] = 7		//Mes
				ii_rk[8] = 8		//Nro Libro
				ii_rk[9] = 9		//Nro Asiento
				
				/**/
				ii_dk[1] = 1		//Tipo Doc
				ii_dk[2] = 2		//Nro doc
				ii_dk[3] = 3		//Codigo Relacion
				ii_dk[4] = 4		//Moneda
				ii_dk[5] = 5		//Origen
				ii_dk[6] = 6		//Año
				ii_dk[7] = 7		//Mes
				ii_dk[8] = 8		//Nro Libro
				ii_dk[9] = 9		//Nro Asiento

		 CASE 8 //REPORTE DE LIBRO BANCOS
				ii_dk[1] = 1 //Cuenta de Banco 
				ii_dk[2] = 2 //Descripcion
				ii_dk[3] = 3 //Cuenta Contable
				ii_dk[4] = 4 //Origen
				
				ii_rk[1] = 1 //Cuenta de Banco 
				ii_rk[2] = 2 //Descripcion
				ii_rk[3] = 3 //Cuenta Contable
				ii_rk[4] = 4 //Origen
		CASE	10 //origenes
				ii_rk[1]  = 1  //codigo
				ii_rk[2]  = 2  //descripcion
				
				ii_dk[1]  = 1  //codigo
				ii_dk[2]  = 2  //descripcion							
				
      CASE  11
				ii_rk[1] = 1 //NRO DE GUIA 
				ii_rk[2] = 2 //ORIGEN
				ii_rk[3] = 3 //FECHA DE REGISTRO
				ii_rk[4] = 4 //USUARIO				
				
				ii_dk[1] = 1 //NRO DE GUIA
				ii_dk[2] = 2 //ORIGEN
				ii_dk[3] = 3 //FECHA DE REGISTRO
				ii_dk[4] = 4 //USUARIO
      CASE  12 //Comprobantes de Egresos
				ii_rk[1]  = 1	//cod_relacion
				ii_rk[2]  = 2	//tipo_doc
				ii_rk[3]  = 3	//nro_doc
				ii_rk[4]  = 4	//total_pagar
				ii_rk[5]  = 5	//cod_moneda
				ii_rk[6]  = 6	//nombre
				ii_rk[7]  = 7	//origen
					
				ii_dk[1]  = 1  //cod_relacion
				ii_dk[2]  = 2  //tipo doc
				ii_dk[3]  = 3  //nro doc
				ii_dk[4]  = 4  //total_pagar
				ii_dk[5]  = 5  //cod_moneda
				ii_dk[6]  = 6  //nombre
				ii_dk[7]  = 7  //origen
				
		CASE	13 ,15 //Cheques a Conciliar,Documentos a Conciliar
				ii_rk [1] = 1 //Nro Reg cheque
				ii_rk [2] = 2 //Cuenta de Banco	
				ii_rk [3] = 3 //Nro de Cheque
				ii_rk [4] = 4 //Importe
				ii_rk [5] = 5 //Origen Caja Bancos
				ii_rk [6] = 6 //Nro Registro Caja Bancos
				ii_rk [7] = 7 //Cheque Afavor
				ii_rk [8] = 8 //Fecha Emision
				ii_rk [9] = 9 //Voucher				
							
				ii_dk [1] = 1 //Nro Reg cheque
				ii_dk [2] = 2 //Cuenta de Banco	
				ii_dk [3] = 3 //Nro de Cheque
				ii_dk [4] = 4 //Importe
				ii_dk [5] = 5 //Origen Caja Bancos
				ii_dk [6] = 6 //Nro Registro Caja Bancos
				ii_dk [7] = 7 //Cheque Afavor
				ii_dk [8] = 8 //Fecha Emision
				ii_dk [9] = 9 //Voucher
				
		CASE	14,16,17,18,19,20,21,22,23,24,25,26,27 //Articulo,Concepto financiero,centro de costo,maquina,cliente,ot_adm,cnta_prsp,ot_tipo
				ii_rk [1] = 1 //Codigo
				ii_rk [2] = 2 //Nombre
				
				ii_dk [1] = 1 //Codigo
				ii_dk [2] = 2 //Nombre
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

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_lista_search
integer x = 539
integer y = 456
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista_search
integer x = 539
integer y = 704
end type

type cb_1 from commandbutton within w_abc_seleccion_lista_search
integer x = 1472
integer y = 20
integer width = 297
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;Long   ll_inicio,ll_found,ll_row,ll_row_det,ll_item,ll_ins_row,ll_inicio_cab, &
		 ll_ins_row_det,ll_inicio_det,ll_ind_guia
String ls_codigo,ls_expresion,ls_origen_ref,ls_tipo_ref,ls_nro_ref,&
       ls_flab_tabor,ls_cod_relacion,ls_cod_moneda,ls_cod_moneda_det,&
		 ls_cod_art,ls_confin,ls_descrip,ls_tipo_doc,ls_nro_doc,ls_tip_impuesto,&
		 ls_cnta_ctbl,ls_desc_impuesto,ls_signo,ls_desc_cnta,ls_matriz,&
		 ls_flag_dh  ,ls_cod_origen,ls_guia_rem,ls_cegreso,ls_null,ls_doc_cheque,&
		 ls_descripcion,ls_grupo
Decimal {6} ldc_precio_unitario
Decimal {4} ldc_cantidad_det
Decimal {2} ldc_tasa_imp,ldc_imp_imp

dw_2.Accepttext()



CHOOSE CASE is_param.opcion
		 CASE 1 //Programa de Pagos
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.Object.codigo [ll_inicio]	 
					 //Inserción de Proveedores
				    Insert Into tt_fin_proveedor
			       (cod_proveedor)  
					 VALUES 
					 (:ls_codigo)  ;

				NEXT	
		 CASE 2 //Bancos
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.Object.cod_banco [ll_inicio]	 
					 //Inserción de Proveedores
				    Insert Into tt_fin_banco
			       (cod_banco)  
					 VALUES 
					 (:ls_codigo)  ;
				NEXT	
		 CASE 3 //NOTA DE VENTAS X PAGAR						
			
				is_param.dw_m.Accepttext()
				is_param.dw_d.Accepttext()

				
				For ll_inicio = 1 TO dw_2.Rowcount()
					 
					 //Motivo del Documento is_param.string3  
					 IF is_param.string3 = 'NCP002' THEN //Reversión de Documento
						 IF is_param.dw_d.Rowcount()  > 0 THEN
							 Messagebox('Aviso','No Puede Ingresar Mas De Un documento Cuando se '&
							 						 +'Trata de Reversión de Documento')
							 GOTO SALIDA	 					  
						 END IF

					 END IF
					 
					 
					 ls_origen_ref	    = dw_2.Object.origen		 [ll_inicio]
					 ls_tipo_ref	    = dw_2.Object.tipo_doc     [ll_inicio]
					 ls_nro_ref		    = dw_2.Object.nro_doc      [ll_inicio]
					 ls_flab_tabor	    = dw_2.Object.flag_tabla   [ll_inicio]
					 ls_cod_relacion   = dw_2.Object.cod_relacion [ll_inicio]
					 ls_cod_moneda_det = dw_2.object.cod_moneda   [ll_inicio] 
					 
					 ls_expresion = 'origen_ref = '+"'"+ls_origen_ref+"'"+' AND tipo_ref = '&
										+"'"+ls_tipo_ref+"'"+' AND nro_ref = '+"'"+ls_nro_ref+"'"
				
					 ll_found = is_param.dw_d.find(ls_expresion,1,is_param.dw_d.rowcount())
					 
					IF ll_found > 0 THEN
						Messagebox('Aviso','Documento '+ls_tipo_ref+' '+ls_nro_ref+' Ya Ha Sido Tomado En cuenta Verifique1!')
						GOTO SALIDA
					ELSE
						//**Moneda de Cabecera**//
						ls_cod_moneda 		= is_param.dw_m.object.cod_moneda [1] 
						
						IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
							is_param.dw_m.object.cod_moneda [1]  = ls_cod_moneda_det
						ELSE
							IF ls_cod_moneda <> ls_cod_moneda_det THEN
								Messagebox( 'Aviso','Documento '+ls_tipo_ref+' '+ls_nro_ref&
											  +' Tiene Diferente Tipo de Moneda Verifique!')								
								GOTO SALIDA
							END IF
						END IF
						
						//** **//
						
						
						
						ll_row = is_param.dw_d.InsertRow(0)
						
						
						is_param.dw_d.object.cod_relacion [ll_row] = ls_cod_relacion
						is_param.dw_d.object.tipo_mov     [ll_row] = 'P'
						is_param.dw_d.object.origen_ref   [ll_row] = ls_origen_ref
						is_param.dw_d.object.tipo_ref	    [ll_row] = ls_tipo_ref
						is_param.dw_d.object.nro_ref	    [ll_row] = ls_nro_ref
						is_param.dw_d.object.flab_tabor   [ll_row] = ls_flab_tabor
						
						is_param.accion = 'aceptar'
						
						
						//*Motivo Por Reversión de Documento*//
						IF is_param.string3 = 'NCP002' THEN
							
							ids_cntas_pagar_det.Retrieve(ls_cod_relacion,ls_tipo_ref,ls_nro_ref)
							ids_imp_x_pagar.Retrieve(ls_cod_relacion,ls_tipo_ref,ls_nro_ref)
							
							
							
							/*Inserto detalle de Cntas x Pagar*/
						
							For ll_inicio = 1 TO ids_cntas_pagar_det.Rowcount()
								 ll_row_det = is_param.dw_c.InsertRow(0)								 
								 is_param.dw_c.Object.cod_relacion     [ll_inicio] = ids_cntas_pagar_det.Object.cod_relacion     [ll_row_det]
								 is_param.dw_c.Object.item             [ll_inicio] = ids_cntas_pagar_det.Object.item 				 [ll_row_det]
								 is_param.dw_c.Object.descripcion	   [ll_inicio] = ids_cntas_pagar_det.Object.descripcion 	    [ll_row_det]
								 is_param.dw_c.Object.cod_art          [ll_inicio] = ids_cntas_pagar_det.Object.cod_art 			 [ll_row_det]
								 is_param.dw_c.Object.confin           [ll_inicio] = ids_cntas_pagar_det.Object.confin 			 [ll_row_det]
								 is_param.dw_c.Object.cantidad         [ll_inicio] = ids_cntas_pagar_det.Object.cantidad 		    [ll_row_det]
								 is_param.dw_c.Object.importe          [ll_inicio] = ids_cntas_pagar_det.Object.importe 			 [ll_row_det]
								 is_param.dw_c.Object.cencos           [ll_inicio] = ids_cntas_pagar_det.Object.cencos 			 [ll_row_det]
								 is_param.dw_c.Object.cnta_prsp        [ll_inicio] = ids_cntas_pagar_det.Object.cnta_prsp		    [ll_row_det]
								 is_param.dw_c.Object.tipo_cred_fiscal [ll_inicio] = ids_cntas_pagar_det.Object.tipo_cred_fiscal [ll_row_det]
								 is_param.dw_c.Object.matriz_cntbl		[ll_inicio] = ids_cntas_pagar_det.Object.matriz_cntbl		 [ll_row_det]
//								 is_param.dw_c.Object.flag_hab			[ll_inicio] = 'S'
							Next
						
							//**// 
						
							/*Inserto detalle de Impuesto x Cntas x Pagar*/
							For ll_inicio = 1 TO ids_imp_x_pagar.Rowcount()
								 ll_row_det = is_param.dw_e.InsertRow(0)
							 	 is_param.dw_e.Object.cod_relacion  [ll_row_det] = ids_imp_x_pagar.Object.cod_relacion  [ll_inicio]
							 	 is_param.dw_e.Object.tipo_doc	   [ll_row_det] = ids_imp_x_pagar.Object.tipo_doc 	    [ll_inicio]
							 	 is_param.dw_e.Object.nro_doc       [ll_row_det] = ids_imp_x_pagar.Object.nro_doc 		 [ll_inicio] 
							 	 is_param.dw_e.Object.item          [ll_row_det] = ids_imp_x_pagar.Object.item 			 [ll_inicio] 
							 	 is_param.dw_e.Object.tipo_impuesto [ll_row_det] = ids_imp_x_pagar.Object.tipo_impuesto [ll_inicio]
						    	 is_param.dw_e.Object.importe		   [ll_row_det] = ids_imp_x_pagar.Object.importe		 [ll_inicio]
							 	 is_param.dw_e.Object.tasa_impuesto [ll_row_det] = ids_imp_x_pagar.Object.tasa_impuesto [ll_inicio]
								 is_param.dw_e.Object.flag          [ll_row_det] = 'S'
         					 is_param.dw_e.Object.cnta_ctbl		[ll_row_det] = ids_imp_x_pagar.Object.cnta_ctbl 	 [ll_inicio]
								 is_param.dw_e.Object.desc_impuesto	[ll_row_det] = ids_imp_x_pagar.Object.desc_impuesto [ll_inicio]
								 is_param.dw_e.Object.signo			[ll_row_det] = ids_imp_x_pagar.Object.signo			 [ll_inicio]
								 is_param.dw_e.Object.desc_cnta		[ll_row_det] =	ids_imp_x_pagar.Object.desc_cnta		 [ll_inicio]
                         is_param.dw_e.Object.flag_dh_cxp	[ll_row_det] = ids_imp_x_pagar.Object.flag_dh_cxp	 [ll_inicio]
							Next
						
						//**//
						END IF
						
					END IF
					
					SALIDA:
			   Next
				
		 CASE 4 //Ajuste x Cantidad y/o precio nota debito,credito X cobrar
				
				For ll_inicio_cab = 1 TO dw_2.Rowcount()
					 ls_cod_moneda = is_param.dw_m.object.cod_moneda [1] 
 					 ls_tipo_doc   = dw_2.object.tipo_doc     [ll_inicio_cab]	
					 ls_nro_doc    = dw_2.object.nro_doc      [ll_inicio_cab]	
					 ll_item		   = dw_2.object.item	      [ll_inicio_cab]	
					 ls_cod_art		= dw_2.object.cod_art      [ll_inicio_cab]	
					 ls_confin		= dw_2.object.confin	      [ll_inicio_cab]	
					 ls_descrip  	= dw_2.object.descripcion  [ll_inicio_cab]	
					 ls_matriz  	= dw_2.object.matriz_cntbl [ll_inicio_cab]	
					 ldc_precio_unitario = dw_2.object.precio_unitario [ll_inicio_cab]
					 
					 ls_expresion = "tipo_ref = '"+ls_tipo_doc+"' AND nro_ref = '"+ls_nro_doc+"' AND item_ref = "+Trim(String(ll_item))
					 ll_found	  = is_param.dw_d.Find(ls_expresion,1,is_param.dw_d.rowcount())

					 IF ll_found = 0 THEN
						 /*Item No Ha Sido Tomado En Cuenta*/	
					 	 ls_cod_moneda_det = dw_2.object.cod_moneda [ll_inicio_cab]

					 	 IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
						 	 ls_cod_moneda = ls_cod_moneda_det
						 	 is_param.dw_m.object.cod_moneda [1] = ls_cod_moneda
					 	 END IF
					 
					 	 IF ls_cod_moneda <> ls_cod_moneda_det THEN //Si Moneda es Diferente Salir
					 	 	 Messagebox ('Aviso','Aviso No Puede Escoger Un Documento con Otro Tipo de Moneda , Verifique!')
						 	 EXIT
					 	 END IF
					 
					 	 ll_ins_row = is_param.dw_d.InsertRow(0)
				 	    /*Activara ii_update de dw_detail e impuestos */
						 is_param.titulo = 's'
					 
					 	 is_param.dw_d.Object.item 	        [ll_ins_row] = ll_ins_row
					 	 is_param.dw_d.Object.tipo_ref        [ll_ins_row] = ls_tipo_doc
					 	 is_param.dw_d.Object.nro_ref         [ll_ins_row] = ls_nro_doc
					 	 is_param.dw_d.Object.item_ref        [ll_ins_row] = ll_item
					 	 is_param.dw_d.Object.cod_art     	  [ll_ins_row] = ls_cod_art
					 	 is_param.dw_d.Object.descripcion 	  [ll_ins_row] = ls_descrip
					 	 is_param.dw_d.Object.cantidad    	  [ll_ins_row] = 1 
					 	 is_param.dw_d.Object.precio_unitario [ll_ins_row] = ldc_precio_unitario
					 	 is_param.dw_d.Object.confin		 	  [ll_ins_row] = ls_confin
						 is_param.dw_d.Object.matriz_cntbl 	  [ll_ins_row] = ls_matriz
					 	 /**/
					 	 is_param.dw_d.Object.flag_rev	 [ll_ins_row] = 'AJ'
					 
					 	 /**/
					 
					 	 is_param.dw_d.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
					 	 is_param.dw_d.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
					 	 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag_rev),1,0)'")
					 	 is_param.dw_d.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
					 	 //campos bloqueados no editables					 

					 	 /**Inserta Impuestos **/ 
					 	 ids_imp_x_cobrar.Retrieve(ls_tipo_doc,ls_nro_doc,ll_item)
					 	 For ll_inicio = 1 to ids_imp_x_cobrar.Rowcount()
							
						     ls_tip_impuesto  = ids_imp_x_cobrar.object.tipo_impuesto [ll_inicio]
						  	  ls_cnta_ctbl		 = ids_imp_x_cobrar.object.cnta_ctbl	  [ll_inicio]
						     ls_desc_impuesto = ids_imp_x_cobrar.object.desc_impuesto [ll_inicio]
							  ldc_tasa_imp		 = ids_imp_x_cobrar.object.tasa_impuesto [ll_inicio]
						  	  ls_signo			 = ids_imp_x_cobrar.object.signo			  [ll_inicio]
						  	  ls_desc_cnta		 = ids_imp_x_cobrar.object.desc_cnta	  [ll_inicio]
						  	  ldc_imp_imp	 	 = ids_imp_x_cobrar.object.importe		  [ll_inicio]
							  ls_flag_dh		 = ids_imp_x_cobrar.object.flag_dh		  [ll_inicio]

						  	  ll_ins_row_det = is_param.dw_c.insertRow(0)	
						  	  /*Activar ii_update*/
						  	  is_param.dw_c.Object.item 	  	    [ll_ins_row_det] = ll_ins_row
						  	  is_param.dw_c.Object.tipo_impuesto [ll_ins_row_det] = ls_tip_impuesto
						     is_param.dw_c.Object.cnta_ctbl		 [ll_ins_row_det] = ls_cnta_ctbl
						     is_param.dw_c.Object.desc_impuesto [ll_ins_row_det] = ls_desc_impuesto
						  	  is_param.dw_c.Object.tasa_impuesto [ll_ins_row_det] = ldc_tasa_imp
						  	  is_param.dw_c.Object.signo			 [ll_ins_row_det] = ls_signo
						  	  is_param.dw_c.Object.desc_cnta		 [ll_ins_row_det] = ls_desc_cnta
					     	  is_param.dw_c.Object.importe	  	 [ll_ins_row_det] = ldc_imp_imp
							  is_param.dw_c.Object.flag_dh_cxp	 [ll_ins_row_det] = ls_flag_dh
						  	  is_param.dw_c.Object.flag_imp	  	 [ll_ins_row_det] = 'AJ'
						  
					 	     is_param.dw_c.Modify("tipo_impuesto.Protect='1~tIf(IsNull(flag_tipo),1,0)'")
					 	     is_param.dw_c.Modify("importe.Protect='1~tIf(IsNull(flag_imp),1,0)'")					 
					 	  	  //campos bloqueados no editables					 
					    Next

					 ELSE
						 Messagebox('Aviso','Item de Referencia Nº '+ Trim(String(ll_item)) +' de Documento '+ ls_tipo_doc +' '+ls_nro_doc+' ya ha sido tomado en cuenta ' )
					 END IF
				Next

		 CASE 5 //Reversion de documento x Nota de Credito
				For ll_inicio_cab = 1 TO dw_2.Rowcount()
					 /*Moneda de Cabecera*/
 					 ls_cod_moneda = is_param.dw_m.object.cod_moneda [1] 
					  
					 ls_tipo_doc   = dw_2.object.tipo_doc [ll_inicio_cab]
					 ls_nro_doc	   = dw_2.object.nro_doc  [ll_inicio_cab]
					 
					 
						  
					 ls_expresion = 'tipo_ref = '+"'"+ls_tipo_doc+"' AND nro_ref = "+"'"+ls_nro_doc+"'"
					 ll_found	  = is_param.dw_d.Find(ls_expresion,1,is_param.dw_d.rowcount())
					 
					 IF ll_found = 0 THEN
						 /*Verifico que tipo de moneda esta vacio o este */
					 	 /*tenga el mismo de tipo del documento seleccionado */
					 	 ls_cod_moneda_det = dw_2.object.cod_moneda [ll_inicio_cab]
						  
					    IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
						    ls_cod_moneda = ls_cod_moneda_det
						    is_param.dw_m.object.cod_moneda [1] = ls_cod_moneda
					    END IF
					 
					    IF ls_cod_moneda <> ls_cod_moneda_det THEN //Si Moneda es Diferente Salir
					  	    Messagebox ('Aviso','Aviso No Puede Escoger Un Documento con Otro Tipo de Moneda , Verifique!')
						    EXIT
					    END IF
						 
					 	 //Inserta Detalle
					 	 ids_cntas_cobrar_det.Retrieve(ls_tipo_doc,ls_nro_doc)

					 	 For ll_inicio = 1 TO ids_cntas_cobrar_det.Rowcount()
						 	  ll_item		 	    = ids_cntas_cobrar_det.object.item 		     [ll_inicio]
					 	  	  ls_cod_art	 	    = ids_cntas_cobrar_det.object.cod_art 	     [ll_inicio]
					 	  	  ls_descrip	 	    = ids_cntas_cobrar_det.object.descripcion     [ll_inicio]
					 	  	  ls_confin	 		    = ids_cntas_cobrar_det.object.confin 		     [ll_inicio]
						  	  ldc_cantidad_det    = ids_cntas_cobrar_det.object.cantidad	     [ll_inicio]
						     ldc_precio_unitario = ids_cntas_cobrar_det.object.precio_unitario [ll_inicio] 
							  ls_matriz				 = ids_cntas_cobrar_det.object.matriz_cntbl 	  [ll_inicio] 
							  
						  	  ll_ins_row = is_param.dw_d.InsertRow(0)
						 	  /*Activara ii_update de dw_detail e impuestos */
						 	  is_param.titulo = 's'
						  
						  	  is_param.dw_d.Object.item 	     		[ll_ins_row] = ll_ins_row
					 	  	  is_param.dw_d.Object.tipo_ref    		[ll_ins_row] = ls_tipo_doc
					 	  	  is_param.dw_d.Object.nro_ref     		[ll_ins_row] = ls_nro_doc
					 	  	  is_param.dw_d.Object.item_ref   		[ll_ins_row] = ll_item
					     	  is_param.dw_d.Object.cod_art     		[ll_ins_row] = ls_cod_art
					     	  is_param.dw_d.Object.descripcion 		[ll_ins_row] = ls_descrip
						  	  is_param.dw_d.Object.precio_unitario [ll_ins_row] = ldc_precio_unitario
					 	  	  is_param.dw_d.Object.cantidad    		[ll_ins_row] = ldc_cantidad_det 
					 	  	  is_param.dw_d.Object.confin		  		[ll_ins_row] = ls_confin
							  is_param.dw_d.Object.matriz_cntbl		[ll_ins_row] = ls_matriz
							  
						  	  /**Insertar Impuestos**/
						  	  ids_imp_x_cobrar_x_doc.Retrieve(ls_tipo_doc,ls_nro_doc,ll_item)
								 
						  	  For ll_inicio_det = 1 TO ids_imp_x_cobrar_x_doc.Rowcount()
								   ls_tip_impuesto  = ids_imp_x_cobrar_x_doc.object.tipo_impuesto [ll_inicio_det]
						  		   ls_cnta_ctbl	  = ids_imp_x_cobrar_x_doc.object.cnta_ctbl	   [ll_inicio_det]
						  		   ls_desc_impuesto = ids_imp_x_cobrar_x_doc.object.desc_impuesto [ll_inicio_det]
						  		   ldc_tasa_imp	  = ids_imp_x_cobrar_x_doc.object.tasa_impuesto [ll_inicio_det]
						  		   ls_signo			  = ids_imp_x_cobrar_x_doc.object.signo			[ll_inicio_det]
						  		   ls_desc_cnta	  = ids_imp_x_cobrar_x_doc.object.desc_cnta	   [ll_inicio_det]
						  		   ldc_imp_imp		  = ids_imp_x_cobrar_x_doc.object.importe		   [ll_inicio_det]
									ls_flag_dh		  = ids_imp_x_cobrar_x_doc.object.flag_dh		   [ll_inicio_det]
								  
						  			ll_ins_row_det = is_param.dw_c.insertRow(0)	
						  			/*Activar ii_update*/
						  			is_param.dw_c.Object.item 	  	     [ll_ins_row_det] = ll_ins_row
						  			is_param.dw_c.Object.tipo_impuesto [ll_ins_row_det] = ls_tip_impuesto
						  			is_param.dw_c.Object.cnta_ctbl	  [ll_ins_row_det] = ls_cnta_ctbl
						  			is_param.dw_c.Object.desc_impuesto [ll_ins_row_det] = ls_desc_impuesto
						  			is_param.dw_c.Object.tasa_impuesto [ll_ins_row_det] = ldc_tasa_imp
						  			is_param.dw_c.Object.signo			  [ll_ins_row_det] = ls_signo
						  			is_param.dw_c.Object.desc_cnta	  [ll_ins_row_det] = ls_desc_cnta
							   	is_param.dw_c.Object.importe	  	  [ll_ins_row_det] = ldc_imp_imp
				  				   is_param.dw_c.Object.flag_dh_cxp	  [ll_ins_row_det] = ls_flag_dh
					 	      	is_param.dw_c.Modify("tipo_impuesto.Protect='1~tIf(IsNull(flag_tipo),1,0)'")
					 	  	   	is_param.dw_c.Modify("importe.Protect='1~tIf(IsNull(flag_imp),1,0)'")					 
									//campos Bloqueados no editables
							  Next		
					    Next
					 
					 	 is_param.dw_d.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
					 	 is_param.dw_d.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
					 	 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag_rev),1,0)'")
					 	 is_param.dw_d.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
					 	 //ningun campo editables			
					 ELSE
						 Messagebox('Aviso','Documento '+ls_tipo_doc+' '+ls_nro_doc+' Ha Sido Tomado En Cuenta')						
					 END IF
				Next

		 CASE 6 //Interes de Boletas ,Facturas ,Letras x Cobrar
				For ll_inicio_cab = 1 TO dw_2.Rowcount()
					 /*Moneda de Cabecera*/
					 ls_cod_moneda = is_param.dw_m.object.cod_moneda [1]
					 
					 ls_tipo_doc   = dw_2.object.tipo_doc [ll_inicio_cab]
					 ls_nro_doc	   = dw_2.object.nro_doc  [ll_inicio_cab]
					 
					 ls_expresion = 'tipo_ref = '+"'"+ls_tipo_doc+"' AND nro_ref = "+"'"+ls_nro_doc+"'"
					 ll_found	  = is_param.dw_d.Find(ls_expresion,1,is_param.dw_d.rowcount())

					 IF ll_found = 0 THEN						 
						 /*Documento No Ha Sido Tomado En Cuenta*/	
						 
					 	 ls_cod_moneda_det = dw_2.object.cod_moneda [ll_inicio_cab]
						  
					    IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
						    ls_cod_moneda = ls_cod_moneda_det
						    is_param.dw_m.object.cod_moneda [1] = ls_cod_moneda
					    END IF
					 
					    IF ls_cod_moneda <> ls_cod_moneda_det THEN //Si Moneda es Diferente Salir
					  	    Messagebox ('Aviso','Aviso No Puede Escoger Un Documento con Otro Tipo de Moneda , Verifique!')
						    EXIT
					    END IF
					 	 //Inserta Detalle
						  
					 	 ids_cntas_cobrar_det.Retrieve(ls_tipo_doc,ls_nro_doc)
					 	 For ll_inicio = 1 TO ids_cntas_cobrar_det.Rowcount()
						 	  ll_item		 	    = ids_cntas_cobrar_det.object.item 		     [ll_inicio]
					 	  	  ls_cod_art	 	    = ids_cntas_cobrar_det.object.cod_art 	     [ll_inicio]
					 	  	  ls_descrip	 	    = ids_cntas_cobrar_det.object.descripcion     [ll_inicio]
						  	  ldc_cantidad_det    = ids_cntas_cobrar_det.object.cantidad	     [ll_inicio]
						  	  ldc_precio_unitario = ids_cntas_cobrar_det.object.precio_unitario [ll_inicio] 
						     
						  	  ll_ins_row = is_param.dw_d.InsertRow(0)
						 	  /*Activara ii_update de dw_detail e impuestos */
						 	  is_param.titulo = 's'
						  
						  	  is_param.dw_d.Object.item 	     		[ll_ins_row] = ll_ins_row
					 	  	  is_param.dw_d.Object.tipo_ref    		[ll_ins_row] = ls_tipo_doc
					 	  	  is_param.dw_d.Object.nro_ref     		[ll_ins_row] = ls_nro_doc
					 	  	  is_param.dw_d.Object.item_ref   		[ll_ins_row] = ll_item
					     	  is_param.dw_d.Object.cod_art     		[ll_ins_row] = ls_cod_art
					     	  is_param.dw_d.Object.descripcion 		[ll_ins_row] = ls_descrip
						  	  is_param.dw_d.Object.precio_unitario [ll_ins_row] = ldc_precio_unitario
					 	  	  is_param.dw_d.Object.cantidad    		[ll_ins_row] = ldc_cantidad_det 
						 	  is_param.dw_d.Object.flag_aj  			[ll_ins_row] = 'INT' //INTERES
						  	  is_param.dw_d.Object.flag_rev 			[ll_ins_row] = 'INT'
							
						
						  	  /**Insertar Impuestos**/
						  	  ids_imp_x_cobrar_x_doc.Retrieve(ls_tipo_doc,ls_nro_doc)

						  	  For ll_inicio_det = 1 TO ids_imp_x_cobrar_x_doc.Rowcount()
								   ls_tip_impuesto  = ids_imp_x_cobrar_x_doc.object.tipo_impuesto [ll_inicio_det]
						  			ls_cnta_ctbl	  = ids_imp_x_cobrar_x_doc.object.cnta_ctbl	   [ll_inicio_det]
						  			ls_desc_impuesto = ids_imp_x_cobrar_x_doc.object.desc_impuesto [ll_inicio_det]
						  			ldc_tasa_imp	  = ids_imp_x_cobrar_x_doc.object.tasa_impuesto [ll_inicio_det]
						  			ls_signo			  = ids_imp_x_cobrar_x_doc.object.signo			[ll_inicio_det]
						  			ls_desc_cnta	  = ids_imp_x_cobrar_x_doc.object.desc_cnta	   [ll_inicio_det]
						  			ldc_imp_imp		  = ids_imp_x_cobrar_x_doc.object.importe		   [ll_inicio_det]
									ls_flag_dh		  = ids_imp_x_cobrar_x_doc.object.flag_dh		   [ll_inicio_det]									  
								  
						  			ll_ins_row_det = is_param.dw_c.insertRow(0)	
						  			/*Activar ii_update*/
						  			is_param.dw_c.Object.item 	  	     [ll_ins_row_det] = ll_ins_row
						  			is_param.dw_c.Object.tipo_impuesto [ll_ins_row_det] = ls_tip_impuesto
						  			is_param.dw_c.Object.cnta_ctbl	  [ll_ins_row_det] = ls_cnta_ctbl
						  			is_param.dw_c.Object.desc_impuesto [ll_ins_row_det] = ls_desc_impuesto
						  			is_param.dw_c.Object.tasa_impuesto [ll_ins_row_det] = ldc_tasa_imp
						  			is_param.dw_c.Object.signo			  [ll_ins_row_det] = ls_signo
						  			is_param.dw_c.Object.desc_cnta	  [ll_ins_row_det] = ls_desc_cnta
							   	is_param.dw_c.Object.importe	  	  [ll_ins_row_det] = ldc_imp_imp
								   is_param.dw_c.Object.flag_dh_cxp	  [ll_ins_row_det] = ls_flag_dh									
						      	is_param.dw_c.Object.flag_tipo	  [ll_ins_row_det] = 'INT' //Interes
									is_param.dw_c.Object.flag_imp		  [ll_ins_row_det] = 'INT'
								
					 	      	is_param.dw_c.Modify("tipo_impuesto.Protect='1~tIf(IsNull(flag_tipo),1,0)'")
					 	  	   	is_param.dw_c.Modify("importe.Protect='1~tIf(IsNull(flag_imp),1,0)'")					 
									//campos Bloqueados no editables
						  	  Next   	
					    Next
						 
					    is_param.dw_d.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
					 	 is_param.dw_d.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
					 	 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag_rev),1,0)'")
					 	 is_param.dw_d.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
					 	 //ningun campo editables			
                ELSE						 
						 Messagebox('Aviso','Documento '+ls_tipo_doc+' '+ls_nro_doc+' Ha Sido Tomado En Cuenta')						 					 
					 END IF

				Next

       CASE 7 //Descuento por pronto pago				
				For ll_inicio_cab = 1 TO dw_2.Rowcount()
					 ls_tipo_doc = dw_2.object.tipo_doc [ll_inicio_cab]
					 ls_nro_doc	 = dw_2.object.nro_doc  [ll_inicio_cab]	
					 
					 ls_expresion = 'tipo_ref = '+"'"+ls_tipo_doc+"' AND nro_ref = "+"'"+ls_nro_doc+"'"
					 ll_found	  = is_param.dw_d.Find(ls_expresion,1,is_param.dw_d.rowcount())
					 IF ll_found = 0 THEN
						 /*Documento No Ha Sido Tomado En Cuenta*/	
					    ll_ins_row = is_param.dw_d.InsertRow(0)
						 /*Activara ii_update de dw_master*/
						 is_param.titulo = 's'
						 
					 	 /*Activar ii_update*/
						 is_param.dw_d.Object.item		 [ll_ins_row] = ll_ins_row
					 	 is_param.dw_d.Object.tipo_ref [ll_ins_row] = ls_tipo_doc
			 	    	 is_param.dw_d.Object.nro_ref  [ll_ins_row] = ls_nro_doc	  
					 	 is_param.dw_d.Object.flag_aj  [ll_ins_row] = 'DES'
					 	 is_param.dw_d.Object.flag_rev [ll_ins_row] = 'DES'
					 
						 is_param.dw_d.Modify("cod_art.Protect='1~tIf(IsNull(flag_int),1,0)'")
						 is_param.dw_d.Modify("descripcion.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
						 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag_rev),1,0)'")
						 is_param.dw_d.Modify("precio_unitario.Protect='1~tIf(IsNull(flag_rev),1,0)'")					 
						 
					 ELSE
						 Messagebox('Aviso','Documento '+ls_tipo_doc+' '+ls_nro_doc+' Ha Sido Tomado En Cuenta')						 
					 END IF
				Next
       CASE 8 //Insercion de Cuentas Bancarias
				FOR ll_inicio = 1 TO dw_2.Rowcount()
	 			   ls_codigo = dw_2.Object.cod_ctabco [ll_inicio]	 

					Insert Into tt_fin_rpt_cta_bco
				   (cod_ctabco)  
					VALUES 
					(:ls_codigo)  ;
					
				NEXT
				
		 CASE	10		
				For ll_inicio = 1 TO dw_2.Rowcount() //Origenes
					 ls_codigo = dw_2.object.cod_origen [ll_inicio]
					 
					 Insert into tt_fin_origenes
					 (cod_origen)
					 Values
					 (:ls_codigo);
				Next					
				
		 CASE	11 /*GUIAS SIN OV*/
				

				FOR ll_inicio = 1 TO dw_2.RowCount()
					 
					 ls_cod_origen	= dw_2.Object.cod_origen [ll_inicio]
					 ls_guia_rem 	= dw_2.Object.nro_guia   [ll_inicio]		 

 					 
					 ll_ind_guia = wf_find_guias(ls_cod_origen,ls_guia_rem)
					 
					 
					 IF ll_ind_guia > 0 THEN	
						 Messagebox('Aviso','Guia No Sera Tomada en cuenta ya ha sido considerada en el Documento a Emitir')
					 ELSE
						 wf_insert_articulos_x_vales (ls_cod_origen,ls_guia_rem,is_param.string3,is_param.db2)	
					END IF

				NEXT

       CASE	12 /*COMPROBANTE DE EGRESOS (EGRESOS DIRECTOS)*/
				SELECT comprobante_egr
				  INTO :ls_cegreso
				  FROM finparam
				 WHERE (reckey = '1') ;
				 
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
						 is_param.dw_m.object.cod_moneda_cab [ll_row] = is_param.string4
					 	 is_param.dw_m.object.tasa_cambio    [ll_row] = is_param.field_ret_d3	  [1]
						 is_param.dw_m.object.importe        [ll_row] = dw_2.object.total_pagar   [ll_inicio]
						 is_param.dw_m.object.flab_tabor     [ll_row] = 'C'
						 
						 IF ls_tipo_doc = ls_cegreso THEN //COMPROBANTE EGRESO
						    is_param.dw_m.object.flag_tip_doc	 [ll_row] = '1'
						 ELSE
							 Setnull(ls_null)
							 is_param.dw_m.object.flag_tip_doc	 [ll_row] = ls_null
						 END IF
					 END IF
					 
				NEXT	
				
		 CASE 13	//CONCILIACION DE CHEQUES
				SELECT doc_cheque
				  INTO :ls_doc_cheque 
				  FROM finparam
				 WHERE (reckey = '1') ;
				
				IF dw_2.Rowcount() > 1 THEN
					Messagebox('Aviso','Debe Seleccionar Solo Un Documento')
					Return
				END IF
				
				For ll_inicio = 1 TO dw_2.Rowcount()
					 is_param.dw_m.object.tipo_doc       [is_param.long1] = ls_doc_cheque
					 is_param.dw_m.object.nro_doc        [is_param.long1] = Trim(String(dw_2.object.cheque_emitir_nro_cheque  [ll_inicio]))
					 is_param.dw_m.object.fecha_doc      [is_param.long1] = dw_2.object.caja_bancos_fecha_emision [ll_inicio]
					 is_param.dw_m.object.origen_cajban  [is_param.long1] = dw_2.object.caja_bancos_origen        [ll_inicio]
					 is_param.dw_m.object.nro_reg_cajban [is_param.long1] = dw_2.object.caja_bancos_nro_registro  [ll_inicio]
					 is_param.dw_m.object.importe			 [is_param.long1] = dw_2.object.cheque_emitir_importe		 [ll_inicio]
					 
				Next
				
		 CASE 14	//articulos
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Registro , Verifique!')
					Return
				END IF
				
				
				For ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.Object.cod_art [ll_inicio]	 
					 //Inserción de Proveedores
				    Insert Into tt_fin_rpt_art
			       (cod_art)  
					 VALUES 
					 (:ls_codigo)  ;
				Next
				

		 CASE 15 //DOCUMENTOS a conciliar
			
				
				IF dw_2.Rowcount() > 1 THEN
					Messagebox('Aviso','Debe Seleccionar Solo Un Documento')
					Return
				END IF
				
				For ll_inicio = 1 TO dw_2.Rowcount()
					 is_param.dw_m.object.tipo_doc       [is_param.long1] = dw_2.object.caja_bancos_tipo_doc 		 [ll_inicio]
					 is_param.dw_m.object.nro_doc        [is_param.long1] = dw_2.object.caja_bancos_nro_doc 		 [ll_inicio]
					 is_param.dw_m.object.fecha_doc      [is_param.long1] = dw_2.object.caja_bancos_fecha_emision [ll_inicio]
					 is_param.dw_m.object.origen_cajban  [is_param.long1] = dw_2.object.caja_bancos_origen        [ll_inicio]
					 is_param.dw_m.object.nro_reg_cajban [is_param.long1] = dw_2.object.caja_bancos_nro_registro  [ll_inicio]
					 is_param.dw_m.object.importe			 [is_param.long1] = dw_2.object.caja_bancos_imp_total		 [ll_inicio]
					 
				Next
			
		 CASE 16	//concepto financiero
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Registro , Verifique!')
					Return
				END IF
				
				
				For ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo 		 = dw_2.Object.confin      [ll_inicio]	 
					 ls_descripcion = dw_2.Object.descripcion [ll_inicio]	 
					 
					 //Inserción de Concepto Financiero
				    Insert Into tt_fin_rpt_confin
			       (confin,descripcion)  
					 VALUES 
					 (:ls_codigo,:ls_descripcion) ;
					 
					 
				Next
		 CASE	17 // GRUPO DE RELACION
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return
				END IF
				
			   FOR ll_inicio = 1 TO dw_2.Rowcount ()
					 ls_grupo = dw_2.object.grupo [ll_inicio]
					 INSERT INTO tt_fin_proveedor
					 (cod_proveedor)
					 SELECT cod_relacion FROM cod_rel_agrupamiento WHERE grupo = :ls_grupo ;
				NEXT
				
		 CASE 18 //	GRUPO DE ARTICULOS
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return
				END IF
			
				FOR ll_inicio = 1 TO dw_2.Rowcount ()
					 ls_grupo = dw_2.object.grupo_art [ll_inicio]				 				
					 INSERT INTO tt_fin_rpt_art
					 (cod_art)
					 SELECT cod_art FROM rel_articulo_grupo WHERE grupo_art = :ls_grupo;
					 
				NEXT
				
		 CASE 19
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return
				END IF
				
				FOR ll_inicio = 1 TO dw_2.Rowcount ()
					 ls_codigo = dw_2.object.cencos [ll_inicio]				 				
					 INSERT INTO tt_ope_cencos
					 (cencos)
					 VALUES
					 (:ls_codigo) ;
					 
				NEXT
				
		 CASE	20
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return					
				END IF
				
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.object.cod_maquina [ll_inicio]				 				
					 INSERT INTO tt_ope_maquina
					 (cod_maquina)
					 VALUES
					 (:ls_codigo) ;	
				NEXT
				
		 CASE	21
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return					
				END IF
				
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.object.cod_relacion [ll_inicio]		
			
					 
					 INSERT INTO tt_fin_proveedor
					 (cod_proveedor)
					 VALUES
					 (:ls_codigo) ;	
				NEXT
				
		 CASE	22
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return					
				END IF
				
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.object.cencos [ll_inicio]		
			
					 
					 INSERT INTO tt_ope_cencos_slc
					 (cencos)
					 VALUES
					 (:ls_codigo) ;	
				NEXT
				
		 CASE	23
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return					
				END IF
				
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.object.cencos [ll_inicio]		
			
					 
					 INSERT INTO tt_ope_cencos_rsp
					 (cencos)
					 VALUES
					 (:ls_codigo) ;	
				NEXT
				
		 CASE	24
				IF dw_2.Rowcount() = 0 THEN
					Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
					Return					
				END IF
				
				FOR ll_inicio = 1 TO dw_2.Rowcount()
					 ls_codigo = dw_2.object.ot_adm [ll_inicio]		
			
					 
					 INSERT INTO tt_ope_ot_adm
					 (ot_adm)
					 VALUES
					 (:ls_codigo) ;	
				NEXT				
				
		 CASE 25
				FOR ll_inicio = 1 to dw_2.rowcount()
  	 				 ls_codigo  = dw_2.object.cencos     [ll_inicio]
	 	 			 ls_descrip = dw_2.object.desc_cencos[ll_inicio]
		 
					 INSERT INTO tt_man_cencos
					 (cencos, desc_cencos)
					 VALUES
					 (:ls_codigo, :ls_descrip);		
				NEXT
				
       CASE 26
				FOR ll_inicio = 1 to dw_2.rowcount()
					 ls_codigo  = dw_2.object.cnta_prsp   [ll_inicio]
					 ls_descrip = dw_2.object.descripcion [ll_inicio]
									 
					 Insert Into tt_man_cnta_prsp 
					 (cnta_prsp,descripcion)
					 Values
					 (:ls_codigo, :ls_descrip);		
					 
				NEXT
				
       CASE 27
				FOR ll_inicio = 1 to dw_2.rowcount()
					 ls_codigo  = dw_2.object.ot_tipo   [ll_inicio]

									 
					 Insert Into tt_mtt_ot_tipo
					 (ot_tipo)
					 Values
					 (:ls_codigo);		
					 
				NEXT
				
END CHOOSE

Closewithreturn(parent,is_param)
end event

type st_campo from statictext within w_abc_seleccion_lista_search
integer x = 27
integer y = 24
integer width = 453
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda :"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_abc_seleccion_lista_search
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 489
integer y = 24
integer width = 974
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
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
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
			dw_3.Setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

