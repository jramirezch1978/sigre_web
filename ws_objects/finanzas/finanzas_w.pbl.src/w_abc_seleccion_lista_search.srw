$PBExportHeader$w_abc_seleccion_lista_search.srw
forward
global type w_abc_seleccion_lista_search from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_lista_search
end type
type uo_search from n_cst_search within w_abc_seleccion_lista_search
end type
end forward

global type w_abc_seleccion_lista_search from w_abc_list
integer x = 50
integer width = 3758
integer height = 2144
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
uo_search uo_search
end type
global w_abc_seleccion_lista_search w_abc_seleccion_lista_search

type variables
str_parametros is_param
DataStore ids_cntas_pagar_det,ids_cntas_cobrar_det,ids_imp_x_cobrar,&
			 ids_imp_x_cobrar_x_doc,ids_art_a_vender
end variables

forward prototypes
public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc)
public function long wf_find_guias (string as_cod_origen, string as_nro_guia)
public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio)
public function boolean of_opcion3 ()
public function boolean of_opcion20 ()
public function boolean of_opcion1 ()
public function boolean of_opcion21 ()
public function boolean of_opcion19 ()
public function boolean of_opcion22 ()
end prototypes

public function long wf_verifica_doc (string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public function long wf_find_guias (string as_cod_origen, string as_nro_guia);String ls_expresion,ls_tipo_doc
Long   ll_found = 0,ll_row


//***SELECCION DE TIPO DE DOC GUIA***//
SELECT doc_gr
  INTO :ls_tipo_doc
  FROM logparam
 WHERE reckey = '1' ;
//***********************************//

ls_expresion = 'origen_ref = '+"'"+as_cod_origen+"'"+'  AND  nro_ref = '+"'"+as_nro_guia+"'"
ll_found = is_param.dw_c.Find(ls_expresion, 1,is_param.dw_c.RowCount())	 

IF ll_found > 0 THEN
	Return ll_found
ELSE

	IF is_param.dw_c.triggerevent ('ue_insert') > 0 THEN
		/*Datos del Registro Modificado*/
	   /**/
		is_param.dw_c.Object.tipo_mov	    [ll_row] = 'C'
	   is_param.dw_c.Object.origen_ref 	 [ll_row] = as_cod_origen
	   is_param.dw_c.Object.tipo_ref		 [ll_row] = ls_tipo_doc
	   is_param.dw_c.Object.nro_ref		 [ll_row] = as_nro_guia
		is_param.dw_c.Object.flab_tabor	 [ll_row] = '9' //Guias de Remision
		Return ll_found
	END IF
END IF



end function

public function long wf_verifica_ed (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long   ll_found
String ls_expresion

ls_expresion = 'cod_relacion = '+"'"+as_cod_relacion+"'"+' AND tipo_doc = '+"'"+as_tipo_doc+"'"+' AND '+'nro_doc ='+"'"+as_nro_doc+"'"

ll_found 	 = is_param.dw_m.Find(ls_expresion,1,is_param.dw_m.Rowcount())


Return ll_found
end function

public subroutine wf_insert_articulos_x_vales (string as_cod_origen, string as_nro_guia, string as_cod_moneda, decimal adc_tasa_cambio);Long   ll_fdw_d,j,ll_found
String ls_soles, ls_dolares,ls_cod_art,ls_cod_moneda,ls_expresion,ls_tipo_doc,&
		 ls_item

Rollback;
DECLARE PB_USP_FIN_ADD_ART_X_GUIA_X_VALE PROCEDURE FOR USP_FIN_ADD_ART_X_GUIA_X_VALE
(:as_cod_origen,:as_nro_guia,:as_cod_moneda,:adc_tasa_cambio);
EXECUTE PB_USP_FIN_ADD_ART_X_GUIA_X_VALE ;




IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_ADD_ART_X_GUIA_X_VALE , Comunicar en Area de Sistemas' )
	RETURN
END IF


ids_art_a_vender.Retrieve()



//* Codigo de Moneda Soles y Dolares *//
SELECT cod_soles,cod_dolares
  INTO :ls_soles,:ls_dolares
  FROM logparam   
 WHERE reckey = '1'   ;
//***********************************// 


FOR j=1 TO ids_art_a_vender.Rowcount()
	 
	 ls_cod_art    = ids_art_a_vender.object.cod_art    [j] 
	 ls_cod_moneda = ids_art_a_vender.object.cod_moneda [j] 
	 
	 ls_expresion  = 'cod_art ='+"'"+ls_cod_art+"'"
	 ll_found      = is_param.dw_d.find(ls_expresion,1,is_param.dw_d.rowcount())
	 
	 IF ll_found > 0 THEN 
		 is_param.dw_d.Object.cantidad        [ll_found] = is_param.dw_d.Object.cantidad     [ll_found] + ids_art_a_vender.Object.cant_procesada [j]
		 is_param.dw_d.Object.cant_proyect    [ll_found] = is_param.dw_d.Object.cant_proyect [ll_found] + ids_art_a_vender.Object.cant_proyect   [j]
	 ELSE
	    IF is_param.dw_d.triggerevent ('ue_insert') > 0 THEN
			  
			 IF ls_cod_moneda = ls_soles      THEN
				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_soles   [j]
			 ELSEIF ls_cod_moneda = ls_dolares    THEN
				  is_param.dw_d.Object.precio_unitario [ll_fdw_d] = ids_art_a_vender.Object.precio_unit_dolares [j]
			 END IF
			 
			 is_param.dw_d.Object.cod_art         [ll_fdw_d] = ids_art_a_vender.Object.cod_art 			 [j]
			 is_param.dw_d.Object.descripcion     [ll_fdw_d] = ids_art_a_vender.Object.nom_articulo    [j]
			 is_param.dw_d.Object.cantidad        [ll_fdw_d] = ids_art_a_vender.Object.cant_procesada  [j]
			 is_param.dw_d.Object.cant_proyect    [ll_fdw_d] = ids_art_a_vender.Object.cant_proyect    [j]
			 is_param.dw_m.Object.moneda_det	     [1] 		 = is_param.string3
			 is_param.dw_m.Object.tasa_cambio_det [1] 		 = is_param.db2
			 is_param.dw_m.Object.cod_relacion_det[1] 	    = is_param.string2
			 is_param.dw_d.Object.confin			  [ll_fdw_d] = ids_art_a_vender.Object.confin 			 [j]
			 is_param.dw_d.Object.matriz_cntbl	  [ll_fdw_d] = ids_art_a_vender.object.matriz_cntbl    [j]
			 is_param.dw_d.Object.flag				  [ll_fdw_d] = 'G'	
			 is_param.dw_d.Object.tipo_cred_fiscal[ll_fdw_d] = ids_art_a_vender.object.tipo_cred_fiscal[j]
 			 is_param.dw_d.Object.rubro			  [ll_fdw_d] = ids_art_a_vender.object.rubro				 [j]
			 //Recalculo de Impuesto				 
			 ls_item = Trim(String(is_param.dw_d.Object.item  [ll_fdw_d]))
			 
			 is_param.dw_d.Modify("cantidad.Protect='1~tIf(IsNull(flag),0,1)'")
			 
		 END IF	
	 END IF	
NEXT





end subroutine

public function boolean of_opcion3 ();
Long			ll_inicio, ll_found, ll_row, ll_row_det, ll_row_imp, ll_inicio2, ll_item
String		ls_origen, ls_tipo_ref, ls_nro_Ref, ls_flag_tabor, ls_cod_Relacion, &
				ls_cod_moneda_det, ls_expresion, ls_cod_moneda, ls_origen_Ref, &
				ls_tipo_doc, ls_nro_doc, ls_flag_cab_det, ls_confin, ls_matriz_cntbl

Decimal 		ldc_tasa_cambio, ldc_precio_unit, ldc_importe
u_ds_base	lds_impuestos
u_dw_abc 	ldw_master, ldw_detail, ldw_referencia, ldw_impuestos

try 
	lds_impuestos = Create u_ds_base
	
	ldw_master 		= is_param.dw_m
	ldw_referencia = is_param.dw_d
	ldw_detail	  	= is_param.dw_c
	ldw_impuestos	= is_param.dw_e
	
	ldw_master.Accepttext()
	ldw_referencia.Accepttext()
	 
	ls_cod_moneda 		= ldw_master.object.cod_moneda 	[1] 
	ls_flag_cab_det	= ldw_master.object.flag_cab_det [1] 
	
	For ll_row = 1 TO dw_2.Rowcount()
		 
		//Motivo del Documento is_param.string3  
		IF is_param.string3 = 'NCP002' THEN //Reversión de Documento
			IF ldw_referencia.Rowcount()  > 0 THEN
				Messagebox('Aviso','No Puede Ingresar Mas De Un documento Cuando se '&
									 +'Trata de Reversión de Documento')
				return false	 					  
			END IF
		END IF
		
		ls_origen_ref	   		= dw_2.Object.origen		 	[ll_row]
		ls_tipo_ref	    			= dw_2.Object.tipo_doc     [ll_row]
		ls_nro_ref		   		= dw_2.Object.nro_doc      [ll_row]
		ls_flag_tabor	   		= dw_2.Object.flag_tabla   [ll_row]
		ls_cod_relacion   		= dw_2.Object.cod_relacion	[ll_row]
		ls_cod_moneda_det 		= dw_2.object.cod_moneda   [ll_row] 
		
		if IsNull(ls_cod_moneda) or trim(ls_cod_moneda) = '' then
			ls_cod_moneda = ls_cod_moneda_det
			
			ldw_master.object.cod_moneda 	[ldw_master.getRow()] = ls_cod_moneda
		end if
		
		ls_expresion = "origen_ref = '" + ls_origen_ref + "' AND tipo_ref = '" &
						+ ls_tipo_ref + "' AND nro_ref = '" + ls_nro_ref + "'"
		
		ll_found = ldw_referencia.find(ls_expresion, 1, ldw_referencia.rowcount())
		 
		IF ll_found = 0 THEN
			//**Moneda de Cabecera**//
			IF ls_cod_moneda <> ls_cod_moneda_det THEN
				//Si las monedas son diferentes entonces hago la pregunta al usuario
				if Messagebox( 'Aviso','Documento '+ls_tipo_ref+' '+ls_nro_ref &
							  +' Tiene Diferente Tipo de Moneda. Desea continuar?', Information!, Yesno!, 2) = 2 then								
					return false
				end if
			END IF
			
			select tasa_cambio 
				into :ldc_tasa_cambio 
				from cntas_pagar
			where cod_relacion 	= :ls_cod_relacion
			  and tipo_doc     	= :ls_tipo_ref
			  and nro_doc		 	= :ls_nro_ref;	 
			
			//DAtos en el maestro
			ldw_master.object.tasa_cambio				[1] = ldc_tasa_cambio
			ldw_master.object.clase_bien_serv		[1] = dw_2.Object.clase_bien_serv		[ll_row]
			ldw_master.object.desc_clase_bien_serv	[1] = dw_2.Object.desc_clase_bien_serv	[ll_row]
	
			ll_found = ldw_referencia.event ue_insert()
			
			if ll_found > 0 then
				ldw_referencia.object.cod_relacion 	[ll_found] = ls_cod_relacion
				ldw_referencia.object.tipo_doc	 	[ll_found] = ls_tipo_doc
				ldw_referencia.object.nro_doc		 	[ll_found] = ls_nro_doc
				ldw_referencia.object.tipo_mov     	[ll_found] = 'P'
				ldw_referencia.object.origen_ref   	[ll_found] = ls_origen_ref
				ldw_referencia.object.tipo_ref	  	[ll_found] = ls_tipo_ref
				ldw_referencia.object.nro_ref	    	[ll_found] = ls_nro_ref
				ldw_referencia.object.proveedor_ref	[ll_found] = ls_cod_relacion
				ldw_referencia.object.flab_tabor   	[ll_found] = ls_flag_tabor
			end if
		else
			ldc_tasa_cambio = Dec(ldw_master.object.tasa_cambio				[1])
		end if
	
		is_param.accion = 'aceptar'
		
		ll_row_det = ldw_detail.event ue_insert()
		if ll_row_det > 0 then
			ldw_detail.Object.cod_art         			[ll_row_det] = dw_2.Object.cod_art 			 		[ll_row]
			ldw_detail.Object.descripcion	   			[ll_row_det] = dw_2.Object.descripcion 	 		[ll_row]
			ldw_detail.Object.confin          			[ll_row_det] = dw_2.Object.confin 			 		[ll_row]
			ldw_detail.Object.cantidad        			[ll_row_det] = dw_2.Object.cantidad 		 		[ll_row]
			ldw_detail.Object.cencos          			[ll_row_det] = dw_2.Object.cencos 			 		[ll_row]
			ldw_detail.Object.cnta_prsp       			[ll_row_det] = dw_2.Object.cnta_prsp		 		[ll_row]
			ldw_detail.Object.centro_benef				[ll_row_det] = dw_2.Object.centro_benef	 		[ll_row]
			
			//Agrego el importe por el tipo de moneda
			ldc_importe 		= Dec(dw_2.Object.importe 			 		[ll_row])
			ldc_precio_unit	= Dec(dw_2.Object.precio_unit		 		[ll_row])
			
			if ls_cod_moneda_det <> ls_cod_moneda then
				if ls_cod_moneda = gnvo_app.is_soles then
					ldc_importe 		= ldc_importe * ldc_Tasa_cambio
					ldc_precio_unit 	= ldc_precio_unit * ldc_Tasa_cambio
				else
					ldc_importe 		= ldc_importe / ldc_Tasa_cambio
					ldc_precio_unit 	= ldc_precio_unit / ldc_Tasa_cambio
				end if
			end if
			
			//ASigno ya los importes modificados
			ldw_detail.Object.importe	      			[ll_row_det] = ldc_importe
			ldw_detail.Object.precio_unit     			[ll_row_det] = ldc_precio_unit
			
			
			if dw_2.of_existeCampo("tipo_cred_fiscal") then
				ldw_detail.Object.tipo_cred_fiscal		[ll_row_det] = dw_2.Object.tipo_cred_fiscal		[ll_row]
			end if
			
			if dw_2.of_existeCampo("desc_tipo_cred_fiscal") then
				ldw_detail.Object.desc_cred_fiscal		[ll_row_det] = dw_2.Object.desc_tipo_cred_fiscal[ll_row]
			end if
			
			if dw_2.of_existeCampo("matriz_cntbl") then
				ldw_detail.Object.matriz_cntbl			[ll_row_det] = dw_2.Object.matriz_cntbl	 		[ll_row]
			else
				ls_confin = dw_2.Object.confin 			[ll_row]
				
				select matriz_cntbl
					into :ls_matriz_cntbl
				from concepto_financiero cf
				where cf.confin = :ls_confin;
				
				if SQLCA.SQLCode = 100 then
					Messagebox( 'Aviso','El concepto financiero ' + ls_confin + ' no existe en la tabla concepto_financiero, por favor Verifique!', StopSign!)								
					return false
				end if
				
				if IsNull(ls_matriz_cntbl) or trim(ls_matriz_cntbl) = '' then
					Messagebox( 'Aviso','El concepto financiero ' + ls_confin + ' no tiene asociado ninguna matriz, por favor Verifique!', StopSign!)								
					return false
				end if
				
				ldw_detail.Object.matriz_cntbl				[ll_row_det] = ls_matriz_cntbl

			end if
			
			
			
			//Rerefencia de Orden de Compra
			if dw_2.of_existeCampo("org_oc") then
				ldw_detail.Object.org_oc				[ll_row_det] = dw_2.Object.org_amp_ref	 	[ll_row]
			end if
			if dw_2.of_existeCampo("item_oc") then
				ldw_detail.Object.item_oc				[ll_row_det] = dw_2.Object.nro_amp_ref	 	[ll_row]
			end if
			if dw_2.of_existeCampo("doc_oc") then
				ldw_detail.Object.doc_oc				[ll_row_det] = dw_2.Object.tipo_doc_amp 	[ll_row]
			end if
			if dw_2.of_existeCampo("nro_oc") then
				ldw_detail.Object.nro_oc				[ll_row_det] = dw_2.Object.nro_doc_amp	 	[ll_row]
			end if
			
			//Referencia de Vale_Mov
			if dw_2.of_existeCampo("org_am") then
				ldw_detail.Object.org_am				[ll_row_det] = dw_2.Object.org_am	 		[ll_row]
			end if
			if dw_2.of_existeCampo("nro_am") then
				ldw_detail.Object.nro_am				[ll_row_det] = dw_2.Object.nro_am	 		[ll_row]
			end if
			if dw_2.of_existeCampo("nro_Vale") then
				ldw_detail.Object.nro_Vale				[ll_row_det] = dw_2.Object.nro_Vale 		[ll_row]
			end if
			
			//Referencia a Orden de Servicio
			if dw_2.of_existeCampo("org_os") then
				ldw_detail.Object.org_os				[ll_row_det] = dw_2.Object.org_os	 		[ll_row]
			end if
			if dw_2.of_existeCampo("nro_os") then
				ldw_detail.Object.nro_os				[ll_row_det] = dw_2.Object.nro_os	 		[ll_row]
			end if
			if dw_2.of_existeCampo("item_os") then
				ldw_detail.Object.item_os				[ll_row_det] = dw_2.Object.item_os 			[ll_row]
			end if
			
			
		end if
		
		//** Datastore Impuesto Cuentas x Pagar Detalle **//
		if ls_flag_cab_det = 'D' then
			
			lds_impuestos.DataObject = 'd_list_impuestos_pagar_det_tbl'
			
			ls_cod_relacion 	= dw_2.object.cod_relacion [ll_row]
			ls_tipo_doc 		= dw_2.object.tipo_doc 		[ll_row]
			ls_nro_doc 			= dw_2.object.nro_doc 		[ll_row]
			ll_item 				= Long(dw_2.object.item 	[ll_row])
			
			lds_impuestos.SettransObject(sqlca)
			
			lds_impuestos.Retrieve(ls_cod_relacion, ls_tipo_doc, ls_nro_doc, ll_item)

		else
			
			lds_impuestos.DataObject = 'd_list_impuestos_pagar_cab_tbl'
			
			ls_cod_relacion 	= dw_2.object.cod_relacion [ll_row]
			ls_tipo_doc 		= dw_2.object.tipo_doc 		[ll_row]
			ls_nro_doc 			= dw_2.object.nro_doc 		[ll_row]

			lds_impuestos.SettransObject(sqlca)
			
			lds_impuestos.Retrieve(ls_cod_relacion, ls_tipo_doc, ls_nro_doc)
			
		end if
		
		//Elimino todo el detalle de impuestos
		ll_item = Long(ldw_detail.Object.item [ll_row_det])
		
		ls_expresion = "item=" + string(ll_item)
		ll_found = ldw_impuestos.find(ls_expresion, 1, ldw_impuestos.rowcount())
	
		do while ll_found > 0 
			ldw_impuestos.deleteRow(ll_found)
			ll_found = ldw_impuestos.find(ls_expresion, 1, ldw_impuestos.rowcount())
		loop
	
		
		/*Inserto detalle de Impuesto x Cntas x Pagar*/
		For ll_inicio2 = 1 TO lds_impuestos.Rowcount()
			ll_row_imp = ldw_impuestos.event ue_insert()
			
			if ll_row_imp > 0 then 
				ldw_impuestos.Object.item			  	[ll_row_det] = ll_item
				ldw_impuestos.Object.tipo_impuesto 	[ll_row_det] = lds_impuestos.Object.tipo_impuesto 	[ll_inicio2]
				ldw_impuestos.Object.tasa_impuesto 	[ll_row_det] = lds_impuestos.Object.tasa_impuesto 	[ll_inicio2]
				ldw_impuestos.Object.flag          	[ll_row_det] = 'S'
				ldw_impuestos.Object.cnta_ctbl		[ll_row_det] = lds_impuestos.Object.cnta_ctbl 	 	[ll_inicio2]
				ldw_impuestos.Object.desc_impuesto	[ll_row_det] = lds_impuestos.Object.desc_impuesto 	[ll_inicio2]
				ldw_impuestos.Object.signo				[ll_row_det] = lds_impuestos.Object.signo			 	[ll_inicio2]
				ldw_impuestos.Object.desc_cnta		[ll_row_det] =	lds_impuestos.Object.desc_cnta		[ll_inicio2]
				ldw_impuestos.Object.flag_dh_cxp		[ll_row_det] = lds_impuestos.Object.flag_dh_cxp	 	[ll_inicio2]
				
				//Agrego el importe por el tipo de moneda
				
					
				ldc_importe 		= Dec(lds_impuestos.Object.importe			[ll_inicio2])
				
				if ls_cod_moneda_det <> ls_cod_moneda then
					if ls_cod_moneda = gnvo_app.is_soles then
						ldc_importe 		= ldc_importe * ldc_Tasa_cambio
					else
						ldc_importe 		= ldc_importe / ldc_Tasa_cambio
					end if
				end if
				
				ldw_impuestos.Object.importe		   [ll_row_det] = ldc_importe

			end if
		Next
		
	Next
	
	
	RETURN TRUE

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, '')
	return false
	
finally
	destroy lds_impuestos
end try


end function

public function boolean of_opcion20 ();Long 		ll_i
String 	ls_codigo

delete tt_cntbl_cliente;
if gnvo_app.of_ExistsError(SQLCA) then
	 rollback;
	 return false
end if
commit;

for ll_i = 1 to dw_2.rowcount()
  	 ls_codigo      = dw_2.object.proveedor		[ll_i]
	 
	 insert into tt_cntbl_cliente (codigo)
	 values (:ls_codigo) ;
	 
	 if gnvo_app.of_ExistsError(SQLCA) then
		 rollback;
		 return false
	end if
next
		
return true
end function

public function boolean of_opcion1 ();Long 		ll_inicio
String	ls_codigo

delete tt_fin_proveedor;
if gnvo_app.of_existsError(SQLCA) then
	rollback;
	return false;
end if	


FOR ll_inicio = 1 TO dw_2.Rowcount()
	ls_codigo = dw_2.Object.codigo [ll_inicio]	 
	//Inserción de Proveedores
	Insert Into tt_fin_proveedor
	(cod_proveedor)  
	VALUES 
	(:ls_codigo)  ;
	
	if gnvo_app.of_existsError(SQLCA) then
		rollback;
		return false;
	end if	

	this.setmicrohelp( string(ll_inicio))
NEXT	

return true
end function

public function boolean of_opcion21 ();Long 		ll_i
String 	ls_codigo

delete tt_fin_tipo_doc;
if gnvo_app.of_ExistsError(SQLCA) then
	 rollback;
	 return false
end if
commit;

for ll_i = 1 to dw_2.rowcount()
  	 ls_codigo      = dw_2.object.tipo_doc		[ll_i]
	 
	 insert into tt_fin_tipo_doc (tipo_doc)
	 values (:ls_codigo) ;
	 
	 if gnvo_app.of_ExistsError(SQLCA) then
		 rollback;
		 return false
	end if
next
		
return true
end function

public function boolean of_opcion19 ();Long 		ll_inicio
String	ls_codigo

IF dw_2.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Algun Item ,Verifique!')
	Return false
END IF

delete tt_fin_tipo_doc;
if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla tt_fin_tipo_doc' ) then
	rollback;
	return false;
end if	

FOR ll_inicio = 1 TO dw_2.Rowcount ()
	ls_codigo	= dw_2.object.codigo  	  [ll_inicio]				 				
	
	
	Insert into tt_fin_tipo_doc(tipo_doc)
	Values (:ls_codigo) ;
	
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla tt_fin_tipo_doc' ) then
		rollback;
		return false;
	end if	
	
NEXT

return true
end function

public function boolean of_opcion22 ();Long 		ll_i, ll_new_row
String 	ls_codigo
u_dw_abc	ldw_master, ldw_detail

ldw_master 	= is_param.dw_m
ldw_detail	= is_param.dw_d

if dw_2.RowCount() = 0 then
	MessageBox('Error', 'Debe seleccionar los registros a tranferir', StopSign!)
	return false
end if

for ll_i = 1 to dw_2.rowcount()
	ll_new_row = ldw_detail.event ue_insert()
	if ll_new_row > 0 then
		ldw_detail.object.proveedor		[ll_new_row] = dw_2.Object.proveedor 		[ll_i]
		ldw_detail.object.nom_proveedor	[ll_new_row] = dw_2.Object.nom_proveedor 	[ll_i]
		ldw_detail.object.ruc_dni			[ll_new_row] = dw_2.Object.ruc_dni		 	[ll_i]
		ldw_detail.object.cencos			[ll_new_row] = dw_2.Object.cencos 			[ll_i]
		ldw_detail.object.desc_Cencos		[ll_new_row] = dw_2.Object.desc_Cencos 	[ll_i]
		ldw_detail.object.centro_benef	[ll_new_row] = dw_2.Object.centro_benef 	[ll_i]
		ldw_detail.object.desc_centro		[ll_new_row] = dw_2.Object.desc_centro 	[ll_i]
	end if
next
		
return true
end function

on w_abc_seleccion_lista_search.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.uo_search
end on

on w_abc_seleccion_lista_search.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.uo_search)
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

