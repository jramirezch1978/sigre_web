$PBExportHeader$w_abc_seleccion_lista.srw
forward
global type w_abc_seleccion_lista from w_abc_list
end type
type cb_1 from commandbutton within w_abc_seleccion_lista
end type
end forward

global type w_abc_seleccion_lista from w_abc_list
integer x = 50
integer width = 1275
integer height = 1372
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
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

public subroutine of_procesa_liq_opc_16 ();string	ls_cod_relacion ,ls_tipo_doc,ls_nro_doc,ls_flag_estado,ls_origen,ls_nro_reg
Long		ll_inicio, ll_row, ll_found, ll_item

dw_2.accepttext( )

For ll_inicio = 1 TO dw_2.Rowcount()
	 ls_cod_relacion = dw_2.object.cod_relacion [ll_inicio]
	 ls_tipo_doc 	  = dw_2.object.tipo_doc	  [ll_inicio]
	 ls_nro_doc		  = dw_2.object.nro_doc	  		[ll_inicio]
	 ls_nro_reg		  = dw_2.object.nro_registro [ll_inicio]
	 ls_flag_estado  = '1'
	
	IF ll_found > 0 THEN
		Messagebox('Aviso','Documento '+Trim(ls_tipo_doc)+' '+Trim(ls_nro_doc)+' ya Ha sido Registrado , Verifique!')
	ELSE	 
		is_param.bret = TRUE
		ll_row = is_param.dw_m.InsertRow(0)	
		
//		// Inserto los registros en el detalle
		 wf_insert_liquidacion (ll_row,ll_inicio,ls_flag_estado)
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
		  ls_flag_estado_og 	,ls_doc_detrac
Long    ll_inicio,ll_found,ll_row,ll_factor,ll_rowcount,ll_item,ll_count
Integer li_nro_sol_pend,li_nro_max
Decimal {2} ldc_aplicado_sol,ldc_aplicado_dol

	  
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


	 if ls_flag_prov = 'R' and is_param.opcion = 15 AND ls_flag_tabla = '3'    THEN //VERIFICAR SI CONTIENE ANTICIPOS
	 	 if wf_verifica_anticipos(ls_cod_relacion,ls_tipo_doc,ls_nro_doc) = false then
			 GOTO SALIDA	
		  end if	
	 end if
	 
	 
	 
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
		 ls_flag_ctrl_reg		 ,ls_soles		  ,ls_dolares

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
String  ls_soles,ls_dolares,ls_cod_moneda,ls_flag_tabla
Decimal {2} ldc_importe

dw_2.Accepttext()

select cod_soles ,cod_dolares into :ls_soles,:ls_dolares from logparam where (reckey = '1');

For ll_inicio = 1 TO dw_2.Rowcount()
	 
	 /*importe*/
	 ls_cod_moneda = dw_2.object.cod_moneda [ll_inicio]
	 ls_flag_tabla = dw_2.object.flag_tabla [ll_inicio]
	 ll_factor		= dw_2.object.factor		 [ll_inicio]
	 
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

//paso datos del dw_2 al al dw_detalle
is_param.dw_m.object.nro_registro    [al_row] = dw_2.object.nro_registro  [al_row_det]		 		
is_param.dw_m.object.cod_moneda		 [al_row] = ls_cod_moneda  
is_param.dw_m.object.cod_relacion    [al_row] = dw_2.object.cod_relacion  [al_row_det]
is_param.dw_m.object.nom_proveedor   [al_row] = dw_2.object.nom_proveedor [al_row_det]
is_param.dw_m.object.tipo_doc        [al_row] = dw_2.object.tipo_doc  	  [al_row_det]
is_param.dw_m.object.nro_doc         [al_row] = dw_2.object.nro_doc   	  [al_row_det]
is_param.dw_m.object.valor_venta     [al_row] = dw_2.object.valor_venta	  [al_row_det]
is_param.dw_m.object.precio_venta    [al_row] = dw_2.object.precio_venta  [al_row_det]

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

//ii_ck[1] = 1         // columnas de lectrua de este dw

CHOOSE CASE is_param.opcion 
		
