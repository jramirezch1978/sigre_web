-------------------------------------------------------
-- Export file for user CANTABRIA@HADES              --
-- Created by jramirez on 15/05/2026, 08:07:36 p. m. --
-------------------------------------------------------

set define off
spool packages_cantabria.log

prompt
prompt Creating package EDG_SEGURIDAD
prompt ==============================
prompt
create or replace package cantabria.edg_seguridad is

  -- Author  : EMORANTE
  -- Created : 04/08/2005 11:29:10 a.m.
  -- Purpose : generar un crosstab

  -- Public type declarations
--  type <TypeName> is <Datatype>;

  -- Public constant declarations
--  <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
--  <VariableName> <Datatype>;

  -- Public function and procedure declarations
--  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
   procedure usp_crea_tabla ;
   procedure usp_roles ( as_sistema in string );
   procedure usp_busca_col ( as_role in string, as_objeto in string, as_permiso in string );
   procedure usp_usuarios ;
   procedure usp_objetos ;
   function  usf_suma_permisos ( as_base in string, as_adic in string) return string ;
   procedure usp_accesos_netos ( as_sistema in string ) ;


end edg_seguridad;
/

prompt
prompt Creating package INDEXBY
prompt ========================
prompt
CREATE OR REPLACE PACKAGE CANTABRIA.IndexBy AS
  TYPE NumTab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
END IndexBy;
/

prompt
prompt Creating package PKG_ALMACEN
prompt ============================
prompt
create or replace package cantabria.PKG_ALMACEN is

  -- Author  : JRAMIREZ
  -- Created : 04/08/2015 11:32:30 a.m.
  -- Purpose : Funciones y procedimientos de Almacen
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_ing_ajuste_inventario   vale_mov.tipo_mov%TYPE;
  is_sal_ajuste_inventario   vale_mov.tipo_mov%TYPE;
  
  is_ing_ajuste_valorizacion  vale_mov.tipo_mov%TYPE;
  is_sal_ajuste_valorizacion  vale_mov.tipo_mov%TYPE;
  
  is_ing_devolucion_vta      vale_mov.tipo_mov%TYPE;
  
  is_doc_alm                 doc_tipo.tipo_doc%TYPE;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  function USF_ALM_SDO_ANTERIOR(adi_fecha   in date,
                                asi_almacen in almacen.almacen%TYPE,
                                asi_cod_art in articulo.cod_art%TYPE,
                                asi_val_ret in char
  ) return number;
  
  function of_get_cant_despachada(asi_nro_guia in guia.nro_guia%TYPE
  ) return number;
  
  -- Obtengo el centro de Costos y Cuenta Presupuestal
  -- lc_reg.cod_art, ls_tipo_mov, ls_cencos, ls_cnta_prsp
  function of_get_cencos_cnta_prsp(
           asi_cod_art   in  articulo.cod_art%TYPE,
           asi_tipo_mov  in  articulo_mov_tipo.tipo_mov%TYPE,
           aso_Cencos    out articulo_mov.cencos%TYPE,
           aso_Cnta_prsp out articulo_mov.cnta_prsp%TYPE
  ) return number;

  function of_get_cant_facturada(asi_nro_guia in guia.nro_guia%TYPE
  ) return number;
  
  function of_get_cant_facturada(asi_org_am   in articulo_mov.cod_origen%TYPE,
                                 ani_nro_am   in articulo_mov.nro_mov%TYPE
  ) return number;
  
  function of_get_nro_vale(
           asi_origen   in num_tablas.origen%TYPE,
           asi_flag_hex in varchar2
  ) return varchar2;
  
  /*************************/  
  -- Procedimientos
  /*************************/
  
  -- Este procedimiento traslada los movimientos de flota propia a almacen de materia prima
  PROCEDURE sp_traslada_fp_alm_mp(ani_year   in number, 
                                  ani_mes    in number, 
                                  asi_user   in usuario.cod_usr%TYPE);
  
  -- Este procedimiento procesa el inventario por conteo y lo traslada a una fecha especifica, como movimiento 
  -- de inventario inicial o ajuste de inventario
  PROCEDURE sp_ajusta_inv_time_line(asi_almacen    inventario_conteo.almacen%TYPE, 
                                    ani_conteo     inventario_conteo.nro_conteo%TYPE, 
                                    adi_fec_conteo inventario_conteo.fec_conteo%TYPE,
                                    adi_time_line  date,
                                    asi_cod_usr    usuario.cod_usr%TYPE);

  -- Este procedimiento procesa el inventario por conteo y lo traslada a una fecha especifica
  PROCEDURE sp_ajusta_invent_conteo(asi_almacen    inventario_conteo.almacen%TYPE, 
                                    ani_conteo     inventario_conteo.nro_conteo%TYPE, 
                                    adi_fec_conteo inventario_conteo.fec_conteo%TYPE,
                                    asi_cod_usr    usuario.cod_usr%TYPE);  
  
  PROCEDURE sp_ajusta_alm_vtas(ani_year       number,
                               ani_mes        number,
                               asi_cod_usr    usuario.cod_usr%TYPE);
  
  -- Este procedimiento actualiza el saldo total
  PROCEDURE sp_act_saldo_all(
         asi_nada             in  string
  );

  -- Crea los movimientos de AJUSTE cuando se haga el movimiento de almacen se haga negativo
  -- y lo pone como Ajuste de Inventario en el mismo dia, pero en el primer minuto del dia
  PROCEDURE sp_crea_mov_ajuste(
            ani_year       number,
            ani_mes        number,
            asi_cod_usr    usuario.cod_usr%TYPE
   );    
   
   -- Crear un movimiento de Salida e ingreso por transformación de manera automatica, con el 
   -- prefijo de TX - Transformación
   procedure sp_mov_transformacion(
             asi_almacen       in almacen.almacen%TYPE,
             asi_cod_art       in articulo.cod_art%TYPE,
             adi_fecha         in date,
             asi_nro_proforma  in proforma_det.nro_proforma%TYPE,
             ani_item_proforma in proforma_det.nro_item%TYPE,
             ani_cant_und1     in articulo_mov.cant_procesada%TYPE,
             ani_cant_und2     in articulo_mov.cant_proc_und2%TYPE,
             asi_vendedor      in vale_mov.vendedor%TYPE,
             asi_usuario       in usuario.cod_usr%TYPE
   );

   -- Ajustar automaticamente el almacen, tomando como base el inventario_pallets, que se toma con el PDA
   -- y por ahora solo sirve para CONSERVAS
   procedure sp_ajuste_inventario_pallets(
             asi_almacen       in almacen.almacen%TYPE,
             adi_fecha         in date,
             asi_usuario       in usuario.cod_usr%TYPE
   ); 
   
   -- Ajuste Mensual de saldos por Almacen
   /*
      Este proceso hace un ajuste mensual
      1.- Si la cantidad und1 es negativa, hace un ajuste por cantidad und1
      2.- Si la cantidad und2 es negativa o no cuadra con la cantidad und1, hace un ajuste en cantidad und2
      3.- Si el importe es negativo en valor hace un ajuste por valor
   */
   procedure sp_ajuste_mensual(
             ani_year          in number,
             ani_mes           in number,
             asi_usuario       in usuario.cod_usr%TYPE
   );
   
   --Procedimiento que cierra mensualmente al almacen
   procedure sp_cierre_mensual(
             ani_year          in number,
             ani_mes           in number,
             asi_usuario       in usuario.cod_usr%TYPE
   );  
   
   --Procedimiento que cierra mensualmente al almacen
   procedure sp_ajusta_matriz_cntbl(
             ani_year          in number,
             ani_mes           in number
   );   
                                        