uo_search.of_set_dw(dw_1)

//Inicializar Variable de Busqueda //

IF Trim(is_param.tipo) = '' OR Isnull(is_param.tipo) THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_param.tipo
		CASE '1S'
			ll_row = dw_1.Retrieve( is_param.string1 )
		CASE '1L'
			ll_row = dw_1.Retrieve( is_param.long1 )
			
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


//** Datastore Cuentas x Cobrar Detalle **//
ids_cntas_cobrar_det = Create Datastore
ids_cntas_cobrar_det.DataObject = 'd_cntas_x_cobrar_det_tbl'
ids_cntas_cobrar_det.SettransObject(sqlca)
////** **//


//** Datastore Cuentas x Pagar Detalle **//
ids_cntas_pagar_det = Create Datastore
ids_cntas_pagar_det.DataObject = 'd_cntas_pagar_det_tbl'
ids_cntas_pagar_det.SettransObject(sqlca)
//** **//

//** Datastore Impuesto Cuentas x Pagar Detalle **//
//ids_imp_x_pagar = Create Datastore
//ids_imp_x_pagar.DataObject = 'd_list_impuestos_pagar_cab_tbl'
//ids_imp_x_pagar.SettransObject(sqlca)
//** **//

//** Datastore Impuesto Cuentas x Cobrar Detalle x Item **//
ids_imp_x_cobrar = Create Datastore
ids_imp_x_cobrar.DataObject = 'd_impuestos_x_cobrar_tbl'
ids_imp_x_cobrar.SettransObject(sqlca)
//** **//