//	 	 CASE 1,2,24    // Canje de letras x cobrar y pagar,DETRACCION
//										// Deploy key
//				ii_dk[1] = 1		//Tipo de Documento		
//				ii_dk[2] = 2		//Nro de Documento		
//				ii_dk[3] = 3		//Moneda
//				ii_dk[4] = 4		//Total a Pagar
//				ii_dk[5] = 5		//Codigo de Relacion
//				ii_dk[6] = 6		//Flag Tabla
//				ii_dk[7] = 7      //tipo origen de doc / P PAGAR C COBRAR
//				ii_dk[8] = 8      //Signo
//				ii_dk[9] = 9      //Origen
//				
//				ii_rk[1] = 1				
//				ii_rk[2] = 2				
//				ii_rk[3] = 3				
//				ii_rk[4] = 4				
//				ii_rk[5] = 5								
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//				ii_rk[9] = 9
//				
//		 CASE 3 //cierre liquidacion fondo fijo
//				ii_dk[1] = 1   //origen
//				ii_dk[2] = 2   //nro solicitud
//				ii_dk[3] = 3   //item
//				ii_dk[4] = 4   //proveedor
//				ii_dk[5] = 5   //tipo documento
//				ii_dk[6] = 6   //nro documento
//				ii_dk[7] = 7   //fecha documento
//				ii_dk[8] = 8   //moneda
//				ii_dk[9] = 9   //tasa cambio
//				ii_dk[10] = 10 //descripcion
//				ii_dk[11] = 11 //importe
//				ii_dk[12] = 12 //confin 1
//				ii_dk[13] = 13 //confin 2
//				ii_dk[14] = 14 //cencos
//				ii_dk[15] = 15 //cnta prsp
//				ii_dk[16] = 16 //flag_tipo_gasto
//				ii_dk[17] = 17 //nom_proveedor
//
//				/*	          */
//				ii_rk[1] = 1
//				ii_rk[2] = 2
//				ii_rk[3] = 3
//				ii_rk[4] = 4
//				ii_rk[5] = 5
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//				ii_rk[9] = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				ii_rk[14] = 14
//				ii_rk[15] = 15
//				ii_rk[16] = 16 //flag_tipo_gasto 
//				ii_rk[16] = 17 //nom_proveedor
//		 CASE 4,5	//ORDEN DE COMPRA ADELANTOS,ORDEN DE SERVICIO ADELANTOS,LIQUIDACION DE PAGO
//			
//				ii_dk[1] = 1
//				ii_dk[2] = 2
//				ii_dk[3] = 3
//				ii_dk[4] = 4
//				ii_dk[5] = 5
//				ii_dk[6] = 6
//				ii_dk[7] = 7
//			   ii_dk[8] = 8
//				
//				ii_rk[1] = 1
//				ii_rk[2] = 2
//				ii_rk[3] = 3
//				ii_rk[4] = 4
//				ii_rk[5] = 5
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//				
//		CASE	6		//APLICACION DE DOCUMENTOS
//			 
//				ii_dk[1]  = 1
//				ii_dk[2]  = 2
//				ii_dk[3]  = 3
//				ii_dk[4]  = 4
//				ii_dk[5]  = 5
//				ii_dk[6]  = 6
//				ii_dk[7]  = 7
//			   ii_dk[8]  = 8
//				ii_dk[9]  = 9
//				ii_dk[10] = 10
//				ii_dk[11] = 11
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				
//				ii_rk[1]  = 1
//				ii_rk[2]  = 2
//				ii_rk[3]  = 3
//				ii_rk[4]  = 4
//				ii_rk[5]  = 5
//				ii_rk[6]  = 6
//				ii_rk[7]  = 7
//				ii_rk[8]  = 8
//				ii_rk[9]  = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				
//		 CASE	8  //Pre liquidacion de orden de giro
//				ii_dk[1]  = 1
//				ii_dk[2]  = 2
//				ii_dk[3]  = 3
//				ii_dk[4]  = 4
//				ii_dk[5]  = 5
//				ii_dk[6]  = 6
//				ii_dk[7]  = 7
//				ii_dk[8]  = 8
//				ii_dk[9]  = 9
//				ii_dk[10] = 10
//				ii_dk[11] = 11
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14
//				ii_dk[15] = 15
//				ii_dk[16] = 16
//				ii_dk[17] = 17
//				ii_dk[18] = 18
//				
//				ii_rk[1]  = 1
//				ii_rk[2]  = 2
//				ii_rk[3]  = 3
//				ii_rk[4]  = 4
//				ii_rk[5]  = 5
//				ii_rk[6]  = 6
//				ii_rk[7]  = 7
//				ii_rk[8]  = 8
//				ii_rk[9]  = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				ii_rk[14] = 14				
//				ii_rk[15] = 15
//				ii_rk[16] = 16
//				ii_rk[17] = 17
//				ii_rk[18] = 18
//				
//				
//		 CASE 14 //devolucion de orden de giro
//				ii_dk[1]  = 1  //cod_relacion
//				ii_dk[2]  = 2  //tipo_doc
//				ii_dk[3]  = 3  //nro_doc
//				ii_dk[4]  = 4  //cod_moneda
//				ii_dk[5]  = 5  //fecha emision
//				ii_dk[6]  = 6  //tasa cambio
//				ii_dk[7]  = 7  //descripcion
//				ii_dk[8]  = 8  //saldo
//				ii_dk[9]  = 9  //nombre proveedor
//				ii_dk[10]  = 10  //cencos
//				ii_dk[11]  = 11  //cnta presup
//				ii_dk[12]  = 12  //Tipo Gasto
//				
//				ii_rk[1]  = 1  //cod_relacion
//				ii_rk[2]  = 2  //tipo_doc
//				ii_rk[3]  = 3  //nro_doc
//				ii_rk[4]  = 4  //cod_moneda
//				ii_rk[5]  = 5  //fecha emision
//				ii_rk[6]  = 6  //tasa cambio
//				ii_rk[7]  = 7  //descripcion
//				ii_rk[8]  = 8  //saldo
//				ii_rk[9]  = 9  //nombre proveedor
//				ii_rk[10]  = 10  //cencos
//				ii_rk[11]  = 11  //cnta presup
//				ii_rk[12]  = 12  //Tipo Gasto				
//				
//			  
//   	CASE 15,25    // Cartera de pagos
//								// Deploy key
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				ii_dk[6]  = 6		
//				ii_dk[7]  = 7      
//				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14				
//				ii_dk[15] = 15	
//				ii_dk[16] = 16
//				ii_dk[17] = 17
//				ii_dk[18] = 18
//				ii_dk[19] = 19
//				
//				ii_rk[1]  = 1		//codigo de relacion		
//				ii_rk[2]  = 2		//tipo doc		
//				ii_rk[3]  = 3		//nro doc		
//				ii_rk[4]  = 4		//flag tabla		
//				ii_rk[5]  = 5		//cnta ctbl
//				ii_rk[6]  = 6		//moneda
//				ii_rk[7]  = 7		//flag debhab
//				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen
//				ii_rk[13] = 13		//importe
//				ii_rk[14] = 14		//flag provisionado			  
//				ii_rk[15] = 15		//nom proveedor
//				ii_rk[16] = 16		//indicador planilla		
//				ii_rk[17] = 17		//tipo de cambio de provision
//				ii_rk[18] = 18		//Saldo Aplicado Soles				
//				ii_rk[19] = 19		//Saldo Aplicado Dolares				
//				
//				
//				
		 CASE 16    //	Liquidaciones de Pesca
								// Deploy key
								
				ii_ck[1]  = 1
				ii_ck[2] = 2
				ii_ck[3] = 3
				ii_ck[4] = 4
				ii_ck[5] = 5
				ii_ck[6] = 6
				ii_ck[7] = 7
				ii_ck[8] = 8

				ii_dk[1]  = 1		
				ii_dk[2]  = 2		
				ii_dk[3]  = 3		
				ii_dk[4]  = 4		
				ii_dk[5]  = 5		
				ii_dk[6]  = 6		
				ii_dk[7]  = 7      
				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14				
//				ii_dk[15] = 15	
//				ii_dk[16] = 16
				
				ii_rk[1]  = 1		//codigo de relacion		
				ii_rk[2]  = 2		//tipo doc		
				ii_rk[3]  = 3		//nro doc		
				ii_rk[4]  = 4		//flag tabla		
				ii_rk[5]  = 5		//cnta ctbl
				ii_rk[6]  = 6		//moneda
				ii_rk[7]  = 7		//flag debhab
				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen
//				ii_rk[13] = 13		//importe
//				ii_rk[14] = 14		//flag provisionado			  
//				ii_rk[15] = 15		//nom proveedor
//				ii_rk[16] = 16		//indicador planilla		
			   
