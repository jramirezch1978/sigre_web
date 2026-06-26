-- CANTABRIA.CNTAS_PAGAR definition

CREATE TABLE "CANTABRIA"."CNTAS_PAGAR" 
   (	"COD_RELACION" CHAR(8) NOT NULL ENABLE, 
	"TIPO_DOC" CHAR(4) NOT NULL ENABLE, 
	"NRO_DOC" CHAR(10) NOT NULL ENABLE, 
	"FLAG_ESTADO" CHAR(1) DEFAULT '1' NOT NULL ENABLE, 
	"FECHA_REGISTRO" DATE, 
	"FECHA_EMISION" DATE, 
	"VENCIMIENTO" DATE, 
	"FORMA_PAGO" CHAR(6), 
	"COD_MONEDA" CHAR(3), 
	"TASA_CAMBIO" NUMBER(7,4) DEFAULT 0, 
	"TOTAL_PAGAR" NUMBER(13,2) DEFAULT 0, 
	"TOTAL_PAGADO" NUMBER(13,2) DEFAULT 0, 
	"COD_USR" CHAR(6), 
	"JOB" CHAR(10), 
	"MOTIVO" CHAR(6), 
	"ORIGEN" CHAR(2) NOT NULL ENABLE, 
	"ANO" NUMBER(4,0), 
	"MES" NUMBER(2,0), 
	"NRO_LIBRO" NUMBER(3,0), 
	"NRO_ASIENTO" NUMBER(10,0), 
	"DESCRIPCION" VARCHAR2(2000), 
	"PORC_RET_IGV" NUMBER(4,2) DEFAULT 0, 
	"NRO_CONST_DEPOSITO" VARCHAR2(20), 
	"FECHA_CONST_DEPOSITO" DATE, 
	"FLAG_RETENCION" CHAR(1) DEFAULT '0', 
	"NRO_DETRACCION" CHAR(10), 
	"FLAG_DETRACCION" CHAR(1) DEFAULT '0', 
	"PORC_DETRACCION" NUMBER(4,2) DEFAULT 0, 
	"FLAG_SITUACION_LTR" CHAR(1), 
	"BANCO_LTR" CHAR(3), 
	"NRO_REN_LTR" NUMBER(2,0), 
	"FLAG_TIPO_LTR" CHAR(1), 
	"FLAG_PROVISIONADO" CHAR(1), 
	"IMPORTE_DOC" NUMBER(13,2) DEFAULT 0 NOT NULL ENABLE, 
	"SALDO_SOL" NUMBER(13,2) DEFAULT 0 NOT NULL ENABLE, 
	"SALDO_DOL" NUMBER(13,2) DEFAULT 0 NOT NULL ENABLE, 
	"NRO_CERTIFICADO" CHAR(10), 
	"FLAG_REPLICACION" CHAR(1) DEFAULT '1', 
	"FLAG_CONTROL_REG" CHAR(1) DEFAULT '0', 
	"FLAG_CAJA_BANCOS" CHAR(1) DEFAULT '0', 
	"SALDO_APLICADO_SOL" NUMBER(13,2) DEFAULT 0, 
	"SALDO_APLICADO_DOL" NUMBER(13,2) DEFAULT 0, 
	"OPER_DETR" CHAR(2), 
	"BIEN_SERV" CHAR(3), 
	"FECHA_PRESENTACION" DATE, 
	"NRO_SOL_CRED_RRHH" CHAR(10), 
	"FLAG_CNTR_ALMACEN" CHAR(1) DEFAULT '1', 
	"IMPORTE_DOC_REFERENCIAL" NUMBER(13,2) DEFAULT 0, 
	"FECHA_PAGO_RTPS" DATE, 
	"FLAG_RET_4CATEG" CHAR(1), 
	"COD_ADUANA" CHAR(3), 
	"NRO_CORRELATIVO" NUMBER(10,0), 
	"NOM_PROVEEDOR" VARCHAR2(200), 
	"TIPO_DOC_IDENT" CHAR(1), 
	"NRO_DOC_IDENT" VARCHAR2(20), 
	"FEC_IMPRESION" DATE, 
	"IMP_DETRACCION" NUMBER(13,2) DEFAULT 0 NOT NULL ENABLE, 
	"FLAG_REDONDEAR" CHAR(1) DEFAULT '1' NOT NULL ENABLE, 
	"CONFIN" CHAR(8), 
	"SERIE_CP" VARCHAR2(4), 
	"NUMERO_CP" VARCHAR2(12), 
	"CLASE_BIEN_SERV" CHAR(2) DEFAULT '1', 
	"COD_BANCO" CHAR(3), 
	"TIEMPO_PROV_NEW" NUMBER(10,8) DEFAULT 0 NOT NULL ENABLE, 
	"TIEMPO_PROV_MODIF" NUMBER(10,8) DEFAULT 0 NOT NULL ENABLE, 
	 CONSTRAINT "PK_CNTAS_PAGAR" PRIMARY KEY ("COD_RELACION", "TIPO_DOC", "NRO_DOC")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 16777216 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 134217728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE OR REPLACE TRIGGER "CANTABRIA"."TDA_FIN_CNTAS_PAGAR" 
  after delete on cntas_pagar
  for each row

declare
  -- local variables here
  ln_count number ;
begin
  If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
     return;
  end if;

--documento provisionado
IF :old.flag_provisionado = 'R' THEN
   --llena tabla temporal
   insert into tt_fin_cp_asiento
   (origen,ano,mes,nro_libro,nro_asiento,cod_relacion,tipo_doc,nro_doc)
   values
   (:old.origen,:old.ano,:old.mes,:old.nro_libro,:old.nro_asiento,:old.cod_relacion,:old.tipo_doc,:old.nro_doc) ;
   --
   --se ingresa informacion en tabla temporal
   insert into tt_fin_tasa_cambio
   (cod_relacion,tipo_doc,nro_doc,tasa_cambio)
   values
   (:old.cod_relacion,:old.tipo_doc,:old.nro_doc,:old.tasa_cambio) ;

END IF;


delete from doc_pendientes_cta_cte
where (cod_relacion = :old.cod_relacion ) and
      (tipo_doc     = :old.tipo_doc     ) and
      (nro_doc      = :old.nro_doc      ) ;

IF (:old.cod_relacion is not null AND
    :old.tipo_doc is not null AND
    :old.nro_doc is not null) THEN

    -- Verifica si existe en tabla de control documentario
    SELECT count(*)
      INTO ln_count
      FROM cd_doc_recibido c
     WHERE c.cod_relacion = :old.cod_relacion
       AND c.tipo_doc     = :old.tipo_doc
       AND c.nro_doc      = :old.nro_doc ;

    -- Actualiza en caso lo encuentre
    UPDATE cd_doc_recibido c
       SET c.flag_provisionado = '0'
     WHERE c.cod_relacion = :old.cod_relacion
       AND c.tipo_doc     = :old.tipo_doc
       AND SUBSTR(c.nro_doc,1,10)  = :old.nro_doc ;
END IF ;

END tda_fin_cntas_pagar;


/
ALTER TRIGGER "CANTABRIA"."TDA_FIN_CNTAS_PAGAR" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TDB_FIN_CNTAS_PAGAR" 
  before delete on cntas_pagar
  for each row

DECLARE
  -- local variables here
ln_count             number ;
ln_imp_dol_old       cntas_pagar.importe_doc%type ;
lc_dolares           logparam.cod_dolares%type ;

BEGIN

If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
 return;
end if;

IF :old.flag_detraccion = '1' THEN
  delete from detraccion where nro_detraccion = :old.nro_detraccion ;
END IF;

-- Actualizando "ot_otros_gastos"
SELECT count(*)
 INTO ln_count
 FROM ot_otros_gastos ot
WHERE ot.cod_relacion = :old.cod_relacion
  AND ot.tipo_doc     = :old.tipo_doc
  AND ot.nro_doc      = :old.nro_doc ;

IF ln_count > 0 THEN
   SELECT l.cod_dolares
     INTO lc_dolares
     FROM logparam l
    WHERE reckey='1' ;

   -- Calculando antiguo importe
   IF :old.cod_moneda = lc_dolares THEN
      ln_imp_dol_old := :old.importe_doc ;
   ELSE
      IF :old.tasa_cambio > 0 THEN
         ln_imp_dol_old := :old.importe_doc / :old.tasa_cambio ;
      ELSE
         ln_imp_dol_old := 0 ;
      END IF ;
   END IF ;
   -- Actualizando el costo en las ordenes de trabajo afectadas
   UPDATE orden_trabajo ot
      SET ot.costo_ejecutado = NVL(ot.costo_ejecutado,0) - ln_imp_dol_old
    WHERE ot.nro_orden IN (SELECT otg.nro_orden
                             FROM ot_otros_gastos otg
                            WHERE otg.cod_relacion = :old.cod_relacion
                              AND otg.tipo_doc     = :old.tipo_doc
                              AND otg.nro_doc      = :old.nro_doc) ;
END IF ;

END tdb_fin_cntas_pagar;


/
ALTER TRIGGER "CANTABRIA"."TDB_FIN_CNTAS_PAGAR" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TIA_FIN_CNTAS_PAGAR" 
  after insert on cntas_pagar
  for each row

declare
  -- local variables here
  lc_cnta_ctbl   cntbl_cnta.cnta_ctbl%type          ;
  lc_flag_debhab cntbl_asiento_det.flag_debhab%type ;
  ln_factor      doc_tipo.factor%type               ;
  ln_count       number ;

  CURSOR c_asiento_det IS
     SELECT cd.cnta_ctbl, cd.flag_debhab, cd.imp_movsol
       FROM cntbl_asiento_det cd
      WHERE cd.origen            = :new.origen
        and cd.ano               = :new.ano
        and cd.mes               = :new.mes
        and cd.nro_libro         = :new.nro_libro
        and cd.nro_asiento       = :new.nro_asiento
        and cd.tipo_docref1      = :new.tipo_doc
        and trim(cd.nro_docref1) = trim(:new.nro_doc)
        and cd.cod_relacion      = :new.cod_relacion
     ORDER BY cd.imp_movsol desc ;


BEGIN
  If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
     return;
  end if;

--FACTOR DE DOCUMENTO
select Nvl(factor,0) into ln_factor from doc_tipo where (tipo_doc = :new.tipo_doc) ;

if ln_factor = 0 THEN
   RAISE_APPLICATION_ERROR( -20000,'Factor de Documento '||:new.tipo_doc|| 'es igual a 0 debera Colocar alguna valor 1 o -1 ' ) ;
end if ;


--documento provisionado
IF :new.flag_provisionado = 'R' THEN

   --recupero cuenta contable de documento provisionado
    For rc_as_det in c_asiento_det Loop
      lc_cnta_ctbl   := rc_as_det.cnta_ctbl;
      lc_flag_debhab := rc_as_det.flag_debhab;
      EXIT ;
    End Loop;

   /*****************************************************************
     REPLICACION
   *****************************************************************/
   Insert into doc_pendientes_cta_cte
   (cod_relacion ,tipo_doc ,nro_doc  ,flag_tabla ,cnta_ctbl ,cod_moneda      ,
    flag_debhab  ,sldo_sol ,saldo_dol,fecha_doc  ,factor    ,flag_replicacion,
    fecha_vencimiento)
   Values
   (:new.cod_relacion, :new.tipo_doc  ,:new.nro_doc  ,'3',lc_cnta_ctbl  ,:new.cod_moneda,
    lc_flag_debhab   , :new.saldo_sol ,:new.saldo_dol,:new.fecha_emision,ln_factor,'0'  ,
    :new.vencimiento ) ;


ELSE

   if ln_factor = 1 then
      lc_flag_debhab := 'D' ;
   elsif ln_factor = -1 then
      lc_flag_debhab := 'H' ;
   end if ;

   /*****************************************************************
     REPLICACION
   *****************************************************************/

   Insert into doc_pendientes_cta_cte
   (cod_relacion ,tipo_doc ,nro_doc  ,flag_tabla ,cod_moneda ,
    flag_debhab  ,sldo_sol ,saldo_dol,fecha_doc  ,factor     ,flag_replicacion,
    fecha_vencimiento)
   Values
   (:new.cod_relacion, :new.tipo_doc  ,:new.nro_doc  ,'3',:new.cod_moneda,
    lc_flag_debhab   , :new.saldo_sol ,:new.saldo_dol,:new.fecha_emision,ln_factor ,'0',
    :new.vencimiento) ;
END IF;

-- Actualizando tabla de control documentario, en caso exista
SELECT count(*)
  INTO ln_count
  FROM cd_doc_recibido c
 WHERE c.cod_relacion = :new.cod_relacion
   AND c.tipo_doc = :new.tipo_doc
   AND SUBSTR(c.nro_doc,1,10) = :new.nro_doc ;

IF ln_count > 0 THEN
   UPDATE cd_doc_recibido c
      SET c.flag_provisionado = 'P'
    WHERE c.cod_relacion = :new.cod_relacion
      AND c.tipo_doc = :new.tipo_doc
      AND SUBSTR(c.nro_doc,1,10) = :new.nro_doc ;
END IF ;

end tia_fin_cntas_pagar;


/
ALTER TRIGGER "CANTABRIA"."TIA_FIN_CNTAS_PAGAR" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TIB_FIN_CNTAS_PAGAR" 
  before insert on cntas_pagar
  for each row
declare
  -- local variables here
begin


  if :new.flag_detraccion = '1' then
     :new.porc_ret_igv   := 0.00 ;
     :new.flag_retencion := '0' ;
  end if ;

  IF :new.fecha_presentacion is null THEN
     :new.fecha_presentacion := :new.fecha_emision ;
  END IF ;

end TIB_FIN_CNTAS_PAGAR;


/
ALTER TRIGGER "CANTABRIA"."TIB_FIN_CNTAS_PAGAR" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TUA_FIN_CNTAS_PAGAR" 
  after update on cntas_pagar
  for each row

declare
  -- local variables here
  lc_cnta_ctbl      cntbl_cnta.cnta_ctbl%type          ;
  lc_flag_debhab    cntbl_asiento_det.flag_debhab%type ;
  ln_factor         doc_tipo.factor%type               ;
  ls_soles          logparam.cod_soles%TYPE            ;
  ls_dolares        logparam.cod_dolares%TYPE          ;
  ln_count          number                             ;
  ln_imp_dol_new    cntas_pagar.importe_doc%type       ;
  ln_imp_dol_old    cntas_pagar.importe_doc%type       ;
  ls_doc_lc         ap_param.doc_lc%TYPE               ;


BEGIN

If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
   return;
end if;

select cod_soles, cod_dolares
  into ls_soles, ls_dolares
from logparam
where reckey = '1' ;

select doc_lc
  into ls_doc_lc
  from ap_param p
 where p.origen = 'XX';

  --FACTOR DE DOCUMENTO
select Nvl(factor,0)
  into ln_factor
  from doc_tipo
where (tipo_doc = :new.tipo_doc) ;

if ln_factor = 0 THEN
   RAISE_APPLICATION_ERROR( -20000, 'Factor de Documento '||:new.tipo_doc|| 'es igual a 0 debera Colocar alguna valor 1 o -1 ' ) ;
end if ;

-- Actualizando "ot_otros_gastos". Cualquier problema con MM
IF ( (:old.cod_moneda  <> :new.cod_moneda)   OR
     (:old.tasa_cambio <> :new.tasa_cambio)  OR
     (:old.importe_doc <> :new.importe_doc)  ) THEN

      SELECT count(*)
        INTO ln_count
        FROM ot_otros_gastos ot
       WHERE ot.cod_relacion = :new.cod_relacion
         AND ot.tipo_doc     = :new.tipo_doc
         AND ot.nro_doc      = :new.nro_doc ;

      IF ln_count > 0 THEN
         -- Calculando nuevo importe
         IF :new.cod_moneda = ls_dolares THEN
            ln_imp_dol_new := :new.importe_doc ;
         ELSE
            IF :new.tasa_cambio > 0 THEN
               ln_imp_dol_new := :new.importe_doc / :new.tasa_cambio ;
            ELSE
               ln_imp_dol_new := 0 ;
            END IF ;
         END IF ;
         -- Calculando antiguo importe
         IF :old.cod_moneda = ls_dolares THEN
            ln_imp_dol_old := :old.importe_doc ;
         ELSE
            IF :old.tasa_cambio > 0 THEN
               ln_imp_dol_old := :new.importe_doc / :new.tasa_cambio ;
            ELSE
               ln_imp_dol_old := 0 ;
            END IF ;
         END IF ;
         -- Actualizando el costo en las ordenes de trabajo afectadas
         UPDATE orden_trabajo ot
            SET ot.costo_ejecutado = NVL(ot.costo_ejecutado,0) + ln_imp_dol_new - ln_imp_dol_old
          WHERE ot.nro_orden IN (SELECT otg.nro_orden
                                   FROM ot_otros_gastos otg
                                  WHERE otg.cod_relacion = :new.cod_relacion
                                    AND otg.tipo_doc     = :new.tipo_doc
                                    AND otg.nro_doc      = :new.nro_doc) ;
      END IF ;
END IF ;

--documento provisionado
IF :new.flag_provisionado = 'R' THEN
   --se ingresa informacion en tabla temporal
   insert into tt_fin_tasa_cambio
   (cod_relacion,tipo_doc,nro_doc,tasa_cambio)
   values
   (:new.cod_relacion,:new.tipo_doc,:new.nro_doc,:old.tasa_cambio) ;



   IF :new.saldo_sol <> 0 OR :new.saldo_dol <> 0 THEN
      --recupero cuenta contable de documento provisionado
      --recuperar datos

        select count(*)
          into ln_count
          from cntbl_asiento_det cad
         where cad.origen            = :new.origen
           and cad.ano               = :new.ano
           and cad.mes               = :new.mes
           and cad.nro_libro         = :new.nro_libro
           and cad.nro_asiento       = :new.nro_asiento
           and cad.cod_relacion      = :new.cod_relacion
           and cad.tipo_docref1      = :new.tipo_doc
           and cad.nro_docref1       = :new.nro_doc;


      if ln_count = 0 then
         RAISE_APPLICATION_ERROR(-20000, 'No existe registros en el asiento para el documento , por favor verifique'
                           || chr(13) || 'Tipo Doc: ' || :new.Tipo_Doc
                           || chr(13) || 'Nro Doc: ' || :new.nro_doc
                           || chr(13) || 'Cod.Relacion: ' || :new.cod_relacion
                           || chr(13) || 'voucher: ' || :new.origen || trim(to_char(:new.ano, '0000')) || trim(to_char(:new.mes, '00')) || trim(to_char(:new.nro_libro, '00'))
                                                     || trim(to_char(:new.nro_Asiento, '000000')));

      end if;
      /*
      if ln_count > 1 then
         RAISE_APPLICATION_ERROR(-20000, 'Existe mas de un registro en el asiento para el documento , por favor verifique'
                           || chr(13) || 'Tipo Doc: ' || :new.Tipo_Doc
                           || chr(13) || 'Nro Doc: ' || :new.nro_doc
                           || chr(13) || 'Cod.Relacion: ' || :new.cod_relacion
                           || chr(13) || 'voucher: ' || :new.origen || trim(to_char(:new.ano, '0000')) || trim(to_char(:new.mes, '00')) || trim(to_char(:new.nro_libro, '00'))
                                                     || trim(to_char(:new.nro_Asiento, '000000')));

      end if;
      */
      select s.cnta_ctbl, s.flag_debhab
        into lc_cnta_ctbl, lc_flag_debhab
        from ( select cad.item, cad.cnta_ctbl, cad.flag_debhab
                 from cntbl_asiento_det cad
                where cad.origen            = :new.origen
                  and cad.ano               = :new.ano
                  and cad.mes               = :new.mes
                  and cad.nro_libro         = :new.nro_libro
                  and cad.nro_asiento       = :new.nro_asiento
                  and cad.cod_relacion      = :new.cod_relacion
                  and cad.tipo_docref1      = :new.tipo_doc
                  and cad.nro_docref1       = :new.nro_doc
                  and cad.cnta_ctbl         not in ('42201101', '42201102')
                order by cad.item) s
       where rownum = 1;


      if :new.saldo_sol < 0 or :new.saldo_dol < 0 then --ajuste por conversion

         if :new.cod_moneda = ls_soles then
            if :new.saldo_sol <= 0 then
               if ln_factor = -1 then
                  ln_factor := 1 ;
                  lc_flag_debhab := 'D' ;
               else
                  ln_factor := -1 ;
                  lc_flag_debhab := 'H' ;
               end if ;

            end if;
         else
            if :new.saldo_dol <= 0 then
               if ln_factor = -1 then
                  ln_factor := 1 ;
                  lc_flag_debhab := 'D' ;
               else
                  ln_factor := -1 ;
                  lc_flag_debhab := 'H' ;
               end if ;

            end if;
         end if;


      end if ;

      /************************************************************************
       REPLICACION
      *************************************************************************/
      update doc_pendientes_cta_cte dp
         set cnta_ctbl = lc_cnta_ctbl        ,cod_moneda  = :new.cod_moneda    ,
             sldo_sol  = Abs(:new.saldo_sol) ,saldo_dol   = Abs(:new.saldo_dol),
             fecha_doc = :new.fecha_emision  ,flag_debhab = lc_flag_debhab     ,
             factor    = ln_factor           ,flag_replicacion = '0'           ,
             fecha_vencimiento = :new.vencimiento
       where ((cod_relacion = :new.cod_relacion ) and
              (tipo_doc     = :new.tipo_doc     ) and
              (nro_doc      = :new.nro_doc      )) ;

      IF SQL%NOTFOUND THEN
         /************************************************************************
           REPLICACION
         *************************************************************************/
         Insert into doc_pendientes_cta_cte
         (cod_relacion ,tipo_doc ,nro_doc  ,flag_tabla ,cnta_ctbl ,cod_moneda       ,
          flag_debhab  ,sldo_sol ,saldo_dol,fecha_doc  ,factor    ,flag_replicacion ,
          fecha_vencimiento)
         Values
         (:new.cod_relacion, :new.tipo_doc  ,:new.nro_doc  ,'3',lc_cnta_ctbl  ,:new.cod_moneda,
          lc_flag_debhab   , Abs(:new.saldo_sol) ,Abs(:new.saldo_dol),:new.fecha_emision,ln_factor,'0',
          :new.vencimiento) ;
      END IF ;


   ELSE --NO EXISTE SALDO
      DELETE FROM DOC_PENDIENTES_CTA_CTE
      WHERE ((cod_relacion = :new.cod_relacion ) AND
             (tipo_doc     = :new.tipo_doc     ) AND
             (nro_doc      = :new.nro_doc      )) ;
   END IF;

ELSIF :new.flag_provisionado = 'D' THEN --DIRECTO SIN PROVISIONAR

   if ln_factor = 1 then
      lc_flag_debhab := 'D' ;
   elsif ln_factor = -1 then
      lc_flag_debhab := 'H' ;
   end if ;


    if :new.saldo_sol < 0 or :new.saldo_dol < 0 then --ajuste por conversion
         if :new.cod_moneda = ls_soles then
            if :new.saldo_sol <= 0 then
               if ln_factor = -1 then
                  ln_factor := 1 ;
                  lc_flag_debhab := 'D' ;
               else
                  ln_factor := -1 ;
                  lc_flag_debhab := 'H' ;
               end if ;

            end if;
         else
            if :new.saldo_dol <= 0 then
               if ln_factor = -1 then
                  ln_factor := 1 ;
                  lc_flag_debhab := 'D' ;
               else
                  ln_factor := -1 ;
                  lc_flag_debhab := 'H' ;
               end if ;

            end if;
         end if;

    end if ;


    IF :new.saldo_sol <> 0 OR :new.saldo_dol <> 0 THEN
       /***********************************************************
         REPLICACION
       ************************************************************/
       IF :new.flag_caja_bancos = '1' THEN
          if ln_factor = -1 then
             lc_flag_debhab := 'D' ;
             ln_factor      := 1   ;
          else
             lc_flag_debhab := 'H' ;
             ln_factor      := -1  ;
          end if;

       END IF ;


       update doc_pendientes_cta_cte
          set cod_moneda       = :new.cod_moneda,sldo_sol  = abs(:new.saldo_sol)    ,
              saldo_dol        = abs(:new.saldo_dol),fecha_doc = :new.fecha_emision,
              flag_replicacion = '0'                ,fecha_vencimiento = :new.vencimiento
        where ((cod_relacion = :new.cod_relacion ) and
               (tipo_doc     = :new.tipo_doc     ) and
               (nro_doc      = :new.nro_doc      )) ;

       IF SQL%NOTFOUND THEN
          /***********************************************************
            REPLICACION
          ************************************************************/
          Insert into doc_pendientes_cta_cte
          (cod_relacion ,tipo_doc ,nro_doc  ,flag_tabla ,cod_moneda ,
           flag_debhab  ,sldo_sol ,saldo_dol,fecha_doc  ,factor     ,
           flag_replicacion ,fecha_vencimiento)
          Values
          (:new.cod_relacion, :new.tipo_doc  ,:new.nro_doc  ,'3',:new.cod_moneda ,
           lc_flag_debhab   , abs(:new.saldo_sol) ,abs(:new.saldo_dol),:new.fecha_emision  ,ln_factor,
           '0',:new.vencimiento) ;

       END IF ;

   ELSE --NO EXISTE SALDO
      DELETE FROM DOC_PENDIENTES_CTA_CTE
      WHERE ((cod_relacion = :new.cod_relacion ) AND
             (tipo_doc     = :new.tipo_doc     ) AND
             (nro_doc      = :new.nro_doc      )) ;
   END IF;
-- Para otros casos de flag_provisionado
ELSE
   IF :new.saldo_sol <> 0 OR :new.saldo_dol <> 0 THEN
       update doc_pendientes_cta_cte
          set cod_moneda       = :new.cod_moneda,
              sldo_sol         = abs(:new.saldo_sol),
              saldo_dol        = abs(:new.saldo_dol),
              fecha_doc        = :new.fecha_emision,
              flag_replicacion = '0'                ,
              fecha_vencimiento = :new.vencimiento
        where ((cod_relacion = :new.cod_relacion ) and
               (tipo_doc     = :new.tipo_doc     ) and
               (nro_doc      = :new.nro_doc      )) ;
   END IF ;
END IF;

--actualiza documentos d epago de planilla
update calc_doc_pagar_plla cdpc
   set flag_estado = :new.flag_estado
 where ((cod_relacion = :new.cod_relacion ) and
        (tipo_doc     = :new.tipo_doc     ) and
        (nro_doc      = :new.nro_doc      )) ;


-- elimina registro en doc_refencias si anula documento
-- Desactiva de control documentario
IF :new.flag_estado='0' THEN
   DELETE FROM doc_referencias d
   WHERE d.cod_relacion=:new.cod_relacion
     AND d.tipo_doc=:new.tipo_doc
     AND d.nro_doc=:new.nro_doc ;

   UPDATE cd_doc_recibido c
      SET c.flag_estado='0',
          c.flag_transfer='1',
          c.cod_user_transfer = null
    WHERE c.cod_relacion = :old.cod_relacion AND
          c.tipo_doc = :old.tipo_doc AND
          SUBSTR(c.nro_doc,1,10) = :old.nro_doc ;
END IF ;

/*if :new.flag_estado = '0' and :new.nro_asiento is not null and:new.tipo_doc <> ls_doc_lc then
   RAISE_APPLICATION_ERROR(-20000, 'Comprobante de Pago de Registro de Compras esta siendo anulado, esta operacion no es permitida, por favor verifique!'
                           || chr(13) || 'Cod Relacion: ' || :new.cod_relacion
                           || chr(13) || 'Tipo Doc: ' || :new.tipo_doc
                           || chr(13) || 'Nro Doc: ' || :new.nro_doc
                           || chr(13) || 'Voucher: ' || :new.origen || '-' || trim(to_char(:new.ano, '0000')) || '-'
                                      || trim(to_char(:new.mes, '00')) || '-'
                                      || trim(to_char(:new.nro_libro, '00')) || '-'
                                      || trim(to_char(:new.nro_asiento, '000000')) );
end if;*/


END tia_fin_cntas_pagar;


/
ALTER TRIGGER "CANTABRIA"."TUA_FIN_CNTAS_PAGAR" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TUB_FIN_CNTAS_PAGAR" 
  before update on cntas_pagar
  for each row


declare
  -- local variables here


begin

  if :new.flag_detraccion = '1' then
     :new.porc_ret_igv   := 0.00 ;
     :new.flag_retencion := '0' ;
  end if ;

  -- Actualizo el monto de la detraccion
  if :new.imp_detraccion <> :old.imp_detraccion and :new.flag_estado <> '0' then
     update detraccion d
        set d.importe = :new.imp_detraccion
      where d.nro_detraccion = :new.nro_detraccion;
  end if;

end TUB_FIN_CNTAS_PAGAR;


/
ALTER TRIGGER "CANTABRIA"."TUB_FIN_CNTAS_PAGAR" ENABLE;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR3" ON "CANTABRIA"."CNTAS_PAGAR" ("COD_RELACION", "TIPO_DOC", "SERIE_CP", "NUMERO_CP") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 17825792 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR1" ON "CANTABRIA"."CNTAS_PAGAR" ("NRO_ASIENTO", "MES") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 4194304 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR2" ON "CANTABRIA"."CNTAS_PAGAR" ("COD_RELACION", "TIPO_DOC", "NRO_DOC", "COD_MONEDA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 17825792 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR5" ON "CANTABRIA"."CNTAS_PAGAR" ("TIPO_DOC") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 6291456 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

COMMENT ON TABLE CANTABRIA.CNTAS_PAGAR IS 'CNTAS PAGAR';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.COD_RELACION IS 'cod relacion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.TIPO_DOC IS 'tipo doc';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_DOC IS 'Nro Doc';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_ESTADO IS 'flag estado';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FECHA_REGISTRO IS 'fecha registro';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FECHA_EMISION IS 'Fecha Emision';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.VENCIMIENTO IS 'vencimiento';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FORMA_PAGO IS 'forma pago';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.COD_MONEDA IS 'cod moneda';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.TASA_CAMBIO IS 'tasa_cambio';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.TOTAL_PAGAR IS 'total pagar';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.TOTAL_PAGADO IS 'total pagado';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.COD_USR IS 'cod usuario';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.JOB IS 'job';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.MOTIVO IS 'motivo';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.ORIGEN IS 'origen';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.ANO IS 'ano';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.MES IS 'mes';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_LIBRO IS 'nro libro';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_ASIENTO IS 'nro_asiento';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.DESCRIPCION IS 'descripcion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.PORC_RET_IGV IS 'porc ret igv';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_CONST_DEPOSITO IS 'nro_const_deposito';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FECHA_CONST_DEPOSITO IS 'fecha const deposito';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_RETENCION IS 'flag retencion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_DETRACCION IS 'nro detraccion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_DETRACCION IS 'flag detraccion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.PORC_DETRACCION IS 'porc detraccion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_SITUACION_LTR IS 'Flag Situacion ltr';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.BANCO_LTR IS 'Banco ltr';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_REN_LTR IS 'Nro Ren Ltr';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_TIPO_LTR IS 'Flag tipo Ltr';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_PROVISIONADO IS 'flag_provisionado';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.IMPORTE_DOC IS 'importe doc';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.SALDO_SOL IS 'saldo sol';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.SALDO_DOL IS 'saldo dol';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_CERTIFICADO IS 'nro certificado';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_REPLICACION IS 'flag_replicacion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_CONTROL_REG IS 'flag control reg';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_CAJA_BANCOS IS 'flag caja bancos';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.SALDO_APLICADO_SOL IS 'saldo aplicado sol';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.SALDO_APLICADO_DOL IS 'saldo aplicado dol';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.OPER_DETR IS 'oper detr';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.BIEN_SERV IS 'bien serv';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FECHA_PRESENTACION IS 'fecha presentacion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_SOL_CRED_RRHH IS 'nro sol cred rrhh';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_CNTR_ALMACEN IS 'flag cntr almacen';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.IMPORTE_DOC_REFERENCIAL IS 'importe_doc_referencial';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FECHA_PAGO_RTPS IS 'fecha_pago_rtps';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.FLAG_RET_4CATEG IS 'flag_ret_4categ';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.COD_ADUANA IS 'COD_ADUANA';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR.NRO_CORRELATIVO IS 'nro_correlativo';


-- CANTABRIA.CNTAS_PAGAR_DET definition

CREATE TABLE "CANTABRIA"."CNTAS_PAGAR_DET" 
   (	"COD_RELACION" CHAR(8) NOT NULL ENABLE, 
	"TIPO_DOC" CHAR(4) NOT NULL ENABLE, 
	"NRO_DOC" CHAR(10) NOT NULL ENABLE, 
	"ITEM" NUMBER(4,0) NOT NULL ENABLE, 
	"DESCRIPCION" VARCHAR2(2000), 
	"COD_ART" CHAR(12), 
	"CONFIN" CHAR(8), 
	"CANTIDAD" NUMBER(12,4) DEFAULT 0, 
	"IMPORTE" NUMBER(13,2) DEFAULT 0, 
	"CENCOS" CHAR(10), 
	"CNTA_PRSP" CHAR(10), 
	"TIPO_CRED_FISCAL" CHAR(2), 
	"FLAG_REPLICACION" CHAR(1) DEFAULT '1', 
	"ORG_AMP_REF" CHAR(2), 
	"NRO_AMP_REF" NUMBER(10,0), 
	"CENTRO_BENEF" CHAR(12), 
	"ORIGEN_REF" CHAR(2), 
	"TIPO_REF" CHAR(4), 
	"NRO_REF" CHAR(10), 
	"ITEM_REF" NUMBER(10,0), 
	"FEC_MOVILIDAD" DATE, 
	"MOV_DESDE" VARCHAR2(50), 
	"MOV_HASTA" VARCHAR2(50), 
	"ORG_OS" CHAR(2), 
	"NRO_OS" CHAR(10), 
	"ITEM_OS" NUMBER(4,0), 
	"ORG_AM" CHAR(2), 
	"NRO_AM" NUMBER(10,0), 
	"NRO_VALE_TRANS" CHAR(10), 
	"ITEM_VALE_TRANS" NUMBER(6,0), 
	"PRECIO_UNIT" NUMBER(17,8) DEFAULT 0, 
	"COD_TRABAJADOR" CHAR(8), 
	 CONSTRAINT "PK_CNTAS_PAGAR_DET" PRIMARY KEY ("COD_RELACION", "TIPO_DOC", "NRO_DOC", "ITEM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 41943040 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 150994944 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE OR REPLACE TRIGGER "CANTABRIA"."TDA_FIN_CNTAS_PAGAR_DET" 
  after delete on cntas_pagar_det
  for each row

declare
  -- local variables here
  lc_cod_origen origen.cod_origen%type ;

begin
  If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
     return;
  end if;

  SELECT origen
    INTO lc_cod_origen
    FROM cntas_pagar
   WHERE ((cod_relacion = :old.cod_relacion ) AND
          (tipo_doc     = :old.tipo_doc     ) AND
          (nro_doc      = :old.nro_doc      ));

   IF Not(:old.cencos is null ) THEN
      /*ELIMINAR AFETACION ANTERIOR*/
      DELETE FROM presupuesto_ejec
      WHERE ((origen_ref    = lc_cod_origen ) AND
             (tipo_doc_ref  = :old.tipo_doc ) AND
             (nro_doc_ref   = :old.nro_doc  ) AND
             (item_ref      = :old.item     )) ;
   END IF;

end tda_fin_cntas_pagar_det;


/
ALTER TRIGGER "CANTABRIA"."TDA_FIN_CNTAS_PAGAR_DET" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TDB_FIN_CNTAS_PAGAR_DET" 
  before delete on cntas_pagar_det
  for each row


declare
  -- local variables here
  lc_doc_oc          logparam.doc_oc%type ;
  lc_doc_os          logparam.doc_os%type ;
  lc_origen_ref      doc_referencias.origen_ref%type  ;
  lc_tipo_ref        doc_referencias.tipo_doc%type    ;
  lc_nro_ref         doc_referencias.nro_doc%type     ;
  lc_tdoc_ndp        doc_tipo.tipo_doc%type           ;
  lc_tdoc_ncp        doc_tipo.tipo_doc%type           ;
  ln_count           Number                           ;
  lc_flag_provision  finparam.flag_os_provision%type  ;
  ln_importe_x_item  cntas_pagar_det.importe%type     ;

  --Moneda
  lc_cod_moneda      moneda.cod_moneda%type           ;

  ln_tasa_cambio     calendario.cmp_dol_libre%type    ;

  -- AP_PARAM
  ls_doc_grmp        ap_param.doc_guia_mp%TYPE;

  -- AP_GUIA_RECEPCION_DET
  ls_nro_grmp        ap_guia_recepcion_det.cod_guia_rec%TYPE;
  Ln_item_grmp       ap_guia_recepcion_det.item%TYPE;

  ln_monto_fac_grmp   ap_guia_recepcion_det.monto_facturado%TYPE;
  ln_monto_tot_fac    ap_guia_recepcion_det.monto_facturado%TYPE;

  -- AP_GUIA_RECEPCION
  ls_moneda_grmp      ap_guia_recepcion.cod_moneda%TYPE;

  -- Articulo_mov_proy
  ln_Cant_facturada   articulo_mov_proy.cant_facturada%TYPE;
  ls_tipo_doc_amp     articulo_mov_proy.tipo_doc%TYPE;
  ls_nro_doc_amp      articulo_mov_proy.nro_doc%TYPE;

  -- Orden_Servicio_det
  ln_imp_provisionado orden_servicio_det.imp_provisionado%TYPE;


begin
  -- Edgar Morante Miercoles 10Jul2002, replicacion
  If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
     return;
  end if;


  /*Recupero tipo de doc Orden de Compra*/
  select doc_oc,doc_os into lc_doc_oc,lc_doc_os
    from logparam
   where (reckey = '1') ;

  select nvl(f.flag_os_provision,'0')
    into lc_flag_provision
    from finparam f
   where reckey = '1' ;

  /*Recuperacion de Tipo de Referencia*/
  select Count(*) into ln_count from doc_referencias
   where ((cod_relacion = :old.cod_relacion ) AND
          (tipo_doc     = :old.tipo_doc     ) AND
          (nro_doc      = :old.nro_doc      ) AND
          (flab_tabor   in ('7','8')        ));

  if ln_count > 0 then
     /*Recuperacion de Tipo de Referencia*/
     select origen_ref,tipo_ref,nro_ref into lc_origen_ref,lc_tipo_ref,lc_nro_ref
       from doc_referencias
      where ((cod_relacion = :old.cod_relacion ) AND
             (tipo_doc     = :old.tipo_doc     ) AND
             (nro_doc      = :old.nro_doc      ) AND
             (flab_tabor   in ('7','8')        ));
  end if ;


  SELECT nota_cred_nfc,nota_deb_ncc,flag_os_provision
    INTO lc_tdoc_ncp,lc_tdoc_ndp,lc_flag_provision
    FROM finparam
   WHERE (reckey = '1') ;

  -- actualizo la cantidad facturada de Articulo_mov_proy (Orden de compra)
  IF  :old.org_amp_ref is not null and :old.nro_amp_ref is not null and
      :old.tipo_doc not in (pq_doc_finanzas.is_doc_ncp, pq_doc_finanzas.is_doc_ndp, pq_doc_finanzas.is_doc_cnc) THEN

      select nvl(amp.cant_facturada, 0), amp.tipo_doc, amp.nro_doc
        into ln_cant_facturada, ls_tipo_doc_amp, ls_nro_doc_amp
        from articulo_mov_proy amp
       where amp.cod_origen = :old.org_amp_ref
         and amp.nro_mov    = :old.nro_amp_ref for update;

      if ln_cant_facturada - :old.cantidad < 0 then
         RAISE_APPLICATION_ERROR( -20000, 'La cantidad a provisionar no puede sobrepasar a la cantidad procesada. Por favor verifique. '
                            || chr(13) || 'Tipo Doc: ' || ls_tipo_doc_amp
                            || chr(13) || 'Nro Doc: ' || ls_nro_doc_amp
                            || chr(13) || 'Articulo: ' || NVL(:old.cod_art,'')
                            || chr(13) || 'Cant. Facturada: ' || to_char(ln_cant_facturada, '999,990.00')
                            || chr(13) || 'Cant. Provisi?n: ' || to_char(:old.cantidad, '999,990.00'));
      end if;

       UPDATE articulo_mov_proy amp
          SET cant_facturada = ln_cant_facturada - NVL(:old.cantidad,0),
              flag_replicacion = '0'
        where amp.cod_origen = :old.org_amp_ref
         and amp.nro_mov     = :old.nro_amp_ref;
  end if;

  -- Actualizo el improte facturado de la Orden de Servicio
  if :old.org_os is not null and :old.nro_os is not null and :old.item_os is not null AND
     :old.tipo_doc not in (pq_doc_finanzas.is_doc_ncp, pq_doc_finanzas.is_doc_ndp, pq_doc_finanzas.is_doc_cnc) then

     select count(*)
       into ln_count
       from orden_servicio_det osd
      where osd.cod_origen = :old.org_os
        and osd.nro_os     = :old.nro_os
        and osd.nro_item   = :old.item_os;

     if ln_count > 0 then
        select NVL(osd.imp_provisionado, 0)
          into ln_imp_provisionado
          from orden_servicio_det osd
         where osd.cod_origen = :old.org_os
           and osd.nro_os     = :old.nro_os
           and osd.nro_item   = :old.item_os for update;

        IF ln_imp_provisionado - :old.importe < 0 THEN
            RAISE_APPLICATION_ERROR( -20000, 'El importe Facturado de la Orden de Servicio es negativo. Por favor verifique. '
                               || chr(13) || 'Tipo Doc: ' || lc_doc_os
                               || chr(13) || 'Nro Doc: ' || :old.nro_os
                               || chr(13) || 'Item OS: ' || NVL(:old.item_os,'')
                               || chr(13) || 'Importe Provisionado: ' || to_char(ln_imp_provisionado, '999,990.00')
                               || chr(13) || 'Importe. a Provisionar: ' || to_char(:old.importe, '999,990.00'));
        end if;

        UPDATE orden_servicio_det osd
           SET osd.imp_provisionado = ln_imp_provisionado - :old.importe,
               flag_replicacion     = '0'
        where osd.cod_origen = :old.org_os
          and osd.nro_os     = :old.nro_os
          and osd.nro_item   = :old.item_os;
     end if;
  END IF ;


  --============================================================================
  -- Si documento de Referencia es una Guia de Recepcion de Materia Prima
  --============================================================================
  SELECT l.doc_guia_mp
     INTO ls_doc_grmp
  FROM   ap_param l
  WHERE l.origen = 'XX';

  IF ls_doc_grmp IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'No ha definido documento de Guia de Recepcion de '
      || 'Materia Prima en AP_PARAM');
     RETURN ;
  END IF;

  -- Recupera el tipo de cambio
  SELECT cp.tasa_cambio
    INTO ln_tasa_cambio
    FROM cntas_pagar cp
   WHERE ((cp.cod_relacion = :OLD.cod_relacion ) AND
          (cp.tipo_doc     = :OLD.tipo_doc     ) AND
          (cp.nro_doc      = :OLD.nro_doc      ));

  IF :OLD.tipo_ref = ls_doc_grmp THEN
       ls_nro_grmp  := :OLD.nro_ref;
       ln_item_grmp := :OLD.item_ref;

       select count(*)
         into ln_count
         from ap_guia_recepcion
        where cod_guia_rec = ls_nro_grmp;


       if ln_count = 0 then
          RAISE_APPLICATION_ERROR(-20000, 'No existe la Guia de Recepcion Nro: ' || ls_nro_grmp);
       end if;

       --Obtengo la moneda de la cabecera de la GRMP
       SELECT COD_MONEDA
        INTO ls_moneda_grmp
       FROM  ap_guia_recepcion
       WHERE cod_guia_rec = ls_nro_grmp;

       -- Obtengo el monto facturado del detalle de la GRMP
       SELECT nvl(a.monto_facturado,0)
        INTO  ln_monto_fac_grmp
       FROM   ap_guia_recepcion_det a
       WHERE  a.cod_guia_rec = ls_nro_grmp
         AND  a.item         = ln_item_grmp;

       -- Verificamos que el importe facturado no sea negativo
       ln_importe_x_item := :OLD.importe ;
       IF ls_moneda_grmp <> lc_cod_moneda THEN
          IF ls_moneda_grmp = PKG_LOGISTICA.is_soles THEN
             ln_importe_x_item := ROUND(ln_importe_x_item * ln_tasa_cambio,2);
          ELSE
             ln_importe_x_item := Round(ln_importe_x_item / ln_tasa_cambio,2);
          END IF;
       END IF;

       -- Calculo el monto total facturado
       ln_monto_tot_fac := ln_monto_fac_grmp - ln_importe_x_item ;

       -- Actualizo el monto total facturado de la GRMP
       UPDATE AP_GUIA_RECEPCION_DET
           SET monto_facturado = ln_monto_tot_fac
        WHERE  cod_guia_rec = ls_nro_grmp
         AND   item         = ln_item_grmp;

  END IF;
  --============================================================================

end TDB_FIN_CNTAS_PAGAR_DET;


/
ALTER TRIGGER "CANTABRIA"."TDB_FIN_CNTAS_PAGAR_DET" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TIA_FIN_CNTAS_PAGAR_DET" 
  after insert on cntas_pagar_det
  for each row

declare
  -- local variables here
  lc_doc_oc          logparam.doc_oc%type ;
  lc_doc_os          logparam.doc_os%type ;
  lc_ncred_x_pagar   doc_tipo.tipo_doc%type           ;
  lc_ndeb_x_pagar    doc_tipo.tipo_doc%type           ;
  lc_comp_egr        doc_tipo.tipo_doc%type           ;
  ln_importe_x_item  cntas_pagar_det.importe%type     ;
  ln_importe_dol     cntas_pagar_det.importe%type     ;


  lc_cod_moneda      moneda.cod_moneda%type           ;
  lc_soles           moneda.cod_moneda%type           ;
  lc_dolares         moneda.cod_moneda%type           ;
  ln_tasa_cambio     calendario.cmp_dol_libre%type    ;
  lc_flag_control    presupuesto_partida.flag_ctrl%type ;
  ld_fecha_emision   cntas_pagar.fecha_emision%type   ;
  ln_ano             Number(4) ;
  ln_mes             Number(2) ;
  ln_count           Number ;
  ln_referencias     number;
  lc_cod_origen      cntas_pagar.origen%type          ;

  lc_flag_provisionado  cntas_pagar.flag_provisionado%TYPE;
  lc_flag_afecta_presup doc_tipo.flag_afecta_prsp%type      ;
  lc_flag_provision     finparam.flag_os_provision%type     ;
  lc_usr                usuario.cod_usr%type                ;

  -- Articulo_mov_proy
  ln_cant_procesada     articulo_mov_proy.cant_procesada%TYPE;
  ln_cant_facturada     articulo_mov_proy.cant_facturada%TYPE;
  ls_tipo_doc_amp       articulo_mov_proy.tipo_doc%TYPE;
  ls_nro_doc_amp        articulo_mov_proy.nro_doc%TYPE;

  --Orden de Servicio
  ln_importe_os         orden_Servicio_det.importe%TYPE;
  ln_imp_provisionado   orden_servicio_det.imp_provisionado%TYPE;

 -- AP_Param
  ls_doc_grmp        ap_param.doc_guia_mp%TYPE;

  --Ap_guia_recepcion
  ls_moneda_grmp     ap_guia_recepcion.cod_moneda%TYPE;
  ls_nro_grmp        ap_guia_recepcion.cod_guia_rec%TYPE;

  --Ap_guia_recepcion_det
  ln_importe_grmp     ap_guia_recepcion_det.monto_facturado%TYPE;
  ln_precio_grmp      ap_guia_recepcion_det.precio_unitario%TYPE;
  ln_peso_grmp        ap_guia_recepcion_det.peso_venta%TYPE;
  ln_item_grmp        ap_guia_recepcion_det.item%TYPE;
  ln_monto_fac_grmp   ap_guia_recepcion_det.monto_facturado%TYPE;
  ln_monto_tot_fac    ap_guia_recepcion_det.monto_facturado%TYPE;
  --



begin

  -- Edgar Morante Miercoles 10Jul2002, replicacion
  If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
     return;
  end if;

  /*Buscar Soles , Dolares , Orden Compra*/

  SELECT cod_soles ,cod_dolares ,doc_oc  ,doc_os
    INTO lc_soles  ,lc_dolares ,lc_doc_oc ,lc_doc_os
    FROM logparam
   WHERE (reckey = '1') ;

  /************************/

  /*Buscar Nota Debito , Nota de Credito x Pagar*/
  select f.nota_cred_nfc,f.nota_deb_ncc,Nvl(f.flag_os_provision,'0')
    into lc_ncred_x_pagar,lc_ndeb_x_pagar,lc_flag_provision
    from finparam f
   where (reckey = '1') ;

  -- actualizo la cantidad facturada de Articulo_mov_proy (Orden de compra)
  IF  :new.org_amp_ref is not null and :new.nro_amp_ref is not null and
      :new.tipo_doc not in (pq_doc_finanzas.is_doc_ncp, pq_doc_finanzas.is_doc_ndp, pq_doc_finanzas.is_doc_cnc)   THEN

      select nvl(amp.cant_procesada, 0), nvl(amp.cant_facturada, 0), amp.tipo_doc, amp.nro_doc
        into ln_cant_procesada, ln_cant_facturada, ls_tipo_doc_amp, ls_nro_doc_amp
        from articulo_mov_proy amp
       where amp.cod_origen = :new.org_amp_ref
         and amp.nro_mov    = :new.nro_amp_ref for update;

      if ln_cant_procesada < ln_cant_facturada + :new.cantidad then
         RAISE_APPLICATION_ERROR( -20000, 'La cantidad a provisionar no puede sobrepasar a la cantidad procesada. Por favor verifique. '
                            || chr(13) || 'Tipo Doc: ' || ls_tipo_doc_amp
                            || chr(13) || 'Nro Doc: ' || ls_nro_doc_amp
                            || chr(13) || 'Articulo: ' || NVL(:new.cod_art,'')
                            || chr(13) || 'Cant. Procesada: ' || to_char(ln_cant_procesada, '999,990.00')
                            || chr(13) || 'Cant. Facturada: ' || to_char(ln_cant_facturada, '999,990.00')
                            || chr(13) || 'Cant. a Provisionar: ' || to_char(:new.cantidad, '999,990.00'));
      end if;

       UPDATE articulo_mov_proy amp
          SET cant_facturada = ln_cant_facturada + NVL(:new.cantidad,0),
              flag_replicacion = '0'
        where amp.cod_origen = :new.org_amp_ref
         and amp.nro_mov     = :new.nro_amp_ref;
  end if;

  -- Actualizo el improte facturado de la Orden de Servicio
  if :new.org_os is not null and :new.nro_os is not null and :new.item_os is not null and
     :new.tipo_doc not in (pq_doc_finanzas.is_doc_ncp, pq_doc_finanzas.is_doc_ndp, pq_doc_finanzas.is_doc_cnc) then

     select (Nvl(osd.importe,0) - Nvl(osd.decuento,0)), NVL(osd.imp_provisionado, 0)
       into ln_importe_os, ln_imp_provisionado
       from orden_servicio_det osd
      where osd.cod_origen = :new.org_os
        and osd.nro_os     = :new.nro_os
        and osd.nro_item   = :new.item_os for update;

     IF ln_importe_os < ln_imp_provisionado + :new.importe THEN
         RAISE_APPLICATION_ERROR( -20000, 'El importe de la factura no puede superar al importe del item de la Orden de Servicio. Por favor verifique. '
                            || chr(13) || 'Tipo Doc: ' || lc_doc_os
                            || chr(13) || 'Nro Doc: ' || :new.nro_os
                            || chr(13) || 'Item OS: ' || NVL(:new.item_os,'')
                            || chr(13) || 'Importe OS: ' || to_char(ln_importe_os, '999,990.00')
                            || chr(13) || 'Importe Provisionado: ' || to_char(ln_imp_provisionado, '999,990.00')
                            || chr(13) || 'Importe. a Provisionar: ' || to_char(:new.importe, '999,990.00'));
     end if;

     UPDATE orden_servicio_det osd
        SET osd.imp_provisionado = ln_imp_provisionado + :new.importe,
            flag_replicacion     = '0'
     where osd.cod_origen = :new.org_os
        and osd.nro_os     = :new.nro_os
        and osd.nro_item   = :new.item_os;

  END IF ;

  /*Afectacion Presupuestal*/
  SELECT Count(*)
    INTO ln_count
    FROM doc_referencias
   WHERE ((cod_relacion = :new.cod_relacion ) AND
          (tipo_doc     = :new.tipo_doc     ) AND
          (nro_doc      = :new.nro_doc      )) ;

--
  select cp.cod_moneda,cp.tasa_cambio,cp.fecha_emision,cp.origen,mes,cp.flag_provisionado,cp.cod_usr
    into lc_cod_moneda,ln_tasa_cambio,ld_fecha_emision,lc_cod_origen,ln_mes,lc_flag_provisionado,lc_usr
    FROM cntas_pagar cp
   WHERE ((cp.cod_relacion = :new.cod_relacion ) AND
          (cp.tipo_doc     = :new.tipo_doc     ) AND
          (cp.nro_doc      = :new.nro_doc      ));



  --datos de maestro de documentos (flag de afectacion presupuestal para documentos porpagardirecto)
  select dt.flag_afecta_prsp
    into lc_flag_afecta_presup
    from doc_tipo dt
   where dt.tipo_doc =:new.tipo_doc ;

  IF lc_soles = lc_cod_moneda THEN
    /*Convertir a Dolares*/

    ln_importe_x_item := :new.importe ;
    ln_importe_dol    := Round(ln_importe_x_item / ln_tasa_cambio ,2) ;

  ELSE
    ln_importe_dol    := :new.importe ;
  END IF ;


  /*Documento Comprobante de Egreso*/
  SELECT comprobante_egr
    INTO lc_comp_egr
    FROM finparam
   WHERE (reckey = '1') ;

  IF lc_flag_provisionado = 'D' OR  lc_flag_provisionado = 'N' THEN --DIRECTO
     ln_mes := to_number(to_char(ld_fecha_emision,'MM'  )) ;
  END IF ;

  ln_ano := to_number(to_char(ld_fecha_emision,'YYYY')) ;

  IF (ln_referencias = 0 OR lc_flag_provisionado in ('D','N')) and lc_flag_afecta_presup = '1' THEN
     IF Not(:new.cencos is null ) THEN


        /*VERIFICA PARTIDA*/
        USP_FIN_VERIF_PRESUP_PARTIDA(ln_ano,:new.cencos,:new.cnta_prsp,lc_flag_control) ;

        IF lc_flag_control <> '0' THEN
           --Valida Afectacion presupuestalmente
           usp_pto_afecta_ejecucion(ln_mes,ln_ano, :new.cencos,:new.cnta_prsp,Nvl(ln_importe_dol,0) );
        END IF ;

        /*Inserta Presupuesto Ejecucion*/
        --replicacion
        Insert Into presupuesto_ejec
        (cod_origen   ,ano         ,cencos  ,cnta_prsp  ,
         fecha        ,descripcion ,importe ,origen_ref ,
         tipo_doc_ref ,nro_doc_ref ,item_ref,flag_replicacion,
         cod_rel_ref  ,cod_usr, centro_benef)
        Values
        (lc_cod_origen     ,ln_ano, :new.cencos,:new.cnta_prsp ,
         ld_fecha_emision  ,Substr(rtrim(ltrim(:new.descripcion)),1,40),Nvl(ln_importe_dol *-1,0),
         lc_cod_origen     ,:new.tipo_doc, :new.nro_doc,:new.item,'0' ,
         :new.cod_relacion ,lc_usr, :NEW.centro_benef ) ;
     ELSE
        raise_application_error(-20000,'Debe Colocar Centro de Costo ,Verifique !') ;
     END IF;
  ELSE


     /*Afectacion Presupuestal de Acuerdo a Documento*/
     IF :new.tipo_doc = lc_ndeb_x_pagar THEN
        /*Nota debito x Pagar (Disminuir)*/
        /*VERIFICA PARTIDA*/
        USP_FIN_VERIF_PRESUP_PARTIDA(ln_ano,:new.cencos,:new.cnta_prsp,lc_flag_control);

        IF lc_flag_control <> '0' THEN
           --Valida Afectacion presupuestalmente
           usp_pto_afecta_ejecucion(ln_mes         ,ln_ano      , :new.cencos,
                                   :new.cnta_prsp ,ln_importe_dol );
        END IF ;

        /*Inserta Presupuesto Ejecucion*/
        --replicacion
        Insert Into presupuesto_ejec
        (cod_origen   ,ano         ,cencos  ,cnta_prsp  ,
         fecha        ,descripcion ,importe ,origen_ref ,
         tipo_doc_ref ,nro_doc_ref ,item_ref,flag_replicacion ,
         cod_rel_ref  ,cod_usr, centro_benef)
        Values
        (lc_cod_origen    ,ln_ano        ,:new.cencos ,:new.cnta_prsp ,
         ld_fecha_emision ,Substr(rtrim(ltrim(:new.descripcion)),1,40),ln_importe_dol *-1,
         lc_cod_origen    ,:new.tipo_doc ,:new.nro_doc,:new.item,'0',
         :new.cod_relacion,lc_usr, :NEW.centro_benef);

     ELSIF :new.tipo_doc = lc_ncred_x_pagar THEN
        /*Nota Credito x Pagar (Devolver)*/
        /*VERIFICA PARTIDA*/
        USP_FIN_VERIF_PRESUP_PARTIDA(ln_ano,:new.cencos,:new.cnta_prsp,lc_flag_control);

        IF lc_flag_control <> '0' THEN
           /*Inserta Presupuesto Ejecucion*/
           usp_pto_afecta_ejecucion(ln_mes,ln_ano, :new.cencos,
                                   :new.cnta_prsp ,ln_importe_dol * -1);
        END IF ;
        --replicacion
        Insert Into presupuesto_ejec
        (cod_origen   ,ano         ,cencos  ,cnta_prsp  ,
         fecha        ,descripcion ,importe ,origen_ref ,
         tipo_doc_ref ,nro_doc_ref,item_ref,flag_replicacion,
         cod_rel_ref  ,cod_usr, centro_benef)
        Values
        (lc_cod_origen    ,ln_ano        ,:new.cencos ,:new.cnta_prsp ,
         ld_fecha_emision ,Substr(rtrim(ltrim(:new.descripcion)),1,40),ln_importe_dol ,
         lc_cod_origen    ,:new.tipo_doc ,:new.nro_doc ,:new.item,'0' ,
         :new.cod_relacion, lc_usr, :NEW.centro_benef) ;

     END IF ;
  END IF ;

 --============================================================================
 -- Si documento de Referencia es una Guia de Recepcion de Materia Prima
 --============================================================================
  SELECT count(*)
     INTO ln_count
  FROM   ap_param l
  WHERE l.origen = 'XX';

  if ln_count = 0 then
      RAISE_APPLICATION_ERROR(-20000, 'No ha definido parametros generasles en AP_PARAM ');
  end if;

  SELECT l.doc_guia_mp
     INTO ls_doc_grmp
  FROM   ap_param l
  WHERE l.origen = 'XX';

  IF ls_doc_grmp IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'No ha definido documento de Guia de Recepcion de '
      || 'Materia Prima en AP_PARAM');
  END IF;

  IF :NEW.tipo_ref = ls_doc_grmp THEN
       ls_nro_grmp  := :NEW.nro_ref;
       ln_item_grmp := :NEW.item_ref;

       --Obtengo la moneda de la cabecera de la GRMP
       SELECT COD_MONEDA
         INTO ls_moneda_grmp
         FROM  ap_guia_recepcion
        WHERE cod_guia_rec = ls_nro_grmp;

       -- Obtengo el precio y peso del detalle de la GRMP
       SELECT NVL(a.precio_unitario, 0) + NVL(a.precio_unitario_castigo, 0) +
              NVL(a.precio_representacion, 0 ) + NVL(a.precio_ajuste_cntbl,0),
              NVL(a.peso_venta,0),
              NVL(a.monto_facturado,0)
        INTO  ln_precio_grmp, ln_peso_grmp, ln_monto_fac_grmp
       FROM   ap_guia_recepcion_det a
       WHERE  a.cod_guia_rec = ls_nro_grmp
         AND  a.item         = ln_item_grmp;
       -- Obtengo el monto total del detalle de la GRMP
       ln_importe_grmp := ROUND(ln_precio_grmp * ln_peso_grmp, 2);

       -- Verificamos que el importe facturado no exceda el monto por facturar de la grmp
       ln_importe_x_item := :new.importe ;
       IF ls_moneda_grmp <> lc_cod_moneda THEN
          IF ls_moneda_grmp = lc_soles THEN
             ln_importe_x_item := Round(ln_importe_x_item * ln_tasa_cambio,2);
          ELSE
             ln_importe_x_item := Round(ln_importe_x_item / ln_tasa_cambio,2);
          END IF;
       END IF;

       -- Calculo el monto total facturado
       ln_monto_tot_fac := ln_monto_fac_grmp + ln_importe_x_item ;

       -- Actualizo el monto total facturado de la GRMP
       IF ln_monto_tot_fac <= (ln_importe_grmp + 1) THEN
            UPDATE AP_GUIA_RECEPCION_DET
               SET monto_facturado = ln_monto_tot_fac
            WHERE  cod_guia_rec = ls_nro_grmp
             AND   item         = ln_item_grmp;
       ELSE
           RAISE_APPLICATION_ERROR(-20000, 'Monto a Facturar excede el monto total de la GRMP '
            ||CHR(13) || 'Por favor Verifique '
            ||CHR(13) || 'Nro de GRMP     ==> ' || ls_nro_grmp
            ||CHR(13) || 'Nro de Item GRMP==> ' || TO_CHAR(ln_item_grmp)
            ||CHR(13) || 'Monto_Item_GRMP ==> ' || TO_CHAR(ln_importe_grmp)
            ||CHR(13) || 'Monto_Facturado ==> ' || TO_CHAR(ln_monto_tot_fac));
           RETURN ;
       END IF;

  END IF;
  --============================================================================

end TIA_FIN_CNTAS_PAGAR_DET;

---COMENTARIOS
--ULTIMO CAMBIO PARA ACTUALIZAR IMPORTE PROVISIONADO
--Ultimo cambio para referencias las GRMP,


/
ALTER TRIGGER "CANTABRIA"."TIA_FIN_CNTAS_PAGAR_DET" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TIB_CNTAS_PAGAR_DET" 
  before insert on cntas_pagar_det
  for each row
declare
  -- local variables here
begin
  if length(:new.descripcion) > 60 then
     :new.descripcion := substr(:new.descripcion, 1, 60);
  end if;
end tib_cntas_pagar_det;


/
ALTER TRIGGER "CANTABRIA"."TIB_CNTAS_PAGAR_DET" ENABLE;
 
  CREATE OR REPLACE TRIGGER "CANTABRIA"."TUB_FIN_CNTAS_PAGAR_DET" 
  before update on cntas_pagar_det
  for each row


declare
  -- local variables here
  lc_doc_oc          logparam.doc_oc%type ;
  lc_doc_os          logparam.doc_os%type ;
  lc_origen_ref      doc_referencias.origen_ref%type  ;
  lc_tipo_ref        doc_referencias.tipo_doc%type    ;
  lc_ncred_x_pagar   doc_tipo.tipo_doc%type           ;
  lc_ndeb_x_pagar    doc_tipo.tipo_doc%type           ;
  lc_nro_ref         doc_referencias.nro_doc%type     ;
  lc_flag_control    presupuesto_partida.flag_ctrl%type ;
  ln_count           Number ;
  ln_mes             Number (2) ;
  ln_ano             Number (4) ;
  ln_tasa_cambio     calendario.cmp_dol_libre%type    ;
  ln_importe_x_item  cntas_pagar.total_pagar%type     ;
  ln_importe_dol     cntas_pagar.total_pagar%type     ;
  ld_fecha_emision   cntas_pagar.fecha_emision%type   ;
  lc_cod_origen      cntas_pagar.origen%type          ;
  lc_soles           moneda.cod_moneda%type           ;
  lc_dolares         moneda.cod_moneda%type           ;
  lc_cod_moneda      moneda.cod_moneda%Type           ;
  lc_comp_egr        DOC_TIPO.TIPO_DOC%TYPE           ;
  ln_cant_fact       cntas_pagar_det.cantidad%TYPE    ;
  ln_nro_mov         articulo_mov_proy.nro_mov%type   ;
  ln_cant_fact_old   cntas_pagar_det.cantidad%TYPE    ;
  ln_cant_fact_new   cntas_pagar_det.cantidad%TYPE    ;
  ln_cant_fact_cal   cntas_pagar_det.cantidad%TYPE    ;
  ln_cant_pendiente  cntas_pagar_det.cantidad%TYPE    ;
  lc_flag_provisionado  cntas_pagar.flag_provisionado%TYPE ;
  lc_flag_afecta_presup doc_tipo.flag_afecta_prsp%type     ;
  lc_flag_provision     finparam.flag_os_provision%type    ;
  ln_importe_old        orden_servicio_det.importe%type  ;
  ln_importe_prov       orden_servicio_det.importe%type  ;
  ln_item_os            orden_servicio_det.nro_item%type ;
  ln_importe_fac_cal    orden_servicio_det.importe%type  ;
  lc_usr                usuario.cod_usr%type             ;

  -- AP_PARAM
  ls_doc_grmp        ap_param.doc_guia_mp%TYPE;

  -- AP_GUIA_RECEPCION_DET
  ls_nro_grmp         ap_guia_recepcion_det.cod_guia_rec%TYPE;
  Ln_item_grmp        ap_guia_recepcion_det.item%TYPE;
  ln_monto_fac_grmp   ap_guia_recepcion_det.monto_facturado%TYPE;
  ln_monto_tot_fac    ap_guia_recepcion_det.monto_facturado%TYPE;

  -- AP_GUIA_RECEPCION
  ls_moneda_grmp      ap_guia_recepcion.cod_moneda%TYPE;

 Cursor c_art_mov_x_art_fact  is /*Articulo Movimiento Proyectado X Articulo Facturado*/
  SELECT Nvl(cant_facturada,0) as cant_facturada,
         nro_mov
    FROM articulo_mov_proy ARTMP
   WHERE ((tipo_doc = lc_doc_oc    )  AND
          (nro_doc  = lc_nro_ref   )  AND
          (cod_art  = :new.cod_art )) AND
          (cant_facturada > 0      )
order by cant_facturada DESC         ;


 Cursor c_art_mov_x_art_pend  is /*Articulo Movimiento Proyectado X Articulo Pendientes*/
  SELECT Nvl(cant_procesada,0) - Nvl(cant_facturada,0) as cant_pendiente,
         nro_mov
    FROM articulo_mov_proy
   WHERE ((tipo_doc = lc_doc_oc    ) AND
          (nro_doc  = lc_nro_ref   ) AND
          (cod_art  = :new.cod_art )) AND
          (Nvl(cant_procesada,0) - Nvl(cant_facturada,0) ) > 0
order by (Nvl(cant_procesada,0) - Nvl(cant_facturada,0) ) DESC ;

Cursor c_det_serv_fact is /*Detalle de Orden de Servicio*/
select Nvl(osd.imp_provisionado,0) as imp_provisionado,
       osd.nro_item
  from orden_servicio_det osd
 where (osd.cod_origen      = lc_origen_ref  ) and
       (osd.nro_os          = lc_nro_ref     ) and
       (osd.conformidad_usr is not null      ) and
       (Nvl(imp_provisionado,0) > 0          ) ;


Cursor c_det_servicio is /*Detalle de Orden de Servicio*/
select (Nvl(osd.importe,0) - Nvl(osd.decuento,0)) - Nvl(osd.imp_provisionado,0) as
imp_pendiente,
       osd.nro_item
  from orden_servicio_det osd
 where (osd.cod_origen      = lc_origen_ref  ) and
       (osd.nro_os          = lc_nro_ref     ) and
       (osd.conformidad_usr is not null      ) and
       ((Nvl(importe,0) - Nvl(decuento,0)) - Nvl(imp_provisionado,0)) > 0 ;



begin
  -- Edgar Morante Miercoles 10Jul2002, replicacion
  If (dbms_reputil.from_remote=true or dbms_snapshot.i_am_a_refresh=true) then
     return;
  end if;

  /*Buscar Soles , Dolares*/

  select cod_soles ,cod_dolares into lc_soles  ,lc_dolares
    from logparam
   where (reckey = '1') ;

   /*Buscar Nota Debito , Nota de Credito x Pagar*/
   select f.nota_cred_nfc,f.nota_deb_ncc,f.flag_os_provision into lc_ncred_x_pagar,lc_ndeb_x_pagar,lc_flag_provision
     from finparam f
    where (reckey = '1') ;

   /*Recupero tipo de doc Orden de Compra*/
   select doc_oc,doc_os into lc_doc_oc,lc_doc_os
     from logparam
    where (reckey = '1') ;

   /*Recuperacion de Tipo de Referencia*/
   select Count(*) into ln_count
     from doc_referencias
    where ((cod_relacion = :new.cod_relacion ) AND
           (tipo_doc     = :new.tipo_doc     ) AND
           (nro_doc      = :new.nro_doc      ) AND
           (flab_tabor   in ('7','8')        ));

   IF ln_count > 0 THEN
      /*Recuperacion de Tipo de Referencia*/
      select origen_ref,tipo_ref,nro_ref into lc_origen_ref,lc_tipo_ref,lc_nro_ref
        from doc_referencias
       where ((cod_relacion = :new.cod_relacion ) AND
              (tipo_doc     = :new.tipo_doc     ) AND
              (nro_doc      = :new.nro_doc      ) AND
              (flab_tabor   in ('7','8')        ));
   END IF ;



  /************************/
  IF  Not(:new.cod_art is null )  THEN
      IF lc_tipo_ref = lc_doc_oc THEN   /*Documento Orden de Compra*/
         IF :old.cantidad <> :new.cantidad THEN

            ln_cant_fact_old := Nvl(:old.cantidad,0) ;
            --restar a todos los facturados
            ---ABRIR EL CURSOR
            OPEN c_art_mov_x_art_fact ;
                 LOOP
                    --RECUPERAR INFORMACION
                    FETCH c_art_mov_x_art_fact INTO ln_cant_fact,ln_nro_mov ;

                    ln_cant_fact_cal  := Nvl(ln_cant_fact_old,0) - Nvl(ln_cant_fact,0) ;


                    IF ln_cant_fact_cal > 0 THEN
                       --ASIGNO NUEVA CANTIDAD PARA DISMINUIR FACTURACION
                       ln_cant_fact_old := Nvl(ln_cant_fact_cal,0) ;
                       --Actualiza Articulo Movimiento Proyectado
                       /************************************************************
                         REPLICACION
                       *************************************************************/

                        UPDATE articulo_mov_proy
                           SET cant_facturada = Nvl(cant_facturada,0) - ln_cant_fact,flag_replicacion = '0'
                         WHERE (nro_mov = ln_nro_mov) ;



                    ELSIF ln_cant_fact_cal < 0 THEN
                       /************************************************************
                         REPLICACION
                       *************************************************************/
                       ln_cant_fact := Nvl(ln_cant_fact,0) - Nvl(Abs(ln_cant_fact_cal),0);


                        UPDATE articulo_mov_proy
                           SET cant_facturada = Nvl(cant_facturada,0) - ln_cant_fact,flag_replicacion = '0'
                         WHERE (nro_mov = ln_nro_mov) ;



                        EXIT ;
                    ELSE
                       /************************************************************
                         REPLICACION
                       *************************************************************/

                       UPDATE articulo_mov_proy
                           SET cant_facturada = Nvl(cant_facturada,0) - ln_cant_fact_old,flag_replicacion = '0'
                         WHERE (nro_mov = ln_nro_mov) ;

                        EXIT ;

                    END IF ;
                     --salida de bucle
                    EXIT WHEN c_art_mov_x_art_fact%NOTFOUND ;
                 END LOOP ;
            CLOSE c_art_mov_x_art_fact ;



            --incrementar cantidad facturada
            ln_cant_fact_new := Nvl(:new.cantidad,0) ;
            ---ABRIR EL CURSOR
            OPEN c_art_mov_x_art_pend ;
                 LOOP
                    --RECUPERAR INFORMACION
                    FETCH c_art_mov_x_art_pend INTO ln_cant_pendiente,ln_nro_mov ;

                    ln_cant_fact_cal := Nvl(ln_cant_fact_new,0) - Nvl(ln_cant_pendiente,0) ;


                    IF ln_cant_fact_cal > 0 THEN
                       --ASIGNO NUEVA CANTIDAD PARA FACTURAR
                       ln_cant_fact_new := Nvl(ln_cant_fact_cal,0) ;
                       --Actualiza Articulo Movimiento Proyectado
                       /************************************************************
                         REPLICACION
                       *************************************************************/

                       UPDATE articulo_mov_proy
                          SET cant_facturada = Nvl(cant_facturada,0) + ln_cant_pendiente,flag_replicacion = '0'
                        WHERE (nro_mov = ln_nro_mov) ;



                       --si no existe nada pendiente y cantidad facturada por aplicar es> 0 error
                       select Count (*)  into ln_count from articulo_mov_proy
                        where ((tipo_doc = lc_doc_oc    ) AND
                               (nro_doc  = lc_nro_ref   ) AND
                               (cod_art  = :new.cod_art )) AND
                               (Nvl(cant_procesada,0) - Nvl(cant_facturada,0) ) > 0 ;

                       if ln_count = 0 and ln_cant_fact_new > 0 then
                          RAISE_APPLICATION_ERROR( -20000, 'No existe Cantidad Pendientes para Aplicar Facturar '
                                                          ||'Verificar Cantidad a Facturar de Articulo '||:new.cod_art ) ;
                       end if ;

                    ELSE
                       /************************************************************
                         REPLICACION
                       *************************************************************/

                       UPDATE articulo_mov_proy
                          SET cant_facturada = Nvl(cant_facturada,0) + ln_cant_fact_new,flag_replicacion = '0'
                        WHERE (nro_mov = ln_nro_mov) ;
                        --salir de programa
                       EXIT ;
                    END IF ;
                    --salida de bucle
                    EXIT WHEN c_art_mov_x_art_pend%NOTFOUND ;
                 END LOOP ;
            CLOSE c_art_mov_x_art_pend ;




         END IF ;
      END IF ;
  ELSE
      IF (lc_tipo_ref = lc_doc_os) and lc_flag_provision = '1' THEN   /*Documento Orden de Servicio*/
         IF :old.importe <> :new.importe THEN

            ln_importe_old      := Nvl(:old.importe,0) ;
            --restar a todos los provisionado
            ---ABRIR EL CURSOR
            OPEN c_det_serv_fact ;
                 LOOP
                    --RECUPERAR INFORMACION
                    FETCH c_det_serv_fact INTO ln_importe_prov,ln_item_os ;


                    IF c_det_serv_fact%NOTFOUND THEN
                       EXIT ;
                    END IF ;

                    ln_importe_fac_cal  := Nvl(ln_importe_old,0) - Nvl(ln_importe_prov,0);


                    IF ln_importe_fac_cal > 0 THEN
                       --ASIGNO NUEVA CANTIDAD PARA DISMINUIR FACTURACION
                       ln_importe_old := Nvl(ln_importe_fac_cal,0) ;

                       --Actualiza Articulo Movimiento Proyectado
                        UPDATE orden_servicio_det osd
                           SET imp_provisionado = Nvl(imp_provisionado,0) - ln_importe_prov,flag_replicacion = '0'
                         where (osd.cod_origen      = lc_origen_ref  ) and
                               (osd.nro_os          = lc_nro_ref     ) and
                               (osd.nro_item        = ln_item_os     ) ;

                    ELSIF ln_importe_fac_cal < 0 THEN
                       ln_importe_prov := Nvl(ln_importe_prov,0) - Nvl(Abs(ln_importe_fac_cal),0) ;

                        update orden_servicio_det osd
                           set osd.imp_provisionado = Nvl(osd.imp_provisionado,0) - ln_importe_prov,flag_replicacion = '0'
                         where (osd.cod_origen      = lc_origen_ref  ) and
                               (osd.nro_os          = lc_nro_ref     ) and
                               (osd.nro_item        = ln_item_os     ) ;

                        EXIT ;
                    ELSE

                        update orden_servicio_det osd
                           set osd.imp_provisionado = Nvl(osd.imp_provisionado,0) - ln_importe_old,flag_replicacion = '0'
                         where (osd.cod_origen      = lc_origen_ref  ) and
                               (osd.nro_os          = lc_nro_ref     ) and
                               (osd.nro_item        = ln_item_os     ) ;

                        EXIT ;

                    END IF ;
                     --salida de bucle
                    EXIT WHEN c_det_serv_fact%NOTFOUND ;
                 END LOOP ;
            CLOSE c_det_serv_fact ;



            --incrementa importe provisionado
            ln_importe_old      := Nvl(:new.importe,0) ;

            ---ABRIR EL CURSOR
            OPEN c_det_servicio ;
                 LOOP
                 --RECUPERAR INFORMACION
                 FETCH c_det_servicio INTO ln_importe_prov,ln_item_os ;

                 IF c_det_servicio%NOTFOUND THEN
                    EXIT ;
                 END IF ;

                 ln_importe_fac_cal := Nvl(ln_importe_old,0) - Nvl(ln_importe_prov,0) ;

                 IF ln_importe_fac_cal > 0 THEN
                    --ASIGNO NUEVA CANTIDAD PARA FACTURAR
                    ln_importe_old := Nvl(ln_importe_fac_cal,0) ;

                    --Actualiza orden servicio detalle
                    UPDATE orden_servicio_det osd
                       SET osd.imp_provisionado = Nvl(osd.imp_provisionado,0) + ln_importe_prov,flag_replicacion = '0'
                     WHERE (osd.cod_origen = lc_origen_ref ) and
                           (osd.nro_os     = lc_nro_ref    ) and
                           (osd.nro_item   = ln_item_os    ) ;

                    --si no existe nada pendiente y cantidad facturada por aplicar es > 0error
                    select Count (*)  into ln_count from orden_servicio_det osd
                     where (osd.cod_origen = lc_origen_ref ) and
                           (osd.nro_os     = lc_nro_ref    ) and
                           (osd.conformidad_usr is not null) and
                          ((Nvl(importe,0) - Nvl(decuento,0)) - Nvl(imp_provisionado,0)) > 0 ;


                    if ln_count = 0 and ln_importe_old > 0 then
                       RAISE_APPLICATION_ERROR( -20000, 'No existe Cantidad Pendientes para Aplicar Facturar '
                                                      ||'Verificar Cantidad a Facturar de Articulo '||:new.cod_art ) ;
                    end if ;

                 ELSE
                    --replicacion  Actualiza detalle de Orden Servicio
                    update orden_servicio_det osd
                       set osd.imp_provisionado = Nvl(osd.imp_provisionado,0) + ln_importe_old ,flag_replicacion = '0'
                     where (osd.cod_origen = lc_origen_ref ) and
                           (osd.nro_item   = ln_item_os    ) and
                           (osd.nro_os     = lc_nro_ref    ) ;
                    --salir de programa
                    EXIT ;
                 END IF ;

              --salida de bucle
            EXIT WHEN c_det_servicio%NOTFOUND ;
          END LOOP ;
         CLOSE c_det_servicio ;





         END IF ;

      END IF;
  END IF ;


  /*AFECTACION PRESUPUESTAL*/
   SELECT Count(*)
    INTO ln_count
    FROM doc_referencias
   WHERE ((cod_relacion = :new.cod_relacion ) AND
          (tipo_doc     = :new.tipo_doc     ) AND
          (nro_doc      = :new.nro_doc      )) ;

--
   /*Datos Para Afectacion Presupuestal*/
   SELECT cp.cod_moneda,cp.tasa_cambio,cp.fecha_emision,cp.origen,cp.mes,cp.flag_provisionado,cp.cod_usr
     INTO lc_cod_moneda,ln_tasa_cambio,ld_fecha_emision,lc_cod_origen,ln_mes,lc_flag_provisionado,lc_usr
     FROM cntas_pagar cp
    WHERE ((cp.cod_relacion = :new.cod_relacion ) AND
           (cp.tipo_doc     = :new.tipo_doc     ) AND
           (cp.nro_doc      = :new.nro_doc      ));



  /*Maestro de Documentos*/
  --datos de maestro de documentos (flag de afectacion presupuestal para documentos porpagar directo)
  select dt.flag_afecta_prsp into lc_flag_afecta_presup from doc_tipo dt where (dt.tipo_doc = :new.tipo_doc) ;



   IF lc_soles = lc_cod_moneda THEN
      /*Convertir a Dolares*/
      ln_importe_x_item := :new.importe ;
      ln_importe_dol    := Round(ln_importe_x_item / ln_tasa_cambio ,2) ;
   ELSE
      ln_importe_dol    := :new.importe ;
   END IF ;



  /*Documento Comprobante de Egreso*/
  SELECT comprobante_egr
    INTO lc_comp_egr
    FROM finparam
   WHERE (reckey = '1') ;

  IF lc_flag_provisionado = 'D' OR  lc_flag_provisionado = 'N' THEN --DIRECTO
     ln_mes := to_number(to_char(ld_fecha_emision,'MM'  )) ;
  END IF ;



   ln_ano := to_number(to_char(ld_fecha_emision,'YYYY')) ;

   IF (ln_count = 0 OR lc_flag_provisionado in ('D','N')) and lc_flag_afecta_presup = '1' THEN
      IF Not(:old.cencos is null ) THEN
        /*ELIMINAR AFETACION ANTERIOR*/
        /*Elimina Movimiento Anterior e Inserto Nuevo Movimiento*/
        DELETE FROM presupuesto_ejec
        WHERE ((origen_ref    = lc_cod_origen ) AND
               (tipo_doc_ref  = :old.tipo_doc ) AND
               (nro_doc_ref   = :old.nro_doc  ) AND
               (item_ref      = :old.item     )) ;

        /*verifico partida presupuestal*/
        USP_FIN_VERIF_PRESUP_PARTIDA(ln_ano,:new.cencos,:new.cnta_prsp,lc_flag_control);

        IF lc_flag_control <> '0' THEN
           --Valida Afectacion presupuestalmente
           usp_pto_afecta_ejecucion(ln_mes         ,ln_ano      , :new.cencos,
                                   :new.cnta_prsp ,ln_importe_dol );
        END IF;


        IF ln_importe_dol > 0 THEN
           /*Inserta Presupuesto Ejecucion*/

           /**************************************************************************************
            REPLICACION
            ***************************************************************************************/
           Insert Into presupuesto_ejec
           (cod_origen   ,ano         ,cencos  ,cnta_prsp  ,
            fecha        ,descripcion ,importe ,origen_ref ,
            tipo_doc_ref ,nro_doc_ref ,item_ref,flag_replicacion,
            cod_rel_ref, cod_usr, centro_benef)
           Values
           (lc_cod_origen    ,ln_ano        ,:new.cencos ,:new.cnta_prsp ,
            ld_fecha_emision ,Substr(rtrim(ltrim(:new.descripcion)),1,40),ln_importe_dol * -1,
            lc_cod_origen    ,:new.tipo_doc ,:new.nro_doc ,:new.item,'0',
            :new.cod_relacion, lc_usr, :NEW.centro_benef) ;
        END IF ;
     ELSE
        raise_application_error(-20000,'Debe Colocar Centro de Costo ,Verifique !') ;

     END IF;
  ELSE
     /*Afectacion Presupuestal de Acuerdo a Documento*/
     IF :new.tipo_doc = lc_ndeb_x_pagar THEN
        /*Nota debito x Pagar (Disminuir)*/

       /*Elimina Movimiento Anterior e Inserto Nuevo Movimiento*/
        DELETE FROM presupuesto_ejec
        WHERE ((origen_ref    = lc_cod_origen ) AND
               (tipo_doc_ref  = :old.tipo_doc ) AND
               (nro_doc_ref   = :old.nro_doc  ) AND
               (item_ref      = :old.item     )) ;



        /*verifico partida presupuestal*/
        USP_FIN_VERIF_PRESUP_PARTIDA(ln_ano,:new.cencos,:new.cnta_prsp,lc_flag_control);

        IF lc_flag_control <> '0' THEN
           --Valida Afectacion presupuestalmente
           usp_pto_afecta_ejecucion(ln_mes         ,ln_ano      , :new.cencos,
                                    :new.cnta_prsp ,ln_importe_dol );
        END IF ;

        IF ln_importe_dol > 0 THEN
          /*Inserta Presupuesto Ejecucion*/

          /*********************************************************************************
            REPLICACION
          **********************************************************************************/
          Insert Into presupuesto_ejec
          (cod_origen   ,ano         ,cencos  ,cnta_prsp  ,
           fecha        ,descripcion ,importe ,origen_ref ,
           tipo_doc_ref ,nro_doc_ref ,item_ref,flag_replicacion,cod_rel_ref,
           cod_usr      , centro_benef)
          Values
          (lc_cod_origen    ,ln_ano        ,:new.cencos ,:new.cnta_prsp ,
           ld_fecha_emision ,Substr(rtrim(ltrim(:new.descripcion)),1,40),ln_importe_dol *-1,
           lc_cod_origen    ,:new.tipo_doc ,:new.nro_doc,:new.item,'0',:new.cod_relacion   ,
           lc_usr           ,:NEW.centro_benef) ;
        END IF ;
     ELSIF :new.tipo_doc = lc_ncred_x_pagar THEN
        /*Nota Credito x Pagar (Devolver)*/
        /*Elimina Movimiento Anterior e Inserto Nuevo Movimiento*/
        DELETE FROM presupuesto_ejec
        WHERE ((origen_ref    = lc_cod_origen ) AND
               (tipo_doc_ref  = :old.tipo_doc ) AND
               (nro_doc_ref   = :old.nro_doc  ) AND
               (item_ref      = :old.item     )) ;


        /*verifico partida presupuestal*/
        USP_FIN_VERIF_PRESUP_PARTIDA(ln_ano,:new.cencos,:new.cnta_prsp,lc_flag_control);

        IF lc_flag_control <> '0' THEN
           /*Inserta Presupuesto Ejecucion*/
           usp_pto_afecta_ejecucion(ln_mes         ,ln_ano      , :new.cencos,
                                    :new.cnta_prsp ,ln_importe_dol * -1);
        END IF ;

        IF ln_importe_dol > 0 THEN
           /****************************************************************************
            REPLICACION
           *****************************************************************************/
           Insert Into presupuesto_ejec
           (cod_origen   ,ano         ,cencos  ,cnta_prsp  ,
            fecha        ,descripcion ,importe ,origen_ref ,
            tipo_doc_ref ,nro_doc_ref ,item_ref,flag_replicacion,cod_rel_ref,
            cod_usr      ,centro_benef)
           Values
           (lc_cod_origen    ,ln_ano        ,:new.cencos ,:new.cnta_prsp ,
            ld_fecha_emision ,Substr(rtrim(ltrim(:new.descripcion)),1,40),ln_importe_dol,
            lc_cod_origen    ,:new.tipo_doc ,:new.nro_doc,:new.item,'0',:new.cod_relacion,
            lc_usr           ,:NEW.centro_benef) ;
        END IF ;

     END IF ;
  END IF ;

  --============================================================================
  -- Si documento de Referencia es una Guia de Recepci?n de Materia Prima
  --============================================================================
  SELECT l.doc_guia_mp
     INTO ls_doc_grmp
  FROM   ap_param l
  WHERE l.origen = 'XX';

  IF ls_doc_grmp IS NULL THEN
      RAISE_APPLICATION_ERROR(-20000, 'No ha definido documento de Guia de Recepcion de '
      || 'Materia Prima en AP_PARAM');
     RETURN ;
  END IF;

  IF :NEW.tipo_ref = ls_doc_grmp THEN
       ls_nro_grmp  := :NEW.nro_ref;
       ln_item_grmp := :NEW.item_ref;
       --Obtengo la moneda de la cabecera de la GRMP
       SELECT COD_MONEDA
        INTO ls_moneda_grmp
       FROM  ap_guia_recepcion
       WHERE cod_guia_rec = ls_nro_grmp;
       -- Obtengo el monto facturado del detalle de la GRMP
       SELECT nvl(a.monto_facturado,0)
        INTO  ln_monto_fac_grmp
       FROM   ap_guia_recepcion_det a
       WHERE  a.cod_guia_rec = ls_nro_grmp
         AND  a.item         = ln_item_grmp;

       -- Verificamos que el importe facturado no sea negativo
       ln_importe_x_item := :NEW.importe ;
       ln_importe_old    := NVL(:OLD.importe,0);
       IF ls_moneda_grmp <> lc_cod_moneda THEN
          IF ls_moneda_grmp = lc_soles THEN
             ln_importe_x_item := Round(ln_importe_x_item * ln_tasa_cambio,2);
          ELSE
             ln_importe_x_item := Round(ln_importe_x_item / ln_tasa_cambio,2);
          END IF;
       END IF;

       -- Calculo el monto total facturado
       ln_monto_tot_fac := (ln_monto_fac_grmp - ln_importe_old) + ln_importe_x_item ;

       -- Actualizo el monto total facturado de la GRMP
       insert into tt_fin_tub_cntas_pagar(flag_trigger)
       values('1');

       UPDATE AP_GUIA_RECEPCION_DET
           SET monto_facturado = ln_monto_tot_fac
        WHERE  cod_guia_rec = ls_nro_grmp
         AND   item         = ln_item_grmp;

  END IF;
  --============================================================================

end TUB_FIN_CNTAS_PAGAR_DET;


/
ALTER TRIGGER "CANTABRIA"."TUB_FIN_CNTAS_PAGAR_DET" ENABLE;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR_DET1" ON "CANTABRIA"."CNTAS_PAGAR_DET" ("ORG_AM", "NRO_AM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 3145728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR_DET2" ON "CANTABRIA"."CNTAS_PAGAR_DET" ("ORG_AMP_REF", "NRO_AMP_REF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 3145728 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR_DET3" ON "CANTABRIA"."CNTAS_PAGAR_DET" ("NRO_VALE_TRANS", "ITEM_VALE_TRANS") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 458752 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR_DET4" ON "CANTABRIA"."CNTAS_PAGAR_DET" ("NRO_OS", "ITEM_OS") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 2097152 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR_DET5" ON "CANTABRIA"."CNTAS_PAGAR_DET" ("COD_RELACION", "TIPO_DOC", "NRO_DOC", "TIPO_CRED_FISCAL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 46137344 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

CREATE INDEX "CANTABRIA"."IX_CNTAS_PAGAR_DET6" ON "CANTABRIA"."CNTAS_PAGAR_DET" ("TIPO_REF", "NRO_REF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

COMMENT ON TABLE CANTABRIA.CNTAS_PAGAR_DET IS 'Cntas Pagar Det';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.COD_RELACION IS 'cod relacion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.TIPO_DOC IS 'tipo doc';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.NRO_DOC IS 'Nro Doc';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.ITEM IS 'item';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.DESCRIPCION IS 'descripcion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.COD_ART IS 'cod articulo';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.CONFIN IS 'confin';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.CANTIDAD IS 'cantidad';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.IMPORTE IS 'importe';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.CENCOS IS 'centro costo';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.CNTA_PRSP IS 'CNTA PRSP';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.TIPO_CRED_FISCAL IS 'Tipo Cred Fiscal';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.FLAG_REPLICACION IS 'flag_replicacion';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.ORG_AMP_REF IS 'org amp ref';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.NRO_AMP_REF IS 'nro amp ref';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.CENTRO_BENEF IS 'CENTRO_BENEF';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.ORIGEN_REF IS 'origen_ref';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.TIPO_REF IS 'tipo_ref';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.NRO_REF IS 'nro_ref';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.ITEM_REF IS 'item_ref';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.FEC_MOVILIDAD IS 'FEC_MOVILIDAD';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.MOV_DESDE IS 'mov_desde';
COMMENT ON COLUMN CANTABRIA.CNTAS_PAGAR_DET.MOV_HASTA IS 'mov_hasta';


-- CANTABRIA.CNTAS_PAGAR foreign keys

ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PAGAR_BANCO" FOREIGN KEY ("COD_BANCO")
	  REFERENCES "CANTABRIA"."BANCO" ("COD_BANCO") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PAGAR_CONFIN" FOREIGN KEY ("CONFIN")
	  REFERENCES "CANTABRIA"."CONCEPTO_FINANCIERO" ("CONFIN") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PAGAR_SUNAT_TABLA30" FOREIGN KEY ("CLASE_BIEN_SERV")
	  REFERENCES "CANTABRIA"."SUNAT_TABLA30" ("CODIGO") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_11447_JOB" FOREIGN KEY ("JOB")
	  REFERENCES "CANTABRIA"."JOB" ("JOB") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_15089_MOTIVO_N" FOREIGN KEY ("MOTIVO")
	  REFERENCES "CANTABRIA"."MOTIVO_NOTA" ("MOTIVO") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_15840_DOC_TIPO" FOREIGN KEY ("TIPO_DOC")
	  REFERENCES "CANTABRIA"."DOC_TIPO" ("TIPO_DOC") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_17425_ADUANA_D" FOREIGN KEY ("COD_ADUANA")
	  REFERENCES "CANTABRIA"."ADUANA_DEPENDENCIA" ("COD_ADUANA") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_19550_CNTBL_AS" FOREIGN KEY ("ORIGEN", "ANO", "MES", "NRO_LIBRO", "NRO_ASIENTO")
	  REFERENCES "CANTABRIA"."CNTBL_ASIENTO" ("ORIGEN", "ANO", "MES", "NRO_LIBRO", "NRO_ASIENTO") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_36218_DETRACCI" FOREIGN KEY ("NRO_DETRACCION")
	  REFERENCES "CANTABRIA"."DETRACCION" ("NRO_DETRACCION") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_44411_BANCO" FOREIGN KEY ("BANCO_LTR")
	  REFERENCES "CANTABRIA"."BANCO" ("COD_BANCO") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_45660_RETENCIO" FOREIGN KEY ("NRO_CERTIFICADO")
	  REFERENCES "CANTABRIA"."RETENCION_IGV_CRT" ("NRO_CERTIFICADO") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_71567_DETR_BIE" FOREIGN KEY ("BIEN_SERV")
	  REFERENCES "CANTABRIA"."DETR_BIEN_SERV" ("BIEN_SERV") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_71567_DETR_OPE" FOREIGN KEY ("OPER_DETR")
	  REFERENCES "CANTABRIA"."DETR_OPERACION" ("OPER_DETR") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_79832_MONEDA" FOREIGN KEY ("COD_MONEDA")
	  REFERENCES "CANTABRIA"."MONEDA" ("COD_MONEDA") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_79832_PROVEEDO" FOREIGN KEY ("COD_RELACION")
	  REFERENCES "CANTABRIA"."PROVEEDOR" ("PROVEEDOR") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_79838_USUARIO" FOREIGN KEY ("COD_USR")
	  REFERENCES "CANTABRIA"."USUARIO" ("COD_USR") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR" ADD CONSTRAINT "FK_CNTAS_PA_REF_86879_FORMA_PA" FOREIGN KEY ("FORMA_PAGO")
	  REFERENCES "CANTABRIA"."FORMA_PAGO" ("FORMA_PAGO") ENABLE;


-- CANTABRIA.CNTAS_PAGAR_DET foreign keys

ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PAGAR_ARTICULO_MOV" FOREIGN KEY ("ORG_AM", "NRO_AM")
	  REFERENCES "CANTABRIA"."ARTICULO_MOV" ("COD_ORIGEN", "NRO_MOV") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PAGAR_DET_OSD" FOREIGN KEY ("ORG_OS", "NRO_OS", "ITEM_OS")
	  REFERENCES "CANTABRIA"."ORDEN_SERVICIO_DET" ("COD_ORIGEN", "NRO_OS", "NRO_ITEM") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PAGAR_VALE_TRANS_DET" FOREIGN KEY ("NRO_VALE_TRANS", "ITEM_VALE_TRANS")
	  REFERENCES "CANTABRIA"."VALE_MOV_TRANS_DET" ("NRO_VALE", "NRO_ITEM") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_12025_CENTRO_B" FOREIGN KEY ("CENTRO_BENEF")
	  REFERENCES "CANTABRIA"."CENTRO_BENEFICIO" ("CENTRO_BENEF") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_12173_CENTROS_" FOREIGN KEY ("CENCOS")
	  REFERENCES "CANTABRIA"."CENTROS_COSTO" ("CENCOS") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_12173_PRESUPUE" FOREIGN KEY ("CNTA_PRSP")
	  REFERENCES "CANTABRIA"."PRESUPUESTO_CUENTA" ("CNTA_PRSP") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_12288_CREDITO_" FOREIGN KEY ("TIPO_CRED_FISCAL")
	  REFERENCES "CANTABRIA"."CREDITO_FISCAL" ("TIPO_CRED_FISCAL") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_14740_DOC_TIPO" FOREIGN KEY ("TIPO_REF")
	  REFERENCES "CANTABRIA"."DOC_TIPO" ("TIPO_DOC") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_14740_ORIGEN" FOREIGN KEY ("ORIGEN_REF")
	  REFERENCES "CANTABRIA"."ORIGEN" ("COD_ORIGEN") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_80094_CNTAS_PA" FOREIGN KEY ("COD_RELACION", "TIPO_DOC", "NRO_DOC")
	  REFERENCES "CANTABRIA"."CNTAS_PAGAR" ("COD_RELACION", "TIPO_DOC", "NRO_DOC") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_80095_ARTICULO" FOREIGN KEY ("COD_ART")
	  REFERENCES "CANTABRIA"."ARTICULO" ("COD_ART") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_81645_CONCEPTO" FOREIGN KEY ("CONFIN")
	  REFERENCES "CANTABRIA"."CONCEPTO_FINANCIERO" ("CONFIN") ENABLE;
 
  ALTER TABLE "CANTABRIA"."CNTAS_PAGAR_DET" ADD CONSTRAINT "FK_CNTAS_PA_REF_89491_ARTICULO" FOREIGN KEY ("ORG_AMP_REF", "NRO_AMP_REF")
	  REFERENCES "CANTABRIA"."ARTICULO_MOV_PROY" ("COD_ORIGEN", "NRO_MOV") ENABLE;

-- CANTABRIA.MATRIZ_CNTBL_FINAN definition

CREATE TABLE "CANTABRIA"."MATRIZ_CNTBL_FINAN" 
   (	"MATRIZ" CHAR(8) NOT NULL ENABLE, 
	"DESCRIPCION" VARCHAR2(100), 
	"FLAG_ESTADO" CHAR(1) DEFAULT '1', 
	"FLAG_REPLICACION" CHAR(1) DEFAULT '1', 
	 CONSTRAINT "PK_MATRIZ_CNTBL_FINAN" PRIMARY KEY ("MATRIZ")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

COMMENT ON TABLE CANTABRIA.MATRIZ_CNTBL_FINAN IS 'Matriz Cntbl Finan';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN.MATRIZ IS 'matriz';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN.DESCRIPCION IS 'descripcion';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN.FLAG_ESTADO IS 'flag estado';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN.FLAG_REPLICACION IS 'flag_replicacion';


-- CANTABRIA.MATRIZ_CNTBL_FINAN_DET definition

CREATE TABLE "CANTABRIA"."MATRIZ_CNTBL_FINAN_DET" 
   (	"MATRIZ" CHAR(8) NOT NULL ENABLE, 
	"ITEM" NUMBER(4,0) NOT NULL ENABLE, 
	"CNTA_CTBL" CHAR(10), 
	"FLAG_DEBHAB" CHAR(1), 
	"DATAWINDOW" VARCHAR2(30), 
	"CAMPO" VARCHAR2(30), 
	"FORMULA" VARCHAR2(100), 
	"GLOSA_TEXTO" VARCHAR2(60), 
	"GLOSA_CAMPO" VARCHAR2(60), 
	"FLAG_CENCOS" CHAR(1) DEFAULT '0', 
	"FLAG_CTABCO" CHAR(1) DEFAULT '0', 
	"FLAG_DOCREF" CHAR(1) DEFAULT '0', 
	"FLAG_REPLICACION" CHAR(1) DEFAULT '1', 
	 CONSTRAINT "PK_MATRIZ_CNTBL_FINAN_DET" PRIMARY KEY ("MATRIZ", "ITEM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 196608 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CANTABRIA" ;

COMMENT ON TABLE CANTABRIA.MATRIZ_CNTBL_FINAN_DET IS 'Matriz Cntbl Finan Det';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.MATRIZ IS 'matriz';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.ITEM IS 'item';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.CNTA_CTBL IS 'Cuenta Contable';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.FLAG_DEBHAB IS 'flag_debhab';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.DATAWINDOW IS 'datawindow';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.CAMPO IS 'campo';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.FORMULA IS 'formula';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.GLOSA_TEXTO IS 'glosa texto';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.GLOSA_CAMPO IS 'glosa campo';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.FLAG_CENCOS IS 'flag cencos';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.FLAG_CTABCO IS 'flag ctabco';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.FLAG_DOCREF IS 'flag docref';
COMMENT ON COLUMN CANTABRIA.MATRIZ_CNTBL_FINAN_DET.FLAG_REPLICACION IS 'flag_replicacion';


-- CANTABRIA.MATRIZ_CNTBL_FINAN_DET foreign keys

ALTER TABLE "CANTABRIA"."MATRIZ_CNTBL_FINAN_DET" ADD CONSTRAINT "FK_MATRIZ_C_REF_78252_MATRIZ_C" FOREIGN KEY ("MATRIZ")
	  REFERENCES "CANTABRIA"."MATRIZ_CNTBL_FINAN" ("MATRIZ") ENABLE;
 
  ALTER TABLE "CANTABRIA"."MATRIZ_CNTBL_FINAN_DET" ADD CONSTRAINT "FK_MATRIZ_C_REF_78758_CNTBL_CN" FOREIGN KEY ("CNTA_CTBL")
	  REFERENCES "CANTABRIA"."CNTBL_CNTA" ("CNTA_CTBL") ENABLE;