//** Datastore Impuesto Cuentas x Cobrar Detalle x Todo el Documento **//
ids_imp_x_cobrar_x_doc = Create Datastore
ids_imp_x_cobrar_x_doc.DataObject = 'd_impuestos_x_cobrar_x_item_tbl'
ids_imp_x_cobrar_x_doc.SettransObject(sqlca)
//** **//

//** Datastore de Articulos a vender **//
ids_art_a_vender = Create Datastore
ids_art_a_vender.DataObject = 'd_tt_fin_art_a_vender_tbl'
ids_art_a_vender.SettransObject(sqlca)
//** **//


end event

event open;//override
THIS.EVENT ue_open_pre()
end event

event resize;call super::resize;//Posiciones 
dw_1.width = newwidth /2 - pb_1.width /2 - 10
dw_1.height = newheight - dw_1.y - 10

pb_1.x 	  = dw_1.width + 10
pb_2.x 	  = pb_1.x

dw_2.x 	  = pb_1.x + pb_1.width + 10

dw_2.width = dw_1.width
dw_2.height = dw_1.height

cb_transferir.x	= newwidth - cb_transferir.width - 10
uo_search.width 	= cb_transferir.x - 10 - uo_Search.x

uo_Search.event ue_resize(sizetype, cb_transferir.x - 10 - uo_Search.x, newheight)
end event