//		 CASE 18    // Cartera de cobros
//										// Deploy key
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				ii_dk[6]  = 6		
//				ii_dk[7]  = 7      
//				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14				
//				ii_dk[15] = 15
//				ii_dk[16] = 16
//				ii_dk[17] = 17
//				ii_dk[18] = 18
//				ii_dk[19] = 19				
//				
//				
//				ii_rk[1]  = 1		//codigo de relacion		
//				ii_rk[2]  = 2		//tipo doc		
//				ii_rk[3]  = 3		//nro doc		
//				ii_rk[4]  = 4		//flag tabla		
//				ii_rk[5]  = 5		//cnta ctbl
//				ii_rk[6]  = 6		//moneda
//				ii_rk[7]  = 7		//flag debhab
//				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen
//				ii_rk[13] = 13		//importe
//				ii_rk[15] = 15		//flag provisionado	
//				ii_rk[16] = 16		//flag planilla
//				ii_rk[17] = 17		//TIPO DE CAMBIO
//				ii_rk[18] = 18 	//saldo aplicado soles
//				ii_rk[19] = 19		//saldo aplicado dolares		
//				
//		 CASE 19    // Anticipo de Orden de Venta
//										// Deploy key
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				
//				
//				ii_rk[1]  = 1		//Origen
//				ii_rk[2]  = 2		//nro ov
//				ii_rk[3]  = 3		//flag estado
//				ii_rk[4]  = 4		//fec registro
//				ii_rk[5]  = 5		//monto total
//
//		 CASE 20    // Anticipo de Orden de compra
//										// Deploy key
//				ii_dk[1] = 1		
//				ii_dk[2] = 2		
//				ii_dk[3] = 3		
//				ii_dk[4] = 4		
//				ii_dk[5] = 5		
//				ii_dk[6] = 6		
//				ii_dk[7] = 7		
//				
//				
//				ii_rk[1] = 1		//Origen
//				ii_rk[2] = 2		//nro oc
//				ii_rk[3] = 3		//proveedor
//				ii_rk[4] = 4		//flag estado
//				ii_rk[5] = 5		//fec registro
//				ii_rk[6] = 6		//cod moneda
//				ii_rk[7] = 7		//monto total
//
//		 CASE 21    // Anticipo de Orden de Servicio
//										// Deploy key
//				ii_dk[1] = 1		
//				ii_dk[2] = 2		
//				ii_dk[3] = 3		
//				ii_dk[4] = 4		
//				ii_dk[5] = 5		
//				ii_dk[6] = 6		
//				ii_dk[7] = 7		
//				
//				
//				ii_rk[1] = 1		//Origen
//				ii_rk[2] = 2		//nro os
//				ii_rk[3] = 3		//proveedor
//				ii_rk[4] = 4		//flag estado
//				ii_rk[5] = 5		//fec registro
//				ii_rk[6] = 6		//cod moneda
//				ii_rk[7] = 7		//monto total
//
//		 CASE 22   // Programacion de pagos
//										// Deploy key
//				ii_dk[1] = 1	//cod_relacion	
//				ii_dk[2] = 2	//nom_proveedor
//				ii_dk[3] = 3	//tipo_doc			
//				ii_dk[4] = 4	//nro_doc	
//				ii_dk[5] = 5	//cod_moneda	
//				ii_dk[6] = 6	//saldo_sol	
//				ii_dk[7] = 7	//saldo_dol
//				ii_dk[8] = 8	//factor
//				ii_dk[9] = 9	//flag_tabla
//				
//				ii_rk[1] = 1	//cod_relacion	
//				ii_rk[2] = 2	//nom_proveedor
//				ii_rk[3] = 3	//tipo_doc			
//				ii_rk[4] = 4	//nro_doc	
//				ii_rk[5] = 5	//cod_moneda	
//				ii_rk[6] = 6	//saldo_sol	
//				ii_rk[7] = 7	//saldo_dol
//				ii_rk[8] = 8	//factor
//				ii_rk[9] = 9	//flag_tabla
//				
//		 CASE 23    // planilla de cobranza
//										// Deploy key
//				ii_dk[1]  = 1	//cod_relacion	
//				ii_dk[2]  = 2	//nom_proveedor
//				ii_dk[3]  = 3	//tipo_doc			
//				ii_dk[4]  = 4	//nro_doc	
//				ii_dk[5]  = 5	//cod_moneda	
//				ii_dk[6]  = 6	//saldo_sol	
//				ii_dk[7]  = 7	//saldo_dol
//				ii_dk[8]  = 8	//factor
//				ii_dk[9]  = 9	//flag_tabla
//				ii_dk[10] = 10	//flag_provisionado
//				ii_dk[11] = 11	//nro_deposito
//				ii_dk[12] = 12	//fecha_deposito
//				ii_dk[13] = 13	//referencia
//				
//				
//				ii_rk[1]  = 1	//cod_relacion	
//				ii_rk[2]  = 2	//nom_proveedor
//				ii_rk[3]  = 3	//tipo_doc			
//				ii_rk[4]  = 4	//nro_doc	
//				ii_rk[5]  = 5	//cod_moneda	
//				ii_rk[6]  = 6	//saldo_sol	
//				ii_rk[7]  = 7	//saldo_dol
//				ii_rk[8]  = 8	//factor
//				ii_rk[9]  = 9	//flag_tabla
//				ii_rk[10] = 10	//flag_provisionado
//				ii_rk[11] = 11	//nro_deposito
//				ii_rk[12] = 12	//fecha_deposito
//				ii_dk[13] = 13	//referencia			
//						
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

