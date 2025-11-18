$PBExportHeader$w_abc_seleccion_lista.srw
forward
global type w_abc_seleccion_lista from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_lista
end type
type uo_search from n_cst_search within w_abc_seleccion_lista
end type
end forward

global type w_abc_seleccion_lista from w_abc_list
integer x = 50
integer width = 4622
integer height = 2140
string title = "Seleccione uno o mas registros"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
uo_search uo_search
end type
global w_abc_seleccion_lista w_abc_seleccion_lista

type variables
String 			is_tipo,is_soles,is_dolares, is_col, is_type, is_doc_og, is_doc_dtrp
str_parametros istr_param
end variables

forward prototypes
public function long wf_verifica_doc (string as_origen_doc, string as_tipo_doc, string as_nro_doc)
public function long wf_verifica_ce (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_dev_og (long al_item, long al_inicio, long al_row)
public subroutine of_procesa_liq_opc_16 ()
public subroutine of_insert_detraccion (long al_item, long al_row, long al_inicio)
public subroutine of_procesa_det_opc_17 ()
public function long wf_verifica_doc (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public function long wf_verifica_doc_ref (string as_origen_doc, string as_tipo_doc, string as_nro_doc)
public function long wf_verifica_det_liq (string as_proveedor, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_det_liq ()
public subroutine wf_insert_ov ()
public subroutine wf_insert_oc ()
public subroutine wf_insert_os ()
public subroutine wf_insert_pp ()
public function long wf_verifica_doc_cc_liq (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public function long wf_verifica_doc_cp_liq (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_liquidacion (long al_row, long al_row_det, string as_flag_tabla)
public subroutine wf_insert_pc ()
public function boolean wf_verifica_anticipos (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_ov_ref ()
public function long wf_verifica_detraccion (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine of_opcion15 ()
public function boolean of_opcion1 ()
public function boolean of_opcion18 ()
public subroutine of_opcion25 ()
end prototypes

public function long wf_verifica_doc (string as_origen_doc, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = "origen_doc = '" + as_origen_doc + "'" &
				 + " AND tipo_doc = '" + as_tipo_doc + "'" &
				 + " AND nro_doc = '" + as_nro_doc + "'"

ll_found 	 = istr_param.dw_m.Find(ls_expresion,1,istr_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_ce (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'proveedor = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = istr_param.dw_m.Find(ls_expresion,1,istr_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_dev_og (long al_item, long al_inicio, long al_row);istr_param.dw_m.object.item		       [al_row] = al_item
istr_param.dw_m.object.proveedor       [al_row] = dw_2.object.cod_relacion    [al_inicio]
istr_param.dw_m.object.tipo_doc        [al_row] = dw_2.object.tipo_doc        [al_inicio]
istr_param.dw_m.object.nro_doc         [al_row] = dw_2.object.nro_doc         [al_inicio]
istr_param.dw_m.object.fecha_doc       [al_row] = dw_2.object.fecha_emision   [al_inicio]
istr_param.dw_m.object.cod_moneda      [al_row] = dw_2.object.cod_moneda      [al_inicio]
istr_param.dw_m.object.cod_moneda_cab  [al_row] = istr_param.string2
istr_param.dw_m.object.tasa_cambio     [al_row] = dw_2.object.tasa_cambio     [al_inicio]
istr_param.dw_m.object.importe         [al_row] = dw_2.object.saldo			    [al_inicio]
istr_param.dw_m.object.descripcion     [al_row] = dw_2.object.descripcion     [al_inicio]	 	
istr_param.dw_m.object.nom_proveedor	 [al_row] = dw_2.object.nombre		    [al_inicio]	
istr_param.dw_m.Object.flag_tipo_gasto [al_row] = dw_2.object.flag_tipo_gasto [al_inicio]	
istr_param.dw_m.object.cencos          [al_row] = dw_2.object.cencos          [al_inicio]
istr_param.dw_m.object.cnta_prsp       [al_row] = dw_2.object.cnta_prsp       [al_inicio]

end subroutine

public subroutine of_procesa_liq_opc_16 ();string	ls_cod_relacion ,ls_tipo_doc    ,ls_nro_doc ,ls_flag_tabla,ls_origen
Long		ll_inicio, ll_row, ll_found, ll_item

dw_2.accepttext( )

For ll_inicio = 1 TO dw_2.Rowcount()
	 ls_origen		  = dw_2.object.origen   	  [ll_inicio]
	 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
	 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
	 ls_nro_doc	 	  = dw_2.object.nro_doc      [ll_inicio]
	 ls_flag_tabla	  = dw_2.object.flag_tabla   [ll_inicio]	 
	 

	if ls_flag_tabla = '1'     then //cobrar
		ll_found = wf_verifica_doc_cc_liq (ls_origen,ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	elseif ls_flag_tabla = '3' then //pagar
		ll_found = wf_verifica_doc_cp_liq (ls_origen,ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	end if

	IF ll_found > 0 THEN
		Messagebox('Aviso','Documento '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
	ELSE	 
		istr_param.bret = TRUE
		ll_row = istr_param.dw_m.InsertRow(0)	
		
		// Inserto los registros en el detalle de la liquidacion de pagos
		 wf_insert_liquidacion (ll_row,ll_inicio,ls_flag_tabla)
	END IF	 		
	
Next
end subroutine

public subroutine of_insert_detraccion (long al_item, long al_row, long al_inicio);String ls_soles,ls_dolares, ls_observacion

f_monedas( ls_soles, ls_dolares )

istr_param.dw_m.object.item 			   [al_row] = al_item
istr_param.dw_m.object.origen_doc_ref [al_row] = dw_2.object.origen     		[al_inicio]
istr_param.dw_m.object.tipo_doc_ref   [al_row] = istr_param.string3
istr_param.dw_m.object.nro_doc_ref	   [al_row] = dw_2.object.nro_detraccion 	[al_inicio]
istr_param.dw_m.object.cod_moneda     [al_row] = dw_2.object.cod_moneda 		[al_inicio]
istr_param.dw_m.object.flag_tabla	   [al_row] = dw_2.object.flag_tabla 		[al_inicio]

ls_observacion = 'Detraccion x Documento: ' + dw_2.object.tipo_doc[al_inicio] + ' - ' &
		+ dw_2.object.nro_doc[al_inicio]
istr_param.dw_m.object.concepto			[al_row] = ls_observacion

IF istr_param.string2 = ls_soles THEN
	istr_param.dw_m.object.importe_liq [al_row] = dw_2.object.sldo_sol  [al_inicio]
ELSE
   istr_param.dw_m.object.importe_liq [al_row] = dw_2.object.saldo_dol [al_inicio]
END IF

IF dw_2.object.flag_debhab [al_inicio] = 'H'  THEN
	istr_param.dw_m.object.flag_cxp [al_row] = '+'
ELSE
	istr_param.dw_m.object.flag_cxp [al_row] = '-'
END IF
end subroutine

public subroutine of_procesa_det_opc_17 ();string		ls_tipo_doc, ls_nro_doc, ls_origen, ls_expresion
Long			ll_inicio, ll_row, ll_found
u_dw_abc		ldw_detail

ldw_detail = istr_param.dw_m

For ll_inicio = 1 TO dw_2.Rowcount()
	ls_origen		 = dw_2.object.origen 			[ll_inicio]
	ls_tipo_doc 	 = istr_param.string3
	ls_nro_doc	 	 = dw_2.object.nro_detraccion [ll_inicio]
		 
	ls_expresion = "origen_doc_ref = '" + ls_origen + "' AND tipo_doc_ref = '" &
				 + ls_tipo_doc + "' AND nro_doc_ref = '" + ls_nro_doc + "'"

	ll_found 	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.Rowcount())

	IF ll_found > 0 THEN
		Messagebox('Aviso','Documento '+Trim(ls_tipo_doc) + ' ' + Trim(ls_nro_doc) &
					+' ya Ha sido Registrado , Verifique!')
	ELSE	 
		istr_param.bret = TRUE
		ll_row = ldw_detail.event dynamic ue_insert()
		
		if ll_row < 0 then continue
		
		this.of_insert_detraccion( ll_row, ll_row, ll_inicio )
		
	END IF	 		
Next
end subroutine

public function long wf_verifica_doc (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = "origen_doc = '" + as_origen_doc + "'" &
				 + " AND cod_relacion = '" + as_cod_relacion + "'" &
				 + " AND tipo_doc = '" + as_tipo_doc + "'" &
				 + " AND nro_doc = '" + as_nro_doc + "'"

ll_found 	 = istr_param.dw_m.Find(ls_expresion,1,istr_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_doc_ref (string as_origen_doc, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = "origen_ref = '" + as_origen_doc +"' AND tipo_ref = '" + as_tipo_doc + "' AND nro_ref = '"+as_nro_doc +"'"

ll_found 	 = istr_param.dw_m.Find(ls_expresion,1,istr_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_det_liq (string as_proveedor, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'proveedor = '+"'"+as_proveedor+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = istr_param.dw_m.Find(ls_expresion,1,istr_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_det_liq ();Long    ll_inicio,ll_row,ll_item,ll_rowcount,ll_found
Integer li_nro_sol_pend,li_nro_max
String  ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_flag_estado,ls_doc_sol_giro


/*parametros*/
select doc_sol_giro into :ls_doc_sol_giro from finparam where (reckey = '1') ;

For ll_inicio  = 1 TO dw_2.Rowcount()
	
	 /*verificar que documento no ha sido ingresado*/
	 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
	 ls_tipo_doc     = dw_2.object.tipo_doc 	  [ll_inicio]
	 ls_nro_doc      = dw_2.object.nro_doc 	  [ll_inicio]

	 /*contador para pagar un orden de giro*/	
	 IF ls_tipo_doc = ls_doc_sol_giro THEN
		 /*estado de orden de giro*/
		 select flag_estado into :ls_flag_estado from solicitud_giro where nro_solicitud = :ls_nro_doc ;		
		 
		 IF ls_flag_estado = '2' THEN  //APROBADA CON RUMBO A PAGAR
		 
			 /*verificar contador de solcitud de giro*/
			 SELECT Nvl(nro_solicitudes_pend,0),
			 		  Nvl(nro_maximo_sol_pend,0) 
		      INTO :li_nro_sol_pend,
			 	     :li_nro_max 
      	   FROM maestro_param_autoriz 
 	        WHERE (cod_relacion = :ls_cod_relacion) ;	 
						 
          IF li_nro_sol_pend >= li_nro_max  THEN
			    Messagebox('Aviso','Verifique su maximo de Pendientes de Ordenes de Giro', Exclamation!)					
			    Return
          END IF
	    END IF		
    END IF
	 
  	 ll_found = wf_verifica_det_liq (ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
		  
	 IF ll_found = 0 THEN
		 ll_row = istr_param.dw_m.InsertRow(0)
		 /*INSERT PRE*/
		 ll_rowcount = istr_param.dw_m.RowCount()	
	 
  		 IF ll_row = 1 THEN 
		    ll_item = 0
		 ELSE
		    ll_item = istr_param.dw_m.Getitemnumber(ll_rowcount - 1,"item")
		 END IF

		 istr_param.dw_m.SetItem(ll_row, "item", ll_item + 1)  
		

		 /**/
	    istr_param.bret = TRUE	 
		 istr_param.dw_m.object.proveedor         [ll_row] = dw_2.object.cod_relacion      [ll_inicio] 
		 istr_param.dw_m.object.tipo_doc          [ll_row] = dw_2.object.tipo_doc	         [ll_inicio]
		 istr_param.dw_m.object.nro_doc           [ll_row] = dw_2.object.nro_doc           [ll_inicio]
		 istr_param.dw_m.object.fecha_doc	       [ll_row] = dw_2.object.fecha_doc	      [ll_inicio]
	 	 istr_param.dw_m.object.cod_moneda        [ll_row] = dw_2.object.cod_moneda	      [ll_inicio]
		 istr_param.dw_m.object.importe           [ll_row] = dw_2.object.importe		      [ll_inicio]	  
		 istr_param.dw_m.object.flag_provisionado [ll_row] = dw_2.object.flag_provisionado [ll_inicio]
		 istr_param.dw_m.object.tasa_cambio		 [ll_row] = dw_2.object.tasa_cambio		   [ll_inicio]
		 istr_param.dw_m.object.descripcion		 [ll_row] = dw_2.object.descripcion		   [ll_inicio]
		 istr_param.dw_m.object.cod_moneda_cab	 [ll_row] = istr_param.string2		 
		 istr_param.dw_m.object.cencos				 [ll_row] = dw_2.object.cencos		   	[ll_inicio]
 		 istr_param.dw_m.object.cnta_prsp			 [ll_row] = dw_2.object.cnta_prsp		   [ll_inicio]
	 ELSE	 
		 //DOCUMENTO YA FUE CONSIDERADO		 
		 Messagebox('Aviso','Documento ya fue Considerado , Verifique!')
	 END IF	 
	 
	 
Next	



end subroutine

public subroutine wf_insert_ov ();Long   ll_inicio,ll_row
String ls_doc_ov,ls_cod_origen,ls_nro_ov

select doc_ov into :ls_doc_ov from logparam where reckey = '1' ;

dw_2.Accepttext()


IF dw_2.Rowcount() > 1 THEN
	Messagebox('Aviso','Solamente puede Seleccionar Una Orden de Venta ,Verfique!')
	RETURN
END IF

For ll_inicio = 1 TO dw_2.Rowcount()

	 
	 ls_cod_origen = dw_2.object.cod_origen [ll_inicio] 
	 ls_nro_ov		= dw_2.object.nro_ov		 [ll_inicio]
	 
	 istr_param.bret = TRUE
	 ll_row = istr_param.dw_m.InsertRow (0)
	 istr_param.dw_m.object.tipo_mov	[ll_row] = 'C'
	 istr_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 istr_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_ov
	 istr_param.dw_m.object.nro_ref    [ll_row] = ls_nro_ov
	 istr_param.dw_m.object.flab_tabor [ll_row] = '9'
	 
Next	
end subroutine

public subroutine wf_insert_oc ();Long   	ll_inicio,ll_row
String 	ls_doc_oc,ls_cod_origen,ls_nro_oc
u_dw_abc	ldw_master

dw_2.Accepttext()

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','NO HA SELECCIONADO ORDEN DE COMPRA ALGUNA, Verfique!')
	RETURN
END IF

IF dw_2.Rowcount() > 1 THEN
	Messagebox('Aviso','Solamente puede Seleccionar Una Orden de Compra ,Verfique!')
	RETURN
END IF

select doc_oc 
  into :ls_doc_oc 
  from logparam 
where reckey = '1' ;

For ll_inicio = 1 TO dw_2.Rowcount()

	 ls_cod_origen = dw_2.object.cod_origen [ll_inicio] 
	 ls_nro_oc		= dw_2.object.nro_oc		 [ll_inicio]
	 
	 istr_param.bret = TRUE
	 ll_row = istr_param.dw_m.InsertRow (0)
	 istr_param.dw_m.object.tipo_mov	[ll_row] = 'R'
	 istr_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 istr_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_oc
	 istr_param.dw_m.object.nro_ref    [ll_row] = ls_nro_oc
	 istr_param.dw_m.object.flab_tabor [ll_row] = '7'

Next	

ldw_master = istr_param.dw_or_m
ldw_master.object.descripcion [ldw_master.GetRow()] = dw_2.object.observacion [1] 
end subroutine

public subroutine wf_insert_os ();Long   	ll_inicio,ll_row
String 	ls_doc_os,ls_cod_origen,ls_nro_os
u_dw_abc	ldw_master

select doc_os 
  into :ls_doc_os 
from logparam 
where reckey = '1' ;

dw_2.Accepttext()


IF dw_2.Rowcount() > 1 THEN
	Messagebox('Aviso','Solamente puede Seleccionar Una Orden de Servicio ,Verfique!')
	RETURN
END IF

For ll_inicio = 1 TO dw_2.Rowcount()

	 
	 ls_cod_origen = dw_2.object.cod_origen [ll_inicio] 
	 ls_nro_os		= dw_2.object.nro_os		 [ll_inicio]
	 
	 istr_param.bret = TRUE
	 ll_row = istr_param.dw_m.InsertRow (0)
	 istr_param.dw_m.object.tipo_mov	[ll_row] = 'R'
	 istr_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 istr_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_os
	 istr_param.dw_m.object.nro_ref    [ll_row] = ls_nro_os
	 istr_param.dw_m.object.flab_tabor [ll_row] = '8'
	 
	 ldw_master = istr_param.dw_or_m
	 
Next	

ldw_master.object.descripcion [ldw_master.GetRow()] = dw_2.object.observacion [1]
end subroutine

public subroutine wf_insert_pp ();Long    ll_inicio,ll_row,ll_row_count,ll_factor
Integer li_item
String  ls_soles,ls_dolares,ls_cod_moneda,ls_flag_tabla,ls_doc_detrac,ls_tipo_doc,ls_null,&
		  ls_cod_relacion,ls_nro_doc,ls_flag_prov, ls_nro_detracción
Decimal {2} ldc_importe, ldc_Importe_detr

dw_2.Accepttext()


Setnull(ls_null)
select cod_soles ,cod_dolares into :ls_soles,:ls_dolares from logparam where (reckey = '1');

select doc_detrac_cp into :ls_doc_detrac from finparam where (reckey = '1') ;

For ll_inicio = 1 TO dw_2.Rowcount()
	 
	 /*importe*/
	 ls_cod_moneda   = dw_2.object.cod_moneda        [ll_inicio]
	 ls_flag_tabla   = dw_2.object.flag_tabla        [ll_inicio]
	 ll_factor		  = dw_2.object.factor		       [ll_inicio]
	 ls_tipo_doc	  = dw_2.object.tipo_doc          [ll_inicio]
	 ls_cod_relacion = dw_2.object.cod_relacion      [ll_inicio]
	 ls_nro_doc		  = dw_2.object.nro_doc		       [ll_inicio]
	 ls_flag_prov	  = dw_2.object.flag_provisionado [ll_inicio]
	 
	 if ls_flag_prov = 'R' AND ls_flag_tabla = '3'    THEN //VERIFICAR SI CONTIENE ANTICIPOS
	 	 if wf_verifica_anticipos(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) = false then
			 GOTO SALIDA	
		  end if	
	 end if
	 
//	  IF wf_verifica_detraccion(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) > 0 THEN
//	   
//		SELECT CP.NRO_DETRACCION,
//             Round((NVL(CP.IMPORTE_DOC,0)*NVL(CP.PORC_DETRACCION,0))/100,2)
//		  INTO :ls_nro_detracción, :ldc_Importe_detr
//        FROM CNTAS_PAGAR CP 
//       WHERE CP.COD_RELACION = :ls_cod_relacion
//         AND CP.TIPO_DOC     = :ls_tipo_doc
//			AND CP.NRO_DOC 	  = :ls_nro_doc;
//		  
//		 MESSAGEBOX('Aviso','El documento Tiene una detracción por descontar~r'+&
//		 			   +'Proveedor: '+ls_cod_relacion+'~r'+'Tipo_Doc: '+ls_tipo_doc+'~r'+'Nro_Doc: '+ls_nro_doc+'~r'&
//						+'Nro_Detracción: '+ls_nro_detracción+' Importe_detracción: '+string(ldc_Importe_detr) )
//		 
//		 GOTO SALIDA
//		 
//	End If
	 
	 /*Factor*/
	 if ll_factor = -1 then
		 ll_factor = 1	
	 else
		 ll_factor = -1		
	 end if
	 
	 
	 if ls_cod_moneda = ls_soles then
		 ldc_importe = dw_2.object.sldo_sol  [ll_inicio]
	 else
 		 ldc_importe = dw_2.object.saldo_dol [ll_inicio]
	 end if
	
	 ll_row = istr_param.dw_m.InsertRow(0)
	 istr_param.bret = TRUE
	 
	 
	 /*Asignacion de item_doc*/
	 ll_row_count = istr_param.dw_m.RowCount()
	 
	 IF ll_row_count = 1 THEN 
		 li_item = 0
	 ELSE
		 li_item = istr_param.dw_m.Getitemnumber(ll_row,"item_max")
	 END IF
	 
	 istr_param.dw_m.SetItem(ll_row, "item_doc", li_item + 1)  	 
	 
	 /***********************/
	 
	 
	 IF ls_flag_tabla = '1' THEN //Cuenta x Cobrar
		 istr_param.dw_m.object.doc_cnta_cobrar [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 istr_param.dw_m.object.nro_cnta_cobrar [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 
	 ELSEIF ls_flag_tabla = '3' THEN //Cuenta x Pagar
		 istr_param.dw_m.object.doc_cnta_pagar  [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 istr_param.dw_m.object.nro_cnta_pagar  [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 END IF	

	 istr_param.dw_m.object.prov_cnta_pagar 			 [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
	 istr_param.dw_m.object.proveedor_nom_proveedor [ll_row] = dw_2.object.nom_proveedor [ll_inicio]
	 istr_param.dw_m.object.cod_moneda		  			 [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
	 istr_param.dw_m.object.importe			  			 [ll_row] = ldc_importe
	 istr_param.dw_m.object.factor			  			 [ll_row] = ll_factor
	 istr_param.dw_m.object.flag_tabla		  			 [ll_row] = ls_flag_tabla
 	 istr_param.dw_m.object.flag_detrac				 [ll_row] = '0'
 	 istr_param.dw_m.object.soles						 [ll_row] = ls_soles
 	 istr_param.dw_m.object.dolares						 [ll_row] = ls_dolares
    istr_param.dw_m.object.item							 [ll_row] = istr_param.long1
	 istr_param.dw_m.object.confin						 [ll_row] = istr_param.string2
	 
	 SALIDA:
Next	 


end subroutine

public function long wf_verifica_doc_cc_liq (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = "origen_doc_ref = '" + as_origen_doc + "'" &
				 + " AND cxp_cod_rel = '" + as_cod_relacion + "'" &
				 + " AND cxc_tipo_doc = '" + as_tipo_doc + "'" &
				 + " AND cxc_nro_doc = '"+as_nro_doc+"'"

ll_found 	 = istr_param.dw_m.Find(ls_expresion,1,istr_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_doc_cp_liq (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_doc_ref = '+"'"+as_origen_doc+"'"+' AND cxp_cod_rel = '+"'"+as_cod_relacion+"'"+' AND cxp_tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'cxp_nro_doc ='+"'"+as_nro_doc+"'"


ll_found 	 = istr_param.dw_m.Find(ls_expresion,1,istr_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_liquidacion (long al_row, long al_row_det, string as_flag_tabla);Long   ll_rowcount,ll_item,ll_factor
String ls_cod_moneda
istr_param.dw_m.Accepttext()


ls_cod_moneda = dw_2.object.cod_moneda [al_row_det]
ll_factor	  = dw_2.object.factor		[al_row_det]



/*INSERT PRE*/
ll_rowcount = istr_param.dw_m.RowCount()

IF al_row = 1 THEN 
	ll_item = 0
ELSE
   ll_item = istr_param.dw_m.Getitemnumber(ll_rowcount - 1,"item")
END IF


istr_param.dw_m.SetItem(al_row, "item", ll_item + 1)  

/**************************************************/
/*Colocar un factor de acuerdo a tipo de documento*/
/**************************************************/
IF TRIM(istr_param.string4) = 'LQP' THEN //si es LIQUIDACION X PAGAR invertir factor

	
	if ll_factor = 1 then
		ll_factor = -1
	else
		ll_factor = 1
	end if

	
END IF







istr_param.dw_m.object.factor_signo            [al_row] = ll_factor
istr_param.dw_m.object.origen_doc_ref	         [al_row] = dw_2.object.origen		    [al_row_det]		 		
istr_param.dw_m.object.cod_moneda		         [al_row] = dw_2.object.cod_moneda    [al_row_det]		
istr_param.dw_m.object.confin      	         [al_row] = istr_param.string3
istr_param.dw_m.object.matriz_cntbl  	         [al_row] = istr_param.string5
istr_param.dw_m.object.cxp_cod_rel		         [al_row] = dw_2.object.cod_relacion  [al_row_det]
istr_param.dw_m.object.flag_replicacion        [al_row] = '1'
istr_param.dw_m.object.moneda_cab		         [al_row] = istr_param.string2
istr_param.dw_m.object.tasa_cambio		         [al_row] = istr_param.db2
istr_param.dw_m.object.flag_provisionado		   [al_row] = dw_2.object.flag_provisionado [al_row_det]		 		

istr_param.dw_m.object.soles			            [al_row] = is_soles
istr_param.dw_m.object.dolares     	         [al_row] = is_dolares
istr_param.dw_m.object.proveedor_nom_proveedor	[al_row] = dw_2.object.nom_proveedor [al_row_det]

IF as_flag_tabla = '3' THEN // X PAGAR
	istr_param.dw_m.object.cxp_tipo_doc     [al_row] = dw_2.object.tipo_doc [al_row_det]			
	istr_param.dw_m.object.cxp_nro_doc		  [al_row] = dw_2.object.nro_doc	 [al_row_det]	
ELSE
	istr_param.dw_m.object.cxc_tipo_doc	  [al_row] = dw_2.object.tipo_doc [al_row_det]		
	istr_param.dw_m.object.cxc_nro_doc		  [al_row] = dw_2.object.nro_doc	 [al_row_det]	
END IF	



IF ls_cod_moneda = is_soles THEN
	istr_param.dw_m.object.importe [al_row] = dw_2.object.sldo_sol  [al_row_det]
ELSE
   istr_param.dw_m.object.importe [al_row] = dw_2.object.saldo_dol [al_row_det]
END IF




end subroutine

public subroutine wf_insert_pc ();Long    ll_inicio,ll_row,ll_row_count,ll_factor
Integer li_item
String  ls_soles,ls_dolares,ls_cod_moneda,ls_flag_tabla
Decimal {2} ldc_importe

dw_2.Accepttext()

select cod_soles ,cod_dolares into :ls_soles,:ls_dolares from logparam where (reckey = '1');

For ll_inicio = 1 TO dw_2.Rowcount()
	 
	 /*importe*/
	 ls_cod_moneda = dw_2.object.cod_moneda [ll_inicio]
	 ls_flag_tabla = dw_2.object.flag_tabla [ll_inicio]
	 ll_factor		= dw_2.object.factor		 [ll_inicio]
	 
	 if ls_cod_moneda = ls_soles then
		 ldc_importe = dw_2.object.sldo_sol  [ll_inicio]
	 else
 		 ldc_importe = dw_2.object.saldo_dol [ll_inicio]
	 end if
	
	 ll_row = istr_param.dw_m.InsertRow(0)
	 istr_param.bret = TRUE
	 
	 
	 /*Asignacion de item_deposito*/
	 ll_row_count = istr_param.dw_m.RowCount()
	 
	 IF ll_row_count = 1 THEN 
		 li_item = 0
	 ELSE
		 li_item = istr_param.dw_m.Getitemnumber(ll_row_count - 1,"item")
	 END IF
	 
	 
	 istr_param.dw_m.SetItem(ll_row, "item", li_item + 1)  	 
	 
	 /***********************/



	 
	 IF ls_flag_tabla = '1' THEN //Cuenta x Cobrar
		 istr_param.dw_m.object.doc_cxc     [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 istr_param.dw_m.object.nro_doc_cxc [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 ELSEIF ls_flag_tabla = '3' THEN //Cuenta x Pagar
		 istr_param.dw_m.object.doc_cxp     [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 istr_param.dw_m.object.nro_doc_cxp [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 END IF	

	 istr_param.dw_m.object.cod_rel_cxp 			    [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
	 istr_param.dw_m.object.proveedor_nom_proveedor [ll_row] = dw_2.object.nom_proveedor [ll_inicio]
	 istr_param.dw_m.object.moneda			  			 [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
	 istr_param.dw_m.object.importe			  			 [ll_row] = ldc_importe
	 istr_param.dw_m.object.factor			  			 [ll_row] = ll_factor
	 istr_param.dw_m.object.flag_tabla		  			 [ll_row] = ls_flag_tabla
 	 istr_param.dw_m.object.flag_detraccion			 [ll_row] = '0'
 	 istr_param.dw_m.object.soles						 [ll_row] = ls_soles
 	 istr_param.dw_m.object.dolares						 [ll_row] = ls_dolares
    istr_param.dw_m.object.item_deposito				 [ll_row] = istr_param.long1
	 istr_param.dw_m.object.confin						 [ll_row] = istr_param.string2
	 istr_param.dw_m.object.flag_provisionado		 [ll_row] = dw_2.object.flag_provisionado [ll_inicio]
	 istr_param.dw_m.object.nro_deposito				 [ll_row] = dw_2.object.nro_deposito		[ll_inicio]
	 istr_param.dw_m.object.fecha_deposito			 [ll_row] = dw_2.object.fecha_deposito		[ll_inicio]

	  

Next	 
end subroutine

public function boolean wf_verifica_anticipos (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Decimal 	ldc_saldo_sol,ldc_saldo_dol
String	ls_mensaje


ldc_saldo_sol = 0.00
ldc_saldo_dol = 0.00

DECLARE usp_fin_monto_anticipos PROCEDURE FOR 
	usp_fin_monto_anticipos(:as_cod_relacion,:as_tipo_doc,:as_nro_doc);
EXECUTE usp_fin_monto_anticipos ;


IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("Error", "Error al ejecutar procedimiento usp_fin_monto_anticipos. Mensaje: " + ls_mensaje, StopSign! )
	return false
END IF

FETCH usp_fin_monto_anticipos INTO :ldc_saldo_sol,:ldc_saldo_dol ;
CLOSE usp_fin_monto_anticipos ;


IF ldc_saldo_sol > 0 OR ldc_saldo_dol > 0 THEN
	if Messagebox('Aviso','Documento : '+Trim(as_cod_relacion)+' '+Trim(as_tipo_doc)+' '+Trim(as_nro_doc)&
							+' Tiene Anticipos Pendientes por Un Saldo en S/.'+ Trim(String(ldc_saldo_sol, "###,##0.00")) & 
							+' y En Dolares $ '+ Trim(String(ldc_saldo_dol, "###,##0.00")) &
							+ "~r~nDesea continuar con el pago del comprobante a pesar de los ANTICIPOS?", Information!, YesNo!, 2) = 2 then
		return false					
	end if
END IF


Return true
end function

public subroutine wf_insert_ov_ref ();Long   ll_inicio,ll_row
String ls_doc_ov,ls_cod_origen,ls_nro_ov

select doc_ov into :ls_doc_ov from logparam where reckey = '1' ;

dw_2.Accepttext()


IF dw_2.Rowcount() > 1 THEN
	Messagebox('Aviso','Solamente puede Seleccionar Una Orden de Servicio ,Verfique!')
	RETURN
END IF

For ll_inicio = 1 TO dw_2.Rowcount()

	 
	 ls_cod_origen = dw_2.object.cod_origen [ll_inicio] 
	 ls_nro_ov		= dw_2.object.nro_ov		 [ll_inicio]
	 
	 istr_param.bret = TRUE
	 ll_row = istr_param.dw_m.InsertRow (0)
	 istr_param.dw_m.object.tipo_mov	[ll_row] = 'R'
	 istr_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 istr_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_ov
	 istr_param.dw_m.object.nro_ref    [ll_row] = ls_nro_ov
	 istr_param.dw_m.object.flab_tabor [ll_row] = 'A'
	 

Next	
end subroutine

public function long wf_verifica_detraccion (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);LONG    ll_count

SELECT count(*)
  INTO :ll_count
  FROM DOC_PENDIENTES_CTA_CTE CC
 WHERE CC.COD_RELACION = :as_cod_relacion
   AND CC.TIPO_DOC	  = :as_tipo_doc
   AND CC.NRO_DOC      = :as_nro_doc
	AND CC.FLAG_TABLA   = '3'  
   AND CC.FLAG_DEBHAB  = 'H';

Return ll_count
end function

public subroutine of_opcion15 ();String  	ls_origen,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_cod_moneda,&
		  	ls_matriz,ls_flag_prov,ls_flag_tabla,ls_flag_ctrl_reg, &
		  	ls_flag_estado_og 	, ls_nro_detracción, ls_expresion, &
			ls_nro_certificado	, ls_confin, ls_cnta_bco_prov, ls_cod_banco, ls_nom_banco
			
Long    	ll_inicio,ll_found,ll_row,ll_factor,ll_rowcount,ll_item,ll_count
Integer 	li_nro_sol_pend,li_nro_max
Decimal 	ldc_aplicado_sol,ldc_aplicado_dol, ldc_Importe_detr,ldc_monto_adeuda
u_dw_abc ldw_detail, ldw_master

//Datos para el presupuesto de caja
Integer	li_semana, li_item_prsp
String	ls_nro_presupuesto, ls_moneda_prsp
Decimal	ldc_importe_prsp

/*
sl_param.string2	= ls_cod_moneda
sl_param.string3	= ls_confin
sl_param.db2		= ldc_tasa_cambio
*/
	  
try 
	ldw_detail 	= istr_param.dw_d
	ldw_master	= istr_param.dw_m
	
	//Obtengo las variables de la cabecera
	ls_confin 		= ldw_master.object.confin 		[1]
	ls_cod_banco	= ldw_master.object.cod_banco    [1] 
	
	For ll_inicio = 1 to dw_2.Rowcount()
		ls_origen   	  		= dw_2.object.origen             [ll_inicio]
		ls_tipo_doc 	  		= dw_2.object.tipo_doc           [ll_inicio]
		ls_nro_doc  	  		= dw_2.object.nro_doc            [ll_inicio]
		ls_cod_relacion 		= dw_2.object.cod_relacion       [ll_inicio]
		ls_cod_moneda			= dw_2.object.cod_moneda         [ll_inicio] 
		ls_flag_prov			= dw_2.object.flag_provisionado  [ll_inicio]
		ls_flag_tabla			= dw_2.object.flag_tabla   	   [ll_inicio]
		ll_factor				= dw_2.object.factor   		      [ll_inicio] 
		ls_nro_certificado 	= dw_2.object.nro_Certificado    [ll_inicio] 
		
		ldc_aplicado_sol 		= 0.00
		ldc_aplicado_dol		= 0.00
		
		IF ll_factor = -1 THEN
			ldc_monto_adeuda = f_monto_adeuda_sunat(ls_cod_relacion)
			if ldc_monto_adeuda> 0 then
				Openwithparm(w_msg_deuda_tributaria,String(ldc_monto_adeuda))
			end if
		END IF
		 
		if ls_flag_prov = 'R' and istr_param.opcion = 15 AND ls_flag_tabla = '3'    THEN //VERIFICAR SI CONTIENE ANTICIPOS
			if wf_verifica_anticipos(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) = false then
				istr_param.bret = false
				return 
			end if	
		end if
		 
		IF ls_tipo_doc = is_doc_og  AND istr_param.tipo = '1CP' THEN
			//VERIFICAR SI SOLICITUD DE GIRO ESTA CANCELADA	
			select nvl(flag_estado,'') 
				into :ls_flag_estado_og 
				from solicitud_giro 
			where nro_solicitud = :ls_nro_doc ;
			
			IF ls_flag_estado_og  <> '5' THEN
				/*verificar contador de solcitud de giro*/
				SELECT 	Nvl(nro_solicitudes_pend,0),
							Nvl(nro_maximo_sol_pend,0) 
					INTO 	:li_nro_sol_pend,
							:li_nro_max 
					FROM maestro_param_autoriz 
				  WHERE cod_relacion = :ls_cod_relacion;	 
						 
				IF li_nro_sol_pend >= li_nro_max  THEN
					Messagebox('Aviso','Verifique su maximo de Pendientes de Ordenes de Giro', Exclamation!)					
					istr_param.bret = false
					Return
				END IF
			END IF		 
		END IF				
		
		ls_expresion = "origen_doc = '" + ls_origen + "'" &
						 + " AND cod_relacion = '" + ls_cod_relacion + "'" &
						 + " AND tipo_doc = '" + ls_tipo_doc + "'" &
						 + " AND nro_doc = '" + ls_nro_doc + "'"
	
		ll_found 	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.Rowcount())
		 
		IF ll_found = 0 THEN 
			ll_row = ldw_detail.event ue_insert()
			
			if ll_row <=0 then 
				istr_param.bret = false
				return 
			end if
			
			istr_param.bret = TRUE
			ldw_detail.object.cod_relacion      [ll_row] = ls_cod_relacion
			ldw_detail.object.origen_doc        [ll_row] = ls_origen
			ldw_detail.object.tipo_doc          [ll_row] = ls_tipo_doc
			ldw_detail.object.nro_doc           [ll_row] = ls_nro_doc
			ldw_detail.object.importe           [ll_row] = dw_2.object.importe	      	[ll_inicio]
			ldw_detail.object.tasa_cambio       [ll_row] = ldw_master.object.tasa_cambio 	[1]
			ldw_detail.object.cod_moneda_cab    [ll_row] = ldw_master.object.cod_moneda 	[1]
			ldw_detail.object.cod_moneda        [ll_row] = ls_cod_moneda
			ldw_detail.object.flab_tabor		   [ll_row] = ls_flag_tabla
			ldw_detail.object.confin			   [ll_row] = ls_confin
			ldw_detail.object.nom_proveedor	   [ll_row] = dw_2.object.nom_proveedor 		[ll_inicio]
			ldw_detail.object.flag_provisionado [ll_row] = ls_flag_prov //flag provisionado
			ldw_detail.object.soles				 	[ll_row] = is_soles
			ldw_detail.object.dolares 			 	[ll_row] = is_dolares
			ldw_detail.object.flag_aplic_comp	[ll_row] = '0'		//editable
			ldw_detail.object.cencos           	[ll_row] = dw_2.object.cencos	      		[ll_inicio]
			ldw_detail.object.centro_benef		[ll_row] = dw_2.object.centro_benef			[ll_inicio]
			
			if ldw_detail.of_existecampo( "nro_certificado") then
				ldw_detail.object.nro_Certificado	[ll_row] = ls_nro_certificado
			end if
			
			/***************************************************************************/
			//para caso de orden giro importe no debe ser editable 
			//en ese campo debe ser nulo
			
			//BUSCO MATRIZ
			SELECT matriz_cntbl 
				into :ls_matriz 
				from concepto_financiero 
			where confin = :ls_confin;
			
			if SQLCA.SQlCode = 100 or IsNull(ls_matriz) or ls_matriz= '' then
				f_mensaje('Error, El concepto financiero ' + ls_confin + ' no tiene matriz asociada o no es valido, por favo verifique', '')
				istr_param.bret = false
				return 
			end if
			
			if ldw_detail.of_Existecampo( "matriz_cntbl") then
				ldw_detail.object.matriz_cntbl		 [ll_row] = ls_matriz
			end if
				
			//para caso de la detraccion el tipo de cambio en el detalle debe ser editable
			//cambio realizado el dia 12/05/2005
			if ls_tipo_doc = is_doc_dtrp and ll_factor = -1 then 
				ldw_detail.object.t_detrac    [ll_row] = gnvo_app.is_null
				//ldw_detail.object.tasa_cambio [ll_row] = dw_2.object.tasa_cambio [ll_inicio]
			else
				ldw_detail.object.t_detrac 	[ll_row] =	'1'
			end if
			
			/***************************************************************************/
			//Obtengo el presupuesto de caja si es que lo han tomado por el numero de doc
			/***************************************************************************/
			
			if gnvo_app.of_get_parametro( "USE_PRSP_CAJA", '0') = '1' then
				
				select a.nro_presupuesto, a.semana, b.nro_item, b.cod_moneda, b.imp_proyectado
					into :ls_nro_presupuesto, :li_semana, :li_item_prsp, :ls_moneda_prsp, :ldc_importe_prsp
				from 	prsp_caja a,
				  		prsp_caja_det b
				where a.nro_presupuesto 	= b.nro_presupuesto
					and a.flag_estado     		= '1'
					and b.proveedor       		= :ls_cod_relacion
					and b.tipo_doc        		= :ls_tipo_doc
					and b.nro_doc         		= :ls_nro_doc
					and b.imp_proyectado 	> b.imp_ejecutado
					and rownum				= 1;
				
				if SQLCA.SQLCOde < 0 then
					
					gnvo_app.of_existserror( SQLCA, 'Busqueda de presupuesto de caja')
					
				elseif SQLCA.SQLCOde <> 100 then
					if ldw_detail.of_existecampo( "semana") then
						ldw_detail.object.semana 			 	[ll_row] = li_semana
					end if
					if ldw_detail.of_existecampo( "nro_prsp") then
						ldw_detail.object.nro_prsp				[ll_row] = ls_nro_presupuesto
					end if
					if ldw_detail.of_existecampo( "item_prsp") then
						ldw_detail.object.item_prsp			[ll_row] = li_item_prsp
					end if
					if ldw_detail.of_existecampo( "moneda_psrsp") then
						ldw_detail.object.moneda_psrsp		[ll_row] = ls_moneda_prsp
					end if
					if ldw_detail.of_existecampo( "imp_proyectado") then
						ldw_detail.object.imp_proyectado		[ll_row] = ldc_importe_prsp
					end if
				end if
			end if
			
			
			IF ls_tipo_doc = is_doc_og THEN
				ldw_detail.object.t_tipdoc 		 [ll_row] = gnvo_app.is_null
			ELSE
				//verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
				select count(*) 
					into :ll_count 
				from doc_grupo_relacion dg 
				where dg.grupo    = 'C2'         
				  and dg.tipo_doc = :ls_tipo_doc;
			 
				if (ll_count > 0 AND ls_flag_prov = 'D' AND ll_factor = -1 AND ls_flag_tabla = '3') then
					select cp.flag_control_reg 
						into :ls_flag_ctrl_reg
						from cntas_pagar cp
					where cp.cod_relacion = :ls_cod_relacion
					  and cp.tipo_doc     = :ls_tipo_doc    
					  and cp.nro_doc      = :ls_nro_doc;
				 
					if ls_flag_ctrl_reg = '1' then
						ldw_detail.object.t_tipdoc [ll_row] = gnvo_app.is_null
					else
						ldw_detail.object.t_tipdoc [ll_row] = '1'	
					end if
				else
					ldw_detail.object.t_tipdoc [ll_row] = '1'	
				end if				 
			END IF	
			
			/*********************************************************************************/
			//Validar si el proveedor tiene una unica cuenta de banco para tomarla por defecto
			/*********************************************************************************/
			select count(*)
			  into :ll_count
		  	  from PROV_BANCO_CNTA t,
				 	 banco           b
		 	 where t.cod_banco     	= b.cod_banco
			   and t.proveedor		= :ls_cod_relacion
			   and t.cod_moneda	 	= :ls_cod_moneda
				and t.cod_banco		= :ls_cod_banco
				and t.flag_estado		= '1';
			
			if ll_count = 1 then
				select t.cnta_bco_prov, b.nom_banco
				  into :ls_cnta_bco_prov, :ls_nom_banco
				  from PROV_BANCO_CNTA t,
						 banco           b
				 where t.cod_banco     	= b.cod_banco
				   and t.proveedor		= :ls_cod_relacion
				   and t.cod_moneda	 	= :ls_cod_moneda
					and t.cod_banco		= :ls_cod_banco
					and t.flag_estado		= '1';
				
				if SQLCA.SQLCOde < 0 then
					gnvo_app.of_existserror( SQLCA, 'Busqueda de presupuesto de caja')
				end if
				
				ldw_detail.object.cnta_bco_prov			[ll_row] = ls_cnta_bco_prov
				ldw_detail.object.cod_moneda_bco_prov	[ll_row] = ls_cod_moneda					
				ldw_detail.object.cod_banco           	[ll_row] = ls_cod_banco
				ldw_detail.object.nom_banco				[ll_row] = ls_nom_banco
				
			end if
			 

			//colocar factor
			if ll_factor = -1 then
				ldw_detail.object.factor [ll_row] = 1
			else
				ldw_detail.object.factor [ll_row] = -1
			end if
			 
			//bloqueo de campos....
			ldw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("flag_referencia.Protect ='1~tIf(IsNull(flag_doc),1,0)'")					 
			ldw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
			ldw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")		
			ldw_detail.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")		
			ldw_detail.Modify("tasa_cambio.Protect ='1~tIf(IsNull(t_detrac),0,1)'")
			 
			//no marcar para flijo de caja
			if ls_tipo_doc = is_doc_dtrp and ll_factor = 1 then 
				ldw_detail.object.flag_flujo_caja [ll_row] = '0'
			end if
		 END IF
	Next

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurido una excepcion ' + ex.getMessage(), StopSign!)
end try

			  
end subroutine

public function boolean of_opcion1 ();String	ls_tipo_mov, ls_origen, ls_cod_relacion, ls_tipo_doc, ls_nro_doc, &
			ls_flag_tabla, ls_flag_provisionado, ls_moneda, ls_expresion
Decimal	ldc_saldo_sol, ldc_saldo_dol, ldc_imp_total, ldc_tasa_cambio
Long		ll_factor, ll_row, ll_inicio, ll_found
u_dw_abc	ldw_detail, ldw_master

ldw_detail 	= istr_param.dw_d
ldw_master	= istr_param.dw_m

if ldw_master.RowCount() = 0 then
	ROLLBACK;
	f_Mensaje('El documento no tiene cabecera, por favor verifique','')
	return false
end if

ldc_tasa_cambio = Dec(ldw_master.object.tasa_cambio [ldw_master.getRow()])

istr_param.bret = FALSE
				
//tipo de movimiento
IF istr_param.opcion = 1 THEN	   //PAGAR 	
	ls_tipo_mov = 'P'
ELSEIF istr_param.opcion = 2 THEN  //COBRAR
	ls_tipo_mov = 'C'
ELSEIF istr_param.opcion = 24 THEN //COBRAR	
	ls_tipo_mov = 'C'
END IF

For ll_inicio = 1 TO dw_2.Rowcount ()
	ls_origen       		 = dw_2.object.origen       		[ll_inicio]
	ls_cod_relacion 		 = dw_2.object.cod_relacion 		[ll_inicio]
	ls_tipo_doc     		 = dw_2.object.tipo_doc     		[ll_inicio]
	ls_nro_doc   	  		 = dw_2.object.nro_doc      		[ll_inicio]	
	ls_flag_tabla	  		 = dw_2.object.flag_tabla   		[ll_inicio]	
	ls_moneda   		 	 = dw_2.object.cod_moneda        [ll_inicio]	
	ldc_saldo_sol   		 = dw_2.object.sldo_sol	         [ll_inicio]
	ldc_saldo_dol	  		 = dw_2.object.saldo_dol         [ll_inicio]		
	ll_factor	     		 = dw_2.object.factor            [ll_inicio]		
	ls_flag_provisionado = dw_2.object.flag_provisionado [ll_inicio]		
	
	
	IF ls_moneda = is_soles THEN //soles 
	 ldc_imp_total = ldc_saldo_sol
	ELSEIF ls_moneda = is_dolares THEN //dolares
	 ldc_imp_total = ldc_saldo_dol
	END IF
	
	//verifico que referencia no ha sido registrada
	ls_expresion = "proveedor_ref = '" + ls_cod_relacion + "' AND tipo_ref = '" + ls_tipo_doc + "' AND nro_ref = '"+ls_nro_doc +"'"

	ll_found 	 = ldw_detail.Find(ls_expresion,1, ldw_detail.Rowcount())

	IF ll_found = 0 THEN
	 ll_row = ldw_detail.event ue_insert()
	 
	 if ll_row > 0 then
		 istr_param.bret = TRUE	
		 ldw_detail.object.origen_ref        [ll_row] = ls_origen
		 ldw_detail.object.tipo_mov	       [ll_row] = ls_tipo_mov
		 ldw_detail.object.proveedor_ref     [ll_row] = ls_cod_relacion
		 ldw_detail.object.tipo_ref          [ll_row] = ls_tipo_doc
		 ldw_detail.object.nro_ref           [ll_row] = ls_nro_doc
		 ldw_detail.object.importe           [ll_row] = ldc_imp_total
		 ldw_detail.object.flab_tabor        [ll_row] = ls_flag_tabla 
		 ldw_detail.object.factor            [ll_row] = ll_factor
		 ldw_detail.object.cod_moneda_det    [ll_row] = ls_moneda
		 ldw_detail.object.cod_moneda_cab    [ll_row] = istr_param.string2
		 ldw_detail.object.tasa_cambio       [ll_row] = istr_param.db2
		 ldw_detail.object.soles		       [ll_row] = is_soles
		 ldw_detail.object.dolares		       [ll_row] = is_dolares
		 ldw_detail.object.flag_provisionado [ll_row] = ls_flag_provisionado
	 end if
	END IF
	 
Next	
				
return true

end function

public function boolean of_opcion18 ();Long   	ll_inicio,			ll_factor,			ll_found,		ll_row,				ll_Rowcount,	&
			ll_item,				ll_count
String 	ls_origen,			ls_tipo_doc,		ls_nro_doc,		ls_cod_relacion,	ls_cod_moneda,&
		 	ls_matriz,			ls_doc_sol_giro,	ls_flag_prov,	ls_flag_tabla,&
		 	ls_flag_ctrl_reg,	ls_flag_estado	, &
		 	ls_nro_detracción
Decimal 	ldc_monto_adeuda, ldc_Importe_detr
u_dw_abc	ldw_detail

//solicitud giro
select doc_sol_giro 
  into :ls_doc_sol_giro 
  from finparam where (reckey = '1');

For ll_inicio = 1 to dw_2.Rowcount()
    ls_origen   	  	= dw_2.object.origen            [ll_inicio]
	 ls_tipo_doc 	  	= dw_2.object.tipo_doc          [ll_inicio]
	 ls_nro_doc  	  	= dw_2.object.nro_doc           [ll_inicio]
	 ls_cod_relacion 	= dw_2.object.cod_relacion      [ll_inicio]
    ls_cod_moneda		= dw_2.object.cod_moneda        [ll_inicio] 
	 ll_factor			= dw_2.object.factor   		     [ll_inicio] 
	 ls_flag_prov		= dw_2.object.flag_provisionado [ll_inicio]
	 ls_flag_tabla		= dw_2.object.flag_tabla   	  [ll_inicio]
	 
	 ll_found = wf_verifica_doc (ls_origen,ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	 
//	 IF wf_verifica_detraccion(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) > 0 THEN
//	   
//		SELECT CP.NRO_DETRACCION,
//             Round((NVL(CP.IMPORTE_DOC,0)*NVL(CP.PORC_DETRACCION,0))/100,2)
//		  INTO :ls_nro_detracción, :ldc_Importe_detr
//        FROM CNTAS_PAGAR CP 
//       WHERE CP.COD_RELACION = :ls_cod_relacion
//         AND CP.TIPO_DOC     = :ls_tipo_doc
//			AND CP.NRO_DOC 	  = :ls_nro_doc;
//		  
//		 MESSAGEBOX('Aviso','El documento Tiene una detracción por descontar~r'+&
//		 			   +'Proveedor: '+ls_cod_relacion+'~r'+'Tipo_Doc: '+ls_tipo_doc+'~r'+'Nro_Doc: '+ls_nro_doc+'~r'&
//						+'Nro_Detracción: '+ls_nro_detracción+' Importe_detracción: '+string(ldc_Importe_detr) )
//		 
//		 GOTO SALIDA
//		 
//	End If


	 //DEUDA TRIBUTARIA

	 IF ll_factor = -1 THEN
		 ldc_monto_adeuda = f_monto_adeuda_sunat(ls_cod_relacion)
		 if ldc_monto_adeuda> 0 then
			 Openwithparm(w_msg_deuda_tributaria,String(ldc_monto_adeuda))
		 end if
	 END IF
	 
	 IF ll_found = 0 THEN 
		 /*INSERT PRE*/
		 ldw_detail = istr_param.dw_m
		 
		 ll_row = ldw_detail.event ue_insert( )
		 
		 if ll_row > 0 then
			 ldw_detail.object.flag_flujo_caja [ll_row] = '1'
			 /**/
			 ll_factor = dw_2.object.factor [ll_inicio]	
			 
	
			 istr_param.bret = TRUE
			 ldw_detail.object.cod_relacion      [ll_row] = dw_2.object.cod_relacion 	[ll_inicio]
			 ldw_detail.object.origen_doc        [ll_row] = ls_origen
			 ldw_detail.object.tipo_doc          [ll_row] = ls_tipo_doc
			 ldw_detail.object.nro_doc           [ll_row] = ls_nro_doc
			 ldw_detail.object.importe           [ll_row] = dw_2.object.importe	    	[ll_inicio]
			 ldw_detail.object.tasa_cambio       [ll_row] = istr_param.db2
			 ldw_detail.object.cod_moneda_cab    [ll_row] = istr_param.string2
			 ldw_detail.object.cod_moneda        [ll_row] = ls_cod_moneda
			 ldw_detail.object.flab_tabor		    [ll_row] = dw_2.object.flag_tabla   	[ll_inicio]
			 ldw_detail.object.confin			    [ll_row] = istr_param.string3
			 ldw_detail.object.factor			    [ll_row] = dw_2.object.factor		 	[ll_inicio]	
			 ldw_detail.object.nom_proveedor     [ll_row] = dw_2.object.nom_proveedor	[ll_inicio]	
			 ldw_detail.object.flag_provisionado [ll_row] = ls_flag_prov
			 ldw_detail.object.cencos 				 [ll_row] = dw_2.object.cencos			[ll_inicio]	
			 ldw_detail.object.soles				 [ll_row] = gnvo_app.is_soles
			 ldw_detail.object.dolares				 [ll_row] = gnvo_app.is_dolares
			 ldw_detail.object.flag_aplic_comp	 [ll_row] = '0'			//compesacion
			 
			 //BUSCO MATRIZ
			 SELECT matriz_cntbl 
			 	into :ls_matriz 
			 from concepto_financiero 
			 where confin = :istr_param.string3 ;
			 
			 ldw_detail.object.matriz_cntbl		 [ll_row] = ls_matriz
	
			 
			 
			 //para caso de orden giro importe no debe ser editable 
			 //en ese campo debe ser nulo
			 IF ls_tipo_doc = ls_doc_sol_giro THEN
				 ldw_detail.object.t_tipdoc 		    [ll_row] = gnvo_app.is_null
				 
				 //colocar que va ser editable cuando va ser una devolucion
				 select flag_estado 
				   into :ls_flag_estado 
					from solicitud_giro 
				  where nro_solicitud = :ls_nro_doc ;
				  
				 if ll_factor = 1 and ls_flag_estado = '5' then
					 ldw_detail.object.t_tipdoc [ll_row] = '1'
				 end if	
				 
			 ELSE
				 //verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
				 select count(*) 
				   into :ll_count 
					from doc_grupo_relacion dg 
				  where (dg.grupo    = 'C1'         ) and
						  (dg.tipo_doc = :ls_tipo_doc ) ;
				 
				 if (ll_count > 0 AND ls_flag_prov = 'D' AND ll_factor = 1 AND ls_flag_tabla = '1') then
					 select cc.flag_control_reg 
					   into :ls_flag_ctrl_reg
						from cntas_cobrar cc
					  where (cc.cod_relacion = :ls_cod_relacion) and
							  (cc.tipo_doc     = :ls_tipo_doc    ) and
							  (cc.nro_doc      = :ls_nro_doc     ) ;
					 
					 if ls_flag_ctrl_reg = '1' then
						 ldw_detail.object.t_tipdoc [ll_row] = gnvo_app.is_null
					 else
						 ldw_detail.object.t_tipdoc [ll_row] = '1'	
					 end if
				 else
					 ldw_detail.object.t_tipdoc [ll_row] = '1'	
				 end if				 
					 
			 END IF		
			 
			 //bloqueo de campos....
			 ldw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
			 ldw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
			 ldw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
			 ldw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_doc),1,0)'")			
			 ldw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_doc),1,0)'")			
			 ldw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
			 ldw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")		
			 ldw_detail.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")		

			
		 end if

		 

		 


						
  
		 
		 
    END IF
	 
//SALIDA:		
	
Next

return true
			  
end function

public subroutine of_opcion25 ();String  	ls_origen,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_cod_moneda,&
		  	ls_matriz,ls_flag_prov,ls_flag_tabla,ls_flag_ctrl_reg, &
		  	ls_flag_estado_og 	, ls_nro_detracción, ls_expresion, &
			ls_nro_certificado	, ls_confin
Long    	ll_inicio,ll_found,ll_row,ll_factor,ll_rowcount,ll_item,ll_count
Integer 	li_nro_sol_pend,li_nro_max
Decimal 	ldc_aplicado_sol,ldc_aplicado_dol, ldc_Importe_detr,ldc_monto_adeuda
u_dw_abc ldw_detail, ldw_master

//Datos para el presupuesto de caja
Integer	li_semana, li_item_prsp
String	ls_nro_presupuesto, ls_moneda_prsp
Decimal	ldc_importe_prsp

/*
sl_param.string2	= ls_cod_moneda
sl_param.string3	= ls_confin
sl_param.db2		= ldc_tasa_cambio
*/
	  
try 
	ldw_detail 	= istr_param.dw_d
	ldw_master	= istr_param.dw_m
	
	//Obtengo las variables de la cabecera
	ls_confin = ldw_master.object.confin 		[1]
	
	For ll_inicio = 1 to dw_2.Rowcount()
		ls_origen   	  		= dw_2.object.origen             [ll_inicio]
		ls_tipo_doc 	  		= dw_2.object.tipo_doc           [ll_inicio]
		ls_nro_doc  	  		= dw_2.object.nro_doc            [ll_inicio]
		ls_cod_relacion 		= dw_2.object.cod_relacion       [ll_inicio]
		ls_cod_moneda			= dw_2.object.cod_moneda         [ll_inicio] 
		ls_flag_prov			= dw_2.object.flag_provisionado  [ll_inicio]
		ls_flag_tabla			= dw_2.object.flag_tabla   	   [ll_inicio]
		ll_factor				= dw_2.object.factor   		      [ll_inicio] 
		ls_nro_certificado 	= dw_2.object.nro_Certificado    [ll_inicio] 
		ldc_aplicado_sol 		= 0.00
		ldc_aplicado_dol		= 0.00
		
		IF ll_factor = -1 THEN
			ldc_monto_adeuda = f_monto_adeuda_sunat(ls_cod_relacion)
			if ldc_monto_adeuda> 0 then
				Openwithparm(w_msg_deuda_tributaria,String(ldc_monto_adeuda))
			end if
		END IF
		 
		if ls_flag_prov = 'R' and istr_param.opcion = 15 AND ls_flag_tabla = '3'    THEN //VERIFICAR SI CONTIENE ANTICIPOS
			if wf_verifica_anticipos(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) = false then
				istr_param.bret = false
				return 
			end if	
		end if
		 
	//   IF wf_verifica_detraccion(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) > 0 THEN
	//	   
	//		SELECT CP.NRO_DETRACCION,
	//             Round((NVL(CP.IMPORTE_DOC,0)*NVL(CP.PORC_DETRACCION,0))/100,2)
	//		  INTO :ls_nro_detracción, :ldc_Importe_detr
	//        FROM CNTAS_PAGAR CP 
	//       WHERE CP.COD_RELACION = :ls_cod_relacion
	//         AND CP.TIPO_DOC     = :ls_tipo_doc
	//			AND CP.NRO_DOC 	  = :ls_nro_doc;
	//		  
	//		 MESSAGEBOX('Aviso','El documento Tiene una detracción por descontar~r'+&
	//		 			   +'Proveedor: '+ls_cod_relacion+'~r'+'Tipo_Doc: '+ls_tipo_doc+'~r'+'Nro_Doc: '+ls_nro_doc+'~r'&
	//						+'Nro_Detracción: '+ls_nro_detracción+' Importe_detracción: '+string(ldc_Importe_detr) )
	//		 
	//		 GOTO SALIDA
	//		 
	//	End If
		 
		 
		IF ls_tipo_doc = is_doc_og  AND istr_param.tipo = '1CP' THEN
			//VERIFICAR SI SOLICITUD DE GIRO ESTA CANCELADA	
			select nvl(flag_estado,'') 
				into :ls_flag_estado_og 
				from solicitud_giro 
			where nro_solicitud = :ls_nro_doc ;
			
			IF ls_flag_estado_og  <> '5' THEN
				/*verificar contador de solcitud de giro*/
				SELECT 	Nvl(nro_solicitudes_pend,0),
							Nvl(nro_maximo_sol_pend,0) 
					INTO 	:li_nro_sol_pend,
							:li_nro_max 
					FROM maestro_param_autoriz 
				  WHERE cod_relacion = :ls_cod_relacion;	 
						 
				IF li_nro_sol_pend >= li_nro_max  THEN
					Messagebox('Aviso','Verifique su maximo de Pendientes de Ordenes de Giro', Exclamation!)					
					istr_param.bret = false
					Return
				END IF
			END IF		 
		END IF				
		
		ls_expresion = "origen_doc = '" + ls_origen + "'" &
						 + " AND cod_relacion = '" + ls_cod_relacion + "'" &
						 + " AND tipo_doc = '" + ls_tipo_doc + "'" &
						 + " AND nro_doc = '" + ls_nro_doc + "'"
	
		ll_found 	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.Rowcount())
		 
		IF ll_found = 0 THEN 
			ll_row = ldw_detail.event ue_insert()
			
			if ll_row <=0 then 
				istr_param.bret = false
				return 
			end if
			
			istr_param.bret = TRUE
			ldw_detail.object.cod_relacion      [ll_row] = ls_cod_relacion
			ldw_detail.object.origen_doc        [ll_row] = ls_origen
			ldw_detail.object.tipo_doc          [ll_row] = ls_tipo_doc
			ldw_detail.object.nro_doc           [ll_row] = ls_nro_doc
			ldw_detail.object.importe           [ll_row] = dw_2.object.importe	      	[ll_inicio]
			ldw_detail.object.tasa_cambio       [ll_row] = ldw_master.object.tasa_cambio 	[1]
			ldw_detail.object.cod_moneda_cab    [ll_row] = ldw_master.object.cod_moneda 	[1]
			ldw_detail.object.cod_moneda        [ll_row] = ls_cod_moneda
			ldw_detail.object.flab_tabor		   [ll_row] = ls_flag_tabla
			ldw_detail.object.confin			   [ll_row] = ls_confin
			ldw_detail.object.nom_proveedor	   [ll_row] = dw_2.object.nom_proveedor 		[ll_inicio]
			ldw_detail.object.flag_provisionado [ll_row] = ls_flag_prov //flag provisionado
			ldw_detail.object.soles				 	[ll_row] = is_soles
			ldw_detail.object.dolares 			 	[ll_row] = is_dolares
			ldw_detail.object.flag_aplic_comp	[ll_row] = '0'		//editable
			ldw_detail.object.cencos           	[ll_row] = dw_2.object.cencos	      		[ll_inicio]
			ldw_detail.object.centro_benef		[ll_row] = dw_2.object.centro_benef			[ll_inicio]
			
			if ldw_detail.of_existecampo( "nro_certificado") then
				ldw_detail.object.nro_Certificado	[ll_row] = ls_nro_certificado
			end if
			
			/***************************************************************************/
			//para caso de orden giro importe no debe ser editable 
			//en ese campo debe ser nulo
			
			//BUSCO MATRIZ
			SELECT matriz_cntbl 
				into :ls_matriz 
				from concepto_financiero 
			where confin = :ls_confin;
			
			if SQLCA.SQlCode = 100 or IsNull(ls_matriz) or ls_matriz= '' then
				f_mensaje('Error, El concepto financiero ' + ls_confin + ' no tiene matriz asociada o no es valido, por favo verifique', '')
				istr_param.bret = false
				return 
			end if
			
			if ldw_detail.of_Existecampo( "matriz_cntbl") then
				ldw_detail.object.matriz_cntbl		 [ll_row] = ls_matriz
			end if
				
			//para caso de la detraccion el tipo de cambio en el detalle debe ser editable
			//cambio realizado el dia 12/05/2005
			if ls_tipo_doc = is_doc_dtrp and ll_factor = -1 then 
				ldw_detail.object.t_detrac    [ll_row] = gnvo_app.is_null
				//ldw_detail.object.tasa_cambio [ll_row] = dw_2.object.tasa_cambio [ll_inicio]
			else
				ldw_detail.object.t_detrac 	[ll_row] =	'1'
			end if
			
			/***************************************************************************/
			//Obtengo el presupuesto de caja si es que lo han tomado por el numero de doc
			/***************************************************************************/
			
			if gnvo_app.of_get_parametro( "USE_PRSP_CAJA", '0') = '1' then
				
				select a.nro_presupuesto, a.semana, b.nro_item, b.cod_moneda, b.imp_proyectado
					into :ls_nro_presupuesto, :li_semana, :li_item_prsp, :ls_moneda_prsp, :ldc_importe_prsp
				from 	prsp_caja a,
				  		prsp_caja_det b
				where a.nro_presupuesto 	= b.nro_presupuesto
					and a.flag_estado     		= '1'
					and b.proveedor       		= :ls_cod_relacion
					and b.tipo_doc        		= :ls_tipo_doc
					and b.nro_doc         		= :ls_nro_doc
					and b.imp_proyectado 	> b.imp_ejecutado
					and rownum				= 1;
				
				if SQLCA.SQLCOde < 0 then
					
					gnvo_app.of_existserror( SQLCA, 'Busqueda de presupuesto de caja')
					
				elseif SQLCA.SQLCOde <> 100 then
					if ldw_detail.of_existecampo( "semana") then
						ldw_detail.object.semana 			 	[ll_row] = li_semana
					end if
					if ldw_detail.of_existecampo( "nro_prsp") then
						ldw_detail.object.nro_prsp				[ll_row] = ls_nro_presupuesto
					end if
					if ldw_detail.of_existecampo( "item_prsp") then
						ldw_detail.object.item_prsp			[ll_row] = li_item_prsp
					end if
					if ldw_detail.of_existecampo( "moneda_psrsp") then
						ldw_detail.object.moneda_psrsp		[ll_row] = ls_moneda_prsp
					end if
					if ldw_detail.of_existecampo( "imp_proyectado") then
						ldw_detail.object.imp_proyectado		[ll_row] = ldc_importe_prsp
					end if
				end if
			end if
			
			
			IF ls_tipo_doc = is_doc_og THEN
				ldw_detail.object.t_tipdoc 		 [ll_row] = gnvo_app.is_null
			ELSE
				//verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
				select count(*) 
					into :ll_count 
				from doc_grupo_relacion dg 
				where dg.grupo    = 'C2'         
				  and dg.tipo_doc = :ls_tipo_doc;
			 
				if (ll_count > 0 AND ls_flag_prov = 'D' AND ll_factor = -1 AND ls_flag_tabla = '3') then
					select cp.flag_control_reg 
						into :ls_flag_ctrl_reg
						from cntas_pagar cp
					where cp.cod_relacion = :ls_cod_relacion
					  and cp.tipo_doc     = :ls_tipo_doc    
					  and cp.nro_doc      = :ls_nro_doc;
				 
					if ls_flag_ctrl_reg = '1' then
						ldw_detail.object.t_tipdoc [ll_row] = gnvo_app.is_null
					else
						ldw_detail.object.t_tipdoc [ll_row] = '1'	
					end if
				else
					ldw_detail.object.t_tipdoc [ll_row] = '1'	
				end if				 
			END IF				
			 
			//colocar factor
			if ll_factor = -1 then
				ldw_detail.object.factor [ll_row] = 1
			else
				ldw_detail.object.factor [ll_row] = -1
			end if
			 
			//bloqueo de campos....
			ldw_detail.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("flag_referencia.Protect ='1~tIf(IsNull(flag_doc),1,0)'")					 
			ldw_detail.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_doc),1,0)'")			
			ldw_detail.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
			ldw_detail.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")		
			ldw_detail.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")		
			ldw_detail.Modify("tasa_cambio.Protect ='1~tIf(IsNull(t_detrac),0,1)'")
			 
			//no marcar para flijo de caja
			if ls_tipo_doc = is_doc_dtrp and ll_factor = 1 then 
				ldw_detail.object.flag_flujo_caja [ll_row] = '0'
			end if
		 END IF
	Next

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurido una excepcion ' + ex.getMessage(), StopSign!)
end try

			  
end subroutine

on w_abc_seleccion_lista.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.uo_search
end on

on w_abc_seleccion_lista.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.uo_search)
end on

event ue_open_pre;Long   ll_row

// Recoge parametro enviado
dw_1.DataObject = istr_param.dw1
dw_2.Dataobject = istr_param.dw1

dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)

//Posiciones 
//if not IsNull(istr_param.db1) and istr_param.db1 > 0 then
//	This.width = istr_param.db1 * 2 + pb_1.width + 50
//end if


IF TRIM(istr_param.tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE istr_param.tipo
			 CASE '1CP','1CC' //cartera de pagos,cartera de cobro 
					dw_1.Retrieve(istr_param.string1) 
			 CASE	'1CLF'	//CIERRA LIQUIDACION FONDO FIJO
					dw_1.Retrieve(istr_param.string1,istr_param.string2) 
			 CASE '1AP'    //APLICACION DE DOCUMENTO
					dw_1.Retrieve(istr_param.string1) 
			 CASE '1POG'    //PRE LIQUIDACION ORDEN_GIRO
					dw_1.Retrieve(istr_param.string1) 						
			 CASE '1PDXG'    //DOC. X PAGAR EN FONDO FIJO
					dw_1.Retrieve(istr_param.string1,istr_param.string2) 												
			 CASE '1DPOG'    //PRE LIQUIDACION ORDEN_GIRO DOC X PAGAR
					dw_1.Retrieve(istr_param.string1)
			 CASE '1OG'		  //ORDEN DE GIRO		
					dw_1.Retrieve(istr_param.string1)
			 CASE '1LQ'		  //LIQUIDACION DE PAGO
					dw_1.Retrieve(istr_param.string1)						
			 CASE '1CD' 	  //Comprobantes de Detraccion
					dw_1.Retrieve(istr_param.string3, istr_param.string1, istr_param.str_array)
			 CASE '1OV'		  //ANTICIPO DE ORDENES DE VENTA
					dw_1.Retrieve(istr_param.string1)			
			 CASE '1OC'		  //ANTICIPO DE ORDENES DE COMPRA
					dw_1.Retrieve(istr_param.string1)				
			 CASE '1OS'		  //ANTICIPO DE ORDENES DE SERVICIO
					dw_1.Retrieve(istr_param.string1)		
			 CASE '1PP'		  //PROGRAMACION DE PAGOS
					dw_1.Retrieve(istr_param.string1)	
			 CASE	'1DETA'		//DETRACCION
					dw_1.Retrieve(istr_param.string4,istr_param.string1,istr_param.string3)
			 CASE	'1DETATEMP' //DETRACCION  TEMPORAL
					dw_1.Retrieve(istr_param.string4)	
	END CHOOSE
END IF


SELECT cod_soles,cod_dolares 
	into :is_soles,:is_dolares 
from logparam 
where reckey = '1';

SELECT doc_sol_giro ,doc_detrac_cp 
 INTO :is_doc_og, :is_doc_dtrp
FROM finparam 
WHERE reckey = '1' ;

This.Title = istr_param.titulo
is_col = dw_1.Describe("#1" + ".name")

uo_search.of_set_dw(dw_1)
end event

event open;//override
THIS.EVENT ue_open_pre()
end event

event resize;call super::resize;dw_1.height = newheight - dw_1.y - 10
dw_2.height = newheight - dw_2.y - 10

pb_1.x 	  = newwidth / 2 - pb_1.width / 2
pb_2.x 	  = newwidth / 2 - pb_2.width / 2

dw_1.width = pb_1.x - dw_1.x - 10

dw_2.x 	  = pb_1.x + pb_1.width + 10
dw_2.width = newwidth - dw_2.x - 10

cb_transferir.x	  = newwidth - cb_transferir.width - 10

uo_search.width	  = cb_transferir.x - uo_search.x - 10
uo_search.event ue_resize(sizetype, uo_search.width, newheight)


end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista
integer x = 0
integer y = 108
integer width = 517
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	istr_param = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0
end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

idw_det.SetRedraw(false)
idw_det.Sort()
idw_det.GroupCalc()
idw_det.SetRedraw(true)
end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)

FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.SetRedraw(false)
idw_det.ScrollToRow(ll_row)
idw_det.SetRedraw(true)

idw_det.Sort()
idw_det.GroupCalc()



end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista
integer x = 690
integer y = 108
integer width = 1874
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
CHOOSE CASE istr_param.opcion 
			 CASE 1,2,24 //Canje de letras x cobrar y pagar
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
				ii_rk[10] = 10      //provisionado
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
				ii_dk[10] = 10
				
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
				
		 CASE 4,5	//ORDEN DE COMPRA ADELANTOS,ORDEN DE SERVICIO ADELANTOS,LIQUIDACION DE PAGO

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
				
	  CASE	8  //Pre liquidacion de orden de giro
		
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
				ii_rk[14] = 14
				ii_rk[15] = 15
				ii_rk[16] = 16
				ii_rk[17] = 17
				ii_rk[18] = 18
							
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
				ii_dk[14] = 14
				ii_dk[15] = 15
				ii_dk[16] = 16
				ii_dk[17] = 17
				ii_dk[18] = 18				
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
				
		
				
		 CASE 15,25    // Cartera de pagos
										// Deploy key
				ii_rk[1]  = 1		//codigo de relacion		
				ii_rk[2]  = 2		//tipo doc		
				ii_rk[3]  = 3		//nro doc		
				ii_rk[4]  = 4		//flag tabla		
				ii_rk[5]  = 5		//cnta ctbl
				ii_rk[6]  = 6		//moneda
				ii_rk[7]  = 7		//flag debhab
				ii_rk[8]  = 8		//sldo sol
				ii_rk[9]  = 9		//saldo dol
				ii_rk[10] = 10		//fecha doc
				ii_rk[11] = 11		//factor
				ii_rk[12] = 12		//origen								
				ii_rk[13] = 13		//importe
				ii_rk[14] = 14		//flag provisionado
				ii_rk[15] = 15		//nom proveedor
				ii_rk[16] = 16		//planilla cobranza
				ii_rk[17] = 17		//TIPO DE CAMBIO
				ii_rk[18] = 18		//Saldo Aplicado Soles
				ii_rk[19] = 19		//Saldo Aplicado Dolares
				
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
				ii_dk[14] = 14
				ii_dk[15] = 15	
				ii_dk[16] = 16		//planilla cobranza				
				ii_dk[17] = 17		//TIPO DE CAMBIO DE PROVISION
				ii_dk[18] = 18		//Saldo Aplicado Soles
				ii_dk[19] = 19		//Saldo Aplicado Dolares
				
		 CASE	16    //LIQUIDACION DE PESCA
				ii_rk[1]  = 1		//codigo de relacion		
				ii_rk[2]  = 2		//tipo doc		
				ii_rk[3]  = 3		//nro doc		
				ii_rk[4]  = 4		//flag tabla		
				ii_rk[5]  = 5		//cnta ctbl
				ii_rk[6]  = 6		//moneda
				ii_rk[7]  = 7		//flag debhab
				ii_rk[8]  = 8		//sldo sol
				ii_rk[9]  = 9		//saldo dol
				ii_rk[10] = 10		//fecha doc
				ii_rk[11] = 11		//factor
				ii_rk[12] = 12		//origen								
				ii_rk[13] = 13		//importe
				ii_rk[14] = 14		//flag provisionado
				ii_rk[15] = 15		//nom proveedor
				ii_rk[16] = 16		//planilla cobranza
										
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
				ii_dk[14] = 14
				ii_dk[15] = 15	
				ii_dk[16] = 16		//planilla cobranza							
		 CASE 18    // Cartera de cobros
										// Deploy key
				ii_rk[1]  = 1		//codigo de relacion		
				ii_rk[2]  = 2		//tipo doc		
				ii_rk[3]  = 3		//nro doc		
				ii_rk[4]  = 4		//flag tabla		
				ii_rk[5]  = 5		//cnta ctbl
				ii_rk[6]  = 6		//moneda
				ii_rk[7]  = 7		//flag debhab
				ii_rk[8]  = 8		//sldo sol
				ii_rk[9]  = 9		//saldo dol
				ii_rk[10] = 10		//fecha doc
				ii_rk[11] = 11		//factor
				ii_rk[12] = 12		//origen								
				ii_rk[13] = 13		//importe
				ii_rk[14] = 14		//flag provisionado
				ii_rk[15] = 15		//nom proveedor
				ii_rk[16] = 16		//planilla cobranza				
				ii_rk[17] = 17		//TIPO CAMBIO
				ii_rk[18] = 18		//Saldo Aplicado Soles
				ii_rk[19] = 19		//Saldo Aplicado Dolares
				
				
										
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
				ii_dk[14] = 14				
				ii_dk[15] = 15		//nom proveedor				
				ii_dk[16] = 16		//planilla cobranza								
				ii_dk[17] = 17		//TIPO DE CAMBIO
				ii_dk[18] = 18		//Saldo Aplicado Soles
				ii_dk[19] = 19		//Saldo Aplicado Dolares

				
		 CASE 19    // Anticipo de Orden de Venta
				ii_rk[1]  = 1		//Origen
				ii_rk[2]  = 2		//nro ov
				ii_rk[3]  = 3		//flag estado
				ii_rk[4]  = 4		//fec registro
				ii_rk[5]  = 5		//monto total
				
				ii_dk[1]  = 1		
				ii_dk[2]  = 2		
				ii_dk[3]  = 3		
				ii_dk[4]  = 4		
				ii_dk[5]  = 5		
				
		 CASE 20    // Anticipo de Orden de Compra	
			
				ii_rk[1] = 1		//Origen
				ii_rk[2] = 2		//nro oc
				ii_rk[3] = 3		//proveedor
				ii_rk[4] = 4		//flag estado
				ii_rk[5] = 5		//fec registro
				ii_rk[6] = 6		//cod moneda
				ii_rk[7] = 7		//monto total							
				
				ii_dk[1] = 1		
				ii_dk[2] = 2		
				ii_dk[3] = 3		
				ii_dk[4] = 4		
				ii_dk[5] = 5		
				ii_dk[6] = 6		
				ii_dk[7] = 7		
				
		 CASE 21,26    // Anticipo de Orden de Servicio
			
				ii_rk[1] = 1		//Origen
				ii_rk[2] = 2		//nro os
				ii_rk[3] = 3		//proveedor
				ii_rk[4] = 4		//flag estado
				ii_rk[5] = 5		//fec registro
				ii_rk[6] = 6		//cod moneda
				ii_rk[7] = 7		//monto total							
				
				ii_dk[1] = 1		
				ii_dk[2] = 2		
				ii_dk[3] = 3		
				ii_dk[4] = 4		
				ii_dk[5] = 5		
				ii_dk[6] = 6		
				ii_dk[7] = 7						
				
		 CASE 22    // Programación de pagos
			
				ii_rk[1] = 1	//cod_relacion	
				ii_rk[2] = 2	//nom_proveedor
				ii_rk[3] = 3	//tipo_doc			
				ii_rk[4] = 4	//nro_doc	
				ii_rk[5] = 5	//cod_moneda	
				ii_rk[6] = 6	//saldo_sol	
				ii_rk[7] = 7	//saldo_dol
				ii_rk[8] = 8	//factor
				ii_rk[9] = 9	//flag_tabla	
				ii_rk[10] = 10	//tcambio
				ii_rk[11] = 11	//flag_provisionado
				
				ii_dk[1]  = 1	//cod_relacion	
				ii_dk[2]  = 2	//nom_proveedor
				ii_dk[3]  = 3	//tipo_doc			
				ii_dk[4]  = 4	//nro_doc	
				ii_dk[5]  = 5	//cod_moneda	
				ii_dk[6]  = 6	//saldo_sol	
				ii_dk[7]  = 7	//saldo_dol
				ii_dk[8]  = 8	//factor
				ii_dk[9]  = 9	//flag_tabla
				ii_dk[10] = 10	//tcambio
				ii_dk[11] = 11	//flag_provisionado
				
				
		 CASE 23    // Planilla de cobranza
			
				ii_rk[1]  = 1	//cod_relacion	
				ii_rk[2]  = 2	//nom_proveedor
				ii_rk[3]  = 3	//tipo_doc			
				ii_rk[4]  = 4	//nro_doc	
				ii_rk[5]  = 5	//cod_moneda	
				ii_rk[6]  = 6	//saldo_sol	
				ii_rk[7]  = 7	//saldo_dol
				ii_rk[8]  = 8	//factor
				ii_rk[9]  = 9	//flag_tabla	
				ii_rk[10] = 10	//flag_provisionado
				ii_rk[11] = 11	//nro_deposito
				ii_rk[12] = 12	//fecha_deposito
				ii_rk[13] = 13	//referencia
				
				ii_dk[1] = 1	//cod_relacion	
				ii_dk[2] = 2	//nom_proveedor
				ii_dk[3] = 3	//tipo_doc			
				ii_dk[4] = 4	//nro_doc	
				ii_dk[5] = 5	//cod_moneda	
				ii_dk[6] = 6	//saldo_sol	
				ii_dk[7] = 7	//saldo_dol
				ii_dk[8] = 8	//factor
				ii_dk[9] = 9	//flag_tabla

				ii_dk[10] = 10	//flag_provisionado
				ii_dk[11] = 11	//nro_deposito
				ii_dk[12] = 12	//fecha_deposito
				ii_rk[13] = 13	//referencia
				
END CHOOSE
end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

idw_det.SetRedraw(false)
idw_det.Sort()
idw_det.GroupCalc()
idw_det.SetRedraw(true)
end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)

FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.SetRedraw(false)
idw_det.Sort()
idw_det.GroupCalc()
idw_det.ScrollToRow(ll_row)
idw_det.SetRedraw(true)



end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_lista
integer x = 530
integer y = 428
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista
integer x = 530
integer y = 676
end type

type cb_transferir from commandbutton within w_abc_seleccion_lista
integer x = 2953
integer width = 297
integer height = 84
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

event clicked;Long    	ll_inicio,ll_found = 0,ll_row,ll_item,ll_row_count,ll_factor
String  	ls_tipo_doc       ,ls_nro_doc      ,ls_let_x_pag ,ls_doc_sol_giro ,ls_flag_edit   ,&
		  	ls_expresion      ,ls_doc_oc       ,ls_doc_os    ,ls_origen       ,ls_flag_estado ,&
		  	ls_flag_estado_og ,ls_cod_relacion ,ls_cod_moneda,&
		  	ls_tipo_mov       ,ls_flag_tabla 	 ,ls_flag_provisionado	
Integer 	li_item,li_nro_sol_pend,li_nro_max
Decimal 	ldc_importe,ldc_importe_cab,ldc_importe_det,ldc_saldo,ldc_saldo_sol,ldc_saldo_dol,&
			ldc_imp_total	

dw_2.Accepttext()

CHOOSE CASE istr_param.opcion
	CASE 1,2,24 //CANJE DE LETRA x pagar y cobrar
		of_opcion1 ()			

				
		 CASE 6		/*Aplicación de Documentos*/		
				FOR ll_inicio = 1 TO dw_2.Rowcount()
			   	 istr_param.bret = TRUE
					 ll_row = istr_param.dw_m.InsertRow(0)
					 ll_row_count = istr_param.dw_m.Rowcount()

					 IF ll_row_count = 1 THEN 
						 ll_item = 0
					 ELSE
					    ll_item = istr_param.dw_m.Getitemnumber(ll_row_count - 1,'item')
					 END IF

					 
					 ll_item = ll_item + 1
					 
					 
					 istr_param.dw_m.object.item            	[ll_row] = ll_item
					 istr_param.dw_m.object.cod_relacion    	[ll_row] = istr_param.string1
					 istr_param.dw_m.object.origen_doc      	[ll_row] = dw_2.object.origen      [ll_inicio]
				    istr_param.dw_m.object.tipo_doc        	[ll_row] = dw_2.object.tipo_doc    [ll_inicio]
			    	 istr_param.dw_m.object.nro_doc         	[ll_row] = dw_2.object.nro_doc     [ll_inicio]
				    istr_param.dw_m.object.importe         	[ll_row] = dw_2.object.total_pagar [ll_inicio]
				    istr_param.dw_m.object.tasa_cambio     	[ll_row] = istr_param.db2
				    istr_param.dw_m.object.cod_moneda_doc  	[ll_row] = dw_2.object.cod_moneda  [ll_inicio]
				    istr_param.dw_m.object.cod_moneda		 	[ll_row] = istr_param.string2
				    istr_param.dw_m.object.flab_tabor		 	[ll_row] = dw_2.object.flag_tabla  [ll_inicio]
				    istr_param.dw_m.object.flag_cxp	     		[ll_row] = dw_2.object.flag_cxp    [ll_inicio]
					 istr_param.dw_m.object.flag_flujo_caja 	[ll_row] = '1'
				NEXT
				
				
		 CASE	8 /*Pre Liquidacion de Orden de Giro*/	
				wf_insert_det_liq ()
				
				
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
						 istr_param.bret = TRUE
						 ll_row = istr_param.dw_m.InsertRow(0) 
					    IF istr_param.dw_m.Rowcount()  > 1 THEN
							 ll_item = istr_param.dw_m.object.item	[istr_param.dw_m.Rowcount() - 1] + 1
						 ELSE
							 ll_item = 1
						 END IF

						 istr_param.dw_m.object.item		       [ll_row] = ll_item
						 istr_param.dw_m.object.proveedor       [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
 					    istr_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
						 istr_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc       [ll_inicio]
						 istr_param.dw_m.object.fecha_doc       [ll_row] = dw_2.object.fecha_emision [ll_inicio]
						 istr_param.dw_m.object.cod_moneda      [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
						 istr_param.dw_m.object.cod_moneda_cab  [ll_row] = istr_param.string2
					    istr_param.dw_m.object.tasa_cambio     [ll_row] = dw_2.object.tasa_cambio   [ll_inicio]
						 istr_param.dw_m.object.importe         [ll_row] = dw_2.object.saldo			  [ll_inicio]
						 istr_param.dw_m.object.descripcion     [ll_row] = dw_2.object.descripcion   [ll_inicio]	 	
						 istr_param.dw_m.object.nom_proveedor	 [ll_row] = dw_2.object.nombre		  [ll_inicio]	
						 istr_param.dw_m.object.cencos          [ll_row] = dw_2.object.cencos        [ll_inicio]
				 	    istr_param.dw_m.object.cnta_prsp       [ll_row] = dw_2.object.cnta_prsp     [ll_inicio]						 
						 istr_param.dw_m.Object.flag_tipo_gasto [ll_row] = 'P'
					 END IF
					 
				NEXT
				
		 CASE	15 //CARTERA DE PAGOS
				/*inserta registro en cartera de pagos*/
				of_opcion15 ()
		
		CASE	25 //APLICACION DE DOCUMENTOS
				/*inserta registro en cartera de pagos*/
				of_opcion25 ()
				
		 CASE 16 	//Liquidaciones de pesca y pago
				of_procesa_liq_opc_16()
	
		 CASE 17	// Detracciones
				of_procesa_det_opc_17()
				
		 CASE 18 //CARTERA DE COBROS
			   /*inserta registro en cartera de cobros*/	
			   of_opcion18 ()	
			  
		 CASE 19 //aNTICIPO DE ORDEN DE VENTA
			   /*inserta orden de venta*/	
			   wf_insert_ov ()	
				
		 CASE 20 //ANTICIPO DE ORDEN DE COMPRA
				/*inserta orden de compra*/	
			   wf_insert_oc ()			
				
		 CASE 21 //ANTICIPO DE ORDEN DE SERVICIO
				/*inserta orden de Servicio*/	
			   wf_insert_os ()			
		 CASE 22 //PROGRAMACION DE PAGOS
				/*inserta Detalle de Programacion de Pagos*/	
			   wf_insert_pp()
		 CASE 23 //PLANILLA DE COBRANZA
				/*inserta detalle de planilla de cobranza*/
			   wf_insert_pc()
		 CASE 26 //LIQUIDACIONES POR EXPORTACIONES
				/*inserta orden de VENTA*/	
			   wf_insert_ov_ref()
				
END CHOOSE

Closewithreturn(parent,istr_param)
end event

type uo_search from n_cst_search within w_abc_seleccion_lista
event destroy ( )
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