event close;call super::close;//** Datastore Cuentas x Cobrar Detalle **//
destroy ids_cntas_cobrar_det 
destroy ids_cntas_pagar_det
destroy ids_imp_x_cobrar 
destroy ids_imp_x_cobrar_x_doc 
destroy ids_art_a_vender 

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista_search
integer x = 0
integer y = 116
integer width = 517
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


ii_ss = 0
end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long 		ll_row, ll_count, ll_rc
integer 	li_x
Any 		la_id

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

// Asigna datos
idw_det.ScrollToRow(ll_row)

//return ll_row


end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista_search
integer x = 690
integer y = 116
integer width = 517
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1

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
integer x = 530
integer y = 436
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista_search
integer x = 530
integer y = 684
end type

type cb_transferir from commandbutton within w_abc_seleccion_lista_search
integer x = 3273
integer width = 297
integer height = 80
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

event clicked;Long   ll_inicio,ll_found,ll_row,ll_row_det,ll_item,ll_ins_row,ll_inicio_cab, &
		 ll_ins_row_det,ll_inicio_det,ll_ind_guia
		 
String ls_codigo,ls_expresion,ls_origen_ref,ls_tipo_ref,ls_nro_ref,&
       ls_flab_tabor,ls_cod_relacion,ls_cod_moneda,ls_cod_moneda_det,&
		 ls_cod_art,ls_confin,ls_descrip,ls_tipo_doc,ls_nro_doc,ls_tip_impuesto,&
		 ls_cnta_ctbl,ls_desc_impuesto,ls_signo,ls_desc_cnta,ls_matriz,&
		 ls_flag_dh  ,ls_cod_origen,ls_guia_rem,ls_cegreso,ls_null,ls_doc_cheque,&
		 ls_descripcion,ls_grupo,ls_desc_grupo,ls_ncredito,ls_ndebito,ls_doc_cab
		 