event dw_2::constructor;call super::constructor;//ii_ck[1] = 1
//CHOOSE CASE is_param.opcion 
//			 CASE 1,2,24 //Canje de letras x cobrar y pagar
//								//Deploy Key
//				ii_rk[1] = 1		//Tipo de Documento		
//				ii_rk[2] = 2		//Nro de Documento		
//				ii_rk[3] = 3		//Moneda
//				ii_rk[4] = 4		//Total a Pagar
//				ii_rk[5] = 5		//Codigo de Relacion
//				ii_rk[6] = 6		//Flag Tabla
//				ii_rk[7] = 7      //tipo origen de doc / P PAGAR C COBRAR
//				ii_rk[8] = 8      //Signo
//				ii_rk[9] = 9      //Origen
//								//Receive Key
//				ii_dk[1] = 1				
//				ii_dk[2] = 2				
//				ii_dk[3] = 3				
//
//				ii_dk[4] = 4				
//				ii_dK[5] = 5								
//				ii_dk[6] = 6
//				ii_dk[7] = 7
//				ii_dk[8] = 8
//				ii_dk[9] = 9
//				
//		 CASE 3 //cierre liquidacion fondo fijo
//				ii_rk[1] = 1
//				ii_rk[2] = 2
//				ii_rk[3] = 3
//				ii_rk[4] = 4
//				ii_rk[5] = 5
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//				ii_rk[9] = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				ii_rk[14] = 14
//				ii_rk[15] = 15
//				ii_rk[16] = 16 //flag_tipo_gasto
//				ii_rk[17] = 17 //nom proveedor
//				/*          */
// 				ii_dk[1] = 1   //origen
//				ii_dk[2] = 2   //nro solicitud
//				ii_dk[3] = 3   //item
//				ii_dk[4] = 4   //proveedor
//				ii_dk[5] = 5   //tipo documento
//				ii_dk[6] = 6   //nro documento
//				ii_dk[7] = 7   //fecha documento
//				ii_dk[8] = 8   //moneda
//				ii_dk[9] = 9   //tasa cambio
//				ii_dk[10] = 10 //descripcion
//				ii_dk[11] = 11 //importe
//				ii_dk[12] = 12 //confin 1
//				ii_dk[13] = 13 //confin 2
//				ii_dk[14] = 14 //cencos
//				ii_dk[15] = 15 //cnta prsp
//				ii_dk[16] = 16 //flag_tipo_gasto
//				ii_dk[17] = 17 //nom proveedor				
//				
//		 CASE 4,5	//ORDEN DE COMPRA ADELANTOS,ORDEN DE SERVICIO ADELANTOS,LIQUIDACION DE PAGO
//
//				ii_rk[1] = 1
//				ii_rk[2] = 2
//				ii_rk[3] = 3
//				ii_rk[4] = 4
//				ii_rk[5] = 5
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//
//				ii_dk[1] = 1
//				ii_dk[2] = 2
//				ii_dk[3] = 3
//				ii_dk[4] = 4
//				ii_dk[5] = 5
//				ii_dk[6] = 6
//				ii_dk[7] = 7
//				ii_dk[8] = 8
//				
//		CASE	6		//APLICACION DE DOCUMENTOS
//			 
//				ii_rk[1]  = 1
//				ii_rk[2]  = 2
//				ii_rk[3]  = 3
//				ii_rk[4]  = 4
//				ii_rk[5]  = 5
//				ii_rk[6]  = 6
//				ii_rk[7]  = 7
//				ii_rk[8]  = 8
//				ii_rk[9]  = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				
//				ii_dk[1]  = 1
//				ii_dk[2]  = 2
//				ii_dk[3]  = 3
//				ii_dk[4]  = 4
//				ii_dk[5]  = 5
//				ii_dk[6]  = 6
//				ii_dk[7]  = 7
//			   ii_dk[8]  = 8
//				ii_dk[9]  = 9
//				ii_dk[10] = 10
//				ii_dk[11] = 11
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				
//	  CASE	8  //Pre liquidacion de orden de giro
//		
//				ii_rk[1]  = 1
//				ii_rk[2]  = 2
//				ii_rk[3]  = 3
//				ii_rk[4]  = 4
//				ii_rk[5]  = 5
//				ii_rk[6]  = 6
//				ii_rk[7]  = 7
//				ii_rk[8]  = 8
//				ii_rk[9]  = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				ii_rk[14] = 14
//				ii_rk[15] = 15
//				ii_rk[16] = 16
//				ii_rk[17] = 17
//				ii_rk[18] = 18
//							
//				ii_dk[1]  = 1
//				ii_dk[2]  = 2
//				ii_dk[3]  = 3
//				ii_dk[4]  = 4
//				ii_dk[5]  = 5
//				ii_dk[6]  = 6
//				ii_dk[7]  = 7
//				ii_dk[8]  = 8
//				ii_dk[9]  = 9
//				ii_dk[10] = 10
//				ii_dk[11] = 11
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14
//				ii_dk[15] = 15
//				ii_dk[16] = 16
//				ii_dk[17] = 17
//				ii_dk[18] = 18				
//		 CASE 11
//				ii_rk[1]  = 1  //cod_relacion
//				ii_rk[2]  = 2  //tipo_doc
//				ii_rk[3]  = 3  //nro_doc
//				ii_rk[4]  = 4  //cod_moneda
//				ii_rk[5]  = 5  //fecha emision
//				ii_rk[6]  = 6  //tasa cambio
//				ii_rk[7]  = 7  //descripcion
//				ii_rk[8]  = 8  //saldo
//				ii_rk[9]  = 9  //CENCOS
//				ii_rk[10]  = 10  //CNTA PRESUP
//								
//				ii_dk[1]  = 1  //cod_relacion
//				ii_dk[2]  = 2  //tipo_doc
//				ii_dk[3]  = 3  //nro_doc
//				ii_dk[4]  = 4  //cod_moneda
//				ii_dk[5]  = 5  //fecha emision
//				ii_dk[6]  = 6  //tasa cambio
//				ii_dk[7]  = 7  //descripcion
//				ii_dk[8]  = 8  //saldo
//				ii_dk[9]  = 9  //CENCOS
//				ii_dk[10] = 10  //CNTA PRESUP
//				
//				
//		 CASE	12 //PRE LIQUIDACION CNTAS X PAGAR
//				ii_rk[1]  = 1  //cod_relacion
//				ii_rk[2]  = 2  //tipo_doc
//				ii_rk[3]  = 3  //nro_doc
//				ii_rk[4]  = 4  //cod_moneda
//				ii_rk[5]  = 5  //fecha emision
//				ii_rk[6]  = 6  //tasa cambio
//				ii_rk[7]  = 7  //descripcion
//				ii_rk[8]  = 8  //saldo
//				ii_rk[9]  = 9  //NOMBRE PROVEEDOR
//				ii_rk[10]  = 10  //cencos
//				ii_rk[11]  = 11  //cnta prsp
//								
//				ii_dk[1]  = 1  //cod_relacion
//				ii_dk[2]  = 2  //tipo_doc
//				ii_dk[3]  = 3  //nro_doc
//				ii_dk[4]  = 4  //cod_moneda
//				ii_dk[5]  = 5  //fecha emision
//				ii_dk[6]  = 6  //tasa cambio
//				ii_dk[7]  = 7  //descripcion
//				ii_dk[8]  = 8  //saldo
//				ii_dk[9]  = 9  //NOMBRE PROVEEDOR
//				ii_dk[10]  = 10  //cencos
//				ii_dk[11]  = 11  //cnta prsp
//				
//		 CASE	13 //orden de giro
//				ii_rk[1]  = 1  //cod_relacion
//				ii_rk[2]  = 2  //tipo_doc
//				ii_rk[3]  = 3  //nro_doc
//				ii_rk[4]  = 4  //cod_moneda
//				ii_rk[5]  = 5  //fecha emision
//				ii_rk[6]  = 6  //tasa cambio
//				ii_rk[7]  = 7  //descripcion
//				ii_rk[8]  = 8  //saldo
//				ii_rk[9]  = 9  //NOMBRE PROVEEDOR
//				ii_rk[10]  = 10  //CENCOS
//				ii_rk[11]  = 11  //CNTA PRESUP
//								
//				ii_dk[1]  = 1  //cod_relacion
//				ii_dk[2]  = 2  //tipo_doc
//				ii_dk[3]  = 3  //nro_doc
//				ii_dk[4]  = 4  //cod_moneda
//				ii_dk[5]  = 5  //fecha emision
//				ii_dk[6]  = 6  //tasa cambio
//				ii_dk[7]  = 7  //descripcion
//				ii_dk[8]  = 8  //saldo
//				ii_dk[9]  = 9  //NOMBRE PROVEEDOR
//				ii_dk[10]  = 10  //CENCOS
//				ii_dk[11]  = 11  //CNTA PRESUP
//
//		 CASE 14 //devolucion de orden de giro
//				ii_rk[1]  = 1  //cod_relacion
//				ii_rk[2]  = 2  //tipo_doc
//				ii_rk[3]  = 3  //nro_doc
//				ii_rk[4]  = 4  //cod_moneda
//				ii_rk[5]  = 5  //fecha emision
//				ii_rk[6]  = 6  //tasa cambio
//				ii_rk[7]  = 7  //descripcion
//				ii_rk[8]  = 8  //saldo
//				ii_rk[9]  = 9  //nombre proveedor
//				ii_rk[10]  = 10  //cencos
//				ii_rk[11]  = 11  //cnta presup
//				ii_rk[12]  = 12  //Tipo Gasto											
//				
//				ii_dk[1]  = 1  //cod_relacion
//				ii_dk[2]  = 2  //tipo_doc
//				ii_dk[3]  = 3  //nro_doc
//				ii_dk[4]  = 4  //cod_moneda
//				ii_dk[5]  = 5  //fecha emision
//				ii_dk[6]  = 6  //tasa cambio
//				ii_dk[7]  = 7  //descripcion
//				ii_dk[8]  = 8  //saldo
//				ii_dk[9]  = 9  //nombre proveedor
//				ii_dk[10]  = 10  //cencos
//				ii_dk[11]  = 11  //cnta presup
//				ii_dk[12]  = 12  //Tipo Gasto
//				
//		
//				
//		 CASE 15,25    // Cartera de pagos
//										// Deploy key
//				ii_rk[1]  = 1		//codigo de relacion		
//				ii_rk[2]  = 2		//tipo doc		
//				ii_rk[3]  = 3		//nro doc		
//				ii_rk[4]  = 4		//flag tabla		
//				ii_rk[5]  = 5		//cnta ctbl
//				ii_rk[6]  = 6		//moneda
//				ii_rk[7]  = 7		//flag debhab
//				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen								
//				ii_rk[13] = 13		//importe
//				ii_rk[14] = 14		//flag provisionado
//				ii_rk[15] = 15		//nom proveedor
//				ii_rk[16] = 16		//planilla cobranza
//				ii_rk[17] = 17		//TIPO DE CAMBIO
//				ii_rk[18] = 18		//Saldo Aplicado Soles
//				ii_rk[19] = 19		//Saldo Aplicado Dolares
//				
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				ii_dk[6]  = 6		
//				ii_dk[7]  = 7      
//				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14
//				ii_dk[15] = 15	
//				ii_dk[16] = 16		//planilla cobranza				
//				ii_dk[17] = 17		//TIPO DE CAMBIO DE PROVISION
//				ii_dk[18] = 18		//Saldo Aplicado Soles
//				ii_dk[19] = 19		//Saldo Aplicado Dolares
//				
//		 CASE	16    //LIQUIDACION DE PESCA
//				ii_rk[1]  = 1		//codigo de relacion		
//				ii_rk[2]  = 2		//tipo doc		
//				ii_rk[3]  = 3		//nro doc		
//				ii_rk[4]  = 4		//flag tabla		
//				ii_rk[5]  = 5		//cnta ctbl
//				ii_rk[6]  = 6		//moneda
//				ii_rk[7]  = 7		//flag debhab
//				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen								
//				ii_rk[13] = 13		//importe
//				ii_rk[14] = 14		//flag provisionado
//				ii_rk[15] = 15		//nom proveedor
//				ii_rk[16] = 16		//planilla cobranza
//										
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				ii_dk[6]  = 6		
//				ii_dk[7]  = 7      
//				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14
//				ii_dk[15] = 15	
//				ii_dk[16] = 16		//planilla cobranza							
//		 CASE 18    // Cartera de cobros
//										// Deploy key
//				ii_rk[1]  = 1		//codigo de relacion		
//				ii_rk[2]  = 2		//tipo doc		
//				ii_rk[3]  = 3		//nro doc		
//				ii_rk[4]  = 4		//flag tabla		
//				ii_rk[5]  = 5		//cnta ctbl
//				ii_rk[6]  = 6		//moneda
//				ii_rk[7]  = 7		//flag debhab
//				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen								
//				ii_rk[13] = 13		//importe
//				ii_rk[14] = 14		//flag provisionado
//				ii_rk[15] = 15		//nom proveedor
//				ii_rk[16] = 16		//planilla cobranza				
//				ii_rk[17] = 17		//TIPO CAMBIO
//				ii_rk[18] = 18		//Saldo Aplicado Soles
//				ii_rk[19] = 19		//Saldo Aplicado Dolares
//				
//				
//										
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				ii_dk[6]  = 6		
//				ii_dk[7]  = 7      
//				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14				
//				ii_dk[15] = 15		//nom proveedor				
//				ii_dk[16] = 16		//planilla cobranza								
//				ii_dk[17] = 17		//TIPO DE CAMBIO
//				ii_dk[18] = 18		//Saldo Aplicado Soles
//				ii_dk[19] = 19		//Saldo Aplicado Dolares
//
//				
//		 CASE 19    // Anticipo de Orden de Venta
//				ii_rk[1]  = 1		//Origen
//				ii_rk[2]  = 2		//nro ov
//				ii_rk[3]  = 3		//flag estado
//				ii_rk[4]  = 4		//fec registro
//				ii_rk[5]  = 5		//monto total
//				
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				
//		 CASE 20    // Anticipo de Orden de Compra	
//			
//				ii_rk[1] = 1		//Origen
//				ii_rk[2] = 2		//nro oc
//				ii_rk[3] = 3		//proveedor
//				ii_rk[4] = 4		//flag estado
//				ii_rk[5] = 5		//fec registro
//				ii_rk[6] = 6		//cod moneda
//				ii_rk[7] = 7		//monto total							
//				
//				ii_dk[1] = 1		
//				ii_dk[2] = 2		
//				ii_dk[3] = 3		
//				ii_dk[4] = 4		
//				ii_dk[5] = 5		
//				ii_dk[6] = 6		
//				ii_dk[7] = 7		
//				
//		 CASE 21    // Anticipo de Orden de Servicio
//			
//				ii_rk[1] = 1		//Origen
//				ii_rk[2] = 2		//nro os
//				ii_rk[3] = 3		//proveedor
//				ii_rk[4] = 4		//flag estado
//				ii_rk[5] = 5		//fec registro
//				ii_rk[6] = 6		//cod moneda
//				ii_rk[7] = 7		//monto total							
//				
//				ii_dk[1] = 1		
//				ii_dk[2] = 2		
//				ii_dk[3] = 3		
//				ii_dk[4] = 4		
//				ii_dk[5] = 5		
//				ii_dk[6] = 6		
//				ii_dk[7] = 7						
//				
//		 CASE 22    // Programación de pagos
//			
//				ii_rk[1] = 1	//cod_relacion	
//				ii_rk[2] = 2	//nom_proveedor
//				ii_rk[3] = 3	//tipo_doc			
//				ii_rk[4] = 4	//nro_doc	
//				ii_rk[5] = 5	//cod_moneda	
//				ii_rk[6] = 6	//saldo_sol	
//				ii_rk[7] = 7	//saldo_dol
//				ii_rk[8] = 8	//factor
//				ii_rk[9] = 9	//flag_tabla	
//				
//				ii_dk[1] = 1	//cod_relacion	
//				ii_dk[2] = 2	//nom_proveedor
//				ii_dk[3] = 3	//tipo_doc			
//				ii_dk[4] = 4	//nro_doc	
//				ii_dk[5] = 5	//cod_moneda	
//				ii_dk[6] = 6	//saldo_sol	
//				ii_dk[7] = 7	//saldo_dol
//				ii_dk[8] = 8	//factor
//				ii_dk[9] = 9	//flag_tabla
//				
//		 CASE 23    // Planilla de cobranza
//			
//				ii_rk[1]  = 1	//cod_relacion	
//				ii_rk[2]  = 2	//nom_proveedor
//				ii_rk[3]  = 3	//tipo_doc			
//				ii_rk[4]  = 4	//nro_doc	
//				ii_rk[5]  = 5	//cod_moneda	
//				ii_rk[6]  = 6	//saldo_sol	
//				ii_rk[7]  = 7	//saldo_dol
//				ii_rk[8]  = 8	//factor
//				ii_rk[9]  = 9	//flag_tabla	
//				ii_rk[10] = 10	//flag_provisionado
//				ii_rk[11] = 11	//nro_deposito
//				ii_rk[12] = 12	//fecha_deposito
//				ii_rk[13] = 13	//referencia
//				
//				ii_dk[1] = 1	//cod_relacion	
//				ii_dk[2] = 2	//nom_proveedor
//				ii_dk[3] = 3	//tipo_doc			
//				ii_dk[4] = 4	//nro_doc	
//				ii_dk[5] = 5	//cod_moneda	
//				ii_dk[6] = 6	//saldo_sol	
//				ii_dk[7] = 7	//saldo_dol
//				ii_dk[8] = 8	//factor
//				ii_dk[9] = 9	//flag_tabla
//				ii_dk[10] = 10	//flag_provisionado
//				ii_dk[11] = 11	//nro_deposito
//				ii_dk[12] = 12	//fecha_deposito
//				ii_rk[13] = 13	//referencia
//				
//END CHOOSE
//
///////////////
// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

