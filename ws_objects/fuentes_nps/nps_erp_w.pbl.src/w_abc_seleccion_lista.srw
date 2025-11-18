$PBExportHeader$w_abc_seleccion_lista.srw
forward
global type w_abc_seleccion_lista from w_abc_list
end type
type cb_1 from commandbutton within w_abc_seleccion_lista
end type
end forward

global type w_abc_seleccion_lista from w_abc_list
integer x = 50
integer width = 3447
integer height = 1896
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
cb_1 cb_1
end type
global w_abc_seleccion_lista w_abc_seleccion_lista

type variables
String is_tipo,is_soles,is_dolares
str_parametros is_param
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
public subroutine wf_insert_cpagos ()
public subroutine wf_insert_ccobros ()
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
public subroutine of_opcion27 ()
public function long of_verifica_doc (string as_tipo_doc, string as_nro_doc)
end prototypes

public function long wf_verifica_doc (string as_origen_doc, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_doc = '+"'"+as_origen_doc+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_ce (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'proveedor = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

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
		is_param.bret = TRUE
		ll_row = is_param.dw_m.InsertRow(0)	
		
		// Inserto los registros en el detalle de la liquidacion de pagos
		 wf_insert_liquidacion (ll_row,ll_inicio,ls_flag_tabla)
	END IF	 		
	
Next
end subroutine

public subroutine of_insert_detraccion (long al_item, long al_row, long al_inicio);String ls_soles,ls_dolares, ls_observacion

f_monedas( ls_soles, ls_dolares )

is_param.dw_m.object.item 			   [al_row] = al_item
is_param.dw_m.object.origen_doc_ref [al_row] = dw_2.object.origen     		[al_inicio]
is_param.dw_m.object.tipo_doc_ref   [al_row] = is_param.string3
is_param.dw_m.object.nro_doc_ref	   [al_row] = dw_2.object.nro_detraccion 	[al_inicio]
is_param.dw_m.object.cod_moneda     [al_row] = dw_2.object.cod_moneda 		[al_inicio]
is_param.dw_m.object.flag_tabla	   [al_row] = dw_2.object.flag_tabla 		[al_inicio]

ls_observacion = 'Detraccion x Documento: ' + dw_2.object.tipo_doc[al_inicio] + ' - ' &
		+ dw_2.object.nro_doc[al_inicio]
is_param.dw_m.object.concepto			[al_row] = ls_observacion

IF is_param.string2 = ls_soles THEN
	is_param.dw_m.object.importe_liq [al_row] = dw_2.object.sldo_sol  [al_inicio]
ELSE
   is_param.dw_m.object.importe_liq [al_row] = dw_2.object.saldo_dol [al_inicio]
END IF

IF dw_2.object.flag_debhab [al_inicio] = 'H'  THEN
	is_param.dw_m.object.flag_cxp [al_row] = '+'
ELSE
	is_param.dw_m.object.flag_cxp [al_row] = '-'
END IF
end subroutine

public subroutine of_procesa_det_opc_17 ();string		ls_tipo_doc, ls_nro_doc, ls_origen, ls_expresion
Long			ll_inicio, ll_row, ll_found
u_dw_abc		ldw_detail

ldw_detail = is_param.dw_m

For ll_inicio = 1 TO dw_2.Rowcount()
	ls_origen		 = dw_2.object.origen 			[ll_inicio]
	ls_tipo_doc 	 = is_param.string3
	ls_nro_doc	 	 = dw_2.object.nro_detraccion [ll_inicio]
		 
	ls_expresion = "origen_doc_ref = '" + ls_origen + "' AND tipo_doc_ref = '" &
				 + ls_tipo_doc + "' AND nro_doc_ref = '" + ls_nro_doc + "'"

	ll_found 	 = ldw_detail.Find(ls_expresion, 1, ldw_detail.Rowcount())

	IF ll_found > 0 THEN
		Messagebox('Aviso','Documento '+Trim(ls_tipo_doc) + ' ' + Trim(ls_nro_doc) &
					+' ya Ha sido Registrado , Verifique!')
	ELSE	 
		is_param.bret = TRUE
		ll_row = ldw_detail.event dynamic ue_insert()
		
		if ll_row < 0 then continue
		
		this.of_insert_detraccion( ll_row, ll_row, ll_inicio )
		
	END IF	 		
Next
end subroutine

public function long wf_verifica_doc (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_doc = '+"'"+as_origen_doc+"'"+' AND cod_relacion ='+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_doc_ref (string as_origen_doc, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_ref = '+"'"+as_origen_doc+"'"+' AND tipo_ref = '+"'"+as_tipo_doc+"'"+' AND '+'nro_ref ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_det_liq (string as_proveedor, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'proveedor = '+"'"+as_proveedor+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


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
		 ll_row = is_param.dw_m.InsertRow(0)
		 /*INSERT PRE*/
		 ll_rowcount = is_param.dw_m.RowCount()	
	 
  		 IF ll_row = 1 THEN 
		    ll_item = 0
		 ELSE
		    ll_item = is_param.dw_m.Getitemnumber(ll_rowcount - 1,"item")
		 END IF

		 is_param.dw_m.SetItem(ll_row, "item", ll_item + 1)  
		

		 /**/
	    is_param.bret = TRUE	 
		 is_param.dw_m.object.proveedor         [ll_row] = dw_2.object.cod_relacion      [ll_inicio] 
		 is_param.dw_m.object.tipo_doc          [ll_row] = dw_2.object.tipo_doc	         [ll_inicio]
		 is_param.dw_m.object.nro_doc           [ll_row] = dw_2.object.nro_doc           [ll_inicio]
		 is_param.dw_m.object.fecha_doc	       [ll_row] = dw_2.object.fecha_doc	      [ll_inicio]
	 	 is_param.dw_m.object.cod_moneda        [ll_row] = dw_2.object.cod_moneda	      [ll_inicio]
		 is_param.dw_m.object.importe           [ll_row] = dw_2.object.importe		      [ll_inicio]	  
		 is_param.dw_m.object.flag_provisionado [ll_row] = dw_2.object.flag_provisionado [ll_inicio]
		 is_param.dw_m.object.tasa_cambio		 [ll_row] = dw_2.object.tasa_cambio		   [ll_inicio]
		 is_param.dw_m.object.descripcion		 [ll_row] = dw_2.object.descripcion		   [ll_inicio]
		 is_param.dw_m.object.cod_moneda_cab	 [ll_row] = is_param.string2		 
		 is_param.dw_m.object.cencos				 [ll_row] = dw_2.object.cencos		   	[ll_inicio]
 		 is_param.dw_m.object.cnta_prsp			 [ll_row] = dw_2.object.cnta_prsp		   [ll_inicio]
	 ELSE	 
		 //DOCUMENTO YA FUE CONSIDERADO		 
		 Messagebox('Aviso','Documento ya fue Considerado , Verifique!')
	 END IF	 
	 
	 
Next	



end subroutine

public subroutine wf_insert_cpagos ();String  ls_doc_sol_giro,ls_origen,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ls_cod_moneda,&
		  ls_null,ls_matriz,ls_flag_prov,ls_flag_tabla,ls_flag_ctrl_reg,ls_soles,ls_dolares,&
		  ls_flag_estado_og 	,ls_doc_detrac, ls_nro_detracción
Long    ll_inicio,ll_found,ll_row,ll_factor,ll_rowcount,ll_item,ll_count
Integer li_nro_sol_pend,li_nro_max
Decimal {2} ldc_aplicado_sol,ldc_aplicado_dol, ldc_Importe_detr,ldc_monto_adeuda

	  
SELECT doc_sol_giro ,doc_detrac_cp INTO :ls_doc_sol_giro,:ls_doc_detrac FROM finparam WHERE reckey = '1' ;

//moneda
select cod_soles,cod_dolares into :ls_soles,:ls_dolares from logparam where reckey = '1' ;


SetNull(ls_null)			  

For ll_inicio = 1 to dw_2.Rowcount()
    ls_origen   	  	= dw_2.object.origen             [ll_inicio]
	 ls_tipo_doc 	  	= dw_2.object.tipo_doc           [ll_inicio]
	 ls_nro_doc  	  	= dw_2.object.nro_doc            [ll_inicio]
	 ls_cod_relacion 	= dw_2.object.cod_relacion       [ll_inicio]
    ls_cod_moneda		= dw_2.object.cod_moneda         [ll_inicio] 
	 ls_flag_prov		= dw_2.object.flag_provisionado  [ll_inicio]
	 ls_flag_tabla		= dw_2.object.flag_tabla   	   [ll_inicio]
	 ll_factor			= dw_2.object.factor   		      [ll_inicio] 
	 ldc_aplicado_sol = 0.00
	 ldc_aplicado_dol	= 0.00
	
	 IF ll_factor = -1 THEN
		 ldc_monto_adeuda = f_monto_adeuda_sunat(ls_cod_relacion)
		 if ldc_monto_adeuda> 0 then
			 Openwithparm(w_msg_deuda_tributaria,String(ldc_monto_adeuda))
		 end if
	 END IF
	 
	 if ls_flag_prov = 'R' and is_param.opcion = 15 AND ls_flag_tabla = '3'    THEN //VERIFICAR SI CONTIENE ANTICIPOS
	 	 if wf_verifica_anticipos(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) = false then
			 GOTO SALIDA	
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
	 
	 
	 IF ls_tipo_doc = ls_doc_sol_giro  AND is_param.tipo = '1CP' THEN
		 //VERIFICAR SI SOLICITUD DE GIRO ESTA CANCELADA	
		 select nvl(flag_estado,'') into :ls_flag_estado_og 
		   from solicitud_giro 
		  where nro_solicitud = :ls_nro_doc ;
		  			
		 
		 IF ls_flag_estado_og  <> '5' THEN
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
					
	 ll_found = wf_verifica_doc (ls_origen,ls_cod_relacion,ls_tipo_doc,ls_nro_doc)				
	 
	 IF ll_found = 0 THEN 
	    ll_row = is_param.dw_m.InsertRow (0)
	     
		 /*INSERT PRE*/
		 ll_rowcount = is_param.dw_m.RowCount()

		 IF ll_row = 1 THEN 
			 ll_item = 0
		 ELSE
	  	 	 ll_item = is_param.dw_m.Getitemnumber(ll_rowcount - 1,"item")
		 END IF

		 is_param.dw_m.SetItem(ll_row, "item", ll_item + 1)  
		 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'
		 /**/


 		 is_param.bret = TRUE
		 is_param.dw_m.object.cod_relacion      [ll_row] = ls_cod_relacion
		 is_param.dw_m.object.origen_doc        [ll_row] = ls_origen
		 is_param.dw_m.object.tipo_doc          [ll_row] = ls_tipo_doc
       is_param.dw_m.object.nro_doc           [ll_row] = ls_nro_doc
       is_param.dw_m.object.importe           [ll_row] = dw_2.object.importe	      [ll_inicio]
		 is_param.dw_m.object.tasa_cambio       [ll_row] = is_param.db2
		 is_param.dw_m.object.cod_moneda_cab    [ll_row] = is_param.string2
		 is_param.dw_m.object.cod_moneda        [ll_row] = ls_cod_moneda
		 is_param.dw_m.object.flab_tabor		    [ll_row] = ls_flag_tabla
		 is_param.dw_m.object.confin			    [ll_row] = is_param.string3
		 is_param.dw_m.object.nom_proveedor	    [ll_row] = dw_2.object.nom_proveedor [ll_inicio]
		 is_param.dw_m.object.flag_provisionado [ll_row] = ls_flag_prov //flag provisionado
		 is_param.dw_m.object.soles				 [ll_row] = ls_soles
		 is_param.dw_m.object.dolares 			 [ll_row] = ls_dolares
		 is_param.dw_m.object.flag_aplic_comp	 [ll_row] = '0'		//editable

		 

       //para caso de la detraccion el tipo de cambio en el detalle debe ser editable
		 //cambio realizado el dia 12/05/2005
		 if ls_tipo_doc = ls_doc_detrac and ll_factor = -1 then 
			 is_param.dw_m.object.t_detrac    [ll_row] = ls_null
			 is_param.dw_m.object.tasa_cambio [ll_row] = dw_2.object.tasa_cambio [ll_inicio]
		 else
			 is_param.dw_m.object.t_detrac [ll_row] =	'1'
		 end if
		 
		 //para caso de orden giro importe no debe ser editable 
		 //en ese campo debe ser nulo
		 
		 //BUSCO MATRIZ
		 SELECT matriz_cntbl into :ls_matriz from concepto_financiero where confin = :is_param.string3 ;
		 
		 is_param.dw_m.object.matriz_cntbl		 [ll_row] = ls_matriz
		 
		 
		 
		 
		 IF ls_tipo_doc = ls_doc_sol_giro THEN
			 is_param.dw_m.object.t_tipdoc 		    [ll_row] = ls_null
		 ELSE
			 //verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
	       select count(*) into :ll_count from doc_grupo_relacion dg 
			  where (dg.grupo    = 'C2'         ) and
			        (dg.tipo_doc = :ls_tipo_doc ) ;
			 
			 if (ll_count > 0 AND ls_flag_prov = 'D' AND ll_factor = -1 AND ls_flag_tabla = '3') then
		       select cp.flag_control_reg into :ls_flag_ctrl_reg
           	  from cntas_pagar cp
	          where (cp.cod_relacion = :ls_cod_relacion) and
   	             (cp.tipo_doc     = :ls_tipo_doc    ) and
      	          (cp.nro_doc      = :ls_nro_doc     ) ;
			 	 
				 if ls_flag_ctrl_reg = '1' then
					 is_param.dw_m.object.t_tipdoc [ll_row] = ls_null
				 else
					 is_param.dw_m.object.t_tipdoc [ll_row] = '1'	
				 end if
			 else
				 is_param.dw_m.object.t_tipdoc [ll_row] = '1'	
			 end if				 
			    
		 END IF				
		 
		 
		 
		 
		 //colocar factor
		 if ll_factor = -1 then
			 is_param.dw_m.object.factor [ll_row] = 1
		 else
			 is_param.dw_m.object.factor [ll_row] = -1
       end if
		 
		 //bloqueo de campos....
		 is_param.dw_m.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("flag_referencia.Protect ='1~tIf(IsNull(flag_doc),1,0)'")					 
		 is_param.dw_m.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("cencos.Protect      ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
		 is_param.dw_m.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")		
		 is_param.dw_m.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")		
		 is_param.dw_m.Modify("tasa_cambio.Protect ='1~tIf(IsNull(t_detrac),0,1)'")
		 
		 //no marcar para flijo de caja
		 if ls_tipo_doc = ls_doc_detrac and ll_factor = 1 then 
		 	 is_param.dw_m.object.flag_flujo_caja [ll_row] = '0'
	 	 end if
    END IF
					
					
	 SALIDA:				
Next
			  
end subroutine

public subroutine wf_insert_ccobros ();Long   ll_inicio,ll_factor,ll_found,ll_row,ll_Rowcount,ll_item,ll_count
String ls_origen,ls_tipo_doc,ls_nro_doc     ,ls_cod_relacion,ls_cod_moneda,&
		 ls_matriz,ls_null    ,ls_doc_sol_giro,ls_flag_prov   ,ls_flag_tabla,&
		 ls_flag_ctrl_reg		 ,ls_soles		  ,ls_dolares		,ls_flag_estado, &
		 ls_nro_detracción
Dec    ldc_Importe_detr
Decimal {2} ldc_monto_adeuda

//solicitud giro
select doc_sol_giro into :ls_doc_sol_giro from finparam where (reckey = '1');

//moneda
select cod_soles,cod_dolares into :ls_soles,:ls_dolares from logparam where reckey = '1' ;

//seteo null
SetNull(ls_null)

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
//	 //DEUDA TRIBUTARIA
	 IF ll_factor = -1 THEN
		 ldc_monto_adeuda = f_monto_adeuda_sunat(ls_cod_relacion)
		 if ldc_monto_adeuda> 0 then
			 Openwithparm(w_msg_deuda_tributaria,String(ldc_monto_adeuda))
		 end if
	 END IF
	 
	 IF ll_found = 0 THEN 
	    ll_row = is_param.dw_m.InsertRow (0)
	     
		 /*INSERT PRE*/
		 ll_rowcount = is_param.dw_m.RowCount()

		 IF ll_row = 1 THEN 
			 ll_item = 0
		 ELSE
	  	 	 ll_item = is_param.dw_m.Getitemnumber(ll_rowcount - 1,"item")
		 END IF

		 is_param.dw_m.SetItem(ll_row, "item", ll_item + 1)  
		 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'
		 /**/
		 ll_factor = dw_2.object.factor [ll_inicio]	
		 

 		 is_param.bret = TRUE
		 is_param.dw_m.object.cod_relacion      [ll_row] = dw_2.object.cod_relacion [ll_inicio]
		 is_param.dw_m.object.origen_doc        [ll_row] = ls_origen
		 is_param.dw_m.object.tipo_doc          [ll_row] = ls_tipo_doc
       is_param.dw_m.object.nro_doc           [ll_row] = ls_nro_doc
       is_param.dw_m.object.importe           [ll_row] = dw_2.object.importe	    [ll_inicio]
		 is_param.dw_m.object.tasa_cambio       [ll_row] = is_param.db2
		 is_param.dw_m.object.cod_moneda_cab    [ll_row] = is_param.string2
		 is_param.dw_m.object.cod_moneda        [ll_row] = ls_cod_moneda
		 is_param.dw_m.object.flab_tabor		    [ll_row] = dw_2.object.flag_tabla   [ll_inicio]
		 is_param.dw_m.object.confin			    [ll_row] = is_param.string3
		 is_param.dw_m.object.factor			    [ll_row] = dw_2.object.factor		 [ll_inicio]	
		 is_param.dw_m.object.nom_proveedor     [ll_row] = dw_2.object.nom_proveedor[ll_inicio]	
		 is_param.dw_m.object.flag_provisionado [ll_row] = ls_flag_prov
		 is_param.dw_m.object.soles				 [ll_row] = ls_soles
		 is_param.dw_m.object.dolares				 [ll_row] = ls_dolares
		 is_param.dw_m.object.flag_aplic_comp	 [ll_row] = '0'			//compesacion
		 
		 //BUSCO MATRIZ
		 SELECT matriz_cntbl into :ls_matriz from concepto_financiero where confin = :is_param.string3 ;
		 
		 is_param.dw_m.object.matriz_cntbl		 [ll_row] = ls_matriz

		 
		 
       //para caso de orden giro importe no debe ser editable 
		 //en ese campo debe ser nulo
		 IF ls_tipo_doc = ls_doc_sol_giro THEN
			 is_param.dw_m.object.t_tipdoc 		    [ll_row] = ls_null
			 
			 //colocar que va ser editable cuando va ser una devolucion
			 select flag_estado into :ls_flag_estado from solicitud_giro 
			  where nro_solicitud = :ls_nro_doc ;
			  
			 if ll_factor = 1 and ls_flag_estado = '5' then
				 is_param.dw_m.object.t_tipdoc [ll_row] = '1'
			 end if	
			 
		 ELSE
			 //verificar flag provisionado,verificar su flab tabor,si pertence al grupo,y factor es = 1
	       select count(*) into :ll_count from doc_grupo_relacion dg 
			  where (dg.grupo    = 'C1'         ) and
			        (dg.tipo_doc = :ls_tipo_doc ) ;
			 
			 if (ll_count > 0 AND ls_flag_prov = 'D' AND ll_factor = 1 AND ls_flag_tabla = '1') then
		       select cc.flag_control_reg into :ls_flag_ctrl_reg
               from cntas_cobrar cc
	           where (cc.cod_relacion = :ls_cod_relacion) and
   	              (cc.tipo_doc     = :ls_tipo_doc    ) and
      	           (cc.nro_doc      = :ls_nro_doc     ) ;
			 	 
				 if ls_flag_ctrl_reg = '1' then
					 is_param.dw_m.object.t_tipdoc [ll_row] = ls_null
				 else
					 is_param.dw_m.object.t_tipdoc [ll_row] = '1'	
				 end if
			 else
				 is_param.dw_m.object.t_tipdoc [ll_row] = '1'	
			 end if				 
			    
		 END IF				
		 

		 


						
  
		 
		 //bloqueo de campos....
		 is_param.dw_m.Modify("tipo_doc.Protect    ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("nro_doc.Protect     ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("cod_relacion.Protect='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("cencos.Protect      ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_doc),1,0)'")			
		 is_param.dw_m.Modify("cencos.Protect      ='1~tIf(IsNull(flag_partida),1,0)'")			
		 is_param.dw_m.Modify("cnta_prsp.Protect   ='1~tIf(IsNull(flag_partida),1,0)'")		
		 is_param.dw_m.Modify("importe.Protect     ='1~tIf(IsNull(t_tipdoc),1,0)'")		
		 
    END IF
	 
//SALIDA:		
	
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
	 
	 is_param.bret = TRUE
	 ll_row = is_param.dw_m.InsertRow (0)
	 is_param.dw_m.object.tipo_mov	[ll_row] = 'C'
	 is_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 is_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_ov
	 is_param.dw_m.object.nro_ref    [ll_row] = ls_nro_ov
	 is_param.dw_m.object.flab_tabor [ll_row] = '9'
	 
Next	
end subroutine

public subroutine wf_insert_oc ();Long   ll_inicio,ll_row
String ls_doc_oc,ls_cod_origen,ls_nro_oc

select doc_oc into :ls_doc_oc from logparam where reckey = '1' ;

dw_2.Accepttext()


IF dw_2.Rowcount() > 1 THEN
	Messagebox('Aviso','Solamente puede Seleccionar Una Orden de Compra ,Verfique!')
	RETURN
END IF

For ll_inicio = 1 TO dw_2.Rowcount()

	 
	 ls_cod_origen = dw_2.object.cod_origen [ll_inicio] 
	 ls_nro_oc		= dw_2.object.nro_oc		 [ll_inicio]
	 
	 is_param.bret = TRUE
	 ll_row = is_param.dw_m.InsertRow (0)
	 is_param.dw_m.object.tipo_mov	[ll_row] = 'R'
	 is_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 is_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_oc
	 is_param.dw_m.object.nro_ref    [ll_row] = ls_nro_oc
	 is_param.dw_m.object.flab_tabor [ll_row] = '7'
	 
Next	
end subroutine

public subroutine wf_insert_os ();Long   ll_inicio,ll_row
String ls_doc_os,ls_cod_origen,ls_nro_os

select doc_os into :ls_doc_os from logparam where reckey = '1' ;

dw_2.Accepttext()


IF dw_2.Rowcount() > 1 THEN
	Messagebox('Aviso','Solamente puede Seleccionar Una Orden de Servicio ,Verfique!')
	RETURN
END IF

For ll_inicio = 1 TO dw_2.Rowcount()

	 
	 ls_cod_origen = dw_2.object.cod_origen [ll_inicio] 
	 ls_nro_os		= dw_2.object.nro_os		 [ll_inicio]
	 
	 is_param.bret = TRUE
	 ll_row = is_param.dw_m.InsertRow (0)
	 is_param.dw_m.object.tipo_mov	[ll_row] = 'R'
	 is_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 is_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_os
	 is_param.dw_m.object.nro_ref    [ll_row] = ls_nro_os
	 is_param.dw_m.object.flab_tabor [ll_row] = '8'
	 
Next	
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
	
	 ll_row = is_param.dw_m.InsertRow(0)
	 is_param.bret = TRUE
	 
	 
	 /*Asignacion de item_doc*/
	 ll_row_count = is_param.dw_m.RowCount()
	 
	 IF ll_row_count = 1 THEN 
		 li_item = 0
	 ELSE
		 li_item = is_param.dw_m.Getitemnumber(ll_row,"item_max")
	 END IF
	 
	 is_param.dw_m.SetItem(ll_row, "item_doc", li_item + 1)  	 
	 
	 /***********************/
	 
	 
	 IF ls_flag_tabla = '1' THEN //Cuenta x Cobrar
		 is_param.dw_m.object.doc_cnta_cobrar [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 is_param.dw_m.object.nro_cnta_cobrar [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 
	 ELSEIF ls_flag_tabla = '3' THEN //Cuenta x Pagar
		 is_param.dw_m.object.doc_cnta_pagar  [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 is_param.dw_m.object.nro_cnta_pagar  [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 END IF	

	 is_param.dw_m.object.prov_cnta_pagar 			 [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
	 is_param.dw_m.object.proveedor_nom_proveedor [ll_row] = dw_2.object.nom_proveedor [ll_inicio]
	 is_param.dw_m.object.cod_moneda		  			 [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
	 is_param.dw_m.object.importe			  			 [ll_row] = ldc_importe
	 is_param.dw_m.object.factor			  			 [ll_row] = ll_factor
	 is_param.dw_m.object.flag_tabla		  			 [ll_row] = ls_flag_tabla
 	 is_param.dw_m.object.flag_detrac				 [ll_row] = '0'
 	 is_param.dw_m.object.soles						 [ll_row] = ls_soles
 	 is_param.dw_m.object.dolares						 [ll_row] = ls_dolares
    is_param.dw_m.object.item							 [ll_row] = is_param.long1
	 is_param.dw_m.object.confin						 [ll_row] = is_param.string2
	 
	 SALIDA:
Next	 


end subroutine

public function long wf_verifica_doc_cc_liq (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_doc_ref = '+"'"+as_origen_doc+"'"+' AND cxp_cod_rel = '+"'"+as_cod_relacion+"'"+' AND cxc_tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'cxc_nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_verifica_doc_cp_liq (string as_origen_doc, string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'origen_doc_ref = '+"'"+as_origen_doc+"'"+' AND cxp_cod_rel = '+"'"+as_cod_relacion+"'"+' AND cxp_tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'cxp_nro_doc ='+"'"+as_nro_doc+"'"


ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_liquidacion (long al_row, long al_row_det, string as_flag_tabla);Long   ll_rowcount,ll_item,ll_factor
String ls_cod_moneda
is_param.dw_m.Accepttext()


ls_cod_moneda = dw_2.object.cod_moneda [al_row_det]
ll_factor	  = dw_2.object.factor		[al_row_det]



/*INSERT PRE*/
ll_rowcount = is_param.dw_m.RowCount()

IF al_row = 1 THEN 
	ll_item = 0
ELSE
   ll_item = is_param.dw_m.Getitemnumber(ll_rowcount - 1,"item")
END IF


is_param.dw_m.SetItem(al_row, "item", ll_item + 1)  

/**************************************************/
/*Colocar un factor de acuerdo a tipo de documento*/
/**************************************************/
IF TRIM(is_param.string4) = 'LQP' THEN //si es LIQUIDACION X PAGAR invertir factor

	
	if ll_factor = 1 then
		ll_factor = -1
	else
		ll_factor = 1
	end if

	
END IF







is_param.dw_m.object.factor_signo            [al_row] = ll_factor
is_param.dw_m.object.origen_doc_ref	         [al_row] = dw_2.object.origen		    [al_row_det]		 		
is_param.dw_m.object.cod_moneda		         [al_row] = dw_2.object.cod_moneda    [al_row_det]		
is_param.dw_m.object.confin      	         [al_row] = is_param.string3
is_param.dw_m.object.matriz_cntbl  	         [al_row] = is_param.string5
is_param.dw_m.object.cxp_cod_rel		         [al_row] = dw_2.object.cod_relacion  [al_row_det]
is_param.dw_m.object.flag_replicacion        [al_row] = '1'
is_param.dw_m.object.moneda_cab		         [al_row] = is_param.string2
is_param.dw_m.object.tasa_cambio		         [al_row] = is_param.db2
is_param.dw_m.object.flag_provisionado		   [al_row] = dw_2.object.flag_provisionado [al_row_det]		 		

is_param.dw_m.object.soles			            [al_row] = is_soles
is_param.dw_m.object.dolares     	         [al_row] = is_dolares
is_param.dw_m.object.proveedor_nom_proveedor	[al_row] = dw_2.object.nom_proveedor [al_row_det]

IF as_flag_tabla = '3' THEN // X PAGAR
	is_param.dw_m.object.cxp_tipo_doc     [al_row] = dw_2.object.tipo_doc [al_row_det]			
	is_param.dw_m.object.cxp_nro_doc		  [al_row] = dw_2.object.nro_doc	 [al_row_det]	
ELSE
	is_param.dw_m.object.cxc_tipo_doc	  [al_row] = dw_2.object.tipo_doc [al_row_det]		
	is_param.dw_m.object.cxc_nro_doc		  [al_row] = dw_2.object.nro_doc	 [al_row_det]	
END IF	



IF ls_cod_moneda = is_soles THEN
	is_param.dw_m.object.importe [al_row] = dw_2.object.sldo_sol  [al_row_det]
ELSE
   is_param.dw_m.object.importe [al_row] = dw_2.object.saldo_dol [al_row_det]
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
	
	 ll_row = is_param.dw_m.InsertRow(0)
	 is_param.bret = TRUE
	 
	 
	 /*Asignacion de item_deposito*/
	 ll_row_count = is_param.dw_m.RowCount()
	 
	 IF ll_row_count = 1 THEN 
		 li_item = 0
	 ELSE
		 li_item = is_param.dw_m.Getitemnumber(ll_row_count - 1,"item")
	 END IF
	 
	 
	 is_param.dw_m.SetItem(ll_row, "item", li_item + 1)  	 
	 
	 /***********************/



	 
	 IF ls_flag_tabla = '1' THEN //Cuenta x Cobrar
		 is_param.dw_m.object.doc_cxc     [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 is_param.dw_m.object.nro_doc_cxc [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 ELSEIF ls_flag_tabla = '3' THEN //Cuenta x Pagar
		 is_param.dw_m.object.doc_cxp     [ll_row] = dw_2.object.tipo_doc [ll_inicio]
		 is_param.dw_m.object.nro_doc_cxp [ll_row] = dw_2.object.nro_doc  [ll_inicio]
	 END IF	

	 is_param.dw_m.object.cod_rel_cxp 			    [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
	 is_param.dw_m.object.proveedor_nom_proveedor [ll_row] = dw_2.object.nom_proveedor [ll_inicio]
	 is_param.dw_m.object.moneda			  			 [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
	 is_param.dw_m.object.importe			  			 [ll_row] = ldc_importe
	 is_param.dw_m.object.factor			  			 [ll_row] = ll_factor
	 is_param.dw_m.object.flag_tabla		  			 [ll_row] = ls_flag_tabla
 	 is_param.dw_m.object.flag_detraccion			 [ll_row] = '0'
 	 is_param.dw_m.object.soles						 [ll_row] = ls_soles
 	 is_param.dw_m.object.dolares						 [ll_row] = ls_dolares
    is_param.dw_m.object.item_deposito				 [ll_row] = is_param.long1
	 is_param.dw_m.object.confin						 [ll_row] = is_param.string2
	 is_param.dw_m.object.flag_provisionado		 [ll_row] = dw_2.object.flag_provisionado [ll_inicio]
	 is_param.dw_m.object.nro_deposito				 [ll_row] = dw_2.object.nro_deposito		[ll_inicio]
	 is_param.dw_m.object.fecha_deposito			 [ll_row] = dw_2.object.fecha_deposito		[ll_inicio]

	  

Next	 
end subroutine

public function boolean wf_verifica_anticipos (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Boolean		lb_ret = TRUE
Decimal {2} ldc_saldo_sol,ldc_saldo_dol


ldc_saldo_sol = 0.00
ldc_saldo_dol = 0.00

DECLARE PB_usp_fin_monto_anticipos PROCEDURE FOR usp_fin_monto_anticipos 
(:as_cod_relacion,:as_tipo_doc,:as_nro_doc);
EXECUTE PB_usp_fin_monto_anticipos ;



IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
	MessageBox("SQL error", SQLCA.SQLErrText)
	
END IF

FETCH PB_usp_fin_monto_anticipos INTO :ldc_saldo_sol,:ldc_saldo_dol ;
CLOSE PB_usp_fin_monto_anticipos ;


IF ldc_saldo_sol > 0 OR ldc_saldo_dol > 0 THEN
	Messagebox('Aviso','Documento : '+Trim(as_cod_relacion)+' '+Trim(as_tipo_doc)+' '+Trim(as_nro_doc)&
							+' Tiene Anticipos Pendientes por Un Saldo en S/.'+ Trim(String(ldc_saldo_sol)) & 
							+' En Dolares $ '+ Trim(String(ldc_saldo_dol)))
	lb_ret = FALSE						
END IF


Return lb_ret
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
	 
	 is_param.bret = TRUE
	 ll_row = is_param.dw_m.InsertRow (0)
	 is_param.dw_m.object.tipo_mov	[ll_row] = 'R'
	 is_param.dw_m.object.origen_ref [ll_row] = ls_cod_origen
	 is_param.dw_m.object.tipo_ref   [ll_row] = ls_doc_ov
	 is_param.dw_m.object.nro_ref    [ll_row] = ls_nro_ov
	 is_param.dw_m.object.flab_tabor [ll_row] = 'A'
	 

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

public subroutine of_opcion27 ();Long   ll_inicio,ll_factor,ll_found,ll_row,ll_Rowcount,ll_item,ll_count
String ls_origen,ls_tipo_doc,ls_nro_doc     ,ls_cod_relacion,ls_cod_moneda,&
		 ls_matriz,ls_null    ,ls_doc_sol_giro,ls_flag_prov   ,ls_flag_tabla,&
		 ls_flag_ctrl_reg		 ,ls_soles		  ,ls_dolares		,ls_flag_estado, &
		 ls_nro_detracción
Dec    ldc_Importe_detr
Decimal {2} ldc_monto_adeuda
u_dw_abc	ldw_detail

//solicitud giro
select doc_sol_giro into :ls_doc_sol_giro from finparam where (reckey = '1');

//moneda
select cod_soles,cod_dolares into :ls_soles,:ls_dolares from logparam where reckey = '1' ;

//seteo null
SetNull(ls_null)

ldw_detail = is_param.dw_d

For ll_inicio = 1 to dw_2.Rowcount()
	 ls_tipo_doc 	  	= dw_2.object.tipo_doc          [ll_inicio]
	 ls_nro_doc  	  	= dw_2.object.nro_doc           [ll_inicio]
	 ls_cod_relacion 	= dw_2.object.cod_relacion      [ll_inicio]
    ls_cod_moneda		= dw_2.object.cod_moneda        [ll_inicio] 
	 ll_factor			= 1
	 
	 ll_found = of_verifica_doc( ls_tipo_doc,ls_nro_doc)
	 
	 
	 IF ll_found = 0 THEN 
	    ll_row = ldw_detail.event ue_insert( )
	     
		 /*INSERT PRE*/
		 ll_rowcount = ldw_detail.RowCount()

		 ldw_detail.object.flag_flujo_caja [ll_row] = '1'
		 

 		 is_param.bret = TRUE
		 ldw_detail.object.cod_relacion      [ll_row] = dw_2.object.cod_relacion [ll_inicio]
		 ldw_detail.object.tipo_doc          [ll_row] = ls_tipo_doc
       ldw_detail.object.nro_doc           [ll_row] = ls_nro_doc
		 
		if ls_cod_moneda = ls_soles then
		 	ldw_detail.object.importe           [ll_row] = dw_2.object.saldo_sol		[ll_inicio]	
	 	else
			ldw_detail.object.importe           [ll_row] = dw_2.object.saldo_dol		[ll_inicio]	
		end if
			 
		 ldw_detail.object.tasa_cambio       [ll_row] = is_param.db2
		 ldw_detail.object.cod_moneda        [ll_row] = ls_cod_moneda
		 ldw_detail.object.factor			    [ll_row] = ll_factor
		 ldw_detail.object.nom_proveedor     [ll_row] = dw_2.object.nom_cliente	[ll_inicio]	
		 ldw_detail.object.monto_sol			 [ll_row] = dw_2.object.saldo_sol		[ll_inicio]	
		 ldw_detail.object.monto_dol			 [ll_row] = dw_2.object.saldo_dol		[ll_inicio]	
		 
    END IF
	 
//SALIDA:		
	
Next
			  
end subroutine

public function long of_verifica_doc (string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = "tipo_doc = '" + as_tipo_doc+"' AND nro_doc ='" + as_nro_doc + "'"

ll_found 	 = is_param.dw_d.Find(ls_expresion,1,is_param.dw_d.Rowcount())


Return ll_found
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

event ue_open_pre;
String ls_null
Long   ll_row

// Recoge parametro enviado

	This.Title = is_param.titulo
	dw_1.DataObject = is_param.dw1
	dw_2.Dataobject = is_param.dw1
	
	dw_1.SetTransObject( SQLCA)
	dw_2.SetTransObject( SQLCA)
	//
	
	
	IF TRIM(is_param.tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
	ELSE		// caso contrario hace un retrieve con parametros
		CHOOSE CASE is_param.tipo
			CASE '1S3S'
				dw_1.Retrieve(is_param.string1, is_param.string3) 
			CASE '1CP','1CC' //cartera de pagos,cartera de cobro 
				dw_1.Retrieve(is_param.string1) 
			CASE	'1CLF'	//CIERRA LIQUIDACION FONDO FIJO
				dw_1.Retrieve(is_param.string1,is_param.string2) 
			CASE '1AP'    //APLICACION DE DOCUMENTO
				dw_1.Retrieve(is_param.string1) 
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
			CASE '1CD' 	  //Comprobantes de Detraccion
				dw_1.Retrieve(is_param.string3, is_param.string1, is_param.str_array)
			CASE '1OV'		  //ANTICIPO DE ORDENES DE VENTA
				dw_1.Retrieve(is_param.string1)			
			CASE '1OC'		  //ANTICIPO DE ORDENES DE COMPRA
				dw_1.Retrieve(is_param.string1)				
			CASE '1OS'		  //ANTICIPO DE ORDENES DE SERVICIO
				dw_1.Retrieve(is_param.string1)		
			CASE '1PP'		  //PROGRAMACION DE PAGOS
				dw_1.Retrieve(is_param.string1)	
			CASE	'1DETA'		//DETRACCION
				dw_1.Retrieve(is_param.string4,is_param.string1,is_param.string3)
			CASE	'1DETATEMP' //DETRACCION  TEMPORAL
				dw_1.Retrieve(is_param.string4)	
		END CHOOSE
	END IF


SELECT cod_soles,cod_dolares into :is_soles,:is_dolares from logparam where reckey = '1';
end event

event open;//override
THIS.EVENT ue_open_pre()
end event

type p_pie from w_abc_list`p_pie within w_abc_seleccion_lista
end type

type ole_skin from w_abc_list`ole_skin within w_abc_seleccion_lista
end type

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista
event type integer ue_selected_row_now ( long al_row )
integer x = 9
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event type integer dw_1::ue_selected_row_now(long al_row);String 		ls_cod, ls_matriz, ls_tipo_mov, ls_almacen, &
				ls_flag_saldo_libre, ls_cencos, ls_cnta_prsp, ls_cod_art
				
Decimal 		ldc_saldo_act, ldc_saldo_cons, ldc_cantidad, ldc_costo_prom

Long			ll_row, ll_rc, ll_nro_mov, j, ll_count
Any			la_id
Integer		li_x
u_dw_abc		ldw_master, ldw_detail

// Valida codigo


ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)

return 1
end event

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

idw_det = dw_2


ii_ss = 0
end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::ue_selected_row;//
Long	ll_row, ll_y

dw_2.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	// si retorna 0 (fallo en el row_now), deselecciona
	if THIS.EVENT ue_selected_row_now(ll_row) = 0 then
		this.selectRow(ll_row, false);
	end if
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.EVENT ue_selected_row_pos()


end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista
event type integer ue_selected_row_now ( long al_row )
integer x = 699
integer y = 136
integer width = 517
boolean hscrollbar = true
boolean vscrollbar = true
end type

event type integer dw_2::ue_selected_row_now(long al_row);String 		ls_cod, ls_matriz, ls_tipo_mov, ls_almacen, &
				ls_flag_saldo_libre, ls_cencos, ls_cnta_prsp, ls_cod_art
				
Decimal 		ldc_saldo_act, ldc_saldo_cons, ldc_cantidad, ldc_costo_prom

Long			ll_row, ll_rc, ll_nro_mov, j, ll_count
Any			la_id
Integer		li_x
u_dw_abc		ldw_master, ldw_detail

// Valida codigo


ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)

return 1
end event

event dw_2::constructor;call super::constructor;ii_ck[1] = 1

idw_det = dw_1
end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_2::ue_selected_row;//
Long	ll_row, ll_y

dw_2.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	// si retorna 0 (fallo en el row_now), deselecciona
	if THIS.EVENT ue_selected_row_now(ll_row) = 0 then
		this.selectRow(ll_row, false);
	end if
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.EVENT ue_selected_row_pos()

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
integer x = 3081
integer y = 16
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

event clicked;Long    ll_inicio,ll_found = 0,ll_row,ll_item,ll_row_count,ll_factor
String  ls_tipo_doc       ,ls_nro_doc      ,ls_let_x_pag ,ls_doc_sol_giro ,ls_flag_edit   ,&
		  ls_expresion      ,ls_doc_oc       ,ls_doc_os    ,ls_origen       ,ls_flag_estado ,&
		  ls_flag_estado_og ,ls_cod_relacion ,ls_cod_moneda,ls_soles        ,ls_dolares     ,&
		  ls_tipo_mov       ,ls_flag_tabla 	 ,ls_flag_provisionado	
Integer li_item,li_nro_sol_pend,li_nro_max
Decimal {2} ldc_importe,ldc_importe_cab,ldc_importe_det,ldc_saldo,ldc_saldo_sol,ldc_saldo_dol,&
				ldc_imp_total	

dw_2.Accepttext()

f_monedas(ls_soles,ls_dolares)

CHOOSE CASE is_param.opcion
		 CASE 1,2,24 //CANJE DE LETRA x pagar y cobrar
				is_param.bret = FALSE
				
				//tipo de movimiento
				IF is_param.opcion = 1 THEN	   //PAGAR 	
					ls_tipo_mov = 'P'
				ELSEIF is_param.opcion = 2 THEN  //COBRAR
					ls_tipo_mov = 'C'
				ELSEIF is_param.opcion = 24 THEN //COBRAR	
					ls_tipo_mov = 'C'
				END IF
				
				For ll_inicio = 1 TO dw_2.Rowcount ()
					 ls_origen       		 = dw_2.object.origen       		[ll_inicio]
					 ls_cod_relacion 		 = dw_2.object.cod_relacion 		[ll_inicio]
					 ls_tipo_doc     		 = dw_2.object.tipo_doc     		[ll_inicio]
					 ls_nro_doc   	  		 = dw_2.object.nro_doc      		[ll_inicio]	
					 ls_flag_tabla	  		 = dw_2.object.flag_tabla   		[ll_inicio]	
					 ls_cod_moneda   		 = dw_2.object.cod_moneda        [ll_inicio]	
					 ldc_saldo_sol   		 = dw_2.object.sldo_sol	         [ll_inicio]
					 ldc_saldo_dol	  		 = dw_2.object.saldo_dol         [ll_inicio]		
					 ll_factor	     		 = dw_2.object.factor            [ll_inicio]		
					 ls_flag_provisionado = dw_2.object.flag_provisionado [ll_inicio]		
					 
					 
					 IF ls_cod_moneda = ls_soles THEN //soles 
						 ldc_imp_total = ldc_saldo_sol
					 ELSEIF ls_cod_moneda = ls_dolares THEN //dolares
						 ldc_imp_total = ldc_saldo_dol
					 END IF
					 
					 //verifico que referencia no ha sido registrada
					 ll_found = wf_verifica_doc_ref (ls_origen,ls_tipo_doc,ls_nro_doc)
					 
					 IF ll_found = 0 THEN
						 ll_row = is_param.dw_m.Insertrow(0)
						 
			
						 
						 is_param.bret = TRUE	
						 is_param.dw_m.object.cod_relacion      [ll_row] = ls_cod_relacion
						 is_param.dw_m.object.origen_ref        [ll_row] = ls_origen
						 is_param.dw_m.object.tipo_mov	       [ll_row] = ls_tipo_mov
						 is_param.dw_m.object.tipo_ref          [ll_row] = ls_tipo_doc
						 is_param.dw_m.object.nro_ref           [ll_row] = ls_nro_doc
						 is_param.dw_m.object.importe           [ll_row] = ldc_imp_total
						 is_param.dw_m.object.flab_tabor        [ll_row] = ls_flag_tabla 
						 is_param.dw_m.object.factor            [ll_row] = ll_factor
						 is_param.dw_m.object.cod_moneda_det    [ll_row] = ls_cod_moneda
						 is_param.dw_m.object.cod_moneda_cab    [ll_row] = is_param.string2
						 is_param.dw_m.object.tasa_cambio       [ll_row] = is_param.db2
						 is_param.dw_m.object.soles		       [ll_row] = ls_soles
						 is_param.dw_m.object.dolares		       [ll_row] = ls_dolares
						 is_param.dw_m.object.flag_provisionado [ll_row] = ls_flag_provisionado
						 
					 END IF
					 
				Next	

				
		 CASE 6		/*Aplicación de Documentos*/		
				FOR ll_inicio = 1 TO dw_2.Rowcount()
			   	 is_param.bret = TRUE
					 ll_row = is_param.dw_m.InsertRow(0)
					 ll_row_count = is_param.dw_m.Rowcount()

					 IF ll_row_count = 1 THEN 
						 ll_item = 0
					 ELSE
					    ll_item = is_param.dw_m.Getitemnumber(ll_row_count - 1,'item')
					 END IF

					 
					 ll_item = ll_item + 1
					 
					 
					 is_param.dw_m.object.item            [ll_row] = ll_item
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
				
		 CASE	15,25 //CARTERA DE PAGOS,APLICACION DE DOCUMENTOS
				/*inserta registro en cartera de pagos*/
				wf_insert_cpagos ()
				
		 CASE 16 	//Liquidaciones de pesca y pago
				of_procesa_liq_opc_16()
	
		 CASE 17	// Detracciones
				of_procesa_det_opc_17()
				
		 CASE 18 //CARTERA DE COBROS
			   /*inserta registro en cartera de cobros*/	
			   wf_insert_ccobros ()	
			  
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
				
	CASE 27 //Caja Bancos
		of_opcion27()

END CHOOSE

Closewithreturn(parent,is_param)
end event