Decimal ldc_precio_unitario, ldc_cantidad_det, ldc_tasa_cambio, ldc_tasa_imp, ldc_imp_imp

dw_2.Accepttext()

select nota_credito, nota_debito 
	into :ls_ncredito, :ls_ndebito 
from finparam 
where reckey = '1' ;

CHOOSE CASE is_param.opcion
	CASE 1 //Programa de Pagos
		if not of_opcion1() then return
		
	CASE 2 //Bancos
		FOR ll_inicio = 1 TO dw_2.Rowcount()
			 ls_codigo = dw_2.Object.cod_banco [ll_inicio]	 
			 //Inserción de Proveedores
			 Insert Into tt_fin_banco
			 (cod_banco)  
			 VALUES 
			 (:ls_codigo)  ;
		NEXT	
		
	CASE 3 //NOTA DE CREDITO / DEBITO DEL PROVEEDOR
		IF not of_opcion3() THEN return
			
	CASE 5 //Reversion de documento x Nota de Credito

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
					  is_param.dw_d.Object.flag_int		   [ll_ins_row] = 'INT'
					  
				
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
				 ls_doc_cab = is_param.dw_m.object.tipo_doc [1]
				 
				 if trim(ls_doc_cab) = trim(ls_ncredito) then
	
					 /*busco tipo de cambio*/
					 select tasa_cambio into :ldc_tasa_cambio from cntas_cobrar
					  where (tipo_doc     = :ls_tipo_doc) and
							  (nro_doc		 = :ls_nro_doc ) ;	 
					 
					 is_param.dw_m.object.tasa_cambio [1] = ldc_tasa_cambio
	
					 
				 end if
	
				
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
		delete tt_fin_rpt_cta_bco;
		FOR ll_inicio = 1 TO dw_2.Rowcount()
				ls_codigo = dw_2.Object.cod_ctabco [ll_inicio]	 
				
				Insert Into tt_fin_rpt_cta_bco
				(cod_ctabco)  
				VALUES 
				(:ls_codigo)  ;
		NEXT
		
	CASE	10		
		delete tt_fin_origenes;
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
				 is_param.dw_m.object.item		        [ll_row] = ll_row
				 is_param.dw_m.object.origen_doc      [ll_row] = dw_2.object.origen	     [ll_inicio]
				 is_param.dw_m.object.cod_relacion    [ll_row] = dw_2.object.cod_relacion  [ll_inicio]
				 is_param.dw_m.object.tipo_doc        [ll_row] = dw_2.object.tipo_doc      [ll_inicio]
				 is_param.dw_m.object.nro_doc         [ll_row] = dw_2.object.nro_doc       [ll_inicio]
				 is_param.dw_m.object.cod_moneda_det  [ll_row] = dw_2.object.cod_moneda    [ll_inicio]
				 is_param.dw_m.object.cod_moneda_cab  [ll_row] = is_param.string4
				 is_param.dw_m.object.tasa_cambio     [ll_row] = is_param.field_ret_d3	  [1]
				 is_param.dw_m.object.importe         [ll_row] = dw_2.object.total_pagar   [ll_inicio]
				 is_param.dw_m.object.flab_tabor      [ll_row] = 'C'
				 is_param.dw_m.object.flag_flujo_caja [ll_row] = '1'
				 
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
			 ls_grupo 		= dw_2.object.grupo_art 	  [ll_inicio]				 				
			 ls_desc_grupo = dw_2.object.desc_grupo_art [ll_inicio]
			 
			 INSERT INTO tt_fin_rpt_art
			 (cod_art)
			 SELECT cod_art FROM rel_articulo_grupo WHERE grupo_art = :ls_grupo;
			 
			 is_param.titulo = ls_desc_grupo
		NEXT
		
	CASE 19 //TIPO DOCUMENTOS
		IF not of_opcion19() THEN return
				
	CASE 20 //Reporte
		if not of_opcion20() then return
		
	CASE 21 //Seleccion de tipo de Documentos CTACTE
		if not of_opcion21() then return

	CASE 22 //Opcion de DPDs Masivos
		if not of_opcion22() then return
		
END CHOOSE

is_param.i_return = 1
is_param.titulo = 's'
is_param.accion = "aceptar"

Closewithreturn(parent,is_param)
end event

type uo_search from n_cst_search within w_abc_seleccion_lista_search
event destroy ( )
integer width = 3241
integer taborder = 20
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