end PKG_ALMACEN;
/

prompt
prompt Creating package PKG_COMERCIALIZACION
prompt =====================================
prompt
create or replace package cantabria.PKG_COMERCIALIZACION is

  -- Author  : JRAMIREZ
  -- Created : 12/04/2018 04:50:42 p.m.
  -- Purpose : 
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  --function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  
  -- Procedimientos
  procedure sp_procesa_letras_terrenos(asi_nada varchar2);
  
  -- Obtengo el estado de la letra
  /*
     0. Anulado
     1. Generado
     2. Facturado - Pendiente de PAgo
     3. Pagado
     5. pendiente
     6. Bloqueado
  */
  function of_estado_letra(
            asi_tipo_doc       in cntas_cobrar.tipo_doc%TYPE,
            asi_nro_doc        in cntas_cobrar.nro_doc%TYPE
        ) return varchar2;
  
  procedure sp_chg_periodo_prov(
       asi_cod_relacion     in proveedor.proveedor%TYPE,
       asi_tipo_doc         in doc_tipo.tipo_doc%TYPE,
       asi_nro_doc          in cntas_pagar.nro_doc%TYPE,
       ani_year             in cntbl_asiento.ano%TYPE,
       ani_mes              in cntbl_asiento.mes%TYPE,
       ani_nro_libro        in cntbl_libro.nro_libro%TYPE
  ) ;
  
  -- Public function and procedure declarations
  function of_get_puerto_origen(as_tipo_doc cntas_cobrar.tipo_doc%TYPE, 
                                as_nro_doc  cntas_cobrar.nro_doc%TYPE) return varchar2;
  
  function of_get_puerto_destino(as_tipo_doc cntas_cobrar.tipo_doc%TYPE, 
                                 as_nro_doc  cntas_cobrar.nro_doc%TYPE) return varchar2;
	
  -- Guias de remision por Orden de Venta
  function of_guias_remision(asi_nro_ov orden_venta.nro_ov%TYPE) return varchar2;   
  
  -- Procedure para validar el credito
  function sp_validar_linea_credito(
       asi_cod_relacion     in proveedor.proveedor%TYPE,
       ani_imp_soles        in cntas_cobrar.saldo_sol%TYPE,
       ani_imp_dolar        in cntas_cobrar.saldo_dol%TYPE
  ) return number;
        
                          
end PKG_COMERCIALIZACION;
/

prompt
prompt Creating package PKG_CONFIG
prompt ===========================
prompt
create or replace package cantabria.PKG_CONFIG is

  -- Author  : JRAMIREZ
  -- Created : 14/04/2015 05:49:44 p.m.
  -- Purpose : Funciones para obtener parametros de la tabla CONFIG
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  function USF_GET_PARAMETER(asi_parameter  IN configuracion.parametro%TYPE) return date;
  function USF_GET_PARAMETER(asi_parameter  IN configuracion.parametro%TYPE, asi_default in configuracion.valor_char%TYPE) return varchar2;
  function USF_GET_PARAMETER(asi_parameter  IN configuracion.parametro%TYPE, 
                             ani_default    in configuracion.valor_int%TYPE) return number;
  function USF_GET_PARAMETER_dec(asi_parameter  IN configuracion.parametro%TYPE, 
                                 ani_default    in configuracion.valor_dec%TYPE) return number;
  function LAST_DAY(ani_mes  number, ani_year  number) return date;
  
  -- Funcion para la generacion del asiento contable
  function OF_MATRIZ_VTA(asi_tipo_doc in doc_tipo.tipo_doc%TYPE, asi_sub_cat in articulo_sub_categ.cod_sub_cat%TYPE, asi_moneda in moneda.cod_moneda%TYPE, asi_default in vta_config.valor%TYPE) return varchar2;
  function OF_CENCOS_VTA(asi_tipo_doc in doc_tipo.tipo_doc%TYPE, asi_sub_cat in articulo_sub_categ.cod_sub_cat%TYPE, asi_moneda in moneda.cod_moneda%TYPE, asi_default in vta_config.valor%TYPE) return varchar2;
  function OF_CENTRO_BENEF_VTA(asi_tipo_doc in doc_tipo.tipo_doc%TYPE, asi_sub_cat in articulo_sub_categ.cod_sub_cat%TYPE, asi_moneda in moneda.cod_moneda%TYPE, asi_default in vta_config.valor%TYPE) return varchar2;

  -- Función para obtener datos de la empresa
  function OF_RAZON_SOCIAL_EMPRESA(asi_empresa in varchar2) return varchar2;
  function OF_RUC_EMPRESA(asi_empresa in varchar2) return varchar2;
  function OF_DIRECCION_EMPRESA(asi_empresa in varchar2) return varchar2;
  function OF_DIRECCION_EMPRESA(asi_empresa in varchar2, asi_origen in origen.cod_origen%TYPE) return varchar2;
  function OF_FONO_FIJO_EMPRESA(asi_empresa in varchar2) return varchar2;
  function OF_CELULAR_EMPRESA(asi_empresa in varchar2) return varchar2;
  
end PKG_CONFIG;
/