//ii_ck[1] = 1         // columnas de lectrua de este dw

CHOOSE CASE is_param.opcion 
		
//	 	 CASE 1,2,24    // Canje de letras x cobrar y pagar,DETRACCION
//										// Deploy key
//				ii_dk[1] = 1		//Tipo de Documento		
//				ii_dk[2] = 2		//Nro de Documento		
//				ii_dk[3] = 3		//Moneda
//				ii_dk[4] = 4		//Total a Pagar
//				ii_dk[5] = 5		//Codigo de Relacion
//				ii_dk[6] = 6		//Flag Tabla
//				ii_dk[7] = 7      //tipo origen de doc / P PAGAR C COBRAR
//				ii_dk[8] = 8      //Signo
//				ii_dk[9] = 9      //Origen
//				
//				ii_rk[1] = 1				
//				ii_rk[2] = 2				
//				ii_rk[3] = 3				
//				ii_rk[4] = 4				
//				ii_rk[5] = 5								
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//				ii_rk[9] = 9
//				
//		 CASE 3 //cierre liquidacion fondo fijo
//				ii_dk[1] = 1   //origen
//				ii_dk[2] = 2   //nro solicitud
//				ii_dk[3] = 3   //item
//				ii_dk[4] = 4   //proveedor
//				ii_dk[5] = 5   //tipo documento
//				ii_dk[6] = 6   //nro documento
//				ii_dk[7] = 7   //fecha documento
//				ii_dk[8] = 8   //moneda
//				ii_dk[9] = 9   //tasa cambio
//				ii_dk[10] = 10 //descripcion
//				ii_dk[11] = 11 //importe
//				ii_dk[12] = 12 //confin 1
//				ii_dk[13] = 13 //confin 2
//				ii_dk[14] = 14 //cencos
//				ii_dk[15] = 15 //cnta prsp
//				ii_dk[16] = 16 //flag_tipo_gasto
//				ii_dk[17] = 17 //nom_proveedor
//
//				/*	          */
//				ii_rk[1] = 1
//				ii_rk[2] = 2
//				ii_rk[3] = 3
//				ii_rk[4] = 4
//				ii_rk[5] = 5
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//				ii_rk[9] = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				ii_rk[14] = 14
//				ii_rk[15] = 15
//				ii_rk[16] = 16 //flag_tipo_gasto 
//				ii_rk[16] = 17 //nom_proveedor
//		 CASE 4,5	//ORDEN DE COMPRA ADELANTOS,ORDEN DE SERVICIO ADELANTOS,LIQUIDACION DE PAGO
//			
//				ii_dk[1] = 1
//				ii_dk[2] = 2
//				ii_dk[3] = 3
//				ii_dk[4] = 4
//				ii_dk[5] = 5
//				ii_dk[6] = 6
//				ii_dk[7] = 7
//			   ii_dk[8] = 8
//				
//				ii_rk[1] = 1
//				ii_rk[2] = 2
//				ii_rk[3] = 3
//				ii_rk[4] = 4
//				ii_rk[5] = 5
//				ii_rk[6] = 6
//				ii_rk[7] = 7
//				ii_rk[8] = 8
//				
//		CASE	6		//APLICACION DE DOCUMENTOS
//			 
//				ii_dk[1]  = 1
//				ii_dk[2]  = 2
//				ii_dk[3]  = 3
//				ii_dk[4]  = 4
//				ii_dk[5]  = 5
//				ii_dk[6]  = 6
//				ii_dk[7]  = 7
//			   ii_dk[8]  = 8
//				ii_dk[9]  = 9
//				ii_dk[10] = 10
//				ii_dk[11] = 11
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				
//				ii_rk[1]  = 1
//				ii_rk[2]  = 2
//				ii_rk[3]  = 3
//				ii_rk[4]  = 4
//				ii_rk[5]  = 5
//				ii_rk[6]  = 6
//				ii_rk[7]  = 7
//				ii_rk[8]  = 8
//				ii_rk[9]  = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				
//		 CASE	8  //Pre liquidacion de orden de giro
//				ii_dk[1]  = 1
//				ii_dk[2]  = 2
//				ii_dk[3]  = 3
//				ii_dk[4]  = 4
//				ii_dk[5]  = 5
//				ii_dk[6]  = 6
//				ii_dk[7]  = 7
//				ii_dk[8]  = 8
//				ii_dk[9]  = 9
//				ii_dk[10] = 10
//				ii_dk[11] = 11
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14
//				ii_dk[15] = 15
//				ii_dk[16] = 16
//				ii_dk[17] = 17
//				ii_dk[18] = 18
//				
//				ii_rk[1]  = 1
//				ii_rk[2]  = 2
//				ii_rk[3]  = 3
//				ii_rk[4]  = 4
//				ii_rk[5]  = 5
//				ii_rk[6]  = 6
//				ii_rk[7]  = 7
//				ii_rk[8]  = 8
//				ii_rk[9]  = 9
//				ii_rk[10] = 10
//				ii_rk[11] = 11
//				ii_rk[12] = 12
//				ii_rk[13] = 13
//				ii_rk[14] = 14				
//				ii_rk[15] = 15
//				ii_rk[16] = 16
//				ii_rk[17] = 17
//				ii_rk[18] = 18
//				
//				
//		 CASE 14 //devolucion de orden de giro
//				ii_dk[1]  = 1  //cod_relacion
//				ii_dk[2]  = 2  //tipo_doc
//				ii_dk[3]  = 3  //nro_doc
//				ii_dk[4]  = 4  //cod_moneda
//				ii_dk[5]  = 5  //fecha emision
//				ii_dk[6]  = 6  //tasa cambio
//				ii_dk[7]  = 7  //descripcion
//				ii_dk[8]  = 8  //saldo
//				ii_dk[9]  = 9  //nombre proveedor
//				ii_dk[10]  = 10  //cencos
//				ii_dk[11]  = 11  //cnta presup
//				ii_dk[12]  = 12  //Tipo Gasto
//				
//				ii_rk[1]  = 1  //cod_relacion
//				ii_rk[2]  = 2  //tipo_doc
//				ii_rk[3]  = 3  //nro_doc
//				ii_rk[4]  = 4  //cod_moneda
//				ii_rk[5]  = 5  //fecha emision
//				ii_rk[6]  = 6  //tasa cambio
//				ii_rk[7]  = 7  //descripcion
//				ii_rk[8]  = 8  //saldo
//				ii_rk[9]  = 9  //nombre proveedor
//				ii_rk[10]  = 10  //cencos
//				ii_rk[11]  = 11  //cnta presup
//				ii_rk[12]  = 12  //Tipo Gasto				
//				
//			  
//   	CASE 15,25    // Cartera de pagos
//								// Deploy key
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				ii_dk[6]  = 6		
//				ii_dk[7]  = 7      
//				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14				
//				ii_dk[15] = 15	
//				ii_dk[16] = 16
//				ii_dk[17] = 17
//				ii_dk[18] = 18
//				ii_dk[19] = 19
//				
//				ii_rk[1]  = 1		//codigo de relacion		
//				ii_rk[2]  = 2		//tipo doc		
//				ii_rk[3]  = 3		//nro doc		
//				ii_rk[4]  = 4		//flag tabla		
//				ii_rk[5]  = 5		//cnta ctbl
//				ii_rk[6]  = 6		//moneda
//				ii_rk[7]  = 7		//flag debhab
//				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen
//				ii_rk[13] = 13		//importe
//				ii_rk[14] = 14		//flag provisionado			  
//				ii_rk[15] = 15		//nom proveedor
//				ii_rk[16] = 16		//indicador planilla		
//				ii_rk[17] = 17		//tipo de cambio de provision
//				ii_rk[18] = 18		//Saldo Aplicado Soles				
//				ii_rk[19] = 19		//Saldo Aplicado Dolares				
//				
//				
//				
		 CASE 16    //	Liquidaciones de Pesca
								// Deploy key
								
				ii_ck[1]  = 1
				ii_ck[2] = 2
				ii_ck[3] = 3
				ii_ck[4] = 4
				ii_ck[5] = 5
				ii_ck[6] = 6
				ii_ck[7] = 7
				ii_ck[8] = 8

				ii_dk[1]  = 1		
				ii_dk[2]  = 2		
				ii_dk[3]  = 3		
				ii_dk[4]  = 4		
				ii_dk[5]  = 5		
				ii_dk[6]  = 6		
				ii_dk[7]  = 7      
				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14				
