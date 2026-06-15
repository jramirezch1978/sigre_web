-------------------------------------------------------
-- Export file for user CANTABRIA@HADES              --
-- Created by jramirez on 15/05/2026, 07:17:03 p. m. --
-------------------------------------------------------

set define off
spool views_cantabria.log

prompt
prompt Creating view CHEQUEAR
prompt ======================
prompt
create or replace force view cantabria.chequear as
select a.cod_art,a.nom_articulo,a.sub_cat_art,a.cod_clase
from articulo a
where substr(a.sub_cat_art,1,3)='037' --or substr(a.sub_cat_art,1,3)='083' or substr(a.sub_cat_art,1,3)='084'
;

prompt
prompt Creating view C_SOL
prompt ===================
prompt
create or replace force view cantabria.c_sol as
Select decode(a.cod_moneda ,(select cod_soles from logparam ),sum(b.importe),round(sum(b.importe) / a.tasa_cambio,2)) AS X
from cntas_pagar a, cntas_pagar_det b
where a.cod_relacion = b.cod_relacion and
      a.tipo_doc    = b.tipo_doc     and
      a.nro_doc     = b.nro_doc      and
      a.ANO = 2005 and
      a.mes = 1 and
      a.nro_libro = 3 and
      b.tipo_cred_fiscal = '01' and
      (a.tipo_doc NOT IN (select nota_cred_nfc from finparam where reckey = '1'
                          union
                          select nota_deb_ncc from finparam where reckey = '1'
                          union
                          select 'PZ' from finparam where reckey = '1'  ) )
group by a.cod_relacion,a.tipo_doc,a.nro_doc,a.cod_moneda,a.tasa_cambio;

prompt
prompt Creating view OC_1000
prompt =====================
prompt
create or replace force view cantabria.oc_1000 as
select oc.proveedor  ,p.nom_proveedor ,p.ruc ,oc.cod_moneda,
       DECODE(oc.cod_moneda ,'S/.',oc.monto_total,round(oc.monto_total *  usf_fin_tasa_cambio(oc.fec_registro),2 ) ) as monto
  from orden_compra oc,proveedor p
 where (oc.proveedor = p.proveedor) and
       (oc.flag_estado <> '0'     ) and
       (to_char(oc.fec_registro,'yyyy') >= 2005);

prompt
prompt Creating view OC_1001
prompt =====================
prompt
create or replace force view cantabria.oc_1001 as
select "CODIGO","DESCRIPCION","DIR_PAIS","DIR_DEP_ESTADO","DIR_PROVINCIA","DIR_CIUDAD","DIR_DISTRITO","DIR_URBANIZACION","DIR_DIRECCION","DIR_MNZ","DIR_LOTE","DIR_NUMERO","DIR_COD_POSTAL","FLAG_USO","FLAG_REPLICACION","ITEM","COD_PAIS","COD_DPTO","COD_PROV","COD_DISTR","FLAG_DIR_COMERCIAL" from direcciones where flag_uso = '1';

prompt
prompt Creating view TRABAJ_ADMIN
prompt ==========================
prompt
create or replace force view cantabria.trabaj_admin as
select m.cod_trabajador,
       rtrim(apel_paterno)||' '||rtrim(apel_materno)||' '||
       nvl(rtrim(nombre1),' ')||' '||nvl(rtrim(nombre2),' ') as nombre,
       m.cod_area, a.desc_area, m.cod_seccion, s.desc_seccion
from maestro m, area a, seccion s
where (m.cod_area = a.cod_area (+)) and
      (a.cod_area = s.cod_area) and
      (m.cod_seccion = s.cod_seccion (+));

prompt
prompt Creating view VC_CAM_TRABAJADOR_PROVEEDOR
prompt =========================================
prompt
create or replace force view cantabria.vc_cam_trabajador_proveedor as
select p.proveedor, p.nom_proveedor
    from proveedor p, maestro m
   where p.proveedor = m.cod_trabajador AND
         m.flag_estado <> '0';

prompt
prompt Creating view V_CHEQUEAR_CATEGORIA_ARTICULO
prompt ===========================================
prompt
create or replace force view cantabria.v_chequear_categoria_articulo as
select c.cat_art,c.desc_categoria,a.sub_cat_art,b.desc_sub_cat,a.cod_art,a.nom_articulo
from articulo a, articulo_sub_categ b, articulo_categ c
where a.sub_cat_art=b.cod_sub_cat and b.cat_art=c.cat_art
order by c.cat_art;

prompt
prompt Creating view V_CORR_CORTE
prompt ==========================
prompt
create or replace force view cantabria.v_corr_corte as
select cc.corr_corte as corr_corte,
         c.desc_campo as descripcion,
         cc.flag_estado as estado,
         cc.rend_esperado as rendimiento
    from CAMPO_CICLO cc, CAMPO c
   where cc.cod_campo = c.cod_campo;

prompt
prompt Creating view V_DOC_REC_DESTINOS
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.V_DOC_REC_DESTINOS AS
SELECT d.nombre destinatario, cc.desc_cencos centro_costo, e.nombre emrpesa FROM destinatario d inner join doc_rec_cencos cc on d.cencos = cc.cencos inner join doc_rec_empresa e on cc.cod_empresa = e.cod_empresa;

prompt
prompt Creating view V_EMPRESA_CENCOS
prompt ==============================
prompt
create or replace force view cantabria.v_empresa_cencos as
select drc.cencos, trim(dre.nombre)||' - '||trim(drc.desc_cencos) cencos_empresa
    from doc_rec_empresa dre, doc_rec_cencos drc
   where drc.cod_empresa = dre.cod_empresa;

prompt
prompt Creating view VM_CARGO_REAL_TRABAJADOR
prompt ======================================
prompt
create or replace force view cantabria.vm_cargo_real_trabajador as
select rh.cod_trabajador,m.apel_paterno,m.apel_materno,m.nombre1,m.nombre2
    from rh_cargo_real_trabajador rh, maestro m
    where rh.cod_trabajador = m.cod_trabajador;

prompt
prompt Creating view VW_AL_ALMACEN_ORIGEN
prompt ==================================
prompt
create or replace force view cantabria.vw_al_almacen_origen as
select a.almacen, initcap(a.desc_almacen) as desc_almacen, decode (upper(a.flag_tipo_almacen), 'M', 'Materiales', 'T', 'Productos Terminados', 'G', 'Generico', 'R', 'Repuestos', 'S', 'Subproductos', 'Otros') as tipo_almacen,  a.cod_origen, initcap(o.nombre) as nombre
      from almacen a
         left outer join origen o on a.cod_origen = o.cod_origen;

prompt
prompt Creating view VW_ALL_TABLAS
prompt ===========================
prompt
create or replace force view cantabria.vw_all_tablas as
select distinct(us.table_name) dato from  user_tables us
  minus
  select distinct(us.table_name) dato from user_tables us
  where us.temporary='Y';

prompt
prompt Creating view VW_ALL_TABLAS_FK
prompt ==============================
prompt
create or replace force view cantabria.vw_all_tablas_fk as
select us.table_name dato , count(*) nro_fk from user_constraints us
         where us.constraint_type='R' group by us.table_name;

prompt
prompt Creating view VW_ALL_TABLAS_MAESTRAS
prompt ====================================
prompt
create or replace force view cantabria.vw_all_tablas_maestras as
select t.dato from vw_all_tablas t
  minus
  select distinct(us.table_name) dato from user_constraints us
         where us.constraint_type='R';

prompt
prompt Creating view VW_ALMACEN
prompt ========================
prompt
create or replace force view cantabria.vw_almacen as
select vm.nro_vale, vm.tipo_mov, amt.desc_tipo_mov, a2.desc_sub_cat, vm.almacen,
       trunc(vm.fec_registro) as fecha,
       to_char(vm.fec_registro, 'mm') as mes,
       to_char(vm.fec_registro, 'yyyy') as ano,
       am.cod_art, a.desc_art, a.und, am.cant_procesada,
       am.precio_unit, am.cant_procesada * am.precio_unit as costo_total, cc.desc_cencos
from vale_mov vm,
     articulo_mov am,
     articulo_mov_tipo amt,
     articulo          a,
     articulo_sub_categ a2,
     centros_costo      cc
where vm.nro_vale = am.nro_vale
  and vm.tipo_mov = amt.tipo_mov
  and am.cod_art  = a.cod_Art
  and a.sub_cat_art = a2.cod_sub_cat
  and am.cencos     = cc.cencos (+)
  and vm.flag_estado <> '0'
  and am.flag_estado <> '0';

prompt
prompt Creating view VW_ALM_ARTICULOS_X_GUIA
prompt =====================================
prompt
create or replace force view cantabria.vw_alm_articulos_x_guia as
select g.cod_origen,
       g.nro_guia,
       vm.tipo_refer,
       vm.nro_refer,
       am.cod_art,
       am.nro_lote,
       am.nro_pallet,
       sum(am.cant_procesada) as cantidad,
       sum(am.Cant_Proc_Und2) AS cant_proc_und2,
       am.cod_moneda,
       gv.serie_dam,
       sum(am.costo_min_traslado) as costo_min_traslado,
       sum(am.peso_neto_tm) as peso_neto_kgr
  from guia g,
       guia_vale gv,
       vale_mov vm,
       articulo_mov am
 where g.cod_origen  = gv.origen_guia
   and g.nro_guia    = gv.nro_guia
   and gv.nro_vale   = vm.nro_vale
   and vm.cod_origen = am.cod_origen
   and vm.nro_vale = am.nro_vale
group by g.cod_origen,
         g.nro_guia,
         vm.tipo_refer,
         vm.nro_refer,
         am.cod_art,
         am.cod_moneda,
         am.nro_lote,
         am.nro_pallet,
         gv.serie_dam;

prompt
prompt Creating view VW_ALM_ART_RESERV_X_OT
prompt ====================================
prompt
create or replace force view cantabria.vw_alm_art_reserv_x_ot as
select distinct(amp.cod_art) as codigo, a.nom_articulo, a.und
from articulo_mov_proy amp, articulo a
where amp.cod_art=a.cod_art and
      amp.cant_reservado > 0 and
      a.flag_estado<>'0';

prompt
prompt Creating view VW_ALM_ART_X_GUIA_DET
prompt ===================================
prompt
create or replace force view cantabria.vw_alm_art_x_guia_det as
select g.cod_origen,
       g.nro_guia,
       vm.tipo_refer,
       vm.nro_refer,
       am.cod_art,
       am.cod_moneda,
       am.costo_min_traslado,
       am.cant_procesada,
       am.cant_proc_und2,
       am.nro_lote
  from guia g,
       guia_vale gv,
       vale_mov vm,
       articulo_mov am
 where g.cod_origen  = gv.origen_guia
   and g.nro_guia    = gv.nro_guia
   and gv.nro_vale   = vm.nro_vale
   and vm.cod_origen = am.cod_origen
   and vm.nro_vale   = am.nro_vale
order by g.cod_origen, g.nro_guia, vm.tipo_refer, vm.nro_refer,
   am.cod_art,am.cod_moneda;

prompt
prompt Creating view VW_ALM_CENCOS_PP
prompt ==============================
prompt
create or replace force view cantabria.vw_alm_cencos_pp as
select distinct cc.cencos,
                cc.desc_cencos,
                pp.ano
from centros_costo       cc,
     presupuesto_partida pp
where cc.cencos = pp.cencos
and cc.flag_estado = '1'
order by cc.desc_cencos;

prompt
prompt Creating view VW_ALM_CNTA_PRSP_PP
prompt =================================
prompt
create or replace force view cantabria.vw_alm_cnta_prsp_pp as
select distinct pc.cnta_prsp,
       pc.descripcion,
       pp.ano,
       pp.cencos
from presupuesto_cuenta   pc,
     presupuesto_partida  pp
where pp.cnta_prsp = pc.cnta_prsp
  and pp.flag_estado <> '0';

prompt
prompt Creating view VW_ALM_CUP_CUV
prompt ============================
prompt
create or replace force view cantabria.vw_alm_cup_cuv as
select case
           when instr(ac1.desc_categoria, 'ACEITE') > 0 then 'ACEITE DE PESCADO'
           when instr(ac1.desc_categoria, 'HARINA') > 0 then 'HARINA RESIDUAL'
           when instr(ac1.desc_categoria, 'MERLUZA') > 0 then 'MERLUZA'
           when instr(ac1.desc_categoria, 'ANCHOVETA') > 0 then 'ANCHOVETA'
           when instr(ac1.desc_categoria, 'CONCHA') > 0 then 'CONCHA DE ABANICO'
           when instr(ac1.desc_categoria, 'PERICO') > 0 then 'PERICO'
           when instr(ac1.desc_categoria, 'CALAMAR') > 0 then 'CALAMAR'
           when instr(ac1.desc_categoria, 'POTA') > 0 then 'POTA'
           when instr(ac1.desc_categoria, 'PAICHE') > 0 then 'PAICHE'
           when instr(ac1.desc_categoria, 'RESIDUOS') > 0 then 'RESIDUOS'
           when instr(ac1.desc_categoria, 'VOLADOR') > 0 then 'VOLADOR'
           when instr(ac1.desc_categoria, 'LANGOSTINO') > 0 then 'LANGOSTINO'
           ELSE
             'OTRAS ESPECIES'
         end as especie,
         as2.cat_art,
         as2.cod_sub_cat,
         as2.desc_sub_cat,
         to_number(to_char(vm.fec_registro, 'yyyy')) as año,
         to_number(to_char(vm.fec_registro, 'mm')) as mes,
         to_char(vm.fec_registro, 'yyyymm') as periodo,
         sum(am.cant_procesada) as cantidad_producida,
         sum(am.cant_procesada * am.precio_unit) as costo_total,
         sum(am.cant_procesada * am.precio_unit_ant) as costo_total_ant,
         case
           when sum(am.cant_procesada) > 0 then
             sum(am.cant_procesada * am.precio_unit) / sum(am.cant_procesada)
           else
             0
         end as costo_unit,
         case
           when sum(am.cant_procesada) > 0 then
             sum(am.cant_procesada * am.precio_unit_ant) / sum(am.cant_procesada)
           else
             0
         end as costo_unit_ant,
         nvl((select sum(usf_fl_conv_mon(ccd.precio_unitario, cc.cod_moneda, (select cod_soles from logparam where reckey = '1'), cc.fecha_documento) * ccd.cantidad) / sum(ccd.cantidad)
            from cntas_cobrar cc,
                 cntas_cobrar_det ccd,
                 articulo         a2
           where cc.tipo_doc = ccd.tipo_doc
             and cc.nro_doc  = ccd.nro_doc
             and cc.flag_estado <> '0'
             and ccd.cod_art    = a2.cod_art
             and a2.sub_cat_art = as2.cod_sub_cat
             and cc.ano = to_number(to_char(vm.fec_registro, 'yyyy'))
             and cc.mes = to_number(to_char(vm.fec_registro, 'mm'))), 0) as precio_venta_mensual,
         nvl((select sum(usf_fl_conv_mon(ccd.precio_unitario, cc.cod_moneda, (select cod_soles from logparam where reckey = '1'), cc.fecha_documento) * ccd.cantidad) / sum(ccd.cantidad)
            from cntas_cobrar cc,
                 cntas_cobrar_det ccd,
                 articulo         a2
           where cc.tipo_doc = ccd.tipo_doc
             and cc.nro_doc  = ccd.nro_doc
             and cc.flag_estado <> '0'
             and ccd.cod_art    = a2.cod_art
             and a2.sub_cat_art = as2.cod_sub_cat
             and cc.ano = to_number(to_char(vm.fec_registro, 'yyyy'))), 0) as precio_venta_anual


  from vale_mov vm,
       articulo_mov am,
       articulo     a,
       articulo_sub_categ as2,
       articulo_categ     ac1
  where vm.nro_vale = am.nro_vale
    and am.cod_art  = a.cod_art
    and a.sub_cat_art = as2.cod_sub_cat
    and as2.cat_art    = ac1.cat_art
    and vm.tipo_mov = 'I09'
    and a.cod_clase = '01'
    and vm.flag_estado <> '0'
    and am.flag_estado <> '0'
  group by case
             when instr(ac1.desc_categoria, 'ACEITE') > 0 then 'ACEITE DE PESCADO'
             when instr(ac1.desc_categoria, 'HARINA') > 0 then 'HARINA RESIDUAL'
             when instr(ac1.desc_categoria, 'MERLUZA') > 0 then 'MERLUZA'
             when instr(ac1.desc_categoria, 'ANCHOVETA') > 0 then 'ANCHOVETA'
             when instr(ac1.desc_categoria, 'CONCHA') > 0 then 'CONCHA DE ABANICO'
             when instr(ac1.desc_categoria, 'PERICO') > 0 then 'PERICO'
             when instr(ac1.desc_categoria, 'CALAMAR') > 0 then 'CALAMAR'
             when instr(ac1.desc_categoria, 'POTA') > 0 then 'POTA'
             when instr(ac1.desc_categoria, 'PAICHE') > 0 then 'PAICHE'
             when instr(ac1.desc_categoria, 'RESIDUOS') > 0 then 'RESIDUOS'
             when instr(ac1.desc_categoria, 'VOLADOR') > 0 then 'VOLADOR'
             when instr(ac1.desc_categoria, 'LANGOSTINO') > 0 then 'LANGOSTINO'
             ELSE
               'OTRAS ESPECIES'
           end,
           as2.cat_art,
           as2.cod_sub_cat,
           as2.desc_sub_cat,
           to_number(to_char(vm.fec_registro, 'yyyy')),
           to_number(to_char(vm.fec_registro, 'mm')),
           to_char(vm.fec_registro, 'yyyymm')
  order by periodo, especie, cod_sub_cat;

prompt
prompt Creating view VW_ALM_DESPACHOS
prompt ==============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_ALM_DESPACHOS AS
SELECT ov.COD_ORIGEN,
         ov.NRO_OV,
         ov.FLAG_ESTADO,
         ov.FEC_REGISTRO,
         ov.FORMA_PAGO,
         ov.COD_MONEDA,
         ov.MONTO_TOTAL,
         ov.MONTO_FACTURADO,
         ov.CLIENTE,
         ov.DESTINO,
         ov.PUNTO_PARTIDA,
         ov.COMPRADOR_FINAL,
         ov.TIPO_DOC,
         ov.NRO_DOC,
         ov.OBS,
         pv.NOM_PROVEEDOR,
         ap.COD_ART,
         ap.CANT_PROYECT as cantidad,
         ar.DESC_ART,
         ar.UND,
         vm.NRO_VALE,
         vm.ALMACEN,
         vm.FEC_REGISTRO AS fec_reg_alm,
         am.cod_art as cod_art_alm,
         am.cant_procesada
    FROM ORDEN_VENTA ov,
         PROVEEDOR pv,
         ARTICULO_MOV_PROY ap,
         ARTICULO ar,
         VALE_MOV vm,
         ARTICULO_MOV am
   WHERE ov.CLIENTE = pv.PROVEEDOR and
         ov.COD_ORIGEN = ap.COD_ORIGEN and
         ov.NRO_OV = ap.NRO_DOC and
         ap.COD_ART = ar.COD_ART and
         ov.COD_ORIGEN = vm.ORIGEN_REFER and
         ov.NRO_OV = vm.NRO_REFER and
         vm.cod_origen = am.cod_origen and
         vm.nro_vale = am.nro_vale and
         ov.FLAG_ESTADO >= '1' AND
         ov.FLAG_ESTADO <= '2' AND
         vm.flag_estado <> '0' AND
         ap.TIPO_DOC = (  SELECT lp.DOC_OV
                                                 FROM LOGPARAM lp
                                                WHERE lp.RECKEY = '1'  ) AND
         vm.TIPO_REFER = (  SELECT lp.DOC_OV
                                          FROM LOGPARAM lp
                                         WHERE lp.RECKEY = '1'  )
ORDER BY ov.FEC_REGISTRO ASC;

prompt
prompt Creating view VW_ALM_MAT_PRIMA
prompt ==============================
prompt
create or replace force view cantabria.vw_alm_mat_prima as
select distinct a.cod_art,
         a.desc_art,
         A.UND,
         vm.tipo_mov,
         trim(vm.tipo_mov) || ' - ' ||amt.desc_tipo_mov as desc_tipo_mov,
         vm.almacen,
         trim(vm.almacen) || ' - ' || al.desc_almacen as desc_almacen,
         amt.flag_contabiliza,
         vm.fec_registro,
         to_char(vm.fec_registro, 'dd') as dia,
         to_char(vm.fec_registro, 'yyyymm') as periodo,
         vm.tipo_doc_int, vm.nro_doc_int,
         vm.tipo_doc_ext, vm.nro_doc_ext,
         vm.tipo_refer, vm.nro_refer,
         decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni,
         am.cant_procesada * amt.factor_sldo_total as cantidad,
         am.cant_procesada * am.precio_unit * amt.factor_sldo_total as importe,
         al.flag_tipo_almacen,
         vm.nro_vale,
         vm.proveedor,
         p.nom_proveedor,
         p.ruc,
         (select nro_doc
             from cntas_pagar_det cpd
             where cpd.tipo_ref = vm.tipo_refer
               and cpd.nro_ref  = vm.nro_refer
               and rownum = 1) as Liquidacion_compra,
         (select cpd.tipo_doc || '-' || cpd.nro_doc
             from cntas_pagar_det cpd
             where cpd.org_am = am.cod_origen
               and cpd.nro_am = am.nro_mov
               and rownum = 1) as comprobante


  from vale_mov          vm,
       articulo_mov      am,
       articulo          a,
       articulo_mov_tipo amt,
       almacen           al,
       proveedor         p
  where vm.nro_vale = am.nro_vale
    and am.cod_art  = a.cod_art
    and vm.tipo_mov = amt.tipo_mov
    and vm.almacen  = al.almacen
    and vm.proveedor  = p.proveedor (+)
    and vm.flag_estado <> '0'
    and am.flag_estado <> '0'
    and a.cod_clase = '03'
  --  and vm.tipo_mov = 'I30'
;

prompt
prompt Creating view VW_ALM_MATRIZ
prompt ===========================
prompt
create or replace force view cantabria.vw_alm_matriz as
select distinct vm.tipo_mov,
       a2.cod_sub_cat,
       a2.desc_sub_cat,
       a.cod_art, a.desc_art,
       am.cencos, cc.grp_cntbl,
       vm.nro_vale,
       (select max(t.matriz)
          from tipo_mov_matriz_subcat t
         where t.tipo_mov = vm.tipo_mov
           and t.grp_cntbl = cc.grp_cntbl
           and t.cod_sub_cat = a2.cod_sub_cat) as matriz_amar,
       am.matriz
from vale_mov vm,
     articulo_mov am,
     centros_costo cc,
     articulo      a,
     articulo_sub_categ a2
where vm.nro_vale = am.nro_vale
  and am.cencos   = cc.cencos
  and vm.flag_estado <> '0'
  and am.flag_estado <> '0'
  and vm.tipo_mov = 'S01'
  and am.cod_art  = a.cod_art
  and a.sub_cat_art = a2.cod_sub_cat;

prompt
prompt Creating view VW_ALM_MOVIMIENTO
prompt ===============================
prompt
create or replace force view cantabria.vw_alm_movimiento as
select vm.almacen, al.desc_almacen,
       vm.cod_origen,
       vm.nro_vale,
       vm.fec_registro,
       vm.tipo_mov,
       vm.tipo_refer,
       vm.nro_refer,
       vm.tipo_doc_int,
       vm.nro_doc_int,
       vm.tipo_doc_ext,
       vm.nro_doc_ext,
       am.cod_art,
       am.cant_procesada,
       am.cant_proc_und2,
       am.precio_unit,
       am.cod_moneda ,
       am.decuento,
       am.origen_mov_proy,
       am.nro_mov_proy,
       am.matriz,
       NVL(amt.flag_ajuste_valorizacion,'0') as flag_ajuste_valorizacion,
       NVL(amt.factor_sldo_total, 0) as factor_sldo_total
  from vale_mov          vm,
       articulo_mov      am,
       articulo_mov_tipo amt,
       almacen           al
 Where vm.cod_origen  = am.cod_origen
   and vm.nro_vale    = am.nro_vale
   and amt.tipo_mov   = vm.tipo_mov
   and vm.almacen     = al.almacen
   and vm.flag_estado <> '0'
   and am.flag_estado <> '0'
order by vm.almacen, vm.fec_registro;

prompt
prompt Creating view VW_ALM_MOV_X_ARTICULO
prompt ===================================
prompt
create or replace force view cantabria.vw_alm_mov_x_articulo as
select vm.almacen, al.desc_almacen,
           vm.nro_vale,
           trunc(vm.fec_registro) as fec_movimiento,
           case
              when to_char(vm.fec_registro, 'mm') = '01' then '01.Ene'
              when to_char(vm.fec_registro, 'mm') = '02' then '02.Feb'
              when to_char(vm.fec_registro, 'mm') = '03' then '03.Mar'
              when to_char(vm.fec_registro, 'mm') = '04' then '04.Abr'
              when to_char(vm.fec_registro, 'mm') = '05' then '05.May'
              when to_char(vm.fec_registro, 'mm') = '06' then '06.Jun'
              when to_char(vm.fec_registro, 'mm') = '07' then '07.Jul'
              when to_char(vm.fec_registro, 'mm') = '08' then '08.Ago'
              when to_char(vm.fec_registro, 'mm') = '09' then '09.Set'
              when to_char(vm.fec_registro, 'mm') = '10' then '10.Oct'
              when to_char(vm.fec_registro, 'mm') = '11' then '11.Nov'
              when to_char(vm.fec_registro, 'mm') = '12' then '12.Dic'
           end as mes,
           to_number(to_char(vm.fec_registro, 'yyyy')) as ano,
           vm.tipo_mov || '-' || amt.desc_tipo_mov as tipo_movimiento,
           vm.proveedor,
           p.nom_proveedor as razon_social,
           decode(p.nro_doc_ident, null, p.ruc, p.nro_doc_ident) as ruc_dni,
           amt.factor_sldo_total,
           vm.tipo_refer, vm.nro_refer,
           vm.tipo_doc_int, vm.nro_doc_int,
           vm.tipo_doc_ext, vm.nro_doc_ext,
           trim(ac.cod_clase) || '-' || ac.desc_clase as clase,
           trim(a1.cat_art) || '-' || a1.desc_categoria as categoria,
           trim(a2.cod_sub_cat) || '-' || a2.desc_sub_cat as subcategoria,
           am.cod_art,
           am.cod_art || '-' || a.desc_art as descripcion_articulo,
           a.und, a.und2,
           am.nro_lote,
           decode(amt.factor_sldo_total, 1, am.cant_procesada, 0) as ingresos_und,
           decode(amt.factor_sldo_total, -1, am.cant_procesada, 0) as salidas_und,
           decode(amt.factor_sldo_total, 1, am.cant_proc_und2, 0) as ingresos_und2,
           decode(amt.factor_sldo_total, -1, am.cant_proc_und2, 0) as salidas_und2,
           am.cant_procesada * amt.factor_sldo_total as cant_procesada,
           am.cant_proc_und2 * amt.factor_sldo_total as cant_proc_und2,
           am.precio_unit,
           decode(amt.factor_sldo_total, 1, am.cant_procesada * am.precio_unit, 0) as imp_ingreso_sol,
           decode(amt.factor_sldo_total, -1, am.cant_procesada * am.precio_unit, 0) as imp_salida_sol,
           usf_fl_conv_mon(decode(amt.factor_sldo_total, 1, am.cant_procesada * am.precio_unit, 0), am.cod_moneda, (select cod_dolares from logparam where reckey = '1'), vm.fec_registro) as imp_ingreso_dol,
           usf_fl_conv_mon(decode(amt.factor_sldo_total, -1, am.cant_procesada * am.precio_unit, 0), am.cod_moneda, (select cod_dolares from logparam where reckey = '1'), vm.fec_registro) as imp_salida_dol,
           am.cant_procesada * am.precio_unit * amt.factor_sldo_total as importe,
           am.cencos, am.centro_benef,
           case
             when am.cencos is not null then am.cencos || '-' || cc.desc_cencos
             else ''
           end as centro_costo,
           case
             when am.centro_benef is not null then
               am.centro_benef || '-' || cb.desc_centro
             else
               ''
            end as centro_beneficio
    from vale_mov vm,
         articulo_mov am,
         articulo     a,
         almacen      al,
         articulo_clase    ac,
         articulo_mov_tipo amt,
         articulo_sub_categ a2,
         articulo_Categ     a1,
         centros_costo      cc,
         centro_beneficio   cb,
         proveedor          p
    where vm.nro_vale = am.nro_vale
      and am.cod_art  = a.cod_art
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and a.cod_clase = ac.cod_clase
      and a.sub_cat_art = a2.cod_sub_cat
      and vm.proveedor  = p.proveedor (+)
      and a2.cat_art    = a1.cat_art
      and am.cencos     = cc.cencos      (+)
      and am.centro_benef = cb.centro_benef (+)
      and vm.flag_estado <> '0'
      and am.flag_estado <> '0'
 order by vm.almacen, am.cod_art, vm.fec_registro;

prompt
prompt Creating view VW_ALM_SALDO_PALLET
prompt =================================
prompt
create or replace force view cantabria.vw_alm_saldo_pallet as
select al.almacen,
           al.desc_almacen,
           al.flag_tipo_almacen,
           am.cod_art,
           am.anaquel,
           am.fila,
           am.columna,
           am.nro_pallet,
           am.nro_lote,
           am.cus,
           a.desc_Art,
           a.und, a.und2,
           sum(am.cant_procesada * amt.factor_sldo_total) as saldo,
           sum(nvl(am.cant_proc_und2,0) * amt.factor_sldo_total) as saldo_und2
    from vale_mov vm,
         articulo_mov am,
         articulo_mov_tipo amt,
         almacen           al,
         articulo          a
    where vm.nro_vale = am.nro_vale
      and vm.tipo_mov = amt.tipo_mov
      and vm.almacen  = al.almacen
      and am.cod_Art  = a.cod_art
      --and am.nro_pallet is not null
      and vm.flag_estado <> '0'
      and am.flag_estado <> '0'
    group by al.almacen,
           al.desc_almacen,
           al.flag_tipo_almacen,
           am.cod_art,
           am.anaquel,
           am.fila,
           am.columna,
           am.nro_pallet,
           am.nro_lote,
           am.cus,
           a.desc_Art,
           a.und, a.und2
  --having sum(am.cant_procesada * amt.factor_sldo_total) > 0 and sum(nvl(am.cant_proc_und2,0)) > 0
;

prompt
prompt Creating view VW_AL_OT_ABI_PLAN
prompt ===============================
prompt
create or replace force view cantabria.vw_al_ot_abi_plan as
select ot.nro_orden, to_char(ot.fec_solicitud, 'dd/mm/yyyy') as fec_sol, to_char(ot.fec_estimada, 'dd/mm/yyyy') as fec_est, ot.cencos_rsp, initcap(cc1.desc_cencos) as cencos_rsp_desc, ot.cencos_slc, initcap(cc2.desc_cencos) as cencos_slc_desc, decode(ot.flag_estado, '1', 'Abierto','3', 'Planeado') as flag_estado
      from orden_trabajo ot
         left outer join centros_costo cc1 on ot.cencos_rsp = cc1.cencos
         left outer join centros_costo cc2 on ot.cencos_slc = cc2.cencos
      where ot.flag_estado in ('1','3');

prompt
prompt Creating view VW_AL_PARIDA_PRESUPUESTAL
prompt =======================================
prompt
create or replace force view cantabria.vw_al_parida_presupuestal as
select pc.cnta_prsp, pc.descripcion, cc.cencos, cc.desc_cencos
   from presupuesto_cuenta pc
      inner join presupuesto_partida pp on pc.cnta_prsp = pp.cnta_prsp
      inner join centros_costo cc on pp.cencos = cc.cencos;

prompt
prompt Creating view VW_AP_ATRIBUTO_UNIDAD
prompt ===================================
prompt
create or replace force view cantabria.vw_ap_atributo_unidad as
select ca.atributo as atrib_codi, ca.descripcion as atrib_desc, ca.und as unid_codi, u.desc_unidad as unid_desc
      from tg_calidad_atributo ca
         inner join unidad u on ca.und = u.und;

prompt
prompt Creating view VW_AP_DOC_PENDIENTE
prompt =================================
prompt
create or replace force view cantabria.vw_ap_doc_pendiente as
select dpcc.tipo_doc as codigo, dpcc.nro_doc as numero, dt.desc_tipo_doc as descripcion
      from doc_pendientes_cta_cte dpcc
      inner join doc_tipo dt on dpcc.tipo_doc = dt.tipo_doc;

prompt
prompt Creating view VW_AP_DOC_PEND_PROVEEDOR
prompt ======================================
prompt
create or replace force view cantabria.vw_ap_doc_pend_proveedor as
select distinct p.proveedor, p.nom_proveedor, p.ruc
       from doc_pendientes_cta_cte dpcc
            inner join proveedor p on dpcc.cod_relacion = p.proveedor
       where p.flag_estado = '1';

prompt
prompt Creating view VW_AP_ESPECIE_PD_MATPRIM
prompt ======================================
prompt
create or replace force view cantabria.vw_ap_especie_pd_matprim as
select substr(ml.nro_parte,1,2) as origen, ml.nro_poza, ml.especie, count(ml.especie) as cuenta
       from ap_pd_matprim_llenado ml
       group by substr(ml.nro_parte,1,2), ml.nro_poza, ml.especie
       order by count(especie);

prompt
prompt Creating view VW_AP_GUIA
prompt ========================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_AP_GUIA AS
SELECT 	grmp.cod_guia_rec,
				trunc(grmp.fecha_registro) as fecha_registro,
        grmp.parte_pesca,
        p.proveedor,
        p.nom_proveedor,
        grmp.flag_estado
FROM 	ap_guia_recepcion grmp,
			proveedor p
where p.proveedor = grmp.proveedor;

prompt
prompt Creating view VW_AP_GUIA_REC_PROV_PEND
prompt ======================================
prompt
create or replace force view cantabria.vw_ap_guia_rec_prov_pend as
select distinct dd.proveedor, cr.nombre as descripcion
      from ap_pd_descarga_det dd
         left outer join ap_guia_recepcion_det grd on dd.nro_parte = grd.nro_parte and dd.item = grd.item_parte
         inner join codigo_relacion cr on dd.proveedor = cr.cod_relacion
         where grd.cod_guia_rec is null;

prompt
prompt Creating view VW_AP_MATPRIM_TIPO
prompt ================================
prompt
create or replace force view cantabria.vw_ap_matprim_tipo as
select upper(decode(flag_tipo_matprim, 'H', 'Hidrob.', 'V', 'Vegetal', 'No definido')) as flag_tipo, especie, descr_especie
   from tg_especies e
   where e.flag_estado <> '0';

prompt
prompt Creating view VW_AP_MOV_MAT_PRIMA
prompt =================================
prompt
create or replace force view cantabria.vw_ap_mov_mat_prima as
select B.COD_ART, B.CANT_PROCESADA , 'INGRESO' AS MOVIMIENTO, a.nro_vale, b.precio_unit,
			 trunc(a.fec_registro) as fecha
from VALE_MOV A,
		 ARTICULO_MOV B,
     TG_ESPECIES C,
     AP_PARAM D
WHERE A.COD_ORIGEN = B.COD_ORIGEN AND A.NRO_VALE = B.NRO_VALE
  AND C.COD_ART = B.COD_ART
  AND D.TIPO_MOV = A.TIPO_MOV
UNION ALL
select B.COD_ART, B.CANT_PROCESADA, 'SALIDA' AS MOVIMIENTO, a.nro_vale, b.precio_unit,
		   trunc(a.fec_registro) as fecha
from VALE_MOV A,
		 ARTICULO_MOV B,
     TG_ESPECIES C,
     LOGPARAM E
WHERE A.COD_ORIGEN = B.COD_ORIGEN AND A.NRO_VALE = B.NRO_VALE
  AND C.COD_ART = B.COD_ART
  AND E.OPER_CONS_INTERNO = A.TIPO_MOV;

prompt
prompt Creating view VW_AP_PD_CHATA
prompt ============================
prompt
create or replace force view cantabria.vw_ap_pd_chata as
select pp.nro_parte, to_char(pp.fecha_parte, 'dd/mm/yyyy') as fecha_parte, t.descripcion as desc_turno, upper(pp.documento_desc) as documento_desc
   from tg_parte_piso pp
      left outer join turno t on pp.turno = t.turno
   where pp.flag_tipo = 'AP';

prompt
prompt Creating view VW_AP_PERIODO_PROYECCION
prompt ======================================
prompt
create or replace force view cantabria.vw_ap_periodo_proyeccion as
select distinct to_char(ap.ano) as C1, decode(ap.mes, 1, '(01) Enero', 2, '(02) Febrero', 3, '(03) Marzo', 4, '(04) Abril', 5, '(05) Mayo', 6, '(06) Junio', 7, '(07) Julio', 8, '(08) Agosto', 9, '(09) Septiembre', 10, '(10) Octubre', 11, '(11) Noviembre', 12, '(12) Diciembre') as C2, ap.especie as C3, to_number(trim(to_char(ap.ano)) || lpad(trim(to_char(ap.mes)),2,'0')) as periodo, ap.flag_proveedor as proveedor, ap.flag_zona_descarga as zona_descarga
      from ap_proyeccion ap
      order by C1, C2;

prompt
prompt Creating view VW_AP_PROY_ESPEC_ANO
prompt ==================================
prompt
create or replace force view cantabria.vw_ap_proy_espec_ano as
select distinct ap.origen, ap.especie, e.descr_especie, ap.flag_zona_descarga, ap.flag_proveedor, ap.ano
      from ap_proyeccion ap
      inner join tg_especies e on ap.especie = e.especie;

prompt
prompt Creating view VW_AP_TIP_MARPRIM_GRF
prompt ===================================
prompt
create or replace force view cantabria.vw_ap_tip_marprim_grf as
select o.cod_origen, trim(o.nombre) || ' (' || o.cod_origen || ')' as nombre, decode(e.flag_tipo_especie, 'H', 'HIDROB.', 'V', 'VEGETAL' ) as tipo_guia, trunc(dd.inicio_descarga) as fecha_registro, e.descr_especie, sum(dd.peso_bruto) as peso_real
   from ap_pd_descarga_det dd
      inner join tg_especies e on dd.especie = e.especie
      inner join origen o on substr(dd.nro_parte,1,2) = o.cod_origen
      group by o.cod_origen, trim(o.nombre) || ' (' || o.cod_origen || ')', e.flag_tipo_especie, trunc(dd.inicio_descarga), e.descr_especie;

prompt
prompt Creating view VW_AP_VARIAC_PROY_PERIODO
prompt =======================================
prompt
create or replace force view cantabria.vw_ap_variac_proy_periodo as
select distinct to_char(ap.ano) as C1, decode(ap.mes, 1, '(01) Enero', 2, '(02) Febrero', 3, '(03) Marzo', 4, '(04) Abril', 5, '(05) Mayo', 6, '(06) Junio', 7, '(07) Julio', 8, '(08) Agosto', 9, '(09) Septiembre', 10, '(10) Octubre', 11, '(11) Noviembre', 12, '(12) Diciembre') as C2, ap.especie as C3, to_number(trim(to_char(ap.ano)) || lpad(trim(to_char(ap.mes)),2,'0')) as periodo, decode(ap.flag_proveedor, 'F', 'Recursos Propios', 'T', 'Otros Proveedores (Terceros)', 'No Aplica') as proveedor, decode(ap.flag_zona_descarga, 'Y', 'Playa', 'C', 'Chata', 'P', 'Planta', 'Otros') as zona_descarga
      from ap_proyeccion ap
      where to_number(lpad(trim(to_char(ap.ano)), 4, '0') || lpad(trim(to_char(ap.mes)), 2, '0')) >= (select to_number(to_char(sysdate, 'yyyymm')) from dual)
      order by c1, c2, proveedor, zona_descarga;

prompt
prompt Creating view VW_AP_ZONA_DESCARGA
prompt =================================
prompt
create or replace force view cantabria.vw_ap_zona_descarga as
select zd.zona_descarga, zd.descripcion as desc_zona, decode(zd.flag_tipo, 'C', 'CHATA', 'Y', 'PLAYA', 'P', 'PLANTA', 'O', 'OTROS', 'NO DEFINIDO') as tipo_zona
      from ap_zona_descarga zd
      where zd.flag_estado = '1';

prompt
prompt Creating view VW_ARTICULO
prompt =========================
prompt
create or replace force view cantabria.vw_articulo as
select trim(
         decode(a1.desc_categoria, null, '', trim(a.desc_art)                    || ' ' || chr(13) || chr(10)) ||
         decode(a.cod_sku        , null, '', 'COD. SKU  : ' || a.cod_sku         || ' ' || chr(13) || chr(10)) || '. '
       ) as full_desc_art,
       trim(
         decode(c2.desc_clase_vehiculo, null, '', 'CLASE      : ' || c2.desc_clase_vehiculo || ' ' || chr(13) || chr(10) ) ||
         decode(c1.cod_categ_vehiculo , null, '', 'CATEGORIA  : ' || c1.cod_categ_vehiculo  || ' ' || chr(13) || chr(10) ) ||
         decode(ma1.nom_marca         , null, '', 'MARCA      : ' || ma1.nom_marca          || ' ' || chr(13) || chr(10) ) ||
         decode(m2.desc_modelo        , null, '', 'MODELO     : ' || m2.desc_modelo         || ' ' || chr(13) || chr(10) ) ||
         decode(a2.version            , null, '', 'VERSION    : ' || a2.version             || ' ' || chr(13) || chr(10) ) ||
         decode(tc.carroceria_desc    , null, '', 'CARROCERIA : ' || tc.carroceria_desc     || ' ' || chr(13) || chr(10) ) ||
         decode(a.ano_modelo          , null, '', 'AÑO MOD/FAB: ' || a.ano_modelo           || '/' || a.ano_fabricacion    || ' ' || chr(13) || chr(10) ) ||
         decode(co.descripcion        , null, '', 'COLOR      : ' || co.descripcion         || ' ' || chr(13) || chr(10) ) ||
         decode(a.nro_Serie           , null, '', 'NRO VIN / SERIE : ' || a.nro_Serie       || ' ' || chr(13) || chr(10) ) ||
         decode(a.nro_motor           , null, '', 'NRO MOTOR  : ' || a.nro_motor            || ' ' || chr(13) || chr(10) ) ||
         decode(a.nro_dua             , null, '', 'NRO POLIZA : ' || a.nro_dua              || ' ' || chr(13) || chr(10) ) ||
         decode(a.nro_item_dua        , null, '', 'NRO ITEM   : ' || a.nro_item_dua         || ' ' || chr(13) || chr(10) ) ||
         decode(a.nro_lote            , null, '', 'NRO LOTE   : ' || a.nro_lote)
       ) as full_desc_vehiculo,
       a."COD_ART",a."NOM_ARTICULO",a."DESC_ART",a."SUB_CAT_ART",a."FLAG_ESTADO",a."FLAG_CNTRL_PRESUP",a."FLAG_REPOSICION",a."FLAG_CRITICO",a."FLAG_OBSOLETO",a."UND",a."COD_CLASE",a."COD_ORIGEN",a."PESO_UND",a."VOL_UND",a."SLDO_TOTAL",a."SLDO_POR_LLEGAR",a."SLDO_SOLICITADO",a."SLDO_DEVUELTO",a."SLDO_PRESTAMO",a."SLDO_CONSIGNACION",a."SLDO_RESERVADO",a."FEC_ULT_COMPRA",a."FEC_ULT_SALIDA",a."NRO_ULTIMA_OC",a."CNTA_PRSP",a."SLDO_MINIMO",a."SLDO_MAXIMO",a."DIAS_REPOSICION",a."DIAS_REP_IMPORT",a."CNT_COMPRA_REC",a."FILE_IMAGEN",a."FLAG_INVENTARIABLE",a."FLAG_UND2",a."FLAG_CNTRL_LOTE",a."UND2",a."FACTOR_CONV_UND",a."SLDO_TOTAL_UND2",a."FLAG_REPLICACION",a."FLAG_CNTRL_REQ",a."NIVEL_APROB",a."COSTO_PROM_SOL",a."COSTO_PROM_DOL",a."COSTO_ULT_COMPRA",a."FEC_REGISTRO",a."SLDO_WARRANTEADO",a."SLDO_TRANSPORTADO",a."FLAG_IQPF",a."ARTICULO_EQUIV",a."FLAG_PERCEPCION",a."IMAGEN",a."COD_CUBSO",a."ANO_MODELO",a."ANO_FABRICACION",a."NRO_CHASIS",a."NRO_SERIE",a."NRO_MOTOR",a."NRO_DUA",a."NRO_ITEM_DUA",a."NRO_PLACA",a."NRO_LOTE",a."COD_MARCA",a."PORC_VTA_UNIDAD",a."PRECIO_VTA_UNIDAD",a."PORC_VTA_MAYOR",a."PRECIO_VTA_MAYOR",a."MONEDA_COMPRA",a."TASA_CAMBIO",a."DSCTO_COMPRA",a."COD_SKU",a."FLAG_REPOS_ALMACEN",a."DSCTO_COMPRA2",a."PORC_VTA_OFERTA",a."PRECIO_VTA_OFERTA",a."COD_SUB_LINEA",a."ESTILO",a."COD_ACABADO",a."COD_SUELA",a."COLOR1",a."COLOR2",a."COD_TACO",a."FLAG_GENERO",a."TALLA",a."FLAG_TIPO_TALLA",a."PRECIO_VTA_MIN",a."PORC_VTA_MIN",a."NRO_POLIZA",a."COD_USR",a."MNZ",a."LOTE",a."FLAG_AFECTO_IGV",a."BIEN_SERV",a."FLAG_FACTURABLE",a."COD_TALLA",a."COD_LINEA",a."COD_SUBLINEA",
       a.imagen as imagen_blob,
       c1.cod_categ_vehiculo,
       c2.cod_clase_vehiculo,
       c2.desc_clase_vehiculo,
       a1.desc_categoria,
       a2.desc_sub_cat,
       a2.cnta_prsp_ingreso,
       a1.cat_art,
       a2.cod_sub_cat,
       case
         when ma1.nom_marca is not null then
           ma1.nom_marca
         when ma2.nom_marca is not null then
           ma2.nom_marca
         else
           null
       end as nom_marca,
       m2.desc_modelo,
       a2.version,
       tc.carroceria_desc,
       co.descripcion as desc_color
  from articulo a,
       articulo_sub_categ a2,
       articulo_categ     a1,
       categoria_vehiculo c1,
       clase_vehiculo     c2,
       marca              ma1,
       marca              ma2,
       modelo             m2,
       tipo_carroceria    tc,
       color              co
 where a.sub_cat_art         = a2.cod_sub_cat        (+)
   and a2.cat_art            = a1.cat_art            (+)
   and a2.cod_categ_vehiculo = c1.cod_categ_vehiculo (+)
   and a2.cod_clase_vehiculo = c2.cod_clase_vehiculo (+)
   and a2.cod_marca          = ma1.cod_marca         (+)
   and a.cod_marca           = ma2.nom_marca         (+)
   and a2.cod_modelo         = m2.cod_modelo         (+)
   and a2.cod_carroceria     = tc.cod_carroceria     (+)
   and a2.cod_color          = co.color              (+);

prompt
prompt Creating view VW_ASIENTO_CNTBLS
prompt ===============================
prompt
create or replace force view cantabria.vw_asiento_cntbls as
select ca.origen,
       ca.ano,
       ca.mes,
       ca.nro_libro,
       ca.nro_asiento,
       ca.origen || '-' || to_char(ca.ano, '0000') || '-' || to_char(ca.mes, '00') || '-' || to_char(ca.nro_libro, '00') || '-' || to_char(ca.nro_asiento, '0000') as nro_voucher,
       trunc(ca.fec_registro) as fecha_registro,
       trunc(ca.fecha_cntbl) as fecha_cntbl,
       ca.cod_usr,
       ca.desc_glosa,
       cad.cod_relacion,
       DECODE(cad.cod_relacion, null, '', cad.cod_relacion || '-' || p.nom_proveedor) as razon_social,
       cad.tipo_docref1,
       cad.nro_docref1,
       DECODE(cad.tipo_docref1 || cad.nro_docref1, null, '', cad.tipo_docref1 || '-' || cad.nro_docref1) as Documento_ref,
       cad.cod_ctabco,
       decode(cad.flag_debhab, 'D', cad.imp_movsol, 0) as debe_sol,
       decode(cad.flag_debhab, 'H', cad.imp_movsol, 0) as haber_sol,
       decode(cad.flag_debhab, 'D', cad.imp_movdol, 0) as debe_dol,
       decode(cad.flag_debhab, 'D', cad.imp_movdol, 0) as haber_dol
  from cntbl_asiento ca,
       cntbl_asiento_det cad,
       proveedor         p
where ca.origen = cad.origen
  and ca.ano    = cad.ano
  and ca.mes    = cad.mes
  and ca.nro_libro = cad.nro_libro
  and ca.nro_asiento = cad.nro_asiento
  and cad.cod_relacion = p.proveedor (+)
  and ca.flag_estado <> '0';

prompt
prompt Creating view VW_BA_ALMACEN
prompt ===========================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_BA_ALMACEN AS
SELECT DISTINCT
        A.ALMACEN,
        A.DESC_ALMACEN,
        A.COD_ORIGEN
 FROM   ALMACEN       A,
        SALIDA_PESADA SP
 WHERE A.ALMACEN = SP.ALMACEN
 AND   (ORG_AM IS NULL OR NRO_AM IS NULL)
 AND   A.FLAG_ESTADO = '1';

prompt
prompt Creating view VW_BAL_GRP_MAQ_ALCE
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_BAL_GRP_MAQ_ALCE AS
SELECT MAQUINA.COD_MAQUINA,
       MAQUINA.DESC_MAQ,
       MAQUINA.TIPO_MAQUINA
FROM MAQUINA,MAQUINA_GRP,BALPARAM
WHERE (MAQUINA_GRP.COD_MAQUINA   = MAQUINA.COD_MAQUINA  ) AND
			(BALPARAM.GRP_MAQ_ALZADORA = MAQUINA_GRP.GRUPO_MAQ);

prompt
prompt Creating view VW_BAL_GRP_PROV_CORTE
prompt ===================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_BAL_GRP_PROV_CORTE AS
SELECT PROVEEDOR.PROVEEDOR,
       PROVEEDOR.NOM_PROVEEDOR
FROM GRUPO_PROVEEDOR_REL,BALPARAM,PROVEEDOR
WHERE (BALPARAM.GRP_PROV_CORTE = GRUPO_PROVEEDOR_REL.GRUPO) AND
			(PROVEEDOR.PROVEEDOR = GRUPO_PROVEEDOR_REL.PROVEEDOR );

prompt
prompt Creating view VW_BAL_GRP_PROV_TRANSP
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_BAL_GRP_PROV_TRANSP AS
SELECT PROVEEDOR.PROVEEDOR,
       PROVEEDOR.NOM_PROVEEDOR
FROM GRUPO_PROVEEDOR_REL,BALPARAM,PROVEEDOR
WHERE (BALPARAM.GRP_PROV_TRANS_CANA = GRUPO_PROVEEDOR_REL.GRUPO) AND
			(PROVEEDOR.PROVEEDOR = GRUPO_PROVEEDOR_REL.PROVEEDOR );

prompt
prompt Creating view VW_BAL_ORDEN_COSECHA
prompt ==================================
prompt
create or replace force view cantabria.vw_bal_orden_cosecha as
select oc.nro_orden as nro_orden,
  oc.corr_corte as corr_corte,
  c.desc_campo as campo,
  oc.fecha as fecha
  from orden_cosecha oc, campo_ciclo cc, campo c
  where oc.corr_corte = cc.corr_corte and
        cc.cod_campo  = c.cod_campo   and
        oc.flag_estado in ('1','2');

prompt
prompt Creating view VW_BA_MOT_PESA_ALM
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_BA_MOT_PESA_ALM AS
SELECT DISTINCT
       MP.MOTIVO_PESADA,
       MP.DESC_MOT_PES,
       MP.TIPO_MOV,
       AMT.DESC_TIPO_MOV,
       SP.ALMACEN
FROM   MOTIVOS_PESADA    MP,
       ARTICULO_MOV_TIPO AMT,
       SALIDA_PESADA     SP
WHERE MP.TIPO_MOV = AMT.TIPO_MOV
  AND MP.MOTIVO_PESADA = SP.MOTIVO_PESADA;

prompt
prompt Creating view VW_CAM_CAMPO_OT_USR
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_CAMPO_OT_USR AS
SELECT "CAMPO"."COD_CAMPO",
         "CAMPO"."DESC_CAMPO" ,
         "OT_ADM_USUARIO"."COD_USR"
    FROM "CAMPO",
         "CAMPO_CICLO",
         "ORDEN_TRABAJO",
         "OT_ADM_USUARIO"
   WHERE ( "CAMPO"."COD_CAMPO" = "CAMPO_CICLO"."COD_CAMPO" ) and
         ( "CAMPO_CICLO"."NRO_ORDEN" = "ORDEN_TRABAJO"."NRO_ORDEN" ) and
         ( "ORDEN_TRABAJO"."OT_ADM" = "OT_ADM_USUARIO"."OT_ADM" ) and
         ( ( "CAMPO"."FLAG_ESTADO" <> '0' ) )
GROUP BY "CAMPO"."COD_CAMPO",
         "CAMPO"."DESC_CAMPO"   ,
         "OT_ADM_USUARIO"."COD_USR";

prompt
prompt Creating view VW_CAM_CORR_CORTE
prompt ===============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_CORR_CORTE AS
SELECT cc.corr_corte, c.cod_campo, c.desc_campo, c.flag_estado
FROM campo_ciclo cc, campo c
WHERE cc.cod_campo  = c.cod_campo AND
      c.flag_estado <> '0';

prompt
prompt Creating view VW_CAM_CQ_X_CORR
prompt ==============================
prompt
create or replace force view cantabria.vw_cam_cq_x_corr as
select op.nro_orden,rsg.subgrupo,Min(pl.hora_inicio) as finicio
from operaciones op,pd_ot_det pl,rpt_subgrupo rsg
where ((op.oper_sec   = pl.oper_sec   )) and
      ((rsg.reporte   = 'RPTINV'      )  and
       (rsg.grupo     = 'CQUIM'       )  and
       (rsg.subgrupo  in ('1','2','3','4') )) and
      (rtrim(ltrim(pl.cod_labor)) = Rtrim(Ltrim(rsg.descripcion)) )
group by op.nro_orden ,rsg.subgrupo;

prompt
prompt Creating view VW_CAM_CUARTEL_X_CAMPO
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_CUARTEL_X_CAMPO AS
SELECT cq.cod_cuartel, cq.has_netas, cq.cod_suelo, cq.variedad, cc.corr_corte
FROM campo_ciclo cc,
     campo c,
     campo_cuartel cq
WHERE cc.cod_campo  = c.cod_campo AND
      c.cod_campo   = cq.cod_campo;

prompt
prompt Creating view VW_CAM_LISTA_COSECHA_TAJO
prompt =======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_LISTA_COSECHA_TAJO AS
SELECT "COSECHA_TAJO"."NRO_COSECHA_TAJO",
         "COSECHA_TAJO"."PROVEEDOR",
         "CODIGO_RELACION"."NOMBRE",
         "COSECHA_TAJO"."NRO_ORDEN",
         "COSECHA_TAJO"."NRO_CUARTEL",
         to_char(fecha_corte,'dd/mm/yyyy') as fecha
    FROM "CODIGO_RELACION",
         "COSECHA_TAJO"
   WHERE ( "COSECHA_TAJO"."PROVEEDOR" = "CODIGO_RELACION"."COD_RELACION" );

prompt
prompt Creating view VW_CAM_MADURANTE_ARTIC
prompt ====================================
prompt
create or replace force view cantabria.vw_cam_madurante_artic as
select cm.madurante, a.nom_articulo
  from campo_madurante cm,
       articulo a
 where cm.madurante = a.cod_art and
       cm.flag_estado <> '0';

prompt
prompt Creating view VW_CAM_MAESTRO_OPERADOR
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_MAESTRO_OPERADOR AS
SELECT "MAQUINA_OPERADOR"."COD_OPERADOR",
         "MAESTRO"."APEL_PATERNO"||' '||"MAESTRO"."APEL_MATERNO"||' , '||"MAESTRO"."NOMBRE1" AS NOMBRES,
         "MAQUINA_OPERADOR"."FLAG_ESTADO"
    FROM "MAESTRO",
         "MAQUINA_OPERADOR"
   WHERE ( "MAQUINA_OPERADOR"."COD_OPERADOR" = "MAESTRO"."COD_TRABAJADOR" )
ORDER BY "MAQUINA_OPERADOR"."COD_OPERADOR" ASC;

prompt
prompt Creating view VW_CAM_OC_X_CC
prompt ============================
prompt
create or replace force view cantabria.vw_cam_oc_x_cc as
select oc.nro_orden,oc.fecha_quema,cc.corr_corte,c.desc_campo
					  from orden_cosecha oc,campo_ciclo cc,campo c
					 where (oc.corr_corte = cc.corr_corte ) and
					 		 (cc.cod_campo  = c.cod_campo   );

prompt
prompt Creating view VW_CAM_ORDEN_COSECHA
prompt ==================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_ORDEN_COSECHA AS
SELECT "ORDEN_COSECHA"."NRO_ORDEN",
       "ORDEN_COSECHA"."FECHA",
       "ORDEN_COSECHA"."CORR_CORTE",
       "CAMPO_CICLO"."COD_CAMPO",
       "CAMPO"."DESC_CAMPO"
    FROM "ORDEN_COSECHA",
         "CAMPO_CICLO",
         "CAMPO"
   WHERE ( "ORDEN_COSECHA"."CORR_CORTE" = "CAMPO_CICLO"."CORR_CORTE" ) AND
         ( "CAMPO_CICLO"."COD_CAMPO" = "CAMPO"."COD_CAMPO" )
ORDER BY "ORDEN_COSECHA"."NRO_ORDEN" ASC;

prompt
prompt Creating view VW_CAM_PROVEEDOR_CORTE
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_PROVEEDOR_CORTE AS
SELECT psc.proveedor, p.nom_proveedor, psc.sigla
FROM proveedor_sigla_carnet psc,
     proveedor p
WHERE psc.proveedor = p.proveedor;

prompt
prompt Creating view VW_CAM_PROVEEDOR_CORTE_CANA
prompt =========================================
prompt
create or replace force view cantabria.vw_cam_proveedor_corte_cana as
select ps.proveedor, p.nom_proveedor
  from proveedor_sigla_carnet ps, proveedor p
 where ps.proveedor=p.proveedor and
       p.flag_estado='1';

prompt
prompt Creating view VW_CAM_USR_ADM
prompt ============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CAM_USR_ADM AS
SELECT aus.ot_adm, adm.descripcion, aus.cod_usr
  FROM ot_adm_usuario aus, ot_administracion adm
 WHERE (aus.ot_adm = adm.ot_adm) and
       (adm.flag_estado<>'0');

prompt
prompt Creating view VW_CAM_ZONA_X_ADM
prompt ===============================
prompt
create or replace force view cantabria.vw_cam_zona_x_adm as
select cz.cod_zona ,
         cz.cencos   ,
         cz.desc_zona
    from campo_zona cz,
         tt_cam_adm tca
   where tca.cod_adm = cz.cod_adm;

prompt
prompt Creating view VW_CENTRO_BENEFIC_USER
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CENTRO_BENEFIC_USER AS
SELECT distinct(a.centro_benef) as centro_beneficio,
		   a.desc_centro as descripcion_centro,
       u.cod_usr
  FROM centro_beneficio a, centro_benef_usuario u
 WHERE a.flag_estado = '1' and
       a.centro_benef = u.centro_benef and
       NVL(a.flag_estructura,'0') = '0'
ORDER BY a.centro_benef;

prompt
prompt Creating view VW_CLIENTES
prompt =========================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CLIENTES AS
SELECT "PROVEEDOR","FLAG_ESTADO","TIPO_PROVEEDOR","NOM_PROVEEDOR","EMAIL",
       "FEC_ULT_OC","RUC","GERENTE","ACTIV_EMPRESA","ANO_EXISTENCIA",
       "UNID_MOVILES","STK_REPUESTOS",
       "VEND_CAPAC","PROG_EXTENS","DISPONIBILIDAD",
       "AREA_CONTROL","NRO_PERS_CC",
       "NRO_PERS_MTTO","FLAG_TRABAJADOR","FLAG_CLIE_PROV"
    FROM PROVEEDOR
   WHERE SUBSTR(PROVEEDOR,1,1) = 'C'
--"PROG_MTTO","AUDIT_CALID","NORMAS_TECNICAS","SISTEMA_CALIDAD","DISTRIBUIDORES",
--"SIST_CATALOGOS","SERV_POST_VENTA","STAFF_TECNICO","SIST_ALMAC","TIPO_TECNOLOGIA",
--"PROG_TECNICO","PRINC_ACTIVOS","BANCOS","PRINC_PROV","PRINC_CLTES",
;

prompt
prompt Creating view VW_CMP_ARTICULO_PROV
prompt ==================================
prompt
create or replace force view cantabria.vw_cmp_articulo_prov as
select distinct a.cod_art, a.desc_art, b.proveedor, a.und, a.sub_cat_art
    from articulo a, proveedor_articulo b
    where a.sub_cat_art = b.cod_sub_cat
      and a.flag_inventariable = '1'
      and a.flag_estado = '1'
    order by a.cod_art;

prompt
prompt Creating view VW_CMP_ARTICULOS_GANADORES
prompt ========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_CMP_ARTICULOS_GANADORES AS
SELECT p.proveedor, p.nom_proveedor, b.cod_art, a.nro_cotiza, b.precio_unit, b.decuento
FROM cotizacion_provee          a,
     cotizacion_provee_bien_det b,
     proveedor                  p
WHERE a.nro_cotiza = b.nro_cotiza
  AND a.proveedor  = b.proveedor
  AND a.proveedor  = p.proveedor
  AND b.flag_ganador = '1'
  AND trunc(a.fec_vigencia) >= SYSDATE;

prompt
prompt Creating view VW_CMP_COSTO_OC_OS
prompt ================================
prompt
create or replace force view cantabria.vw_cmp_costo_oc_os as
select oc.nro_oc,
         oc.fec_registro as fec_registro_oc,
         oc.proveedor,
         oc.flag_importacion,
         p.nom_proveedor as razon_social_oc,
         amp.cod_origen,
         amp.nro_mov,
         amp.fec_proyect as fec_proy_despacho,
         amp.cod_art,
         ar.desc_art,
         ar.und,
         amp.cant_proyect,
         (select sum(am1.cant_procesada * amt1.factor_sldo_total)
             from vale_mov vm1,
                  articulo_mov am1,
                  articulo_mov_tipo amt1
            where vm1.nro_vale = am1.nro_vale
              and vm1.tipo_mov = amt1.tipo_mov
              and vm1.flag_estado <> '0'
              and am1.flag_estado <> '0'
              and am1.origen_mov_proy = amp.cod_origen
              and am1.nro_mov_proy    = amp.nro_mov) as cant_procesada,
         oc.cod_moneda, (amp.precio_unit * amp.cant_proyect) as importe_oc,
         cpd.tipo_doc as tipo_doc_oc,
         cpd.nro_doc as nro_doc_oc,
         cp.fecha_emision as fecha_emision_cp_oc,
         cp.tasa_cambio as tasa_cambio_cp_oc,
         cp.cod_moneda as moneda_cp_oc,
         cpd.importe as importe_cp_oc,
         s.descripcion as desc_servicio,
         os.nro_os,
         os.fec_registro as fec_registro_os,
         os.proveedor as proveedor_os,
         p2.nom_proveedor as razon_social_os,
         osd.fec_proyect as fec_proyect_os,
         os.cod_moneda as moneda_os,
         a.importe as importe_os,
         cpd2.tipo_doc as tipo_doc_os,
         cpd2.nro_doc as nro_doc_os,
         cp2.fecha_emision as fec_emision_cp_os,
         cp2.tasa_cambio as tasa_cambio_cp_os,
         cp2.cod_moneda as moneda_cp_os,
         cpd2.importe as importe_cp_os
  from oc_det_os_det       a,
       articulo_mov_proy   amp,
       articulo            ar,
       orden_compra        oc,
       orden_servicio_det  osd,
       orden_servicio      os,
       proveedor           p,
       proveedor           p2,
       cntas_pagar_det     cpd,
       cntas_pagar_det     cpd2,
       cntas_pagar         cp,
       cntas_pagar         cp2,
       servicios           s
  where a.org_amp = amp.cod_origen
    and a.nro_amp = amp.nro_mov
    and amp.cod_art = ar.cod_art
    and amp.nro_doc = oc.nro_oc
    and amp.tipo_doc = (select doc_oc from logparam where reckey = '1')
    and a.org_os     = osd.cod_origen
    and a.nro_os     = osd.nro_os
    and a.item_os    = osd.nro_item
    and os.nro_os    = osd.nro_os
    and osd.servicio = s.servicio
    and oc.proveedor = p.proveedor
    and  os.proveedor = p2.proveedor
    and amp.cod_origen     = cpd.org_amp_ref (+)
    and amp.nro_mov        = cpd.nro_amp_ref (+)
    and cpd.cod_relacion   = cp.cod_relacion (+)
    and cpd.tipo_doc       = cp.tipo_doc (+)
    and cpd.nro_doc        = cp.nro_doc (+)
    and osd.cod_origen     = cpd2.org_os (+)
    and osd.nro_os         = cpd2.nro_os (+)
    and osd.nro_item       = cpd2.item_os (+)
    and cpd2.cod_relacion  = cp2.cod_relacion (+)
    and cpd2.tipo_doc      = cp2.tipo_doc (+)
    and cpd2.nro_doc       = cp2.nro_doc (+)
  union
  select oc.nro_oc,
         oc.fec_registro as fec_registro_oc,
         oc.proveedor,
         oc.flag_importacion,
         p.nom_proveedor as razon_social_oc,
         amp.cod_origen,
         amp.nro_mov,
         amp.fec_proyect as fec_proy_despacho,
         amp.cod_art,
         ar.desc_art,
         ar.und,
         amp.cant_proyect,
         amp.cant_procesada,
         oc.cod_moneda, (amp.precio_unit * amp.cant_proyect) as importe_oc,
         cpd.tipo_doc as tipo_doc_oc,
         cpd.nro_doc as nro_doc_oc,
         cp.fecha_emision as fecha_emision_cp_oc,
         cp.tasa_cambio as tasa_cambio_cp_oc,
         cp.cod_moneda as moneda_cp_oc,
         cpd.importe as importe_cp_oc,
         null as desc_servicio,
         null nro_os,
         null as fec_registro_os,
         null as proveedor_os,
         null as razon_social_os,
         null as fec_proyect_os,
         null as moneda_os,
         null as importe_os,
         null as tipo_doc_os,
         null as nro_doc_os,
         null as fec_emision_cp_os,
         null as tasa_cambio_cp_os,
         null as moneda_cp_os,
         null as importe_cp_os
  from articulo_mov_proy   amp,
       articulo            ar,
       (select amp2.cod_origen, amp2.nro_mov
          from articulo_mov_proy amp2
         where tipo_doc = (select doc_oc from logparam where reckey = 1)
        minus
        select tt.org_amp, tt.nro_amp
          from oc_det_os_det tt) s1,
       orden_compra        oc,
       proveedor           p,
       cntas_pagar_det     cpd,
       cntas_pagar         cp
  where amp.nro_doc = oc.nro_oc
    and amp.cod_art  = ar.cod_art
    and amp.tipo_doc = (select doc_oc from logparam where reckey = '1')
    and amp.cod_origen = s1.cod_origen
    and amp.nro_mov    = s1.nro_mov
    and oc.proveedor = p.proveedor
    and (oc.flag_importacion = '1' or p.flag_nac_ext = 'E' or p.flag_personeria = 'E')
    and amp.cod_origen     = cpd.org_amp_ref (+)
    and amp.nro_mov        = cpd.nro_amp_ref (+)
    and cpd.cod_relacion   = cp.cod_relacion (+)
    and cpd.tipo_doc       = cp.tipo_doc (+)
    and cpd.nro_doc        = cp.nro_doc (+)
    and oc.flag_estado     <> '0'

  order by nro_oc, nro_os;

prompt
prompt Creating view VW_CMP_OS_OC_RESUMEN
prompt ==================================
prompt
create or replace force view cantabria.vw_cmp_os_oc_resumen as
select distinct
     nro_oc,
       fec_registro_oc,
       proveedor,
       razon_social_oc,
       cod_origen,
       nro_mov,
       fec_proy_despacho,
       to_number(to_char(t.fec_proy_despacho,'yyyy')) as ano,
       to_number(to_char(t.fec_proy_despacho,'mm')) as mes,
       cod_art,
       cod_art || '-' || desc_art as descripcion_articulo,
       und,
       cant_proyect as cantidad_solicitada,
       cant_procesada as cantidad_ingresada,
       cod_moneda,
       usf_cmp_costo_oc_fap(t.cod_origen, t.nro_mov, t.cod_moneda) as importe_compra,
       usf_cmp_costo_serv(t.cod_origen, t.nro_mov, t.cod_moneda) as importe_servicios,
       usf_cmp_costo_oc_fap(t.cod_origen, t.nro_mov, (select cod_soles from logparam where reckey = '1')) as imp_compra_sol,
       usf_cmp_costo_serv(t.cod_origen, t.nro_mov, (select cod_soles from logparam where reckey = '1')) as imp_serv_sol,
       usf_cmp_costo_oc_fap(t.cod_origen, t.nro_mov, (select cod_dolares from logparam where reckey = '1')) as imp_compra_dol,
       usf_cmp_costo_serv(t.cod_origen, t.nro_mov, (select cod_dolares from logparam where reckey = '1')) as imp_serv_dol,
       DECODE(t.cant_procesada, 0, 0, usf_cmp_costo_oc_fap(t.cod_origen, t.nro_mov, (select cod_soles from logparam where reckey = '1'))/t.cant_procesada) as precio_unit_cmp_sol,
       DECODE(t.cant_procesada, 0, 0, usf_cmp_costo_serv(t.cod_origen, t.nro_mov, (select cod_soles from logparam where reckey = '1')) /t.cant_procesada) as precio_unit_serv_sol,
       DECODE(t.cant_procesada, 0, 0, usf_cmp_costo_oc_fap(t.cod_origen, t.nro_mov, (select cod_dolares from logparam where reckey = '1')) /t.cant_procesada) as precio_unit_cmp_dol,
       DECODE(t.cant_procesada, 0, 0, usf_cmp_costo_serv(t.cod_origen, t.nro_mov, (select cod_dolares from logparam where reckey = '1')) /t.cant_procesada) as precio_unit_serv_dol

from VW_CMP_COSTO_OC_OS t;

prompt
prompt Creating view VW_CNTA_BCO
prompt =========================
prompt
create or replace force view cantabria.vw_cnta_bco as
select b.nom_banco, bc.cod_ctabco, bc.cod_moneda, bc.cnta_ctbl
  from   banco_cnta bc, banco b
  where  bc.cod_banco = b.cod_banco;

prompt
prompt Creating view VW_CNTAS_PAGAR
prompt ============================
prompt
create or replace force view cantabria.vw_cntas_pagar as
select cp.cod_relacion,
       cp.ano, cp.mes,
       p.nom_proveedor,
       p.ruc,
       p.nro_doc_ident,
       cp.tipo_doc, cp.nro_doc,
       cp.descripcion,
       DECODE(cp.flag_estado, '0', 'Anulado', '1', 'Generado', cp.flag_estado) as flag_estado,
       cpd.item, cpd.descripcion as glosa_detalle,
       cpd.cantidad,
       cpd.importe,
       cpd.cencos,
       cpd.cnta_prsp,
       cpd.centro_benef,
       cpd.confin,
       cpd.tipo_cred_fiscal, cf.descripcion as desc_credito_fiscal,
       cpd.nro_os,
       imp.tipo_impuesto,
       imp.importe as imp_impuesto,
       cp.origen || '-' || to_char(cp.ano, '0000') || '-' || to_char(cp.mes, '00') || '-' || to_char(cp.nro_libro, '00') || '-' || trim(to_char(cp.nro_asiento)) as voucher
from cntas_pagar cp,
     cntas_pagar_det cpd,
     cp_doc_det_imp  imp,
     usuario         u,
     proveedor       p,
     credito_fiscal  cf
where cp.cod_relacion  = cpd.cod_relacion
  and cp.tipo_doc      = cpd.tipo_doc
  and cp.nro_doc       = cpd.nro_doc
  and cpd.cod_relacion = imp.cod_relacion (+)
  and cpd.tipo_doc     = imp.tipo_doc (+)
  and cpd.nro_doc      = imp.nro_doc (+)
  and cpd.item         = imp.item (+)
  and cp.cod_usr       = u.cod_usr
  and cp.cod_relacion  = p.proveedor
  and cpd.tipo_cred_fiscal = cf.tipo_cred_fiscal (+);

prompt
prompt Creating view VW_CNTBL_ASIENTO
prompt ==============================
prompt
create or replace force view cantabria.vw_cntbl_asiento as
select a.ano, a.mes, ad.tipo_docref1, ad.nro_docref1, ad.cod_relacion, ad.cnta_ctbl,
sum(decode(ad.flag_debhab,'D',ad.imp_movdol,0)) as imp_debe_dol,
sum(decode(ad.flag_debhab,'H',ad.imp_movdol,0)) as imp_haber_dol,
sum(decode(ad.flag_debhab,'D',ad.imp_movsol,0)) as imp_debe_sol,
sum(decode(ad.flag_debhab,'H',ad.imp_movsol,0)) as imp_haber_sol
from cntbl_asiento a,cntbl_asiento_det ad, cntbl_cnta ca
where a.origen = ad.origen
and a.ano = ad.ano and a.mes = ad.mes and a.nro_libro = ad.nro_libro
and a.nro_asiento = ad.nro_asiento
and a.flag_estado <> '0'
and ad.cnta_ctbl = ca.cnta_ctbl and ca.flag_codrel='1' and ca.flag_doc_ref='1'
and (ad.cod_relacion is not null and ad.tipo_docref1 is not null and ad.nro_docref1 is not null)
and a.cod_moneda = 'US$'
group by a.ano, a.mes, ad.tipo_docref1, ad.nro_docref1, ad.cod_relacion, ad.cnta_ctbl
having sum(decode(ad.flag_debhab,'D',ad.imp_movsol,0))- sum(decode(ad.flag_debhab,'H',ad.imp_movsol,0))<>0
order by ad.tipo_docref1, ad.nro_docref1, ad.cod_relacion, ad.cnta_ctbl;

prompt
prompt Creating view VW_CNTBL_BALANCE_COMPROB
prompt ======================================
prompt
create or replace force view cantabria.vw_cntbl_balance_comprob as
select cc.cnta_ctbl,
       cc.desc_cnta,
       cc.flag_labor,
       ca.cnta_debe,
       ca.cnta_haber,
       ca.ano, ca.mes,
       NVL(cad.flag_gen_aut,'0') as flag_gen_aut,
       case
         when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) = 0 then
           null
         else
            sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
       end as suma_debe,
       case
         when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) = 0 then
           null
         else
           sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
       end as suma_haber,
       case
         when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) then
           sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
         else
           null
       end as saldo_debe,
       case
         when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) then
           sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
         else
           null
       end as saldo_haber,
       case
         when cc.flag_labor = 'I' then
           case
             when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
             else
               null
           end
         else
           null
       end as inventario_debe,
        case
         when cc.flag_labor = 'I' then
           case
             when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
             else
               null
           end
         else
           null
       end as inventario_haber,
       case
         when cc.flag_labor in ('N', 'T') then
           case
             when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
             else
               null
           end
         else
           null
       end as naturaleza_debe,
        case
         when cc.flag_labor in ('N', 'T') then
           case
             when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
             else
               null
           end
         else
           null
       end as naturaleza_haber,
       case
         when cc.flag_labor in ('F', 'T') then
           case
             when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
             else
               null
           end
         else
           null
       end as funcion_debe,
        case
         when cc.flag_labor in ('F', 'T') then
           case
             when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
             else
               null
           end
         else
           null
       end as funcion_haber
  from cntbl_asiento ca,
       cntbl_asiento_det cad,
       cntbl_cnta        cc,
       cntbl_ctas_aut    ca
where ca.origen = cad.origen
  and ca.ano    = cad.ano
  and ca.mes    = cad.mes
  and ca.nro_libro = cad.nro_libro
  and ca.nro_asiento = cad.nro_asiento
  and cad.cnta_ctbl  = cc.cnta_ctbl
  and cc.cnta_ctbl   = ca.cnta_cntbl   (+)
  and ca.flag_estado <> '0'
  and ca.ano = 2014
--  and ca.mes = 03
group by cc.cnta_ctbl,
       cc.desc_cnta,
       cc.flag_labor,
       ca.cnta_debe,
       ca.cnta_haber,
       ca.ano, ca.mes,
        NVL(cad.flag_gen_aut,'0')
order by 1
;

prompt
prompt Creating view VW_CNTBL_COSTOS_X_CENCOS
prompt ======================================
prompt
create or replace force view cantabria.vw_cntbl_costos_x_cencos as
select cad.cnta_ctbl,
       c.cnta_ctbl || '-' || c.desc_cnta as desc_cnta,
       ca.ano,
       ca.mes,
       cc.cencos,
       cc.cencos || '-' || cc.desc_cencos as desc_cencos,
       ca.desc_glosa as glosa,
       cad.det_glosa as glosa_detalle,
       ca.nro_libro,
       c2.cnta_ctbl as grupo_cntbl,
       c2.desc_cnta as desc_grupo_cntbl,
       ca.cod_usr,
       ca.origen || trim(to_char(ca.ano, '0000')) || trim(to_char(ca.mes, '00')) || trim(to_char(ca.nro_libro, '00')) || trim(to_char(ca.nro_asiento, '000000')) as voucher,
       sum(cad.imp_movsol * decode(cad.flag_debhab, 'D', 1, -1)) as total_sol,
       sum(cad.imp_movdol * decode(cad.flag_debhab, 'D', 1, -1)) as total_dol
from cntbl_asiento ca,
     cntbl_asiento_det cad,
     centros_costo     cc,
     cntbl_cnta        c,
     cntbl_cnta        c2
where ca.origen        = cad.origen
  and ca.ano           = cad.ano
  and ca.mes           = cad.mes
  and ca.nro_libro     = cad.nro_libro
  and ca.nro_asiento   = cad.nro_asiento
  and cad.cnta_ctbl    = c.cnta_ctbl
  and substr(c.cnta_ctbl,1,2) = trim(c2.cnta_ctbl)
  and ca.flag_estado     <> '0'
  and cad.cencos     = cc.cencos (+)
  and substr(c.cnta_ctbl,1,1) = '9'
group by cad.cnta_ctbl,
       c.cnta_ctbl || '-' || c.desc_cnta,
       ca.ano,
       ca.mes,
       cc.cencos,
       cc.cencos || '-' || cc.desc_cencos,
       ca.desc_glosa,
       cad.det_glosa,
       ca.nro_libro,
       c2.cnta_ctbl,
       c2.desc_cnta,
       ca.cod_usr,
       ca.origen || trim(to_char(ca.ano, '0000')) || trim(to_char(ca.mes, '00')) || trim(to_char(ca.nro_libro, '00')) || trim(to_char(ca.nro_asiento, '000000'));

prompt
prompt Creating view VW_CNTBL_RESUMEN_ASIENTOS
prompt =======================================
prompt
create or replace force view cantabria.vw_cntbl_resumen_asientos as
select cc.cnta_ctbl,
       cc.cnta_ctbl || '-' || cc.desc_cnta as desc_cnta,
       DECODE(cc.flag_labor, 'I', 'Inventario', 'F', 'Funcion', 'N', 'Naturaleza', 'T', 'Funcion/Naturaleza', '0', 'Nada', '') as Tipo_Estado_Cuenta,
       cc.niv_cnta,
       DECODE(ca.flag_estado, '1', 'Activo', 'Anulado') as flag_estado,
       ca.ano, ca.mes,
       ca.origen || trim(to_char(ca.ano, '0000')) || trim(to_char(ca.mes, '00')) || trim(to_char(ca.nro_libro, '00')) || trim(to_char(ca.nro_Asiento, '000000')) as voucher,
       ca.cnta_debe,
       ca.cnta_haber,
       sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) as debe_sol,
       sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) as haber_sol,
       sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) as saldo
from cntbl_cnta cc,
     cntbl_ctas_aut ca,
     cntbl_asiento_det cad,
     cntbl_Asiento     ca
where cc.cnta_ctbl = ca.cnta_cntbl (+)
  and ca.origen    = cad.origen
  and ca.ano       = cad.ano
  and ca.mes       = cad.mes
  and ca.nro_libro = cad.nro_libro
  and ca.nro_asiento = cad.nro_asiento
  and cad.cnta_ctbl  = cc.cnta_ctbl
  and ca.flag_estado <> '0'
group by cc.cnta_ctbl,
       cc.desc_cnta,
       DECODE(cc.flag_labor, 'I', 'Inventario', 'F', 'Funcion', 'N', 'Naturaleza', 'T', 'Funcion/Naturaleza', '0', 'Nada', ''),
       cc.niv_cnta,
       DECODE(ca.flag_estado, '1', 'Activo', 'Anulado'),
       ca.ano, ca.mes,
       ca.origen || trim(to_char(ca.ano, '0000')) || trim(to_char(ca.mes, '00')) || trim(to_char(ca.nro_libro, '00')) || trim(to_char(ca.nro_Asiento, '000000')),
       ca.cnta_debe,
       ca.cnta_haber
order by cc.cnta_ctbl;

prompt
prompt Creating view VW_CNTBL_VALE_MOV
prompt ===============================
prompt
create or replace force view cantabria.vw_cntbl_vale_mov as
select vm1.nro_vale,
       vm1.fec_registro as fec_movimiento,
       to_char(vm1.fec_registro, 'yyyy') as ano,
       to_char(vm1.fec_registro, 'mm') as mes,
       to_char(vm1.fec_registro, 'yyyymm') as periodo,
       vm1.almacen,
       al1.desc_almacen,
       vm1.tipo_mov,
       trim(amt1.tipo_mov) || '-' || amt1.desc_tipo_mov as desc_tipo_mov,
       am1.cod_art,
       a1.desc_art,
       a1.und,
       am1.cant_procesada,
       am1.cod_origen,
       am1.nro_mov,
       DECODE(amt1.factor_sldo_total, 1, am1.cant_procesada * am1.precio_unit, 0 ) as ingresos,
       DECODE(amt1.factor_sldo_total, -1, am1.cant_procesada * am1.precio_unit, 0 ) as salidas,
       decode(am1.cant_procesada, 0, 0, s.imp_movsol / am1.cant_procesada) as precio_unit,
       am1.cant_procesada * am1.precio_unit * amt1.factor_sldo_total as importe,
       DECODE(amt1.factor_sldo_total, 1, s.imp_movsol, 0 ) as debe,
       DECODE(amt1.factor_sldo_total, -1, s.imp_movsol, 0 ) as haber,
       vm1.cod_usr, u.nombre as nom_usuario,
       am1.fec_registro,
       am1.matriz,
       vm1.flag_estado,
       s.cnta_cntbl_debe,
       s.cnta_cntbl_haber,
       s.nro_libro,
       al1.flag_tipo_almacen,
       ac.cod_clase,
       ac.desc_clase,
       ac1.cat_art, ac1.desc_categoria,
       as1.cod_sub_cat, as1.desc_sub_cat,
       case
             when instr(ac1.desc_categoria, 'ACEITE') > 0 then 'ACEITE DE PESCADO'
             when instr(ac1.desc_categoria, 'HARINA') > 0 then 'HARINA RESIDUAL'
             when instr(ac1.desc_categoria, 'MERLUZA') > 0 then 'MERLUZA'
             when instr(ac1.desc_categoria, 'ANCHOVETA') > 0 then 'ANCHOVETA'
             when instr(ac1.desc_categoria, 'CONCHA') > 0 then 'CONCHA DE ABANICO'
             when instr(ac1.desc_categoria, 'PERICO') > 0 then 'PERICO'
             when instr(ac1.desc_categoria, 'CALAMAR') > 0 then 'CALAMAR'
             when instr(ac1.desc_categoria, 'POTA') > 0 then 'POTA'
             when instr(ac1.desc_categoria, 'PAICHE') > 0 then 'PAICHE'
             when instr(ac1.desc_categoria, 'HIELO') > 0 then 'HIELO'
             ELSE
               'OTRAS ESPECIES'
           end as especie
from vale_mov vm1,
     articulo_mov am1,
     almacen      al1,
     articulo     a1,
     articulo_mov_tipo amt1,
     articulo_sub_categ as1,
     articulo_categ     ac1,
     articulo_clase     ac,
     usuario           u,
     (select cad.org_am as cod_origen, cad.nro_am as nro_mov, cad.imp_movsol,
             cad.nro_libro,
             max(decode(cad.flag_debhab, 'D', cad.cnta_ctbl, null)) as cnta_cntbl_debe,
             max(decode(cad.flag_debhab, 'H', cad.cnta_ctbl, null)) as cnta_cntbl_haber
        from cntbl_asiento ca,
             cntbl_asiento_det cad
       where ca.origen = cad.origen
         and ca.ano    = cad.ano
         and ca.mes    = cad.mes
         and ca.nro_libro = cad.nro_libro
         and ca.nro_asiento = cad.nro_asiento
         and ca.flag_estado <> '0'
         and nvl(cad.flag_gen_aut,'0') <> '2'
         --and ca.nro_libro = 23
         --and ca.ano = 2014
      group by cad.org_am, cad.nro_am, cad.imp_movsol,
             cad.nro_libro) s
where vm1.nro_vale = am1.nro_vale
  and am1.cod_art  = a1.cod_art
  and vm1.almacen  = al1.almacen
  and vm1.tipo_mov = amt1.tipo_mov
  and am1.cod_origen = s.cod_origen
  and am1.nro_mov    = s.nro_mov
  and vm1.cod_usr    = u.cod_usr
  and a1.sub_cat_art = as1.cod_sub_cat
  and as1.cat_art    = ac1.cat_art
  and a1.cod_clase   = ac.cod_clase
  and usf_cnt_count_matriz(am1.matriz) > 0
  and vm1.flag_estado <> '0'
  and am1.flag_estado <> '0'
  --and vm1.nro_vale    = 'PA00011440'
  --and vm1.tipo_mov    = 'I01'
  --and vm1.nro_vale in ('PA00011241', 'PA00011310')
  --and round(am1.cant_procesada * am1.precio_unit,4) <> s.imp_movsol
;

prompt
prompt Creating view VW_COD_RELACION_CARTERA_COBROS
prompt ============================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_COD_RELACION_CARTERA_COBROS AS
SELECT DISTINCT DP.COD_RELACION, P.NOM_PROVEEDOR
FROM   DOC_PENDIENTES_CTA_CTE DP, PROVEEDOR P
WHERE  DP.COD_RELACION = P.PROVEEDOR AND
       P.FLAG_CLIE_PROV IN (0,2);

prompt
prompt Creating view VW_COM_CNTAS_PAGAR
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_COM_CNTAS_PAGAR AS
select distinct cp.cod_relacion,
                p.nom_proveedor,
                cp.tipo_doc,
                dt.desc_tipo_doc,
                cp.nro_doc,
                cp.total_pagar,
                cp.fecha_registro,
                cp.fecha_emision,
                cp.cod_moneda,
                cp.importe_doc
from cntas_pagar cp,
     proveedor   p,
     doc_tipo    dt
where p.proveedor = cp.cod_relacion
  and dt.tipo_doc = cp.tipo_doc
  and NVL(cp.flag_estado, '0') <> '0'
  and cp.cod_relacion || cp.tipo_doc || cp.nro_doc not in (
               select cod_relacion || tipo_doc || nro_doc
               from com_compr_pago_det )
  AND cp.cod_relacion IN (SELECT t.proveedor FROM com_parte_rac t);

prompt
prompt Creating view VW_COM_COD_RELACION
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_COM_COD_RELACION AS
SELECT DISTINCT CR.COD_RELACION,
       CR.NOMBRE
FROM CODIGO_RELACION CR,
     CNTAS_PAGAR     CP
WHERE CP.COD_RELACION = CR.COD_RELACION;

prompt
prompt Creating view VW_COM_FULL_CNTAS_PAGAR
prompt =====================================
prompt
create or replace force view cantabria.vw_com_full_cntas_pagar as
select cp.cod_relacion,
       p.nom_proveedor,
       cp.tipo_doc,
       dt.desc_tipo_doc,
       cp.nro_doc,
       trunc(cp.fecha_registro) as fecha_registro,
       trunc(cp.fecha_emision) as fecha_emision,
       cp.total_pagar
from cntas_pagar cp,
     doc_tipo    dt,
     proveedor   p
where dt.tipo_doc = cp.tipo_doc
  and p.proveedor = cp.cod_relacion
  and cp.flag_estado IN ('1', '2', '3', '4', '5');

prompt
prompt Creating view VW_COM_FULL_RAC_COSTO
prompt ===================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_COM_FULL_RAC_COSTO AS
SELECT O.Nro_Orden,
       A.ORIGEN_SOLICITUD AS COD_ORIGEN,
       A.Parte_Racion,
       Trunc(A.Fecha_Parte_Rac) as fecha_parte,
       A.TIPO_COMEDOR,
       E.Descr_Comedor,
       B.Cencos,
       C.Desc_Cencos,
       B.FLAG_TIPO_RACION as TIPO_RACION,
       B.Zona_Proceso,
       f.descr_zona_proc  as DESC_ZONA_PROCESO,
       DECODE(B.Flag_Tipo_Racion, 'D', '1.Desayuno', 'C', '4.Cena', 'A', '2.Almuerzo',
                                  'R', '3.Refrigerio', 'Indefinido') as desc_tipo_racion,
       B.NRO_RACIONES,
       d.costo_unit,
       b.nro_raciones * d.costo_unit as costo_calc

FROM com_parte_rac      A,
     com_parte_rac_det  B,
     Centros_Costo      C,
     com_part_rac_costo d,
     com_tipo_comed     E,
     com_zona_proceso   F,
     Operaciones        O

WHERE B.OPER_SEC_REF     = O.OPER_SEC
  AND A.parte_racion     = B.Parte_Racion
  AND A.Tipo_Comedor     = E.Tipo_Comedor
  AND B.CENCOS           = C.Cencos
  AND B.PARTE_RACION     = D.Parte_Racion (+)
  AND B.FLAG_TIPO_RACION = D.FLAG_TIPO_RACION (+)
  AND b.zona_proceso     = f.zona_proceso

ORDER BY nro_orden,
         COD_ORIGEN,
         parte_racion,
         cencos,
         zona_proceso,
         b.flag_tipo_racion

--( com_parte_rac_det.oper_sec_ref = operaciones.oper_sec (+)) and
;

prompt
prompt Creating view VW_COM_PARTE_RACIONES
prompt ===================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_COM_PARTE_RACIONES AS
SELECT "COM_PARTE_RAC"."FECHA_REGISTRO",
         "COM_PARTE_RAC"."FECHA_PARTE_RAC",
         "COM_PARTE_RAC"."FLAG_ESTADO",
         "COM_PARTE_RAC"."PARTE_RACION",
         "COM_PARTE_RAC"."TIPO_COMEDOR",
         "COM_TIPO_COMED"."DESCR_COMEDOR"
    FROM "COM_PARTE_RAC",
         "COM_TIPO_COMED"
   WHERE ( "COM_PARTE_RAC"."TIPO_COMEDOR" = "COM_TIPO_COMED"."TIPO_COMEDOR" )
     AND COM_PARTE_RAC.FLAG_ESTADO = '1';

prompt
prompt Creating view VW_COM_RACIONES
prompt =============================
prompt
create or replace force view cantabria.vw_com_raciones as
select Nro_Orden,
       COD_ORIGEN,
       Parte_Racion,
       Fecha_Parte,
       TIPO_COMEDOR,
       Descr_Comedor,
       Cencos,
       Desc_Cencos,
       TIPO_RACION,
       desc_tipo_racion,
       sum(NRO_RACIONES) as nro_raciones,
       sum(Nvl(costo_unit,0) * nro_raciones)/ sum(nro_raciones) as costo_unit ,
       sum(Nvl(costo_unit,0) * nro_raciones) as costo_calc
from vw_com_full_rac_costo
  group by Nro_Orden,
           COD_ORIGEN,
           Parte_Racion,
           Fecha_Parte,
           TIPO_COMEDOR,
           Descr_Comedor,
           Cencos,
           Desc_Cencos,
           TIPO_RACION ,
           desc_tipo_racion;

prompt
prompt Creating view VW_COM_RACIONES_ZP
prompt ================================
prompt
create or replace force view cantabria.vw_com_raciones_zp as
select A.Nro_Orden,
       A.Parte_Racion,
       trunc(A.Fecha_Parte_Rac) as fecha_parte,
       A.TIPO_COMEDOR,
       E.Descr_Comedor,
       B.Cencos,
       t.ratio,
       C.Desc_Cencos,
       B.FLAG_TIPO_RACION as TIPO_RACION,
       DECODE(B.Flag_Tipo_Racion, 'D', '1.DESAYUNO', 'C', '4.CENA', 'A', '2.ALMUERZO',
                                  'R', '3.REFRIGERIO', 'INDEFINIDO') as desc_tipo_racion,
       f.zona_proceso,
       f.descr_zona_proc as desc_zona_proc,
       B.NRO_RACIONES,
       a.proveedor
from com_parte_rac      A,
     com_parte_rac_det  B,
     Centros_Costo      C,
     com_tipo_comed     E,
     com_zona_proceso   F,
     com_parte_rac_ratio t
where A.parte_racion     = B.Parte_Racion
  and A.Tipo_Comedor     = E.Tipo_Comedor
  and B.CENCOS           = C.Cencos
  and F.Zona_Proceso     = B.Zona_Proceso
  and a.parte_racion     = t.parte_racion
  and b.parte_racion     = t.parte_racion
  and b.flag_tipo_racion = t.flag_tipo_racion
  AND a.flag_estado = '1';

prompt
prompt Creating view VW_COM_SOLO_RACIONES
prompt ==================================
prompt
create or replace force view cantabria.vw_com_solo_raciones as
select A.Nro_Orden,
       A.Parte_Racion,
       trunc(A.Fecha_Parte_Rac) as fecha_parte,
       A.TIPO_COMEDOR,
       E.Descr_Comedor,
       B.Cencos,
       C.Desc_Cencos,
       B.FLAG_TIPO_RACION as TIPO_RACION,
       DECODE(B.Flag_Tipo_Racion, 'D', '1.DESAYUNO', 'C', '4.CENA', 'A', '2.ALMUERZO',
                                  'R', '3.REFRIGERIO', 'INDEFINIDO') as desc_tipo_racion,
       sum(B.NRO_RACIONES) as nro_raciones,
       a.proveedor
from com_parte_rac      A,
     com_parte_rac_det  B,
     Centros_Costo      C,
     com_tipo_comed     E,
     proveedor          p
where A.parte_racion     = B.Parte_Racion
  and A.Tipo_Comedor     = E.Tipo_Comedor
  and B.CENCOS           = C.Cencos
  AND a.proveedor        = p.proveedor
  group by A.Nro_Orden,
       A.Parte_Racion,
       trunc(A.Fecha_Parte_Rac),
       A.TIPO_COMEDOR,
       E.Descr_Comedor,
       B.Cencos,
       C.Desc_Cencos,
       B.FLAG_TIPO_RACION ,
       DECODE(B.Flag_Tipo_Racion, 'D', 'DESAYUNO', 'C', 'CENA', 'A', 'ALMUERZO',
                                  'R', 'REFRIGERIO', 'INDEFINIDO'),
       a.proveedor;

prompt
prompt Creating view VW_COM_TIPO_DOC
prompt =============================
prompt
create or replace force view cantabria.vw_com_tipo_doc as
select distinct dt.tipo_doc, dt.desc_tipo_doc, cp.cod_relacion
from doc_tipo dt,
     cntas_pagar cp
where cp.tipo_doc = dt.tipo_doc;

prompt
prompt Creating view VW_CONCIL
prompt =======================
prompt
create or replace force view cantabria.vw_concil as
select cb.cod_ctabco,cb.ano,cb.mes,cb.origen,cb.nro_registro
  from caja_bancos cb
 where (cb.cod_ctabco is not null ) and
        (ltrim(rtrim(to_char(cb.ano)))||ltrim(rtrim(to_char(cb.mes,'09'))) <=  '200501') and
       (cb.flag_estado <> '0'     ) and
       (cb.nro_libro in (select libro_pagos from finparam where reckey = '1'
                         union
                         select libro_cobranzas from finparam where reckey = '1'))
 union
select cb.cod_ctabco,cb.ano,cb.mes,cb.origen,cb.nro_registro
  from caja_bancos cb
 where (cb.cod_ctabco is not null ) and
       (ltrim(rtrim(to_char(cb.ano)))||ltrim(rtrim(to_char(cb.mes,'09'))) <=  '200501') and
       (cb.flag_estado <> '0'     ) and
       (cb.nro_libro  = (select nro_libro_tranfer from finparam  where reckey = '1')    )
 union
select cb.cod_ctabco_ref,cb.ano,cb.mes,cb.origen,cb.nro_registro
  from caja_bancos cb
 where (cb.cod_ctabco_ref is not null ) and
       (ltrim(rtrim(to_char(cb.ano)))||ltrim(rtrim(to_char(cb.mes,'09'))) <=  '200501') and
       (cb.flag_estado <> '0'     ) and
       (cb.nro_libro  = (select nro_libro_tranfer from finparam  where reckey = '1')    );

prompt
prompt Creating view VW_CONTABILIDAD
prompt =============================
prompt
create or replace force view cantabria.vw_contabilidad as
select cn.cnta_ctbl,
       cn.cnta_ctbl || ' ' || cn.desc_cnta as desc_cnta,
       DECODE(cad.flag_debhab, 'D', 'DEBE', 'HABER') as flag_debhab,
       DECODE(cad.flag_debhab, 'D', 1, -1) * cad.imp_movsol as imp_movsol_signo, cad.imp_movsol,
       cc.cencos, cc.desc_cencos,
       DECODE(cad.flag_debhab, 'D', cad.imp_movsol, 0) as imp_sol_debe,
       DECODE(cad.flag_debhab, 'H', cad.imp_movsol, 0) as imp_sol_haber,
       ca.mes, ca.ano, ca.nro_libro, ca.nro_asiento,
       cad.tipo_docref1  || ' ' || cad.nro_docref1 as doc_referencia,
       gc.grp_cntbl || ' ' || gc.desc_grp_cntbl as grupo_contable,
       cad.cod_ctabco, bc.descripcion as desc_banco,
       cad.cod_relacion,
       p.nom_proveedor, p.ruc, p.nro_doc_ident
from cntbl_asiento ca,
     cntbl_asiento_det cad,
     centros_costo     cc,
     cntbl_cnta        cn,
     (select trim(cc2.cnta_ctbl) as grp_cntbl, cc2.desc_cnta as desc_grp_Cntbl
         from cntbl_cnta cc2
        where length(trim(cc2.cnta_ctbl)) = 2
          and cc2.flag_estado <> '0') gc,
     banco_cnta        bc,
     banco             b,
     proveedor         p
where ca.origen = cad.origen
  and ca.ano    = cad.ano
  and ca.mes    = cad.mes
  and ca.nro_libro = cad.nro_libro
  and ca.nro_asiento = cad.nro_Asiento
  and cad.cencos     = cc.cencos (+)
  and cad.cod_ctabco = bc.cod_ctabco (+)
  and bc.cod_banco   = b.cod_banco (+)
  and cn.cnta_ctbl   = cad.cnta_ctbl
  and cad.cod_relacion = p.proveedor (+)
  and substr(cn.cnta_ctbl,1,2) = gc.grp_cntbl (+)
  and ca.flag_estado <> '0';

prompt
prompt Creating view VW_DE_LABOR_OT_ADM
prompt ================================
prompt
create or replace force view cantabria.vw_de_labor_ot_adm as
select la.cod_labor,
       la.desc_labor,
       la.und,
       la.flag_estado,
       oau.cod_usr
from labor               la,
     labor_grupo_rel     lgr,
     labor_grupo_ot_adm  lgoa,
     ot_adm_usuario      oau
where lgr.cod_labor = la.cod_labor
  and lgoa.grupo    = lgr.grupo
  and oau.ot_adm    = lgoa.ot_adm;

prompt
prompt Creating view VW_DE_TRAB_DESTAJO
prompt ================================
prompt
create or replace force view cantabria.vw_de_trab_destajo as
select b.cod_labor,
       b.desc_labor,
       a.cod_trabajador,
       cr.nombre as nom_trabajador,
       Trunc(c.fecha) as fecha,
       c.nro_parte,
       a.cant_destajada,
       la.und,
       a.horas_efectivas
from pd_ot_asist_destajo a,
     pd_ot_det           b,
     pd_ot               c,
     labor               la,
     codigo_relacion     cr
where a.nro_parte        = b.nro_parte
  and a.nro_item         = b.nro_item
  and c.nro_parte        = b.nro_parte
  and la.cod_labor       = b.cod_labor
  and cr.cod_relacion   = a.cod_trabajador;

prompt
prompt Creating view VW_DOC_TIPO_CONTROL_DOC
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_DOC_TIPO_CONTROL_DOC AS
SELECT d.tipo_doc, d.desc_tipo_doc
  FROM doc_tipo d
 WHERE d.flag_estado='1' and
       d.tipo_doc in (select dr.tipo_doc from doc_grupo_relacion dr
                      where dr.grupo=(select c.grupo_cd from cdparam c where reckey='1'))
ORDER BY d.tipo_doc;

prompt
prompt Creating view VW_EGRESOS_DIRECTOS
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_EGRESOS_DIRECTOS AS
SELECT TIPO_DOC		    ,
       NRO_DOC		    ,
       COD_RELACION
FROM  CNTAS_PAGAR
MINUS
SELECT CD.TIPO_DOC     ,
       CD.NRO_DOC      ,
       CB.COD_RELACION
  FROM CAJA_BANCOS     CB,
       CAJA_BANCOS_DET CD
 WHERE ((CB.ORIGEN       = CD.ORIGEN       )  AND
        (CB.NRO_REGISTRO = CD.NRO_REGISTRO )) AND
        (CB.FLAG_TIPTRAN = '9'             );

prompt
prompt Creating view VW_EMISOR_DOC_REC
prompt ===============================
prompt
create or replace force view cantabria.vw_emisor_doc_rec as
select distinct nombre_emisor
    from documentos_recibidos
    where ruc_emisor is Null;

prompt
prompt Creating view VW_EVALUACION_PERSONAL
prompt ====================================
prompt
create or replace force view cantabria.vw_evaluacion_personal as
select Cod_trabajador,cod_area,cod_cargo
    from rh_cargo_real_trabajador;

prompt
prompt Creating view VW_FACT_ANTICIPOS
prompt ===============================
prompt
create or replace force view cantabria.vw_fact_anticipos as
select ccd.tipo_doc,
         ccd.nro_doc,
         case
           when cc.cod_moneda = 'S/.' then 'PEN' else 'USD'
         end as cod_moneda,
         ccd.descripcion,
         abs(ccd.cantidad * ccd.precio_unitario +
         (select sum(ci.importe)
            from cc_doc_det_imp ci
           where ci.tipo_doc = ccd.tipo_doc
             and ci.nro_doc  = ccd.nro_doc
             and ci.item     = ccd.item)) as importe,
         '02' as tipo_anticipo,
         abs(ccd.cantidad * ccd.precio_unitario) as base_imponible,
         (select abs(sum(ci.importe))
            from cc_doc_det_imp ci
           where ci.tipo_doc = ccd.tipo_doc
             and ci.nro_doc  = ccd.nro_doc
             and ci.item     = ccd.item) as impuesto,
         pkg_fact_electronica.of_get_full_nro(cc.nro_doc) as nro_anticipo,
         to_char(cc.fecha_documento, 'YYYY-MM-DD') as fec_pago
    from cntas_cobrar_det  ccd,
         cntas_cobrar      cc
   where ccd.tipo_ref = cc.tipo_doc
     and ccd.nro_ref  = cc.nro_doc
     --and ccd.tipo_doc = 'FAC'
     --and ccd.nro_doc  like '%F3-63%'
     and ccd.precio_unitario < 0
;

prompt
prompt Creating view VW_FACT_DESCUENTOS
prompt ================================
prompt
create or replace force view cantabria.vw_fact_descuentos as
select ccd.tipo_doc, ccd.nro_doc,
         ccd.descripcion,
         abs(ccd.cantidad * ccd.precio_unitario +
          (select nvl(sum(ci.importe), 0)
             from cc_doc_det_imp ci
            where ci.tipo_doc = ccd.tipo_doc
              and ci.nro_doc  = ccd.nro_doc
              and ci.item     = ccd.item)) as importe
     from cntas_cobrar_det ccd
    where ccd.tipo_ref is null
      and ccd.nro_ref is null
      and (ccd.cantidad * ccd.precio_unitario) < 0
  union
  select ccd.tipo_doc, ccd.nro_doc,
         ccd.descripcion,
         abs(ccd.cantidad * ccd.precio_unitario +
          (select nvl(sum(ci.importe), 0)
             from cc_doc_det_imp ci
            where ci.tipo_doc = ccd.tipo_doc
              and ci.nro_doc  = ccd.nro_doc
              and ci.item     = ccd.item)) as importe
     from cntas_cobrar_det ccd,
          (select ccd.tipo_ref, ccd.nro_ref
             from cntas_cobrar_det ccd
           minus
           select cc.tipo_doc, cc.nro_doc
             from cntas_cobrar cc) s
    where ccd.tipo_ref = s.tipo_ref
      and ccd.nro_ref  = s.nro_ref
      and (ccd.cantidad * ccd.precio_unitario) < 0;

prompt
prompt Creating view VW_FIN_ART_X_VENTA
prompt ================================
prompt
create or replace force view cantabria.vw_fin_art_x_venta as
select art.cod_art,art.nom_articulo ,artv.confin ,cf.matriz_cntbl,artv.cnta_prsp_vale_sal,
       art.cod_clase
  from articulo art,articulo_venta artv ,concepto_financiero cf
 where (art.cod_art     = artv.cod_art ) and
			 (artv.confin     = cf.confin	   ) and
       (art.flag_estado = '1'          );

prompt
prompt Creating view VW_FIN_CLIENTE_CTAS_X_COBRAR
prompt ==========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_CLIENTE_CTAS_X_COBRAR AS
SELECT "CODIGO_RELACION"."COD_RELACION",
         "CODIGO_RELACION"."NOMBRE"
    FROM "CNTAS_COBRAR",
         "CODIGO_RELACION"
   WHERE ( "CNTAS_COBRAR"."COD_RELACION" = "CODIGO_RELACION"."COD_RELACION" )
GROUP BY "CODIGO_RELACION"."COD_RELACION",
         "CODIGO_RELACION"."NOMBRE"
ORDER BY "CODIGO_RELACION"."COD_RELACION" ASC;

prompt
prompt Creating view VW_FIN_CONS_INGRESOS_EGRESOS
prompt ==========================================
prompt
create or replace force view cantabria.vw_fin_cons_ingresos_egresos as
select cb.origen, cb.nro_registro, cb.cod_relacion, p.nom_proveedor,
       cb.fecha_emision, cb.tasa_cambio, to_char(ce.nro_cheque) as nro_cheque,
       cb.ano      ,  cb.mes,
       cb.nro_libro,     'INGRESOS' as desc_libro , cb.nro_asiento,
       cb.cod_moneda, cb.imp_total as imp_soles,
           0       as imp_dolar   , Round((cb.imp_total/cb.tasa_cambio),2) as dolarizado
from caja_bancos cb, proveedor p, finparam f, cheques_externos ce
where cb.cod_moneda in (select cod_soles from logparam where reckey ='1')and
      cb.cod_relacion = p.proveedor and
      cb.nro_libro  in (select libro_cobranzas from finparam where reckey ='1') and
      cb.origen    = ce.origen (+)and
      cb.nro_registro = ce.nro_registro (+)
union
select cb.origen, cb.nro_registro, cb.cod_relacion, p.nom_proveedor,
       cb.fecha_emision, cb.tasa_cambio, to_char(ce.nro_cheque) as nro_cheque,
       cb.ano      , cb.mes ,
       cb.nro_libro,     'EGRESOS' as desc_libro, cb.nro_asiento,
       cb.cod_moneda, cb.imp_total as imp_soles,
           0       as imp_dolar   , Round((cb.imp_total/cb.tasa_cambio),2) as dolarizado
from caja_bancos cb, proveedor p, finparam f, cheque_emitir ce
where cb.cod_moneda in (select cod_soles from logparam where reckey ='1')and
      cb.cod_relacion = p.proveedor and
      cb.nro_libro  in (select libro_pagos from finparam where reckey ='1') and
      cb.reg_cheque = ce.nro_registro (+)
union
select cb.origen, cb.nro_registro, cb.cod_relacion, p.nom_proveedor,
       cb.fecha_emision, cb.tasa_cambio, to_char(ce.nro_cheque) as nro_cheque,
       cb.ano      ,cb.mes,
       cb.nro_libro,    'INGRESOS' as desc_libro , cb.nro_asiento,
       cb.cod_moneda,           0  as imp_soles,
       cb.imp_total as imp_dolar  ,Round(cb.imp_total,2) as dolarizado
from caja_bancos cb, proveedor p, finparam f, cheques_externos ce
where cb.cod_moneda in (select cod_dolares from logparam where reckey ='1')and
      cb.cod_relacion = p.proveedor and
      cb.nro_libro  in (select libro_cobranzas from finparam where reckey ='1') and
      cb.origen = ce.origen (+) and
      cb.nro_registro = ce.nro_registro (+)
union
select cb.origen, cb.nro_registro, cb.cod_relacion, p.nom_proveedor,
       cb.fecha_emision, cb.tasa_cambio, to_char(ce.nro_cheque) as nro_cheque,
       cb.ano       ,cb.mes,
       cb.nro_libro,  'EGRESOS' as desc_libro, cb.nro_asiento,
       cb.cod_moneda,           0  as imp_soles,
       cb.imp_total as imp_dolar  ,Round(cb.imp_total,2) as dolarizado
from caja_bancos cb, proveedor p, finparam f, cheque_emitir ce
where cb.cod_moneda in (select cod_dolares from logparam where reckey ='1')and
      cb.cod_relacion = p.proveedor and
      cb.nro_libro  in (select libro_pagos from finparam where reckey ='1')and
      cb.reg_cheque = ce.nro_registro (+);

prompt
prompt Creating view VW_FIN_CONS_IE_ORIGEN
prompt ===================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_CONS_IE_ORIGEN AS
SELECT DISTINCT V.ORIGEN, O.NOMBRE
FROM   VW_FIN_CONS_INGRESOS_EGRESOS V, ORIGEN O
WHERE  V.ORIGEN = O.COD_ORIGEN;

prompt
prompt Creating view VW_FIN_CONS_IE_PROV
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_CONS_IE_PROV AS
SELECT DISTINCT V.COD_RELACION, V.NOM_PROVEEDOR
FROM   VW_FIN_CONS_INGRESOS_EGRESOS V;

prompt
prompt Creating view VW_FIN_CRELACION_X_SOLGIRO
prompt ========================================
prompt
create or replace force view cantabria.vw_fin_crelacion_x_solgiro as
select cr.cod_relacion ,cr.nombre
    from solicitud_giro  sg,
         codigo_relacion cr
  where sg.cod_relacion = cr.cod_relacion
   GROUP BY cr.cod_relacion ,cr.nombre;

prompt
prompt Creating view VW_FIN_EGRESOS_DIRECTOS
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_EGRESOS_DIRECTOS AS
SELECT TIPO_DOC		    ,
       NRO_DOC		    ,
       COD_RELACION
FROM  CNTAS_PAGAR
MINUS
SELECT CD.TIPO_DOC     ,
       CD.NRO_DOC      ,
       CB.COD_RELACION
  FROM CAJA_BANCOS     CB,
       CAJA_BANCOS_DET CD
 WHERE ((CB.ORIGEN       = CD.ORIGEN       )  AND
        (CB.NRO_REGISTRO = CD.NRO_REGISTRO )) AND
        (CB.FLAG_TIPTRAN = '9'             );

prompt
prompt Creating view VW_FIN_INGRESOS_DIRECTOS
prompt ======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_INGRESOS_DIRECTOS AS
SELECT TIPO_DOC		    ,
       NRO_DOC
FROM  CNTAS_COBRAR
MINUS
SELECT CD.TIPO_DOC     ,
       CD.NRO_DOC
  FROM CAJA_BANCOS     CB,
       CAJA_BANCOS_DET CD
 WHERE ((CB.ORIGEN       = CD.ORIGEN       )  AND
        (CB.NRO_REGISTRO = CD.NRO_REGISTRO )) AND
        (CB.FLAG_TIPTRAN = 'I'             );

prompt
prompt Creating view VW_FIN_DOC_GENERAL
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_DOC_GENERAL AS
SELECT CC.TIPO_DOC ,
         CC.NRO_DOC ,
         CC.COD_RELACION ,
         CC.COD_MONEDA ,
         CC.TASA_CAMBIO ,
         '1' AS FLAB_TABOR,
         CC.ORIGEN,
         CC.ANO,
         CC.MES,
         CC.NRO_LIBRO,
         CC.NRO_ASIENTO,
         CC.FECHA_DOCUMENTO,
         CC.FLAG_ESTADO
  FROM CNTAS_COBRAR             CC,
       VW_FIN_INGRESOS_DIRECTOS VI
  WHERE CC.TIPO_DOC = VI.TIPO_DOC
    AND CC.NRO_DOC  = VI.NRO_DOC
  UNION
  SELECT CP.TIPO_DOC ,
         CP.NRO_DOC ,
         CP.COD_RELACION ,
         CP.COD_MONEDA ,
         CP.TASA_CAMBIO ,
         '3' AS FLAB_TABOR,
         CP.ORIGEN ,
         CP.ANO ,
         CP.MES ,
         CP.NRO_LIBRO ,
         CP.NRO_ASIENTO ,
         CP.FECHA_EMISION ,
         CP.FLAG_ESTADO
  FROM CNTAS_PAGAR CP,
       VW_FIN_EGRESOS_DIRECTOS VE
  WHERE ((CP.COD_RELACION = VE.COD_RELACION (+) ) AND
  (CP.TIPO_DOC = VE.TIPO_DOC (+) ) AND
  (CP.NRO_DOC = VE.NRO_DOC (+) ))
  UNION
  SELECT CD.TIPO_DOC ,
  CD.NRO_DOC ,
  CB.COD_RELACION,
  CB.COD_MONEDA ,
  CB.TASA_CAMBIO ,
  'E' AS FLAB_TABOR,
  CB.ORIGEN ,
  CB.ANO ,
  CB.MES ,
  CB.NRO_LIBRO ,
  CB.NRO_ASIENTO ,
  CB.FECHA_EMISION ,
  CB.FLAG_ESTADO
  FROM CAJA_BANCOS CB,
  CAJA_BANCOS_DET CD
  WHERE ((CB.ORIGEN = CD.ORIGEN ) AND
  (CB.NRO_REGISTRO = CD.NRO_REGISTRO ))AND
  (CB.FLAG_TIPTRAN = '9' )
  UNION
  SELECT CD.TIPO_DOC ,
  CD.NRO_DOC ,
  CD.COD_RELACION,
  CB.COD_MONEDA ,
  CB.TASA_CAMBIO ,
  'E' AS FLAB_TABOR,
  CB.ORIGEN ,
  CB.ANO ,
  CB.MES ,
  CB.NRO_LIBRO ,
  CB.NRO_ASIENTO ,
  CB.FECHA_EMISION ,
  CB.FLAG_ESTADO
  FROM CAJA_BANCOS CB,
  CAJA_BANCOS_DET CD
  WHERE ((CB.ORIGEN = CD.ORIGEN ) AND
  (CB.NRO_REGISTRO = CD.NRO_REGISTRO ))AND
  (CB.FLAG_TIPTRAN = 'I' )
  UNION
  SELECT CD.TIPO_DOC ,
  CD.NRO_DOC ,
  CD.COD_RELACION,
  CB.COD_MONEDA ,
  CB.TASA_CAMBIO ,
  'G' AS FLAB_TABOR,
  CB.ORIGEN ,
  CB.ANO ,
  CB.MES ,
  CB.NRO_LIBRO ,
  CB.NRO_ASIENTO ,
  CB.FECHA_EMISION ,
  CB.FLAG_ESTADO
  FROM CAJA_BANCOS CB,
  CAJA_BANCOS_DET CD
  WHERE ((CB.ORIGEN = CD.ORIGEN ) AND
  (CB.NRO_REGISTRO = CD.NRO_REGISTRO ))AND
  (CB.FLAG_TIPTRAN = '7' ) AND
  (CB.FLAG_ESTADO <> '0' )
  UNION
  SELECT CD.TIPO_DOC ,
  CD.NRO_DOC ,
  CD.COD_RELACION,
  CB.COD_MONEDA ,
  CB.TASA_CAMBIO ,
  'N' AS FLAB_TABOR,
  CB.ORIGEN ,
  CB.ANO ,
  CB.MES ,
  CB.NRO_LIBRO ,
  CB.NRO_ASIENTO ,
  CB.FECHA_EMISION ,
  CB.FLAG_ESTADO
  FROM CAJA_BANCOS CB,
  CAJA_BANCOS_DET CD
  WHERE ((CB.ORIGEN = CD.ORIGEN ) AND
  (CB.NRO_REGISTRO = CD.NRO_REGISTRO ))AND
  (CB.FLAG_TIPTRAN = '8' )
  UNION
  SELECT (SELECT DOC_SOL_GIRO FROM FINPARAM WHERE RECKEY = '1' ) ,
  NRO_SOLICITUD ,
  COD_RELACION ,
  COD_MONEDA ,
  0.000 ,
  '6' AS FLAB_TABOR,
  ORIGEN ,
  0 AS ANO ,
  0 AS MES ,
  0 AS NRO_LIBRO ,
  0 AS NRO_ASIENTO,
  FECHA_EMISION ,
  FLAG_ESTADO
  FROM SOLICITUD_GIRO
  UNION
  SELECT (SELECT DOC_OC FROM LOGPARAM WHERE RECKEY = '1' ) ,
  NRO_OC ,
  PROVEEDOR ,
  COD_MONEDA ,
  0.000 ,
  '7' AS FLAB_TABOR,
  COD_ORIGEN ,
  0 AS ANO ,
  0 AS MES ,
  0 AS NRO_LIBRO ,
  0 AS NRO_ASIENTO,
  NULL ,
  FLAG_ESTADO
  FROM ORDEN_COMPRA
  UNION
  SELECT (SELECT DOC_OS FROM LOGPARAM WHERE RECKEY = '1' ) ,
  NRO_OS ,
  PROVEEDOR ,
  COD_MONEDA ,
  0.000 ,
  '8' AS FLAB_TABOR,
  COD_ORIGEN ,
  0 AS ANO ,
  0 AS MES ,
  0 AS NRO_LIBRO ,
  0 AS NRO_ASIENTO,
  null,
  FLAG_ESTADO
  FROM ORDEN_SERVICIO;

prompt
prompt Creating view VW_FIN_DOC_PENDIENTE_X_PAGAR
prompt ==========================================
prompt
create or replace force view cantabria.vw_fin_doc_pendiente_x_pagar as
select dt.tipo_doc,dt.desc_tipo_doc
  from doc_pendientes_cta_cte dp,doc_tipo dt
 where (dp.tipo_doc   = dt.tipo_doc )  and
       (dp.flag_tabla = '3'         )
group by  dt.tipo_doc,dt.desc_tipo_doc;

prompt
prompt Creating view VW_FIN_DOC_REF_X_PAG
prompt ==================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_DOC_REF_X_PAG AS
SELECT COD_ORIGEN, (SELECT doc_oc FROM logparam WHERE reckey = '1') as tipo_doc,NRO_OC as nro_doc,COD_MONEDA
FROM ORDEN_COMPRA
UNION
SELECT COD_ORIGEN,(SELECT doc_os FROM logparam WHERE reckey = '1'),NRO_OS,COD_MONEDA
FROM ORDEN_SERVICIO
UNION
SELECT A.COD_ORIGEN, (SELECT DOC_MOV_ALMACEN FROM LOGPARAM WHERE RECKEY = '1'), A.NRO_VALE, A.COD_MONEDA
FROM ARTICULO_MOV A;

prompt
prompt Creating view VW_FIN_DOC_VENTAS
prompt ===============================
prompt
create or replace force view cantabria.vw_fin_doc_ventas as
select dt.tipo_doc,dt.desc_tipo_doc
    from doc_tipo dt,doc_grupo_relacion dgr
   where ((dt.tipo_doc = dgr.tipo_doc )) AND
          (dgr.grupo   = (select f.doc_ventas from finparam f where reckey = '1'));

prompt
prompt Creating view VW_FIN_DOC_X_COBRAR_X_NCC002
prompt ==========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_DOC_X_COBRAR_X_NCC002 AS
SELECT DOC_FACT_COBRAR AS TIPO_DOC
   FROM FINPARAM
   WHERE RECKEY = '1'
  UNION
  SELECT DOC_BOL_COBRAR
   FROM FINPARAM
   WHERE RECKEY = '1'
  UNION
  SELECT NOTA_DEBITO
   FROM FINPARAM
   WHERE RECKEY = '1';

prompt
prompt Creating view VW_FIN_DOC_X_COBRAR_X_NDC003
prompt ==========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_DOC_X_COBRAR_X_NDC003 AS
SELECT DOC_FACT_COBRAR AS TIPO_DOC
   FROM FINPARAM
   WHERE RECKEY = '1'
  UNION
  SELECT DOC_BOL_COBRAR
   FROM FINPARAM
   WHERE RECKEY = '1'
  UNION
  SELECT DOC_LETRA_COBRAR
   FROM FINPARAM
   WHERE RECKEY = '1'
  UNION
  SELECT 'EX' from dual;

prompt
prompt Creating view VW_FIN_DOC_X_GRUPO_COBRAR
prompt =======================================
prompt
create or replace force view cantabria.vw_fin_doc_x_grupo_cobrar as
select dgr.tipo_doc,dt.desc_tipo_doc
  from doc_grupo dg, doc_grupo_relacion dgr, finparam fp ,doc_tipo dt
 where (dg.grupo     = dgr.grupo  ) and
       (dg.grupo     = fp.doc_grp_cob_directo ) and
       (dt.factor    = 1                      ) and
       (dgr.tipo_doc = dt.tipo_doc            );

prompt
prompt Creating view VW_FIN_DOC_X_GRUPO_PAGAR
prompt ======================================
prompt
create or replace force view cantabria.vw_fin_doc_x_grupo_pagar as
select dgr.tipo_doc,dt.desc_tipo_doc
  from doc_grupo dg, doc_grupo_relacion dgr, finparam fp ,doc_tipo dt
 where (dg.grupo     = dgr.grupo              ) and
       (dg.grupo     = fp.doc_grp_pag_directo ) and
       (dgr.tipo_doc = dt.tipo_doc            ) and
       (dt.factor    = -1                     );

prompt
prompt Creating view VW_FIN_DOC_X_PAGAR_CNS
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_DOC_X_PAGAR_CNS AS
SELECT "DOC_TIPO"."DESC_TIPO_DOC",
         "DOC_TIPO"."NRO_LIBRO",
         "DOC_TIPO"."TIPO_DOC"
    FROM "DOC_GRUPO_RELACION",
         "FINPARAM",
         "DOC_TIPO"
   WHERE ( "FINPARAM"."DOC_CXP" = "DOC_GRUPO_RELACION"."GRUPO" ) and
         ( "DOC_GRUPO_RELACION"."TIPO_DOC" = "DOC_TIPO"."TIPO_DOC" ) and
         ( "FINPARAM"."RECKEY" = '1' );

prompt
prompt Creating view VW_FIN_FLUJO_CAJA
prompt ===============================
prompt
create or replace force view cantabria.vw_fin_flujo_caja as
select  af.orden as orden1,
           af.desc_actividad,
           gc.orden as orden2,
           fc.orden as orden3,
           case
              when af.flag_tipo_flujo = 'E' then 'FLUJO ECONOMICO'
              when af.flag_tipo_flujo = 'F' then 'FLUJO FINANCIERO'
           END AS TIPO_FLUJO,
           case
              when gc.factor = 'I' then '01.Ingresos'
              else '02.Egresos'
           end as flag_ingr_egr,
           trunc(cb.fecha_emision) as fecha_emision,
           gc.descripcion as desc_grupo_flujo,
           fc.descripcion as desc_flujo_caja,
           cb.nro_registro,
           p.nom_proveedor,
           decode(p.tipo_doc_ident, '6', p.ruc,p.nro_doc_ident) as ruc_dni,
           to_number(to_char(cb.fecha_emision, 'yyyy')) as ano,
           to_number(to_char(cb.fecha_emision, 'mm')) as mes,
           to_number(to_char(cb.fecha_emision, 'yyyymm')) as periodo,
           PKG_UTILITY.of_semana(cb.fecha_emision) as semana,
           cb.origen,
           cbd.cod_moneda,
           cb.tasa_cambio,
           cbd.tipo_doc,
           cbd.nro_doc,
           cbd.importe,
           cb.obs,
           nvl(cbd.impt_ret_igv, 0) as impt_ret_igv,
           (
             cbd.importe -
             case
                when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then
                   nvl(cbd.impt_ret_igv, 0)
                else
                   nvl(cbd.impt_ret_igv, 0) / cb.tasa_cambio
             end
           ) * decode(gc.factor , 'E', -1, 1) * cbd.factor as imp_neto,
           cbd.factor,
           gc.factor as factor_ing_egr,
           case
             when gc.factor = 'I' then
               (case
                 when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then
                   cbd.importe
                 else
                   cbd.importe * cb.tasa_cambio
               end - nvl(cbd.impt_ret_igv, 0) ) * decode(gc.factor , 'E', -1, 1) * cbd.factor
             else
               0
           end as ingresos_sol,
           case
             when gc.factor = 'E' then
               (case
                 when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then
                   cbd.importe
                 else
                   cbd.importe * cb.tasa_cambio
               end - nvl(cbd.impt_ret_igv, 0) ) * decode(gc.factor , 'E', -1, 1) * cbd.factor
             else
               0
           end as egresos_sol,
           case
             when gc.factor = 'I' then
               (case
                 when cbd.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
                   cbd.importe
                 else
                   cbd.importe / cb.tasa_cambio
               end - (nvl(cbd.impt_ret_igv, 0) / cb.tasa_cambio) ) * decode(gc.factor , 'E', -1, 1) * cbd.factor
             else
               0
           end as ingresos_dol,
           case
             when gc.factor = 'E' then
               (case
                 when cbd.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
                   cbd.importe
                 else
                   cbd.importe / cb.tasa_cambio
               end - (nvl(cbd.impt_ret_igv, 0) / cb.tasa_cambio) ) * decode(gc.factor , 'E', -1, 1) * cbd.factor
             else
               0
           end as egresos_dol
     from caja_bancos           cb,
          caja_bancos_det       cbd,
          codigo_flujo_caja     fc,
          grupo_cod_flujo_caja  gc,
          fin_actividad_flujo   af,
          banco_cnta            bc,
          proveedor             p
    where cb.origen            = cbd.origen
      and cb.nro_registro      = cbd.nro_registro
      and cb.cod_ctabco         = bc.cod_ctabco
      and cbd.cod_flujo_caja    = fc.cod_flujo_caja
      and fc.grp_flujo_caja     = gc.grp_flujo_caja
      and gc.cod_actividad     = af.cod_actividad
      and cbd.cod_relacion     = p.proveedor
      and cb.flag_estado       <> '0'
      and bc.flag_flujo_caja   = '1'
order by 1, 2, flag_ingr_egr;

prompt
prompt Creating view VW_FIN_PENDIENTE_COBRAR
prompt =====================================
prompt
create or replace force view cantabria.vw_fin_pendiente_cobrar as
select to_number(to_char(cc.fecha_vencimiento, 'yyyy')) as ano_vence,
           to_number(to_char(cc.fecha_vencimiento, 'mm')) as mes_vence,
           to_number(to_char(cc.fecha_vencimiento, 'yyyymm')) as periodo_vence,
           PKG_UTILITY.of_semana(cc.fecha_vencimiento) as semana_vence,
           cc.cod_relacion,
           p.nom_proveedor,
           p.tipo_doc_ident,
           decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
           cc.origen,
           cc.tipo_doc,
           cc.fecha_documento as fecha_emision,
           cc.fecha_vencimiento,
           cc.forma_pago,
           cc.medio_pago,
           PKG_FACT_ELECTRONICA.of_get_serie(cc.nro_doc) as serie,
           PKG_FACT_ELECTRONICA.of_get_nro(cc.nro_doc) as numero,
           cc.nro_doc,
           PKG_FACT_ELECTRONICA.of_get_full_nro(cc.nro_doc) as full_nro_doc,
           cc.cod_moneda,
           cc.importe_doc,
           cc.tasa_cambio,
           cc.observacion,
           (select cf.confin || ' - ' || cf.descripcion
              from concepto_financiero cf,
                   cntas_cobrar_Det    ccd
             where cf.confin = ccd.confin
               and ccd.tipo_doc     = cc.tipo_doc
               and ccd.nro_doc      = cc.nro_doc
               and rownum           = 1) as confin,
           cc.saldo_sol,
           cc.saldo_dol,
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_soles(null) then
               cc.saldo_sol
             else
               cc.saldo_dol
           end as saldo,
           (trunc(sysdate) - cc.fecha_vencimiento) as dias_mora,
           (Select trim(dr.tipo_ref) || ' - ' || dr.nro_ref
              from doc_referencias dr
             where dr.cod_relacion = cc.cod_relacion
               and dr.tipo_doc     = cc.tipo_doc
               and dr.nro_doc      = cc.nro_doc
               and rownum      = 1) as referencia,
           case
               when cc.nro_asiento is not null then
                 cc.origen || trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) || trim(to_char(cc.nro_libro, '00')) || trim(to_char(cc.nro_Asiento, '000000'))
               else
                 ''
           end as voucher,
           trim(to_char(cc.fecha_documento, 'mm/yyyy')) as periodo,
           cc.flag_detraccion,
           cc.observacion as descripcion,
           cc.flag_provisionado,
           cc.flag_control_reg,
           cc.flag_caja_bancos,
           cc.flag_estado,
           cc.cod_usr,
           'CXC' as tabla,
           cc.nro_libro,
           cc.nro_asiento,
           dt.factor,
           USP_SIGRE_CNTBL.of_get_ult_cnta_cntbl(cc.cod_relacion, cc.tipo_doc, cc.nro_doc) as cnta_ctbl,
           null as desc_cnta,
           cc.vendedor,
           v.nom_vendedor
    from cntas_cobrar cc,
         proveedor     p,
         doc_tipo      dt,
         vendedor      v
    where cc.cod_relacion    = p.proveedor
      and cc.tipo_doc        = dt.tipo_doc
      and cc.vendedor        = v.vendedor    (+)
      and ((cc.cod_moneda    = PKG_LOGISTICA.of_soles(null) and cc.saldo_sol > 0) or
           (cc.cod_moneda    = PKG_LOGISTICA.of_dolares(null) and cc.saldo_dol > 0) )
      and cc.flag_estado     <> '0'
      and (cc.flag_provisionado = 'R'
       or (cc.flag_provisionado = 'D' and cc.flag_control_reg = '0')
       or (cc.flag_provisionado = 'D' and cc.flag_control_reg = '1' and cc.flag_caja_bancos = '0'))
    union
    select to_number(to_char(cp.vencimiento, 'yyyy')) as ano_vence,
           to_number(to_char(cp.vencimiento, 'mm')) as mes_vence,
           to_number(to_char(cp.vencimiento, 'yyyymm')) as periodo_vence,
           PKG_UTILITY.of_semana(cp.vencimiento) as semana_vence,
           cp.cod_relacion,
           p.nom_proveedor,
           p.tipo_doc_ident,
           decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
           cp.origen,
           cp.tipo_doc,
           cp.fecha_emision as fecha_emision,
           cp.vencimiento as fecha_vencimiento,
           cp.forma_pago,
           null as medio_pago,
           cp.serie_cp as serie,
           cp.numero_cp as numero,
           cp.nro_doc,
           case
             when cp.serie_cp is not null or cp.numero_cp is not null then
               cp.serie_cp || '-' || cp.numero_cp
             else
               cp.nro_doc
           end as full_nro_doc,
           cp.cod_moneda,
           cp.importe_doc,
           cp.tasa_cambio,
           cp.descripcion,
           (select cf.confin || ' - ' || cf.descripcion
              from concepto_financiero cf,
                   cntas_pagar_det     cpd
             where cf.confin = cpd.confin
               and cpd.cod_relacion = cp.cod_relacion
               and cpd.tipo_doc     = cp.tipo_doc
               and cpd.nro_doc      = cp.nro_doc
               and rownum           = 1) as confin,
           cp.saldo_sol,
           cp.saldo_dol,
           case
             when cp.cod_moneda = PKG_LOGISTICA.of_soles(null) then
               cp.saldo_sol
             else
               cp.saldo_dol
           end as saldo,
           (trunc(sysdate) - cp.vencimiento) as dias_mora,
           (Select trim(dr.tipo_ref) || ' - ' || dr.nro_ref
              from doc_referencias dr
             where dr.cod_relacion = cp.cod_relacion
               and dr.tipo_doc     = cp.tipo_doc
               and dr.nro_doc      = cp.nro_doc
               and rownum      = 1) as referencia,
           case
               when cp.nro_asiento is not null then
                 cp.origen || trim(to_char(cp.ano, '0000')) || trim(to_char(cp.mes, '00')) || trim(to_char(cp.nro_libro, '00')) || trim(to_char(cp.nro_Asiento, '000000'))
               else
                 ''
           end as voucher,
           trim(to_char(cp.fecha_emision, 'mm/yyyy')) as periodo,
           cp.flag_detraccion,
           cp.descripcion as descripcion,
           cp.flag_provisionado,
           cp.flag_control_reg,
           cp.flag_caja_bancos,
           cp.flag_estado,
           cp.cod_usr,
           'CXP' as tabla,
           cp.nro_libro,
           cp.nro_asiento,
           1 as factor,
           USP_SIGRE_CNTBL.of_get_ult_cnta_cntbl(cp.cod_relacion, cp.tipo_doc, cp.nro_doc) as cnta_ctbl,
           null as desc_cnta,
           null as vendedor,
           null as nom_vendedor
    from cntas_pagar   cp,
         proveedor     p,
         doc_tipo      dt
    where cp.cod_relacion   = p.proveedor
      and cp.tipo_doc       = dt.tipo_doc
      and ((cp.cod_moneda   = PKG_LOGISTICA.of_soles(null) and cp.saldo_sol > 0) or
           (cp.cod_moneda   = PKG_LOGISTICA.of_dolares(null) and cp.saldo_dol > 0) )
      and cp.flag_estado    <> '0'
      and cp.flag_provisionado = 'D' and cp.flag_control_reg = '1' and cp.flag_caja_bancos = '1';

prompt
prompt Creating view VW_FIN_PENDIENTE_PAGAR
prompt ====================================
prompt
create or replace force view cantabria.vw_fin_pendiente_pagar as
select   /*+ PARALLEL(8) */
         to_number(to_char(cp.vencimiento, 'yyyy')) as ano_vence,
         to_number(to_char(cp.vencimiento, 'mm')) as mes_vence,
         to_number(to_char(cp.vencimiento, 'yyyymm')) as periodo_vence,
         PKG_UTILITY.of_semana(cp.vencimiento) as semana_vence,
         cp.cod_relacion,
         p.nom_proveedor,
         p.tipo_doc_ident,
         decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
         cp.origen,
         cp.ano,
         cp.mes,
         cp.nro_libro,
         cp.nro_asiento,
         cp.tipo_doc,
         cp.fecha_emision,
         cp.fecha_presentacion,
         cp.vencimiento,
         cp.forma_pago,
         (case when cp.flag_estado=1 then 'GENERADO' ELSE CASE WHEN cp.flag_estado=3 then 'CANCELADO' else '-' END END) as ESTADO,
         cp.serie_cp as serie,
         (case when cp.numero_cp is null then PKG_FACT_ELECTRONICA.of_get_full_nro(cp.nro_doc) ELSE cp.numero_cp END ) as numero,
         case
            when cp.serie_cp is not null and cp.numero_cp is not null then
               cp.serie_cp || '-' || PKG_UTILITY.of_trim(cp.numero_cp, '0')
            else
               cp.nro_doc
         end as full_nro_doc,
         cp.nro_doc,
         cp.cod_moneda,
         cp.importe_doc,
         cp.tasa_cambio,
         dt.factor * -1 as factor,
         case
           when cp.cod_moneda = pkg_logistica.of_soles(null) then
             cp.saldo_sol
           else
             cp.saldo_dol
         end as saldo,
         (select cf.confin || ' - ' || cf.descripcion
            from concepto_financiero cf,
                 cntas_pagar_Det     cpd
           where cf.confin = cpd.confin
             and cpd.cod_relacion = cp.cod_relacion
             and cpd.tipo_doc     = cp.tipo_doc
             and cpd.nro_doc      = cp.nro_doc
             and rownum           = 1) as confin,
         case
            when cp.cod_moneda = pkg_logistica.of_soles(null) then
               cp.saldo_sol
            else
               cp.saldo_dol * cp.tasa_cambio
         end as saldo_sol,
         case
            when cp.cod_moneda = pkg_logistica.of_dolares(null) then
               cp.saldo_dol
            else
               cp.saldo_sol / cp.tasa_cambio
         end as saldo_dol,
         (trunc(sysdate) - cp.vencimiento) as dias_mora,
         (Select dr.tipo_ref || '-' || dr.nro_ref
            from doc_referencias dr
           where dr.cod_relacion = cp.cod_relacion
             and dr.tipo_doc    = cp.tipo_doc
             and dr.nro_doc     = cp.nro_doc
             and rownum      = 1) as referencia,
         case
          when cp.nro_asiento is not null then
            cp.origen || trim(to_char(cp.ano, '0000')) || trim(to_char(cp.mes, '00')) || trim(to_char(cp.nro_libro, '00')) || trim(to_char(cp.nro_Asiento, '000000'))
          else
            ''
        end as voucher,
        trim(to_char(cp.fecha_emision, 'mm/yyyy')) as periodo,
        cp.flag_detraccion,
        cp.descripcion,
        cp.flag_provisionado,
        cp.flag_control_reg,
        cp.flag_caja_bancos,
        cp.fecha_registro,
        cp.flag_estado,
        'CP' as flag_cxp_cxc,
        s.cnta_ctbl,
        s.desc_cnta
  from cntas_pagar cp,
       proveedor   p,
       doc_tipo    dt,
       (select distinct
                 cad.cnta_ctbl,
                 cc2.desc_cnta,
                 cad.cod_relacion,
                 cad.tipo_docref1 as tipo_Doc,
                 trim(cad.nro_docref1) as nro_doc
            from cntbl_asiento ca,
                 cntbl_Asiento_det cad,
                 cntbl_cnta        cc2
           where ca.origen         = cad.origen
             and ca.ano            = cad.ano
             and ca.mes            = cad.mes
             and ca.nro_libro      = cad.nro_libro
             and ca.nro_Asiento    = cad.nro_Asiento
             and cad.cnta_ctbl     = cc2.cnta_ctbl
             and ca.flag_estado    <> '0'
             and cad.tipo_docref1  is not null
             and cad.nro_docref1   is not null
             and cad.cod_relacion  is not null) s
  where cp.cod_relacion    = p.proveedor
    and cp.tipo_doc        = dt.tipo_doc
    and cp.cod_relacion    = s.cod_relacion  (+)
    and cp.tipo_doc        = s.tipo_doc      (+)
    and trim(cp.nro_doc)   = s.nro_doc       (+)
    and ((cp.cod_moneda    = PKG_LOGISTICA.of_soles(null) and cp.saldo_sol > 0) or
         (cp.cod_moneda    = PKG_LOGISTICA.of_dolares(null) and cp.saldo_dol > 0) )
    and cp.flag_estado     <> '0'
    and (cp.flag_provisionado = 'R'
     or (cp.flag_provisionado = 'D' and cp.flag_control_reg = '0')
     or (cp.flag_provisionado = 'D' and cp.flag_control_reg = '1' and cp.flag_caja_bancos = '0'))
  union
  select   to_number(to_char(cc.fecha_vencimiento, 'yyyy')) as ano_vence,
           to_number(to_char(cc.fecha_vencimiento, 'mm')) as mes_vence,
           to_number(to_char(cc.fecha_vencimiento, 'yyyymm')) as periodo_vence,
           PKG_UTILITY.of_semana(cc.fecha_vencimiento) as semana_vence,
           cc.cod_relacion,
           p.nom_proveedor,
           p.tipo_doc_ident,
           decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
           cc.origen,
           cc.ano,
           cc.mes,
           cc.nro_libro,
           cc.nro_asiento,
           cc.tipo_doc,
           cc.fecha_documento,
           cc.fecha_presentacion,
           cc.fecha_vencimiento,
           cc.forma_pago,
          (case when cc.flag_estado=1 then 'GENERADO' ELSE CASE WHEN cc.flag_estado=3 then 'CANCELADO' else '-' END END) as ESTADO,
           PKG_FACT_ELECTRONICA.of_get_serie(cc.nro_doc) as serie,
           PKG_FACT_ELECTRONICA.of_get_nro(cc.nro_doc) as numero,
           PKG_FACT_ELECTRONICA.of_get_full_nro(cc.nro_doc) as full_nro_doc,
           PKG_FACT_ELECTRONICA.of_get_full_nro(cc.nro_doc) as nro_doc,
           cc.cod_moneda,
           cc.importe_doc,
           cc.tasa_cambio,
           -1 as factor,
           case
             when cc.cod_moneda = pkg_logistica.of_soles(null) then
               cc.saldo_sol
             else
               cc.saldo_dol
           end as saldo,
           (select cf.confin || ' - ' || cf.descripcion
              from concepto_financiero cf,
                   cntas_cobrar_det     ccd
             where cf.confin = ccd.confin
               and ccd.tipo_doc     = cc.tipo_doc
               and ccd.nro_doc      = cc.nro_doc
               and rownum           = 1) as confin,

        case
          when cc.cod_moneda = pkg_logistica.of_soles(null) then
            cc.saldo_sol
          else
            cc.saldo_dol * cc.tasa_cambio
        end as saldo_sol,
        case
          when cc.cod_moneda = pkg_logistica.of_dolares(null) then
            cc.saldo_dol
          else
            cc.saldo_sol / cc.tasa_cambio
        end as saldo_dol,
           (trunc(sysdate) - cc.fecha_vencimiento) as dias_mora,
           (Select dr.tipo_ref || '-' || dr.nro_ref
             from doc_referencias dr
             where dr.cod_relacion = cc.cod_relacion
               and dr.tipo_doc    = cc.tipo_doc
               and dr.nro_doc     = cc.nro_doc
               and rownum      = 1) as referencia,
           case
             when cc.nro_asiento is not null then
                cc.origen || trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) || trim(to_char(cc.nro_libro, '00')) || trim(to_char(cc.nro_Asiento, '000000'))
               else
                 ''
           end as voucher,
           trim(to_char(cc.fecha_documento, 'mm/yyyy')) as periodo,
           cc.flag_detraccion,
           cc.observacion,
           cc.flag_provisionado,
           cc.flag_control_reg,
           cc.flag_caja_bancos,
           cc.fecha_registro,
           cc.flag_estado,
           'CC' as flag_cxp_cxc,
           s.cnta_ctbl,
           s.desc_cnta
           --cc.flag_provisionado
  from cntas_cobrar cc,
       proveedor   p,
       doc_tipo    dt,
       (select distinct
                 cad.cnta_ctbl,
                 cc2.desc_cnta,
                 cad.cod_relacion,
                 cad.tipo_docref1 as tipo_Doc,
                 trim(cad.nro_docref1) as nro_doc
            from cntbl_asiento ca,
                 cntbl_Asiento_det cad,
                 cntbl_cnta        cc2
           where ca.origen         = cad.origen
             and ca.ano            = cad.ano
             and ca.mes            = cad.mes
             and ca.nro_libro      = cad.nro_libro
             and ca.nro_Asiento    = cad.nro_Asiento
             and cad.cnta_ctbl     = cc2.cnta_ctbl
             and ca.flag_estado    <> '0'
             and cad.tipo_docref1  is not null
             and cad.nro_docref1   is not null
             and cad.cod_relacion  is not null) s
  where cc.cod_relacion    = p.proveedor
    and cc.tipo_doc        = dt.tipo_doc
    and cc.cod_relacion    = s.cod_relacion  (+)
    and cc.tipo_doc        = s.tipo_doc      (+)
    and trim(cc.nro_doc)   = s.nro_doc       (+)
    and ((cc.cod_moneda    = PKG_LOGISTICA.of_soles(null) and cc.saldo_sol > 0) or
         (cc.cod_moneda    = PKG_LOGISTICA.of_dolares(null) and cc.saldo_dol > 0) )
    and cc.flag_estado     <> '0'
    and (cc.flag_provisionado = 'D' and cc.flag_control_reg = '1' and cc.flag_caja_bancos = '1')
;

prompt
prompt Creating view VW_FIN_FLUJO_CAJA_PROY
prompt ====================================
prompt
create or replace force view cantabria.vw_fin_flujo_caja_proy as
select  'FLUJO ECONOMICO'AS TIPO_FLUJO,
           '01.Ingresos' as flag_ingr_egr,
           cc.confin,
           trunc(cc.fecha_emision) as fecha_emision,
           trunc(cc.fecha_vencimiento) as fecha_vencimiento,
           cc.mes_vence,
           cc.nom_proveedor,
           cc.ruc_dni,
           cc.ano_vence as ano,
           cc.mes_vence as mes,
           cc.periodo_vence as periodo,
           cc.semana_vence as semana,
           cc.cod_moneda,
           cc.tasa_cambio,
           cc.tipo_doc,
           cc.nro_doc,
           cc.importe_doc,
           cc.descripcion,
           cc.saldo as importe,
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_soles(null) then
               cc.saldo_sol
             else
               0
           end as ingresos_sol,
           0 as egresos_sol,
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
               cc.saldo_dol
             else
               0
           end as ingresos_dol,
           0 as egresos_dol,
           cc.origen
     from vw_fin_pendiente_cobrar cc
    where cc.voucher is not null
      or (cc.flag_provisionado = 'D' or cc.flag_control_reg = '0')
union
   select  'FLUJO ECONOMICO'AS TIPO_FLUJO,
           '02.Egresos' as flag_ingr_egr,
           cp.confin,
           trunc(cp.fecha_emision) as fecha_emision,
           trunc(cp.vencimiento) as fecha_vencimiento,
           cp.mes_vence,
           cp.nom_proveedor,
           cp.ruc_dni,
           cp.ano_vence as ano,
           cp.mes_vence as mes,
           cp.periodo_vence as periodo,
           cp.semana_vence as semana,
           cp.cod_moneda,
           cp.tasa_cambio,
           cp.tipo_doc,
           cp.nro_doc,
           cp.importe_doc,
           cp.descripcion,
           cp.saldo * -1 as importe,
           0 as ingresos_sol,
           case
             when cp.cod_moneda = PKG_LOGISTICA.of_soles(null) then
               cp.saldo_sol
             else
               0
           end as egresos_sol,
           0 as ingresos_sol,
           case
             when cp.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
               cp.saldo_dol
             else
               0
           end as egresos_dol,
           cp.origen
     from vw_fin_pendiente_pagar cp
    where cp.voucher is not null
      or (cp.flag_provisionado = 'D' or cp.flag_control_reg = '0')

order by 1, 2, flag_ingr_egr;

prompt
prompt Creating view VW_FIN_HELP_CAJA_BANCOS
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_HELP_CAJA_BANCOS AS
SELECT  ORIGEN ,
        NRO_REGISTRO ,
        cb.FLAG_ESTADO ,
        FECHA_EMISION ,
        ANO ,
        MES ,
        NRO_LIBRO ,
        NRO_ASIENTO ,
        TRIM(origen) || TRIM(TO_CHAR(ano, '0000'))|| TRIM(TO_CHAR(mes,'00')) || TRIM(TO_CHAR(nro_libro, '00')) || TRIM(TO_CHAR(nro_asiento, '000000')) AS VOUCHER,
        FLAG_TIPTRAN,
        CB.Imp_Total,
        CB.COD_CTABCO,
        cb.cod_relacion,
        p.nom_proveedor,
        cb.tipo_doc, cb.nro_doc, cb.reg_cheque,
        cb.obs
 FROM   CAJA_BANCOS CB,
        proveedor   p
WHERE cb.cod_relacion = p.proveedor (+);

prompt
prompt Creating view VW_FIN_HELP_CNTAS_PAGAR
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_HELP_CNTAS_PAGAR AS
SELECT "CNTAS_PAGAR"."COD_RELACION" ,"CNTAS_PAGAR"."TIPO_DOC"      ,
       "CNTAS_PAGAR"."NRO_DOC"      ,"CNTAS_PAGAR"."FLAG_ESTADO"   ,
       "PROVEEDOR"."NOM_PROVEEDOR"  , "CNTAS_PAGAR"."SALDO_SOL"	   ,
	 	   "CNTAS_PAGAR"."SALDO_DOL"		,"CNTAS_PAGAR"."ORIGEN"        ,
		   "CNTAS_PAGAR"."ANO"          ,"CNTAS_PAGAR"."MES"           ,
       "CNTAS_PAGAR"."NRO_LIBRO"    ,"CNTAS_PAGAR"."NRO_ASIENTO"   ,
       "CNTAS_PAGAR"."FECHA_EMISION", "CNTAS_PAGAR"."FECHA_REGISTRO",
		   RTRIM(LTRIM(cntas_pagar.origen))||RTRIM(LTRIM(TO_CHAR(cntas_pagar.ano)))||RTRIM(LTRIM(TO_CHAR(cntas_pagar.mes,'09')))||RTRIM(LTRIM(TO_CHAR(cntas_pagar.nro_libro)))||RTRIM(LTRIM(TO_CHAR(cntas_pagar.nro_asiento))) AS VOUCHER
  FROM "CNTAS_PAGAR" ,"PROVEEDOR" ,"DOC_GRUPO_RELACION" ,"FINPARAM"
 WHERE ( "PROVEEDOR"."PROVEEDOR"           = "CNTAS_PAGAR"."COD_RELACION"    ) and
       ( "CNTAS_PAGAR"."TIPO_DOC"          = "DOC_GRUPO_RELACION"."TIPO_DOC" ) and
       ( "DOC_GRUPO_RELACION"."GRUPO"      = "FINPARAM"."DOC_CXP"            ) and
   		 ( "CNTAS_PAGAR"."FLAG_PROVISIONADO" = 'R'								             );

prompt
prompt Creating view VW_FIN_HELP_RPT_SLDO_CTA_CTE
prompt ==========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_HELP_RPT_SLDO_CTA_CTE AS
SELECT  DISTINCT DP.COD_RELACION,
        P.NOM_PROVEEDOR
FROM    DOC_PENDIENTES_CTA_CTE DP,
        PROVEEDOR P,
        DOC_TIPO DT
WHERE   DP.COD_RELACION = P.PROVEEDOR AND
        DP.TIPO_DOC     = DT.TIPO_DOC;

prompt
prompt Creating view VW_FIN_LIQUIDACION_CTACTE
prompt =======================================
prompt
create or replace force view cantabria.vw_fin_liquidacion_ctacte as
select f.doc_liq_x_cobrar as tipo_doc,dt.desc_tipo_doc,dt.factor
    from finparam f ,doc_tipo dt
   where (f.doc_liq_x_cobrar = dt.tipo_doc)
   union
  select f.doc_liq_x_pagar,dt.desc_tipo_doc,dt.factor
    from finparam f ,doc_tipo dt
   where (f.doc_liq_x_pagar = dt.tipo_doc);

prompt
prompt Creating view VW_FIN_NC_X_COBRAR_REVERSION
prompt ==========================================
prompt
create or replace force view cantabria.vw_fin_nc_x_cobrar_reversion as
select D.TIPO_DOC, DT.FLAG_SIGNO, D.NRO_DOC, D.COD_MONEDA,
       D.SLDO_SOL, D.SALDO_DOL, D.CNTA_CTBL,
       DECODE(D.FLAG_DEBHAB,'D','H','D') AS FLAG_DEBHAB,
       D.FLAG_TABLA, D.COD_RELACION, CC.ORIGEN AS ORIGEN_REF
       , CD.CONFIN
from DOC_PENDIENTES_CTA_CTE D, DOC_TIPO DT,
     CNTAS_COBRAR CC , CNTAS_COBRAR_DET CD
where (D.TIPO_DOC = (select doc_fact_cobrar from finparam where reckey ='1')or
       D.TIPO_DOC = (select doc_bol_cobrar  from finparam where reckey ='1')or
       D.TIPO_DOC = (select nota_debito from finparam where reckey = '1')) AND
      D.TIPO_DOC = DT.TIPO_DOC  AND
      D.COD_RELACION = CC.COD_RELACION AND
      D.TIPO_DOC = CC.TIPO_DOC  AND
      D.NRO_DOC  = CC.NRO_DOC   AND
      CC.TIPO_DOC = CD.TIPO_DOC AND
      CC.NRO_DOC = CD.NRO_DOC;

prompt
prompt Creating view VW_FIN_NETOS_CAJA_SEMANAL
prompt =======================================
prompt
create or replace force view cantabria.vw_fin_netos_caja_semanal as
select af.orden,
         af.desc_actividad,
         to_number(to_char(cb.fecha_emision, 'yyyy')) as ano,
         pkg_utility.of_semana(cb.fecha_emision) as semana,
         cb.origen,
         cb.fecha_emision,
         pkg_utility.of_last_day_week(cb.fecha_emision) as fecha_fin,
         case
           when to_char(cb.fecha_emision, 'mm') = '01' then '01.Enero'
           when to_char(cb.fecha_emision, 'mm') = '02' then '02.Febrero'
           when to_char(cb.fecha_emision, 'mm') = '03' then '03.Marzo'
           when to_char(cb.fecha_emision, 'mm') = '04' then '04.Abril'
           when to_char(cb.fecha_emision, 'mm') = '05' then '05.Mayo'
           when to_char(cb.fecha_emision, 'mm') = '06' then '06.Junio'
           when to_char(cb.fecha_emision, 'mm') = '07' then '07.Julio'
           when to_char(cb.fecha_emision, 'mm') = '08' then '08.Agosto'
           when to_char(cb.fecha_emision, 'mm') = '09' then '09.Setiembre'
           when to_char(cb.fecha_emision, 'mm') = '10' then '10.Octubre'
           when to_char(cb.fecha_emision, 'mm') = '11' then '11.Noviembre'
           when to_char(cb.fecha_emision, 'mm') = '12' then '12.Diciembre'
         end as mes,
         sum(case
                 when cbd.cod_moneda = pkg_logistica.of_soles(null) then
                   cbd.importe
                 else
                   cbd.importe * cb.tasa_cambio
               end * DECODE(gc.factor, 'E', -1, 1) * cbd.factor ) as saldo_sol,
         sum(case
                 when cbd.cod_moneda = pkg_logistica.of_dolares(null) then
                   cbd.importe
                 else
                   cbd.importe / cb.tasa_cambio
               end * DECODE(gc.factor, 'E', -1, 1) * cbd.factor ) as saldo_dol

      from caja_bancos         cb,
          caja_bancos_det     cbd,
          codigo_flujo_caja     fc,
          grupo_cod_flujo_caja   gc,
         fin_actividad_flujo  af,
         banco_cnta        bc
      where cb.origen         = cbd.origen
        and cb.nro_registro     = cbd.nro_registro
        and cbd.cod_flujo_caja   = fc.cod_flujo_caja
        and fc.grp_flujo_caja    = gc.grp_flujo_caja
        and gc.cod_actividad     = af.cod_actividad
        and cb.cod_ctabco      = bc.cod_ctabco
        and cb.flag_estado      <> '0'
        and bc.flag_flujo_caja  = '1'
    group by af.orden,
           af.desc_actividad,
           cb.origen,
           case
             when to_char(cb.fecha_emision, 'mm') = '01' then '01.Enero'
             when to_char(cb.fecha_emision, 'mm') = '02' then '02.Febrero'
             when to_char(cb.fecha_emision, 'mm') = '03' then '03.Marzo'
             when to_char(cb.fecha_emision, 'mm') = '04' then '04.Abril'
             when to_char(cb.fecha_emision, 'mm') = '05' then '05.Mayo'
             when to_char(cb.fecha_emision, 'mm') = '06' then '06.Junio'
             when to_char(cb.fecha_emision, 'mm') = '07' then '07.Julio'
             when to_char(cb.fecha_emision, 'mm') = '08' then '08.Agosto'
             when to_char(cb.fecha_emision, 'mm') = '09' then '09.Setiembre'
             when to_char(cb.fecha_emision, 'mm') = '10' then '10.Octubre'
             when to_char(cb.fecha_emision, 'mm') = '11' then '11.Noviembre'
             when to_char(cb.fecha_emision, 'mm') = '12' then '12.Diciembre'
           end,
           cb.fecha_emision;

prompt
prompt Creating view VW_FIN_NV_X_COBRAR_AJUSTE
prompt =======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_NV_X_COBRAR_AJUSTE AS
SELECT D.TIPO_DOC  , T.FLAG_SIGNO , D.NRO_DOC,
       D.COD_MONEDA, D.SLDO_SOL   , D.SALDO_DOL,
       D.CNTA_CTBL , decode(D.FLAG_DEBHAB,'D','H','D') as flag_debhab,
       D.FLAG_TABLA, D.COD_RELACION, CC.ORIGEN AS ORIGEN_REF
FROM   DOC_PENDIENTES_CTA_CTE D, DOC_TIPO T,
       CNTAS_COBRAR CC
WHERE  ( D.TIPO_DOC = (select doc_fact_cobrar from finparam where reckey ='1' )or
         D.TIPO_DOC = (select doc_bol_cobrar  from finparam where reckey ='1')) AND
       ( D.TIPO_DOC     = T.TIPO_DOC AND
         D.COD_RELACION = CC.COD_RELACION AND
         D.TIPO_DOC     = CC.TIPO_DOC AND
         D.NRO_DOC      = CC.NRO_DOC );

prompt
prompt Creating view VW_FIN_NV_X_COBRAR_REVERSION
prompt ==========================================
prompt
create or replace force view cantabria.vw_fin_nv_x_cobrar_reversion as
select D.TIPO_DOC, DT.FLAG_SIGNO, D.NRO_DOC, D.COD_MONEDA,
       D.SLDO_SOL, D.SALDO_DOL, D.CNTA_CTBL,
       DECODE(D.FLAG_DEBHAB,'D','H','D') AS FLAG_DEBHAB,
       D.FLAG_TABLA, D.COD_RELACION, CC.ORIGEN AS ORIGEN_REF
       , CD.CONFIN
from DOC_PENDIENTES_CTA_CTE D, DOC_TIPO DT,
     CNTAS_COBRAR CC , CNTAS_COBRAR_DET CD
where D.TIPO_DOC in (select dr.tipo_doc
                     from   doc_grupo_relacion dr
                     where  dr.grupo = (select doc_ntvnt from finparam where reckey='1')) AND
      D.TIPO_DOC = DT.TIPO_DOC  AND
      D.COD_RELACION = CC.COD_RELACION AND
      D.TIPO_DOC = CC.TIPO_DOC AND
      D.NRO_DOC  = CC.NRO_DOC
      AND
      CC.TIPO_DOC = CD.TIPO_DOC AND
      CC.NRO_DOC = CD.NRO_DOC;

prompt
prompt Creating view VW_FIN_PAGAR_DIRECTO
prompt ==================================
prompt
create or replace force view cantabria.vw_fin_pagar_directo as
select cp.cod_relacion , p.nom_proveedor, cp.tipo_doc    ,cp.nro_doc   ,
       cp.fecha_emision, cp.cod_moneda   ,cp.tasa_cambio ,cp.saldo_sol ,
       cp.saldo_dol    ,cp.flag_provisionado
  from cntas_pagar cp,proveedor p
 where  cp.cod_relacion = p.proveedor and
        cp.flag_provisionado in ('D','N');

prompt
prompt Creating view VW_FIN_PERSON_AUTORIZ_SOL_GIRO
prompt ============================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_PERSON_AUTORIZ_SOL_GIRO AS
SELECT p.proveedor                    AS CODIGO ,
       p.nom_proveedor                as NOMBRE ,
       ma.NRO_MAXIMO_SOL_PEND	        AS SOLICITUDES_MAX  ,
       Nvl(ma.NRO_SOLICITUDES_PEND,0) AS SOLICITUDES_GEN
FROM   proveedor 	           p,
       MAESTRO_PARAM_AUTORIZ ma
WHERE ma.COD_RELACION = p.proveedor
  AND Nvl(ma.NRO_SOLICITUDES_PEND,0) < ma.NRO_MAXIMO_SOL_PEND
  and p.flag_estado <> '0';

prompt
prompt Creating view VW_FIN_PROVEEDOR_AND_PERS_AUT
prompt ===========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_PROVEEDOR_AND_PERS_AUT AS
SELECT PROVEEDOR.PROVEEDOR     AS CODIGO ,
       PROVEEDOR.NOM_PROVEEDOR AS NOMBRES
FROM PROVEEDOR
UNION
SELECT MAESTRO_PARAM_AUTORIZ.COD_RELACION ,
       MAESTRO.NOMBRE1||' '||MAESTRO.APEL_PATERNO||' '||MAESTRO.APEL_MATERNO
FROM   MAESTRO,
       MAESTRO_PARAM_AUTORIZ
WHERE (MAESTRO_PARAM_AUTORIZ.COD_RELACION = MAESTRO.COD_TRABAJADOR );

prompt
prompt Creating view VW_FIN_PROV_X_CAMPO
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_PROV_X_CAMPO AS
SELECT P.PROVEEDOR     ,
       P.NOM_PROVEEDOR ,
       P.EMAIL			   ,
       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc           ,
       C.COD_CAMPO     ,
       C.DESC_CAMPO
FROM PROVEEDOR P,CAMPO C
WHERE (P.PROVEEDOR = C.PROVEEDOR (+)) AND
      (P.FLAG_ESTADO = '1'          )
ORDER BY P.RUC;

prompt
prompt Creating view VW_FIN_PROV_X_CTAS_X_PAGAR
prompt ========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_PROV_X_CTAS_X_PAGAR AS
SELECT DISTINCT(DP.COD_RELACION) AS CODIGO ,
       PV.NOM_PROVEEDOR          AS NOMBRES
  FROM DOC_PENDIENTES_CTA_CTE DP,
       PROVEEDOR              PV
 WHERE (DP.COD_RELACION = PV.PROVEEDOR )
 UNION
SELECT DISTINCT(SG.COD_RELACION) ,
       RTRIM(LTRIM(PV.NOM_PROVEEDOR))
  FROM SOLICITUD_GIRO SG  ,
       PROVEEDOR      PV
 WHERE (SG.COD_RELACION = PV.PROVEEDOR);

prompt
prompt Creating view VW_FIN_REG_TESORERIA
prompt ==================================
prompt
create or replace force view cantabria.vw_fin_reg_tesoreria as
select u.cod_usr,
         u.nombre as nom_usuario,
         cb.cod_ctabco,
         b.nom_banco,
         cb.cod_moneda,
         trunc(cb.fec_registro) as fec_registro,
         cb.ano,
         case
            when cb.mes = 1 then '01.Ene'
            when cb.mes = 2 then '02.Feb'
            when cb.mes = 3 then '03.Mar'
            when cb.mes = 4 then '04.Abr'
            when cb.mes = 5 then '05.May'
            when cb.mes = 6 then '06.Jun'
            when cb.mes = 7 then '07.Jul'
            when cb.mes = 8 then '08.Ago'
            when cb.mes = 9 then '09.Set'
            when cb.mes = 10 then '10.Oct'
            when cb.mes = 11 then '11.Nov'
            when cb.mes = 12 then '12.Dic'
         end as mes,
         trunc(cb.fecha_emision) as fec_emision,
         count(*) as nro_registros
    from caja_bancos cb,
         usuario     u,
         banco_cnta  bc,
         banco       b
  where cb.cod_usr = u.cod_usr
    and cb.cod_ctabco = bc.cod_ctabco
    and b.cod_banco   = bc.cod_banco
  group by u.cod_usr,
         u.nombre,
         cb.cod_ctabco,
         b.nom_banco,
         cb.cod_moneda,
         trunc(cb.fec_registro),
         cb.ano, cb.mes,
         trunc(cb.fecha_emision);

prompt
prompt Creating view VW_FIN_RPT_ACNTBLE_LIBRO
prompt ======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_RPT_ACNTBLE_LIBRO AS
SELECT DISTINCT CP.NRO_LIBRO, CL.DESC_LIBRO
FROM   CNTBL_PRE_ASIENTO CP, CNTBL_LIBRO CL
WHERE  CP.NRO_LIBRO = CL.NRO_LIBRO;

prompt
prompt Creating view VW_FIN_RPT_CNTAS_X_COBRAR
prompt =======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_RPT_CNTAS_X_COBRAR AS
SELECT DISTINCT(CC.COD_RELACION), P.NOM_PROVEEDOR
FROM   CNTAS_COBRAR CC, PROVEEDOR P
WHERE  CC.COD_RELACION = P.PROVEEDOR;

prompt
prompt Creating view VW_FIN_RPT_CNTAS_X_PAGAR
prompt ======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_RPT_CNTAS_X_PAGAR AS
SELECT DISTINCT(CP.COD_RELACION), P.NOM_PROVEEDOR
FROM   CNTAS_PAGAR CP, PROVEEDOR P
WHERE  CP.COD_RELACION = P.PROVEEDOR;

prompt
prompt Creating view VW_FIN_RPT_SLDO_CTA_CTE_PAR
prompt =========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FIN_RPT_SLDO_CTA_CTE_PAR AS
SELECT  DISTINCT DP.COD_RELACION,
        P.NOM_PROVEEDOR,
        DP.TIPO_DOC    ,
        DT.DESC_TIPO_DOC
FROM    DOC_PENDIENTES_CTA_CTE DP,
        PROVEEDOR P,
        DOC_TIPO DT
WHERE   DP.COD_RELACION = P.PROVEEDOR AND
        DP.TIPO_DOC     = DT.TIPO_DOC;

prompt
prompt Creating view VW_FIN_RUBRO_SCATEG
prompt =================================
prompt
create or replace force view cantabria.vw_fin_rubro_scateg as
select fr.rubro ,fr.descripcion ,ast.cod_sub_cat ,ast.desc_sub_cat ,art.cod_art
  from articulo art ,articulo_sub_categ ast ,factura_rubro fr
 where art.sub_cat_art   = ast.cod_sub_cat and
       ast.factura_rubro = fr.rubro;

prompt
prompt Creating view VW_FIN_TESORERIA
prompt ==============================
prompt
create or replace force view cantabria.vw_fin_tesoreria as
select  to_number(to_char(cb.fecha_emision, 'yyyy')) as ano,
           to_number(to_char(cb.fecha_emision, 'mm')) as mes,
           to_number(to_char(cb.fecha_emision, 'yyyymm')) as periodo,
           cb.fecha_emision,
           cbd.cod_moneda,
           cb.tasa_cambio,
           cbd.importe,
           cb.obs,
           nvl(cbd.impt_ret_igv, 0) as impt_ret_igv,
           (
             cbd.importe -
             case
                when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then
                   nvl(cbd.impt_ret_igv, 0)
                else
                   nvl(cbd.impt_ret_igv, 0) / cb.tasa_cambio
             end
           ) * decode(gc.factor , 'E', -1, 1) * cbd.factor as imp_neto,
           cbd.factor,
           gc.factor as flag_ingr_egr,
           case
             when gc.factor = 'I' then
               (case
                 when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then
                   cbd.importe
                 else
                   cbd.importe * cb.tasa_cambio
               end - nvl(cbd.impt_ret_igv, 0) ) * decode(gc.factor , 'E', -1, 1) * cbd.factor
             else
               0
           end as ingresos,
           case
             when gc.factor = 'E' then
               (case
                 when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then
                   cbd.importe
                 else
                   cbd.importe * cb.tasa_cambio
               end - nvl(cbd.impt_ret_igv, 0) ) * decode(gc.factor , 'E', -1, 1) * cbd.factor
             else
               0
           end as egresos
     from caja_bancos           cb,
          caja_bancos_det       cbd,
          codigo_flujo_caja     fc,
          grupo_cod_flujo_caja   gc,
          fin_actividad_flujo    af,
          banco_cnta            bc
    where cb.origen            = cbd.origen
      and cb.nro_registro      = cbd.nro_registro
      and cb.cod_ctabco         = bc.cod_ctabco
      and cbd.cod_flujo_caja    = fc.cod_flujo_caja
      and fc.grp_flujo_caja     = gc.grp_flujo_caja
      and gc.cod_actividad     = af.cod_actividad
      and cb.flag_estado       <> '0'
      and bc.flag_flujo_caja   = '1'
--      and to_char(cb.fecha_emision, 'yyyymm') < '201702'
--      and cb.origen          like '%%'
order by 1, 2, flag_ingr_egr desc
;

prompt
prompt Creating view VW_FL_ANHO_PROYEC
prompt ===============================
prompt
create or replace force view cantabria.vw_fl_anho_proyec as
select distinct fppv.ano as anho
         from fl_pesca_proy_viariacion fppv;

prompt
prompt Creating view VW_FL_BITACORA
prompt ============================
prompt
create or replace force view cantabria.vw_fl_bitacora as
select b.registro_bitacora as registro_bitacora,
       b.nave as nave,
       nvl(n.nomb_nave,'----------') as nomb_nave,
       b.fecha_hora_reg as fecha_hora_reg,
       substr(nvl(b.latitud,'000000'),1,2)  || '° ' || substr(nvl(b.latitud,'0000000'),3,2)  ||''' '|| substr(nvl(b.latitud,'0000000'),4,2)  || '''''' as latitud,
       substr(nvl(b.longitud,'000000'),1,2) || '° ' || substr(nvl(b.longitud,'0000000'),3,2) ||''' '|| substr(nvl(b.longitud,'0000000'),4,2) || '''''' as longitud,
       nvl(b.ubicacion,'SIN REGISTRO EN BITACORA') as ubicacion,
       NVL(b.observaciones,'NO HAY OBSERVACIONES REGISTRADAS') as observaciones,
       NVL(bc.nro_cala,0) as nro_cala,
       NVL(bc.captura_estimada,0) as captura_estimada,
       NVL(bc.unidad_peso,'') as unidad_peso,
       NVL(e.descr_especie,'SIN CALA') as descr_especie,
       NVL(bc.temperatura_agua,0) as temperatura_agua,
       NVL(bc.temperatura_und,'') as temperatura_und

 from fl_bitacora b,
      tg_naves n,
      fl_bitacora_calas bc,
      tg_especies e
where b.nave              = n.nave
  and b.registro_bitacora = bc.registro_bitacora (+)
  and bc.especie          = e.especie            (+)
 order by n.nomb_nave, b.fecha_hora_reg, b.registro_bitacora
;

prompt
prompt Creating view VW_FL_BITACORA_MES
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_BITACORA_MES AS
SELECT distinct nave, to_char(fecha_hora_reg, 'yyyy') as ano, to_char(fecha_hora_reg,'mm') as mes, decode(to_char(fecha_hora_reg,'mm'), '01', 'ENERO', '02', 'FEBRERO', '03', 'MARZO', '04', 'ABRIL', '05', 'MAYO', '06', 'JUNIO', '07', 'JULIO','08', 'AGOSTO', '09', 'SEPTIEMBRE', '10', 'OCTUBRE', '11', 'NOVIEMBRE', '12', 'DICIEMBRE') as nombre
    FROM "FL_BITACORA";

prompt
prompt Creating view VW_FL_BITACORA_NAVES
prompt ==================================
prompt
create or replace force view cantabria.vw_fl_bitacora_naves as
select distinct substr(trim(n.nomb_nave)||'                    ',1,20) as nomb_nave , substr(trim(b.nave)||'            ',1,12) as nave
              from fl_bitacora b
              inner join tg_naves n on n.nave = b.nave;

prompt
prompt Creating view VW_FL_CAPTURA_EMRPESAS
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_CAPTURA_EMRPESAS AS
SELECT E.NOMBRE_EMPRESA, TO_CHAR(CE.FECHA,'YYYY') AS ANO, NVL(SUM(CE.CANTIDAD_CAPTURADA),0) AS CAPTURA
       FROM  FL_CAPTURA_EMPRESAS CE
             INNER JOIN FL_EMPRESAS E ON CE.EMPRESA = E.EMPRESA
             GROUP BY E.NOMBRE_EMPRESA, TO_CHAR(CE.FECHA,'YYYY');

prompt
prompt Creating view VW_FL_CAPTURA_NAVE_DIA
prompt ====================================
prompt
create or replace force view cantabria.vw_fl_captura_nave_dia as
select n.nomb_nave as nave,
           to_char(v.hora_inicio_descarga,'mm')  as mes,
           to_char(v.hora_inicio_descarga,'yyyy') as ano,
           nvl(sum(v.cantidad_real) - sum(v.cantidad_castigada),0) as cantidad,
           '1. Vendido' as  tipo
      from fl_venta          v,
           fl_parte_de_pesca pp,
           tg_naves          n
     where v.parte_pesca = pp.parte_pesca
       and pp.nave_real = n.nave
  group by n.nomb_nave, to_char(v.hora_inicio_descarga,'mm'), to_char(v.hora_inicio_descarga,'yyyy')
union all
    select n.nomb_nave as nave,
           to_char(v.hora_inicio_descarga,'mm')  as mes,
           to_char(v.hora_inicio_descarga,'yyyy') as ano,
           nvl(sum(v.cantidad_castigada),0) as cantidad,
           '2. Castigado' as tipo
      from fl_venta          v,
           fl_parte_de_pesca pp,
           tg_naves          n
     where v.parte_pesca = pp.parte_pesca
       and pp.nave_real = n.nave
  group by n.nomb_nave, to_char(v.hora_inicio_descarga,'mm'), to_char(v.hora_inicio_descarga,'yyyy');

prompt
prompt Creating view VW_FL_CAPTURA_TOTAL
prompt =================================
prompt
create or replace force view cantabria.vw_fl_captura_total as
select n.nomb_nave as nave,
         to_char(v.hora_inicio_descarga,'mm/yyyy') as periodo,
         to_number(to_char(v.hora_inicio_descarga,'mm')) as mes,
         to_number(to_char(v.hora_inicio_descarga,'yyyy')) as ano,
         nvl(sum(v.cantidad_real - v.cantidad_castigada),0) as TOTAL
    from fl_venta          v,
         fl_parte_de_pesca pp,
         tg_naves          n
   where v.parte_pesca = pp.parte_pesca
     and pp.nave_real = n.nave
group by n.nomb_nave,
         to_char(v.hora_inicio_descarga,'mm/yyyy'),
         to_number(to_char(v.hora_inicio_descarga,'mm')),
         to_number(to_char(v.hora_inicio_descarga,'yyyy'));

prompt
prompt Creating view VW_PR_TRABAJADOR
prompt ==============================
prompt
create or replace force view cantabria.vw_pr_trabajador as
select APEL_PATERNO || ' ' || APEL_MATERNO || ', ' || NOMBRE1 || ' ' ||
       NOMBRE2 AS NOM_TRABAJADOR,
       M.COD_TRABAJADOR,
       M.COD_TRAB_ANTGUO,
       M.FOTO_TRABAJ,
       M.APEL_PATERNO,
       M.APEL_MATERNO,
       M.NOMBRE1,
       M.NOMBRE2,
       M.FLAG_ESTADO_CIVIL,
       M.FLAG_CAL_PLNLLA,
       M.FLAG_SINDICATO,
       M.FLAG_ESTADO,
       M.FEC_INGRESO,
       M.FEC_NACIMIENTO,
       M.FEC_CESE,
       M.COD_MOTIV_CESE,
       M.FLAG_SEXO,
       M.DIRECCION,
       M.TEL_COD_CIUDAD,
       M.TELEFONO1,
       M.TELEFONO2,
       M.DNI,
       M.LIB_MILITAR,
       M.RUC,
       M.EMAIL,
       M.COD_TIPO_BREV,
       M.NRO_BREVETE,
       M.CARNET_TRABAJ,
       M.NRO_IPSS,
       M.COD_GRADO_INST,
       M.COD_PROFESION,
       M.COD_CARGO,
       M.SITUA_TRABAJ,
       M.COD_AFP,
       M.NRO_AFP_TRABAJ,
       M.FEC_INI_AFIL_AFP,
       M.FEC_FIN_AFIL_AFP,
       M.PORC_JUDICIAL,
       M.BONIF_FIJA_30_25,
       M.FLAG_QUINCENA,
       M.TIPO_TRABAJADOR,
       M.NRO_CNTA_AHORRO,
       M.NRO_CNTA_CTS,
       M.COD_MONEDA,
       M.COD_EMPRESA,
       M.COD_LABOR,
       M.CENCOS,
       M.FLAG_ALGUN_FAMIL,
       M.COD_USR,
       M.COD_BANCO,
       M.COD_BANCO_CTS,
       M.COD_TIPO_SANGRE,
       M.COD_CATEG_SAL,
       M.COD_SECCION, s.desc_seccion,
       M.COD_AREA, a.desc_area,
       M.COD_PAIS,
       M.COD_DPTO,
       M.COD_PROV,
       M.COD_DISTR,
       M.COD_CIUDAD,
       M.COD_VIVIENDA,
       M.TURNO,
       M.FLAG_MARCA_RELOJ,
       M.FLAG_ESPOSA,
       M.FLAG_CONVENIO,
       M.FLAG_JUICIO,
       M.COD_ORIGEN,
       M.FLAG_REPLICACION,
       M.CONTRA,
       M.BANDA,
       M.CONDES,
       M.MONEDA_CTS,
       M.TASA_HR_CALC_CST,
       M.TIPO_CNTA_HABERES,
       M.TIPO_CNTA_CTS,
       M.PORC_JUD_UTIL,
       M.CENTRO_BENEF,
       M.CALIF_TIPO,
       M.FLAG_CAT_TRAB,
       M.COD_TIPO_PENSION,
       M.FLAG_REG_LABORAL,
       M.COD_SIT_EPS,
       M.COD_TIP_TRAB,
       M.COD_EPS,
       M.COD_REG_PENSION,
       M.COD_TIPO_CONTRATO,
       M.COD_ESTADO_CIVIL,
       M.FLAG_ESSALUD_VIDA,
       M.FLAG_SCTR_SALUD,
       M.FLAG_DISCAPACIDAD,
       M.FLAG_DOMICILIADO,
       M.COD_VIA,
       M.NOMBRE_VIA,
       M.NUMERO_VIA,
       M.INTERIOR,
       M.COD_ZONA,
       M.NOMBRE_ZONA,
       M.REFERENCIA,
       M.COD_PERIOCIDAD_REM,
       M.FLAG_TIPO_REMUN_RTPS,
       M.COD_MOD_PAGO_RTPS,
       M.TIPO_DOC_IDENT_RTPS,
       M.NRO_DOC_IDENT_RTPS,
       M.COD_OCUPACION_RTPS,
       M.FLAG_SCTR_PENSION,
       M.TURNO_ASIST,
       M.FEC_INSCRIP_REG,
       M.FLAG_PENSIONISTA,
       M.FLAG_SUJETO_CONTROL_,
       M.COD_PAIS_NAC,
       M.COD_DPTO_NAC,
       M.COD_PROV_NAC,
       M.COD_DIST_NAC,
       M.FLAG_JORNADA_ALTERNA,
       M.FLAG_JORNADA_MAXIMA,
       M.FLAG_HORARIO_NOCTURNO,
       M.FLAG_OTROS_QUINTA_CATEG,
       M.FLAG_AFILIADO_EPS,
       M.FLAG_QUINTA_EXONERADO,
       M.FLAG_TIPO_RELACION,
       M.FLAG_SEGURO_MEDICO,
       M.FLAG_MADRE_RESP_FAMILIAR,
       M.FLAG_FORMACION_PERSONAL,
       M.REGIMEN_LABORAL,
       M.COD_PENSION_RTPS,
       M.FOTO_BLOB
  from MAESTRO M,
       area    a,
       seccion s
 where a.cod_area    = s.cod_area
   and m.cod_area    = s.cod_area
   and m.cod_seccion = s.cod_seccion;

prompt
prompt Creating view VW_FL_CAPTURA_TRIPULANTE_NAVE
prompt ===========================================
prompt
create or replace force view cantabria.vw_fl_captura_tripulante_nave as
select m.COD_TRABAJADOR,
       m.NOM_TRABAJADOR,
       m.TIPO_DOC_IDENT_RTPS,
       m.NRO_DOC_IDENT_RTPS,
       fa.cargo_tripulante || '-' || fc.descr_cargo as cargo_tripulante,
       vw."NAVE",vw."NOMB_NAVE",vw."ESPECIE",vw."DESCR_ESPECIE",vw."FECHA_PROCESO",vw."FLAG_DESTINO",vw."TASA_PARTICIPACION",vw."TOTAL_PESCA",
       to_char(vw.fecha_proceso, 'yyyy') as año,
       to_char(vw.fecha_proceso, 'mm') as mes,
       (select trim(to_char(s.ano, '0000')) || '-' || trim(to_char(s.semana, '00'))
           from semanas s
          where trunc(vw.fecha_proceso) between s.fecha_inicio and s.fecha_fin
            and rownum = 1) as semana_pesca
  from (select tn.nave,
               tn.nomb_nave,
               b.especie,
               te.descr_especie,
               case
                 when b.hora_inicio_descarga >= to_date(trim(to_char(trunc(b.hora_inicio_descarga), 'dd/mm/yyyy')) || ' 08:00', 'dd/mm/yyyy hh:mi') then
                   trunc(b.hora_inicio_descarga)
                 else
                   trunc(b.hora_inicio_descarga) - 1
               end as fecha_proceso,
               case
                   when b.flag_destino = 'H' then
                     'HARINA'
                   when b.flag_destino = 'C' then
                     'CONSERVAS'
                   else
                     'NO DEFINIDO'
               end as flag_destino,
               case
                   when b.flag_destino = 'H' then
                     tn.porc_partic
                   when b.flag_destino = 'C' then
                     tn.porc_partic_cons
               end as tasa_participacion,
               sum(NVL(b.cantidad_real,0) - nvl(b.cantidad_castigada,0)) as total_pesca

          from fl_parte_de_pesca a,
               fl_venta          b,
               tg_especies       te,
               tg_naves          tn
          where a.parte_pesca             = b.parte_pesca
            and a.nave_real               = tn.nave
            and b.especie                 = te.especie
            and a.flag_estado   <> '0'
          group by tn.nave,
                   tn.nomb_nave,
                   b.especie,
                   case
                     when b.hora_inicio_descarga >= to_date(trim(to_char(trunc(b.hora_inicio_descarga), 'dd/mm/yyyy')) || ' 08:00', 'dd/mm/yyyy hh:mi') then
                       trunc(b.hora_inicio_descarga)
                     else
                       trunc(b.hora_inicio_descarga) - 1
                   end,
                   b.flag_destino,
                   te.descr_especie,
                   case
                     when b.flag_destino = 'H' then
                       tn.porc_partic
                     when b.flag_destino = 'C' then
                       tn.porc_partic_cons
                   end) vw,
       fl_asistencia    fa,
       vw_pr_trabajador m,
       fl_cargo_tripulantes fc
where vw.fecha_proceso = trunc(fa.fecha)
  and vw.nave          = fa.nave
  and fa.tripulante    = m.COD_TRABAJADOR
  and fa.cargo_tripulante   = fc.cargo_tripulante (+)
  --and trunc(b.hora_inicio_descarga) between trunc(:ad_fecha1) and trunc(:ad_fecha2)
  --and fa.tripulante               like :as_tripulante
order by vw.fecha_proceso,
         vw.nave
;

prompt
prompt Creating view VW_FL_PARPESCA_CALAS
prompt ==================================
prompt
create or replace force view cantabria.vw_fl_parpesca_calas as
select pp.parte_pesca, pp.nave_real as nave, n.nomb_nave as nombre, pp.fecha_hora_zarpe, b.registro_bitacora, avg(bc.tiempo_estimado) as tiempo, sum(bc.nro_cala) as calas, sum (v.cantidad_real-v.cantidad_castigada) as venta
       from fl_parte_de_pesca pp
            inner join fl_venta v on v.parte_pesca = pp.parte_pesca
            inner join tg_naves n on pp.nave_real = n.nave
            inner join fl_bitacora b on b.parte_pesca = pp.parte_pesca
            inner join fl_bitacora_calas bc on b.registro_bitacora = bc.registro_bitacora
       group by pp.parte_pesca, pp.nave_real, n.nomb_nave, pp.fecha_hora_zarpe, b.registro_bitacora;

prompt
prompt Creating view VW_FL_EFICIENCIA_CALA
prompt ===================================
prompt
create or replace force view cantabria.vw_fl_eficiencia_cala as
select vpc.nave, vpc.nombre, to_char(vpc.fecha_hora_zarpe,'yyyy') as ano, to_char(vpc.fecha_hora_zarpe,'mm') as mes, sum(vpc.venta) / sum(vpc.calas) as ton_cala, avg(vpc.tiempo) as tiempo
       from vw_fl_parpesca_calas vpc
       group by vpc.nave, vpc.nombre, to_char(vpc.fecha_hora_zarpe,'yyyy'), to_char(vpc.fecha_hora_zarpe,'mm');

prompt
prompt Creating view VW_FL_INIDCADOR_ANO
prompt =================================
prompt
create or replace force view cantabria.vw_fl_inidcador_ano as
select distinct poi.cod_art, to_char(trunc(po.fecha), 'yyyy') as ano
   from fl_ot_nave fon
      inner join tg_naves tn on fon.nave = tn.nave
      inner join orden_trabajo ot on ot.nro_orden = fon.nro_orden
      inner join pd_ot_det pod on ot.nro_orden = pod.nro_orden
      inner join pd_ot po on pod.nro_parte = po.nro_parte
      inner join pd_ot_insumos poi on pod.nro_parte = poi.nro_parte and pod.nro_item = poi.nro_item
   where tn.flag_tipo_flota = 'P';

prompt
prompt Creating view VW_FL_INIDCADOR_ARTICULOS
prompt =======================================
prompt
create or replace force view cantabria.vw_fl_inidcador_articulos as
select distinct rpad(trim(a.nom_articulo),40,' ')as nom_articulo, rpad(trim(poi.cod_art),12,' ') as cod_art
   from fl_ot_nave fon
      inner join tg_naves tn on fon.nave = tn.nave
      inner join orden_trabajo ot on ot.nro_orden = fon.nro_orden
      inner join pd_ot_det pod on ot.nro_orden = pod.nro_orden
      inner join pd_ot po on pod.nro_parte = po.nro_parte
      inner join pd_ot_insumos poi on pod.nro_parte = poi.nro_parte and pod.nro_item = poi.nro_item
      inner join articulo a on a.cod_art = poi.cod_art
   where tn.flag_tipo_flota = 'P';

prompt
prompt Creating view VW_FL_INIDCADOR_FECHA
prompt ===================================
prompt
create or replace force view cantabria.vw_fl_inidcador_fecha as
select distinct poi.cod_art as cod_art, trunc(po.fecha)as fecha, to_char(trunc(po.fecha), 'dd/mm/yyyy') as fecha_t
   from fl_ot_nave fon
      inner join tg_naves tn on fon.nave = tn.nave
      inner join orden_trabajo ot on ot.nro_orden = fon.nro_orden
      inner join pd_ot_det pod on ot.nro_orden = pod.nro_orden
      inner join pd_ot po on pod.nro_parte = po.nro_parte
      inner join pd_ot_insumos poi on pod.nro_parte = poi.nro_parte and pod.nro_item = poi.nro_item
   where tn.flag_tipo_flota = 'P';

prompt
prompt Creating view VW_FL_NAVE_PROY_PESCA
prompt ===================================
prompt
create or replace force view cantabria.vw_fl_nave_proy_pesca as
select distinct fppv.nave, tn.nomb_nave
  from fl_pesca_proy fppv,
       tg_naves      tn
 where tn.nave = fppv.nave
   and fppv.ano >= (select to_number(to_char(sysdate,'yyyy')) from dual)
   and fppv.mes >= (select to_number(to_char(sysdate,'mm')) from dual);

prompt
prompt Creating view VW_FL_NAVES_ARRIBO
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_NAVES_ARRIBO AS
SELECT "NAVE","PROVEEDOR","CENCOS","ORIGEN","IMAGEN","FLAG_CONDICION_NAVE","FLAG_TIPO_FLOTA","FLAG_TIPO_NAVE","FLAG_TIPO_CASCO","FLAG_FORMA_POPA","FLAG_FORMA_PROA","CODIGO_ACTIVO","NOMB_NAVE","MATRICULA","PORC_PARTIC","REGISTRO_CAJA_BENEFICIO","FECHA_CONSTRUCCION","ESLORA","MANGA","PUNTAL","CAPAC_BODEGA","CAPAC_PERMITIDA","TONELAJE_BRUTO","TONELAJE_NETO","NRO_TANQ_AGUA","CAP_TOTAL_TANQ_AGUA","NRO_TANQ_COMB","CAPAC_TOTAL_TANQ_COMB","RESOLUCION_MINIST","FLAG_SERVICIO_PRESTADO","FLAG_ESTADO"
FROM TG_NAVES
WHERE FLAG_TIPO_FLOTA = 'P'
	and nave in (select distinct nave_real from fl_parte_de_pesca flpp where flpp.fecha_hora_arribo is null)
union all
SELECT "NAVE","PROVEEDOR","CENCOS","ORIGEN","IMAGEN","FLAG_CONDICION_NAVE","FLAG_TIPO_FLOTA","FLAG_TIPO_NAVE","FLAG_TIPO_CASCO","FLAG_FORMA_POPA","FLAG_FORMA_PROA","CODIGO_ACTIVO","NOMB_NAVE","MATRICULA","PORC_PARTIC","REGISTRO_CAJA_BENEFICIO","FECHA_CONSTRUCCION","ESLORA","MANGA","PUNTAL","CAPAC_BODEGA","CAPAC_PERMITIDA","TONELAJE_BRUTO","TONELAJE_NETO","NRO_TANQ_AGUA","CAP_TOTAL_TANQ_AGUA","NRO_TANQ_COMB","CAPAC_TOTAL_TANQ_COMB","RESOLUCION_MINIST","FLAG_SERVICIO_PRESTADO","FLAG_ESTADO"
FROM TG_NAVES
WHERE FLAG_TIPO_FLOTA = 'T';

prompt
prompt Creating view VW_FL_NAVES_ZARPE
prompt ===============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_NAVES_ZARPE AS
SELECT "NAVE","PROVEEDOR","CENCOS","ORIGEN","IMAGEN","FLAG_CONDICION_NAVE","FLAG_TIPO_FLOTA","FLAG_TIPO_NAVE","FLAG_TIPO_CASCO","FLAG_FORMA_POPA","FLAG_FORMA_PROA","CODIGO_ACTIVO","NOMB_NAVE","MATRICULA","PORC_PARTIC","REGISTRO_CAJA_BENEFICIO","FECHA_CONSTRUCCION","ESLORA","MANGA","PUNTAL","CAPAC_BODEGA","CAPAC_PERMITIDA","TONELAJE_BRUTO","TONELAJE_NETO","NRO_TANQ_AGUA","CAP_TOTAL_TANQ_AGUA","NRO_TANQ_COMB","CAPAC_TOTAL_TANQ_COMB","RESOLUCION_MINIST","FLAG_SERVICIO_PRESTADO","FLAG_ESTADO","FLAG_REPLICACION","CENCOS_ADM","CODIGO_PRODUCE","CENTRO_BENEF","ALMACEN_MAT","ALMACEN_MP","PORC_PARTIC_CONS","FLAG_SUPNEP"
FROM TG_NAVES
WHERE FLAG_TIPO_FLOTA = 'P'
	and nave not in (select distinct nave_real from fl_parte_de_pesca flpp where flpp.fecha_hora_arribo is null);

prompt
prompt Creating view VW_FL_NOMB_CLIENTE
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_NOMB_CLIENTE AS
SELECT C.CLIENTE, P.NOM_PROVEEDOR, P.RUC, P.PROVEEDOR
FROM FL_CLIENTES C, PROVEEDOR P
WHERE P.PROVEEDOR = C.PROVEEDOR;

prompt
prompt Creating view VW_FL_OT_NAVE
prompt ===========================
prompt
create or replace force view cantabria.vw_fl_ot_nave as
select ot."COD_ORIGEN",ot."NRO_ORDEN",ot."FLAG_ESTADO",ot."FEC_SOLICITUD",ot."FEC_ESTIMADA",ot."FEC_INICIO",ot."CENCOS_RSP",ot."CENCOS_SLC",ot."COD_USR",ot."NRO_SOLICITUD",ot."CLIENTE",ot."DESCRIPCION",ot."COD_MAQUINA",ot."OT_ADM",ot."OT_TIPO",ot."FEC_REGISTRO",ot."NRO_PROCESO",ot."PROG_MNT",ot."MNT_UND_ACT_PROY",ot."MNT_UND_ACT_REAL",ot."FLAG_REPLICACION",ot."FLAG_PROGRAMADO",ot."RESPONSABLE",ot."FECHA_FIN_ESTIMADA",ot."FLAG_ESTRUCTURA",ot."FECHA_ULT_PD",ot."TITULO",ot."COSTO_ESTIMADO",ot."COSTO_EJECUTADO",ot."FECHA_PROX_MTTO",ot."FLAG_COSTO_TIPO",ot."COD_ACTIVO",ot."CENTRO_BENEF",ot."LOTE_CAMPO",ot."VARIEDAD", tn.nave, tn.nomb_nave
    from 	orden_trabajo ot,
    			fl_ot_nave flon,
          tg_naves tn
	where flon.nro_orden = ot.nro_orden
  	and tn.nave = flon.nave;

prompt
prompt Creating view VW_FL_PARTE_PESCA
prompt ===============================
prompt
create or replace force view cantabria.vw_fl_parte_pesca as
select 	flpp.parte_pesca,
				flpp.origen,
        tn.nave,
        tn.nomb_nave,
  			flpp.flag_zarpe_aprobado, flpp.flag_arribo_aprobado,
    		trunc(flpp.fecha_hora_zarpe) as fecha_zarpe,
    		trunc(flpp.fecha_hora_arribo) as fecha_arribo,
    		tn.proveedor,
    		p.nom_proveedor
  from 	fl_parte_de_pesca flpp,
  			tg_naves tn,
        proveedor p
  where tn.nave = flpp.nave_real
  	and p.proveedor = tn.proveedor
    and ( flpp.flag_zarpe_aprobado = '1' or flpp.flag_arribo_aprobado = '1')
    and flpp.parte_pesca not in (select distinct parte_pesca from ap_guia_recepcion
    															where parte_pesca is not null);

prompt
prompt Creating view VW_FL_PESCA_PROY
prompt ==============================
prompt
create or replace force view cantabria.vw_fl_pesca_proy as
select pp.ano,
       pp.mes,
       '1. Proyectada' as tipo,
       nvl(sum(pp.pesca_estim),0) as cantidad
from fl_pesca_proy pp
where pp.flag_aprobado = 1
group by pp.ano, pp.mes;

prompt
prompt Creating view VW_FL_PESCA_REAL
prompt ==============================
prompt
create or replace force view cantabria.vw_fl_pesca_real as
select pp.ano, pp.mes, '3. Real' as tipo, nvl(sum(pp.pesca_real),0) as cantidad
       from fl_pesca_proy pp
       where pp.flag_aprobado = 1
       group by pp.ano, pp.mes;

prompt
prompt Creating view VW_FL_PESCA_VARIACION
prompt ===================================
prompt
create or replace force view cantabria.vw_fl_pesca_variacion as
select ppv.mes, ppv.ano, '2. Variado' as tipo,  sum(ppv.cantidad * decode(ppv.flag_tipo, 'P', 1, 'N', -1)) as cantidad
       from fl_pesca_proy_viariacion ppv
       group by ppv.mes, ppv.ano;

prompt
prompt Creating view VW_FL_PESCA_COMPARA_GRAF
prompt ======================================
prompt
create or replace force view cantabria.vw_fl_pesca_compara_graf as
select vpp.mes, vpp.ano, vpp.tipo, vpp.cantidad
       from vw_fl_pesca_proy vpp
union all
select vpv.mes, vpv.ano, vpv.tipo, vpv.cantidad + vpp.cantidad
       from vw_fl_pesca_variacion vpv
            inner join vw_fl_pesca_proy vpp on vpv.mes = vpp.mes and vpv.ano = vpp.ano
union all
select vpr.mes, vpr.ano, vpr.tipo, vpr.cantidad
       from vw_fl_pesca_real vpr;

prompt
prompt Creating view VW_FL_PESCA_PROY_VARIA
prompt ====================================
prompt
create or replace force view cantabria.vw_fl_pesca_proy_varia as
select fppv.nave,
       fppv.ano,
       fppv.mes as mesnum,
       decode( fppv.mes, 1, 'Enero', 2, 'Febrero', 3, 'Marzo',  4, 'Abril', 5, 'Mayo', 6, 'Junio',
                         7, 'Julio', 8, 'Agosto' , 9, 'Septiembre', 10, 'Octubre',11, 'Noviembre',
                         12,'Diciembre') as mes,
       fppv.item,
       fppv.cantidad * decode (fppv.flag_tipo , 'P' , 1, 'N', -1) as cantidad
from fl_pesca_proy_viariacion fppv
union all
select fpp.nave,
       fpp.ano,
       fpp.mes as mesnum,
       decode(fpp.mes, 1, 'Enero', 2, 'Febrero', 3, 'Marzo', 4 , 'Abril', 5, 'Mayo',6, 'Junio',
                       7, 'Julio', 8, 'Agosto',9, 'Septiembre',10, 'Octubre',11, 'Noviembre',
                       12,'Diciembre') as mes,
       0 as item,
       fpp.pesca_estim as cantidad
from fl_pesca_proy fpp;

prompt
prompt Creating view VW_FL_PESCA_PROY_GRAF
prompt ===================================
prompt
create or replace force view cantabria.vw_fl_pesca_proy_graf as
select vfpv.nave,
       vfpv.ano,
       to_char(vfpv.mesnum,'00') ||' - '|| trim(vfpv.mes) as mes,
       sum(vfpv.cantidad) as total
from vw_fl_pesca_proy_varia vfpv
group by vfpv.nave, vfpv.ano, to_char(vfpv.mesnum,'00') ||' - '|| trim(vfpv.mes);

prompt
prompt Creating view VW_FL_PESCA_PROY_PER
prompt ==================================
prompt
create or replace force view cantabria.vw_fl_pesca_proy_per as
select distinct fpp.nave, trim(to_char(fpp.mes,'00')) as permes , trim(to_char(fpp.ano,'0000')) as perano
         from fl_pesca_proy fpp;

prompt
prompt Creating view VW_FL_PLANT_CON_DETALLE
prompt =====================================
prompt
create or replace force view cantabria.vw_fl_plant_con_detalle as
select distinct a.cod_fl_plantilla,
           a.origen,
           a.unid,
           a.descripcion,
           a.fecha_registro,
           a.fecha_inicio_vigencia,
           a.fecha_fin_vigencia
    from fl_plant_presup       a,
         fl_plant_presup_det   b
    where a.cod_fl_plantilla = b.cod_fl_plantilla;

prompt
prompt Creating view VW_FL_POS_ARRIB
prompt =============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_POS_ARRIB AS
select FLPA.REG_POS_ARRIB, FLPA.NAVE, TN.NOMB_NAVE, TN.FLAG_TIPO_FLOTA,
       FLPA.FECHA_HORA_REG, FLPA.FECHA_HORA_ARRIBO
    from FL_POSIB_ARRIBOS FLPA,
         TG_NAVES TN
   WHERE TN.NAVE = FLPA.NAVE
     AND FLPA.REG_POS_ARRIB NOT IN (SELECT DISTINCT FLPP.REG_POS_ARRIB
                                      FROM FL_PARTE_DE_PESCA FLPP
                                      WHERE LENGTH(RTRIM(FLPP.REG_POS_ARRIB)) > 0);

prompt
prompt Creating view VW_FL_PROV_CLIENTE
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_PROV_CLIENTE AS
SELECT P.PROVEEDOR AS CODIGO, P.NOM_PROVEEDOR AS NOMBRE, P.RUC AS RUC
              FROM PROVEEDOR P
                   RIGHT OUTER JOIN FL_CLIENTES FLC ON P.PROVEEDOR = FLC.PROVEEDOR;

prompt
prompt Creating view VW_FL_PROV_CLIENTE_NON
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_FL_PROV_CLIENTE_NON AS
SELECT P.PROVEEDOR AS CODIGO, P.NOM_PROVEEDOR AS NOMBRE, P.RUC AS RUC
              FROM FL_CLIENTES C
                   RIGHT OUTER JOIN PROVEEDOR P ON P.PROVEEDOR = C.PROVEEDOR
              WHERE C.CLIENTE IS NULL;

prompt
prompt Creating view VW_FL_PROV_NAVE
prompt =============================
prompt
create or replace force view cantabria.vw_fl_prov_nave as
select 	p.proveedor, p.nom_proveedor, tn.nave, tn.nomb_nave, p.ruc,
				p.flag_estado, tn.flag_tipo_flota
	from 	proveedor p,
  			tg_naves tn
where tn.proveedor = p.proveedor;

prompt
prompt Creating view VW_FL_PROV_NON_RELATION
prompt =====================================
prompt
create or replace force view cantabria.vw_fl_prov_non_relation as
select p.proveedor, p.nom_proveedor, ep.empresa
              from fl_empresa_prove ep
                   right outer join proveedor p on p.proveedor = ep.proveedor;

prompt
prompt Creating view VW_FL_UBICA_NAVE
prompt ==============================
prompt
create or replace force view cantabria.vw_fl_ubica_nave as
select distinct(ubicacion) from fl_bitacora;

prompt
prompt Creating view VW_FL_UNIDAD
prompt ==========================
prompt
create or replace force view cantabria.vw_fl_unidad as
select u.und, u.desc_unidad, ug.descripcion, ug.und_grupo
	from 	unidad_grupo ug,
  			und_grp_relacion ugr,
				unidad u
where ug.und_grupo = ugr.und_grupo
	and u.und = ugr.und
order by u.desc_unidad;

prompt
prompt Creating view VW_GUIA_REC_PROV_PEND
prompt ===================================
prompt
create or replace force view cantabria.vw_guia_rec_prov_pend as
select distinct dd.proveedor, cr.nombre as descripcion
      from ap_pd_descarga_det dd
         left outer join ap_guia_recepcion_det grd on dd.nro_parte = grd.nro_parte and dd.item = grd.item_parte
         inner join codigo_relacion cr on dd.proveedor = cr.cod_relacion
         where grd.cod_guia_rec is null;

prompt
prompt Creating view VW_INGRESOS_DIRECTOS
prompt ==================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_INGRESOS_DIRECTOS AS
SELECT TIPO_DOC		    ,
       NRO_DOC
FROM  CNTAS_COBRAR
MINUS
SELECT CD.TIPO_DOC     ,
       CD.NRO_DOC
  FROM CAJA_BANCOS     CB,
       CAJA_BANCOS_DET CD
 WHERE ((CB.ORIGEN       = CD.ORIGEN       )  AND
        (CB.NRO_REGISTRO = CD.NRO_REGISTRO )) AND
        (CB.FLAG_TIPTRAN = 'I'             );

prompt
prompt Creating view VW_LAB_TEMPLAS_RESULTADO
prompt ======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_LAB_TEMPLAS_RESULTADO AS
SELECT r.cod_templa, r.fecha, r.tipo_analisis, ta.desc_analisis, r.cod_usr
   FROM resultados_templa r, templas t, tipo_analisis ta
  WHERE r.cod_templa=t.cod_templa and
        r.tipo_analisis=ta.tipo_analisis;

prompt
prompt Creating view VW_MAESTRO_CNTA_CTE
prompt =================================
prompt
create or replace force view cantabria.vw_maestro_cnta_cte as
select distinct
       m.cod_trabajador,
       m.NOM_TRABAJADOR,
       m.NRO_DOC_IDENT_RTPS,
       m.FLAG_ESTADO,
       m.COD_ORIGEN,
       m.TIPO_TRABAJADOR,
       m.TIPO_DOC_IDENT_RTPS,
       m.FEC_INGRESO,
       m.FEC_CESE
  from cnta_crrte cc,
       vw_pr_trabajador m
 where cc.cod_trabajador = m.COD_TRABAJADOR
union all
select distinct
       m.cod_trabajador,
       m.NOM_TRABAJADOR,
       m.NRO_DOC_IDENT_RTPS,
       m.FLAG_ESTADO,
       m.COD_ORIGEN,
       m.TIPO_TRABAJADOR,
       m.TIPO_DOC_IDENT_RTPS,
       m.FEC_INGRESO,
       m.FEC_CESE
  from (select m1.COD_TRABAJADOR
          from vw_pr_trabajador m1
        minus
        select distinct cc1.cod_trabajador
          from cnta_crrte cc1) s,
       vw_pr_trabajador m
 where s.cod_trabajador = m.COD_TRABAJADOR
   and m.FLAG_ESTADO     = '1';

prompt
prompt Creating view VW_MIGR_ART_SIN_CLASE
prompt ===================================
prompt
create or replace force view cantabria.vw_migr_art_sin_clase as
Select a.cod_art, a.nom_articulo, a.cod_clase, a.sub_cat_art
      from articulo a
      where a.cod_clase is null or
            a.sub_cat_art is null;

prompt
prompt Creating view VW_MT_CARACTERISTICA_TECNICA
prompt ==========================================
prompt
create or replace force view cantabria.vw_mt_caracteristica_tecnica as
select cod_caract, desc_caract, decode(flag_valor, 'N', 'NUMERICO', 'D', 'FECHA', 'C', 'TEXTO', 'NO DEFINIDO') as tipo_valor
      from caract_tec;

prompt
prompt Creating view VW_MT_LABOR_OT_ADM
prompt ================================
prompt
create or replace force view cantabria.vw_mt_labor_ot_adm as
select distinct l.cod_labor, l.desc_labor, pp.ot_adm
      from labor l
         inner join plant_prod_oper ppo on l.cod_labor = ppo.cod_labor
         inner join plant_prod pp on ppo.cod_plantilla = pp.cod_plantilla;

prompt
prompt Creating view VW_MT_MAQ_ESTRUC
prompt ==============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_MT_MAQ_ESTRUC AS
SELECT m.COD_MAQUINA,
         m.DESC_MAQ ,
			   m.icono,
         m.UND,
         m.flag_estado,
         count(*) as num_hijos
    FROM MAQUINA        m,
         maq_estructura me
   WHERE m.cod_maquina = me.maq_padre
     and m.FLAG_ESTADO = '1'
group by m.COD_MAQUINA, m.DESC_MAQ , m.icono, m.UND, m.flag_estado
having count(*) > 0
ORDER BY COD_MAQUINA;

prompt
prompt Creating view VW_MT_PLANT_PROD_USR
prompt ==================================
prompt
create or replace force view cantabria.vw_mt_plant_prod_usr as
select pp.cod_plantilla, pp.desc_plantilla, pp.ot_adm, pp.grupo, oau.cod_usr
from plant_prod pp, ot_adm_usuario oau
where pp.ot_adm = oau.ot_adm;

prompt
prompt Creating view VW_MTT_ART_X_LABOR
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_MTT_ART_X_LABOR AS
SELECT a.cod_art   ,
       a.desc_art  ,
			 a.und       ,
       l.cod_labor ,
       asu.cnta_prsp_egreso as cnta_prsp_insm
  FROM articulo a, labor_insumo l, articulo_sub_categ asu
WHERE (a.cod_art     = l.cod_art     ) AND
      (a.sub_cat_art = asu.cod_sub_cat ) AND
      (a.flag_estado = '1'          );

prompt
prompt Creating view VW_OC_IMPUESTOS
prompt =============================
prompt
create or replace force view cantabria.vw_oc_impuestos as
select amp.cod_origen, amp.nro_mov,
         amp.cant_proyect, amp.precio_unit, it.tasa_impuesto,
         amp.impuesto,
         round(amp.cant_proyect * amp.precio_unit * it.tasa_impuesto/100,6) as impuesto_real
  from articulo_mov_proy amp,
       impuestos_tipo    it
  where amp.tipo_impuesto1 = it.tipo_impuesto
    and amp.tipo_doc = 'OC'
    and amp.tipo_impuesto1 is not null
    and amp.impuesto <> round(amp.cant_proyect * amp.precio_unit * it.tasa_impuesto/100, 6);

prompt
prompt Creating view VW_OPE_ARTICULO_VENTA
prompt ===================================
prompt
create or replace force view cantabria.vw_ope_articulo_venta as
select av.cod_art, a.nom_articulo, a.und
from articulo_venta av, articulo a
where av.cod_art = a.cod_art and
a.flag_estado='1'
order by a.nom_articulo;

prompt
prompt Creating view VW_OPE_CENCOS_CAL_RECLAMO
prompt =======================================
prompt
create or replace force view cantabria.vw_ope_cencos_cal_reclamo as
select distinct(c.cencos_rsp) as cencos, cc.desc_cencos
from cal_reclamo c, centros_costo cc
where c.cencos_rsp=cc.cencos;

prompt
prompt Creating view VW_OPE_CENTRO_BENEFICIO
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_CENTRO_BENEFICIO AS
SELECT distinct a.centro_benef AS centro_beneficio,
       a.desc_centro AS descripcion_centro,
       u.cod_usr AS usuario
  FROM centro_beneficio a, centro_benef_usuario u
WHERE a.FLAG_ESTADO = '1'
  AND A.CENTRO_BENEF = U.CENTRO_BENEF
ORDER BY u.cod_usr;

prompt
prompt Creating view VW_OPE_CLIENTE_CAL_RECLAMO
prompt ========================================
prompt
create or replace force view cantabria.vw_ope_cliente_cal_reclamo as
select distinct(c.cliente) as proveedor, p.nom_proveedor
from cal_reclamo c, proveedor p
where c.cliente=p.proveedor;

prompt
prompt Creating view VW_OPE_CODREL_CNTA_PAGAR
prompt ======================================
prompt
create or replace force view cantabria.vw_ope_codrel_cnta_pagar as
select distinct(p.proveedor) as cod_relacion,
       p.nom_proveedor,
       p.ruc
from proveedor p, cntas_pagar cp
where p.proveedor=cp.cod_relacion and
      p.flag_estado<>'0';

prompt
prompt Creating view VW_OPE_CONSULTA_ORDEN_TRABAJO
prompt ===========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_CONSULTA_ORDEN_TRABAJO AS
SELECT OT.COD_ORIGEN   AS ORIGEN             ,
       OT.NRO_ORDEN    AS NRO_OT             ,
       OT.OT_ADM 	     AS ADMINISTRACION     ,
       OT.OT_TIPO      AS TIPO			         ,
       OT.CENCOS_SLC   AS CENCOS_SOLIC       ,
       CCA.DESC_CENCOS AS DESC_CC_SOLICITANTE,
       OT.CENCOS_RSP   AS CENCOS_RESP        ,
       CCB.DESC_CENCOS AS DESC_CC_RESPONSABLE,
       OT.COD_USR 	   AS USUARIO            ,
       OT.RESPONSABLE  AS CODIGO_RESPONSABLE ,
       M.APEL_PATERNO||' '||M.APEL_MATERNO||' '||M.NOMBRE1 AS NOMBRE_RESPONSABLE ,
       TO_CHAR(OT.FEC_INICIO,'DD/MM/YYYY')   AS FECHA_INICIO		   ,
       OT.TITULO       AS TITULO_ORDEN_TRABAJO
  FROM ORDEN_TRABAJO OT ,CENTROS_COSTO CCA,CENTROS_COSTO CCB,MAESTRO M
 WHERE (OT.CENCOS_SLC  = CCA.CENCOS (+)     ) AND
       (OT.CENCOS_RSP  = CCB.CENCOS (+)     ) AND
       (OT.RESPONSABLE = M.COD_TRABAJADOR(+));

prompt
prompt Creating view VW_OPE_CRELACION_X_GRUPO
prompt ======================================
prompt
create or replace force view cantabria.vw_ope_crelacion_x_grupo as
select cra.grupo,cr.cod_relacion,cr.nombre,crg.ot_adm
  from cod_rel_agrupamiento cra,
       cod_rel_grupo_ot_adm crg,
       codigo_relacion      cr
 where cra.grupo        = crg.grupo       AND
       cra.cod_relacion = cr.cod_relacion;

prompt
prompt Creating view VW_OPE_ESTRUCTURA
prompt ===============================
prompt
create or replace force view cantabria.vw_ope_estructura as
select Distinct(ots.ot_padre) AS NRO_ORDEN,
       ot.titulo ,
       ot.cencos_slc,ot.ot_adm
  from ot_estructura ots,orden_trabajo ot
 where (ots.ot_padre = ot.nro_orden);

prompt
prompt Creating view VW_OPE_INCIDENCIAS_GRUPO
prompt ======================================
prompt
create or replace force view cantabria.vw_ope_incidencias_grupo as
select i.cod_incidencia, i.desc_incidencia, ig.ot_adm
from incidencias_dma i, incidencia_grupo ig
where i.cod_incidencia=ig.cod_incidencia;

prompt
prompt Creating view VW_OPE_LABOR_X_OT_ADM
prompt ===================================
prompt
create or replace force view cantabria.vw_ope_labor_x_ot_adm as
select DISTINCT lr.cod_labor, l.desc_labor, l.und, lg.ot_adm
  from labor_grupo_ot_adm lg, labor_grupo_rel lr, labor l
 where lg.grupo=lr.grupo and
       lr.cod_labor = l.cod_labor and
       l.flag_estado='1';

prompt
prompt Creating view VW_OPE_LABOR_X_OT_ADM_CMP
prompt =======================================
prompt
create or replace force view cantabria.vw_ope_labor_x_ot_adm_cmp as
select lr.cod_labor, l.desc_labor, l.und, lg.ot_adm
  from labor_grupo_ot_adm lg, labor_grupo_rel lr, labor l
 where lg.grupo=lr.grupo and
       lr.cod_labor = l.cod_labor and
       l.flag_maq_mo  = 'A' and
       l.flag_estado='1';

prompt
prompt Creating view VW_OPE_MAESTRO_TARJETAS
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_MAESTRO_TARJETAS AS
SELECT MAESTRO.COD_TRABAJADOR ,
       MAESTRO.APEL_PATERNO   ,
			 MAESTRO.APEL_MATERNO   ,
			 MAESTRO.NOMBRE1        ,
       MAESTRO.NOMBRE2        ,
       MAESTRO.COD_ORIGEN     ,
       RRHH_ASIGNA_TRJT_RELOJ.COD_TARJETA
  FROM MAESTRO ,RRHH_ASIGNA_TRJT_RELOJ
WHERE RRHH_ASIGNA_TRJT_RELOJ.COD_TRABAJADOR = MAESTRO.COD_TRABAJADOR AND
      MAESTRO.FLAG_ESTADO = '1'                                      AND
      RRHH_ASIGNA_TRJT_RELOJ.FLAG_ESTADO = '1';

prompt
prompt Creating view VW_OPE_OT_ADM_USR
prompt ===============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_OT_ADM_USR AS
SELECT "OT_ADM_USUARIO"."OT_ADM",
         "OT_ADMINISTRACION"."DESCRIPCION" ,
         "OT_ADM_USUARIO"."COD_USR"
    FROM "OT_ADM_USUARIO",
         "OT_ADMINISTRACION"
   WHERE ( "OT_ADMINISTRACION"."OT_ADM" = "OT_ADM_USUARIO"."OT_ADM" );

prompt
prompt Creating view VW_OPE_OT_CC_ADM
prompt ==============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_OT_CC_ADM AS
SELECT "CAMPO_CICLO"."COD_CICLO",
         "CAMPO_CICLO"."NRO_CORTE",
         "ORDEN_TRABAJO"."FLAG_ESTADO",
         "CAMPO_CICLO"."FEC_ESPERADA",
         "CAMPO_CICLO"."FEC_INICIO",
         "CAMPO_CICLO"."FEC_FINAL",
         "CAMPO_CICLO"."CORR_CORTE",
         "ORDEN_TRABAJO"."NRO_ORDEN",
         "ORDEN_TRABAJO"."CENCOS_RSP",
         "ORDEN_TRABAJO"."CENCOS_SLC",
         "ORDEN_TRABAJO"."OT_ADM",
         "ORDEN_TRABAJO"."OT_TIPO"
    FROM "CAMPO_CICLO",
         "ORDEN_TRABAJO"
   WHERE ( orden_trabajo.nro_orden = campo_ciclo.nro_orden (+));

prompt
prompt Creating view VW_OPE_OT_X_ADM
prompt =============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_OT_X_ADM AS
SELECT ot.cod_origen   ,
       ot.nro_orden    ,
       ot.fec_solicitud,
       ot.fec_inicio   ,
       ot.cod_usr      ,
       ot.nro_solicitud,
       ot.ot_adm       ,
       ot.ot_tipo      ,
       ota.cod_usr as usuario,
       '' as desc_campo ,
       '' as cod_campo  ,
       '' as corr_corte
  FROM orden_trabajo  ot,
       ot_adm_usuario ota
 WHERE ota.ot_adm   = ot.ot_adm
   AND ot.flag_estado in ('1','3')
GROUP BY ot.cod_origen    ,
         ot.nro_orden     ,
         ot.fec_solicitud ,
         ot.fec_inicio    ,
         ot.cod_usr       ,
         ot.nro_solicitud ,
         ot.ot_adm        ,
         ot.ot_tipo       ,
         ota.cod_usr;

prompt
prompt Creating view VW_OPE_OT_X_ADM_TOD
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_OT_X_ADM_TOD AS
SELECT ot.cod_origen   ,
       ot.nro_orden    ,
       ot.fec_solicitud,
       ot.fec_registro ,
       ot.fec_inicio   ,
       ot.cod_usr      ,
       ot.nro_solicitud,
       cc.corr_corte   ,
       ot.ot_adm       ,
       ot.ot_tipo      ,
       ot.flag_estado  ,
       ota.cod_usr as usuario,
       c.cod_campo     ,
       c.desc_campo
  FROM orden_trabajo  ot,
       ot_adm_usuario ota,
       campo_ciclo    cc,
       campo          c
 WHERE ( ot.nro_orden = cc.nro_orden (+)) and
       ( cc.cod_campo = c.cod_campo  (+)) and
       ( ota.ot_adm   = ot.ot_adm       )
GROUP BY ot.cod_origen    ,
         ot.nro_orden     ,
         ot.fec_solicitud ,
         ot.fec_registro  ,
         ot.fec_inicio    ,
         ot.cod_usr       ,
         ot.nro_solicitud ,
         cc.corr_corte    ,
         ot.ot_adm        ,
         ot.ot_tipo       ,
         ot.flag_estado   ,
         ota.cod_usr      ,
         c.cod_campo      ,
         c.desc_campo
ORDER BY ot.fec_registro;

prompt
prompt Creating view VW_OPE_OT_X_ADM_TO_NEW
prompt ====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_OT_X_ADM_TO_NEW AS
SELECT distinct ot.cod_origen   ,
       ot.nro_orden    ,
       ot.fec_solicitud,
       ot.fec_registro ,
       ot.fec_inicio   ,
       ot.cod_usr      ,
       ot.nro_solicitud,
       ot.ot_adm       ,
       ot.ot_tipo      ,
       ot.flag_estado  ,
       ota.cod_usr as usuario,
       ot.titulo,
       ot.cliente,
       p.nom_proveedor
  FROM orden_trabajo  ot,
       ot_adm_usuario ota,
       proveedor      p
 WHERE ota.ot_adm   = ot.ot_adm
   and ot.cliente   = p.proveedor (+)
ORDER BY ot.fec_registro;

prompt
prompt Creating view VW_OPE_PLANT_OT_X_USR
prompt ===================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_PLANT_OT_X_USR AS
SELECT pot.cod_plantilla,
       pot.ot_adm,
       pot.ot_tipo,
       pot.descripcion,
       ota.cod_usr
  FROM plant_ot  pot,
       ot_adm_usuario ota
 WHERE ( pot.ot_adm   = ota.ot_adm       );

prompt
prompt Creating view VW_OPE_PLANT_X_ADM
prompt ================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_PLANT_X_ADM AS
SELECT PLANT_PROD.COD_PLANTILLA AS CODIGO ,
       PLANT_PROD.DESC_PLANTILLA AS DESCRIPCION ,
       PLANT_PROD.OT_ADM AS ADMINISTRACION ,
       OT_ADM_USUARIO.COD_USR    AS USUARIO
FROM PLANT_PROD,OT_ADM_USUARIO
WHERE PLANT_PROD.OT_ADM = OT_ADM_USUARIO.OT_ADM;

prompt
prompt Creating view VW_OPE_PROV_X_OPERACIONES
prompt =======================================
prompt
create or replace force view cantabria.vw_ope_prov_x_operaciones as
select distinct(op.proveedor) as codigo,
       pr.nom_proveedor       as descripcion
  from operaciones op,proveedor pr
 where op.proveedor = pr.proveedor;

prompt
prompt Creating view VW_OPE_PT_X_ADM
prompt =============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_PT_X_ADM AS
SELECT po.nro_parte, TO_CHAR(po.fecha,'DD/MM/YYYY') AS FECHA,po.ot_adm, OTU.COD_USR,po.obs
  FROM pd_ot po,ot_adm_usuario otu
 WHERE  po.ot_adm    = otu.ot_adm
GROUP BY po.nro_parte, po.fecha,po.ot_adm,otu.cod_usr ,po.obs;

prompt
prompt Creating view VW_OPE_SALDO_LIBRE_ARTICULO
prompt =========================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_SALDO_LIBRE_ARTICULO AS
SELECT AA.COD_ART,
       A.NOM_ARTICULO,
       a.desc_art,
       A.UND,
       AMP.COD_ORIGEN,
       AMP.ALMACEN,
       AMP.NRO_MOV,
       AMP.NRO_DOC AS ORD_TRABAJ,
       AMP.OPER_SEC,
       CASE WHEN USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV) <
                 (NVL(AA.SLDO_TOTAL,0) - NVL(AA.SLDO_RESERVADO,0)) THEN
            USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV)
       ELSE
            NVL(AA.SLDO_TOTAL,0) - NVL(AA.SLDO_RESERVADO,0)
       END  SALDO_LIBRE,
       aa.sldo_total,
       amp.fec_proyect,
       amp.cant_proyect,
       amp.cant_procesada,
       amp.cant_reservado,
       usf_cmp_cant_cmp_AMP_OT(AMP.COD_ORIGEN, AMP.NRO_MOV) AS CANT_COMPRADA,
       aa.flag_reposicion
  FROM ARTICULO_MOV_PROY AMP,
       ARTICULO_ALMACEN AA,
       ARTICULO A
 WHERE AMP.COD_ART = AA.COD_ART
   AND amp.almacen = AA.Almacen
   AND AMP.COD_ART = A.COD_ART
   AND AA.COD_ART = A.COD_ART
   AND NVL(AA.FLAG_REPOSICION,0)='0'
   AND AMP.FLAG_ESTADO = '1'
   AND AMP.tipo_doc = (SELECT doc_ot FROM logparam WHERE reckey = '1')
   AND AMP.tipo_mov = (SELECT oper_cons_interno FROM logparam WHERE reckey = '1')
   AND nvl(AA.SLDO_TOTAL,0 )- nvl(AA.SLDO_RESERVADO,0) > 0
   AND nvl(AMP.CANT_PROYECT,0) - nvl(AMP.CANT_PROCESADA,0) - nvl(AMP.CANT_RESERVADO,0) > 0
   AND A.FLAG_INVENTARIABLE = '1'
   AND A.FLAG_ESTADO = '1'
   AND (CASE WHEN USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV) <
                 (NVL(AA.SLDO_TOTAL,0) - NVL(AA.SLDO_RESERVADO,0)) THEN
            USF_ALM_CANT_LIBRE_OT(AMP.COD_ORIGEN, AMP.NRO_MOV)
       ELSE
            NVL(AA.SLDO_TOTAL,0) - NVL(AA.SLDO_RESERVADO,0)
       END) > 0
ORDER BY AA.COD_ART, AMP.COD_ORIGEN, AMP.NRO_MOV;

prompt
prompt Creating view VW_OPE_SOLICITUD_OT
prompt =================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_OPE_SOLICITUD_OT AS
SELECT "SOLICITUD_OT"."NRO_SOLICITUD",
         "SOLICITUD_OT"."FLAG_ESTADO",
         "SOLICITUD_OT"."FLAG_URGENCIA",
         "SOLICITUD_OT"."FEC_SOLICITUD",
         "SOLICITUD_OT"."FECHA_ESPERADA",
         "SOLICITUD_OT"."CENCOS_SLC",
         "SOLICITUD_OT"."CENCOS_RSP",
         "SOLICITUD_OT"."COD_USUARIO_SOL",
         "SOLICITUD_OT"."COD_USUARIO_RESP",
         "ORDEN_TRABAJO"."COD_ORIGEN",
         "ORDEN_TRABAJO"."NRO_ORDEN"
    FROM "SOLICITUD_OT",
         "ORDEN_TRABAJO"
   WHERE ( solicitud_ot.nro_solicitud = orden_trabajo.nro_solicitud (+));

prompt
prompt Creating view VW_OPE_TT_EFECTIVIDADA
prompt ====================================
prompt
create or replace force view cantabria.vw_ope_tt_efectividada as
select tt.fecha_inicio,tt.cod_trabajador,tt.codprd,tt.peso,tt.hora_efectiva
      from tt_ope_tefectivo_x_trab tt
     where
           ((tt.hora_efectiva > 0 and tt.peso > 0 ));

prompt
prompt Creating view VW_OT_ADM_USER
prompt ============================
prompt
create or replace force view cantabria.vw_ot_adm_user as
select distinct a.ot_adm, a.descripcion, b.cod_usr
from ot_administracion a,
     ot_adm_usuario    b
where a.ot_adm = b.ot_adm;

prompt
prompt Creating view VW_PARTE_PISO_FIRMAS
prompt ==================================
prompt
create or replace force view cantabria.vw_parte_piso_firmas as
select a.cod_usr, b.nombre, trunc(a.fecha) as fecha, a.nro_parte
from tg_parte_piso_firmas a,
     usuario b
where b.cod_usr = a.cod_usr;

prompt
prompt Creating view VW_PD_RPT_DESTAJO_JORNAL
prompt ======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_PD_RPT_DESTAJO_JORNAL AS
select a.nro_parte, a.turno, a.fec_parte, b.cod_trabajador,
             vw.NOM_TRABAJADOR,
             vw.TIPO_TRABAJADOR, vw.FLAG_estado, vw.FLAG_CAL_PLNLLA,
             a.cod_especie, e.descr_especie,
             a.cod_presentacion, p.desc_presentacion,
             a.cod_tarea, t.desc_tarea,
             0 as imp_hora,
             a.precio_unit,
             b.cant_producida,
             tf.und,
             a.cod_cliente, p.nom_proveedor as nom_cliente,
             tf.flag_destajo,
             0 as total_horas,
             0 as horas_diu_nor,
             0 as horas_diu_ext1,
             0 as horas_diu_ext2,
             0 as horas_noc_nor,
             0 as horas_noc_ext1,
             0 as horas_noc_ext2,
             0 as horas_ext_100,
             0 as imp_hor_diu_nor,
             0 as imp_hor_diu_ext1,
             0 as imp_hor_diu_ext2,
             0 as imp_hor_noc_nor,
             0 as imp_hor_noc_ext1,
             0 as imp_hor_noc_ext2,
             0 as imp_hor_ext_100,
             a.ot_adm,
             ota.descripcion as desc_ot_adm,
             a.oper_sec,
             op.nro_orden as nro_ot,
             vw.cod_origen,
             'PD' as tipo,
             vw.COD_BANCO,
             vw.NRO_CNTA_AHORRO,
               vw.CENTRO_BENEF,
             vw.NRO_DOC_IDENT_RTPS
        from tg_pd_destajo      a,
             tg_pd_destajo_det  b,
             vw_pr_trabajador   vw,
             tg_especies        e,
             tg_presentacion    p,
             tg_tareas          t,
             tg_tarifario       tf,
             proveedor          p,
             operaciones        op,
             ot_administracion  ota
        where a.nro_parte       = b.nro_parte
          and a.cod_cliente     = p.proveedor
          and b.cod_trabajador    = vw.cod_trabajador (+)
          and a.cod_especie       = e.especie
          and a.cod_presentacion  = p.cod_presentacion
          and a.cod_tarea         = t.cod_tarea
          and a.cod_especie       = tf.cod_especie        (+)
          and a.cod_presentacion  = tf.cod_presentacion   (+)
          and a.cod_tarea         = tf.cod_tarea          (+)
          and a.ot_adm            = ota.ot_adm            (+)
          and a.oper_sec          = op.oper_sec           (+)
          and a.flag_Estado <> '0'
          and tf.flag_destajo = '1'
          and b.cant_producida > 0
        union
        select a.nro_parte, a.turno, a.fec_parte, b.cod_trabajador,
               vw.NOM_TRABAJADOR,
               vw.TIPO_TRABAJADOR, vw.FLAG_estado, vw.FLAG_CAL_PLNLLA,
               a.cod_especie, e.descr_especie,
               a.cod_presentacion, p.desc_presentacion,
               a.cod_tarea,
               t.desc_tarea,
               0 as imp_hora,
               a.precio_unit,
               0 as cant_producida,
               tf.und,
               a.cod_cliente,
               p.nom_proveedor as nom_cliente,
               tf.flag_destajo,
               b.cant_horas_diu + b.cant_horas_noc as total_horas,
               case
                 when b.cant_horas_diu < 8 then
                   b.cant_horas_diu
                 else
                   8
               end as horas_diu_nor,
               case
                 when b.cant_horas_diu > 8 then
                   case
                     when b.cant_horas_diu - 8 > 2 then
                       2
                     else
                       b.cant_horas_diu - 8
                   end
                 else 0
               end as horas_diu_ext1,
               case
                 when b.cant_horas_diu > 10 then
                   b.cant_horas_diu - 10
                 else 0
               end as horas_diu_ext2,
               case
                 when b.cant_horas_noc < 8 then b.cant_horas_noc
                 else 8
               end as horas_noc_nor,
               case
                 when b.cant_horas_noc > 8 then
                   case
                     when b.cant_horas_noc - 8 > 2 then
                       2
                     else
                       b.cant_horas_noc - 8
                   end
                 else 0
               end as horas_noc_ext1,
               case
                 when b.cant_horas_noc > 10 then
                   b.cant_horas_noc - 10
                 else 0
               end as horas_noc_ext2,
               0 as horas_ext_100,
               0 as imp_hor_diu_nor,
               0 as imp_hor_diu_ext1,
               0 as imp_hor_diu_ext2,
               0 as imp_hor_noc_nor,
               0 as imp_hor_noc_ext1,
               0 as imp_hor_noc_ext2,
               0 as imp_hor_ext_100,
               a.ot_adm,
               ota.descripcion as desc_ot_adm,
               a.oper_sec,
               op.nro_orden,
               vw.cod_origen,
               'PD' as tipo,
               vw.COD_BANCO,
               vw.NRO_CNTA_AHORRO,
               vw.CENTRO_BENEF,
               vw.NRO_DOC_IDENT_RTPS
        from tg_pd_destajo      a,
             tg_pd_destajo_det  b,
             vw_pr_trabajador   vw,
             tg_especies        e,
             tg_presentacion    p,
             tg_tareas          t,
             tg_tarifario       tf,
             proveedor          p,
             ot_administracion  ota,
             operaciones        op,
             labor              la
        where a.nro_parte         = b.nro_parte
          and a.cod_cliente       = p.proveedor
          and b.cod_trabajador    = vw.cod_trabajador
          and a.cod_especie       = e.especie
          and a.cod_presentacion  = p.cod_presentacion
          and a.cod_tarea         = t.cod_tarea
          and a.cod_especie       = tf.cod_especie       (+)
          and a.cod_presentacion  = tf.cod_presentacion  (+)
          and a.cod_tarea         = tf.cod_tarea         (+)
          and a.ot_adm            = ota.ot_adm           (+)
          and tf.cod_labor        = la.cod_labor         (+)
          and a.oper_sec          = op.oper_sec          (+)
          and a.flag_Estado <> '0'
          and tf.flag_destajo = '0'
          and (b.cant_horas_diu > 0 or b.cant_horas_noc > 0)
      union
        select null as nro_parte,
               a.turno,
               a.fec_movim,
               m.cod_trabajador,
               m.NOM_TRABAJADOR,
               m.TIPO_TRABAJADOR,
               m.FLAG_estado,
               m.FLAG_CAL_PLNLLA,
               null as cod_especie,
               null as descr_especie,
               null as cod_presentacion,
               null as desc_presentacion,
               la.cod_labor as cod_tarea,
               la.desc_labor as desc_tarea,
               m.jornal / 240 as imp_hora,
               case
                 when nvl(a.imp_hor_diu_nor, 0) + nvl(a.imp_hor_diu_ext1, 0) + nvl(a.imp_hor_diu_ext2, 0) +
                      nvl(a.imp_hor_noc_nor, 0) + nvl(a.imp_hor_noc_ext1, 0) + nvl(a.imp_hor_noc_ext2, 0) +
                      nvl(a.imp_hor_ext_100, 0) = 0 then
                      m.jornal / 240
                 when a.hor_diu_nor + a.hor_noc_nor + a.hor_ext_diu_1 + a.hor_ext_diu_2 + a.hor_ext_noc_1 + a.hor_ext_noc_2 + a.hor_ext_100 = 0 then
                      m.jornal / 240
                 else
                      (nvl(a.imp_hor_diu_nor, 0) + nvl(a.imp_hor_diu_ext1, 0) + nvl(a.imp_hor_diu_ext2, 0) +
                      nvl(a.imp_hor_noc_nor, 0) + nvl(a.imp_hor_noc_ext1, 0) + nvl(a.imp_hor_noc_ext2, 0) +
                      nvl(a.imp_hor_ext_100, 0)) / (a.hor_diu_nor + a.hor_noc_nor * 1.35 + a.hor_ext_diu_1 * 1.25 +
                      a.hor_ext_diu_2 * 1.35 + a.hor_ext_noc_1 * 1.35 * 1.25 + a.hor_ext_noc_2 * 1.35 * 1.35 + a.hor_ext_100 * 2)
               end as tarifa,
               0 as cant_producida,
               'HRS' as und,
               m.cod_empresa as cod_cliente,
               e.nombre as nom_cliente,
               '0' as flag_destajo,
               a.hor_diu_nor + a.hor_noc_nor + a.hor_ext_diu_1 + a.hor_ext_diu_2 + a.hor_ext_noc_1 + a.hor_ext_noc_2 + a.hor_ext_100 as horas,
               a.hor_diu_nor,
               a.hor_ext_diu_1,
               a.hor_ext_diu_2,
               a.hor_noc_nor,
               a.hor_ext_noc_1,
               a.hor_ext_noc_2,
               a.hor_ext_100,
               nvl(a.imp_hor_diu_nor, 0) as imp_hor_diu_nor,
               nvl(a.imp_hor_diu_ext1, 0) as imp_hor_diu_ext1,
               nvl(a.imp_hor_diu_ext2, 0) as imp_hor_diu_ext2,
               nvl(a.imp_hor_noc_nor, 0) as imp_hor_noc_nor,
               nvl(a.imp_hor_noc_ext1, 0) as imp_hor_noc_ext1,
               nvl(a.imp_hor_noc_ext2, 0) as imp_hor_noc_ext2,
               nvl(a.imp_hor_ext_100, 0) as imp_hor_ext_100,
               a.ot_adm,
               ota.descripcion as desc_ot_adm,
               a.oper_sec,
               op.nro_orden,
               m.cod_origen,
               'PJ' as tipo,
               m.cod_banco,
               m.NRO_CNTA_AHORRO,
               m.CENTRO_BENEF,
               m.NRO_DOC_IDENT_RTPS
        from asistencia         a,
             (select vw.*, (SELECT NVL(sum(G.IMP_GAN_DESC),0)
                              FROM gan_desct_fijo g,
                                   GRUPO_CALCULO_DET d
                             WHERE G.COD_TRABAJADOR = vw.COD_TRABAJADOR
                               and d.concepto_calc = g.concep
                               AND G.FLAG_ESTADO = '1'
                               AND D.GRUPO_CALCULO = PKG_CONFIG.USF_GET_PARAMETER('RRHH_GRUPO_CALCULO_JORNAL', '039')) as jornal
                from vw_pr_trabajador vw)  m,
             ot_administracion  ota,
             empresa            e,
             operaciones        op,
             labor              la
        where a.cod_trabajador    = m.cod_trabajador
          and a.ot_adm            = ota.ot_adm           (+)
          and a.oper_sec          = op.oper_sec          (+)
          and op.cod_labor        = la.cod_labor         (+)
          and m.cod_empresa       = e.cod_empresa        (+)
          and m.tipo_trabajador   in ('JOR', 'DES')
  order by nom_trabajador, fec_parte;

prompt
prompt Creating view VW_PLANT_OT_ADM
prompt =============================
prompt
create or replace force view cantabria.vw_plant_ot_adm as
select distinct a."COD_PLANTILLA",a."DESC_PLANTILLA",a."ZONA",a."TIPO_SUELO",a."TIPO_RIEGO",a."VARIEDAD",a."FLAG_USO",a."FLAG_ESTADO",a."OT_ADM",a."FLAG_REPLICACION",a."GRUPO",a."FLAG_ESTRUCTURA", b.cod_usr
from plant_prod a,
     ot_adm_usuario b
where b.ot_adm = a.ot_adm;

prompt
prompt Creating view VW_PR_ARTICULO_OPERSEC
prompt ====================================
prompt
create or replace force view cantabria.vw_pr_articulo_opersec as
select amp.cod_art, a.desc_art, a.und, amp.precio_unit, amp.oper_sec
      from articulo_mov_proy amp
      inner join articulo a on amp.cod_art = a.cod_art;

prompt
prompt Creating view VW_PR_ARTICULO_PARTE_PISO
prompt =======================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_PR_ARTICULO_PARTE_PISO AS
SELECT DISTINCT PPD.NRO_PARTE,
                M.DESC_MAQ,
                MAA.DESCRIPCION,
                PP.FECHA_PARTE
  FROM TG_PARTE_PISO_DET              PPD,
       MAQUINA                        M,
       TG_MED_ACT_ATRIBUTO            MAA,
       TG_FMT_MED_ACT_DET             FD,
       TG_PARTE_PISO                  PP
WHERE PPD.FORMATO                     = FD.FORMATO
  AND FD.COD_MAQUINA                  = M.COD_MAQUINA
  AND FD.ATRIBUTO                     = MAA.ATRIBUTO
  AND PP.NRO_PARTE                    = PPD.NRO_PARTE;

prompt
prompt Creating view VW_PR_ATRIB_ARTICULO
prompt ==================================
prompt
create or replace force view cantabria.vw_pr_atrib_articulo as
select distinct ta.atributo, tb.descripcion, tb.und, ta.cod_art
 from tg_articulo_calidad_atributo ta,
      tg_calidad_atributo tb
 where ta.atributo = tb.atributo;

prompt
prompt Creating view VW_PR_ATRIBUTOS_X_ARTICULO
prompt ========================================
prompt
create or replace force view cantabria.vw_pr_atributos_x_articulo as
select distinct taca.atributo, tca.descripcion, taca.cod_art
      from tg_articulo_calidad_atributo taca
         inner join tg_calidad_atributo tca on taca.atributo = tca.atributo;

prompt
prompt Creating view VW_PR_FORAMTO_LABOR
prompt =================================
prompt
create or replace force view cantabria.vw_pr_foramto_labor as
select fma.formato as fmt_cod, fma.descripcion as fmt_desc, l.desc_labor as lbr_desc
      from tg_fmt_med_act fma
      left outer join labor l on fma.cod_labor = l.cod_labor
      where fma.flag_estado = '1';

prompt
prompt Creating view VW_PR_FORAMTO_TUSO
prompt ================================
prompt
create or replace force view cantabria.vw_pr_foramto_tuso as
select fma.formato as fmt_cod, fma.descripcion as fmt_desc, l.desc_labor as lbr_desc
      from tg_fmt_med_act fma
      left outer join labor l on fma.cod_labor = l.cod_labor
      where fma.flag_estado = '1';

prompt
prompt Creating view VW_PR_FORMATO_LABOR
prompt =================================
prompt
create or replace force view cantabria.vw_pr_formato_labor as
select fma.formato as fmt_cod, fma.descripcion as fmt_desc, l.desc_labor as lbr_desc
      from tg_fmt_med_act fma
      left outer join labor l on fma.cod_labor = l.cod_labor
      where fma.flag_estado = '1';

prompt
prompt Creating view VW_PR_INSUMOS_X_OT
prompt ================================
prompt
create or replace force view cantabria.vw_pr_insumos_x_ot as
select a.Nro_Item,
       A.COD_ART,
       NVL(a.cantidad, 0) AS CANTIDAD,
       NVL(a.costo_insumo, 0) AS COSTO_INSUMO,
       a.nro_parte,
       b.desc_art,
       b.und,
       d.oper_sec,
       d.nro_orden,
       NVL(a.cantidad, 0) * NVL(a.costo_insumo, 0) AS TOTAL_COSTO
from pd_ot_insumos a,
     articulo b,
     pd_ot_det c,
     operaciones d
where a.cod_art = b.cod_art
  and c.nro_parte = a.nro_parte
  and c.nro_item  = a.nro_item
  and d.oper_sec  = c.oper_sec;

prompt
prompt Creating view VW_PR_INSUMOS_X_PD_OT
prompt ===================================
prompt
create or replace force view cantabria.vw_pr_insumos_x_pd_ot as
select a.nro_parte as nro_parte,
       a.cod_art,
       ar.nom_articulo,
       ar.und,
       a.cantidad,
       op.oper_sec,
       op.desc_operacion,
       pdot.desc_labor,
       pd.fecha,
       op.fec_inicio,
       a.nro_item,
       pdot.cod_labor,
       pdot.hora_inicio
from pd_ot_insumos       a,
     articulo            ar,
     pd_ot_det           pdot,
     operaciones         op,
     pd_ot               pd
where ar.cod_art        = a.cod_art
  and pdot.nro_item     = a.nro_item
  and pdot.nro_parte    = a.nro_parte
  and op.oper_sec       = pdot.oper_sec
  and pd.nro_parte      = pdot.nro_parte;

prompt
prompt Creating view VW_PR_LABOR_EJECUTOR
prompt ==================================
prompt
create or replace force view cantabria.vw_pr_labor_ejecutor as
select a."COD_LABOR",a."COD_EJECUTOR",a."FLAG_ESTADO",a."FLAG_COSTO_FIJO",a."UND_ALT",a."FACTOR_CONV",a."NRO_PERSONAS",a."RATIO_ESTIMADO",a."FLAG_REPLICACION",a."COSTO_UNITARIO",a."COD_MONEDA",a."FLAG_UND_COSTO", b.descripcion as desc_ejecutor
from labor_ejecutor a,
     ejecutor b
where b.cod_ejecutor = a.cod_ejecutor;

prompt
prompt Creating view VW_PROD_LAVADO_ZP
prompt ===============================
prompt
create or replace force view cantabria.vw_prod_lavado_zp as
select A.nro_Parte,
       trunc(A.Fec_Parte_lav) AS fec_parte_lav,
       B.Cencos,
       t.tarifa,
       C.Desc_Cencos,
       b.tipo_prenda,
       p.desc_prenda,
       f.zona_proceso,
       f.descr_zona_proc as desc_zona_proc,
       b.nro_prendas,
       a.proveedor
from prod_parte_lavado      A,
     prod_parte_lavado_det  B,
     Centros_Costo          C,
     com_zona_proceso       F,
     prod_parte_lav_tarifa  t,
     prod_tipo_prenda       p,
     proveedor              v
where a.nro_parte           = b.nro_parte
  AND a.proveedor           = v.proveedor
  AND A.NRO_PARTE           = T.NRO_PARTE
  AND b.zona_proceso        = f.zona_proceso
  AND b.tipo_prenda         = T.TIPO_PRENDA
  AND b.cencos              = c.cencos
  AND t.nro_parte           = b.nro_parte
  AND t.tipo_prenda         = p.tipo_prenda
  AND t.tipo_prenda         = b.tipo_prenda
  AND a.flag_estado         = '1';

prompt
prompt Creating view VW_PROD_PARTES_PISOS
prompt ==================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_PROD_PARTES_PISOS AS
SELECT tg.nro_parte,
		    tg.formato,
        f.descripcion,
        tg.fecha_parte,
        tg.cod_usr,
        tg.cod_planta, p.desc_planta
  FROM tg_parte_piso  tg,
		   tg_fmt_med_act f,
       tg_plantas     p
 WHERE tg.formato     = f.formato
   and tg.nro_version = f.nro_version
   AND p.cod_planta(+)= tg.cod_planta;

prompt
prompt Creating view VW_PR_OT_ADM_USR
prompt ==============================
prompt
create or replace force view cantabria.vw_pr_ot_adm_usr as
select oa.ot_adm, oa.descripcion, oau.cod_usr, oa.flag_ctrl_aprt_ot
                        from ot_administracion oa
         inner join ot_adm_usuario oau on oa.ot_adm = oau.ot_adm;

prompt
prompt Creating view VW_PR_OT_LABOR
prompt ============================
prompt
create or replace force view cantabria.vw_pr_ot_labor as
select o.cod_labor,  upper(l.desc_labor) as desc_labor, o.oper_sec, o.nro_orden, o.cod_ejecutor, upper(e.descripcion) as descripcion, o.proveedor, upper(cr.nombre) as nombre, om.cod_maquina, upper(m.desc_maq) as desc_maquina, o.avance_und, upper(u.desc_unidad) as desc_unidad
      from operaciones o
         left outer join operaciones_maquina om on o.oper_sec = om.oper_sec
         left outer join labor l on o.cod_labor = l.cod_labor
         left outer join ejecutor e on o.cod_ejecutor = e.cod_ejecutor
         left outer join maquina m on om.cod_maquina = m.cod_maquina
         left outer join codigo_relacion cr on o.proveedor = cr.cod_relacion
         left outer join unidad u on o.avance_und = u.und;

prompt
prompt Creating view VW_PR_OT_X_USR
prompt ============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_PR_OT_X_USR AS
SELECT distinct
       ot.cod_origen   ,
       ot.nro_orden    ,
       ot.fec_solicitud,
       ot.fec_inicio   ,
       ot.cod_usr      ,
       ot.nro_solicitud,
       ot.ot_adm       ,
       ot.ot_tipo      ,
       ot.descripcion,
       ota.cod_usr as usuario
  FROM orden_trabajo  ot,
       ot_adm_usuario ota
 WHERE ota.ot_adm   = ot.ot_adm
   and ot.flag_estado in ('1','3');

prompt
prompt Creating view VW_PROVEEDOR_GUIA_RECEP
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_PROVEEDOR_GUIA_RECEP AS
SELECT DISTINCT
       PDD.PROVEEDOR,
       P.NOM_PROVEEDOR,
       PD.COD_ORIGEN
FROM  AP_PD_DESCARGA_DET       PDD,
      AP_PD_DESCARGA           PD,
      PROVEEDOR                P,
      (SELECT DD.NRO_PARTE, DD.ITEM
         FROM AP_PD_DESCARGA_DET DD
       MINUS
       SELECT RD.NRO_PARTE, RD.ITEM_PARTE
         FROM AP_GUIA_RECEPCION_DET RD) DET
WHERE PD.NRO_PARTE = PDD.NRO_PARTE
  AND PDD.NRO_PARTE = DET.NRO_PARTE
  AND PDD.ITEM = DET.ITEM
  AND PDD.PROVEEDOR = P.PROVEEDOR
  AND P.FLAG_ESTADO = '1';

prompt
prompt Creating view VW_PROVEEDOR_NAVE
prompt ===============================
prompt
create or replace force view cantabria.vw_proveedor_nave as
select p.proveedor, p.nom_proveedor, tn.nave, tn.nomb_nave, p.ruc
	from 	proveedor p,
  			tg_naves tn
where tn.proveedor = p.proveedor;

prompt
prompt Creating view VW_PR_PARTE_DESTAJO
prompt =================================
prompt
create or replace force view cantabria.vw_pr_parte_destajo as
select distinct po.nro_parte as parte, to_char(po.fecha, 'dd/mm/yyyy hh24:mi') as fec
      from pd_ot po
         inner join pd_ot_asist_destajo poa on po.nro_parte = poa.nro_parte;

prompt
prompt Creating view VW_PR_PARTE_DESTAJO_CAB
prompt =====================================
prompt
create or replace force view cantabria.vw_pr_parte_destajo_cab as
select p.nro_parte, to_char(p.fecha, 'dd/mm/yyyy') as fecha_c, a.descripcion, p.fecha
      from pd_ot p
         left outer join ot_administracion a on p.ot_adm = a.ot_adm;

prompt
prompt Creating view VW_PR_PARTE_PISO
prompt ==============================
prompt
create or replace force view cantabria.vw_pr_parte_piso as
select decode(pp.flag_tipo, 'PH', 'Harina', 'PG', 'Congelados', 'PC', 'Conservas') as flag_tipo, pp.nro_parte, initcap(trim(t.descripcion)) as descripcion, to_char(pp.fecha_parte, 'dd/mm/yyyy') as parte_fecha
      from tg_parte_piso pp
      left outer join turno t on pp.turno = t.turno
      where pp.flag_tipo in ('PH','PC', 'PG');

prompt
prompt Creating view VW_PR_PARTE_PISO_FMT
prompt ==================================
prompt
create or replace force view cantabria.vw_pr_parte_piso_fmt as
select pp.nro_parte,
          nvl(pp.formato, 'N/A') as parte_fmt,
          nvl(fma.descripcion, 'N/A') as parte_desc,
          to_char(pp.fecha_parte, 'dd/mm/yyyy') as parte_fecha
      from tg_parte_piso pp
      left outer join tg_fmt_med_act fma on pp.formato = fma.formato;

prompt
prompt Creating view VW_PR_PD_OT_ADM
prompt =============================
prompt
create or replace force view cantabria.vw_pr_pd_ot_adm as
select ot.nro_orden, ot.descripcion as desc_orden, decode(ot.flag_estado,'1', 'ABIERTO', '3', 'PLANEADO') as flag_estado, ot.ot_adm, oa.descripcion as desc_ot_adm, ccs.desc_cencos as desc_cencos_s, ccr.desc_cencos as desc_cencos_r, to_char(ot.fec_solicitud, 'dd/mm/yyyy') as f_solicitud, to_char(ot.fec_estimada, 'dd/mm/yyyy') as f_estimado, to_char(ot.fec_inicio, 'dd/mm/yyyy') as f_inicio
      from orden_trabajo ot
         inner join ot_administracion oa on ot.ot_adm = oa.ot_adm
         left outer join centros_costo ccr on ot.cencos_rsp = ccr.cencos
         left outer join centros_costo ccs on ot.cencos_slc = ccs.cencos
      where ot.flag_estado in ('1','3')
         and ot.ot_adm in ('PRODH', 'PRODG', 'PRODC');

prompt
prompt Creating view VW_PR_PROD_FIN
prompt ============================
prompt
create or replace force view cantabria.vw_pr_prod_fin as
select a."COD_ART",a."NOM_ARTICULO",a."DESC_ART",a."SUB_CAT_ART",a."FLAG_ESTADO",a."FLAG_CNTRL_PRESUP",a."FLAG_REPOSICION",a."FLAG_CRITICO",a."FLAG_OBSOLETO",a."UND",a."COD_CLASE",a."COD_ORIGEN",a."PESO_UND",a."VOL_UND",a."SLDO_TOTAL",a."SLDO_POR_LLEGAR",a."SLDO_SOLICITADO",a."SLDO_DEVUELTO",a."SLDO_PRESTAMO",a."SLDO_CONSIGNACION",a."SLDO_RESERVADO",a."FEC_ULT_COMPRA",a."FEC_ULT_SALIDA",a."NRO_ULTIMA_OC",a."CNTA_PRSP",a."SLDO_MINIMO",a."SLDO_MAXIMO",a."DIAS_REPOSICION",a."DIAS_REP_IMPORT",a."CNT_COMPRA_REC",a."FILE_IMAGEN",a."FLAG_INVENTARIABLE",a."FLAG_UND2",a."FLAG_CNTRL_LOTE",a."UND2",a."FACTOR_CONV_UND",a."SLDO_TOTAL_UND2",a."FLAG_REPLICACION",a."FLAG_CNTRL_REQ",a."NIVEL_APROB",a."COSTO_PROM_SOL",a."COSTO_PROM_DOL",a."COSTO_ULT_COMPRA",a."FEC_REGISTRO",a."SLDO_WARRANTEADO", b.desc_prodfin
from articulo a,
     tg_producto_final b
where a.cod_art = b.cod_art
  and b.flag_estado = '1';

prompt
prompt Creating view VW_PR_PROD_FINAL_X_OT
prompt ===================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_PR_PROD_FINAL_X_OT AS
SELECT PD_OT_PROD_FINAL.NRO_PARTE,
       PD_OT_PROD_FINAL.NRO_ITEM,
       PD_OT_PROD_FINAL.COD_PRODUCTO,
       TIPO_PRODUCTO.DESC_PROD,
       PD_OT_PROD_FINAL.CANTIDAD,
       PD_OT_DET.DESC_LABOR
  FROM  PD_OT_PROD_FINAL,
        TIPO_PRODUCTO,
        PD_OT_DET
 WHERE PD_OT_PROD_FINAL.COD_PRODUCTO    = TIPO_PRODUCTO.COD_PROD
   AND PD_OT_PROD_FINAL.NRO_ITEM        = PD_OT_DET.NRO_ITEM
   AND PD_OT_PROD_FINAL.NRO_PARTE       = PD_OT_DET.NRO_PARTE
 ORDER BY PD_OT_PROD_FINAL.NRO_ITEM     ASC,
          PD_OT_PROD_FINAL.COD_PRODUCTO ASC;

prompt
prompt Creating view VW_PR_SEMANAS_PROD
prompt ================================
prompt
create or replace force view cantabria.vw_pr_semanas_prod as
select s.ano, s.mes, s.semana, s.fecha_inicio, s.fecha_fin
from semanas s;

prompt
prompt Creating view VW_PR_SERVICIOS_X_OT
prompt ==================================
prompt
create or replace force view cantabria.vw_pr_servicios_x_ot as
select os.nro_os,
       decode(length(osd.descripcion), 0, os.descripcion, 1, os.descripcion,
              osd.descripcion) as descripcion,
       op.nro_orden,
       os.fec_registro as fecha,
       os.cod_moneda,
       usf_fl_conv_mon( Nvl(osd.importe,0) - Nvl(osd.decuento,0) + Nvl(osd.impuesto,0)
              + Nvl(osd.impuesto2,0), os.cod_moneda, (select cod_dolares from logparam where reckey = '1'),
              os.fec_registro )as Total
from orden_servicio os,
     orden_servicio_det osd,
     operaciones op
where os.nro_os = osd.nro_os
  and op.oper_sec = osd.oper_sec;

prompt
prompt Creating view VW_PR_TIEMPO_USO
prompt ==============================
prompt
create or replace force view cantabria.vw_pr_tiempo_uso as
select decode(pp.flag_tipo, 'TH', 'HARINA', 'TG', 'CONGELADOS', 'TC', 'CONSERVAS') as flag_tipo, pp.nro_parte, UPPER(trim(t.descripcion)) as descripcion, to_char(pp.fecha_parte, 'dd/mm/yyyy') as parte_fecha
      from tg_parte_piso pp
      left outer join turno t on pp.turno = t.turno
      where pp.flag_tipo in ('TH','TC', 'TG');

prompt
prompt Creating view VW_PR_TRAB_DESTAJO_X_OT
prompt =====================================
prompt
create or replace force view cantabria.vw_pr_trab_destajo_x_ot as
select pdad.nro_parte,
       pdad.cod_trabajador,
       cr.nombre,
       Nvl(pdad.cant_destajada, 0) as Cant_destajada,
       usf_fl_conv_mon( Nvl(pdad.tarifa_normal,0) ,
                  (select cod_soles from logparam where reckey = '1'),
                  (select cod_dolares from logparam where reckey = '1'),
                  pd.fecha ) as costo_unit,
       la.cod_labor as linea_destajo,
       la.desc_labor as descr_linea,
       op.oper_sec,
       op.nro_orden,
       pdot.flag_terminado,
       usf_fl_conv_mon( (Nvl(pdad.cant_destajada, 0) * Nvl(pdad.tarifa_normal,0) ),
                        (select cod_soles from logparam where reckey = '1'),
                        (select cod_dolares from logparam where reckey = '1'),
                        pd.fecha ) as total_costo,
       pdad.nro_item,
       Nvl(pdad.cant_destajada, 0) * Nvl(pdad.tarifa_normal,0)as Costo_Soles,
       la.und as unidad_destajo
from pd_ot_asist_destajo pdad,
     codigo_relacion     cr,
     pd_ot_det           pdot,
     operaciones         op,
     labor               la,
     pd_ot               pd
where cr.cod_relacion  = pdad.cod_trabajador
  and la.cod_labor= pdot.cod_labor
  and pdot.nro_item    = pdad.nro_item
  and pdot.nro_parte   = pdad.nro_parte
  and op.oper_sec      = pdot.oper_sec
  and pd.nro_parte     = pdot.nro_parte
  and la.flag_maq_mo   = 'O'
  and la.und           <> (select und_hr from prod_param where reckey = '1');

prompt
prompt Creating view VW_PR_TRAB_DEST_X_PD_OT
prompt =====================================
prompt
create or replace force view cantabria.vw_pr_trab_dest_x_pd_ot as
select a.nro_parte,
       a.cod_trabajador,
       cr.nombre,
       la.cod_labor,
       la.desc_labor as descr_linea,
       a.cant_destajada,
       op.oper_sec,
       op.desc_operacion,
       la.und,
       pd.fecha,
       op.fec_inicio,
       a.nro_item,
       pdot.hora_inicio
from pd_ot_asist_destajo a,
     codigo_relacion     cr,
     labor               la,
     pd_ot_det           pdot,
     operaciones         op,
     pd_ot               pd
where cr.cod_relacion    = a.cod_trabajador
  and la.cod_labor       = pdot.cod_labor
  and pdot.nro_item      = a.nro_item
  and pdot.nro_parte     = a.nro_parte
  and op.oper_sec        = pdot.oper_sec
  and pd.nro_parte       = pdot.nro_parte;

prompt
prompt Creating view VW_PR_TRAB_JORNAL_X_OT
prompt ====================================
prompt
create or replace force view cantabria.vw_pr_trab_jornal_x_ot as
select pa.cod_trabajador,
       cr.nombre,
       NVL(pa.nro_horas,0) AS NRO_HORAS,
       usf_fl_conv_mon( NVL(pa.costo_horas,0),
                 (select cod_soles from logparam where reckey= '1'),
                 (select cod_dolares from logparam where reckey = '1'), pd.fecha ) AS COSTO_HORAS,
       NVL(pa.factor,0) AS FACTOR,
       usf_fl_conv_mon( (NVL(pa.nro_horas,0) * NVL(pa.costo_horas,0) * NVL(pa.factor,0)),
                 (select cod_soles from logparam where reckey= '1'),
                 (select cod_dolares from logparam where reckey = '1'), pd.fecha ) AS TOTAL,
       (NVL(pa.nro_horas,0) * NVL(pa.factor,0)) as hora_factor,
       pa.no_parte as nro_parte,
       pdot.oper_sec,
       op.nro_orden
from pd_ot_asistencia pa,
     codigo_relacion  cr,
     pd_ot_det        pdot,
     operaciones      op,
     labor            la,
     pd_ot            pd
where cr.cod_relacion = pa.cod_trabajador
  and pdot.nro_item   = pa.nro_item
  and pdot.nro_parte  = pa.no_parte
  and op.oper_sec     = pdot.oper_sec
  and la.cod_labor    = op.cod_labor
  and pd.nro_parte    = pdot.nro_orden
  and la.flag_maq_mo  = 'O'
  and la.und          = (select und_hr from prod_param where reckey = '1');

prompt
prompt Creating view VW_PR_TRAB_JORNAL_X_PD_OT
prompt =======================================
prompt
create or replace force view cantabria.vw_pr_trab_jornal_x_pd_ot as
select a.no_parte as nro_parte,
       a.cod_trabajador,
       cr.nombre,
       a.nro_horas,
       op.oper_sec,
       op.desc_operacion,
       pdot.desc_labor,
       pd.fecha,
       op.fec_inicio,
       a.nro_item,
       pdot.cod_labor,
       pdot.hora_inicio
from pd_ot_asistencia a,
     codigo_relacion     cr,
     pd_ot_det           pdot,
     operaciones         op,
     pd_ot               pd
where cr.cod_relacion    = a.cod_trabajador
  and pdot.nro_item     = a.nro_item
  and pdot.nro_parte    = a.no_parte
  and op.oper_sec       = pdot.oper_sec
  and pd.nro_parte      = pdot.nro_parte;

prompt
prompt Creating view VW_PR_TURNOS
prompt ==========================
prompt
create or replace force view cantabria.vw_pr_turnos as
select t.turno, trim(t.descripcion) || ' / ' || to_char(t.hora_inicio_norm, 'hh24:mi') || ' - ' || to_char(t.hora_final_norm, 'hh24:mi') as descripcion
      from turno t
      where t.flag_estado = '1';

prompt
prompt Creating view VW_PTO_PRESUP_CAJA_EJEC
prompt =====================================
prompt
create or replace force view cantabria.vw_pto_presup_caja_ejec as
select cb.nro_registro,
         cb.cod_ctabco,
         b.nom_banco,
         cb.fecha_emision,
         cbd.cod_relacion,
         p.nom_proveedor,
         p.ruc,
         cbd.tipo_doc,
         cbd.nro_doc,
         cbd.cod_moneda,
         cbd.importe,
         pcd.cod_moneda as moneda_prsp,
         cb.tasa_cambio,
         case
           when pcd.cod_moneda = cbd.cod_moneda then
             cbd.importe
           when pcd.cod_moneda = (select cod_dolares from logparam where reckey = '1') then
             cbd.importe / cb.tasa_cambio
           when pcd.cod_moneda = (select cod_soles from logparam where reckey = '1') then
             cbd.importe * cb.tasa_cambio
         end as imp_ejecutado,
         pcd.nro_presupuesto,
         pcd.nro_item
  from caja_bancos cb,
       caja_bancos_det cbd,
       proveedor       p,
       banco_cnta      bc,
       banco           b,
       prsp_caja_det   pcd,
       prsp_caja       pc
  where cb.origen = cbd.origen
    and cb.nro_registro = cbd.nro_registro
    and cbd.cod_relacion = p.proveedor (+)
    and cb.cod_ctabco    = bc.cod_ctabco (+)
    and bc.cod_banco     = b.cod_banco   (+)
    and cbd.nro_prsp     = pcd.nro_presupuesto
    and cbd.item_prsp    = pcd.nro_item
    and pcd.nro_presupuesto = pc.nro_presupuesto
    and cb.flag_estado <> '0'
    --and cbd.nro_prsp = 'PA00000025'
    --and cbd.item_prsp in (6, 5)
;

prompt
prompt Creating view VW_PTO_PRESUP_MATERIALES_DET
prompt ==========================================
prompt
create or replace force view cantabria.vw_pto_presup_materiales_det as
select t.ano, t.cencos, t.cnta_prsp, t.cod_art,
   avg(t.costo_unit) as precio_prom,
   sum(decode( t.mes_corresp,1, NVL(cantidad,0),0)) as ene,
   sum(decode( t.mes_corresp,2, NVL(cantidad,0),0)) as feb,
   sum(decode( t.mes_corresp,3, NVL(cantidad,0),0)) as mar,
   sum(decode( t.mes_corresp,4, NVL(cantidad,0),0)) as abr,
   sum(decode( t.mes_corresp,5, NVL(cantidad,0),0)) as may,
   sum(decode( t.mes_corresp,6, NVL(cantidad,0),0)) as jun,
   sum(decode( t.mes_corresp,7, NVL(cantidad,0),0)) as jul,
   sum(decode( t.mes_corresp,8, NVL(cantidad,0),0)) as ago,
   sum(decode( t.mes_corresp,9, NVL(cantidad,0),0)) as seti,
   sum(decode( t.mes_corresp,10, NVL(cantidad,0),0)) as oct,
   sum(decode( t.mes_corresp,11, NVL(cantidad,0),0)) as nov,
   sum(decode( t.mes_corresp,12, NVL(cantidad,0),0)) as dic
 from presupuesto_det t
 group by ano, cencos, cnta_prsp, cod_art;

prompt
prompt Creating view VW_PTO_VARIACIONES
prompt ================================
prompt
create or replace force view cantabria.vw_pto_variaciones as
select t.cencos_origen as cencos,
       t.cnta_prsp_origen as cnta_prsp,
       t.fecha,
       DECODE(t.tipo_variacion, 'A', t.importe, t.importe * - 1) as importe,
       t.descripcion,
       t.nro_variacion,
       t.tipo_variacion,
       t.mes_origen as mes,
       t.ano,
       t.mes_destino,
       t.cencos_destino,
       t.cnta_prsp_destino,
       t.cod_usr,
       t.centro_benef
  from PRESUP_VARIACION t
UNION
select t.cencos_destino as cencos,
       t.cnta_prsp_destino as cnta_prsp,
       t.fecha,
       t.importe as importe,
       t.descripcion,
       t.nro_variacion,
       t.tipo_variacion,
       t.mes_destino as mes,
       t.ano,
       null as mes_destino,
       '' as cencos_destino,
       '' as cnta_prsp_destino,
       t.cod_usr,
       t.centro_benef
  from PRESUP_VARIACION t
  where t.tipo_variacion = 'T';

prompt
prompt Creating view VW_REGISTRO_OC_OS
prompt ===============================
prompt
create or replace force view cantabria.vw_registro_oc_os as
select 'OC' as tipo_doc,
       u.nombre as cod_usr,
       oc.nro_oc as nro_doc,
       oc.observacion as glosa,
       trunc(oc.fec_registro) as fec_registro,
       to_char(oc.fec_registro, 'hh24') || ':00' as hora,
       to_number(to_char(amp.fec_proyect, 'yyyy')) as ano,
       case
         	when to_number(to_char(amp.fec_proyect, 'mm')) = 1 then '01.Ene'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 2 then '02.Feb'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 3 then '03.Mar'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 4 then '04.Abr'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 5 then '05.May'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 6 then '06.Jun'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 7 then '07.Jul'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 8 then '08.Ago'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 9 then '09.Set'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 10 then '10.Oct'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 11 then '11.Nov'
          when to_number(to_char(amp.fec_proyect, 'mm')) = 12 then '12.Dic'
       end as mes,
       case
         when oc.flag_importacion = '1' then 'Importacion'
         else 'Local'
       end as Mercado,
       --to_number(to_char(amp.fec_proyect, 'mm')) as mes,
       count(distinct oc.nro_oc) as nro_registros,
       sum(usf_fl_conv_mon(amp.cant_proyect * amp.precio_unit, oc.cod_moneda, (select cod_soles from logparam where reckey = '1'), oc.fec_registro)) as importe_sol,
       sum(usf_fl_conv_mon(amp.cant_proyect * amp.precio_unit, oc.cod_moneda, (select cod_dolares from logparam where reckey = '1'), oc.fec_registro)) as importe_dol,
       sum(usf_fl_conv_mon(amp.impuesto+ amp.impuesto2, oc.cod_moneda, (select cod_soles from logparam where reckey = '1'), oc.fec_registro)) as impuesto_sol,
       sum(usf_fl_conv_mon(amp.impuesto+ amp.impuesto2, oc.cod_moneda, (select cod_dolares from logparam where reckey = '1'), oc.fec_registro)) as impuesto_dol
from orden_compra oc,
     articulo_mov_proy amp,
     usuario u
where oc.nro_oc = amp.nro_doc
  and oc.cod_usr = u.cod_usr
  and amp.tipo_doc in (select doc_oc from logparam where reckey = '1')
  and oc.flag_estado <> '0'
  and amp.flag_estado <> '0'
group by u.nombre,
         oc.nro_oc,
         oc.observacion,
         trunc(oc.fec_registro),
         to_char(oc.fec_registro, 'hh24') || ':00',
         to_number(to_char(amp.fec_proyect, 'yyyy')),
         to_number(to_char(amp.fec_proyect, 'mm')),
         oc.flag_importacion
union
select 'OS' as titulo,
       u.nombre as cod_usr,
       os.nro_os as nro_doc,
       os.descripcion as glosa,
       trunc(os.fec_registro) as fec_registro,
       to_char(os.fec_registro, 'hh24') || ':00' as hora,
       to_number(to_char(osd.fec_proyect, 'yyyy')) as ano,
       --to_number(to_char(osd.fec_proyect, 'mm')) as mes,
       case
         	when to_number(to_char(osd.fec_proyect, 'mm')) = 1 then '01.Ene'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 2 then '02.Feb'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 3 then '03.Mar'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 4 then '04.Abr'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 5 then '05.May'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 6 then '06.Jun'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 7 then '07.Jul'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 8 then '08.Ago'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 9 then '09.Set'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 10 then '10.Oct'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 11 then '11.Nov'
          when to_number(to_char(osd.fec_proyect, 'mm')) = 12 then '12.Dic'
       end as mes,
       '' as Mercado,
       count(distinct os.nro_os) as nro_registros,
       sum(usf_fl_conv_mon(osd.importe, os.cod_moneda, (select cod_soles from logparam where reckey = '1'), os.fec_registro)) as cant_comprada_sol,
       sum(usf_fl_conv_mon(osd.importe, os.cod_moneda, (select cod_dolares from logparam where reckey = '1'), os.fec_registro)) as cant_comprada_dol,
       sum(usf_fl_conv_mon(osd.impuesto + osd.impuesto2, os.cod_moneda, (select cod_soles from logparam where reckey = '1'), os.fec_registro)) as impuesto_sol,
       sum(usf_fl_conv_mon(osd.impuesto+ osd.impuesto2, os.cod_moneda, (select cod_dolares from logparam where reckey = '1'), os.fec_registro)) as impuesto_dol
  from orden_servicio os,
       orden_servicio_Det osd,
       usuario u
where os.nro_os = osd.nro_os
  and os.cod_usr = u.cod_usr
  and os.flag_estado <> '0'
  and osd.flag_estado <> '0'
group by u.nombre,
         os.nro_os,
         os.descripcion,
         trunc(os.fec_registro),
         to_char(os.fec_registro, 'hh24') || ':00',
         to_number(to_char(osd.fec_proyect, 'yyyy')),
         to_number(to_char(osd.fec_proyect, 'mm'))
;

prompt
prompt Creating view VW_REGISTRO_PARTES_DST
prompt ====================================
prompt
create or replace force view cantabria.vw_registro_partes_dst as
select p.cod_cuadrilla,
       u.nombre as cod_usr,
       trunc(p.fec_registro) as fec_registro,
       trunc(p.fec_parte) as fec_parte,
       count(distinct p.nro_parte) as nro_partes,
       count(distinct pd.cod_trabajador) as nro_trabajadores,
       avg(((select max(l.fecha)
          from log_diario l
         where trunc(l.fecha) = trunc(p.fec_registro)
           and l.cod_usr      = p.cod_usr
           and l.tabla        like '%tg_pd_destajo_det%'
           and l.llave        like '%' || p.nro_parte || '%') -
       (select min(l.fecha)
          from log_diario l
         where trunc(l.fecha) = trunc(p.fec_registro)
           and l.cod_usr      = p.cod_usr
           and l.tabla        like '%tg_pd_destajo_det%'
           and l.llave        like '%' || p.nro_parte || '%')) * 24 * 60) as tiempo_registro
from tg_pd_destajo p,
     tg_pd_destajo_det pd,
     usuario           u
where p.nro_parte = pd.nro_parte
  and u.cod_usr   = p.cod_usr
group by p.cod_cuadrilla,
         u.nombre,
         trunc(p.fec_registro),
         trunc(p.fec_parte);

prompt
prompt Creating view VW_REGISTRO_PROVISION
prompt ===================================
prompt
create or replace force view cantabria.vw_registro_provision as
select trunc(cp.fecha_registro) as fecha,
       cp.origen,
       --cp.ano,
       DECODE(cp.ano, NULL, to_number(to_char(cp.fecha_emision, 'yyyy')), cp.ano) as ano,
       --cp.mes,
       case
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 1 then '01.Ene'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 2 then '02.Feb'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 3 then '03.Mar'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 4 then '04.Abr'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 5 then '05.May'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 6 then '06.Jun'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 7 then '07.Jul'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 8 then '08.Ago'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 9 then '09.Set'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 10 then '10.Oct'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 11 then '11.Nov'
          when DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes) = 12 then '12.Dic'
       end as mes,
       u.nombre as cod_usr,
       u.cod_usr as  usuario,
       count(*) as nro_registros,
       case
         when cp.ano is null and cp.mes is null then
           'DOCUMENTO POR PAGAR DIRECTO'
         else
           'PROVISION'
       end as titulo
from cntas_pagar cp,
     usuario     u
where cp.cod_usr = u.cod_usr
  and cp.flag_estado <> '0'
group by trunc(cp.fecha_registro),
       cp.origen,
       DECODE(cp.ano, NULL, to_number(to_char(cp.fecha_emision, 'yyyy')), cp.ano),
       cp.ano, cp.mes,
       DECODE(cp.mes, NULL, to_number(to_char(cp.fecha_emision, 'mm')), cp.mes),
       u.nombre, u.cod_usr
order by 1 desc, 2
;

prompt
prompt Creating view VW_RH_AFP
prompt =======================
prompt
create or replace force view cantabria.vw_rh_afp as
select c.cod_trabajador, decode(m.flag_estado,'1','01','0','02') as tipo ,
       decode(m.flag_estado,'1',m.fec_ingreso,'0',m.fec_cese) as fecha_inegre,
       trunc(c.fec_proceso) as fecha,
       (select trim(concep_calculo_afp) from rrhhparam_cconcep where reckey = '1') as grupo_calculo,
       sum(c.imp_soles) as importe,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_cese,'yyyymm'),m.fec_cese,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),m.fec_ingreso,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_VAC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_LIC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),null  )))) as fecha_afp,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_cese,'yyyymm'),'02',
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),'01',
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'05',
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'04',
       null )))) as codigo_afp
  from calculo c
  inner join maestro m
     on c.cod_trabajador = m.cod_trabajador
  where --nvl(m.flag_estado,'0') = '1' and
        trim(nvl(m.cod_afp,' ')) <> ' '
        and c.concep in ( select trim(d.concepto_calc) from grupo_calculo_det d where d.grupo_calculo = (select trim(concep_calculo_afp) from rrhhparam_cconcep where reckey = '1'))
   group by c.cod_trabajador,m.flag_estado ,m.fec_ingreso,m.fec_cese,trunc(c.fec_proceso) ,to_char(c.fec_proceso,'yyyymm'),m.cod_origen,m.tipo_trabajador
union all
select hc.cod_trabajador,decode(m.flag_estado,'1','01','0','02') as tipo ,decode(m.flag_estado,'1',m.fec_ingreso,'0',m.fec_cese) as fecha_inegre, trunc(hc.fec_calc_plan) as fecha, (select trim(concep_calculo_afp) from rrhhparam_cconcep where reckey = '1') as grupo_calculo, sum(hc.imp_soles) as importe,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_cese,'yyyymm'),m.fec_cese,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),m.fec_ingreso,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_VAC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_LIC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),null  )))) as fecha_afp,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_cese,'yyyymm'),'02',
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),'01',
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'05',
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'04', null )))) as codigo_afp
  from historico_calculo hc
  inner join maestro m
     on hc.cod_trabajador = m.cod_trabajador
  where --nvl(m.flag_estado,'0') = '1' and
        trim(nvl(m.cod_afp,' ')) <> ' '
        and hc.concep in ( select trim(d.concepto_calc) from grupo_calculo_det d where d.grupo_calculo = (select trim(concep_calculo_afp) from rrhhparam_cconcep where reckey = '1'))
   group by hc.cod_trabajador,m.flag_estado ,m.fec_ingreso,m.fec_cese,trunc(hc.fec_calc_plan),to_char(hc.fec_calc_plan,'yyyymm'),m.cod_origen,m.tipo_trabajador
union all
select c.cod_trabajador,decode(m.flag_estado,'1','01','0','02') as tipo ,decode(m.flag_estado,'1',m.fec_ingreso,'0',m.fec_cese) as fecha_inegre, trunc(c.fec_proceso) as fecha, gc.grupo_calculo, sum(c.imp_soles) as importe,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_cese,'yyyymm'),m.fec_cese,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),m.fec_ingreso,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_VAC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_LIC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),null )))) as fecha_afp,
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_cese,'yyyymm'),'02',
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),'01',
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'05',
       decode(to_char(c.fec_proceso,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(c.fec_proceso,'yyyymm'),c.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'04', null )))) as codigo_afp
   from calculo c
   inner join grupo_calculo gc
      on c.concep = gc.concepto_gen
   inner join maestro m
      on c.cod_trabajador = m.cod_trabajador
   where c.concep in (select trim(gc.concepto_gen) from grupo_calculo gc where gc.grupo_calculo in
         (select trim(afp_jubilacion) from rrhhparam_cconcep where reckey = '1'
          union
          select trim(afp_invalidez) from rrhhparam_cconcep where reckey = '1'
          union
          select trim(afp_comision) from rrhhparam_cconcep where reckey = '1')     )
      --and nvl(m.flag_estado,'0') = '1'
      and trim(nvl(m.cod_afp,' ')) <> ' '
   group by c.cod_trabajador,m.flag_estado ,m.fec_ingreso,m.fec_cese,  gc.grupo_calculo,trunc(c.fec_proceso),to_char(c.fec_proceso,'yyyymm'),m.cod_origen,m.tipo_trabajador
union all
select hc.cod_trabajador,decode(m.flag_estado,'1','01','0','02') as tipo ,
       decode(m.flag_estado,'1',m.fec_ingreso,'0',m.fec_cese) as fecha_inegre,
       trunc(hc.fec_calc_plan) as fecha,
       gc.grupo_calculo, sum(hc.imp_soles) as importe,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_cese,'yyyymm'),m.fec_cese,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),m.fec_ingreso,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_VAC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),USF_RRHH_FECHA_LIC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),null )))) as fecha_afp,
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_cese,'yyyymm'),'02',
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(m.fec_ingreso,'yyyymm'),'01',
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_VAC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'05',
       decode(to_char(hc.fec_calc_plan,'yyyymm'),to_char(USF_RRHH_FECHA_LIC(to_char(hc.fec_calc_plan,'yyyymm'),hc.cod_trabajador,m.cod_origen,m.tipo_trabajador),'yyyymm'),'04', null )))) as codigo_afp
  from historico_calculo hc inner join grupo_calculo gc  on hc.concep = gc.concepto_gen
                            inner join maestro m         on hc.cod_trabajador = m.cod_trabajador
                            left outer join calculo c    on hc.cod_trabajador = c.cod_trabajador
                                  and hc.concep = c.concep
                                  and trunc(hc.fec_calc_plan) = trunc(c.fec_proceso)
   where hc.concep in (select trim(gc.concepto_gen) from grupo_calculo gc where gc.grupo_calculo in (select trim(afp_jubilacion) from rrhhparam_cconcep where reckey = '1'
                                                                                               union
                                                                                               select trim(afp_invalidez) from rrhhparam_cconcep where reckey = '1'
                                                                                               union
                                                                                               select trim(afp_comision) from rrhhparam_cconcep where reckey = '1'))
      and c.concep is null
      and trim(nvl(m.cod_afp,' ')) <> ' '
   group by hc.cod_trabajador,m.flag_estado ,m.fec_ingreso,m.fec_cese, gc.grupo_calculo,trunc(hc.fec_calc_plan),to_char(hc.fec_calc_plan,'yyyymm'),m.cod_origen,m.tipo_trabajador
;

prompt
prompt Creating view VW_RH_AFP_COLS
prompt ============================
prompt
create or replace force view cantabria.vw_rh_afp_cols as
select vra.cod_trabajador,
      trunc(vra.fecha) as fecha,
      vra.tipo,
      vra.fecha_inegre,
      decode(vra.grupo_calculo,(select trim(afp_jubilacion) from rrhhparam_cconcep where reckey ='1'),sum(importe),0)     as GC033,
      decode(vra.grupo_calculo,(select trim(afp_invalidez) from rrhhparam_cconcep where reckey ='1'),sum(importe),0)      as GC034,
      decode(vra.grupo_calculo,(select trim(afp_comision) from rrhhparam_cconcep where reckey ='1'),sum(importe),0)       as GC035,
      decode(vra.grupo_calculo,(select trim(concep_calculo_afp) from rrhhparam_cconcep where reckey ='1'),sum(importe),0) as GC036,
      vra.fecha_afp ,
      vra.codigo_afp
from vw_rh_afp vra
group by vra.cod_trabajador,trunc(vra.fecha),vra.tipo,vra.fecha_inegre, vra.grupo_calculo,vra.fecha_afp,vra.codigo_afp;

prompt
prompt Creating view VW_RH_AFP_TOTS
prompt ============================
prompt
create or replace force view cantabria.vw_rh_afp_tots as
select vrac.cod_trabajador,
       vrac.fecha,
       vrac.tipo,
       vrac.fecha_inegre,
       sum(vrac.gc033) as Aporte_obligatorio,
       sum(vrac.gc034) as Seguros,
       sum(vrac.gc035) as Comision_porcent,
       sum(vrac.gc036) as Remuneracion_asegurable ,
       vrac.fecha_afp,
       vrac.codigo_afp
from vw_rh_afp_cols vrac
group by vrac.cod_trabajador, vrac.fecha,vrac.fecha_inegre,vrac.tipo,vrac.fecha_afp,vrac.codigo_afp;

prompt
prompt Creating view VW_RH_CMP_HRS_SOBRET
prompt ==================================
prompt
create or replace force view cantabria.vw_rh_cmp_hrs_sobret as
select c.concep, c.desc_concep
      from concepto c
      where c.concep in (
         select gcd.concepto_calc
            from grupo_calculo_det gcd
            where gcd.grupo_calculo = (
               select rhc.sobret_compens_hrs
               from rrhhparam_cconcep rhc
               where rhc.reckey = '1'));

prompt
prompt Creating view VW_RH_CONCEP_LABOR
prompt ================================
prompt
create or replace force view cantabria.vw_rh_concep_labor as
select trunc(pod.hora_fin) as fecha_labor, poa.cod_trabajador, l.concepto_rrhh, pod.cod_labor, pod.cant_labor, u.desc_unidad
      from pd_ot_det pod
         inner join pd_ot_asistencia poa on pod.nro_item = poa.nro_item and pod.nro_parte = poa.no_parte
         inner join labor l on pod.cod_labor = l.cod_labor
         inner join concepto c on l.concepto_rrhh = c.concep
         left outer join unidad u on l.und = u.und;

prompt
prompt Creating view VW_RH_CTA_CTE
prompt ===========================
prompt
create or replace force view cantabria.vw_rh_cta_cte as
select cod_relacion, d.desc_tipo_doc, nro_doc, fecha_doc,  cod_moneda, decode(cod_moneda, (select l.cod_soles from logparam l where l.reckey = '1'), sldo_sol, saldo_dol) as importe
      from doc_pendientes_cta_cte c
         inner join doc_tipo d on c.tipo_doc = d.tipo_doc
      where c.flag_debhab = 'D';

prompt
prompt Creating view VW_RH_DEVENGADO_DET
prompt =================================
prompt
create or replace force view cantabria.vw_rh_devengado_det as
select a.ano,
         case
           when a.mes = '1' then '01.Enero'
           when a.mes = '2' then '02.Febrero'
           when a.mes = '3' then '03.Marzo'
           when a.mes = '4' then '04.Abril'
           when a.mes = '5' then '05.Mayo'
           when a.mes = '6' then '06.Junio'
           when a.mes = '7' then '07.Julio'
           when a.mes = '8' then '08.Agosto'
           when a.mes = '9' then '09.Setiembre'
           when a.mes = '10' then '10.Octubre'
           when a.mes = '11' then '11.Noviembre'
           when a.mes = '12' then '12.Diciembre'
         end as mes  ,
         a.cod_trabajador,
         m.NOM_TRABAJADOR,
         m.TIPO_TRABAJADOR, tt.desc_tipo_tra,
         case when a.tipo_devengado = 'G' then '1.Gratificacion'
              when a.tipo_devengado = 'V' then '2.Vacaciones'
              when a.tipo_devengado = 'C' then '3.CTS'
         end as tipo_devengado,
         a.parte_fija,
         a.parte_variable,
         a.gratificacion,
         a.importe

  from rh_devengados_mes a,
       vw_pr_trabajador  m,
       tipo_trabajador   tt
  where a.cod_trabajador = m.cod_trabajador
    and m.tipo_trabajador = tt.tipo_trabajador
  order by ano, mes, tipo_devengado, tipo_trabajador, NOM_TRABAJADOR;

prompt
prompt Creating view VW_RH_EXP_FORMULA_DET
prompt ===================================
prompt
create or replace force view cantabria.vw_rh_exp_formula_det as
select f.cod_formula, f.descripcion, decode(flag_cabecera, '1', 'CABECERA', 'DETALLE') as cabecera
      from rh_exp_formula f
      where f.flag_estado = '1';

prompt
prompt Creating view VW_RH_FICHA_TRABAJADOR
prompt ====================================
prompt
create or replace force view cantabria.vw_rh_ficha_trabajador as
Select
       m.cod_trabajador,
       upper(m.cod_trabajador) as codigo,
       upper(m.cod_trab_antguo) as cod_antiguo,
       upper(m.apel_paterno) as paterno,
       upper(m.apel_materno) as materno,
       upper(m.nombre1) as nombre1,
       upper(m.nombre2) as nombre2,
       m.flag_estado_civil,
       decode(m.flag_estado_civil, 'C', 'CASADO(A)', 'S', 'SOLTERO(A)', 'V', 'VIUDO(A)', 'D', 'DIVORCIADO(A)', 'OTRO') as estado_civil,
       decode(m.flag_cal_plnlla, '1', 'SI', 'NO') as planilla,
       decode(m.flag_sindicato, '1', 'SI', 'NO') as sindicato,
       m.fec_nacimiento,
       to_char(m.fec_nacimiento, 'dd/mm/yyyy') as nacimiento,
       decode(m.flag_estado, '1', 'ACTIVO', 'INACTIVO') as estado,
       m.fec_ingreso,
       to_char(m.fec_ingreso, 'dd/mm/yyyy') as ingreso,
       m.fec_cese,
       to_char(m.fec_cese, 'dd/mm/yyyy') as cese,
       upper(mc.desc_motiv_cese) as motivo_cese,
       m.flag_sexo,
       decode(m.flag_sexo, 'M', 'MASCULINO', 'FEMENINO') as sexo,
       upper(m.direccion) as direccion_postal,
       m.cod_ciudad as disc_ciu,
       m.telefono1 as tel_princ,
       m.telefono2 as tel_sec,
       m.dni as dni,
       m.lib_militar as lib_milit,
       m.ruc as ruc,
       lower(m.email) as correo_electronico,
       upper(tb.desc_brev) as tipo_brevete,
       upper(m.nro_brevete) as nro_brevete,
       m.carnet_trabaj as carnet,
       m.nro_ipss as seguro_social,
       upper(gi.desc_instruc) as grado_instruccion,
       upper(p.desc_profesion) as profesion,
       upper(c.desc_cargo) as cargo,
       upper(st.desc_sit_trab) as situacion_trabajador,
       m.cod_afp,
       upper(aa.desc_afp) as afp,
       upper(m.nro_afp_trabaj) as nro_afp,
       m.fec_ini_afil_afp,
       to_char(m.fec_ini_afil_afp, 'dd/mm/yyyy') as ini_afp,
       to_char(m.fec_fin_afil_afp, 'dd/mm/yyyy') as fin_afp,
       to_char(m.porc_judicial, '990,00') as judicial,
       decode(m.bonif_fija_30_25, '1', '30%', '2', '25%', 'NO PERCIBE') as bonificacion_fija,
       decode(m.flag_quincena, '1', 'SI', 'NO') as quincena,
       m.tipo_trabajador as cod_tipo_trabajador,
       upper(tt.desc_tipo_tra) as tipo_trabajador,
       m.nro_cnta_ahorro as nro_cnta_ahorro,
       m.nro_cnta_cts as nro_cnta_cts,
       upper(mo.descripcion) as moneda_ahorros,
       upper(e.nombre) as empresa,
       upper(l.desc_labor) as labor,
       m.cencos,
       upper(cc.desc_cencos) as centro_costo,
       m.cod_banco,
       upper(b1.nom_banco) as banco_ahorro,
       upper(b2.nom_banco) as banco_cts,
       upper(ts.desc_sangre) as tipo_sangre,
       trim(to_char(cs.imp_categ_min)) || ' - ' || trim(to_char(cs.imp_categ_max)) as categoria_salarial,
       m.cod_area,
       upper(a.desc_area) as area,
       m.cod_seccion,
       upper(s.desc_seccion) as seccion,
       upper(ps.nom_pais) as pais,
       upper(de.desc_dpto) as departamento,
       upper(pc.desc_prov) as provincia,
       upper(cd.descr_ciudad) as ciudad,
       upper(dt.cod_distr) as distrito,
       upper(vd.desc_vivienda) as vivienda,
       upper(tr.descripcion) as turno,
       decode(m.flag_marca_reloj, '1', 'SI', 'NO') as marca_reloj,
       decode(m.flag_convenio, '1', 'SI', 'NO') as convenio,
       decode(m.flag_juicio, '1', 'SI', 'NO') as calcula_sobretirmpo,
       m.cod_origen,
       upper(o.nombre) as origen ,
       m.flag_estado
    from maestro m
       left outer join motivo_cese mc on m.cod_motiv_cese = mc.cod_motiv_cese
       left outer join tipo_brevete tb on m.cod_tipo_brev = tb.cod_tipo_brev
       left outer join grado_instruccion gi on m.cod_grado_inst = gi.cod_grado_inst
       left outer join profesion p on m.cod_profesion = p.cod_profesion
       left outer join cargo c on m.cod_cargo = c.cod_cargo
       left outer join situacion_trabajador st on m.situa_trabaj = st.situa_trabaj
       left outer join admin_afp aa on m.cod_afp = aa.cod_afp
       left outer join tipo_trabajador tt on m.tipo_trabajador = tt.tipo_trabajador
       left outer join moneda mo on m.cod_moneda = mo.cod_moneda
       left outer join empresa e on m.cod_empresa = e.cod_empresa
       left outer join labor l on m.cod_labor = l.cod_labor
       left outer join centros_costo cc on m.cencos = cc.cencos
       left outer join banco b1 on m.cod_banco = b1.cod_banco
       left outer join banco b2 on m.cod_banco_CTS = b2.cod_banco
       left outer join tipo_sangre ts on m.cod_tipo_sangre = ts.cod_tipo_sangre
       left outer join categoria_salarial cs on m.cod_categ_sal = cs.cod_categ_sal
       left outer join area a on m.cod_area = a.cod_area
       left outer join seccion s on m.cod_area = s.cod_area and m.cod_area = s.cod_seccion
       left outer join pais ps on m.cod_pais = ps.cod_pais
       left outer join departamento_estado de on m.cod_pais = de.cod_pais and m.cod_dpto = de.cod_dpto
       left outer join provincia_condado pc on m.cod_pais = pc.cod_pais and m.cod_dpto = pc.cod_dpto and m.cod_prov = pc.cod_prov
       left outer join ciudad cd on m.cod_pais = cd.cod_pais and m.cod_dpto = cd.cod_dpto and m.cod_prov = cd.cod_prov and m.cod_ciudad = cd.cod_ciudad
       left outer join distrito dt on m.cod_pais = dt.cod_pais and m.cod_dpto = dt.cod_dpto and m.cod_prov = dt.cod_prov and m.cod_distr = dt.cod_distr
       left outer join vivienda vd on m.cod_vivienda = vd.cod_vivienda
       left outer join turno tr on m.turno = tr.turno
       left outer join origen o on m.cod_origen = o.cod_origen;

prompt
prompt Creating view VW_RH_FICHA_TRABAJADOR_EDG
prompt ========================================
prompt
create or replace force view cantabria.vw_rh_ficha_trabajador_edg as
Select
       m.cod_trabajador,
       upper(m.cod_trabajador) as codigo,
       upper(m.cod_trab_antguo) as cod_antiguo,
       upper(m.apel_paterno) as paterno,
       upper(m.apel_materno) as materno,
       upper(m.nombre1) as nombre1,
       upper(m.nombre2) as nombre2,
       m.flag_estado_civil,
       decode(m.flag_estado_civil, 'C', 'CASADO(A)', 'S', 'SOLTERO(A)', 'V', 'VIUDO(A)', 'D', 'DIVORCIADO(A)', 'OTRO') as estado_civil,
       decode(m.flag_cal_plnlla, '1', 'SI', 'NO') as planilla,
       decode(m.flag_sindicato, '1', 'SI', 'NO') as sindicato,
       m.fec_nacimiento,
       to_char(m.fec_nacimiento, 'dd/mm/yyyy') as nacimiento,
       decode(m.flag_estado, '1', 'ACTIVO', 'INACTIVO') as estado,
       m.fec_ingreso,
       to_char(m.fec_ingreso, 'dd/mm/yyyy') as ingreso,
       m.fec_cese,
       to_char(m.fec_cese, 'dd/mm/yyyy') as cese,
       upper(mc.desc_motiv_cese) as motivo_cese,
       m.flag_sexo,
       decode(m.flag_sexo, 'M', 'MASCULINO', 'FEMENINO') as sexo,
       upper(m.direccion) as direccion_postal,
       m.cod_ciudad as disc_ciu,
       m.telefono1 as tel_princ,
       m.telefono2 as tel_sec,
       m.dni as dni,
       m.lib_militar as lib_milit,
       m.ruc as ruc,
       lower(m.email) as correo_electronico,
       upper(tb.desc_brev) as tipo_brevete,
       upper(m.nro_brevete) as nro_brevete,
       m.carnet_trabaj as carnet,
       m.nro_ipss as seguro_social,
       upper(gi.desc_instruc) as grado_instruccion,
       upper(p.desc_profesion) as profesion,
       upper(c.desc_cargo) as cargo,
       upper(st.desc_sit_trab) as situacion_trabajador,
       m.cod_afp,
       upper(aa.desc_afp) as afp,
       upper(m.nro_afp_trabaj) as nro_afp,
       m.fec_ini_afil_afp,
       to_char(m.fec_ini_afil_afp, 'dd/mm/yyyy') as ini_afp,
       to_char(m.fec_fin_afil_afp, 'dd/mm/yyyy') as fin_afp,
       to_char(m.porc_judicial, '990,00') as judicial,
       decode(m.bonif_fija_30_25, '1', '30%', '2', '25%', 'NO PERCIBE') as bonificacion_fija,
       decode(m.flag_quincena, '1', 'SI', 'NO') as quincena,
       m.tipo_trabajador as cod_tipo_trabajador,
       upper(tt.desc_tipo_tra) as tipo_trabajador,
       m.nro_cnta_ahorro as nro_cnta_ahorro,
       m.nro_cnta_cts as nro_cnta_cts,
       upper(mo.descripcion) as moneda_ahorros,
       upper(e.nombre) as empresa,
       upper(l.desc_labor) as labor,
       m.cencos,
       upper(cc.desc_cencos) as centro_costo,
       m.cod_banco,
       upper(b1.nom_banco) as banco_ahorro,
       upper(b2.nom_banco) as banco_cts,
       upper(ts.desc_sangre) as tipo_sangre,
       trim(to_char(cs.imp_categ_min)) || ' - ' || trim(to_char(cs.imp_categ_max)) as categoria_salarial,
       m.cod_area,
       upper(a.desc_area) as area,
       m.cod_seccion,
       upper(s.desc_seccion) as seccion,
       upper(ps.nom_pais) as pais,
       upper(de.desc_dpto) as departamento,
       upper(pc.desc_prov) as provincia,
       upper(cd.descr_ciudad) as ciudad,
       upper(dt.cod_distr) as distrito,
       upper(vd.desc_vivienda) as vivienda,
       upper(tr.descripcion) as turno,
       decode(m.flag_marca_reloj, '1', 'SI', 'NO') as marca_reloj,
       decode(m.flag_convenio, '1', 'SI', 'NO') as convenio,
       decode(m.flag_juicio, '1', 'SI', 'NO') as calcula_sobretirmpo,
       m.cod_origen,
       upper(o.nombre) as origen ,
       m.flag_estado
    from maestro m
       left outer join motivo_cese mc on m.cod_motiv_cese = mc.cod_motiv_cese
       left outer join tipo_brevete tb on m.cod_tipo_brev = tb.cod_tipo_brev
       left outer join grado_instruccion gi on m.cod_grado_inst = gi.cod_grado_inst
       left outer join profesion p on m.cod_profesion = p.cod_profesion
       left outer join cargo c on m.cod_cargo = c.cod_cargo
       left outer join situacion_trabajador st on m.situa_trabaj = st.situa_trabaj
       left outer join admin_afp aa on m.cod_afp = aa.cod_afp
       left outer join tipo_trabajador tt on m.tipo_trabajador = tt.tipo_trabajador
       left outer join moneda mo on m.cod_moneda = mo.cod_moneda
       left outer join empresa e on m.cod_empresa = e.cod_empresa
       left outer join labor l on m.cod_labor = l.cod_labor
       left outer join centros_costo cc on m.cencos = cc.cencos
       left outer join banco b1 on m.cod_banco = b1.cod_banco
       left outer join banco b2 on m.cod_banco_CTS = b2.cod_banco
       left outer join tipo_sangre ts on m.cod_tipo_sangre = ts.cod_tipo_sangre
       left outer join categoria_salarial cs on m.cod_categ_sal = cs.cod_categ_sal
       left outer join area a on m.cod_area = a.cod_area
       left outer join seccion s on m.cod_area = s.cod_area and m.cod_area = s.cod_seccion
       left outer join pais ps on m.cod_pais = ps.cod_pais
       left outer join departamento_estado de on m.cod_pais = de.cod_pais and m.cod_dpto = de.cod_dpto
       left outer join provincia_condado pc on m.cod_pais = pc.cod_pais and m.cod_dpto = pc.cod_dpto and m.cod_prov = pc.cod_prov
       left outer join ciudad cd on m.cod_pais = cd.cod_pais and m.cod_dpto = cd.cod_dpto and m.cod_prov = cd.cod_prov and m.cod_ciudad = cd.cod_ciudad
       left outer join distrito dt on m.cod_pais = dt.cod_pais and m.cod_dpto = dt.cod_dpto and m.cod_prov = dt.cod_prov and m.cod_distr = dt.cod_distr
       left outer join vivienda vd on m.cod_vivienda = vd.cod_vivienda
       left outer join turno tr on m.turno = tr.turno
       left outer join origen o on m.cod_origen = o.cod_origen;

prompt
prompt Creating view VW_RH_GAN_DESC_FIJ
prompt ================================
prompt
create or replace force view cantabria.vw_rh_gan_desc_fij as
select c.concep, c.cod_trabajador, c.imp_soles, c.fec_proceso
      from calculo c
union all
   select hc.concep, hc.cod_trabajador, hc.imp_soles, hc.fec_calc_plan
      from historico_calculo hc
         left outer join calculo c
            on hc.concep = c.concep
            and hc.cod_trabajador = c.cod_trabajador
            and hc.fec_calc_plan = c.fec_proceso
      where c.concep is null;

prompt
prompt Creating view VW_RH_GANFIJ
prompt ==========================
prompt
create or replace force view cantabria.vw_rh_ganfij as
select gdf.cod_trabajador,
          gdf.concep,
          gdf.flag_trabaj,
          gdf.flag_estado,
          nvl(m.bonif_fija_30_25,'0') as flag_bonif_fija_30_25,
          nvl(m.situa_trabaj,' ') as situa_trabaj,
          decode(nvl(m.situa_trabaj,' '), 'E', 'ESTABLE', 'S', 'ESTABLE', 'C', 'CONTRATADO', 'OTROS') as estado_contrato,
          gdf.imp_gan_desc
      from gan_desct_fijo gdf
      inner join maestro m on gdf.cod_trabajador = m.cod_trabajador
      where gdf.concep in (select c.concep from concepto c where c.flag_estado = '1' and substr(c.concep,1,2) = (select p.grc_gnn_fija from rrhhparam p where p.reckey = '1') and c.concep not in (select g.concepto_gen from grupo_calculo g where g.grupo_calculo in ('030', '031')))
         and gdf.flag_estado = '1'
         and m.flag_estado = '1'
         and gdf.imp_gan_desc <> 0
         and m.situa_trabaj in ('S','E','C')
union all
   select gdf.cod_trabajador,
          (select min(gc.concepto_gen) from grupo_calculo gc where gc.grupo_calculo = '031'),
          gdf.flag_trabaj,
          gdf.flag_estado,
          nvl(m.bonif_fija_30_25,'0') as flag_bonif_fija_30_25,
          nvl(m.situa_trabaj,' ') as situa_trabaj,
          decode(nvl(m.situa_trabaj,' '), 'E', 'ESTABLE', 'S', 'ESTABLE', 'C', 'CONTRATADO', 'OTROS') as estado_contrato,
          round((decode(nvl(m.bonif_fija_30_25,'0'), '1', 0.30, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) as imp_acumula_30
      from gan_desct_fijo gdf
      inner join maestro m on gdf.cod_trabajador = m.cod_trabajador
      where gdf.concep in (select c.concep from concepto c where c.flag_estado = '1' and substr(c.concep,1,2) = (select p.grc_gnn_fija from rrhhparam p where p.reckey = '1') and c.concep not in (select g.concepto_gen from grupo_calculo g where g.grupo_calculo in ('030', '031')))
         and gdf.flag_estado = '1'
         and m.flag_estado = '1'
         and round((decode(nvl(m.bonif_fija_30_25,'0'), '1', 0.30, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) <> 0
         and m.situa_trabaj in ('S','E','C')
union all
   select gdf.cod_trabajador,
          (select min(gc.concepto_gen) from grupo_calculo gc where gc.grupo_calculo = '030'),
          gdf.flag_trabaj,
          gdf.flag_estado,
          nvl(m.bonif_fija_30_25,'0') as flag_bonif_fija_30_25,
          nvl(m.situa_trabaj,' ') as situa_trabaj,
          decode(nvl(m.situa_trabaj,' '), 'E', 'ESTABLE', 'S', 'ESTABLE', 'C', 'CONTRATADO', 'OTROS') as estado_contrato,
          round((decode(nvl(m.bonif_fija_30_25,'0'), '2', 0.25, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) as imp_acumula_25
      from gan_desct_fijo gdf
      inner join maestro m on gdf.cod_trabajador = m.cod_trabajador
      where gdf.concep in (select c.concep from concepto c where c.flag_estado = '1' and substr(c.concep,1,2) = (select p.grc_gnn_fija from rrhhparam p where p.reckey = '1') and c.concep not in (select g.concepto_gen from grupo_calculo g where g.grupo_calculo in ('030', '031')))
         and gdf.flag_estado = '1'
         and m.flag_estado = '1'
         and round((decode(nvl(m.bonif_fija_30_25,'0'), '2', 0.25, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) <> 0
         and m.situa_trabaj in ('S','E','C');

prompt
prompt Creating view VW_RH_GANFIJ_DET
prompt ==============================
prompt
create or replace force view cantabria.vw_rh_ganfij_det as
select gdf.cod_trabajador,
          gdf.concep,
          gdf.flag_trabaj,
          gdf.flag_estado,
          nvl(m.bonif_fija_30_25,'0') as flag_bonif_fija_30_25,
          nvl(m.situa_trabaj,' ') as situa_trabaj,
          decode(nvl(m.situa_trabaj,' '), 'E', 'ESTABLE', 'S', 'ESTABLE', 'C', 'CONTRATADO', 'OTROS') as estado_contrato,
          gdf.imp_gan_desc
      from gan_desct_fijo gdf
      inner join maestro m on gdf.cod_trabajador = m.cod_trabajador
      where gdf.concep in (select c.concep from concepto c where c.flag_estado = '1' and (substr(c.concep,1,2) = (select p.grc_gnn_fija from rrhhparam p where p.reckey = '1') or substr(c.concep,1,2) = (select p.grc_dsc_fijo from rrhhparam p where p.reckey = '1')) and c.concep not in (select g.concepto_gen from grupo_calculo g where g.grupo_calculo in ('030', '031')))
         and gdf.flag_estado = '1'
         and m.flag_estado = '1'
         and gdf.imp_gan_desc <> 0
         and m.situa_trabaj in ('S','E','C')
union all
   select gdf.cod_trabajador,
          (select min(gc.concepto_gen) from grupo_calculo gc where gc.grupo_calculo = '031'),
          gdf.flag_trabaj,
          gdf.flag_estado,
          nvl(m.bonif_fija_30_25,'0') as flag_bonif_fija_30_25,
          nvl(m.situa_trabaj,' ') as situa_trabaj,
          decode(nvl(m.situa_trabaj,' '), 'E', 'ESTABLE', 'S', 'ESTABLE', 'C', 'CONTRATADO', 'OTROS') as estado_contrato,
          round((decode(nvl(m.bonif_fija_30_25,'0'), '1', 0.30, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) as imp_acumula_30
      from gan_desct_fijo gdf
      inner join maestro m on gdf.cod_trabajador = m.cod_trabajador
      where gdf.concep in (select c.concep from concepto c where c.flag_estado = '1' and (substr(c.concep,1,2) = (select p.grc_gnn_fija from rrhhparam p where p.reckey = '1') or substr(c.concep,1,2) = (select p.grc_dsc_fijo from rrhhparam p where p.reckey = '1')) and c.concep not in (select g.concepto_gen from grupo_calculo g where g.grupo_calculo in ('030', '031')))
         and gdf.flag_estado = '1'
         and m.flag_estado = '1'
         and round((decode(nvl(m.bonif_fija_30_25,'0'), '1', 0.30, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) <> 0
         and m.situa_trabaj in ('S','E','C')
union all
   select gdf.cod_trabajador,
          (select min(gc.concepto_gen) from grupo_calculo gc where gc.grupo_calculo = '030'),
          gdf.flag_trabaj,
          gdf.flag_estado,
          nvl(m.bonif_fija_30_25,'0') as flag_bonif_fija_30_25,
          nvl(m.situa_trabaj,' ') as situa_trabaj,
          decode(nvl(m.situa_trabaj,' '), 'E', 'ESTABLE', 'S', 'ESTABLE', 'C', 'CONTRATADO', 'OTROS') as estado_contrato,
          round((decode(nvl(m.bonif_fija_30_25,'0'), '2', 0.25, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) as imp_acumula_25
      from gan_desct_fijo gdf
      inner join maestro m on gdf.cod_trabajador = m.cod_trabajador
      where gdf.concep in (select c.concep from concepto c where c.flag_estado = '1' and (substr(c.concep,1,2) = (select p.grc_gnn_fija from rrhhparam p where p.reckey = '1') or substr(c.concep,1,2) = (select p.grc_dsc_fijo from rrhhparam p where p.reckey = '1')) and c.concep not in (select g.concepto_gen from grupo_calculo g where g.grupo_calculo in ('030', '031')))
         and gdf.flag_estado = '1'
         and m.flag_estado = '1'
         and round((decode(nvl(m.bonif_fija_30_25,'0'), '2', 0.25, 0) * decode(m.situa_trabaj, 'E', gdf.imp_gan_desc, 'S', gdf.imp_gan_desc, 'C', gdf.imp_gan_desc, 0)),2) <> 0
         and m.situa_trabaj in ('S','E','C');

prompt
prompt Creating view VW_RH_GANVAR
prompt ==========================
prompt
create or replace force view cantabria.vw_rh_ganvar as
select gdv.cod_trabajador, gdv.concep, gdv.nro_doc, gdv.imp_var, gdv.cod_usr, gdv.fec_movim
      from gan_desct_variable gdv
   union all
   select hv.cod_trabajador, hv.concep, hv.nro_doc, hv.imp_var, hv.cod_usr, hv.fec_movim
      from historico_variable hv
      left outer join gan_desct_variable gdv
         on gdv.cod_trabajador = hv.cod_trabajador
         and gdv.concep = hv.cod_trabajador
         and trunc(gdv.fec_movim) = trunc(hv.fec_movim)
      where gdv.concep is null;

prompt
prompt Creating view VW_RH_INASISTENCIA
prompt ================================
prompt
create or replace force view cantabria.vw_rh_inasistencia as
select i.cod_trabajador, i.concep, i.fec_desde, i.fec_hasta, i.dias_inasist, i.fec_movim
   from inasistencia i
union all
select hi.cod_trabajador, hi.concep, hi.fec_desde, hi.fec_hasta, hi.dias_inasist, hi.fec_movim
   from historico_inasistencia hi
   left outer join inasistencia i
      on i.cod_trabajador = hi.cod_trabajador
      and i.concep = hi.concep
      and trunc(i.fec_movim) = trunc(hi.fec_movim)
   where i.concep is null;

prompt
prompt Creating view VW_RH_PLANILLA_COMPLETA
prompt =====================================
prompt
create or replace force view cantabria.vw_rh_planilla_completa as
select to_char(c.fec_proceso, 'dd/mm/yyyy') as fec_proceso,
       to_char(c.fec_proceso, 'yyyy') as year,
       to_char(c.fec_proceso, 'mm') as mes,
       case
          when to_char(c.fec_proceso, 'mm') = '01' then '01.Ene'
          when to_char(c.fec_proceso, 'mm') = '02' then '02.Feb'
          when to_char(c.fec_proceso, 'mm') = '03' then '03.Mar'
          when to_char(c.fec_proceso, 'mm') = '04' then '04.Abr'
          when to_char(c.fec_proceso, 'mm') = '05' then '05.May'
          when to_char(c.fec_proceso, 'mm') = '06' then '06.Jun'
          when to_char(c.fec_proceso, 'mm') = '07' then '07.Jul'
          when to_char(c.fec_proceso, 'mm') = '08' then '08.Ago'
          when to_char(c.fec_proceso, 'mm') = '09' then '09.Set'
          when to_char(c.fec_proceso, 'mm') = '10' then '10.Oct'
          when to_char(c.fec_proceso, 'mm') = '11' then '11.Nov'
          when to_char(c.fec_proceso, 'mm') = '12' then '12.Dic'
       end as nombre_mes,
       m.TIPO_TRABAJADOR,
       m.TIPO_TRABAJADOR || '-' || tt.desc_tipo_tra as full_desc_tipo_trabajador,
       c.cod_trabajador,
       m.NOM_TRABAJADOR,
       case
          when c.concep like '1%' then '01.Ingresos'
          when c.concep like '2%' then '02.Descuentos'
          when c.concep like '3%' then '03.Aportaciones'
       end as tipo_concepto,
       c.concep,
       c.concep || '-' || co.desc_concep as full_desc_concepto,
       niv1.cod_n1 || ' - ' || niv1.descripcion as desc_cencos_niv1,
       m.CENCOS,
       trim(m.cencos) || '-' || cc.desc_cencos as full_desc_cencos,
       c.imp_soles,
       c.imp_dolar,
       c.horas_trabaj,
       c.horas_pag,
       case
          when c.concep = '1301' and m.TIPO_TRABAJADOR = 'TRI' then
            (select sum(total_pesca)
              from fl_participacion_pesca t,
                   rrhh_param_org         rh
             where t.tripulante = c.cod_trabajador
               and t.fecha between rh.fec_inicio and rh.fec_final
               and rh.fec_proceso     = c.fec_proceso
               and rh.tipo_trabajador = m.TIPO_TRABAJADOR
               and rh.origen          = c.COD_ORIGEN      )
          else
             0
       end as pesca_capturada,
       m.COD_CARGO,
       ca.desc_cargo,
       case
          when c.concep = '1001' then
            (select sum(gf.imp_gan_desc)
              from gan_desct_fijo gf
             where gf.cod_trabajador = m.COD_TRABAJADOR
               and gf.flag_estado    = '1'
               and gf.concep         like '1%')
          else
             0
       end as haber_fijo
  from calculo          c,
       vw_pr_trabajador m,
       concepto         co,
       tipo_trabajador  tt,
       centros_costo    cc,
       cencos_niv1      niv1,
       cargo            ca
 where c.cod_trabajador = m.COD_TRABAJADOR
   and c.concep         = co.concep
   and m.TIPO_TRABAJADOR = tt.tipo_trabajador
   and m.CENCOS          = cc.cencos  (+)
   and cc.cod_n1          = niv1.cod_n1          (+)
   and m.COD_CARGO        = ca.cod_cargo         (+)
union
select to_char(hc.fec_calc_plan, 'dd/mm/yyyy') as fec_proceso,
       to_char(hc.fec_calc_plan, 'yyyy') as year,
       to_char(hc.fec_calc_plan, 'mm') as mes,
       case
          when to_char(hc.fec_calc_plan, 'mm') = '01' then '01.Ene'
          when to_char(hc.fec_calc_plan, 'mm') = '02' then '02.Feb'
          when to_char(hc.fec_calc_plan, 'mm') = '03' then '03.Mar'
          when to_char(hc.fec_calc_plan, 'mm') = '04' then '04.Abr'
          when to_char(hc.fec_calc_plan, 'mm') = '05' then '05.May'
          when to_char(hc.fec_calc_plan, 'mm') = '06' then '06.Jun'
          when to_char(hc.fec_calc_plan, 'mm') = '07' then '07.Jul'
          when to_char(hc.fec_calc_plan, 'mm') = '08' then '08.Ago'
          when to_char(hc.fec_calc_plan, 'mm') = '09' then '09.Set'
          when to_char(hc.fec_calc_plan, 'mm') = '10' then '10.Oct'
          when to_char(hc.fec_calc_plan, 'mm') = '11' then '11.Nov'
          when to_char(hc.fec_calc_plan, 'mm') = '12' then '12.Dic'
       end as nombre_mes,
       hc.TIPO_TRABAJADOR,
       hc.TIPO_TRABAJADOR || '-' || tt.desc_tipo_tra as full_desc_tipo_trabajador,
       hc.cod_trabajador,
       m.NOM_TRABAJADOR,
       case
          when hc.concep like '1%' then '01.Ingresos'
          when hc.concep like '2%' then '02.Descuentos'
          when hc.concep like '3%' then '03.Aportaciones'
       end as tipo_concepto,
       hc.concep,
       hc.concep || '-' || co.desc_concep as full_desc_concepto,
       niv1.cod_n1 || ' - ' || niv1.descripcion as desc_cencos_niv1,
       hc.CENCOS,
       trim(hc.cencos) || '-' || cc.desc_cencos as full_desc_cencos,
       hc.imp_soles,
       hc.imp_dolar,
       hc.horas_trabaj,
       hc.horas_pagad,
       case
          when hc.concep = '1301' and hc.TIPO_TRABAJADOR = 'TRI' then
            (select sum(total_pesca)
              from fl_participacion_pesca t,
                   rrhh_param_org rh
             where t.tripulante = hc.cod_trabajador
               and t.fecha between rh.fec_inicio and rh.fec_final
               and rh.fec_proceso     = hc.fec_calc_plan
               and rh.tipo_trabajador = hc.TIPO_TRABAJADOR
               and rh.origen          = hc.cod_origen      )
          else
             0
       end as pesca_capturada,
       m.COD_CARGO,
       ca.desc_cargo,
       case
          when hc.concep = '1001' then
            (select sum(gf.imp_gan_desc)
              from gan_desct_fijo gf
             where gf.cod_trabajador = m.COD_TRABAJADOR
               and gf.flag_estado    = '1'
               and gf.concep         like '1%')
          else
             0
       end as haber_fijo
  from historico_calculo hc,
       vw_pr_trabajador  m,
       concepto         co,
       tipo_trabajador  tt,
       centros_costo    cc,
       cencos_niv1      niv1,
       cargo            ca
 where hc.cod_trabajador = m.COD_TRABAJADOR
   and hc.concep         = co.concep
   and hc.tipo_trabajador = tt.tipo_trabajador
   and hc.cencos          = cc.cencos            (+)
   and cc.cod_n1          = niv1.cod_n1          (+)
   and m.COD_CARGO        = ca.cod_cargo         (+)
   and to_number(to_char(sysdate, 'yyyy')) - to_number(to_char(hc.fec_calc_plan, 'yyyy')) <= 5;

prompt
prompt Creating view VW_RH_QUINCENA
prompt ============================
prompt
create or replace force view cantabria.vw_rh_quincena as
select aq.concep as concep, aq.cod_trabajador as cod_trabajador, aq.imp_adelanto as importe, aq.fec_proceso  as fecha
      from adelanto_quincena aq
   union all
   select hc.concep as concep, hc.cod_trabajador as cod_trabajador, hc.imp_soles as importe, hc.fec_calc_plan as fecha
      from historico_calculo hc
      inner join grupo_calculo gc on hc.concep = gc.concepto_gen
      left outer join adelanto_quincena aq
         on hc.cod_trabajador = aq.cod_trabajador
         and hc.concep = aq.concep
         and trunc(hc.fec_calc_plan) = trunc(aq.fec_proceso)
      where gc.grupo_calculo = '001'
         and aq.concep is null;

prompt
prompt Creating view VW_RH_SOBRETIRMPO
prompt ===============================
prompt
create or replace force view cantabria.vw_rh_sobretirmpo as
select s.cod_trabajador, s.fec_movim, s.concep, s.nro_doc, s.horas_sobret, s.cod_usr
   from sobretiempo_turno s
   union all
select hs.cod_trabajador, hs.fec_movim, hs.concep, hs.nro_doc, hs.horas_sobret, hs.cod_usr
   from historico_sobretiempo hs
   left outer join sobretiempo_turno s
      on s.cod_trabajador = hs.cod_trabajador
      and s.concep = hs.concep
      and trunc(s.fec_movim) = trunc(hs.fec_movim)
   where s.concep is null;

prompt
prompt Creating view VW_RH_UBIGEO
prompt ==========================
prompt
create or replace force view cantabria.vw_rh_ubigeo as
select p.cod_pais, de.cod_dpto, pc.cod_prov, p.nom_pais, de.desc_dpto, pc.desc_prov from pais p
      full join departamento_estado de on p.cod_pais = de.cod_pais
      full join provincia_condado pc on de.cod_pais = pc.cod_pais and de.cod_dpto = pc.cod_dpto;

prompt
prompt Creating view VW_RPT_DASHBOARD_PROD
prompt ===================================
prompt
create or replace force view cantabria.vw_rpt_dashboard_prod as
select ot.nro_orden,
       ot.ot_adm,
       ot.ot_tipo,
       ot.titulo,
       trunc(vm.fec_registro) as fec_produccion,
       PKG_PRODUCCION.of_saldo_inicial_mp(trunc(vm.fec_registro), ot.nro_orden) as saldo_inicial_mp,
       PKG_PRODUCCION.of_ing_mp_propia(trunc(vm.fec_registro), ot.nro_orden) as ing_mp_propia,
       PKG_PRODUCCION.of_ing_mp_tercero(trunc(vm.fec_registro), ot.nro_orden) as ing_mp_tercero,
       PKG_PRODUCCION.of_consumo_mp(trunc(vm.fec_registro), ot.nro_orden) as consumo_mp,
       PKG_PRODUCCION.of_saldo_final_mp(trunc(vm.fec_registro), ot.nro_orden) as saldo_final_mp,
       PKG_PRODUCCION.of_consumo_petroleo_diesel(trunc(vm.fec_registro), ot.nro_orden) as consumo_petroleo_diesel,
       PKG_PRODUCCION.of_consumo_petroleo_r500(trunc(vm.fec_registro), ot.nro_orden) as consumo_petroleo_r500,
       PKG_PRODUCCION.of_consumo_antioxidante(trunc(vm.fec_registro), ot.nro_orden) as consumo_antioxidante,
       PKG_PRODUCCION.of_consumo_polimero(trunc(vm.fec_registro), ot.nro_orden) as consumo_polimero,
       PKG_PRODUCCION.of_consumo_coagulante(trunc(vm.fec_registro), ot.nro_orden) as consumo_coagulante,
       PKG_PRODUCCION.of_consumo_sacos(trunc(vm.fec_registro), ot.nro_orden) as consumo_sacos,
       PKG_PRODUCCION.of_reproceso_sac(trunc(vm.fec_registro), ot.nro_orden) as reproceso_sac,
       PKG_PRODUCCION.of_reproceso_ton(trunc(vm.fec_registro), ot.nro_orden) as reproceso_ton,
       PKG_PRODUCCION.of_prod_aceite_ch(trunc(vm.fec_registro), ot.nro_orden) as prod_aceite_ch,
       PKG_PRODUCCION.of_prod_aceite_chi(trunc(vm.fec_registro), ot.nro_orden) as prod_aceite_chi,
       PKG_PRODUCCION.of_prod_aceite_pama(trunc(vm.fec_registro), ot.nro_orden) as prod_aceite_pama,
       a.cod_art,
       a.desc_art,
       a.und,
       a.und2,
       sum(am.cant_procesada) as cant_proc_und1,
       sum(am.cant_proc_und2) as cant_proc_und2
from vale_mov vm,
     articulo_mov am,
     articulo_mov_proy amp,
     orden_trabajo     ot,
     articulo          a
where vm.nro_Vale      = am.nro_Vale
  and amp.cod_Art      = a.cod_art
  and am.origen_mov_proy = amp.cod_origen
  and am.nro_mov_proy    = amp.nro_mov
  and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
  and amp.nro_doc        = ot.nro_orden
  and vm.tipo_mov        = PKG_PRODUCCION.of_oper_ing_prod(null)
  and trim(am.cod_art)   in (select trim(column_value)
                               from table(split(PKG_CONFIG.USF_GET_PARAMETER('COD_ARTICULO_HARINA_PESCADO', '015001.0001'))))
  and vm.flag_estado           <> '0'
  and am.flag_estado           <> '0'
group by ot.nro_orden,
       ot.ot_adm,
       ot.ot_tipo,
       ot.titulo,
       vm.tipo_mov,
       trunc(vm.fec_registro),
       a.cod_art,
       a.desc_art,
       a.und,
       a.und2
order by fec_produccion;

prompt
prompt Creating view VW_RRHH_ALCANCE_TRABAJADOR
prompt ========================================
prompt
create or replace force view cantabria.vw_rrhh_alcance_trabajador as
select c.cod_trabajador, c.imp_soles, c.fec_proceso as fecha, upper(decode(trim(nvl(m.nro_cnta_ahorro,' ')) || 's', 's', 'sin tarjeta', 'con tarjeta')) as tarjeta
      from calculo c
         left outer join rrhhparam rhp on c.concep = rhp.cnc_total_pgd
         left outer join maestro m on c.cod_trabajador = m.cod_trabajador
      union all
   select hc.cod_trabajador, hc.imp_soles, hc.fec_calc_plan as fecha, upper(decode(trim(nvl(m.nro_cnta_ahorro,' ')) || 's', 's', 'sin tarjeta', 'con tarjeta')) as tarjeta
      from historico_calculo hc
         left outer join rrhhparam rhp on hc.concep = rhp.cnc_total_pgd
         left outer join maestro m on hc.cod_trabajador = m.cod_trabajador;

prompt
prompt Creating view VW_RRHH_CODREL_MAESTRO
prompt ====================================
prompt
create or replace force view cantabria.vw_rrhh_codrel_maestro as
select m.cod_trabajador as codigo,
       trim(m.apel_paterno) || ' ' || trim(m.apel_materno) || ', ' || trim(m.nombre1) || ' ' || trim(m.nombre2) as nombre,
       m.dni,
       m.flag_estado
    from maestro m
    order by nombre;

prompt
prompt Creating view VW_RRHH_COMPET_COMPORT
prompt ====================================
prompt
create or replace force view cantabria.vw_rrhh_compet_comport as
select c2.cod_competencia as cod_compet,
       c1.desc_competencia as desc_compet,
       c2.cod_comport as cod_comport,
       substr(c2.desc_comport,1,35) as desc_comport
from rh_comportamiento c2, rh_competencia c1
where c2.cod_competencia = c1.cod_competencia
order by c2.cod_competencia, c2.cod_comport;

prompt
prompt Creating view VW_RRHH_QUINCENA
prompt ==============================
prompt
create or replace force view cantabria.vw_rrhh_quincena as
select aq.concep as concep, aq.cod_trabajador as cod_trabajador, aq.imp_adelanto as importe, aq.fec_proceso  as fecha
      from adelanto_quincena aq
   union all
   select hc.concep as concep, hc.cod_trabajador as cod_trabajador, hc.imp_soles as importe, hc.fec_calc_plan as fecha
      from historico_calculo hc
      inner join grupo_calculo gc on hc.concep = gc.concepto_gen
      left outer join adelanto_quincena aq
         on hc.cod_trabajador = aq.cod_trabajador
         and hc.concep = aq.concep
         and trunc(hc.fec_calc_plan) = trunc(aq.fec_proceso)
      where gc.grupo_calculo = '001'
         and aq.concep is null;

prompt
prompt Creating view VW_RRHH_RESUMEN_PLANILLA
prompt ======================================
prompt
create or replace force view cantabria.vw_rrhh_resumen_planilla as
select decode(substr(c.concep,1,1), '1', '1. GANANCIAS', '2', '2. DESCUENTOS', '3', '3. APORTACIONES', 'OTROS') as grupo, c.cod_trabajador, c.fec_proceso as fecha, to_char(c.fec_proceso, 'yyyy') as ano, to_char(c.fec_proceso, 'mm') as mes, c.concep, c.horas_trabaj as horas_trabajadas, c.horas_pag as horas_pagadas, c.imp_soles as importe_soles, c.dias_trabaj
      from calculo c
      where c.concep <> (select rhp.cnc_total_ing  from rrhhparam rhp)
      and c.concep <> (select rhp.cnc_total_dsct from rrhhparam rhp)
      and c.concep <> (select rhp.cnc_total_aport from rrhhparam rhp)
      and c.concep <> (select rhp.cnc_total_pgd from rrhhparam rhp)
   union all
   select decode(substr(hc.concep,1,1), '1', '1. GANANCIAS', '2', '2. DESCUENTOS', '3', '3. APORTACIONES', 'OTROS') as grupo, hc.cod_trabajador, hc.fec_calc_plan as fecha, to_char(hc.fec_calc_plan, 'yyyy') as ano, to_char(hc.fec_calc_plan, 'mm') as mes, hc.concep, hc.horas_trabaj as horas_trabajadas, hc.horas_pagad as horas_pagadas, hc.imp_soles as importe_soles, hc.dias_trabaj
      from historico_calculo hc
         left outer join calculo c
            on hc.concep = c.concep
            and hc.cod_trabajador = c.cod_trabajador
            and hc.fec_calc_plan = c.fec_proceso
      where c.concep is null
      and hc.concep <> (select rhp.cnc_total_ing  from rrhhparam rhp)
      and hc.concep <> (select rhp.cnc_total_dsct from rrhhparam rhp)
      and hc.concep <> (select rhp.cnc_total_aport from rrhhparam rhp)
      and hc.concep <> (select rhp.cnc_total_pgd from rrhhparam rhp);

prompt
prompt Creating view VW_RRHH_TIPO_TRABAJADOR
prompt =====================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_RRHH_TIPO_TRABAJADOR AS
SELECT TP.TIPO_TRABAJADOR AS CODIGO,
       TP.DESC_TIPO_TRA
  FROM TIPO_TRABAJADOR TP
 WHERE TP.FLAG_ESTADO = '1';

prompt
prompt Creating view VW_TG_ATRIB_UND
prompt =============================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_TG_ATRIB_UND AS
SELECT MAA.ATRIBUTO    AS ATRIB_COD,
       MAA.DESCRIPCION AS ATRIB_DESC,
       U.DESC_UNIDAD,
       DECODE(MAA.FLAG_TIPO_DATO, 'C', 'TEXTO', 'N', 'NUMERO', 'H', 'HORA') AS TIPO_DATO
  FROM TG_MED_ACT_ATRIBUTO MAA,
       UNIDAD              U
 WHERE MAA.UND  = U.UND;

prompt
prompt Creating view VW_TG_PARTE_PISO_DET
prompt ==================================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.VW_TG_PARTE_PISO_DET AS
SELECT DISTINCT PPD.NRO_PARTE,
                M.DESC_MAQ,
                MAA.DESCRIPCION,
                PP.FECHA_PARTE
  FROM TG_PARTE_PISO_DET              PPD,
       MAQUINA                        M,
       TG_MED_ACT_ATRIBUTO            MAA,
       TG_FMT_MED_ACT_DET             FD,
       TG_PARTE_PISO                  PP
WHERE PPD.FORMATO                     = FD.FORMATO
  AND FD.COD_MAQUINA                  = M.COD_MAQUINA
  AND FD.ATRIBUTO                     = MAA.ATRIBUTO
  AND PP.NRO_PARTE                    = PPD.NRO_PARTE;

prompt
prompt Creating view VW_TG_PARTE_PISO_FIRMAS
prompt =====================================
prompt
create or replace force view cantabria.vw_tg_parte_piso_firmas as
select 1 as nro, a.cod_usr, b.nombre, trunc(a.fecha) as fecha, a.nro_parte
from tg_parte_piso_firmas a,
     usuario b
where b.cod_usr = a.cod_usr;

prompt
prompt Creating view VW_TG_PARTE_PISO_INCID
prompt ====================================
prompt
create or replace force view cantabria.vw_tg_parte_piso_incid as
select a."NRO_PARTE",a."COD_MAQUINA",a."HORA_ENCENDIDO",a."HORA_APAGADO",a."FLAG_REPLICACION", d.desc_maq, usf_pr_DateTime_horas(hora_encendido, hora_apagado) as horas_funcionamiento,
       usf_pr_horas_incid(a.cod_maquina, a.nro_parte) as horas_incidencias,
       usf_pr_DateTime_horas(hora_encendido, hora_apagado)
                   - usf_pr_horas_incid(a.cod_maquina, a.nro_parte) as horas_produccion,
       b.cod_incidencia, c.desc_incidencia, b.hora_inicio, b.hora_fin,
       usf_pr_DateTime_horas(b.hora_inicio, b.hora_fin) as hora_incidencia
from tg_parte_piso_tiempo_uso a,
     tg_parte_piso_incidencias b,
     incidencias_dma c,
     maquina d
where a.nro_parte      = b.nro_parte
  and a.cod_maquina    = b.cod_maquina
  and c.cod_incidencia = b.cod_incidencia
  and d.cod_maquina    = a.cod_maquina;

prompt
prompt Creating view VW_TG_PARTE_PISO_TIEMPO_USO
prompt =========================================
prompt
create or replace force view cantabria.vw_tg_parte_piso_tiempo_uso as
select distinct fma.descripcion, pp.nro_parte, trunc(pp.fecha_parte) as f_parte, to_char(pp.fecha_parte, 'dd/mm/yyyy hh:mi') as fc_parte
      from tg_parte_piso pp
         inner join tg_parte_piso_tiempo_uso pptu on pp.nro_parte = pptu.nro_parte
         inner join tg_fmt_med_act fma on pp.formato = fma.formato
      where pp.flag_tipo in ('TH', 'TG', 'TC') and pp.flag_estado = '1';

prompt
prompt Creating view VW_TG_TRABAJADOR_ORIGEN
prompt =====================================
prompt
create or replace force view cantabria.vw_tg_trabajador_origen as
select cr.cod_relacion, cr.nombre, m.cod_origen
      from codigo_relacion cr
      inner join maestro m on cr.cod_relacion = m.cod_trabajador;

prompt
prompt Creating view VW_TG_UBIGEO
prompt ==========================
prompt
create or replace force view cantabria.vw_tg_ubigeo as
select tu.ubigeo_codigo,
       tu.ubige_descripcion
--       trim(decode( nvl(decode(substr(trim(tu.ubigeo_codigo),1,2), '00', 1),0) + nvl(decode(substr(trim(tu.ubigeo_codigo),3,2), '00', 1),0) + nvl(decode(substr(trim(tu.ubigeo_codigo),5,2), '00', 1),0),0, 'DISTRITO DE LA',1, 'PROVINCIA DEL', 2, 'DEPARTAMIENTO DEL', 3, 'PAIS DEL')) || ' ' || trim(decode( nvl(decode(substr(trim(tu.ubi_ubigeo_codigo),1,2), '00', 1),0) + nvl(decode(substr(trim(tu.ubi_ubigeo_codigo),3,2), '00', 1),0) + nvl(decode(substr(trim(tu.ubi_ubigeo_codigo),5,2), '00', 1),0),0, 'DISTRITO DE',1, 'PROVINCIA DE', 2, 'DEPARTAMIENTO DE', 3, 'PAIS DE')) || ' ' || trim(ru.ubige_descripcion) as referencia, trim(decode( nvl(decode(substr(trim(tu.ubigeo_codigo),1,2), '00', 1),0) + nvl(decode(substr(trim(tu.ubigeo_codigo),3,2), '00', 1),0) + nvl(decode(substr(trim(tu.ubigeo_codigo),5,2), '00', 1),0),0, 'DISTRITO',1, 'PROVINCIA', 2, 'DEPARTAMIENTO', 3, 'PAIS')) as tipo
   from tg_ubigeo tu
--      inner join tg_ubigeo ru on ru.ubigeo_codigo = tu.ubi_ubigeo_codigo
;

prompt
prompt Creating view VW_TIPO_MOV
prompt =========================
prompt
create or replace force view cantabria.vw_tipo_mov as
select distinct
       am.cod_origen,
       am.nro_mov,
       vm.tipo_mov,
       a.sub_cat_art,
       cc.grp_cntbl,
       tm.item,
       tm.matriz

from articulo_mov am,
     vale_mov     vm,
     centros_costo  cc,
     articulo          a,
     tipo_mov_matriz_subcat tm
where am.nro_vale = vm.nro_Vale
  and vm.tipo_mov = tm.tipo_mov
  and am.cod_art  = a.cod_art
  and a.sub_cat_art = tm.cod_sub_cat
  and am.cencos = cc.cencos
  and cc.grp_cntbl = tm.grp_cntbl
  and vm.flag_estado <> '0'
  and am.flag_estado <> '0'
  and vm.tipo_mov <> 'I00'
  and am.matriz is null;

prompt
prompt Creating view VW_TRIPULANTES
prompt ============================
prompt
create or replace force view cantabria.vw_tripulantes as
select ft.tripulante as codigo_tripulante,
       ma.apel_paterno || ' ' || ma.apel_materno || ', ' || ma.nombre1 as nomb_trip,
       ft.nave as codigo_nave,
		 tn.nomb_nave as nomb_nave
from fl_tripulantes ft, maestro ma, tg_naves tn
where ma.cod_trabajador = ft.cod_trabajador
  and tn.nave = ft.nave;

prompt
prompt Creating view VW_VTA_CNTAS_COBRAR_DET
prompt =====================================
prompt
create or replace force view cantabria.vw_vta_cntas_cobrar_det as
select null as nro_registro,
         cc.tipo_doc,
         cc.nro_doc,
         ccd.item,
         dt.cod_sunat as tipo_doc_cxc,
         PKG_FACT_ELECTRONICA.of_get_serie(cc.nro_doc) as  serie_cxc,
         PKG_FACT_ELECTRONICA.of_get_nro(cc.nro_doc) as nro_cxc,
         cc.observacion,
         cc.cod_moneda,
         trunc(cc.fecha_documento) as fec_emision,
         to_char(cc.fecha_documento, 'HH24:mi:ss') as hora_emision,
         trunc(cc.FECHA_VENCIMIENTO) as fec_vencimiento,
         cc.cod_relacion as cliente,
         p.nom_proveedor,
         p.tipo_doc_ident,
         decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as nro_doc_ident,
         mn.tipo_nc as tipo_nc,
         mn.tipo_nd as tipo_nd,
         mn.descripcion as desc_motivo,
         case
          when cc.item_direccion is null then
            PKG_LOGISTICA.of_get_dir_comercial(cc.cod_relacion)
          else
            PKG_LOGISTICA.of_get_direccion(cc.cod_relacion, cc.item_direccion)
         end as direccion,
         PKG_LOGISTICA.of_get_pais(cc.cod_relacion) as pais,
         ccd.cod_art,
         decode(ccd.descripcion, null, a.desc_art, ccd.descripcion) as descripcion,
         a.und,
         ccd.cantidad as cant_proyect,
         ccd.precio_unitario as precio_unit,
         (Select nvl(sum(ci.importe),0)
            from cc_doc_det_imp ci,
                 impuestos_tipo it
           where ci.tipo_impuesto = it.tipo_impuesto
             and it.flag_igv      = '1'
             and ci.tipo_doc      = ccd.tipo_doc
             and ci.nro_doc       = ccd.nro_doc
             and ci.item          = ccd.item
             and ci.tipo_impuesto not in(select *
                                           from table(split(PKG_CONFIG.USF_GET_PARAMETER('IMPUESTO_ICBPER', 'ICBPE'))))
         ) as importe_igv,
         (Select nvl(sum(ci.importe),0)
            from cc_doc_det_imp ci
           where ci.tipo_doc      = ccd.tipo_doc
             and ci.nro_doc       = ccd.nro_doc
             and ci.item          = ccd.item
             and ci.tipo_impuesto in(select *
                                       from table(split(PKG_CONFIG.USF_GET_PARAMETER('IMPUESTO_ICBPER', 'ICBPE'))))
         ) as icbper,
         0  as descuento,
         upper(mo.descripcion) as desc_moneda,
         dtr.cod_sunat as tipo_doc_ref,
         pkg_fact_electronica.of_get_serie(ccd.nro_ref) as serie_ref,
         pkg_fact_electronica.of_get_nro(ccd.nro_ref) as nro_Ref,
         cc.nro_ra_id,
         cc.nro_rc_id,
         cc.nro_envio_id,
         trunc(se.fec_registro) as fec_envio,
         ccd.tipo_cred_fiscal,
         cc.forma_pago,
         fp.desc_forma_pago,
         fp.dias_vencimiento,
         cc.importe_doc
  from  cntas_cobrar         cc,
        cntas_cobrar_det     ccd,
        articulo             a,
        proveedor            p,
        doc_tipo             dt,
        doc_tipo             dtr,
        moneda               mo,
        motivo_nota          mn,
        sunat_Envio_ce       se,
        forma_pago           fp
  where cc.tipo_doc     = ccd.tipo_doc
    and cc.nro_doc      = ccd.nro_doc
    and ccd.cod_art     = a.cod_art         (+)
    and cc.motivo       = mn.motivo         (+)
    and ccd.tipo_ref    = dtr.tipo_doc       (+)
    and cc.forma_pago   = fp.forma_pago
    and cc.cod_relacion = p.proveedor
    and cc.tipo_doc     = dt.tipo_doc
    and cc.cod_moneda   = mo.cod_moneda
    and ccd.cantidad * ccd.precio_unitario > 0
    and cc.nro_envio_id = se.nro_envio_id (+)
  --  and cc.NRO_Ra_ID   is null
  --  and cc.nro_rc_id   is null
    --and cc.tipo_doc    = :as_tipo_doc
    --and cc.nro_doc     = :as_nro_doc
  order by ccd.item
;

prompt
prompt Creating view VW_VTA_FACTURACION_DET
prompt ====================================
prompt
create or replace force view cantabria.vw_vta_facturacion_det as
select ov.nro_ov,
         DECODE(ov.flag_mercado, 'L', 'LOCAL', 'EXTERNO') as flag_mercado,
         cc.tipo_doc,
         cc.nro_doc,
         cc.cod_relacion, p.nom_proveedor,
         DECODE(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni,
         cc.ano, cc.mes,
         cc.origen || trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) || trim(to_char(cc.nro_libro, '00')) || trim(to_char(cc.nro_libro, '000000')) as voucher,
         cc.fecha_documento as fec_emision,
         amp.cod_art,
         a.desc_art,
         a.und,
         ccd.cantidad,
         cc.cod_moneda,
         ccd.precio_unitario * ccd.cantidad as importe,
         ccd.confin,
         c.cnta_ctbl || '-' || c.desc_cnta as cuenta_contable,
         decode(md.flag_debhab, 'D', decode(cc.cod_moneda, (select cod_soles from logparam where reckey = '1'), ccd.precio_unitario * ccd.cantidad, ccd.precio_unitario * ccd.cantidad * cc.tasa_cambio), null) as importe_deb,
         decode(md.flag_debhab, 'D', decode(cc.cod_moneda, (select cod_soles from logparam where reckey = '1'), ccd.precio_unitario * ccd.cantidad, ccd.precio_unitario * ccd.cantidad * cc.tasa_cambio), null) as importe_hab
  from articulo_mov_proy amp,
       orden_venta       ov,
       articulo          a,
       cntas_cobrar      cc,
       cntas_cobrar_det  ccd,
       proveedor         p,
       concepto_financiero   cf,
       matriz_cntbl_finan_det  md,
       cntbl_cnta              c
  where amp.nro_doc      = ov.nro_ov
    and amp.tipo_doc     = (select doc_ov from logparam where reckey = '1')
    and amp.cod_art      = a.cod_art
    and ccd.org_amp_ref  = amp.cod_origen
    and ccd.nro_amp_ref  = amp.nro_mov
    and cc.tipo_doc      = ccd.tipo_doc
    and cc.nro_doc       = ccd.nro_doc
    and cc.cod_relacion  = p.proveedor
    and ccd.confin       = cf.confin           (+)
    and cf.matriz_cntbl  = md.matriz           (+)
    and md.cnta_ctbl     = c.cnta_ctbl         (+)
    and cc.flag_estado     <> '0'
    and amp.flag_estado    <> '0'
    and ov.flag_estado     <> '0';

prompt
prompt Creating view VW_VTA_FACTURACION_ELECT_DET
prompt ==========================================
prompt
create or replace force view cantabria.vw_vta_facturacion_elect_det as
select rownum as item,
       s."TIPO_DOC",s."NRO_DOC",s."COD_ART",s."DESC_ART",s."DESC_UNIDAD",s."DESCRIPCION",s."PRECIO_UNITARIO",s."TIPO_AFECTACION_IGV",s."MATRICULA",s."NOMB_NAVE",s."DESCR_ESPECIE",s."TIPO_CRED_FISCAL",s."CANTIDAD",s."SUB_TOTAL",s."DESCUENTO",s."IGV",s."ISC",s."CANT_UND2"
from (
    select ccd.tipo_doc, ccd.nro_doc,
           ccd.cod_art,
           a.desc_art,
           --decode(u.desc_unidad, null, 'ZZ', u.desc_unidad) as desc_unidad,
           case
              when u.desc_unidad is null then 'ZZ'
              else u.cod_sunat
           end as desc_unidad,
           ccd.descripcion,
           ccd.precio_unitario,
           cf.tipo_afectacion_igv,
           tn.matricula,
           tn.nomb_nave,
           te.descr_especie,
           ccd.tipo_cred_fiscal,
           sum(ccd.cantidad) as cantidad,
           sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))) as sub_total,
           sum(round(nvl(ccd.precio_unitario * ccd.cantidad * ccd.descuento/ 100,0),2)) as descuento,
           sum((select nvl(sum(ci.importe), 0)
              from cc_doc_det_imp ci
             where ci.tipo_doc = ccd.tipo_doc
               and ci.nro_doc  = ccd.nro_doc
               and ci.item     = ccd.item)) as IGV,
           0 as ISC,
           sum((select nvl(sum(am.cant_proc_und2 * amt.factor_sldo_total * -1) ,0)
              from vale_mov          vm,
                   articulo_mov      am,
                   articulo_mov_tipo amt
             where vm.nro_Vale    = am.nro_Vale
               and vm.tipo_mov    = amt.tipo_mov
               and vm.flag_estado <> '0'
               and am.cod_origen  = ccd.org_am
               and am.nro_mov     = ccd.nro_am )) as cant_und2

        from cntas_cobrar_det ccd,
             articulo         a,
             unidad           u,
             tg_naves         tn,
             credito_fiscal   cf,
             tg_especies       te
        where ccd.cod_art           = a.cod_art (+)
          and a.und                 = u.und     (+)
          and ccd.nave              = tn.nave   (+)
          and ccd.tipo_cred_fiscal  = cf.tipo_cred_fiscal (+)
          and ccd.especie           = te.especie          (+)
          and (ccd.tipo_ref          not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.tipo_doc in ('NCC', 'NDC'))
    group by ccd.tipo_doc, ccd.nro_doc,
           ccd.cod_art,
           a.desc_Art,
           case
              when u.desc_unidad is null then 'ZZ'
              else u.cod_sunat
           end,
           ccd.descripcion,
           ccd.precio_unitario,
           cf.tipo_afectacion_igv,
           tn.matricula,
           tn.nomb_nave,
           ccd.tipo_cred_fiscal,
           te.descr_especie
    having sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))) > 0) s
;

prompt
prompt Creating view VW_VTA_FACTURACION_ELECT
prompt ======================================
prompt
create or replace force view cantabria.vw_vta_facturacion_elect as
select cc.tipo_doc,
         cc.nro_doc,
         to_char(cc.fecha_documento, 'yyyy-mm-dd') as fecha_doc,
         to_char(cc.fecha_vencimiento, 'yyyy-mm-dd') as fecha_vencimiento,
         case
           when cc.tipo_doc = 'FAC' then '01' else '03'
         end as tipo_doc_elect,
         case
           when cc.cod_moneda = 'S/.' then 'PEN' else 'USD'
         end as moneda,
         trim(fp.desc_forma_pago) as forma_pago,
         fp.dias_vencimiento,
         cc.consignado_to,
         cc.peso_neto,
         cc.peso_bruto,
         m.descripcion as desc_moneda,
         (select count(*)
            from VW_VTA_FACTURACION_ELECT_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc) as nro_lineas,
         (select nvl(sum(ci.importe), 0)
            from cc_doc_det_imp ci,
                 impuestos_tipo it
           where ci.tipo_impuesto = it.tipo_impuesto
             and ci.tipo_doc = cc.tipo_doc
             and ci.nro_doc  = cc.nro_doc
             and it.flag_igv = '1') as igv,
         0 as ISC,
         0 as otros_conceptos,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC'))) as precio_venta,
         ((select nvl(sum(ci.importe), 0)
              from cc_doc_det_imp ci,
                   impuestos_tipo it,
                   cntas_cobrar_det ccd2
             where ci.tipo_doc      = ccd2.tipo_doc
               and ci.nro_doc       = ccd2.nro_doc
               and ci.item          = ccd2.item
               and ci.tipo_impuesto = it.tipo_impuesto
               and ci.tipo_doc = cc.tipo_doc
               and ci.nro_doc  = cc.nro_doc
               and (ccd2.tipo_ref not in ('FAC', 'BVC') or ccd2.tipo_ref is null or ccd2.TIPO_DOC in ('NCC', 'NDC'))) +
           (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
              from cntas_cobrar_det ccd
             where ccd.tipo_doc = cc.tipo_doc
               and ccd.nro_doc  = cc.nro_doc
               and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC')))) as total_venta,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '08'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC')))  as exportaciones,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '09'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC')))  as ventas_gravadas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '10'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC')))  as ventas_inafectas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '11'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC')))  as ventas_exoneradas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '12'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC')))  as ventas_gratuitas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NDC')))  as subtotal_venta,
          (select nvl(sum(vw.importe), 0)
            from vw_fact_descuentos vw
           where vw.tipo_doc = cc.tipo_doc
             and vw.nro_doc  = cc.nro_doc) as descuento_global,
          0 as Otros_cargos,
          case
             when cc.flag_detraccion = '1' and trim(cc.bien_serv) = '004' then '1002' -- Opercion Sujeta a detraccion, recursos hidrobiologicos
             when cc.flag_detraccion = '1' then '1001' -- Operación Sujeta a Detracción
             when cc.flag_mercado = 'L' then '0101' -- Venta Interna Nacional
             when cc.flag_mercado = 'E' then '0200' -- Exportacion
          end as Tipo_operacion,
          0 as anticipos_monto,
          '' as anticipos_tipo_doc,
          '' as anticipos_serie,
          -- Detraccion
          nvl(cc.porc_detraccion, 0) as porc_detraccion ,
          --round(decode(cc.tasa_cambio, 0, 0, NVL(cc.imp_detraccion, 0) / cc.tasa_cambio),2) AS imp_detraccion,
          cc.imp_detraccion,
          cc.importe_doc,
          0 as bonificaciones_totales,
          0 as descuentos_totales,
          0 as retenciones_total,
          trim(db.bien_serv) || ' - ' || db.descripcion as desc_bien_serv,
          trim(db.bien_serv) as codigo_sunat_detr,
          (select p1.detr_cta_bco
             from proveedor p1
            where p1.proveedor = e.cod_empresa) as nro_cnta_detraccion,
          -- datos Emisor
          e.nombre as nombre_emisor,
          e.ruc    as ruc_emisor,
          e.direccion as direccion_emisor,
          e.dir_urbanizacion as urb_emisor,
          e.dir_departamento as dpto_emisor,
          e.dir_provincia as prov_emisor,
          e.dir_distrito as distrito_emisor,
          e.dir_ubigeo as ubigeo_emisor,
          -- Datos Cliente
          DECODE(p.nro_doc_ident, null, p.ruc, p.nro_doc_ident) as ruc_receptor,
          p.tipo_doc_ident as tipo_doc_receptor,
          p.nom_proveedor as razon_social_receptor,
          pkg_logistica.of_get_dir_comercial(p.proveedor) as direccion_receptor,
          pkg_logistica.of_get_urbanizacion(p.proveedor) as urb_receptor,
          pkg_logistica.of_get_departamento(p.proveedor) as dpto_receptor,
          pkg_logistica.of_get_provincia(p.proveedor) as prov_receptor,
          pkg_logistica.of_get_distrito(p.proveedor) as distrito_receptor,
          pkg_logistica.of_get_pais(p.proveedor) as pais_receptor,
          p.email as correo_receptor,
          CC.OBSERVACION,
          -- Datos de Exportacion
          pkg_comercializacion.of_get_puerto_origen(cc.tipo_doc, cc.nro_doc) as puerto_origen,
          pkg_comercializacion.of_get_puerto_destino(cc.tipo_doc, cc.nro_doc) as puerto_destino,
          -- Datos del emisor del comprobante
          u.nombre as nom_usuario,
          u.email as email_usuario,
          cc.cod_usr,
          -- DAtos de la nota de credito o Debito
          ref.tipo_ref,
          ref.cod_sunat as tipo_doc_ref,
          PKG_FACT_ELECTRONICA.of_get_full_nro(ref.nro_ref) as nro_ref,
          ref.fec_emision_ref,
          ref.motivo,
          ref.desc_motivo_nota,
          ref.tipo_doc_sunat,
          ref.tipo_nota,
          ref.desc_tipo_nota

  from cntas_cobrar   cc,
       proveedor      p,
       empresa        e,
       detr_bien_serv db,
       moneda         m,
       forma_pago     fp,
       usuario        u,
       (select distinct ccd.tipo_ref,
               ccd.nro_ref,
               dt.cod_sunat,
               ccd.tipo_doc, ccd.nro_doc,
               dt2.cod_sunat as tipo_doc_sunat,
               mn.descripcion as desc_motivo_nota,
               mn.motivo,
               decode(mn.tipo_nc, null, mn.tipo_nd, mn.tipo_nc) as tipo_nota,
               decode(s1.desc_tipo_nc, null, s2.desc_tipo_nd, s1.desc_tipo_nc) as desc_tipo_nota,
               to_char(cc.fecha_documento, 'yyyy-mm-dd') as fec_emision_ref
          from cntas_cobrar     cc,
               cntas_cobrar_det ccd,
               doc_tipo         dt,
               doc_tipo         dt2,
               motivo_nota      mn,
               sunat_catalogo09 s1,
               sunat_catalogo10 s2
          where cc.tipo_doc  = ccd.tipo_doc
            and cc.nro_doc   = ccd.nro_doc
            and cc.motivo    = mn.motivo
            and ccd.tipo_ref = dt.tipo_doc
            and cc.tipo_doc  = dt2.tipo_doc
            and mn.tipo_nc   = s1.tipo_nc    (+)
            and mn.tipo_nd   = s2.tipo_nd    (+)
            and ccd.tipo_doc in ('NCC', 'NDC')
            and nro_ref is not null) ref
  where e.cod_empresa = 'E0000000'
    and cc.cod_relacion = p.proveedor
    and cc.bien_serv    = db.bien_serv                    (+)
    and cc.cod_moneda   = m.cod_moneda                    (+)
    and cc.forma_pago   = fp.forma_pago                   (+)
    and cc.cod_usr      = u.cod_usr                       (+)
    and cc.tipo_doc     = ref.tipo_doc                      (+)
    and cc.nro_doc      = ref.nro_doc                       (+)
    and cc.tipo_doc in ('FAC', 'BVC', 'NCC', 'NDC')
    and cc.flag_enviar_efact   = '1'
    and cc.fec_envio_efact is null
  --  and cc.nro_doc = '002-003386'
  --  and cc.tipo_doc = 'BVC'
;

prompt
prompt Creating view VW_VTA_FACTURACION_ELECT_OLD
prompt ==========================================
prompt
create or replace force view cantabria.vw_vta_facturacion_elect_old as
select cc.tipo_doc,
         cc.nro_doc,
         to_char(cc.fecha_documento, 'yyyy-mm-dd') as fecha_doc,
         to_char(cc.fecha_vencimiento, 'yyyy-mm-dd') as fecha_vencimiento,
         case
           when cc.tipo_doc = 'FAC' then '01' else '03'
         end as tipo_doc_elect,
         case
           when cc.cod_moneda = 'S/.' then 'PEN' else 'USD'
         end as moneda,
         trim(fp.desc_forma_pago) as forma_pago,
         fp.dias_vencimiento,
         cc.consignado_to,
         cc.peso_neto,
         cc.peso_bruto,
         m.descripcion as desc_moneda,
         (select count(*)
            from VW_VTA_FACTURACION_ELECT_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc) as nro_lineas,
         (select nvl(sum(ci.importe), 0)
            from cc_doc_det_imp ci,
                 impuestos_tipo it
           where ci.tipo_impuesto = it.tipo_impuesto
             and ci.tipo_doc = cc.tipo_doc
             and ci.nro_doc  = cc.nro_doc
             and it.flag_igv = '1') as igv,
         0 as ISC,
         0 as otros_conceptos,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD'))) as precio_venta,
         ((select nvl(sum(ci.importe), 0)
              from cc_doc_det_imp ci,
                   impuestos_tipo it,
                   cntas_cobrar_det ccd2
             where ci.tipo_doc      = ccd2.tipo_doc
               and ci.nro_doc       = ccd2.nro_doc
               and ci.item          = ccd2.item
               and ci.tipo_impuesto = it.tipo_impuesto
               and ci.tipo_doc = cc.tipo_doc
               and ci.nro_doc  = cc.nro_doc
               and (ccd2.tipo_ref not in ('FAC', 'BVC') or ccd2.tipo_ref is null or ccd2.TIPO_DOC in ('NCC', 'NCD'))) +
           (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
              from cntas_cobrar_det ccd
             where ccd.tipo_doc = cc.tipo_doc
               and ccd.nro_doc  = cc.nro_doc
               and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD')))) as total_venta,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '08'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD')))  as exportaciones,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '09'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD')))  as ventas_gravadas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '10'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD')))  as ventas_inafectas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '11'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD')))  as ventas_exoneradas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '12'
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD')))  as ventas_gratuitas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and (ccd.tipo_ref not in ('FAC', 'BVC') or ccd.tipo_ref is null or ccd.TIPO_DOC in ('NCC', 'NCD')))  as subtotal_venta,
          (select nvl(sum(vw.importe), 0)
            from vw_fact_descuentos vw
           where vw.tipo_doc = cc.tipo_doc
             and vw.nro_doc  = cc.nro_doc) as descuento_global,
          0 as Otros_cargos,
          case
             when cc.flag_detraccion = '1' and trim(cc.bien_serv) = '004' then '1002' -- Opercion Sujeta a detraccion, recursos hidrobiologicos
             when cc.flag_detraccion = '1' then '1001' -- Operación Sujeta a Detracción
             when cc.flag_mercado = 'L' then '0101' -- Venta Interna Nacional
             when cc.flag_mercado = 'E' then '0200' -- Exportacion
          end as Tipo_operacion,
          0 as anticipos_monto,
          '' as anticipos_tipo_doc,
          '' as anticipos_serie,
          -- Detraccion
          nvl(cc.porc_detraccion, 0) as porc_detraccion ,
          --round(decode(cc.tasa_cambio, 0, 0, NVL(cc.imp_detraccion, 0) / cc.tasa_cambio),2) AS imp_detraccion,
          cc.imp_detraccion,
          cc.importe_doc,
          0 as bonificaciones_totales,
          0 as descuentos_totales,
          0 as retenciones_total,
          trim(db.bien_serv) || ' - ' || db.descripcion as desc_bien_serv,
          trim(db.bien_serv) as codigo_sunat_detr,
          (select p1.detr_cta_bco
             from proveedor p1
            where p1.proveedor = e.cod_empresa) as nro_cnta_detraccion,
          -- datos Emisor
          e.nombre as nombre_emisor,
          e.ruc    as ruc_emisor,
          e.direccion as direccion_emisor,
          e.dir_urbanizacion as urb_emisor,
          e.dir_departamento as dpto_emisor,
          e.dir_provincia as prov_emisor,
          e.dir_distrito as distrito_emisor,
          e.dir_ubigeo as ubigeo_emisor,
          -- Datos Cliente
          DECODE(p.nro_doc_ident, null, p.ruc, p.nro_doc_ident) as ruc_receptor,
          p.tipo_doc_ident as tipo_doc_receptor,
          p.nom_proveedor as razon_social_receptor,
          pkg_logistica.of_get_dir_comercial(p.proveedor) as direccion_receptor,
          pkg_logistica.of_get_urbanizacion(p.proveedor) as urb_receptor,
          pkg_logistica.of_get_departamento(p.proveedor) as dpto_receptor,
          pkg_logistica.of_get_provincia(p.proveedor) as prov_receptor,
          pkg_logistica.of_get_distrito(p.proveedor) as distrito_receptor,
          pkg_logistica.of_get_pais(p.proveedor) as pais_receptor,
          p.email as correo_receptor,
          CC.OBSERVACION,
          -- Datos de Exportacion
          pkg_comercializacion.of_get_puerto_origen(cc.tipo_doc, cc.nro_doc) as puerto_origen,
          pkg_comercializacion.of_get_puerto_destino(cc.tipo_doc, cc.nro_doc) as puerto_destino,
          -- Datos del emisor del comprobante
          u.nombre as nom_usuario,
          u.email as email_usuario,
          cc.cod_usr,
          -- DAtos de la nota de credito o Debito
          ref.tipo_ref,
          ref.cod_sunat as tipo_doc_ref,
          PKG_FACT_ELECTRONICA.of_get_full_nro(ref.nro_ref) as nro_ref,
          ref.fec_emision_ref,
          ref.motivo,
          ref.desc_motivo_nota,
          ref.tipo_doc_sunat,
          ref.tipo_nota,
          ref.desc_tipo_nota

  from cntas_cobrar   cc,
       proveedor      p,
       empresa        e,
       detr_bien_serv db,
       moneda         m,
       forma_pago     fp,
       usuario        u,
       (select distinct ccd.tipo_ref,
               ccd.nro_ref,
               dt.cod_sunat,
               ccd.tipo_doc, ccd.nro_doc,
               dt2.cod_sunat as tipo_doc_sunat,
               mn.descripcion as desc_motivo_nota,
               mn.motivo,
               decode(mn.tipo_nc, null, mn.tipo_nd, mn.tipo_nc) as tipo_nota,
               decode(s1.desc_tipo_nc, null, s2.desc_tipo_nd, s1.desc_tipo_nc) as desc_tipo_nota,
               to_char(cc.fecha_documento, 'yyyy-mm-dd') as fec_emision_ref
          from cntas_cobrar     cc,
               cntas_cobrar_det ccd,
               doc_tipo         dt,
               doc_tipo         dt2,
               motivo_nota      mn,
               sunat_catalogo09 s1,
               sunat_catalogo10 s2
          where cc.tipo_doc  = ccd.tipo_doc
            and cc.nro_doc   = ccd.nro_doc
            and cc.motivo    = mn.motivo
            and ccd.tipo_ref = dt.tipo_doc
            and cc.tipo_doc  = dt2.tipo_doc
            and mn.tipo_nc   = s1.tipo_nc    (+)
            and mn.tipo_nd   = s2.tipo_nd    (+)
            and ccd.tipo_doc in ('NCC', 'NDC')
            and nro_ref is not null) ref
  where e.cod_empresa = 'E0000000'
    and cc.cod_relacion = p.proveedor
    and cc.bien_serv    = db.bien_serv                    (+)
    and cc.cod_moneda   = m.cod_moneda                    (+)
    and cc.forma_pago   = fp.forma_pago                   (+)
    and cc.cod_usr      = u.cod_usr                       (+)
    and cc.tipo_doc     = ref.tipo_doc                      (+)
    and cc.nro_doc      = ref.nro_doc                       (+)
    and cc.tipo_doc in ('FAC', 'BVC', 'NCC', 'NDC')
    and cc.flag_enviar_efact   = '1'
    and cc.fec_envio_efact is null
  --  and cc.nro_doc = '002-003386'
  --  and cc.tipo_doc = 'BVC'
;

prompt
prompt Creating view VW_VTA_REG_VENTAS
prompt ===============================
prompt
create or replace force view cantabria.vw_vta_reg_ventas as
select   cc.origen,
         cc.fecha_documento,
         cc.ano,
         cc.mes,
         cc.tipo_doc,
         dt.cod_sunat,
         dt.desc_tipo_doc,
         cc.forma_pago,
         fp.desc_forma_pago,
         cc.fecha_vencimiento,
         cc.fecha_presentacion,
         PKG_FACT_ELECTRONICA.of_get_serie(cc.nro_doc) as serie_cp,
         PKG_FACT_ELECTRONICA.of_get_nro(cc.nro_doc) as numero_cp,
         PKG_FACT_ELECTRONICA.of_get_full_nro(cc.nro_doc) as full_nro_doc,
         cc.nro_doc,
         cc.cod_relacion,
         cc.observacion,
         cc.nro_asiento,
         p.nom_proveedor,
         p.tipo_doc_ident,
         decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
         p.flag_nac_ext,
         cc.flag_estado,
         dt.flag_signo,
         cc.cod_usr,
         cc.cod_moneda,
         cc.saldo_sol,
         cc.saldo_dol,
         case
           when cc.cod_moneda = PKG_LOGISTICA.of_soles(null) then
             cc.importe_doc
           else
             cc.importe_doc * cc.tasa_cambio
         end * decode(dt.flag_signo, '+', 1, -1) as imp_soles,
         case
           when cc.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
             cc.importe_doc
           else
             cc.importe_doc / cc.tasa_cambio
         end * decode(dt.flag_signo, '+', 1, -1) as imp_dolar,
         cc.origen || trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) || trim(to_char(cc.nro_libro, '00')) || trim(to_char(cc.nro_asiento, '00000')) as voucher,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
                 * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '08') as exportaciones,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
                 * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '09') as vta_afectas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
                 * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '10') as vta_inafectas,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
                 * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ccd.tipo_cred_fiscal = '11') as vta_exoneradas,
         (select nvl(sum(ci.importe), 0) * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd,
                 cc_doc_det_imp   ci,
                 impuestos_tipo   it
           where ccd.tipo_doc = ci.tipo_doc
             and ccd.nro_doc  = ci.nro_doc
             and ccd.item     = ci.item
             and ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ci.tipo_impuesto = it.tipo_impuesto
             and ccd.tipo_cred_fiscal = '09'
             and it.flag_igv          = '1'
             and it.tipo_impuesto  <> PKG_CONFIG.USF_GET_PARAMETER('IMPUESTO_ICBPER', 'ICBPE')) as igv_afecto,
         (select nvl(sum(ci.importe), 0) * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd,
                 cc_doc_det_imp   ci,
                 impuestos_tipo   it
           where ccd.tipo_doc = ci.tipo_doc
             and ccd.nro_doc  = ci.nro_doc
             and ccd.item     = ci.item
             and ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ci.tipo_impuesto = it.tipo_impuesto
             and ccd.tipo_cred_fiscal in ('10', '11')
             and it.flag_igv          = '1'
             and it.tipo_impuesto  <> PKG_CONFIG.USF_GET_PARAMETER('IMPUESTO_ICBPER', 'ICBPE')) as igv_inafecto,
         (select nvl(sum(ci.importe), 0) * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd,
                 cc_doc_det_imp   ci,
                 impuestos_tipo   it
           where ccd.tipo_doc = ci.tipo_doc
             and ccd.nro_doc  = ci.nro_doc
             and ccd.item     = ci.item
             and ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc
             and ci.tipo_impuesto = it.tipo_impuesto
             and it.tipo_impuesto  = PKG_CONFIG.USF_GET_PARAMETER('IMPUESTO_ICBPER', 'ICBPE')) as icbper,
         (select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
                  * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc) as base_imponible,
         (select nvl(sum(ci.importe), 0) * decode(dt.flag_signo, '+', 1, -1)
            from cc_doc_det_imp ci
           where ci.tipo_doc = cc.tipo_doc
             and ci.nro_doc  = cc.nro_doc) as total_igv,
         ((select nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0)) ), 0)
                  * decode(dt.flag_signo, '+', 1, -1)
            from cntas_cobrar_det ccd
           where ccd.tipo_doc = cc.tipo_doc
             and ccd.nro_doc  = cc.nro_doc) +
          (select nvl(sum(ci.importe), 0) * decode(dt.flag_signo, '+', 1, -1)
            from cc_doc_det_imp ci
           where ci.tipo_doc = cc.tipo_doc
             and ci.nro_doc  = cc.nro_doc)) as total_venta,
       (select nota_credito from finparam where reckey = '1') as ncc,
       (select cb.centro_benef
          from cntas_cobrar_det ccd,
               centro_beneficio cb
         where ccd.centro_benef = cb.centro_benef
           and ccd.tipo_doc     = cc.tipo_doc
           and ccd.nro_doc      = cc.nro_doc
           and rownum           = 1)    as centro_benef,
       (select cb.desc_centro
          from cntas_cobrar_det ccd,
               centro_beneficio cb
         where ccd.centro_benef = cb.centro_benef
           and ccd.tipo_doc     = cc.tipo_doc
           and ccd.nro_doc      = cc.nro_doc
           and rownum           = 1)    as desc_centro,
       (select max(trunc(cb.fecha_emision))
          from caja_bancos cb,
               caja_bancos_det cbd
         where cb.origen       = cbd.origen
           and cb.nro_registro = cbd.nro_registro
           and cbd.tipo_doc      = cc.tipo_doc
           and cbd.nro_doc       = cc.nro_doc
           and cbd.cod_relacion  = cc.cod_relacion
           and cb.flag_estado    <> '0') as fec_deposito

  from cntas_cobrar     cc,
       doc_tipo         dt,
       proveedor        p,
       forma_pago       fp
  where cc.tipo_doc     = dt.tipo_doc
    and cc.cod_relacion = p.proveedor
    and cc.forma_pago   = fp.forma_pago
    and cc.nro_asiento is not null
    and cc.nro_libro   = 4       -- Registro de ventas
    and cc.flag_estado <> '0'
;

prompt
prompt Creating view VW_VTA_REG_VENTAS_DET
prompt ===================================
prompt
create or replace force view cantabria.vw_vta_reg_ventas_det as
select   cc.origen || trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) || trim(to_char(cc.nro_libro, '00')) || trim(to_char(cc.nro_asiento, '00000')) as voucher,
           cc.origen,
           cc.fecha_documento,
           cc.ano,
           cc.mes,
           cc.tipo_doc,
           dt.cod_sunat,
           dt.desc_tipo_doc,
           cc.forma_pago,
           fp.desc_forma_pago,
           cc.fecha_vencimiento,
           cc.tasa_cambio,
           cc.fecha_presentacion,
           PKG_FACT_ELECTRONICA.of_get_serie(cc.nro_doc) as serie_cp,
           PKG_FACT_ELECTRONICA.of_get_nro(cc.nro_doc) as numero_cp,
           PKG_FACT_ELECTRONICA.of_get_full_nro(cc.nro_doc) as full_nro_doc,
           cc.nro_doc,
           cc.cod_relacion,
           cc.observacion,
           cc.nro_asiento,
           p.nom_proveedor,
           p.tipo_doc_ident,
           decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
           p.flag_nac_ext,
           cc.flag_estado,
           dt.flag_signo,
           cc.cod_moneda,
           cc.observacion as glosa_cabecera,
           ccd.item,
           a1.cat_art,
           a1.desc_categoria,
           a2.cod_sub_cat,
           a2.desc_sub_cat,
           ccd.cod_art,
           ccd.descripcion as desc_detalle,
           ccd.und,
           ccd.und2,
           ccd.tipo_cred_fiscal,
           ccd.centro_benef,
           cb.desc_centro as desc_centro_benef,
           cc.cod_usr,
           ccd.org_am,
           ccd.nro_am,
           cc.vendedor,
           v.nom_vendedor,
           cc.importe_doc,
           ccd.org_amp_ref,
           ccd.nro_amp_ref,
           (select nota_credito from finparam where reckey = '1') as ncc,
           sum(ccd.cantidad) as cantidad,
           sum(ccd.cantidad_und2) as cantidad_und2,
           case
             when sum(ccd.cantidad) <> 0 then
               sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))) / sum(ccd.cantidad)
             else
               0
           end * decode(dt.flag_signo, '+', 1, -1) as precio_unit,
           nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))),0)
               * decode(dt.flag_signo, '+', 1, -1) as base_imponible,
           nvl(sum(
             (select nvl(ci.importe, 0) * decode(it.signo, '-', -1, 1)
                from cc_doc_det_imp   ci,
                     impuestos_tipo   it
               where ccd.tipo_doc = ci.tipo_doc
                 and ccd.nro_doc  = ci.nro_doc
                 and ccd.item     = ci.item
                 and ci.tipo_impuesto = it.tipo_impuesto
                 and it.flag_igv      = '1')
           ),0) * decode(dt.flag_signo, '+', 1, -1) as importe_igv,
           (
              nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))),0) +
              nvl(sum(
                   (select nvl(ci.importe, 0) * decode(it.signo, '-', -1, 1)
                      from cc_doc_det_imp   ci,
                           impuestos_tipo   it
                     where ccd.tipo_doc = ci.tipo_doc
                       and ccd.nro_doc  = ci.nro_doc
                       and ccd.item     = ci.item
                       and ci.tipo_impuesto = it.tipo_impuesto
                       and it.flag_igv      = '1')),0)
           ) * decode(dt.flag_signo, '+', 1, -1) as total_venta,
           case
             when sum(ccd.cantidad) <> 0 then
               (
                  nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))),0) +
                  nvl(sum(
                       (select nvl(ci.importe, 0) * decode(it.signo, '-', -1, 1)
                          from cc_doc_det_imp   ci,
                               impuestos_tipo   it
                         where ccd.tipo_doc = ci.tipo_doc
                           and ccd.nro_doc  = ci.nro_doc
                           and ccd.item     = ci.item
                           and ci.tipo_impuesto = it.tipo_impuesto
                           and it.flag_igv      = '1')),0)
               ) / sum(ccd.cantidad)
             else
               0
           end * decode(dt.flag_signo, '+', 1, -1) as precio_vta,
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_soles(null) then
               nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))),0) +
               nvl(sum(
                   (select nvl(ci.importe, 0) * decode(it.signo, '-', -1, 1)
                      from cc_doc_det_imp   ci,
                           impuestos_tipo   it
                     where ccd.tipo_doc = ci.tipo_doc
                       and ccd.nro_doc  = ci.nro_doc
                       and ccd.item     = ci.item
                       and ci.tipo_impuesto = it.tipo_impuesto
                       and it.flag_igv      = '1')),0)
             else
               (nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))),0) +
                nvl(sum(
                   (select nvl(ci.importe, 0) * decode(it.signo, '-', -1, 1)
                      from cc_doc_det_imp   ci,
                           impuestos_tipo   it
                     where ccd.tipo_doc = ci.tipo_doc
                       and ccd.nro_doc  = ci.nro_doc
                       and ccd.item     = ci.item
                       and ci.tipo_impuesto = it.tipo_impuesto
                       and it.flag_igv      = '1')),0)) * cc.tasa_cambio
           end * decode(dt.flag_signo, '+', 1, -1) as imp_soles,
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
               nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))),0) +
               nvl(sum(
                   (select nvl(ci.importe, 0) * decode(it.signo, '-', -1, 1)
                      from cc_doc_det_imp   ci,
                           impuestos_tipo   it
                     where ccd.tipo_doc = ci.tipo_doc
                       and ccd.nro_doc  = ci.nro_doc
                       and ccd.item     = ci.item
                       and ci.tipo_impuesto = it.tipo_impuesto
                       and it.flag_igv      = '1')),0)
             else
               (nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))),0) +
                nvl(sum(
                   (select nvl(ci.importe, 0) * decode(it.signo, '-', -1, 1)
                      from cc_doc_det_imp   ci,
                           impuestos_tipo   it
                     where ccd.tipo_doc = ci.tipo_doc
                       and ccd.nro_doc  = ci.nro_doc
                       and ccd.item     = ci.item
                       and ci.tipo_impuesto = it.tipo_impuesto
                       and it.flag_igv      = '1')),0)) / cc.tasa_cambio
           end * decode(dt.flag_signo, '+', 1, -1) as imp_dolar,
           case
             when ccd.tipo_cred_fiscal = '08' then
               nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))), 0)
                   * decode(dt.flag_signo, '+', 1, -1)
             else
               0
           end as exportaciones,
           case
             when ccd.tipo_cred_fiscal = '09' then
               nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))), 0)
                   * decode(dt.flag_signo, '+', 1, -1)
             else
               0
           end as vta_afectas,
           case
             when ccd.tipo_cred_fiscal = '10' then
               nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))), 0)
                   * decode(dt.flag_signo, '+', 1, -1)
             else
               0
           end as vta_inafectas,
           case
             when ccd.tipo_cred_fiscal = '11' then
               nvl(sum(ccd.cantidad * (ccd.precio_unitario - ccd.precio_unitario * nvl(ccd.descuento,0) / 100 + nvl(ccd.redondeo_manual,0))), 0)
                   * decode(dt.flag_signo, '+', 1, -1)
             else
               0
           end as vta_exoneradas,
           case
             when ccd.tipo_cred_fiscal = '09' then
               nvl(sum(
                   (select nvl(ci.importe, 0) * decode(dt.flag_signo, '+', 1, -1) * decode(it.signo, '-', -1, 1)
                      from cc_doc_det_imp   ci,
                           impuestos_tipo   it
                     where ccd.tipo_doc = ci.tipo_doc
                       and ccd.nro_doc  = ci.nro_doc
                       and ccd.item     = ci.item
                       and ci.tipo_impuesto = it.tipo_impuesto
                       and it.flag_igv      = '1')
                 ),0)
             else
               0
           end as igv_afecto,
           case
             when ccd.tipo_cred_fiscal = '10' then
               nvl(sum(
                   (select nvl(ci.importe, 0) * decode(dt.flag_signo, '+', 1, -1) * decode(it.signo, '-', -1, 1)
                      from cc_doc_det_imp   ci,
                           impuestos_tipo   it
                     where ccd.tipo_doc = ci.tipo_doc
                       and ccd.nro_doc  = ci.nro_doc
                       and ccd.item     = ci.item
                       and ci.tipo_impuesto = it.tipo_impuesto
                       and it.flag_igv      = '1')
                 ),0)
             else
               0
           end as igv_inafecto,
           -- Porcentaje del IGV
           nvl(max(
               (select max(it.tasa_impuesto)
                  from cc_doc_det_imp   ci,
                       impuestos_tipo   it
                 where ccd.tipo_doc = ci.tipo_doc
                   and ccd.nro_doc  = ci.nro_doc
                   and ccd.item     = ci.item
                   and ci.tipo_impuesto = it.tipo_impuesto
                   and it.flag_igv      = '1')
             ),18) as porc_igv,
           nvl(max(
               (select max(it.tipo_impuesto)
                  from cc_doc_det_imp   ci,
                       impuestos_tipo   it
                 where ccd.tipo_doc = ci.tipo_doc
                   and ccd.nro_doc  = ci.nro_doc
                   and ccd.item     = ci.item
                   and ci.tipo_impuesto = it.tipo_impuesto
                   and it.flag_igv      = '1')
             ),'IGV18') as cod_igv,
           ccd.tipo_ref,
           ccd.nro_ref,
           ccd.item_ref,
           PKG_FACT_ELECTRONICA.of_get_serie(ccd.nro_ref) as serie_cc_ref,
           PKG_FACT_ELECTRONICA.of_get_nro(ccd.nro_ref) as numero_cc_ref,
           case
             when cc.tipo_doc in ('NCC', 'NDC') then
               (select ccr.fecha_documento
                  from cntas_cobrar     ccr
                 where ccr.tipo_doc    = ccd.tipo_ref
                   and ccr.nro_doc     = ccd.nro_ref)
             else
               null
           end as fecha_emision_ref,
           (select max(trunc(cb.fecha_emision))
             from caja_bancos cb,
                  caja_bancos_det cbd
            where cb.origen       = cbd.origen
              and cb.nro_registro = cbd.nro_registro
              and cbd.tipo_doc      = cc.tipo_doc
              and cbd.nro_doc       = cc.nro_doc
              and cbd.cod_relacion  = cc.cod_relacion
              and cb.flag_estado    <> '0') as fec_deposito
    from cntas_cobrar        cc,
         cntas_cobrar_det    ccd,
         articulo            a,
         centro_beneficio    cb,
         doc_tipo            dt,
         proveedor           p,
         forma_pago          fp,
         vendedor            v,
         articulo_sub_categ  a2,
         articulo_categ      a1
    where cc.tipo_doc       = ccd.tipo_doc
      and cc.nro_doc        = ccd.nro_doc
      and cc.tipo_doc       = dt.tipo_doc
      and cc.cod_relacion   = p.proveedor
      and cc.forma_pago     = fp.forma_pago
      and ccd.cod_art       = a.cod_art       (+)
      and a.sub_cat_art     = a2.cod_sub_cat  (+)
      and a2.cat_art        = a1.cat_art      (+)
      and ccd.centro_benef  = cb.centro_benef (+)
      and cc.vendedor       = v.vendedor
      and cc.nro_asiento is not null
      and cc.nro_libro   = 4       -- Registro de ventas
      and cc.flag_estado <> '0'
  group by cc.origen || trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) || trim(to_char(cc.nro_libro, '00')) || trim(to_char(cc.nro_asiento, '00000')) ,
           cc.origen,
           cc.fecha_documento,
           cc.ano,
           cc.mes,
           cc.tipo_doc,
           dt.cod_sunat,
           dt.desc_tipo_doc,
           cc.forma_pago,
           fp.desc_forma_pago,
           cc.fecha_vencimiento,
           cc.fecha_presentacion,
           PKG_FACT_ELECTRONICA.of_get_serie(cc.nro_doc),
           PKG_FACT_ELECTRONICA.of_get_nro(cc.nro_doc),
           PKG_FACT_ELECTRONICA.of_get_full_nro(cc.nro_doc),
           cc.nro_doc,
           cc.cod_relacion,
           cc.observacion,
           cc.nro_asiento,
           p.nom_proveedor,
           p.tipo_doc_ident,
           decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident),
           p.flag_nac_ext,
           cc.flag_estado,
           dt.flag_signo,
           cc.cod_moneda,
           cc.observacion,
           ccd.item,
           a1.cat_art,
           a1.desc_categoria,
           a2.cod_sub_cat,
           a2.desc_sub_cat,
           ccd.cod_art,
           ccd.descripcion,
           ccd.und,
           ccd.und2,
           cc.cod_usr,
           ccd.tipo_cred_fiscal,
           ccd.tipo_cred_fiscal,
           ccd.centro_benef,
           cb.desc_centro,
           ccd.tipo_ref,
           ccd.nro_ref,
           ccd.item_ref,
           cc.tasa_cambio,
           ccd.org_am,
           ccd.nro_am,
           cc.vendedor,
           v.nom_vendedor,
           cc.importe_doc,
           ccd.org_amp_ref,
           ccd.nro_amp_ref
  order by tipo_doc, nro_doc
;

prompt
prompt Creating view VW_VTA_VENTAS
prompt ===========================
prompt
create or replace force view cantabria.vw_vta_ventas as
Select nvl(cc.vendedor,'S/V') As vendedor,
           nvl(u.nombre,'S/Vendedor') As nom_vendedor,
           cc.cod_relacion,
           p.nom_proveedor,
           p.tipo_doc_ident,
           cc.nro_registro_fs,
           decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
           dt.cod_sunat as tipo_doc_sunat,
           decode(dt.flag_signo, '+', 1, -1) as factor,
           cc.tipo_doc,
           pkg_fact_electronica.of_get_serie(cc.nro_doc) as serie,
           pkg_fact_electronica.of_get_nro(cc.nro_doc) as numero,
           pkg_fact_electronica.of_get_full_nro(cc.nro_doc) as nro_doc,
           cc.fecha_registro,
           cc.fecha_documento as fecha_emision,
           to_Char(cc.fecha_documento, 'mm') as periodo,
           cc.tasa_cambio,
           cc.cod_moneda,
           cc.cod_usr,
           ccd.cod_art,
           decode(a.desc_art, null, ccd.descripcion, a.full_desc_art) as descripcion,
           a.cat_art,
           a.desc_categoria,
           a.cod_sub_cat,
           a.desc_sub_cat,
           cc.flag_estado,
           ccd.cantidad,
           ccd.precio_unitario,
           ccd.precio_unitario * nvl(ccd.descuento,0) / 100 as descuento,
           ccd.cantidad * ccd.precio_unitario * (1 - nvl(ccd.descuento,0) / 100) As base_imponible,
           ccd.cantidad As unidades,
           cc.origen,
           cc.ano,
           cc.mes,
           cc.nro_libro,
           cc.nro_asiento,
           (select nvl(sum(ci.importe), 0)
              from cc_doc_det_imp ci
             where ci.tipo_doc    = cc.tipo_doc
               and ci.nro_doc     = cc.nro_doc
               and ci.item        = ccd.item) as importe_igv,
           -- Calculo la base imponible en soles
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_soles(null) then
               ccd.cantidad * ccd.precio_unitario
             else
               ccd.cantidad * ccd.precio_unitario * cc.tasa_cambio
           end as base_sol,
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
               ccd.cantidad * ccd.precio_unitario
             else
               ccd.cantidad * ccd.precio_unitario / cc.tasa_cambio
           end as base_dol,
           -- Calculo del IGV en Soles
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_soles(null) then
               (select nvl(sum(ci.importe), 0)
                  from cc_doc_det_imp ci
                 where ci.tipo_doc    = cc.tipo_doc
                   and ci.nro_doc     = cc.nro_doc
                   and ci.item        = ccd.item)
             else
               (select nvl(sum(ci.importe), 0) * cc.tasa_cambio
                  from cc_doc_det_imp ci
                 where ci.tipo_doc    = cc.tipo_doc
                   and ci.nro_doc     = cc.nro_doc
                   and ci.item        = ccd.item)
           end as igv_sol,
           -- Calculo del IGV en Dolares
           case
             when cc.cod_moneda = PKG_LOGISTICA.of_dolares(null) then
               (select nvl(sum(ci.importe), 0)
                  from cc_doc_det_imp ci
                 where ci.tipo_doc    = cc.tipo_doc
                   and ci.nro_doc     = cc.nro_doc
                   and ci.item        = ccd.item)
             else
               (select nvl(sum(ci.importe), 0) / cc.tasa_cambio
                  from cc_doc_det_imp ci
                 where ci.tipo_doc    = ccd.tipo_doc
                   and ci.nro_doc     = ccd.nro_doc
                   and ci.item        = ccd.item)
           end as igv_dol,
           (select am.precio_unit
              from articulo_mov am
             where am.cod_origen = ccd.org_am
               and am.nro_mov    = ccd.nro_am) as costo_unit,
           (select am.precio_unit * am.cant_procesada
              from articulo_mov am
             where am.cod_origen = ccd.org_am
               and am.nro_mov    = ccd.nro_am) as total_costo,
           (select am.cod_moneda
              from articulo_mov am
             where am.cod_origen = ccd.org_am
               and am.nro_mov    = ccd.nro_am) as mon_costo


      From cntas_cobrar cc,
           cntas_cobrar_det ccd,
           vw_Articulo      a,
           usuario          u,
           proveedor        p,
           doc_tipo         dt
     Where cc.tipo_doc      = ccd.tipo_doc
       And cc.nro_doc       = ccd.nro_doc
       And ccd.cod_art      = a.cod_art     (+)
       And cc.vendedor      = u.cod_usr     (+)
       And cc.cod_relacion  = p.proveedor   (+)
       and cc.tipo_doc      = dt.tipo_doc
       and cc.flag_provisionado = 'R'
       and cc.nro_libro         = 4
       --And trunc(cc.fecha_registro) between trunc(:adi_fecha1) and  trunc(:adi_fecha2)
       --And cc.flag_estado  <> '0'
;

prompt
prompt Creating view W_LUIS
prompt ====================
prompt
CREATE OR REPLACE FORCE VIEW CANTABRIA.W_LUIS AS
SELECT  DISTINCT pdad.cod_trabajador,
        trunc(pd.fecha) as fecha,
        (select rhp.cnc_dstj_domingo from rrhhparam rhp where rhp.reckey = '1') AS concepto_rrhh,
        sum(nvl(pdad.cant_destajada,0) * nvl(pdad.tarifa_normal,0) * nvl(pdad.factor_calculo,0)) as monto
     from pd_ot pd,pd_ot_det pdd,pd_ot_asist_destajo pdad,labor l
    where (pd.nro_parte        = pdd.nro_parte       ) and
          (pdd.nro_parte       = pdad.nro_parte      ) and
          (pdd.nro_item        = pdad.nro_item       ) and
          (pdd.cod_labor       = l.cod_labor         ) and
          TO_CHAR(PD.FECHA, 'yyyymmdd') BETWEEN '20070201' AND '20070204' AND
          (pdad.flag_procesado = '0'                 ) and
          (substr(pd.nro_parte,1,2) = 'SC' ) AND
          to_char(pd.fecha,'d') = '1'
 group by l.concepto_rrhh, pdad.cod_trabajador,pd.fecha;

prompt
prompt Creating view WV_FIN_NUM_DOC_SERIE
prompt ==================================
prompt
create or replace force view cantabria.wv_fin_num_doc_serie as
select dt.desc_tipo_doc, to_char(ndt.nro_serie) as nro_serie, ndt.tipo_doc
      from num_doc_tipo ndt
         inner join doc_tipo dt on ndt.tipo_doc = dt.tipo_doc;

prompt
prompt Creating view WV_MIGR_ART_SIN_CLASE
prompt ===================================
prompt
create or replace force view cantabria.wv_migr_art_sin_clase as
Select a.cod_art, a.nom_articulo
      from articulo a
      where a.sub_cat_art is null
         and a.cod_clase is null;


spool off