prompt
prompt Creating package PKG_FACT_ELECTRONICA
prompt =====================================
prompt
create or replace package cantabria.pkg_fact_electronica is

  -- Author  : JRAMIREZ
  -- Created : 01/12/2016 10:35:37 p.m.
  -- Purpose : Generacion del comprobante electronico
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_grp_mercaderia        grupo_contable.grp_cntbl%TYPE;
  is_matriz_VS000          matriz_cntbl_finan.matriz%TYPE;
  is_ncc_devol_total       motivo_nota.motivo%TYPE;
  is_ncc_devol_parcial     motivo_nota.motivo%TYPE;
  IS_DOC_VALE_DCSTO        doc_tipo.tipo_doc%TYPE;
  is_banco_caja            banco.cod_banco%TYPE;
  
  -- Formas de Pago
  is_fp_pcon               finparam.pago_contado%TYPE;
  is_fp_F30d               forma_pago.forma_pago%TYPE;
  
  -- Libros contables necesarios
  il_libro_ventas          finparam.libro_ventas%TYPE;
  il_libro_cobranzas       finparam.libro_cobranzas%TYPE;
  il_libro_prov_vd         cntbl_libro.nro_libro%TYPE;
  il_libro_pagos           finparam.libro_pagos%TYPE;
  il_libro_caja_egr        cntbl_libro.nro_libro%TYPE;
  il_libro_caja_ing        cntbl_libro.nro_libro%TYPE;
  il_libro_prov_aplic      cntbl_libro.nro_libro%TYPE;
  
  -- Concepto Financiero Pago Generico
  is_confin_FI001          concepto_financiero.confin%TYPE;
  
  -- Cuentas Contables para las diferentes cajas, Efectivo y Tarjetas de credito
  is_cc_efectivo_mn        cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_efectivo_me        cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_tarjeta_visa       cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_tarjeta_mast       cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_tarjeta_din_club   cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_tarjeta_estilos    cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_tarjeta_american   cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_igv_gasto          cntbl_cnta.cnta_ctbl%TYPE;
  is_cntbl_cnta_vd         cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_dscto_institucion  cntbl_cnta.cnta_ctbl%TYPE;
  
  -- Consignacion
  is_cc_consig_mn          cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_consig_me          cntbl_cnta.cnta_ctbl%TYPE;
  
  -- Letras
  is_cc_ltc_mn             cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_ltc_me             cntbl_cnta.cnta_ctbl%TYPE;
  
  is_doc_efectivo          doc_tipo.tipo_doc%TYPE;
  is_doc_tarjeta           doc_tipo.tipo_doc%TYPE;
  is_doc_ov                doc_tipo.tipo_doc%TYPE;
  is_doc_gr                doc_tipo.tipo_doc%TYPE;
  
  -- Nota Contabilidad x cobrar
  is_doc_ncnc              doc_tipo.tipo_doc%TYPE;
  -- Letras por Cobrar
  is_doc_ltc               finparam.doc_letra_cobrar%TYPE;
  
  -- matriz contables por defecto
  is_matriz_int_sol        matriz_cntbl_finan.matriz%TYPE;
  is_matriz_int_dol        matriz_cntbl_finan.matriz%TYPE;
  is_serv_interes          servicios_cxc.cod_servicio%TYPE;
  is_serie_bvc_int         num_doc_tipo.nro_serie%TYPE;
  is_Serie_fvc_int         num_doc_tipo.nro_serie%TYPE;
  
  -- Impuesto por consumo de bolsa plastica
  is_icbper                impuestos_tipo.tipo_impuesto%TYPE;
  
  is_doc_prof              doc_tipo.tipo_doc%TYPE := 'PROF';
  
  /*******************************************************************************
  FUNCIONES 
  ---------
  *******************************************************************************/
  -- Function para obtener el numero de documento simplificado
  function of_get_nro_doc(as_serie in fs_factura_simpl.serie_cxc%TYPE, as_nro_doc in fs_factura_simpl.nro_cxc%TYPE) return varchar2;
  -- Function para obtener el nro de Serie de un Numero de documento completo
  function of_get_serie(as_nro_doc in cntas_cobrar.nro_doc%TYPE) return varchar2 ;
  -- Function para obtener el nro de Documento
  function of_get_nro(as_nro_doc in cntas_cobrar.nro_doc%TYPE) return varchar2;
  -- Function para obtener el nro completo del Documento
  function of_get_full_nro(as_nro_doc in cntas_cobrar.nro_doc%TYPE) return varchar2;
  -- Function para obtener la forma de pago de la factura simplificada
  function of_get_forma_pago(as_nro_registro in fs_factura_simpl.nro_registro%TYPE) return varchar2;
  -- Function que devuelve la cuenta contable del banco, y ademas lo crea
  function of_get_cod_ctabco(
           asi_flag_forma_pago  in fs_factura_simpl_pagos.flag_forma_pago%TYPE,
           asi_tipo_tarjeta     in fs_factura_simpl_pagos.tipo_tarjeta%TYPE,
           asi_origen           in fs_factura_simpl.cod_origen%TYPE,
           asi_tipo_doc         in fs_factura_simpl.tipo_doc_cxc%TYPE,
           asi_nro_doc          in fs_factura_simpl.nro_doc_cxc%TYPE,
           asi_moneda           in fs_factura_simpl.cod_moneda%TYPE,
           aso_cnta_cntbl       out cntbl_cnta.cnta_ctbl%TYPE,
           aso_desc_cnta_cntbl  out cntbl_cnta.desc_cnta%TYPE
  )return banco_cnta.cod_ctabco%TYPE;
  
  -- Function para obtener la forma de pago de la factura simplificada
  function of_get_cod_forma_pago(
    asi_nro_registro       in  fs_factura_simpl.nro_registro%TYPE,
    ado_fec_vencimiento    out cntas_cobrar.fecha_vencimiento%TYPE
  ) return forma_pago.forma_pago%TYPE;
  
  /*******************************************************************************
  PROCEDIMIENTOS 
  ---------
  *******************************************************************************/
  
  -- Public function and procedure declarations
  procedure sp_cxc_factura_smpl    (asi_registro fs_factura_simpl.nro_registro%TYPE );
  procedure sp_fs_vale_almacen     (asi_registro fs_factura_simpl.nro_registro%TYPE );
  procedure sp_fs_asiento_contable (asi_registro fs_factura_simpl.nro_registro%TYPE );
  procedure sp_fs_cntas_cobrar	   (asi_registro fs_factura_simpl.nro_registro%TYPE );
  procedure sp_anular_fs_simpl     (asi_registro fs_factura_simpl.nro_registro%TYPE );
  -- Proceso que genera la aplicacion de la nota de credito en el pago de la factura
  procedure of_aplicacion_ncc_fs_simpl(asi_nro_registro      fs_factura_simpl_pagos.nro_registro%TYPE,
                                       asi_flag_forma_pago   fs_factura_simpl_pagos.flag_forma_pago%TYPE,
                                       ani_nro_item          fs_factura_simpl_pagos.nro_item%TYPE,
                                       asi_cod_usr           fs_factura_simpl_pagos.cod_usr%TYPE);
  
  -- Procedimientos para la generacion del pago
  procedure sp_tesoreria_fact_smpl(asi_registro fs_factura_simpl.nro_registro%TYPE );
  procedure sp_cart_cob_asiento_cntbl(asi_registro fs_factura_simpl.nro_registro%TYPE );
  
  -- Descuento Cuenta Corriente del Trabajador
  procedure of_descuento_cnta_crrte(asi_registro in fs_factura_simpl.nro_registro%TYPE,
                                    asi_cod_usr  in usuario.cod_usr%TYPE );
  
  -- Procedimientos para procesos masivos
  procedure sp_procesar_periodo(ani_year number, ani_mes number);
  procedure sp_procesar_dia(adi_Fecha date);
  
  -- Generacion asiento de aplicacion de los descuentos
  procedure sp_aplicacion_anticipo(
      asi_nro_registro  fs_factura_simpl_det.nro_registro%TYPE,
      ani_nro_item      fs_factura_simpl_det.nro_item%TYPE,
      asi_tipo_doc      cntas_cobrar.tipo_doc%TYPE,
      asi_nro_doc       cntas_cobrar.nro_doc%TYPE,
      asi_origen        cntbl_asiento.origen%TYPE,
      ani_year          cntbl_asiento.ano%TYPE,
      ani_mes           cntbl_asiento.mes%TYPE,
      ani_nro_libro     cntbl_asiento.nro_libro%TYPE,
      ani_nro_Asiento   cntbl_asiento.nro_asiento%TYPE,
      asi_cod_usr       fs_factura_simpl_pagos.cod_usr%TYPE);
      
  -- Generacion del asiento de provision del vale de descuento
  procedure sp_provision_vale_dscto(asi_vale_vd        zc_vales_descuento.nro_vale_vd%TYPE, 
                                    ani_base_imponible cntbl_asiento_det.imp_movsol%TYPE, 
                                    ani_igv            cntbl_asiento_det.imp_movsol%TYPE,
                                    asi_nro_registro   fs_factura_simpl_det.nro_registro%TYPE,
                                    ani_nro_item       fs_factura_simpl_det.nro_item%TYPE,
                                    asi_descripcion    fs_factura_simpl_det.descripcion%TYPE,
                                    asi_cod_usr        fs_factura_simpl.cod_usr%TYPE);
  
  -- Proceso de la consignacion, genero el asiento y el canje de documento por cobrar
  procedure of_procesar_consignacion(asi_nro_registro      fs_factura_simpl_pagos.nro_registro%TYPE,
                                     asi_flag_forma_pago   fs_factura_simpl_pagos.flag_forma_pago%TYPE,
                                     ani_nro_item          fs_factura_simpl_pagos.nro_item%TYPE,
                                     asi_consignatario     consignatarios.consignatario%TYPE,
                                     asi_cod_usr           fs_factura_simpl_pagos.cod_usr%TYPE);

  -- Proceso de credito directo, genero las letras por cobrar
  procedure of_procesar_cred_directo(asi_nro_registro      fs_factura_simpl_pagos.nro_registro%TYPE,
                                     asi_flag_forma_pago   fs_factura_simpl_pagos.flag_forma_pago%TYPE,
                                     ani_nro_item          fs_factura_simpl_pagos.nro_item%TYPE,
                                     asi_cod_usr           fs_factura_simpl_pagos.cod_usr%TYPE);
                                     
  -- Genero el documento y el asiento por ingresos por interes
  procedure of_Generar_cxc_interes(asi_nro_registro      in fs_factura_simpl_pagos.nro_registro%TYPE,
                                   asi_flag_forma_pago   in fs_factura_simpl_pagos.flag_forma_pago%TYPE,
                                   ani_nro_item          in fs_factura_simpl_pagos.nro_item%TYPE,
                                   ani_total_interes     in cntas_cobrar.importe_doc%TYPE,
                                   asi_cod_usr           in fs_factura_simpl_pagos.cod_usr%TYPE,
                                   aso_tipo_doc_interes  out fs_factura_simpl_pagos.tipo_doc_interes%TYPE,
                                   aso_nro_doc_interes   out fs_factura_simpl_pagos.nro_doc_interes%TYPE);


  -- Anulo el comprobante de ventas
  procedure of_anular_cxc(asi_tipo_doc      in cntas_cobrar.tipo_doc%TYPE,
                          asi_nro_doc       in cntas_cobrar.nro_doc%TYPE);

  -- Anulo el pago y todo lo que esta asociado
  procedure sp_anular_pago_fs_simpl(
     asi_registro    in fs_factura_simpl_pagos.nro_registro%TYPE,
     asi_forma_pago  in fs_factura_simpl_pagos.flag_forma_pago%TYPE,
     ani_nro_item    in fs_factura_simpl_pagos.nro_item%TYPE
            
  );
                          
  -- Anulo el comprobante de interes que esta demas
  procedure sp_anular_ce_interes(
     asi_nada        in char
  );
  
  -- Corrige los comprobantes electronicos que estan defectuosos y los elimina
  ----------------------------------------------------------------------------
  procedure sp_corregir_ce_defectuosos(
     asi_nada        in char
  );
  
  -- Para procesar proformas y Crear las OV - VS - GR - FAC / BVC
  ----------------------------------------------------------------------------
  procedure sp_procesar_proforma(
     asi_nro_proforma        in proforma.nro_proforma%TYPE,
     asi_serie_gr            in num_doc_tipo.nro_serie%TYPE,
     asi_serie_ce            in num_doc_tipo.nro_serie%TYPE,
     asi_prov_transp         in guia.prov_transp%TYPE,
     asi_nom_chofer          in guia.nom_chofer%TYPE,
     asi_motivo_traslado     in guia.motivo_traslado%TYPE,
     asi_nro_brevete         in guia.nro_brevete%TYPE,
     asi_nro_placa           in guia.nro_placa%TYPE,
     asi_nro_placa_carreta   in guia.nro_placa_carreta%TYPE,
     asi_marca_vehiculo      in guia.marca_vehiculo%TYPE,
     asi_cert_insc_mtc       in proveedor.cert_insc_mtc%TYPE,
     adi_fec_inicio_traslado in guia.fec_inicio_traslado%TYPE,
     asi_observaciones       in guia.obs%TYPE,
     asi_usuario             in guia.cod_usr%TYPE
  );
  
  -- Anular la proforma
  ----------------------------------------------------------------------------
  procedure sp_anular_proforma(
     asi_nro_proforma        in proforma.nro_proforma%TYPE
  );