//				ii_dk[15] = 15	
//				ii_dk[16] = 16
				
				ii_rk[1]  = 1		//codigo de relacion		
				ii_rk[2]  = 2		//tipo doc		
				ii_rk[3]  = 3		//nro doc		
				ii_rk[4]  = 4		//flag tabla		
				ii_rk[5]  = 5		//cnta ctbl
				ii_rk[6]  = 6		//moneda
				ii_rk[7]  = 7		//flag debhab
				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen
//				ii_rk[13] = 13		//importe
//				ii_rk[14] = 14		//flag provisionado			  
//				ii_rk[15] = 15		//nom proveedor
//				ii_rk[16] = 16		//indicador planilla		
			   
//		 CASE 18    // Cartera de cobros
//										// Deploy key
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				ii_dk[6]  = 6		
//				ii_dk[7]  = 7      
//				ii_dk[8]  = 8      
//				ii_dk[9]  = 9      
//				ii_dk[10] = 10      
//				ii_dk[11] = 11      
//				ii_dk[12] = 12
//				ii_dk[13] = 13
//				ii_dk[14] = 14				
//				ii_dk[15] = 15
//				ii_dk[16] = 16
//				ii_dk[17] = 17
//				ii_dk[18] = 18
//				ii_dk[19] = 19				
//				
//				
//				ii_rk[1]  = 1		//codigo de relacion		
//				ii_rk[2]  = 2		//tipo doc		
//				ii_rk[3]  = 3		//nro doc		
//				ii_rk[4]  = 4		//flag tabla		
//				ii_rk[5]  = 5		//cnta ctbl
//				ii_rk[6]  = 6		//moneda
//				ii_rk[7]  = 7		//flag debhab
//				ii_rk[8]  = 8		//sldo sol
//				ii_rk[9]  = 9		//saldo dol
//				ii_rk[10] = 10		//fecha doc
//				ii_rk[11] = 11		//factor
//				ii_rk[12] = 12		//origen
//				ii_rk[13] = 13		//importe
//				ii_rk[15] = 15		//flag provisionado	
//				ii_rk[16] = 16		//flag planilla
//				ii_rk[17] = 17		//TIPO DE CAMBIO
//				ii_rk[18] = 18 	//saldo aplicado soles
//				ii_rk[19] = 19		//saldo aplicado dolares		
//				
//		 CASE 19    // Anticipo de Orden de Venta
//										// Deploy key
//				ii_dk[1]  = 1		
//				ii_dk[2]  = 2		
//				ii_dk[3]  = 3		
//				ii_dk[4]  = 4		
//				ii_dk[5]  = 5		
//				
//				
//				ii_rk[1]  = 1		//Origen
//				ii_rk[2]  = 2		//nro ov
//				ii_rk[3]  = 3		//flag estado
//				ii_rk[4]  = 4		//fec registro
//				ii_rk[5]  = 5		//monto total
//
//		 CASE 20    // Anticipo de Orden de compra
//										// Deploy key
//				ii_dk[1] = 1		
//				ii_dk[2] = 2		
//				ii_dk[3] = 3		
//				ii_dk[4] = 4		
//				ii_dk[5] = 5		
//				ii_dk[6] = 6		
//				ii_dk[7] = 7		
//				
//				
//				ii_rk[1] = 1		//Origen
//				ii_rk[2] = 2		//nro oc
//				ii_rk[3] = 3		//proveedor
//				ii_rk[4] = 4		//flag estado
//				ii_rk[5] = 5		//fec registro
//				ii_rk[6] = 6		//cod moneda
//				ii_rk[7] = 7		//monto total
//
//		 CASE 21    // Anticipo de Orden de Servicio
//										// Deploy key
//				ii_dk[1] = 1		
//				ii_dk[2] = 2		
//				ii_dk[3] = 3		
//				ii_dk[4] = 4		
//				ii_dk[5] = 5		
//				ii_dk[6] = 6		
//				ii_dk[7] = 7		
//				
//				
//				ii_rk[1] = 1		//Origen
//				ii_rk[2] = 2		//nro os
//				ii_rk[3] = 3		//proveedor
//				ii_rk[4] = 4		//flag estado
//				ii_rk[5] = 5		//fec registro
//				ii_rk[6] = 6		//cod moneda
//				ii_rk[7] = 7		//monto total
//
//		 CASE 22   // Programacion de pagos
//										// Deploy key
//				ii_dk[1] = 1	//cod_relacion	
//				ii_dk[2] = 2	//nom_proveedor
//				ii_dk[3] = 3	//tipo_doc			
//				ii_dk[4] = 4	//nro_doc	
//				ii_dk[5] = 5	//cod_moneda	
//				ii_dk[6] = 6	//saldo_sol	
//				ii_dk[7] = 7	//saldo_dol
//				ii_dk[8] = 8	//factor
//				ii_dk[9] = 9	//flag_tabla
//				
//				ii_rk[1] = 1	//cod_relacion	
//				ii_rk[2] = 2	//nom_proveedor
//				ii_rk[3] = 3	//tipo_doc			
//				ii_rk[4] = 4	//nro_doc	
//				ii_rk[5] = 5	//cod_moneda	
//				ii_rk[6] = 6	//saldo_sol	
//				ii_rk[7] = 7	//saldo_dol
//				ii_rk[8] = 8	//factor
//				ii_rk[9] = 9	//flag_tabla
//				
//		 CASE 23    // planilla de cobranza
//										// Deploy key
//				ii_dk[1]  = 1	//cod_relacion	
//				ii_dk[2]  = 2	//nom_proveedor
//				ii_dk[3]  = 3	//tipo_doc			
//				ii_dk[4]  = 4	//nro_doc	
//				ii_dk[5]  = 5	//cod_moneda	
//				ii_dk[6]  = 6	//saldo_sol	
//				ii_dk[7]  = 7	//saldo_dol
//				ii_dk[8]  = 8	//factor
//				ii_dk[9]  = 9	//flag_tabla
//				ii_dk[10] = 10	//flag_provisionado
//				ii_dk[11] = 11	//nro_deposito
//				ii_dk[12] = 12	//fecha_deposito
//				ii_dk[13] = 13	//referencia
//				
//				
//				ii_rk[1]  = 1	//cod_relacion	
//				ii_rk[2]  = 2	//nom_proveedor
//				ii_rk[3]  = 3	//tipo_doc			
//				ii_rk[4]  = 4	//nro_doc	
//				ii_rk[5]  = 5	//cod_moneda	
//				ii_rk[6]  = 6	//saldo_sol	
//				ii_rk[7]  = 7	//saldo_dol
//				ii_rk[8]  = 8	//factor
//				ii_rk[9]  = 9	//flag_tabla
//				ii_rk[10] = 10	//flag_provisionado
//				ii_rk[11] = 11	//nro_deposito
//				ii_rk[12] = 12	//fecha_deposito
//				ii_dk[13] = 13	//referencia			
//						
END CHOOSE
ii_ss = 0
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

event clicked;Long    ll_inicio,ll_found = 0,ll_row,ll_item,ll_row_count,ll_factor
String  ls_tipo_doc       ,ls_nro_doc      ,ls_let_x_pag ,ls_doc_sol_giro ,ls_flag_edit   ,&
		  ls_expresion      ,ls_doc_oc       ,ls_doc_os    ,ls_origen       ,ls_flag_estado ,&
		  ls_flag_estado_og ,ls_cod_relacion ,ls_cod_moneda,ls_soles        ,ls_dolares     ,&
		  ls_tipo_mov       ,ls_flag_tabla
Integer li_item,li_nro_sol_pend,li_nro_max
Decimal {2} ldc_importe,ldc_importe_cab,ldc_importe_det,ldc_saldo,ldc_saldo_sol,ldc_saldo_dol,&
				ldc_imp_total	

dw_2.Accepttext()

CHOOSE CASE is_param.opcion
				
		 CASE 16 	//Liquidaciones de pesca y pago
				of_procesa_liq_opc_16()
	
				
END CHOOSE

Closewithreturn(parent,is_param)
end event