end pkg_fact_electronica;
/

prompt
prompt Creating package PKG_LOGISTICA
prompt ==============================
prompt
create or replace package cantabria.PKG_LOGISTICA is

  -- Author  : JRAMIREZ
  -- Created : 06/11/2014 12:22:52 p.m.
  -- Purpose : Paquete con funciones de Logistica
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_soles    logparam.cod_soles%TYPE;
  is_dolares  logparam.cod_dolares%TYPE;
  is_euros    moneda.cod_moneda%TYPE;
  is_oper_cons_int   logparam.oper_cons_interno%TYPE;
  is_oper_ing_oc     logparam.oper_ing_oc%TYPE;  
  is_oper_ing_prod   logparam.oper_ing_prod%TYPE; 
  is_oper_vnta_terc  logparam.oper_vnta_terc%TYPE;
  is_oper_vnta_nac_sinov  articulo_mov_tipo.tipo_mov%TYPE;
  is_oper_vnta_mat   logparam.oper_vnta_mat%TYPE;
  is_doc_oc          logparam.doc_oc%TYPE;
  is_prsp_cnta_vta_mp  presupuesto_cuenta.cnta_prsp%TYPE; 
  
  -- Impuestos
  is_igv             logparam.cod_igv%TYPE;

  -- Public function and procedure declarations
  function of_get_dir_comercial(as_proveedor proveedor.proveedor%TYPE) return varchar2;
  function of_get_direccion (as_proveedor proveedor.proveedor%TYPE, an_item direcciones.item%TYPE) return varchar2;
  function of_get_direccion (asi_origen origen.cod_origen%TYPE) return varchar2;
  
  -- Funciones para la facturación electronica
  function of_get_urbanizacion(as_proveedor proveedor.proveedor%TYPE) return varchar2;
  function of_get_distrito(as_proveedor proveedor.proveedor%TYPE) return varchar2;
  function of_get_provincia(as_proveedor proveedor.proveedor%TYPE) return varchar2;
  function of_get_departamento(as_proveedor proveedor.proveedor%TYPE) return varchar2;
  function of_get_pais(as_proveedor proveedor.proveedor%TYPE) return varchar2;
  
  
  --Codigo Moneda Dolares
  function of_dolares(asi_nada varchar2) return varchar2;
  function of_soles(asi_nada varchar2) return varchar2;
  function of_euros(asi_nada varchar2) return varchar2;
  function of_doc_oc(asi_nada varchar2) return varchar2;
  function of_tasa_cambio_euros(adi_fecha date) return number;
  
  -- Para reportes de almacen
  function of_cant_ingresada_periodo(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number;  
  function of_importe_ingreso(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number;  
  function of_cant_provision_periodo(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number;  
  function of_importe_provision(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number;  
 
  -- Funciones para Programa de Compras
  function of_get_nro_OT(
       asi_nro_programa    in prog_compras_det.nro_programa%TYPE,
       ani_nro_item        in prog_compras_det.nro_item%TYPE
  ) return varchar2;

end PKG_LOGISTICA;
/

prompt
prompt Creating package PKG_PRODUCCION
prompt ===============================
prompt
create or replace package cantabria.PKG_PRODUCCION is

  -- Author  : JRAMIREZ
  -- Created : 16/08/2018 09:38:10 a.m.
  -- Purpose : 
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;
  
  -- Public variable declarations
  is_doc_ot                 doc_tipo.tipo_doc%TYPE;
  is_oper_sal_trans_int     articulo_mov_tipo.tipo_mov%TYPE;
  is_oper_ing_trans_int     articulo_mov_tipo.tipo_mov%TYPE;
  is_oper_ing_prod          articulo_mov_tipo.tipo_mov%TYPE;
  is_oper_ing_reproceso     articulo_mov_tipo.tipo_mov%TYPE;
  is_oper_ing_reempaque     articulo_mov_tipo.tipo_mov%TYPE;
  is_oper_ing_reclasif      articulo_mov_tipo.tipo_mov%TYPE;

  -- Tipos de documento
  function of_doc_ot(asi_nada varchar2) return varchar2;
  function of_oper_ing_prod(asi_nada varchar2) return varchar2;
  
  --Funciones para las cantidades correspondientes al reporte de producción diaria
  function of_ing_mp_propia(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_ing_mp_tercero(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_saldo_inicial_mp(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_saldo_final_mp(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  
  function of_consumo_mp(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_consumo_petroleo_diesel(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_consumo_petroleo_r500(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_consumo_antioxidante(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_consumo_polimero(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_consumo_coagulante(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_consumo_sacos(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  
  function of_reproceso_ton(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_reproceso_sac(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  
  --Producción de aceites
  function of_prod_aceite_ch(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_prod_aceite_chi(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function of_prod_aceite_pama(adi_fecha date, asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
      
  -- Este procedimiento crea / actualiza los movimientos de almacen del parte de empaque
  procedure sp_procesar_parte(asi_nro_parte in tg_parte_empaque.nro_parte%TYPE);
  procedure sp_procesar_parte_sin_cu(asi_nro_parte in tg_parte_empaque.nro_parte%TYPE);
  
  procedure sp_procesar_recepcion(asi_nro_parte in tg_parte_recepcion.nro_parte%TYPE);
  procedure sp_procesar_transferencia(asi_nro_parte in tg_parte_transferencia.nro_parte%TYPE);
  
  -- Este procedimiento crea / actualiza los movimientos de almacen del parte de empaque
  procedure sp_procesar_empaque_all(asi_nada in varchar2);
  procedure sp_procesar_recepcion_all(asi_nada in varchar2);
  procedure sp_procesar_transferencia_all(asi_nada in varchar2);
  
  -- Procedimientos para la anulación de los partes
  procedure sp_anular_parte_empaque(asi_nro_parte in tg_parte_empaque.nro_parte%TYPE);
  procedure sp_anular_parte_empaque_sin_cu(asi_nro_parte in tg_parte_empaque.nro_parte%TYPE);
  
  procedure sp_anular_parte_recepcion(asi_nro_parte in tg_parte_empaque.nro_parte%TYPE);
  procedure sp_anular_parte_tranferencia(asi_nro_parte in tg_parte_transferencia.nro_parte%TYPE);
  
  procedure sp_anular_recepcion_duplicada(asi_nada in varchar2);
  procedure sp_anular_recep_cu_anulados(asi_nada in varchar2);

end PKG_PRODUCCION;
/

prompt
prompt Creating package PKG_RRHH
prompt =========================
prompt
create or replace package cantabria.PKG_RRHH is

  -- Author  : JRAMIREZ
  -- Created : 19/05/2017 01:15:56 p.m.
  -- Purpose : 
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_grp_subsidios          grupo_calculo.grupo_calculo%TYPE;
  is_grp_permisos           grupo_calculo.grupo_calculo%TYPE;
  is_grp_vacaciones         grupo_calculo.grupo_calculo%TYPE;
  is_grp_inasistencia       grupo_calculo.grupo_calculo%TYPE;
  
  is_grp_utilidad           grupo_calculo.grupo_calculo%TYPE;
  
  is_tipo_ejo               tipo_trabajador.tipo_trabajador%TYPE;
  
  -- Conceptos generales
  is_cnc_movilidad          concepto.concep%TYPE;
  is_cnc_asig_familiar      asistparam.cnc_asig_familiar%TYPE;

  -- Public procedimientos and procedure declarations
  procedure of_borra_mov_calculo ( asi_origen         in origen.cod_origen%TYPE,
                                   adi_fec_proceso    in date,
                                   asi_cod_trabajador in maestro.cod_trabajador%TYPE,
                                   asi_tipo_planilla  in calculo.tipo_planilla%TYPE);
                                   
  procedure usp_calcula_utilidad ( ani_periodo     in utl_distribucion.periodo%TYPE, 
                                   ani_item        in utl_distribucion.item%TYPE 
  );
  
  -- Procedimiento que genera el asiento de provision de la CTS
  procedure usp_rh_asiento_prov_cts(
    asi_origen      in origen.cod_origen%type ,
    asi_ttrab       in tipo_trabajador.tipo_trabajador%type ,
    asi_usuario     in usuario.cod_usr%type   ,
    ani_year        in cntbl_asiento.ano%TYPE,
    ani_mes         in cntbl_asiento.mes%TYPE
  );

  -- Procedure para distribuir la asignacion familiar
  procedure sp_ajustar_asig_familiar(
    ani_year        in cntbl_asiento.ano%TYPE,
    ani_mes         in cntbl_asiento.mes%TYPE,
    asi_flag_ajuste in varchar2
  );
  
  procedure sp_cal_quinta_categ_sueldo (
      asi_codtra          in maestro.cod_trabajador%TYPE,
      adi_fec_proceso     in date,
      ani_tipcam          in number,
      asi_origen          in origen.cod_origen%TYPE,
      ani_dias_trabaj     IN NUMBER,
      asi_tipo_planilla   in calculo.tipo_planilla%TYPE
  );
  
  -- Function que retorna los días de asistencia
  function of_total_dias_utilidad( 
           ani_periodo      in utl_distribucion.periodo%TYPE,
           ani_item         in utl_distribucion.item%TYPE
  ) return number;

  function of_total_dias_utilidad( 
           asi_trabajador  in maestro.cod_trabajador%TYPE,
           ani_year        in number,
           ani_mes         in number
  ) return number;
  
  function of_total_dias_utilidad( 
           asi_trabajador  in maestro.cod_trabajador%TYPE,
           ani_periodo      in number
  ) return number;
  
  function of_total_remun_utilidad( 
           ani_periodo      in number
  ) return number;
  

  function of_dias_laborados   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 asi_tipo_trabaj    in maestro.tipo_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_dias_laborados   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_dias_laborados   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 ani_year           in number,
                                 ani_mes            in number) return number;  
  function of_dias_no_laborados   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 ani_year           in number,
                                 ani_mes            in number) return number;                                                                  
  function of_dias_vacaciones  ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_dias_subsidios   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_dias_permisos    ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_dias_inasistencia( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_dias_domingo     ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_dias_feriado     ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date) return number;
  function of_string_dias_lab  ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 ani_year           in number,
                                 ani_mes            in number) return varchar2;    
  function of_string_dias_no_lab  ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 ani_year           in number,
                                 ani_mes            in number) return varchar2;    
  -- Obtengo el rmv minimo vital
  function of_get_rmv          ( asi_tipo_trabaj    in maestro.cod_trabajador%TYPE,
                                 adi_fec_proceso    in date) return number;     
  
  -- Obtengo el rmv minimo vital
  function of_get_uit          ( ani_year           in number) return number;     
                                                             
  -- Dias Habiles del periodo
  function of_dias_habiles     ( asi_origen         in origen.cod_origen%TYPE,
                                 asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fec_proceso    in date,
                                 asi_tipo_planilla  in calculo.tipo_planilla%TYPE) return number;
  
  function of_dias_habiles_vacaciones  ( 
                                 asi_origen         in origen.cod_origen%TYPE,
                                 asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fec_proceso    in date,
                                 asi_tipo_planilla  in calculo.tipo_planilla%TYPE) return number;	
                                 
  function of_dias_asist_sin_domingo(
         asi_origen          in origen.cod_origen%TYPE,
         asi_codtra          in maestro.cod_trabajador%TYPE ,
         asi_tipo_trabaj     in tipo_trabajador.tipo_trabajador%TYPE,
         adi_fec_proceso     in date,
         asi_tipo_planilla   in calculo.tipo_planilla%TYPE
  )return number;
  
  
  
end PKG_RRHH;
/

prompt
prompt Creating package PKG_SIGRE_FINANZAS
prompt ===================================
prompt
create or replace package cantabria.PKG_SIGRE_FINANZAS is

  -- Author  : JRAMIREZ
  -- Created : 05/09/2014 11:39:13 a.m.
  -- Purpose : Funciones Financieras y Tesorerira
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_doc_dtrp      finparam.doc_detrac_cp%TYPE;
  is_doc_dtrc      finparam.doc_detrac_cc%TYPE;
  
  --Documentos para la parte contable
  is_doc_ncp        doc_tipo.tipo_doc%TYPE := 'NCP';
  is_doc_ndp        doc_tipo.tipo_doc%TYPE := 'NDP';
  is_doc_ncc        doc_tipo.tipo_doc%TYPE := 'NCC';
  is_doc_ndc        doc_tipo.tipo_doc%TYPE := 'NDC';
  is_doc_bvc        finparam.doc_bol_cobrar%TYPE;
  is_doc_fac        finparam.doc_fact_cobrar%TYPE;
  is_doc_cnc        doc_tipo.tipo_doc%TYPE := 'CNC';
  
  in_nro_decimales  number;
  
  -- Matrices contables / Conceptos Financieros
  is_confin_vta_vd_sol   concepto_financiero.confin%TYPE;     -- Venta con vale de descuento en soles
  is_confin_vta_vd_dol   concepto_financiero.confin%TYPE;     -- Venta con vale de descuento en dolares

  function of_confin_vta_vd_sol(asi_nada varchar2) return varchar2;
  function of_confin_vta_vd_dol(asi_nada varchar2) return varchar2;
  
  -- Obtiene el saldo anterior por una fecha especifica pero en dolares
  function of_fin_caja_saldo_anterior(
           adi_fecha in date, 
           asi_origen in origen.cod_origen%TYPE
  ) return number;
  -- Obtiene el saldo anterior a una fecha especifica, pero se elige el tipo de moneda
  function of_fin_caja_saldo_anterior(
           adi_fecha  in date,
           asi_origen in origen.cod_origen%TYPE,
           asi_moneda in moneda.cod_moneda%TYPE
  ) return number;
  -- Obtiene el saldo anterior a una fecha especifica, pero se elige un periodo
  function of_fin_caja_saldo_anterior(
           ani_year   in number,
           ani_mes    in number,
           asi_origen in origen.cod_origen%TYPE,
           asi_moneda in moneda.cod_moneda%TYPE
  ) return number;
  
  
  -- Fecha del primer ingreso por favor
  function of_fecha_primer_ingreso(
           asi_proveedor in proveedor.proveedor%TYPE, 
           asi_tipo_doc in cntas_pagar.tipo_doc%TYPE, 
           asi_nro_doc in cntas_pagar.nro_doc%TYPE
  ) return date;
  
  -- Obtiene el IGV de la transferencia Gratuita, solo cuando el valor de la boleta es cero
  -- y no deba incluir descuentos ni anticipos
  function of_IGV_gratuito(
           asi_tipo_doc    in cntas_cobrar.tipo_doc%TYPE, 
           asi_nro_doc     in cntas_cobrar.tipo_doc%TYPE 
  ) return number;
  
  -- Procedimiento para actualizar saldo de cuentas por cobrar
  procedure of_actualiza_saldo_cc(asi_nada in varchar2);
  
  -- Procedimiento para actualizar saldo de cuentas por pagar
  procedure of_actualiza_saldo_cp(asi_nada in varchar2);

  -- Procedimiento para cambiar el periodo de una factura
  procedure sp_cambiar_periodo(asi_proveedor in proveedor.proveedor%TYPE, 
                               asi_tipo_doc  in cntas_pagar.tipo_doc%TYPE, 
                               asi_nro_doc   in cntas_pagar.nro_doc%TYPE,
                               ani_new_year  in number,
                               ani_new_mes   in number);
                               
	-- Procedimiento para cambiar el periodo de una factura de cntas_cobrar
  procedure sp_cambiar_periodo_vta(asi_proveedor in proveedor.proveedor%TYPE, 
                                   asi_tipo_doc  in cntas_cobrar.tipo_doc%TYPE, 
                                   asi_nro_doc   in cntas_cobrar.nro_doc%TYPE,
                                   ani_new_year  in number,
                                   ani_new_mes   in number);
                                                                  
  --procedimiento para cambiar el tipo y nro de documento de una cuenta por pagar
  procedure sp_change_nro_doc(
            asi_cod_rel        in cntas_pagar.cod_relacion%type ,
            asi_tipo_doc       in cntas_pagar.tipo_doc%type     ,
            asi_nro_doc        in cntas_pagar.nro_doc%type      ,
            asi_new_cod_rel    in cntas_pagar.cod_relacion%type ,
            asi_new_tipo_doc   in cntas_pagar.tipo_doc%Type     ,
            asi_new_nro_doc    in cntas_pagar.nro_doc%type);
  
end PKG_SIGRE_FINANZAS;
/

prompt
prompt Creating package PKG_SIGRE_FLOTA
prompt ================================
prompt
create or replace package cantabria.PKG_SIGRE_FLOTA is

  -- Author  : JRAMIREZ
  -- Created : 08/04/2015 10:59:50 p.m.
  -- Purpose : Procedimientos y cunciones para flota
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_concep_bonif_pesca concepto.concep%TYPE := '1005';

  -- Public function and procedure declarations
  function of_get_inicio_descarga(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return date;
  function of_get_fin_descarga(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return date;
  function of_tiempo_descarga(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number;
  function of_pesca_calas(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number;
  function of_pesca_declarada(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number;
  function of_pesca_real(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number;
  function of_nro_calas(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number;
  function of_ultima_bitacora(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return varchar2;
  function of_concep_bonif_pesca(asi_nada varchar2) return varchar2;
  function of_get_semana(adi_fecha date) return varchar2;
end PKG_SIGRE_FLOTA;
/

prompt
prompt Creating package PKG_SIGRE_OT
prompt =============================
prompt
create or replace package cantabria.PKG_SIGRE_OT is

  -- Author  : JRAMIREZ
  -- Created : 18/03/2015 10:00:56 a.m.
  -- Purpose : funciones y procedimientos para OT
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_doc_ot   logparam.doc_ot%TYPE;

  -- Public function and procedure declarations
  function uf_costo_proy_ot(asi_nro_ot orden_trabajo.nro_orden%TYPE, asi_moneda moneda.cod_moneda%TYPE) return number;
  function uf_costo_ejec_ot(asi_nro_ot orden_trabajo.nro_orden%TYPE, asi_moneda moneda.cod_moneda%TYPE) return number;
  function uf_porc_avance_atencion(asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;
  function uf_material_pend_aprob(asi_nro_ot orden_trabajo.nro_orden%TYPE) return number;

end PKG_SIGRE_OT;
/

prompt
prompt Creating package PKG_UTILITY
prompt ============================
prompt
create or replace package cantabria.PKG_UTILITY is

  -- Author  : JRAMIREZ
  -- Created : 02/10/2016 01:53:01 p.m.
  -- Purpose : Funciones diversas y utilidades
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  --<VariableName> <Datatype>;

  -- Public function and procedure declarations
  function of_in_search(asi_search varchar2, asi_cadena varchar2) return number;

  -- Funcion que me devuelve la cadena para Codificacion 128b
  function of_convert_to_char128b(asi_yourData varchar2) return varchar2;

  -- Public function and procedure declarations
  function of_trim(asi_cadena varchar2, asi_char varchar2) return VARCHAR2;

  -- Funcion que devuelve la semana de una fecha especifica
  function of_semana(adi_fecha in date) return VARCHAR2;

  -- Funcion que devuelve la ultima fecha de la semana
  function of_last_day_week(adi_fecha in date) return date;

  -- Funcion que devuelve la ultima fecha de la semana
  function of_last_day(ani_year in number, ani_mes in number) return date;
  
  -- Funcion que convierte en hexadecimal
  function of_convert_to_hex(ani_numero in number) return varchar2;

end PKG_UTILITY;
/

prompt
prompt Creating package PQ_DOC_FINANZAS
prompt ================================
prompt
create or replace package cantabria.PQ_DOC_FINANZAS is

  -- Author  : JRAMIREZ
  -- Created : 02/12/2013 02:43:37 p.m.
  -- Purpose : DOCUMENTOS PARA FINANZAS
  
  
  -- Public constant declarations
  is_doc_ncp constant doc_tipo.tipo_doc%TYPE := 'NCP';
  is_doc_ndp constant doc_tipo.tipo_doc%TYPE := 'NDP';
  is_doc_cnc constant doc_tipo.tipo_doc%TYPE := 'CNC';


end PQ_DOC_FINANZAS;
/

prompt
prompt Creating package USP_SIGRE_CNTBL
prompt ================================
prompt
create or replace package cantabria.USP_SIGRE_CNTBL is

  -- Author  : JRAMIREZ
  -- Created : 18/02/2014 10:02:09 a.m.
  -- Purpose : PROCEDIMIENTOS COMPLETOS PARA CONTABILIDAD
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_cnta_cntbl_red_deb     cntbl_cnta.cnta_ctbl%TYPE;
  is_cnta_cntbl_red_hab     cntbl_cnta.cnta_ctbl%TYPE;
  
  -- Cuentas Contables por diferencia de cambio
  is_cc_perdida_dif         cntbl_cnta.cnta_ctbl%TYPE;
  is_cc_ganancia_dif        cntbl_cnta.cnta_ctbl%TYPE;
  
  -- Libro de Ajuste por redondeo
  in_libro_ajuste_red       cntbl_libro.nro_libro%TYPE;
  in_count                  number;

  function SF_CNT_CIERRE_CNTBL(ani_year in cntbl_asiento.ano%type,
                                ani_mes  in cntbl_asiento.mes%type,
                                asi_tipo in string
  ) return varchar2;
  
  function of_get_moneda(asi_cod_relacion in cntbl_asiento_det.cod_relacion%TYPE,
                         asi_tipo_doc     in cntbl_asiento_det.tipo_docref1%TYPE,
                         asi_nro_doc      in cntbl_Asiento_det.Nro_Docref1%TYPE
  ) return varchar2;
  
  -- Obtengo la ultima cuenta contable
  function of_get_ult_cnta_cntbl(
             asi_cod_relacion in cntbl_asiento_det.cod_relacion%TYPE,
             asi_tipo_doc     in cntbl_asiento_det.tipo_docref1%TYPE,
             asi_nro_doc      in cntas_cobrar.nro_doc%TYPE
  ) return varchar2;
  
  -- Public function and procedure declarations
  PROCEDURE sp_delete_pre_asiento(asi_origen    origen.cod_origen%TYPE, 
                                  ani_nro_libro cntbl_libro.nro_libro%TYPE, 
                                  ani_year      number, 
                                  ani_mes       number);
  
  -- Asiento para generar el ajuste por redondeo
  PROCEDURE sp_asiento_redondeo(
      asi_origen         origen.cod_origen%TYPE, 
      ani_year           number, 
      ani_mes            number,
      asi_cnta_cntbl     cntbl_cnta.cnta_ctbl%TYPE,
      asi_cod_relacion   cntbl_asiento_det.cod_relacion%TYPE,
      asi_tipo_doc       cntbl_asiento_det.tipo_docref1%TYPE,
      asi_nro_doc        cntbl_asiento_det.nro_docref1%TYPE,
      asi_cod_usr        usuario.cod_usr%TYPE
  );
  
  -- Inserto en el detalle del asiento contable (cntbl_Asiento_det)
  procedure SP_INSERT_ASIENTO(
         asi_origen         in cntbl_asiento_det.origen%type      ,
         ani_year           in cntbl_asiento_det.ano%TYPE             ,
         ani_mes            in cntbl_asiento_det.mes%TYPE             ,
         ani_nro_libro      in cntbl_asiento_det.nro_libro%type       ,
         ani_nro_asiento    in cntbl_asiento_det.nro_asiento%type     ,
         ani_item           in out cntbl_asiento_det.item%type        ,
         adi_fec_proceso    in date                                   ,
         asi_cencos         in centros_costo.cencos%type              ,
         asi_cnta_ctbl      in cntbl_cnta.cnta_ctbl%type              ,
         asi_tipo_doc       in doc_tipo.tipo_doc%type                 ,
         asi_nro_doc        in calculo.nro_doc_cc%type                ,
         asi_cod_relacion   in cntbl_asiento_det.cod_relacion%TYPE    ,
         asi_cod_ctabco     in cntbl_asiento_det.cod_ctabco%TYPE      ,
         asi_flag_negativo  in cntbl_asiento_det.flag_debhab%TYPE     ,
         asi_flag_debhab    in cntbl_asiento_det.flag_debhab%TYPE     ,
         asi_glosa_det      in cntbl_pre_asiento_det.det_glosa%TYPE   ,
         ani_imp_soles      in cntbl_pre_asiento_det.imp_movsol%type  ,
         ani_imp_dolares    in cntbl_pre_asiento_det.imp_movsol%type  ,
         asi_concep         in concepto.concep%type                   ,
         asi_cbenef         in maestro.centro_benef%type              ,
         asi_cod_trabajador in maestro.cod_trabajador%TYPE
  );
  
end USP_SIGRE_CNTBL;
/

prompt
prompt Creating package USP_SIGRE_RRHH
prompt ===============================
prompt
create or replace package cantabria.USP_SIGRE_RRHH is

  -- Author  : JRAMIREZ
  -- Created : 19/02/2014 09:16:15 a.m.
  -- Purpose : FUNCIONES Y PROCEDIMIENTOS PARA RECURSOS HUMANOS
  
  -- Public type declarations
  --type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  is_tipo_trip               rrhhparam.tipo_trab_tripulante%TYPE;
  is_tipo_des                rrhhparam.tipo_trab_destajo%TYPE;
  is_tipo_ser                rrhhparam.tipo_trab_servis%TYPE;
  is_tipo_jor                rrhhparam.tipo_trab_obrero%TYPE;
  is_tipo_emp                rrhhparam.tipo_trab_empleado%TYPE;
  
  is_cnc_bonif_tri           concepto.concep%TYPE;
  is_cnc_partic_pesca        concepto.concep%TYPE;
  
  -- Grupos de Calculo para tripulantes
  is_grp_gratif_tri          grupo_calculo.grupo_calculo%TYPE;
  is_grp_VACAC_TRI           grupo_calculo.grupo_calculo%TYPE;
  is_grp_CTS_TRI             grupo_calculo.grupo_calculo%TYPE;
  
  -- Tipos de Planilla
  is_planilla_gratif_tri     char(1) := 'G';
  is_planilla_CTS_tri        char(1) := 'C';
  is_planilla_VACAC_tri      char(1) := 'V';
  
  -- Datos para la gratificacion Extraordinaria
  in_porc_bonif_ext          asistparam.porc_bonif_ext%TYPE;
  is_cnc_bonif_ext           asistparam.cnc_bonif_ext%TYPE;
  
  -- Parametros para el calculo de planilla
  is_cnc_total_ingreso       rrhhparam.cnc_total_ing%TYPE;
  is_cnc_total_dscto         rrhhparam.cnc_total_dsct%TYPE;
  is_cnc_total_pagado        rrhhparam.cnc_total_pgd%TYPE;
  is_cnc_total_aportes       rrhhparam.cnc_total_aport%TYPE;
  in_ano_tope_seg_inv        rrhhparam.tope_ano_seg_inv%TYPE;
  
  -- Conceptos diversos para calculo
  is_cnc_reintegro_grati     concepto.concep%TYPE := '1483';
  is_cnc_reint_asig_fam      concepto.concep%TYPE;
  
  
  -- AFP para REP
  is_afp_rep                 admin_afp.cod_afp%TYPE;
  
  -- función
  
  -- Esta función devuelve las toneladas que han entrado al calculo de la participación de Pesca
  function of_get_toneladas(asi_origen          rrhh_param_org.origen%TYPE,
                            adi_fec_proceso     rrhh_param_org.fec_proceso%TYPE,
                            asi_tipo_trabajador rrhh_param_org.tipo_trabajador%TYPE,
                            asi_tipo_planilla   rrhh_param_org.tipo_planilla%TYPE,
                            asi_tripulante      maestro.cod_trabajador%TYPE) return number;

  -- Estas funciones son para el reporte por tripulantes de RRHH
  function of_total_partic_pesca(adi_fec_proceso     date,
                                 asi_codtra          maestro.cod_trabajador%TYPE) return number;
                            
  function of_total_bonif_pesca (adi_fec_proceso     date,
                                 asi_codtra          maestro.cod_trabajador%TYPE) return number;
                                 
  function of_base_calc_gratif (adi_fec_proceso     date,
                                asi_codtra          maestro.cod_trabajador%TYPE) return number;

  function of_base_calculo     (adi_fec_proceso     date,
                                asi_tipo_planilla   calculo.tipo_planilla%TYPE,
                                asi_codtra          maestro.cod_trabajador%TYPE) return number;

  -- Esta función devuelve la participación de pesca del tripulante en un rango de fechas
  function of_total_concepto(ani_year            number,
                             ani_mes             number,
                             asi_concepto        concepto.concep%TYPE,
                             asi_codtra          maestro.cod_trabajador%TYPE) return number;
                      
  function of_get_tipo_trip(asi_nada varchar2) return varchar2;
  function of_get_tipo_emp(asi_nada varchar2) return varchar2;
  
  function of_hras_normales(
           asi_codtra        maestro.cod_trabajador%TYPE, 
           adi_fec_proceso   date,
           asi_origen        origen.cod_origen%TYPE,
           asi_tipo_planilla rrhh_param_org.tipo_planilla%TYPE
  ) return decimal;
  
  function of_hras_extras(
           asi_codtra        maestro.cod_trabajador%TYPE, 
           adi_fec_proceso   date,
           asi_origen        origen.cod_origen%TYPE,
           asi_tipo_planilla rrhh_param_org.tipo_planilla%TYPE     
  ) return decimal;

  function of_dias_asist(
           asi_codtra  maestro.cod_trabajador%TYPE, 
           adi_fecha1  date, 
           adi_Fecha2  date
  ) return decimal;
  
  function of_dias_asist(
           asi_codtra      maestro.cod_trabajador%TYPE, 
           adi_fec_proceso date,
           asi_origen      origen.cod_origen%TYPE
  ) return decimal;
  
  

  function of_dias_asist(
           asi_codtra        maestro.cod_trabajador%TYPE, 
           adi_fec_proceso   date,
           asi_origen        origen.cod_origen%TYPE,
           asi_tipo_planilla calculo.tipo_planilla%TYPE
  ) return decimal;

   function of_tipo_planilla(
           asi_tipo_planilla   rrhh_param_org.tipo_planilla%TYPE
   ) return varchar2;
  
  -- Public function and procedure declarations
  procedure SP_RH_DISTRIBUCION_ASIENTOS(
           adi_fec_proceso     in     date                                   ,
           asi_cod_trabajador  in     maestro.cod_trabajador%type            ,
           asi_origen          in     origen.cod_origen%TYPE                 ,
           asi_cnta_ctbl       in     cntbl_cnta.cnta_ctbl%type              ,
           asi_flag_debhab     in     cntbl_asiento_det.flag_debhab%TYPE     ,
           ani_imp_movsol      in     calculo.imp_soles%type                 ,
           ani_imp_movdol      in     calculo.imp_soles%type                 ,
           asi_tipo_doc        in     doc_tipo.tipo_doc%type                 ,
           asi_nro_doc         in     calculo.nro_doc_cc%type                ,
           ani_nro_libro       in     cntbl_libro.nro_libro%type             ,
           asi_det_glosa       in     cntbl_pre_asiento_det.det_glosa%TYPE   ,
           ani_nro_provisional in     cntbl_libro.num_provisional%type       ,
           ani_item            in out cntbl_pre_asiento_det.item%type        ,
           asi_concep          in     concepto.concep%type                   
    );
  
  procedure SP_RH_INSERT_ASIENTO(
         adi_fec_proceso    in date                                   ,
         asi_origen         in origen.cod_origen%type                 ,
         asi_cencos         in centros_costo.cencos%type              ,
         asi_cnta_ctbl      in cntbl_cnta.cnta_ctbl%type              ,
         asi_tipo_doc       in doc_tipo.tipo_doc%type                 ,
         asi_nro_doc        in calculo.nro_doc_cc%type                ,
         asi_cod_relacion   in cntbl_asiento_det.cod_relacion%TYPE    ,
         asi_flag_debhab    in cntbl_asiento_det.flag_debhab%TYPE     ,
         ani_nro_libro      in cntbl_libro.nro_libro%type             ,
         asi_glosa_det      in cntbl_pre_asiento_det.det_glosa%TYPE   ,
         ani_item           in out cntbl_pre_asiento_det.item%type    ,
         ani_num_prov       in cntbl_libro.num_provisional%type       ,
         ani_imp_soles      in cntbl_pre_asiento_det.imp_movsol%type  ,
         ani_imp_dolares    in cntbl_pre_asiento_det.imp_movsol%type  ,
         asi_concep         in concepto.concep%type                   ,
         asi_cbenef         in maestro.centro_benef%type              ,
         asi_cod_trabajador in maestro.cod_trabajador%TYPE
  );
  
  --Procedimiento para Procesar Gratificacion de Tripulantes
  procedure PROCESAR_GRATIF_TRIPULANTE (
    asi_codtra             in maestro.cod_trabajador%TYPE,
    asi_codusr             in usuario.cod_usr%TYPE,
    adi_fec_proceso        in date,
    asi_origen             in origen.cod_origen%TYPE
  );

  --Procedimiento para Procesar Vacaciones de Tripulantes
  procedure PROCESAR_VACAC_TRIPULANTE (
    asi_codtra             in maestro.cod_trabajador%TYPE,
    asi_codusr             in usuario.cod_usr%TYPE,
    adi_fec_proceso        in date,
    asi_origen             in origen.cod_origen%TYPE,
    asi_flag_renta_quinta  in char
  );

  --Procedimiento para Procesar CTS de Tripulantes
  procedure PROCESAR_CTS_TRIPULANTE (
    asi_codtra             in maestro.cod_trabajador%TYPE,
    asi_codusr             in usuario.cod_usr%TYPE,
    adi_fec_proceso        in date,
    asi_origen             in origen.cod_origen%TYPE
  );
  
  procedure usp_rh_cal_borra_hist_calculo (
    asi_origen         in origen.cod_origen%TYPE,
    adi_fec_proceso    in date,
    asi_tipo_trabaj    in tipo_trabajador.tipo_trabajador %TYPE,
    asi_tipo_planilla  in calculo.tipo_planilla%TYPE
  );

end USP_SIGRE_RRHH;
/


spool off
