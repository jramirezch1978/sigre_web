-------------------------------------------------------
-- Export file for user CANTABRIA@HADES              --
-- Created by jramirez on 15/05/2026, 08:11:51 p. m. --
-------------------------------------------------------

set define off
spool package_body_cantabria.log

prompt
prompt Creating package body PKG_ALMACEN
prompt =================================
prompt
create or replace package body cantabria.PKG_ALMACEN is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  function of_get_cant_despachada(asi_nro_guia in guia.nro_guia%TYPE
  ) return number is
    ln_Return number;
  begin
    
    select abs(nvl(sum(am.cant_procesada * amt.factor_sldo_total * -1), 0) )
      into ln_Return
      from guia g,
           guia_vale gv,
           vale_mov  vm,
           articulo_mov am,
           articulo_mov_tipo amt
     where g.nro_guia = gv.nro_guia
       and gv.nro_vale = vm.nro_vale
       and vm.nro_vale = am.nro_vale
       and vm.tipo_mov = amt.tipo_mov
       and vm.flag_estado <> '0'
       and am.flag_estado <> '0'
       and g.flag_estado <> '0'
       and g.nro_guia    = asi_nro_guia;
       
  
    return ln_Return;
  end;
  
  function of_get_cant_facturada(asi_nro_guia in guia.nro_guia%TYPE
  ) return number is
    ln_Return number;
  begin
    
    select abs(nvl(sum(ccd.cantidad), 0) )
      into ln_Return
      from cntas_cobrar cc,
           cntas_cobrar_det ccd
     where cc.tipo_doc  = ccd.tipo_doc
       and cc.nro_doc   = ccd.nro_doc
       and cc.flag_estado <> '0'
       and ccd.flag_estado <> '0'
       and ccd.nro_guia = asi_nro_guia;
       
  
    return ln_Return;
  end;
  
  -- Obtengo el centro de Costos y Cuenta Presupuestal
  -- lc_reg.cod_art, ls_tipo_mov, ls_cencos, ls_cnta_prsp
  function of_get_cencos_cnta_prsp(
           asi_cod_art   in  articulo.cod_art%TYPE,
           asi_tipo_mov  in  articulo_mov_tipo.tipo_mov%TYPE,
           aso_Cencos    out articulo_mov.cencos%TYPE,
           aso_Cnta_prsp out articulo_mov.cnta_prsp%TYPE
  ) return number is
    
    ln_count             number;
    ln_Factor_presup     articulo_mov_tipo.factor_presup%TYPE;
    
  begin
    
    -- Obtener el factor_presup
    select nvl(amt.factor_presup, 0)
      into ln_Factor_presup
      from articulo_mov_tipo amt
     where amt.tipo_mov = asi_tipo_mov;
    
    --Determino el centro de costos y la cuenta presupuestal
    if ln_Factor_presup <> 0 then
       select count(*)
         into ln_count
         from articulo_venta av
        where av.cod_art = asi_cod_art;
               
       if ln_count > 0 then
          select av.cencos_ingreso , case when asi_tipo_mov like 'S%' then av.cnta_prsp_vale_sal else av.cnta_prsp_ingreso end
            into aso_cencos, aso_cnta_prsp
            from articulo_venta av
           where av.cod_art = asi_cod_art;
                   
       else
          aso_cnta_prsp := null;
          aso_Cnta_prsp := null;
       end if;
       
       if aso_Cencos is null then
          select l.cencos_almacen
            into aso_Cencos
            from logparam l 
           where l.reckey = '1';
       end if;
       
       if aso_Cnta_prsp is null then
          select l.cnta_prsp_mat
            into aso_Cnta_prsp
            from logparam l 
           where l.reckey = '1';
       end if;
    else
       aso_cencos := null;
       aso_Cnta_prsp := null;
    end if;
       
  
    return 1;
  end;  
  
  function of_get_cant_facturada(asi_org_am   in articulo_mov.cod_origen%TYPE,
                                 ani_nro_am   in articulo_mov.nro_mov%TYPE
  ) return number is
    ln_Return number;
  begin
    
    select abs(nvl(sum(ccd.cantidad), 0) )
      into ln_Return
      from cntas_cobrar cc,
           cntas_cobrar_det ccd
     where cc.tipo_doc  = ccd.tipo_doc
       and cc.nro_doc   = ccd.nro_doc
       and cc.flag_estado <> '0'
       and ccd.flag_estado <> '0'
       and ccd.org_am = asi_org_am
       and ccd.nro_am = ani_nro_am;
       
  
    return ln_Return;
  end;

  function USF_ALM_SDO_ANTERIOR(adi_fecha   in date,
                                asi_almacen in almacen.almacen%TYPE,
                                asi_cod_art in articulo.cod_art%TYPE,
                                asi_val_ret in char
  ) return number is
    ln_sldo_total      articulo_almacen.sldo_total%TYPE;
    ln_ret             number;   -- Valor de retorno
    ln_costo_prom_sol  number;   -- Saldo Valorizado
    ln_sldo_und2       articulo_almacen.sldo_total_und2%TYPE;   -- Saldo Total 2 Unidad

  /*
     funcion que retorna un dato referente al saldo de un mes.
     Parametros:  mes anterior
                  cod. articulo
                  valor retorno ( S = Saldo
                                  L = Soles
                                  2UND = Saldo Total en 2Und
  */


  begin
    -- encuentra el saldo de acuerdo los movimientos
    
    select nvl(sum(am.cant_procesada * amt.factor_sldo_total),0),
           nvl(sum(nvl(am.cant_proc_und2,0) * amt.factor_sldo_total),0),
           nvl(sum(am.precio_unit * amt.factor_sldo_total * decode(amt.flag_ajuste_valorizacion, '1', 1, nvl(am.cant_procesada,0))),0)
      into ln_sldo_total,
           ln_sldo_und2,
           ln_costo_prom_sol
      from vale_mov     vm,
           articulo_mov am,
           articulo_mov_tipo amt
     where vm.nro_Vale = am.nro_Vale
       and vm.tipo_mov = amt.tipo_mov
       and am.cod_art = asi_cod_art
       and vm.almacen = asi_almacen
       and trunc( vm.fec_registro) <= trunc(adi_fecha)
       and vm.flag_estado <> '0'
       and am.flag_estado <> '0';
       
    if asi_val_ret = 'S' then         -- saldo Total
       ln_ret := ln_sldo_total;
    elsif asi_val_ret = '2UND' then   -- Saldo en Segunda Unidad
       ln_ret := ln_sldo_und2;
    elsif asi_val_ret = 'L' then   --Soles
       if ln_sldo_total = 0 then
          ln_ret := ln_costo_prom_sol;
       else
          ln_ret := ln_costo_prom_sol / ln_sldo_total;
       end if;
    else
       ln_ret := 0;
    end if;

    return(ln_ret);
  end;
  
  function of_get_nro_vale(
           asi_origen   in num_tablas.origen%TYPE,
           asi_flag_hex in varchar2
  ) return varchar2 is
  
    ls_table_name     num_tablas.tabla%TYPE    := 'VALE_MOV';
    ls_nro_Vale       vale_mov.nro_vale%TYPE;
    ln_count          number;
    ln_ult_nro        num_tablas.ult_nro%TYPE;
    
  begin
    
   select count(*)
     into ln_count
     from num_tablas n
    where n.tabla    = ls_table_name
      and n.origen   = asi_origen;
         
   if ln_count = 0 then
      insert into num_tablas(
             tabla, origen, ult_nro)
      values(
             ls_table_name, asi_origen, 1);
   end if;
         
   select n.ult_nro
     into ln_ult_nro
     from num_tablas n
    where n.tabla    = ls_table_name
      and n.origen   = asi_origen for update;
   
   if asi_flag_hex = '1' then      
      ls_nro_vale := asi_origen || lpad(PKG_UTILITY.of_convert_to_hex(ln_ult_nro), 8, '0');
   else
      ls_nro_vale := asi_origen || lpad(trim(to_char(ln_ult_nro)), 8, '0');
   end if;
         
   select count(*)
     into ln_count
     from vale_mov vm
    where vm.nro_vale = ls_nro_vale;
         
   while ln_count > 0 loop
         ln_ult_nro := ln_ult_nro + 1;
               
         if asi_flag_hex = '1' then      
            ls_nro_vale := asi_origen || lpad(PKG_UTILITY.of_convert_to_hex(ln_ult_nro), 8, '0');
         else
            ls_nro_vale := asi_origen || lpad(trim(to_char(ln_ult_nro)), 8, '0');
         end if;
         
         select count(*)
           into ln_count
           from vale_mov vm
          where vm.nro_vale = ls_nro_vale;
               
   end loop;
   
   update num_tablas n
      set n.ult_nro = ln_ult_nro + 1
    where n.tabla    = ls_table_name
      and n.origen   = asi_origen;
   
   return ls_nro_Vale;
  end;
  
  -- Function and procedure implementations
  PROCEDURE sp_traslada_fp_alm_mp(
            ani_year    number, 
            ani_mes     number,
            asi_user    usuario.cod_usr%TYPE
  ) is
    cursor c_datos is
        select te.cod_art,
           a.desc_art,
           fv.cantidad_real,
           p.proveedor,
           p.nom_proveedor,
           fv.hora_inicio_descarga,
           fv.hora_fin_descarga,
           fp.origen,
           fv.nro_vale_ing,
           fv.nro_vale_sal,
           tn.nomb_nave,
           tn.almacen_mp,
           fp.parte_pesca,
           a.sub_cat_art,
           tn.centro_benef,
           te.especie
    from fl_venta fv,
         fl_parte_de_pesca fp,
         tg_naves          tn,
         tg_especies       te,
         articulo          a,
         proveedor         p
    where fv.parte_pesca = fp.parte_pesca     
      and fp.nave_real   = tn.nave
      and fv.especie     = te.especie
      and te.cod_art     = a.cod_art    (+)
      and fv.cliente     = p.proveedor  (+)
      and fv.cliente     <> 'E0000000'
      and to_number(to_char(fv.hora_inicio_descarga, 'yyyy')) = ani_year
      and to_number(to_char(fv.hora_inicio_descarga, 'mm'))   = ani_mes;
    
    ln_ult_nro    num_vale_mov.ult_nro%TYPE;
    ls_origen     vale_mov.cod_origen%TYPE;
    ln_count      number;
    ls_vale_ing   vale_mov.nro_vale%TYPE;
    ls_vale_sal   vale_mov.nro_vale%TYPE;
    ls_obs        vale_mov.observaciones%TYPE;
    ls_matriz     articulo_mov.matriz%TYPE;
    
  begin
    for lc_reg in c_datos loop                       
        if lc_reg.almacen_mp is null then
           rollback;
           RAISE_APPLICATION_ERROR(-20000, 'No se ha definido almacen de materia prima para la nave ' || lc_reg.nomb_nave || '. Por favor verifique!');
        end if;
        
        -- Genero el vale de ingreso
        if lc_reg.nro_vale_ing is null then
           -- Obtengo el origen del almacen
           select al.cod_origen
             into ls_origen
             from almacen al
            where al.almacen = lc_reg.almacen_mp;
            
           -- Otengo el siguiente numero, en caso no exista lo creo
           select count(*)
             into ln_count
             from num_Vale_mov n
            where n.origen = ls_origen;
            
           if ln_count = 0 then
              insert into num_vale_mov(ult_nro, origen)
              values(1, ls_origen);
           end if;
            
           select n.ult_nro
             into ln_ult_nro
             from num_Vale_mov n
            where n.origen = ls_origen for update;
            
           -- Genero el vale en caso no exista
           ls_vale_ing := trim(ls_origen) || trim(to_char(ln_ult_nro, '00000000'));
           
           -- Incremento el numerador
           ln_ult_nro := ln_ult_nro + 1;
           
           -- ACtualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro
            where n.origen = ls_origen;
           
           -- Inserto la cabecera del movimiento
           ls_obs := 'GENERADO DE MANERA AUTOMATICA';
            
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, 
                  cod_usr, nom_receptor, tipo_doc_int, nro_doc_int, observaciones)
           values(
                  ls_origen, 
                  ls_vale_ing, 
                  lc_reg.almacen_mp, 
                  '1',
                  lc_reg.hora_inicio_descarga, 
                  PKG_LOGISTICA.is_oper_ing_prod,
                  asi_user,
                  lc_reg.nom_proveedor, 
                  'PPE',
                  lc_reg.parte_pesca,
                  ls_obs);
           
           -- Inserto el detalle
           ls_matriz := usf_alm_matriz_contable(PKG_LOGISTICA.is_oper_ing_prod, null, null, lc_reg.sub_cat_art);
           insert into articulo_mov(
                  cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                  cod_moneda, matriz, fec_registro, centro_benef)
           values(
                  ls_origen,
                  ls_vale_ing,
                  '1',
                  lc_reg.cod_art,
                  lc_reg.cantidad_real,
                  0.00,
                  PKG_LOGISTICA.is_soles,
                  ls_matriz,
                  sysdate,
                  lc_reg.centro_benef);
                  
           -- aCtualizo el dato
           update fl_venta f
              set f.nro_vale_ing = ls_vale_ing
            where f.parte_pesca = lc_reg.parte_pesca
              and f.cliente     = lc_reg.proveedor
              and f.especie     = lc_reg.especie;
        else
           ls_vale_ing := lc_reg.nro_vale_ing;
           
           update vale_mov vm
              set vm.fec_registro = lc_reg.hora_inicio_descarga
            where vm.nro_Vale = lc_reg.nro_Vale_ing;
            
        end if;
        
        -- Genero el vale de salida
        if lc_reg.nro_vale_sal is null then
           -- Obtengo el origen del almacen
           select al.cod_origen
             into ls_origen
             from almacen al
            where al.almacen = lc_reg.almacen_mp;
            
           -- Otengo el siguiente numero, en caso no exista lo creo
           select count(*)
             into ln_count
             from num_Vale_mov n
            where n.origen = ls_origen;
            
           if ln_count = 0 then
              insert into num_vale_mov(ult_nro, origen)
              values(1, ls_origen);
           end if;
            
           select n.ult_nro
             into ln_ult_nro
             from num_Vale_mov n
            where n.origen = ls_origen for update;
            
           -- Genero el vale en caso no exista
           ls_vale_sal := trim(ls_origen) || trim(to_char(ln_ult_nro, '00000000'));
           
           -- Incremento el numerador
           ln_ult_nro := ln_ult_nro + 1;
           
           -- ACtualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro
            where n.origen = ls_origen;
           
           -- Inserto la cabecera del movimiento
           ls_obs := 'GENERADO DE MANERA AUTOMATICA';
            
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, 
                  nom_receptor, tipo_doc_int, nro_doc_int, observaciones,
                  proveedor)
           values(
                  ls_origen, 
                  ls_vale_sal, 
                  lc_reg.almacen_mp, 
                  '1',
                  lc_reg.hora_fin_descarga, 
                  PKG_LOGISTICA.is_oper_vnta_nac_sinov,
                  asi_user,
                  lc_reg.nom_proveedor, 
                  'PPE',
                  lc_reg.parte_pesca,
                  ls_obs,
                  lc_reg.proveedor);
           
           -- Inserto el detalle
           ls_matriz := usf_alm_matriz_contable(PKG_LOGISTICA.is_oper_vnta_terc, null, null, lc_reg.sub_cat_art);
           insert into articulo_mov(
                  cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                  cod_moneda, matriz, fec_registro, centro_benef)
           values(
                  ls_origen,
                  ls_vale_sal,
                  '1',
                  lc_reg.cod_art,
                  lc_reg.cantidad_real,
                  0.00,
                  PKG_LOGISTICA.is_soles,
                  ls_matriz,
                  sysdate,
                  lc_reg.centro_benef);
           
           -- aCtualizo el dato
           update fl_venta f
              set f.nro_vale_sal = ls_vale_sal
            where f.parte_pesca = lc_reg.parte_pesca
              and f.cliente     = lc_reg.proveedor
              and f.especie     = lc_reg.especie;
             
        else
           ls_vale_sal := lc_reg.nro_vale_sal;
           
           update vale_mov vm
              set vm.fec_registro = lc_reg.hora_inicio_descarga
            where vm.nro_Vale = lc_reg.nro_Vale_sal;
            
        end if;
        
        
    end loop;  
    
    commit;
  end;
  
  PROCEDURE sp_ajusta_inv_time_line(asi_almacen    inventario_conteo.almacen%TYPE, 
                                    ani_conteo     inventario_conteo.nro_conteo%TYPE, 
                                    adi_fec_conteo inventario_conteo.fec_conteo%TYPE,
                                    adi_time_line  date,
                                    asi_cod_usr    usuario.cod_usr%TYPE
  ) is
   -- Variables diversas
   ln_count                   number;
   ln_sldo_conteo             inventario_conteo.sldo_conteo1%TYPE;
   ln_sldo_conteo_und2        inventario_conteo.sldo_conteo1_und2%TYPE;
   ln_saldo_after_lt          articulo_mov.cant_procesada%TYPE;
   ln_saldo_before_lt         articulo_mov.cant_procesada%TYPE;
   ln_saldo_und2_after_lt     articulo_mov.cant_procesada%TYPE;
   ln_saldo_und2_before_lt    articulo_mov.cant_procesada%TYPE;
   
   ln_saldo_lt                articulo_mov.cant_procesada%TYPE;
   ln_saldo_und2_lt           articulo_mov.cant_procesada%TYPE;
   ln_saldo_dif_lt            articulo_mov.cant_procesada%TYPE;
   ln_saldo_und2_dif_lt       articulo_mov.cant_procesada%TYPE;
   
   ls_mov_ajuste              vale_mov.tipo_mov%TYPE;
   ls_obs_vale_mov            vale_mov.observaciones%TYPE;
   ls_nro_vale                vale_mov.nro_vale%TYPE;
   ln_ult_nro                 num_vale_mov.ult_nro%TYPE;
   ls_origen                  almacen.cod_origen%TYPE;
   ld_fec_registro            vale_mov.fec_registro%TYPE;
   ls_flag_contabiliza        articulo_mov_tipo.flag_contabiliza%TYPE;
   ls_flag_und2               articulo.flag_und2%TYPE;
   ls_matriz                  articulo_mov.matriz%TYPE;
   
   -- Cursor con los datos del inventario x conteo
   cursor c_datos is
     select ic.cod_art,
            a.sub_cat_art,
            a.und,
            ic.sldo_conteo1,
            ic.sldo_conteo1_und2,
            ic.sldo_conteo2,
            ic.sldo_conteo2_und2
       from inventario_conteo ic,         
            articulo          a,
            articulo_sub_categ a2
      where ic.cod_art        = a.cod_art
        and a.sub_cat_art     = a2.cod_sub_cat
        and ic.almacen        = asi_almacen
        and ic.nro_conteo     = ani_conteo
        and ic.fec_conteo     = adi_fec_conteo;
--        and ic.cod_art        = 'PL0145.0007';
  
  
  begin
     
     -- Verifico si existe algun inventario por conteo
     select count(*)
       into ln_count
       from inventario_conteo ic,         
            articulo          a
      where ic.cod_art        = a.cod_art
        and ic.almacen        = asi_almacen
        and ic.nro_conteo     = ani_conteo
        and ic.fec_conteo     = adi_fec_conteo;
    
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No existe inventario por conteo para los parametros indicados. '
                         || chr(13) || 'Almacen: ' || asi_Almacen
                         || chr(13) || 'Nro Conteo: ' || ani_conteo
                         || chr(13) || 'Fecha Conteo: ' || to_char(adi_fec_conteo, 'dd/mm/yyyy'));
    end if;
    
    ls_obs_vale_mov := 'AJUSTE AUTOMATICO POR INVENTARIO POR CONTEO DEL ' || to_char(adi_Fec_conteo, 'dd/mm/yyyy');
    
    for lc_reg in c_datos loop
      
        if nvl(lc_reg.sldo_conteo2,0) > 0 then
           ln_sldo_conteo := nvl(lc_reg.sldo_conteo2,0);
        else
           ln_sldo_conteo := nvl(lc_reg.sldo_conteo1,0);
        end if;      
        
        if nvl(lc_reg.sldo_conteo2_und2,0) > 0 then
           ln_sldo_conteo_und2 := nvl(lc_reg.sldo_conteo2_und2,0);
        else
           ln_sldo_conteo_und2 := nvl(lc_reg.sldo_conteo1_und2,0);
        end if;      
        
        -- Obtengo el saldo despues de la linea de tiempo
        select nvl(sum(am.cant_procesada * amt.factor_sldo_total * -1), 0),
               nvl(sum(nvl(am.cant_proc_und2,0) * amt.factor_sldo_total * -1), 0)
          into ln_saldo_after_lt, ln_saldo_und2_after_lt
          from vale_mov vm,
               articulo_mov am,
               articulo_mov_tipo amt
         where vm.nro_vale = am.nro_Vale
           and vm.tipo_mov = amt.tipo_mov
           and vm.flag_estado <> '0'
           and am.flag_estado <> '0'
           and am.cod_Art     = lc_reg.cod_art
           and vm.almacen     = asi_almacen
           and trunc(vm.fec_registro) > trunc(adi_time_line);
           --and trunc(vm.fec_registro) <= trunc(adi_fec_conteo);
           
        -- Obtengo el saldo antes de la linea de tiempo
        select nvl(sum(am.cant_procesada * amt.factor_sldo_total), 0),
               nvl(sum(nvl(am.cant_proc_und2,0) * amt.factor_sldo_total), 0)
          into ln_saldo_before_lt, ln_saldo_und2_before_lt
          from vale_mov vm,
               articulo_mov am,
               articulo_mov_tipo amt
         where vm.nro_vale = am.nro_Vale
           and vm.tipo_mov = amt.tipo_mov
           and vm.flag_estado <> '0'
           and am.flag_estado <> '0'
           and am.cod_Art     = lc_reg.cod_art
           and vm.almacen     = asi_almacen
           and trunc(vm.fec_registro) <= trunc(adi_time_line);
           
        -- Obtengo el saldo que deberia tener en la linea de tiempo
        ln_saldo_lt      := ln_sldo_conteo + ln_saldo_after_lt;
        ln_saldo_und2_lt := ln_sldo_conteo_und2 + ln_saldo_und2_after_lt;
           
           
        -- Obtengo la diferencia que deberia aplicarse para la linea de tiempo
        ln_saldo_dif_lt      := ln_saldo_lt - ln_saldo_before_lt;
        ln_saldo_und2_dif_lt := ln_saldo_und2_lt - ln_saldo_und2_before_lt;
           
        -- Genero el ajuste por inventario correspondiente a la und1
        if abs(ln_saldo_dif_lt) > 0 then
              
           if ln_saldo_dif_lt > 0 then
              ls_mov_ajuste := PKG_ALMACEN.is_ing_ajuste_inventario;
           else
              ls_mov_ajuste := PKG_ALMACEN.is_sal_ajuste_inventario;
           end if; 
           
           -- Verifico si se contabiliza o no el tipo de movimiento
           select nvl(amt.flag_contabiliza,0)
             into ls_flag_contabiliza
             from articulo_mov_tipo amt
            where amt.tipo_mov      = ls_mov_ajuste;
           
           -- Verifico si existe un el vale
           select count(*)
             into ln_count
             from vale_mov     vm,
                  articulo_mov am
            where vm.nro_vale = am.nro_Vale
              and vm.almacen  = asi_almacen
              and trim(vm.tipo_mov) = trim(ls_mov_ajuste)
              and trunc(vm.fec_registro) = trunc(adi_time_line)
              and vm.flag_estado <> '0'
              and am.flag_estado <> '0'
              and vm.observaciones = ls_obs_vale_mov;
           
           if ln_count = 0 then
              -- Obtengo el codigo de origen del almacen
              select al.cod_origen
                into ls_origen
                from almacen al
               where al.almacen = asi_almacen;
              
              -- Genero un numero numero de vale
              select count(*)
                into ln_count
                from num_vale_mov n
               where n.origen  = ls_origen;
              
              if ln_count = 0 then
                 insert into num_vale_mov(origen, ult_nro)
                 values(ls_origen, 1);
              end if;
              
              -- Obtengo el siguiente numero
              select n.ult_nro
                into ln_ult_nro
                from num_vale_mov n
               where n.origen  = ls_origen for update;
              
              ls_nro_vale := ls_origen || trim(to_char(ln_ult_nro, '00000000'));
              ld_fec_registro := to_date(to_char(adi_time_line, 'dd/mm/yyyy') || ' 23:59:59', 'dd/mm/yyyy HH24:mi:ss');
              
              
              insert into vale_mov(
                     cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, 
                     nom_receptor, observaciones)
              values(
                     ls_origen, ls_nro_vale, asi_almacen, '1', ld_fec_registro, ls_mov_ajuste, asi_cod_usr, 
                     'AJUSTE INVENTARIO', ls_obs_vale_mov);
              
              -- actualizo el contador
              update num_Vale_mov n
                 set n.ult_nro = ln_ult_nro + 1
               where n.origen  = ls_origen;
           else
             
              -- Obtengo el nro de vale
              select distinct vm.nro_vale, vm.cod_origen
                into ls_nro_vale, ls_origen
                from vale_mov     vm,
                     articulo_mov am
               where vm.nro_vale = am.nro_Vale
                 and vm.almacen  = asi_almacen
                 and trim(vm.tipo_mov) = trim(ls_mov_ajuste)
                 and trunc(vm.fec_registro) = trunc(adi_time_line)
                 and vm.flag_estado <> '0'
                 and am.flag_estado <> '0'
                 and vm.observaciones = ls_obs_vale_mov;
              
           end if;
           
           update articulo a
              set a.flag_estado = '1'
            where a.cod_art = lc_reg.cod_art;
           
           /*
           update articulo_mov am
              set am.cant_procesada = ln_saldo_dif_lt
            where am.nro_vale       = ls_nro_Vale
              and am.cod_art        = lc_reg.cod_art;
           
           if SQL%NOTFOUND then
           */
            -- Obtengo la matriz contable adecuada
            if ls_flag_contabiliza = '1' then
               select count(*)
                 into ln_count
                 from tipo_mov_matriz_subcat t
                where trim(t.tipo_mov)      = trim(ls_mov_ajuste)
                  and t.grp_cntbl            = '20'
                  and t.cod_sub_cat          = lc_reg.sub_cat_art;
                   
               if ln_count = 0 then
                  ls_matriz := PKG_FACT_ELECTRONICA.is_matriz_VS000;
                      
                  insert into tipo_mov_matriz_subcat(
                         tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
                  values(
                         ls_mov_ajuste, '20', lc_reg.sub_cat_art, 1, ls_matriz);
                             
               else
                  select t.matriz
                    into ls_matriz
                    from tipo_mov_matriz_subcat t
                   where t.tipo_mov             = ls_mov_ajuste
                     and t.grp_cntbl            = '20'
                     and t.cod_sub_cat          = lc_reg.sub_cat_art
                     and rownum                 = 1
                   order by t.item;
                         
                      
               end if;
                     
            else
               ls_matriz := null;
            end if;
            
            insert into articulo_mov(
                   cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, cant_proc_und2, precio_unit, cod_moneda, matriz)
            values(
                   ls_origen, ls_nro_vale, '1', lc_reg.cod_art, abs(ln_saldo_dif_lt), 0, 0, PKG_LOGISTICA.is_soles, ls_matriz);
         end if;
           
                
        --end if;

        -- Genero el ajuste por inventario correspondiente a la und2
        /**********************************************************/
        select flag_und2
          into ls_flag_und2
          from articulo a
         where a.cod_art = lc_reg.cod_art;
        
        if abs(ln_saldo_und2_dif_lt) > 0 and ls_flag_und2 = '1' then
              
           if ln_saldo_und2_dif_lt > 0 then
              ls_mov_ajuste := PKG_ALMACEN.is_ing_ajuste_inventario;
           else
              ls_mov_ajuste := PKG_ALMACEN.is_sal_ajuste_inventario;
           end if; 
           
           -- Verifico si se contabiliza o no el tipo de movimiento
           select nvl(amt.flag_contabiliza,0)
             into ls_flag_contabiliza
             from articulo_mov_tipo amt
            where amt.tipo_mov      = ls_mov_ajuste;
           
           -- Verifico si existe un el vale
           select count(*)
             into ln_count
             from vale_mov     vm,
                  articulo_mov am
            where vm.nro_vale = am.nro_Vale
              and trim(vm.tipo_mov) = trim(ls_mov_ajuste)
              and trunc(vm.fec_registro) = trunc(adi_time_line)
              and vm.flag_estado <> '0'
              and am.flag_estado <> '0'
              and vm.observaciones = ls_obs_vale_mov;
           
           if ln_count = 0 then
              -- Obtengo el codigo de origen del almacen
              select al.cod_origen
                into ls_origen
                from almacen al
               where al.almacen = asi_almacen;
              
              -- Genero un numero numero de vale
              select count(*)
                into ln_count
                from num_vale_mov n
               where n.origen  = ls_origen;
              
              if ln_count = 0 then
                 insert into num_vale_mov(origen, ult_nro)
                 values(ls_origen, 1);
              end if;
              
              -- Obtengo el siguiente numero
              select n.ult_nro
                into ln_ult_nro
                from num_vale_mov n
               where n.origen  = ls_origen for update;
              
              ls_nro_vale := ls_origen || trim(to_char(ln_ult_nro, '00000000'));
              ld_fec_registro := to_date(to_char(adi_time_line, 'dd/mm/yyyy') || ' 23:59:59', 'dd/mm/yyyy HH24:mi:ss');
              
              
              insert into vale_mov(
                     cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, 
                     nom_receptor, observaciones)
              values(
                     ls_origen, ls_nro_vale, asi_almacen, '1', ld_fec_registro, ls_mov_ajuste, asi_cod_usr, 
                     'AJUSTE INVENTARIO', ls_obs_vale_mov);

              -- actualizo el contador
              update num_Vale_mov n
                 set n.ult_nro = ln_ult_nro + 1
               where n.origen  = ls_origen;
                     
           else
             
              -- Obtengo el nro de vale
              select distinct vm.nro_vale
                into ls_nro_vale
                from vale_mov     vm,
                     articulo_mov am
               where vm.nro_vale = am.nro_Vale
                 and trim(vm.tipo_mov) = trim(ls_mov_ajuste)
                 and trunc(vm.fec_registro) = trunc(adi_time_line)
                 and vm.flag_estado <> '0'
                 and am.flag_estado <> '0'
                 and vm.observaciones = ls_obs_vale_mov;
              
           end if;
           
           update articulo_mov am
              set am.cant_proc_und2 = ln_saldo_und2_dif_lt
            where am.nro_vale       = ls_nro_Vale
              and am.cod_art        = lc_reg.cod_art;
           
           if SQL%NOTFOUND then
              -- Obtengo la matriz contable adecuada
              if ls_flag_contabiliza = '1' then
                 select count(*)
                   into ln_count
                   from tipo_mov_matriz_subcat t
                  where t.tipo_mov             = ls_mov_ajuste
                    and t.grp_cntbl            = '20'
                    and t.cod_sub_cat          = lc_reg.sub_cat_art;
                 
                 if ln_count = 0 then
                    ls_matriz := PKG_FACT_ELECTRONICA.is_matriz_VS000;
                    
                    insert into tipo_mov_matriz_subcat(
                           tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
                    values(
                           ls_mov_ajuste, '20', lc_reg.sub_cat_art, 1, ls_matriz);
                           
                 else
                    select t.matriz
                      into ls_matriz
                      from tipo_mov_matriz_subcat t
                     where t.tipo_mov             = ls_mov_ajuste
                       and t.grp_cntbl            = '20'
                       and t.cod_sub_cat          = lc_reg.sub_cat_art
                       and rownum                 = 1
                     order by t.item;
                  
                 end if;
                   
              else
                 ls_matriz := null;
              end if;
              
              insert into articulo_mov(
                     cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, cant_proc_und2, precio_unit, cod_moneda, matriz)
              values(
                     ls_origen, ls_nro_vale, '1', lc_reg.cod_art, 0, ln_saldo_und2_dif_lt, 0, PKG_LOGISTICA.is_soles, ls_matriz);
           end if;
           
                
        end if;

    end loop;
    
    commit;
      
  end;       
  
  -- Este procedimiento procesa el inventario por conteo y lo traslada a una fecha especifica
  PROCEDURE sp_ajusta_invent_conteo(
            asi_almacen    inventario_conteo.almacen%TYPE, 
            ani_conteo     inventario_conteo.nro_conteo%TYPE, 
            adi_fec_conteo inventario_conteo.fec_conteo%TYPE,
            asi_cod_usr    usuario.cod_usr%TYPE
  ) is   
    -- Vale_mov
    ld_fec_registro        vale_mov.fec_registro%TYPE;
    ls_org_nro             vale_mov.cod_origen%TYPE;
    ls_org_vale            vale_mov.cod_origen%TYPE;
    ls_tipo_mov            vale_mov.tipo_mov%TYPE;
    ls_nom_receptor        vale_mov.nom_receptor%TYPE;
    ls_nro_vale            vale_mov.nro_vale%TYPE;
    
    -- Variables
    ln_inventario_und1     inventario_conteo.sldo_conteo1%TYPE;
    ln_inventario_und2     inventario_conteo.sldo_conteo1_und2%TYPE;
    ln_cant_proce_und1     articulo_mov.cant_procesada%TYPE;
    ln_cant_proce_und2     articulo_mov.cant_proc_und2%TYPE;
    ln_count               number;
    ln_ult_nro             num_Vale_mov.Ult_Nro%TYPE;
    ln_precio_unit         articulo_almacen.costo_prom_sol%TYPE;
    ln_sldo_total_und1     articulo_mov.cant_procesada%TYPE;
    ln_sldo_total_und2     articulo_mov.cant_proc_und2%TYPE;
    
    -- Cursor
    cursor c_saldo is 
      select vm.almacen,
             am.cod_art,
             decode(a.flag_und2, '0', 0, a.factor_conv_und) as factor_conv_und,
             sum(am.cant_procesada * amt.factor_sldo_total) as saldo_und1,
             sum(am.cant_proc_und2 * amt.factor_sldo_total) as saldo_und2
        from vale_mov vm,
             articulo_mov am,
             articulo_mov_tipo amt,
             almacen           al,
             articulo          a
       where vm.nro_vale = am.nro_vale
         and vm.tipo_mov = amt.tipo_mov
         and vm.almacen  = al.almacen
         and am.cod_art  = a.cod_art
         and am.flag_estado <> '0'
         and vm.flag_estado <> '0'
         --and am.cod_art     = '005001.00003'
         and vm.almacen     = asi_almacen
         and trunc(vm.fec_registro) <= trunc(adi_fec_conteo)
      group by vm.almacen,
               am.cod_art,
               decode(a.flag_und2, '0', 0, a.factor_conv_und);    
                        
    -- Inventario por conteo
    cursor c_inventario_conteo is 
      select ic.almacen,
             ic.cod_art,
             decode(a.flag_und2, '0', 0, a.factor_conv_und) as factor_conv_und,
             ic.sldo_conteo1 as sldo_conteo_und1,
             ic.sldo_conteo1 * decode(a.flag_und2, '0', 0, a.factor_conv_und) as sldo_conteo_und2,
             (select nvl(sum(am.cant_procesada * amt.factor_sldo_total),0)
                from vale_mov vm,
                     articulo_mov am,
                     articulo_mov_tipo amt
               where vm.nro_Vale = am.nro_vale
                 and vm.tipo_mov = amt.tipo_mov
                 and vm.almacen  = ic.almacen
                 and am.cod_art  = ic.cod_art
                 and trunc(vm.fec_registro) <= trunc(ic.fec_conteo)
                 and vm.flag_estado <> '0'
                 and am.flag_estado <> '0') as sldo_total_und1,
             (select nvl(sum(am.cant_proc_und2 * amt.factor_sldo_total),0)
                from vale_mov vm,
                     articulo_mov am,
                     articulo_mov_tipo amt
               where vm.nro_Vale = am.nro_vale
                 and vm.tipo_mov = amt.tipo_mov
                 and vm.almacen  = ic.almacen
                 and am.cod_art  = ic.cod_art
                 and trunc(vm.fec_registro) <= trunc(ic.fec_conteo)
                 and vm.flag_estado <> '0'
                 and am.flag_estado <> '0') as sldo_total_und2
      from inventario_conteo ic,
           articulo          a
      where ic.cod_art  = a.cod_art
        and ic.almacen = asi_almacen
        and ic.fec_conteo = trunc(adi_fec_conteo)
        and ic.nro_conteo = ani_conteo;
      
  begin
     -- Obtengo la cantidad inventariada
     select count(*)
       into ln_count
       from inventario_conteo ic
      where ic.almacen           = asi_almacen
        and trunc(ic.fec_conteo) = trunc(adi_fec_conteo);
     
     if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'No existe Inventario por conteo en la fecha y ALMACEN indicado'
                                    || chr(13) || 'Almacen: ' || asi_almacen
                                    || chr(13) || 'Fec Conteo: ' || to_char(adi_fec_conteo, 'dd/mm/yyyy'));
     end if;
            
     ld_fec_registro := to_date(to_char(adi_fec_conteo, 'dd/mm/yyyy') || ' 23:59:59', 'dd/mm/yyyy HH24:mi:ss');
     
     ls_org_nro := 'AX';
     
     for lc_reg in c_saldo loop
         select al.cod_origen
           into ls_org_vale
           from almacen al
          where al.almacen = lc_reg.almacen;
          
         -- Obtengo la cantidad inventariada
         select count(*)
           into ln_count
           from inventario_conteo ic
          where ic.almacen             = asi_almacen
            and trunc(ic.fec_conteo)   = trunc(adi_fec_conteo)
            and ic.nro_conteo          = ani_conteo
            and ic.cod_art             = lc_reg.cod_art;
         
         if ln_count = 0 then
            ln_inventario_und1 := 0;
            ln_inventario_und2 := 0;
         else
            select sum(ic.sldo_conteo1)
              into ln_inventario_und1
              from inventario_conteo ic
             where ic.almacen             = asi_almacen
               and trunc(ic.fec_conteo)   = trunc(adi_fec_conteo)
               and ic.nro_conteo          = ani_conteo
               and ic.cod_art             = lc_reg.cod_art;
            
            ln_inventario_und2 := ln_inventario_und1 * lc_reg.factor_conv_und;
         end if;
         
         
         
         if ln_inventario_und1 > lc_reg.saldo_und1 then
            ln_cant_proce_und1 := ln_inventario_und1 - lc_reg.saldo_und1;
            ln_cant_proce_und2 := ln_cant_proce_und1 * lc_reg.factor_conv_und;
            
            if ln_cant_proce_und2 < ln_inventario_und2 then
               ln_cant_proce_und2 := ln_inventario_und2;
            end if;
            
            ls_tipo_mov        := is_ing_ajuste_inventario;
         else
            ln_cant_proce_und1 := lc_reg.saldo_und1 - ln_inventario_und1;
            ln_cant_proce_und2 := ln_cant_proce_und1 * lc_reg.factor_conv_und;

            if ln_cant_proce_und2 < ln_inventario_und2 then
               ln_cant_proce_und2 := ln_inventario_und2;
            end if;

            ls_tipo_mov        := is_sal_ajuste_inventario;
         end if;
         
         if ln_cant_proce_und1 > 0 or ln_cant_proce_und2 > 0 then
            
            ls_nom_receptor    := 'AJUSTE AUT. ' || trim(ls_tipo_mov) || ' AUTOMATICO ' || asi_almacen 
                               || ' INVENTARIO CONTEO';
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen      = asi_almacen
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = ls_tipo_mov
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      ls_org_vale, ls_nro_Vale, asi_almacen, '1', ld_fec_registro, 
                      ls_tipo_mov, asi_cod_usr,
                      ls_nom_receptor, ls_nom_receptor, trunc(adi_fec_conteo), asi_almacen);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen      = asi_almacen
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = ls_tipo_mov
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Obtengo el costo_prom_soles
            select count(*)
              into ln_count
              from articulo_almacen aa
             where aa.cod_Art = lc_reg.cod_Art
               and aa.almacen = lc_reg.almacen;
            
            if ln_count > 0 then
               select aa.costo_prom_sol, aa.sldo_total, aa.sldo_total_und2
                 into ln_precio_unit, ln_sldo_total_und1, ln_sldo_total_und2
                 from articulo_almacen aa
                where aa.cod_Art = lc_reg.cod_Art
                  and aa.almacen = lc_reg.almacen;
            else
               ln_precio_unit := 0;
               ln_sldo_total_und1 := 0;
               ln_sldo_total_und2 := 0;
            end if;
            
            if ls_tipo_mov like 'S%' then
               if ln_sldo_total_und1 < ln_cant_proce_und1 then
                  ln_sldo_total_und1 := ln_cant_proce_und1;
               end if;
               
               if ln_sldo_total_und2 < ln_cant_proce_und2 then
                  ln_sldo_total_und2 := ln_cant_proce_und2;
               end if;
               
               update articulo_almacen aa
                  set aa.sldo_total = ln_sldo_total_und1,
                      aa.sldo_total_und2 = ln_sldo_total_und2
                where aa.cod_Art = lc_reg.cod_Art
                  and aa.almacen = lc_reg.almacen;
                  
            elsif ls_tipo_mov like 'I%' then
                ln_precio_unit := 0;
            end if;
            
            if ln_precio_unit < 0 then ln_precio_unit := 0; end if;

            insert into articulo_mov(
                      cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                      cod_moneda, 
                      cant_proc_und2)
            values(
                      ls_org_vale, ls_nro_vale, '1', lc_reg.cod_art, ln_cant_proce_und1, ln_precio_unit, 
                      PKG_LOGISTICA.is_soles,
                      ln_cant_proce_und2);
           
         end if;
     
         commit;
     end loop;
     
     for lc_reg in c_inventario_conteo loop
         select al.cod_origen
           into ls_org_vale
           from almacen al
          where al.almacen = lc_reg.almacen;
          
         if lc_reg.sldo_conteo_und1 > lc_reg.sldo_total_und1 then
            ln_cant_proce_und1 := lc_reg.sldo_conteo_und1 - lc_reg.sldo_total_und1;
            ln_cant_proce_und2 := ln_cant_proce_und1 * lc_reg.factor_conv_und;
            
            if ln_cant_proce_und2 < lc_reg.sldo_conteo_und2 then
               ln_cant_proce_und2 := lc_reg.sldo_conteo_und2;
            end if;
            
            ls_tipo_mov        := is_ing_ajuste_inventario;
         else
            ln_cant_proce_und1 := lc_reg.sldo_total_und1  - lc_reg.sldo_conteo_und1;
            ln_cant_proce_und2 := ln_cant_proce_und1 * lc_reg.factor_conv_und;

            if ln_cant_proce_und2 < lc_reg.sldo_conteo_und2 then
               ln_cant_proce_und2 := lc_reg.sldo_conteo_und2;
            end if;

            ls_tipo_mov        := is_sal_ajuste_inventario;
         end if;
         
         if ln_cant_proce_und1 > 0 or ln_cant_proce_und2 > 0 then
            
            ls_nom_receptor    := 'AJUSTE AUT. ' || trim(ls_tipo_mov) || ' AUTOMATICO ' || asi_almacen 
                               || ' INVENTARIO CONTEO';
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen      = asi_almacen
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = ls_tipo_mov
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      ls_org_vale, ls_nro_Vale, asi_almacen, '1', ld_fec_registro, 
                      ls_tipo_mov, asi_cod_usr,
                      ls_nom_receptor, ls_nom_receptor, trunc(adi_fec_conteo), asi_almacen);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen      = asi_almacen
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = ls_tipo_mov
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Obtengo el costo_prom_soles
            select count(*)
              into ln_count
              from articulo_almacen aa
             where aa.cod_Art = lc_reg.cod_Art
               and aa.almacen = lc_reg.almacen;
            
            if ln_count > 0 then
               select aa.costo_prom_sol, aa.sldo_total, aa.sldo_total_und2
                 into ln_precio_unit, ln_sldo_total_und1, ln_sldo_total_und2
                 from articulo_almacen aa
                where aa.cod_Art = lc_reg.cod_Art
                  and aa.almacen = lc_reg.almacen;
            else
               ln_precio_unit := 0;
               ln_sldo_total_und1 := 0;
               ln_sldo_total_und2 := 0;
            end if;
            
            if ls_tipo_mov like 'S%' then
               if ln_sldo_total_und1 < ln_cant_proce_und1 then
                  ln_sldo_total_und1 := ln_cant_proce_und1;
               end if;
               
               if ln_sldo_total_und2 < ln_cant_proce_und2 then
                  ln_sldo_total_und2 := ln_cant_proce_und2;
               end if;
               
               update articulo_almacen aa
                  set aa.sldo_total = ln_sldo_total_und1,
                      aa.sldo_total_und2 = ln_sldo_total_und2
                where aa.cod_Art = lc_reg.cod_Art
                  and aa.almacen = lc_reg.almacen;
                  
            elsif ls_tipo_mov like 'I%' then
                ln_precio_unit := 0;
            end if;
            
            if ln_precio_unit < 0 then ln_precio_unit := 0; end if;

            insert into articulo_mov(
                      cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                      cod_moneda, 
                      cant_proc_und2)
            values(
                      ls_org_vale, ls_nro_vale, '1', lc_reg.cod_art, ln_cant_proce_und1, ln_precio_unit, 
                      PKG_LOGISTICA.is_soles,
                      ln_cant_proce_und2);
           
         end if;
     
         commit;
     end loop;
    

  end;

  PROCEDURE sp_ajusta_alm_vtas(ani_year       number,
                               ani_mes        number,
                               asi_cod_usr    usuario.cod_usr%TYPE
   ) is
   
   -- Variables diversas
   ls_flag_contabiliza        articulo_mov_tipo.flag_contabiliza%TYPE;
   --ls_flag_und2               articulo.flag_und2%TYPE;
   ls_matriz                  articulo_mov.matriz%TYPE;
   ld_last_day                date;
   ls_obs_vale_mov            vale_mov.observaciones%TYPE;
   ln_count                   number;
   ln_ult_nro                 num_vale_mov.ult_nro%TYPE;
   ls_nro_Vale                vale_mov.nro_vale%TYPE;
   
   -- Cursor con los datos del inventario x conteo
   cursor c_datos is
      select am.cod_art,
             vm.almacen,
             al.cod_origen,
             a.sub_cat_art,
             sum(am.cant_procesada * amt.factor_sldo_total),
             (select nvl(sum(fsd.cant_proyect), 0)
                from fs_factura_simpl fs,
                     fs_factura_simpl_det fsd
               where fs.nro_registro = fsd.nro_registro
                 and fsd.cod_art     = am.cod_art
                 and fsd.almacen     = vm.almacen
                 and to_char(fs.fec_registro, 'yyyymm') = trim(to_char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))) as salidas,
             sum(am.cant_procesada * amt.factor_sldo_total) -
             (select nvl(sum(fsd.cant_proyect), 0)
                from fs_factura_simpl fs,
                     fs_factura_simpl_det fsd
               where fs.nro_registro = fsd.nro_registro
                 and fsd.cod_art     = am.cod_art
                 and fsd.almacen     = vm.almacen
                 and to_char(fs.fec_registro, 'yyyymm') = trim(to_char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))) as saldo
      from vale_mov vm,
           articulo_mov am,
           articulo_mov_tipo amt,
           almacen           al,
           articulo          a
      where vm.nro_vale = am.nro_Vale
        and vm.tipo_mov = amt.tipo_mov     
        and vm.almacen  = al.almacen
        and am.cod_Art  = a.cod_art
        and trunc(vm.fec_registro) <= trunc(ld_last_day)
      group by am.cod_art,
               vm.almacen,
               al.cod_origen,
               a.sub_cat_art
      having sum(am.cant_procesada * amt.factor_sldo_total) -
             (select nvl(sum(fsd.cant_proyect), 0)
                from fs_factura_simpl fs,
                     fs_factura_simpl_det fsd
               where fs.nro_registro = fsd.nro_registro
                 and fsd.cod_art     = am.cod_art
                 and fsd.almacen     = vm.almacen
                 and to_char(fs.fec_registro, 'yyyymm') = trim(to_char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))) < 0         ;
  
  begin
    -- Obtengo la fecha del ultimo dia del mes anterior
    ld_last_day := to_date('01/' || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year, '0000')) || ' 23:00:00', 'dd/mm/yyyy HH24:mi:ss') - 1;
    
    -- Observacion del vale del almacen
    ls_obs_vale_mov := 'AJUSTE AUTOMATICO DEL INVENTARIO SEGUN VENTAS. PERIODO ' || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year, '0000'));
    
     for lc_reg in c_Datos loop
         -- Busco si ya existe el movimiento de ajuste
         select count(*)
           into ln_count
           from vale_mov vm
          where vm.tipo_mov = PKG_ALMACEN.is_ing_ajuste_inventario
            and trim(vm.observaciones) = ls_obs_vale_mov
            and vm.fec_registro        = ld_last_day
            and vm.almacen             = lc_reg.almacen;
         
         if ln_count = 0 then
            select count(*)
              into ln_count
              from num_vale_mov n
             where n.origen = lc_reg.cod_origen;
            
            if ln_count = 0 then
               insert into num_vale_mov(origen, ult_nro)
               values(lc_reg.cod_origen, 1);
            end if;
            
            select n.ult_nro
              into ln_ult_nro
              from num_vale_mov n
             where n.origen = lc_reg.cod_origen for update;
            
            ls_nro_vale := trim(lc_reg.cod_origen) || trim(to_char(ln_ult_nro, '00000000'));
            
            -- Actualizo el numerador
            update num_vale_mov n
               set n.ult_nro = ln_ult_nro + 1
             where n.origen = lc_reg.cod_origen;
            
            -- Inserto el movimiento de almacen
            insert into vale_mov(
                   cod_origen, 
                   nro_vale,
                   almacen,
                   flag_estado,
                   fec_registro,
                   tipo_mov,
                   cod_usr,
                   nom_receptor,
                   observaciones)
            values(
                   lc_reg.cod_origen,
                   ls_nro_Vale,
                   lc_reg.almacen,
                   '1',
                   ld_last_day,
                   PKG_ALMACEN.is_ing_ajuste_inventario,
                   asi_cod_usr,
                   'AJUSTE AUTOMATICO',
                   ls_obs_vale_mov);
            
         else
            select vm.nro_vale
              into ls_nro_Vale
              from vale_mov vm
             where vm.tipo_mov = PKG_ALMACEN.is_ing_ajuste_inventario
               and trim(vm.observaciones) = ls_obs_vale_mov
               and vm.fec_registro        = ld_last_day
               and vm.almacen             = lc_reg.almacen;
         end if;

         -- Verifico si se contabiliza o no el tipo de movimiento
         select nvl(amt.flag_contabiliza,0)
           into ls_flag_contabiliza
           from articulo_mov_tipo amt
          where amt.tipo_mov      = PKG_ALMACEN.is_ing_ajuste_inventario;         
         
         if ls_flag_contabiliza = '1' then
             select count(*)
               into ln_count
               from tipo_mov_matriz_subcat t
              where trim(t.tipo_mov)      = trim(PKG_ALMACEN.is_ing_ajuste_inventario)
                and t.grp_cntbl            = '20'
                and t.cod_sub_cat          = lc_reg.sub_cat_art;
                     
             if ln_count = 0 then
                ls_matriz := PKG_FACT_ELECTRONICA.is_matriz_VS000;
                        
                insert into tipo_mov_matriz_subcat(
                       tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
                values(
                       PKG_ALMACEN.is_ing_ajuste_inventario, '20', lc_reg.sub_cat_art, 1, ls_matriz);
                               
             else
                select t.matriz
                  into ls_matriz
                  from tipo_mov_matriz_subcat t
                 where t.tipo_mov             = PKG_ALMACEN.is_ing_ajuste_inventario
                   and t.grp_cntbl            = '20'
                   and t.cod_sub_cat          = lc_reg.sub_cat_art
                   and rownum                 = 1
                 order by t.item;
                           
                        
             end if;
                       
         else
             ls_matriz := null;
         end if;

         
         -- Inserto en el detalle el articulo para ajutarlo
         insert into articulo_mov(
                cod_origen,
                nro_vale,
                flag_estado,
                cod_art,
                cant_procesada,
                precio_unit,
                cod_moneda,
                matriz,
                fec_registro)
          values(
                lc_reg.cod_origen,
                ls_nro_Vale,
                '1',
                lc_reg.cod_art,
                abs(lc_reg.saldo),
                0,
                PKG_LOGISTICA.is_soles,
                ls_matriz,
                sysdate);
                
                     
            
     end loop;
     
     -- Aplico los cambios
     commit;
      
  end;
  
  PROCEDURE sp_act_saldo_all(
         asi_nada             in  string
  ) is

  -- Precios Promedios
  ln_saldo                 articulo_almacen.sldo_total%TYPE;
  ln_saldo_und2            articulo_almacen.sldo_total_und2%TYPE;

  --  Lectura del movimiento de ingresos y salidas para los almacenes
  --  que no son de transito
  CURSOR c_saldos_m is
    SELECT am.cod_art, vm.almacen,
           SUM(NVL(am.cant_procesada,0) * amt.factor_sldo_total) as Saldo_total,
           SUM(NVL(am.cant_proc_und2,0) * amt.factor_sldo_total) as saldo_total_und2
      FROM vale_mov          vm,
           articulo_mov      am,
           articulo_mov_tipo amt,
           almacen           a
     WHERE vm.cod_origen = am.cod_origen
       and vm.nro_vale   = am.nro_vale
       and vm.tipo_mov    = amt.tipo_mov
       AND a.almacen      = vm.almacen
       and vm.flag_estado <> '0'
       AND am.flag_estado <> '0'
       and amt.factor_sldo_total <> 0
       and NVL(amt.flag_ajuste_valorizacion,'0') = '0'
       AND a.flag_tipo_almacen <> 'O'
       --and am.cod_art = '101016.00630'
  group by am.cod_art, vm.almacen;

  --  Lectura del movimiento de ingresos y salidas para los almacenes
  --  que si son de transito
  CURSOR c_saldos_t is
    SELECT vm2.cod_art, vm1.almacen,
           SUM(NVL(vm2.cant_procesada,0) * amt.factor_sldo_total) as Saldo_total
      FROM vale_mov_trans     vm1,
           vale_mov_trans_det vm2,
           articulo_mov_tipo amt,
           almacen           a
     WHERE vm1.nro_vale   = vm2.nro_vale
       and vm1.tipo_mov   = amt.tipo_mov
       AND a.almacen      = vm1.almacen
       and vm1.flag_estado <> '0'
       AND vm2.flag_estado <> '0'
       and amt.factor_sldo_total <> 0
       and NVL(amt.flag_ajuste_valorizacion,'0') = '0'
       AND a.flag_tipo_almacen = 'O'
       --and vm2.cod_art = '101016.00630'
  group by vm2.cod_art, vm1.almacen;
  
  cursor c_articulos is
     select cod_art, almacen
       from articulo_almacen aa
     where aa.sldo_total <> 0
       and aa.sldo_reservado = 0;
       --and aa.cod_art        = '101016.00630';
       --and aa.almacen        = 'ALCG08';

  BEGIN

    LOCK TABLE articulo_mov IN EXCLUSIVE MODE;
    LOCK TABLE articulo_almacen IN EXCLUSIVE MODE;

    update articulo a
      set a.sldo_Total = (select sum(sldo_total)
                           from articulo_almacen
                          where cod_art = a.cod_art),
          sldo_total_und2 = (select sum(sldo_total_und2)
                           from articulo_almacen
                          where cod_art = a.cod_art),
          a.flag_replicacion = '0'
    where cod_art in (select distinct cod_art from articulo_almacen);
    
    -- Actualizo el valor total
    update articulo a
         set a.costo_prom_sol = (select round(
                                         case 
                                          when sum(aa.sldo_total) = 0 then
                                            0
                                          else sum(aa.sldo_total * aa.costo_prom_sol) / sum(aa.sldo_total)
                                        end,8)
                                   from articulo_almacen aa
                                  where aa.cod_Art = a.cod_art)
       where a.costo_prom_sol <> (select round(
                                         case 
                                          when sum(aa.sldo_total) = 0 then
                                            0
                                          else sum(aa.sldo_total * aa.costo_prom_sol) / sum(aa.sldo_total)
                                        end,8)
                                   from articulo_almacen aa
                                  where aa.cod_Art = a.cod_art);    

      update articulo a
         set a.costo_prom_dol = (select round(
                                         case 
                                          when sum(aa.sldo_total) = 0 then
                                            0
                                          else sum(aa.sldo_total * aa.costo_prom_dol) / sum(aa.sldo_total)
                                        end,8)
                                   from articulo_almacen aa
                                  where aa.cod_Art = a.cod_art)
       where a.costo_prom_dol <> (select round(
                                         case 
                                          when sum(aa.sldo_total) = 0 then
                                            0
                                          else sum(aa.sldo_total * aa.costo_prom_dol) / sum(aa.sldo_total)
                                        end,8)
                                   from articulo_almacen aa
                                  where aa.cod_Art = a.cod_art);                                                    
                            
    /*
    update articulo_almacen
       set sldo_total = 0
     where sldo_total <> 0
       and sldo_reservado = 0;
    */
    
    for lc_Reg in c_articulos loop
        --DBMS_OUTPUT.put_line(lc_reg.cod_Art || '-' || lc_reg.almacen);
        
        update articulo_almacen aa
           set sldo_total = 0
         where aa.cod_art   = lc_Reg.cod_art
           and aa.almacen   = lc_reg.almacen;
    end loop;
    
    FOR lc_reg IN c_saldos_m LOOP
        if lc_reg.saldo_total < 0 then
           ln_saldo := 0;
        else
            ln_saldo := lc_reg.saldo_total;
        end if;
        if lc_reg.saldo_total_und2 < 0 then
           ln_saldo_und2 := 0;
        else
           ln_saldo_und2 := lc_reg.saldo_total_und2;
        end if;

        update articulo_almacen a
           set a.sldo_total      = ln_saldo,
               a.sldo_total_und2 = ln_saldo_und2,
               a.flag_replicacion= '0'
         where almacen = lc_reg.almacen
           and cod_art = lc_reg.cod_art;

        IF SQL%NOTFOUND then
           insert into articulo_almacen(
                  cod_art, almacen, sldo_total, sldo_total_und2)
           values(
                  lc_reg.cod_art, lc_reg.almacen, ln_saldo, ln_saldo_und2);
        end if;

        insert into tt_edg1(cod_art)
        values(lc_reg.cod_art);

    END LOOP ;

    FOR lc_reg IN c_saldos_t LOOP
        if lc_reg.saldo_total < 0 then
           ln_saldo := 0;
        else
            ln_saldo := lc_reg.saldo_total;
        end if;
        update articulo_almacen a
           set a.sldo_total      = ln_saldo,
               a.flag_replicacion= '0'
         where almacen = lc_reg.almacen
           and cod_art = lc_reg.cod_art;

        IF SQL%NOTFOUND then
           insert into articulo_almacen(
                  cod_art, almacen, sldo_total, sldo_total_und2)
           values(
                  lc_reg.cod_art, lc_reg.almacen, ln_saldo, 0);
        end if;

        insert into tt_edg1(cod_art)
        values(lc_reg.cod_art);

    END LOOP ;

    update articulo a
      set a.sldo_Total = (select sum(sldo_total)
                           from articulo_almacen
                          where cod_art = a.cod_art),
          sldo_total_und2 = (select sum(sldo_total_und2)
                           from articulo_almacen
                          where cod_art = a.cod_art),
          a.flag_replicacion = '0'
    where cod_art in (select distinct cod_art from articulo_almacen);

  END;
                                    

  -- Crea los movimientos de AJUSTE cuando se haga el movimiento de almacen se haga negativo
  -- y lo pone como Ajuste de Inventario en el mismo dia, pero en el primer minuto del dia
  PROCEDURE sp_crea_mov_ajuste(ani_year       number,
                               ani_mes        number,
                               asi_cod_usr    usuario.cod_usr%TYPE
   ) is
   
   -- Variables diversas
   ln_saldo                   articulo_mov.cant_procesada%TYPE;
   ln_count                   number;
   ln_ult_nro                 num_vale_mov.ult_nro%TYPE;
   ls_nro_Vale                vale_mov.nro_vale%TYPE;
   ld_fec_registro            vale_mov.fec_registro%TYPE;
   ls_obs_vale_mov            vale_mov.observaciones%TYPE;
   ls_flag_contabiliza        articulo_mov_tipo.flag_contabiliza%TYPE;
   ls_matriz                  articulo_mov.matriz%TYPE;
   
   -- Cursor con los datos del almacen y articulo
   cursor c_almacenes is
      select distinct
             am.cod_art,
             vm.almacen
      from vale_mov vm,
           articulo_mov am
      where vm.nro_vale = am.nro_Vale
        and vm.flag_estado <> '0'
        and am.flag_estado <> '0'
        and to_char(vm.fec_registro, 'yyyymm') <= trim(to_char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))
      order by 1, 2;
     
   -- Cursor con los datos del inventario x conteo
   cursor c_datos(as_almacen almacen.almacen%TYPE,
                  as_cod_art articulo.cod_art%TYPE) is
      select vm.fec_registro,
             vm.tipo_mov,
             amt.factor_sldo_total,
             am.cod_art,
             am.cant_procesada,
             al.cod_origen,
             amt.flag_contabiliza,
             a.sub_cat_art
      from vale_mov vm,
           articulo_mov am,
           articulo_mov_tipo amt,
           almacen           al,
           articulo          a
      where vm.nro_vale = am.nro_Vale
        and vm.tipo_mov = amt.tipo_mov     
        and vm.almacen  = al.almacen
        and am.cod_art  = a.cod_art
        and vm.flag_estado <> '0'
        and am.flag_estado <> '0'
        and vm.almacen     = as_almacen
        and am.cod_Art     = as_cod_art
        and amt.flag_ajuste_valorizacion = '0'
        and to_char(vm.fec_registro, 'yyyymm') <= trim(to_char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))
     order by vm.fec_registro;
        
  
  begin
    
    -- Observacion del vale del almacen
    ls_obs_vale_mov := 'INGRESO POR AJUSTE AUTOMATICO DEL INVENTARIO POR SALDO NEGATIVO. PERIODO ' 
                    || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year, '0000'));

    for lc_datos in c_almacenes loop
        ln_saldo := 0;
        
        for lc_reg in c_datos(lc_datos.almacen, lc_datos.cod_art) loop
            if lc_reg.factor_sldo_total = 1 then
               ln_saldo := ln_Saldo + lc_reg.cant_procesada;
            elsif lc_reg.factor_sldo_total = -1 then
               ln_saldo := ln_Saldo - lc_reg.cant_procesada;
            end if;
            
            if ln_saldo < 0 then
               -- Obtengo la fecha del movimiento de ajuste
               ld_fec_registro := lc_reg.fec_registro - 3/86400;
               
               -- Creo el movimiento de ajuste por inventario
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = lc_reg.cod_origen;
            
               if ln_count = 0 then
                   insert into num_vale_mov(origen, ult_nro)
                   values(lc_reg.cod_origen, 1);
               end if;
            
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = lc_reg.cod_origen for update;
            
               ls_nro_vale := trim(lc_reg.cod_origen) || trim(to_char(ln_ult_nro, '00000000'));
            
               -- Actualizo el numerador
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = lc_reg.cod_origen;
            
               -- Inserto el movimiento de almacen
               insert into vale_mov(
                     cod_origen, 
                     nro_vale,
                     almacen,
                     flag_estado,
                     fec_registro,
                     tipo_mov,
                     cod_usr,
                     nom_receptor,
                     observaciones)
               values(
                     lc_reg.cod_origen,
                     ls_nro_Vale,
                     lc_datos.almacen,
                     '1',
                     ld_fec_registro,
                     PKG_ALMACEN.is_ing_ajuste_inventario,
                     asi_cod_usr,
                     'AJUSTE AUTOMATICO',
                     ls_obs_vale_mov);
            

               -- Verifico si se contabiliza o no el tipo de movimiento
               select nvl(amt.flag_contabiliza,0)
                 into ls_flag_contabiliza
                 from articulo_mov_tipo amt
                where amt.tipo_mov      = PKG_ALMACEN.is_ing_ajuste_inventario;         
             
               if ls_flag_contabiliza = '1' then
                   select count(*)
                     into ln_count
                     from tipo_mov_matriz_subcat t
                    where trim(t.tipo_mov)      = trim(PKG_ALMACEN.is_ing_ajuste_inventario)
                      and t.grp_cntbl            = '20'
                      and t.cod_sub_cat          = lc_reg.sub_cat_art;
                             
                   if ln_count = 0 then
                      ls_matriz := PKG_FACT_ELECTRONICA.is_matriz_VS000;
                               
                      insert into tipo_mov_matriz_subcat(
                             tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
                      values(
                             PKG_ALMACEN.is_ing_ajuste_inventario, '20', lc_reg.sub_cat_art, 1, ls_matriz);
                                       
                   else
                      select t.matriz
                        into ls_matriz
                        from tipo_mov_matriz_subcat t
                       where t.tipo_mov             = PKG_ALMACEN.is_ing_ajuste_inventario
                         and t.grp_cntbl            = '20'
                         and t.cod_sub_cat          = lc_reg.sub_cat_art
                         and rownum                 = 1
                        order by t.item;
                                   
                                
                   end if;
                               
               else
                   ls_matriz := null;
               end if;

                 
               -- Inserto en el detalle el articulo para ajutarlo
               insert into articulo_mov(
                      cod_origen,
                      nro_vale,
                      flag_estado,
                      cod_art,
                      cant_procesada,
                      precio_unit,
                      cod_moneda,
                      matriz,
                      fec_registro)
                values(
                      lc_reg.cod_origen,
                      ls_nro_Vale,
                      '1',
                      lc_reg.cod_art,
                      abs(ln_saldo),
                      0,
                      PKG_LOGISTICA.is_soles,
                      ls_matriz,
                      sysdate);
               
               
               -- Coloco el saldo en cero
               ln_Saldo := 0;
            
            end if;            
        end loop;
      
    end loop;
    
     -- Aplico los cambios
     commit;
      
  end;                                    
  
  
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
   ) is
     
     ln_count            number;
     ln_ult_nro          num_vale_mov.ult_nro%TYPE;
     ls_org_vale         origen.cod_origen%TYPE := 'TX';
     ls_sub_cat_art      articulo.sub_cat_art%TYPE;
     
     -- ARticulo_mov
     ln_cant_ingr_und1   articulo_mov.cant_procesada%TYPE;
     ln_cant_ingr_und2   articulo_mov.cant_proc_und2%TYPE;
     ln_cant_sal_und1    articulo_mov.cant_procesada%TYPE;
     ln_cant_sal_und2    articulo_mov.cant_proc_und2%TYPE;
     ln_precio_unit      articulo_mov.precio_unit%TYPE;
     ls_matriz           articulo_mov.matriz%TYPE;
     ls_cencos           articulo_mov.cencos%TYPE;
     ls_centro_benef     articulo_mov.centro_benef%TYPE;
     
     -- Articulo
     ls_flag_und2        articulo.flag_und2%TYPE;
     ln_factor_conv_und  articulo.factor_conv_und%TYPE;
     ls_und2             articulo.und2%TYPE;
     
     -- Almacen
     ls_org_alm          almacen.cod_origen%TYPE;
     
     -- ARticulo_almacen
     ln_sldo_total       articulo_almacen.sldo_total%TYPE;
     ln_sldo_total_und2  articulo_almacen.sldo_total_und2%TYPE;
     
     -- Vale_mov
     ls_vale_sal         vale_mov.nro_vale%TYPE;
     ls_vale_ing         vale_mov.nro_vale%TYPE;
     ls_oper_sal_transf  vale_mov.tipo_mov%TYPE;
     ls_oper_ing_transf  vale_mov.tipo_mov%TYPE;
     ls_obs              vale_mov.nom_receptor%TYPE;
     
          
     
     -- Cursor con los componentes del articulo
     cursor c_componentes is
       select ac.componente,
              ac.cantidad,
              ac.und as und_componente,
              a.sub_cat_art,
              a.flag_und2,
              a.und,
              a.und2,
              av.cencos_ingreso,
              (select max(cba.centro_benef)
                 from centro_benef_articulo cba
                where cba.cod_art = ac.componente) as centro_benef,
              case
                 when a.flag_und2 = '0' then 
                    0
                 else 
                    a.factor_conv_und
              end as factor_conv_und
         from articulo_composicion ac,
              articulo             a,
              articulo_venta       av
        where ac.componente   = a.cod_art
          and ac.componente   = av.cod_art (+)
          and ac.cod_art      = asi_cod_art;
     
   begin
     -- Parametros de los mov de transformación
     ls_oper_ing_transf  := PKG_CONFIG.USF_GET_PARAMETER('OPERACION_ING_TRANSFORMACION', 'I16');
     ls_oper_sal_transf  := PKG_CONFIG.USF_GET_PARAMETER('OPERACION_SAL_TRANSFORMACION', 'S09');
     
     
     -- Obtengo los datos necesarios del articulo
     select a.flag_und2, a.factor_conv_und, a.und2
       into ls_flag_und2, ln_factor_conv_und, ls_und2
       from articulo a
      where a.cod_art = asi_cod_art;
      
     if ls_flag_und2 = '0' and ln_factor_conv_und <> 0 then
        update articulo a
           set a.factor_conv_und = 0,
               a.und2 = null
         where a.cod_art = asi_cod_art;
        
        ln_factor_conv_und := 0;
        
     elsif ls_flag_und2 = '1' and ln_factor_conv_und = 0 then
       
        RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || asi_cod_art || ' tiene activo el Flag_und2 '
                                        || 'pero no ha especificado el factor, por favor verifique!'
                                        || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                                        
     end if;
     
     if ls_flag_und2 = '1' and ls_und2 is null then
        RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || asi_cod_art || ' tiene activo el Flag_und2 '
                                        || 'pero no ha especificado la 2da Unidad, por favor verifique!'
                                        || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
     end if;
      
     if ani_cant_und1 > 0 then
        -- Obtengo los saldos por cada und
        select count(*)
          into ln_count
          from articulo_almacen aa
         where aa.cod_art = asi_cod_art
           and aa.almacen = asi_almacen;
         
        if ln_count > 0 then
           select aa.sldo_total
             into ln_sldo_total
             from articulo_almacen aa
            where aa.cod_art = asi_cod_art
              and aa.almacen = asi_almacen;
        else
           ln_sldo_total := 0.00;
        end if;
         
        if ln_sldo_total < ani_cant_und1 then
            -- Calculo la cantidad que debe ingresar por transformación
            ln_cant_ingr_und1 := ani_cant_und1; --- ln_sldo_total;
            
            if ls_flag_und2 = '1' then
               ln_cant_ingr_und2 := ln_cant_ingr_und1 * ln_factor_conv_und;
            else
               ln_cant_ingr_und2 := 0.00;
            end if;
            
            if ln_cant_ingr_und1 > 0 or ln_cant_ingr_und2 > 0 then
               -- Recorremos el cursor para determinar la cantidad según la composicion y hacer
               -- la salida por transformación correspondiente
               for lc_reg in c_componentes loop
                   -- Validos las unidades y los factores de Und2
                   if lc_reg.flag_und2 = '1' and lc_reg.factor_conv_und = 0 then
                      RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' tiene activo el Flag_und2 '
                                                      || 'pero no ha especificado el factor, por favor verifique!'
                                                      || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                   end if;
                    
                   if lc_reg.flag_und2 = '1' and lc_reg.und2 is null then
                      RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' tiene activo el Flag_und2 '
                                                      || 'pero no ha especificado la 2da Unidad, por favor verifique!'
                                                      || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                   end if;
                   
                   if lc_reg.und_componente = lc_reg.und then
                      
                      -- Si la und_componente es la unidad1 y obtengo las unidades convertidas
                      ln_cant_sal_und1 := lc_reg.cantidad * ln_cant_ingr_und1;
                      ln_cant_sal_und2 := ln_cant_sal_und1 * lc_reg.factor_conv_und;
                      
                   elsif lc_reg.und_componente = lc_reg.und2 then
                      
                      if lc_reg.flag_und2 = '0' or lc_reg.factor_conv_und = 0 then
                         RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' tiene en cantidad ' 
                                                         || trim(to_char(lc_reg.cantidad * ln_cant_ingr_und1, '999.990.000000')) || ' en und2 ' || lc_reg.und_componente
                                                         || 'pero no ha especificado el factor o el flag und2, por favor verifique!'
                                                         || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                      end if;
                   
                      -- Si la und componente es la unidad2 y obtengo las undiades convertidas
                      ln_cant_sal_und2 := lc_reg.cantidad * ln_cant_ingr_und1;
                      ln_cant_sal_und1 := ln_cant_sal_und2 / lc_reg.factor_conv_und;
                   
                   
                   else
                      -- Busco la unidad de ARTICULO_UND
                      select count(*)
                        into ln_count
                        from articulo_und au
                       where au.cod_art = lc_reg.componente
                         and au.und     = lc_reg.und_componente;
                      
                      if ln_count = 0 then
                         RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' con cantidad ' 
                                                         || trim(to_char(lc_reg.cantidad * ln_cant_ingr_und1, '999.990.000000')) || ' ' || lc_reg.und_componente
                                                         || 'no coincide con ninguna unidad del Articulo, por favor verifique!'
                                                         || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                      end if;
                      
                      select au.factor_conv_und
                        into ln_factor_conv_und
                        from articulo_und au
                       where au.cod_art = lc_reg.componente
                         and au.und     = lc_reg.und_componente;
                      
                      -- Obtengo las cantidades en und1 y und2
                      ln_cant_sal_und1 := lc_reg.cantidad * ln_cant_ingr_und1 / ln_factor_conv_und;
                      ln_cant_sal_und2 := ln_cant_sal_und1 * lc_reg.factor_conv_und;
                      
                   
                   end if;
                   
                   if ln_cant_sal_und1 > 0 or ln_cant_sal_und2 > 0 then
                      -- Obtengo el almacen donde hay stock suficiente
                      select count(*)
                        into ln_count
                        from articulo_almacen aa
                       where aa.cod_art = lc_reg.componente
                         and aa.sldo_total > ln_cant_sal_und1
                         and aa.almacen    = asi_almacen;
                      
                      if ln_count = 0 then
                         RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' no tiene saldo suficiente '
                                                         || 'en stock en Und1, por favor verifique!'
                                                         || chr(13) || 'Almacen: ' || asi_almacen
                                                         || chr(13) || 'Cantidad: ' || trim(to_char(ln_cant_sal_und1, '999,990.000000')) || ' ' || lc_reg.und
                                                         || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                      end if;
                      
                      -- Obtengo el almacen que tenga suficiente stock para la salida por transformación
                      select al.cod_origen
                        into ls_org_alm
                        from articulo_almacen aa,
                             almacen          al
                       where aa.almacen = al.almacen
                         and aa.cod_art = lc_reg.componente
                         and aa.sldo_total > ln_cant_sal_und1
                         and aa.almacen    = asi_almacen;
                      
                      -- Creo el vale de salida por transformación
                      select count(*)
                        into ln_count
                        from vale_mov     vm,
                             articulo_mov am
                       where vm.nro_Vale      = am.nro_vale
                         and vm.almacen       = asi_almacen
                         and vm.tipo_mov      = ls_oper_sal_transf
                         and am.nro_proforma  = asi_nro_proforma
                         and am.item_proforma = ani_item_proforma
                         and vm.flag_estado   <> '0'
                         and am.flag_estado   <> '0';
                      
                      -- Glosa
                      ls_obs := 'TRANSFORMACION AUTOMATICA PROFORMA: ' || asi_nro_proforma || ' Item : ' || trim(to_char(ani_item_proforma));
                      
                      -- Si no existe el nro de vale lo creo
                      if ln_count = 0 then
                         select count(*)
                           into ln_count
                           from num_vale_mov n
                          where n.origen = ls_org_vale;
                         
                         if ln_count = 0 then
                            insert into num_vale_mov(
                                   ult_nro, origen)
                            values(
                                   1, ls_org_vale);
                         end if;
                         
                         select n.ult_nro
                           into ln_ult_nro
                           from num_vale_mov n
                          where n.origen = ls_org_vale for update;
                         
                         ls_vale_sal := trim(ls_org_vale) || trim(to_char(ln_ult_nro, '00000000'));
                         
                         update num_vale_mov n
                            set n.ult_nro = ln_ult_nro + 1
                          where n.origen = ls_org_vale;
                         
                         insert into vale_mov(
                                cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, nom_receptor,
                                tipo_doc_ext, nro_doc_ext, observaciones, vendedor, fec_produccion, 
                                almacen_old)
                         values(
                                ls_org_alm, ls_vale_sal, asi_almacen, '1', adi_fecha, ls_oper_sal_transf, asi_usuario, ls_obs,
                                PKG_FACT_ELECTRONICA.is_doc_prof, asi_nro_proforma, ls_obs, asi_vendedor, trunc(adi_fecha), 
                                asi_almacen);
                         
                      else
                         select distinct
                                vm.nro_Vale
                           into ls_vale_sal
                           from vale_mov     vm,
                                articulo_mov am
                          where vm.nro_Vale      = am.nro_vale
                            and vm.almacen       = asi_almacen
                            and vm.tipo_mov      = ls_oper_sal_transf
                            and am.nro_proforma  = asi_nro_proforma
                            and am.item_proforma = ani_item_proforma
                            and vm.flag_estado   <> '0'
                            and am.flag_estado   <> '0';
                      end if;
                      
                      -- Ahora inserto el detalle de articulo_mov
                      select count(*)
                        into ln_count
                        from articulo_mov am
                       where am.nro_vale      = ls_vale_sal
                         and am.nro_proforma  = asi_nro_proforma
                         and am.item_proforma = ani_item_proforma
                         and am.cod_art       = lc_reg.componente
                         and am.flag_estado   <> '0'; 
                      
                      if ln_count = 0 then
                         
                         select count(*)
                           into ln_count
                           from articulo_almacen aa
                          where aa.cod_art = lc_reg.componente
                            and aa.almacen = asi_almacen;
                         
                         if ln_count > 0 then
                             ln_precio_unit := 0.00;
                         else
                            select aa.costo_prom_sol
                              into ln_precio_unit
                              from articulo_almacen aa
                             where aa.cod_art = lc_reg.componente
                               and aa.almacen = asi_almacen;
                         end if;   
                         
                         ls_matriz := usf_alm_matriz_contable(ls_oper_sal_transf, lc_reg.cencos_ingreso, null, lc_reg.sub_cat_art);
                      
                         insert into articulo_mov(
                                cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                                cod_moneda,
                                cencos, matriz, cant_proc_und2, fec_registro, centro_benef, 
                                nro_proforma, item_proforma)	
                         values(        
                                ls_org_alm, ls_vale_sal, '1', lc_reg.componente, ln_cant_sal_und1, ln_precio_unit, 
                                PKG_LOGISTICA.is_soles,
                                lc_reg.cencos_ingreso, ls_matriz, ln_cant_sal_und2, sysdate, lc_reg.centro_benef, 
                                asi_nro_proforma, ani_item_proforma);
                      end if;
     
                          
                   end if;
                end loop;
                
                -- Una vez que hice la salida de los componentes AHORA realizo el Ingreso por transformacion
                select a.cod_origen
                  into ls_org_alm
                  from almacen a
                 where a.almacen = asi_almacen;
                 
                select count(*)
                  into ln_count
                  from vale_mov     vm,
                       articulo_mov am
                 where vm.nro_Vale      = am.nro_vale
                   and vm.almacen       = asi_almacen
                   and vm.tipo_mov      = ls_oper_ing_transf
                   and am.nro_proforma  = asi_nro_proforma
                   and am.item_proforma = ani_item_proforma
                   and vm.flag_estado   <> '0'
                   and am.flag_estado   <> '0';
                      
                -- Glosa
                ls_obs := 'TRANSFORMACION AUTOMATICA PROFORMA: ' || asi_nro_proforma || ' Item : ' || trim(to_char(ani_item_proforma));
                      
                -- Si no existe el nro de vale lo creo
                if ln_count = 0 then
                   select count(*)
                     into ln_count
                     from num_vale_mov n
                    where n.origen = ls_org_vale;
                         
                   if ln_count = 0 then
                      insert into num_vale_mov(
                             ult_nro, origen)
                      values(
                             1, ls_org_vale);
                   end if;
                         
                   select n.ult_nro
                     into ln_ult_nro
                     from num_vale_mov n
                    where n.origen = ls_org_vale for update;
                         
                   ls_vale_ing := trim(ls_org_vale) || trim(to_char(ln_ult_nro, '00000000'));
                         
                   update num_vale_mov n
                      set n.ult_nro = ln_ult_nro + 1
                    where n.origen = ls_org_vale;
                         
                   insert into vale_mov(
                          cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, nom_receptor,
                          tipo_doc_ext, nro_doc_ext, observaciones, vendedor, fec_produccion, 
                          almacen_old, tipo_doc_int, nro_doc_int)
                   values(
                          ls_org_alm, ls_vale_ing, asi_almacen, '1', adi_fecha, ls_oper_ing_transf, asi_usuario, ls_obs,
                          PKG_FACT_ELECTRONICA.is_doc_prof, asi_nro_proforma, ls_obs, asi_vendedor, trunc(adi_fecha), 
                          asi_almacen, is_doc_alm, ls_vale_sal);
                         
                else
                   select distinct
                          vm.nro_Vale
                     into ls_vale_ing
                     from vale_mov     vm,
                          articulo_mov am
                    where vm.nro_Vale      = am.nro_vale
                      and vm.almacen       = asi_almacen
                      and vm.tipo_mov      = ls_oper_ing_transf
                      and am.nro_proforma  = asi_nro_proforma
                      and am.item_proforma = ani_item_proforma
                      and vm.flag_estado   <> '0'
                      and am.flag_estado   <> '0';
                end if;
                      
                -- Ahora inserto el detalle de articulo_mov
                select count(*)
                  into ln_count
                  from articulo_mov am
                 where am.nro_vale      = ls_vale_ing
                   and am.nro_proforma  = asi_nro_proforma
                   and am.item_proforma = ani_item_proforma
                   and am.cod_art       = asi_cod_art
                   and am.flag_estado   <> '0'; 
                      
                if ln_count = 0 then
                         
                   select count(*)
                     into ln_count
                     from articulo_almacen aa
                    where aa.cod_art = asi_cod_art
                      and aa.almacen = asi_almacen;
                         
                   if ln_count = 0 then
                       ln_precio_unit := 0.00;
                   else
                      select aa.costo_prom_sol
                        into ln_precio_unit
                        from articulo_almacen aa
                       where aa.cod_art = asi_cod_art
                         and aa.almacen = asi_almacen;
                   end if;   
                   
                   select a.sub_cat_art, av.cencos_ingreso
                     into ls_sub_Cat_Art, ls_cencos
                     from articulo a,
                          articulo_venta av
                    where a.cod_Art = av.cod_art (+)
                      and a.cod_art = asi_cod_art;
                   
                   select max(cba.centro_benef)
                     into ls_centro_benef
                     from centro_benef_articulo cba
                    where cba.cod_art = asi_cod_art;
                         
                   ls_matriz := usf_alm_matriz_contable(ls_oper_sal_transf, ls_Cencos, null, ls_sub_cat_art);
                      
                   insert into articulo_mov(
                          cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                          cod_moneda,
                          cencos, matriz, cant_proc_und2, fec_registro, centro_benef, 
                          nro_proforma, item_proforma)	
                   values(        
                          ls_org_alm, ls_vale_ing, '1', asi_cod_Art, ln_cant_ingr_und1, ln_precio_unit, 
                          PKG_LOGISTICA.is_soles,
                          ls_cencos, ls_matriz, ln_cant_ingr_und2, sysdate, ls_centro_benef, 
                          asi_nro_proforma, ani_item_proforma);
                end if;
             
            end if;

         end if;

     end if;
     
     if ani_cant_und2 > 0 and ls_flag_und2 = '1' then
        -- Obtengo los saldos por cada und
        select count(*)
          into ln_count
          from articulo_almacen aa
         where aa.cod_art = asi_cod_art
           and aa.almacen = asi_almacen;
         
        if ln_count > 0 then
           select aa.sldo_total_und2
             into ln_sldo_total_und2
             from articulo_almacen aa
            where aa.cod_art = asi_cod_art
              and aa.almacen = asi_almacen;
        else
           ln_sldo_total_und2 := 0.00;
        end if;
         
        if ln_sldo_total_und2 < ani_cant_und2 then
           -- Calculo la cantidad que debe ingresar por transformación
           ln_cant_ingr_und2 := ani_cant_und2 - ln_sldo_total_und2;
            
           if ls_flag_und2 = '1' then
              ln_cant_ingr_und1 := ln_cant_ingr_und2 / ln_factor_conv_und;
           else
              RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || asi_cod_art || ' tiene Cantidad en Und2 pero '
                                        || 'no tiene activo el Flag_und2 para la conversión, por favor verifique!'
                                        || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
           end if;
            
            if ln_cant_ingr_und1 > 0 or ln_cant_ingr_und2 > 0 then
               -- Recorremos el cursor para determinar la cantidad según la composicion y hacer
               -- la salida por transformación correspondiente
               for lc_reg in c_componentes loop
                   -- Validos las unidades y los factores de Und2
                   if lc_reg.flag_und2 = '1' and lc_reg.factor_conv_und = 0 then
                      RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' tiene activo el Flag_und2 '
                                                      || 'pero no ha especificado el factor, por favor verifique!'
                                                      || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                   end if;
                    
                   if lc_reg.flag_und2 = '1' and lc_reg.und2 is null then
                      RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' tiene activo el Flag_und2 '
                                                      || 'pero no ha especificado la 2da Unidad, por favor verifique!'
                                                      || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                   end if;
                   
                   if lc_reg.und_componente = lc_reg.und then
                      
                      -- Si la und_componente es la unidad1 y obtengo las unidades convertidas
                      ln_cant_sal_und1 := lc_reg.cantidad * ln_cant_ingr_und1;
                      ln_cant_sal_und2 := ln_cant_sal_und1 * lc_reg.factor_conv_und;
                      
                   elsif lc_reg.und_componente = lc_reg.und2 then
                      
                      if lc_reg.flag_und2 = '0' or lc_reg.factor_conv_und = 0 then
                         RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' tiene en cantidad ' 
                                                         || trim(to_char(lc_reg.cantidad * ln_cant_ingr_und1, '999.990.000000')) || ' en und2 ' || lc_reg.und_componente
                                                         || 'pero no ha especificado el factor o el flag und2, por favor verifique!'
                                                         || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                      end if;
                   
                      -- Si la und componente es la unidad2 y obtengo las undiades convertidas
                      ln_cant_sal_und2 := lc_reg.cantidad * ln_cant_ingr_und1;
                      ln_cant_sal_und1 := ln_cant_sal_und2 / lc_reg.factor_conv_und;
                   
                   
                   else
                      -- Busco la unidad de ARTICULO_UND
                      select count(*)
                        into ln_count
                        from articulo_und au
                       where au.cod_art = lc_reg.componente
                         and au.und     = lc_reg.und_componente;
                      
                      if ln_count = 0 then
                         RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' con cantidad ' 
                                                         || trim(to_char(lc_reg.cantidad * ln_cant_ingr_und1, '999.990.000000')) || ' ' || lc_reg.und_componente
                                                         || 'no coincide con ninguna unidad del Articulo, por favor verifique!'
                                                         || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                      end if;
                      
                      select au.factor_conv_und
                        into ln_factor_conv_und
                        from articulo_und au
                       where au.cod_art = lc_reg.componente
                         and au.und     = lc_reg.und_componente;
                      
                      -- Obtengo las cantidades en und1 y und2
                      ln_cant_sal_und1 := lc_reg.cantidad * ln_cant_ingr_und1 / ln_factor_conv_und;
                      ln_cant_sal_und2 := ln_cant_sal_und1 * lc_reg.factor_conv_und;
                      
                   
                   end if;
                   
                   if ln_cant_sal_und1 > 0 or ln_cant_sal_und2 > 0 then
                      -- Obtengo el almacen donde hay stock suficiente
                      select count(*)
                        into ln_count
                        from articulo_almacen aa
                       where aa.cod_art = lc_reg.componente
                         and aa.sldo_total > ln_cant_sal_und1;
                      
                      if ln_count = 0 then
                         RAISE_APPLICATION_ERROR(-20000, 'El Codigo de Artículo ' || lc_reg.componente || ' no tiene saldo suficiente '
                                                         || 'en stock en Und1, por favor verifique!'
                                                         || chr(13) || 'Cantidad: ' || trim(to_char(ln_cant_sal_und1, '999,990.000000')) || ' ' || lc_reg.und
                                                         || chr(13) || 'Nro Proforma: ' || asi_nro_proforma);
                      end if;
                      
                      -- Obtengo el almacen que tenga suficiente stock para la salida por transformación
                      select al.cod_origen
                        into ls_org_alm
                        from articulo_almacen aa,
                             almacen          al
                       where aa.almacen = al.almacen
                         and aa.cod_art = lc_reg.componente
                         and aa.sldo_total > ln_cant_sal_und1
                         and aa.almacen    = asi_almacen;
                      
                      -- Creo el vale de salida por transformación
                      select count(*)
                        into ln_count
                        from vale_mov     vm,
                             articulo_mov am
                       where vm.nro_Vale      = am.nro_vale
                         and vm.almacen       = asi_almacen
                         and vm.tipo_mov      = ls_oper_sal_transf
                         and am.nro_proforma  = asi_nro_proforma
                         and am.item_proforma = ani_item_proforma
                         and vm.flag_estado   <> '0'
                         and am.flag_estado   <> '0';
                      
                      -- Glosa
                      ls_obs := 'TRANSFORMACION AUTOMATICA PROFORMA: ' || asi_nro_proforma || ' Item : ' || trim(to_char(ani_item_proforma));
                      
                      -- Si no existe el nro de vale lo creo
                      if ln_count = 0 then
                         select count(*)
                           into ln_count
                           from num_vale_mov n
                          where n.origen = ls_org_vale;
                         
                         if ln_count = 0 then
                            insert into num_vale_mov(
                                   ult_nro, origen)
                            values(
                                   1, ls_org_vale);
                         end if;
                         
                         select n.ult_nro
                           into ln_ult_nro
                           from num_vale_mov n
                          where n.origen = ls_org_vale for update;
                         
                         ls_vale_sal := trim(ls_org_vale) || trim(to_char(ln_ult_nro, '00000000'));
                         
                         update num_vale_mov n
                            set n.ult_nro = ln_ult_nro + 1
                          where n.origen = ls_org_vale;
                         
                         insert into vale_mov(
                                cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, nom_receptor,
                                tipo_doc_ext, nro_doc_ext, observaciones, vendedor, fec_produccion, 
                                almacen_old)
                         values(
                                ls_org_alm, ls_vale_sal, asi_almacen, '1', adi_fecha, ls_oper_sal_transf, asi_usuario, ls_obs,
                                PKG_FACT_ELECTRONICA.is_doc_prof, asi_nro_proforma, ls_obs, asi_vendedor, trunc(adi_fecha), 
                                asi_almacen);
                         
                      else
                         select distinct
                                vm.nro_Vale
                           into ls_vale_sal
                           from vale_mov     vm,
                                articulo_mov am
                          where vm.nro_Vale      = am.nro_vale
                            and vm.almacen       = asi_almacen
                            and vm.tipo_mov      = ls_oper_sal_transf
                            and am.nro_proforma  = asi_nro_proforma
                            and am.item_proforma = ani_item_proforma
                            and vm.flag_estado   <> '0'
                            and am.flag_estado   <> '0';
                      end if;
                      
                      -- Ahora inserto el detalle de articulo_mov
                      select count(*)
                        into ln_count
                        from articulo_mov am
                       where am.nro_vale      = ls_vale_sal
                         and am.nro_proforma  = asi_nro_proforma
                         and am.item_proforma = ani_item_proforma
                         and am.cod_art       = lc_reg.componente
                         and am.flag_estado   <> '0'; 
                      
                      if ln_count = 0 then
                         
                         select count(*)
                           into ln_count
                           from articulo_almacen aa
                          where aa.cod_art = lc_reg.componente
                            and aa.almacen = asi_almacen;
                         
                         if ln_count > 0 then
                             ln_precio_unit := 0.00;
                         else
                            select aa.costo_prom_sol
                              into ln_precio_unit
                              from articulo_almacen aa
                             where aa.cod_art = lc_reg.componente
                               and aa.almacen = asi_almacen;
                         end if;   
                         
                         ls_matriz := usf_alm_matriz_contable(ls_oper_sal_transf, lc_reg.cencos_ingreso, null, lc_reg.sub_cat_art);
                      
                         insert into articulo_mov(
                                cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                                cod_moneda,
                                cencos, matriz, cant_proc_und2, fec_registro, centro_benef, 
                                nro_proforma, item_proforma)	
                         values(        
                                ls_org_alm, ls_vale_sal, '1', lc_reg.componente, ln_cant_sal_und1, ln_precio_unit, 
                                PKG_LOGISTICA.is_soles,
                                lc_reg.cencos_ingreso, ls_matriz, ln_cant_sal_und2, sysdate, lc_reg.centro_benef, 
                                asi_nro_proforma, ani_item_proforma);
                      else
                         update articulo_mov am
                            set am.cant_procesada = am.cant_procesada + ln_cant_sal_und1,
                                am.cant_proc_und2 = am.cant_proc_und2 + ln_cant_sal_und2
                         where am.nro_vale      = ls_vale_sal
                           and am.nro_proforma  = asi_nro_proforma
                           and am.item_proforma = ani_item_proforma
                           and am.cod_art       = lc_reg.componente
                           and am.flag_estado   <> '0'; 
                      end if;
     
                          
                   end if;
                end loop;
                
                -- Una vez que hice la salida de los componentes AHORA realizo el Ingreso por transformacion
                select a.cod_origen
                  into ls_org_alm
                  from almacen a
                 where a.almacen = asi_almacen;
                 
                select count(*)
                  into ln_count
                  from vale_mov     vm,
                       articulo_mov am
                 where vm.nro_Vale      = am.nro_vale
                   and vm.almacen       = asi_almacen
                   and vm.tipo_mov      = ls_oper_ing_transf
                   and am.nro_proforma  = asi_nro_proforma
                   and am.item_proforma = ani_item_proforma
                   and vm.flag_estado   <> '0'
                   and am.flag_estado   <> '0';
                      
                -- Glosa
                ls_obs := 'TRANSFORMACION AUTOMATICA PROFORMA: ' || asi_nro_proforma || ' Item : ' || trim(to_char(ani_item_proforma));
                      
                -- Si no existe el nro de vale lo creo
                if ln_count = 0 then
                   select count(*)
                     into ln_count
                     from num_vale_mov n
                    where n.origen = ls_org_vale;
                         
                   if ln_count = 0 then
                      insert into num_vale_mov(
                             ult_nro, origen)
                      values(
                             1, ls_org_vale);
                   end if;
                         
                   select n.ult_nro
                     into ln_ult_nro
                     from num_vale_mov n
                    where n.origen = ls_org_vale for update;
                         
                   ls_vale_ing := trim(ls_org_vale) || trim(to_char(ln_ult_nro, '00000000'));
                         
                   update num_vale_mov n
                      set n.ult_nro = ln_ult_nro + 1
                    where n.origen = ls_org_vale;
                         
                   insert into vale_mov(
                          cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, nom_receptor,
                          tipo_doc_ext, nro_doc_ext, observaciones, vendedor, fec_produccion, 
                          almacen_old, tipo_doc_int, nro_doc_int)
                   values(
                          ls_org_alm, ls_vale_ing, asi_almacen, '1', adi_fecha, ls_oper_ing_transf, asi_usuario, ls_obs,
                          PKG_FACT_ELECTRONICA.is_doc_prof, asi_nro_proforma, ls_obs, asi_vendedor, trunc(adi_fecha), 
                          asi_almacen, is_doc_alm, ls_vale_sal);
                         
                else
                   select distinct
                          vm.nro_Vale
                     into ls_vale_ing
                     from vale_mov     vm,
                          articulo_mov am
                    where vm.nro_Vale      = am.nro_vale
                      and vm.almacen       = asi_almacen
                      and vm.tipo_mov      = ls_oper_ing_transf
                      and am.nro_proforma  = asi_nro_proforma
                      and am.item_proforma = ani_item_proforma
                      and vm.flag_estado   <> '0'
                      and am.flag_estado   <> '0';
                end if;
                      
                -- Ahora inserto el detalle de articulo_mov
                select count(*)
                  into ln_count
                  from articulo_mov am
                 where am.nro_vale      = ls_vale_ing
                   and am.nro_proforma  = asi_nro_proforma
                   and am.item_proforma = ani_item_proforma
                   and am.cod_art       = asi_cod_art
                   and am.flag_estado   <> '0'; 
                      
                if ln_count = 0 then
                         
                   select count(*)
                     into ln_count
                     from articulo_almacen aa
                    where aa.cod_art = asi_cod_art
                      and aa.almacen = asi_almacen;
                         
                   if ln_count > 0 then
                       ln_precio_unit := 0.00;
                   else
                      select aa.costo_prom_sol
                        into ln_precio_unit
                        from articulo_almacen aa
                       where aa.cod_art = asi_cod_art
                         and aa.almacen = asi_almacen;
                   end if;   
                   
                   select a.sub_cat_art, av.cencos_ingreso
                     into ls_sub_Cat_Art, ls_cencos
                     from articulo a,
                          articulo_venta av
                    where a.cod_Art = av.cod_art (+)
                      and a.cod_art = asi_cod_art;
                   
                   select max(cba.centro_benef)
                     into ls_centro_benef
                     from centro_benef_articulo cba
                    where cba.cod_art = asi_cod_art;
                         
                   ls_matriz := usf_alm_matriz_contable(ls_oper_sal_transf, ls_Cencos, null, ls_sub_cat_art);
                      
                   insert into articulo_mov(
                          cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                          cod_moneda,
                          cencos, matriz, cant_proc_und2, fec_registro, centro_benef, 
                          nro_proforma, item_proforma)	
                   values(        
                          ls_org_alm, ls_vale_ing, '1', asi_cod_Art, ln_cant_ingr_und1, ln_precio_unit, 
                          PKG_LOGISTICA.is_soles,
                          ls_cencos, ls_matriz, ln_cant_ingr_und2, sysdate, ls_centro_benef, 
                          asi_nro_proforma, ani_item_proforma);
                else
                   update articulo_mov am
                      set am.cant_procesada = am.cant_procesada + ln_cant_ingr_und1,
                          am.cant_proc_und2 = am.cant_proc_und2 + ln_cant_ingr_und2
                    where am.nro_vale      = ls_vale_ing
                      and am.nro_proforma  = asi_nro_proforma
                      and am.item_proforma = ani_item_proforma
                      and am.cod_art       = asi_cod_art
                      and am.flag_estado   <> '0';
                end if;
             
            end if;

        end if;
 

     end if;
     
     
   end ;

  -- Ajustar automaticamente el almacen, tomando como base el inventario_pallets, que se toma con el PDA
  -- y por ahora solo sirve para CONSERVAS
  procedure sp_ajuste_inventario_pallets(
            asi_almacen       in almacen.almacen%TYPE,
            adi_fecha         in date,
            asi_usuario       in usuario.cod_usr%TYPE
  ) is
     -- Variables
     ls_cat_conservas         articulo_categ.cat_art%TYPE := '102';
     ln_count                 number;
     ln_ult_nro               num_vale_mov.ult_nro%TYPE;
     
     -- Articulo_mov
     ln_inventario_und1       articulo_mov.cant_procesada%TYPE;
     ln_inventario_und2       articulo_mov.cant_procesada%TYPE;
     ln_cant_proce_und1       articulo_mov.cant_procesada%TYPE;
     ln_cant_proce_und2       articulo_mov.cant_proc_und2%TYPE;
     ls_codigo_cu             tg_parte_empaque_und.codigo_cu%TYPE;
     ls_nro_lote              articulo_mov.nro_lote%TYPE;
     ln_precio_unit           articulo_mov.precio_unit%TYPE;
     
     -- Vale_mov 
     ld_fec_registro          vale_mov.fec_registro%TYPE;
     ls_org_nro               vale_mov.cod_origen%TYPE := 'AX';
     ls_org_vale              vale_mov.cod_origen%TYPE;
     ls_nom_receptor          vale_mov.nom_receptor%TYPE;
     ls_nro_Vale              vale_mov.nro_vale%TYPE;
     ls_nro_Vale_sal          vale_mov.nro_Vale%TYPE;
     ls_nro_Vale_ing          vale_mov.nro_Vale%TYPE;
     
     -- Num_tablas
     ls_nom_tabla             num_tablas.tabla%TYPE;
     
     -- Parte de Transferencia
     ls_parte_transf          tg_parte_transferencia.nro_parte%TYPE;
     
     -- Parte de transferencia Und
     ln_item                  tg_parte_transferencia_und.nro_item%TYPE;
     ls_org_am_ing            tg_parte_recepcion_und.org_am_ing%TYPE;
     ln_nro_am_ing            tg_parte_recepcion_und.nro_am_ing%TYPE;
     ls_org_am_sal            tg_parte_recepcion_und.org_am_sal%TYPE;
     ln_nro_am_sal            tg_parte_recepcion_und.nro_am_sal%TYPE;
     
     -- Articulo_almacen
     ln_Saldo_total_und1      articulo_almacen.sldo_total%TYPE;
     ln_Saldo_total_und2      articulo_almacen.sldo_total_und2%TYPE;
     
     cursor c_pallets is
      select vw1.almacen as almacen_org,
             vw1.nro_pallet,
             vw1.anaquel,
             vw1.fila,
             vw1.columna,
             vw1.saldo_total_und,
             vw1.saldo_total_und2,
             vw2.almacen as almacen_dst,
             vw2.nro_pallet as nro_pallet_dst,
             vw2.anaquel as anaquel_dst,
             vw2.fila as fila_dst,
             vw2.columna as columna_dst
        from (select vm.almacen,
                     am.nro_pallet,
                     am.anaquel,
                     am.fila,
                     am.columna,
                     sum(am.cant_procesada * amt.factor_sldo_total) as saldo_total_und,
                     sum(am.cant_proc_und2 * amt.factor_sldo_total) as saldo_total_und2
                from vale_mov vm,
                     articulo_mov am,
                     articulo_mov_tipo amt,
                     almacen           al
               where vm.nro_vale = am.nro_vale
                 and vm.tipo_mov = amt.tipo_mov
                 and am.flag_estado <> '0'
                 and vm.flag_estado <> '0'
                 and am.nro_pallet is not null
                 and vm.almacen     = asi_almacen
                 and trunc(vm.fec_registro) <= trunc(adi_fecha)
              group by vm.almacen,
                       am.nro_pallet,
                       am.anaquel,
                       am.fila,
                       am.columna
              having sum(am.cant_procesada * amt.factor_sldo_total) > 0 or sum(am.cant_proc_und2 * amt.factor_sldo_total) > 0) vw1,
             (select *
                from inventario_pallets ip
               where trunc(ip.fecha) = trunc(adi_fecha)) vw2
      where vw1.almacen     = vw2.almacen    (+)
        and vw1.nro_pallet  = vw2.nro_pallet (+)
      order by vw2.almacen  ;
     
     cursor c_datos is
        select t.almacen,
               t.anaquel,
               t.fila,
               t.columna,
               t.fecha,
               t.nro_cajas,
               t.cod_usr,
               t.nro_pallet, 
               a1.cat_art,
               a.cod_art,
               a.desc_art,
               a.flag_und2,
               decode(a.flag_und2, '0', 0, a.factor_conv_und) as factor_conv_und,
               al.desc_almacen,
               vw.und,
               vw.und2,
               trim(vw.nro_pallet) as nro_pallet_sigre,
               nvl(sum(vw.saldo_und2),0) as saldo_und2,
               nvl(sum(vw.saldo),0) as saldo_und1
        from inventario_pallets t,
             almacen            al,
             tg_parte_empaque   te,
             articulo           a,
             articulo_sub_categ a2,
             articulo_categ     a1,
             (select vm.almacen,
                     am.anaquel,
                     am.fila,
                     am.columna,
                     am.nro_pallet,
                     a.und,
                     a.und2,
                     sum(am.cant_procesada * amt.factor_sldo_total) as saldo,
                     sum(nvl(am.cant_proc_und2,0) * amt.factor_sldo_total) as saldo_und2
                from vale_mov         vm,
                     articulo_mov       am,
                     articulo_mov_tipo  amt,
                 articulo       a
               where vm.nro_vale      = am.nro_vale
                 and vm.tipo_mov      = amt.tipo_mov
              and am.cod_art          = a.cod_art
                 and vm.flag_estado   <> '0'
                 and am.flag_estado   <> '0'
                 and vm.almacen       = asi_almacen
                 and trunc(vm.fec_registro) <= trunc(adi_fecha)
              group by vm.almacen,
                       am.anaquel,
                       am.fila,
                       am.columna,
                       am.nro_pallet,
                       a.und,
                       a.und2
               having sum(am.cant_procesada * amt.factor_sldo_total) > 0)  vw
        where t.almacen       = al.almacen
          and te.cod_art_pptt = a.cod_art
          and a.sub_cat_art   = a2.cod_sub_cat
          and a2.cat_art      = a1.cat_art
          and t.nro_pallet    = te.nro_pallet (+)
          and t.almacen       = vw.almacen    (+)
          and t.anaquel       = vw.anaquel    (+)
          and t.fila          = vw.fila       (+)
          and t.columna       = vw.columna    (+)
          and t.nro_pallet    = vw.nro_pallet (+)
          and t.almacen       = asi_almacen
          and a1.cat_art      = ls_cat_conservas  -- Por ahora solo en conservas
          and trunc(t.fecha)  = trunc(adi_fecha)
     group by  t.almacen,
               t.anaquel,
               t.fila,
               t.columna,
               t.fecha,
               t.nro_cajas,
               t.cod_usr,
               t.nro_pallet, 
               a1.cat_art,
               a.cod_art,
               a.desc_art,
               a.flag_und2,
               decode(a.flag_und2, '0', 0, a.factor_conv_und),
               al.desc_almacen,
               vw.und,
               vw.und2,
               vw.nro_pallet
        having t.nro_cajas <> nvl(sum(vw.saldo), 0);
        
     cursor c_detalle(as_nro_pallet articulo_mov.nro_pallet%TYPE,
                      as_anaquel    articulo_mov.anaquel%TYPE,
                      as_fila       articulo_mov.fila%TYPE,
                      as_columna    articulo_mov.columna%TYPE) is
        select vm.almacen,
               am.nro_pallet,
               am.anaquel,
               am.fila,
               am.columna,
               am.cod_art,
               am.nro_lote,
               am.cus,
               a.flag_und2,
               a.factor_conv_und,
               sum(am.cant_procesada * amt.factor_sldo_total) as saldo_total_und1,
               sum(am.cant_proc_und2 * amt.factor_sldo_total) as saldo_total_und2,
               sum(am.cant_procesada * am.precio_unit * amt.factor_sldo_total) as importe
          from vale_mov vm,
               articulo_mov am,
               articulo_mov_tipo amt,
               almacen           al,
               articulo          a
          where vm.nro_vale = am.nro_vale
            and vm.tipo_mov  = amt.tipo_mov
            and vm.almacen   = al.almacen
            and am.cod_art   = a.cod_art
            and am.flag_estado <> '0'
            and vm.flag_estado <> '0'
            and am.nro_pallet is not null
            and vm.almacen     = asi_almacen
            and am.nro_pallet  = as_nro_pallet
            and am.anaquel     = as_anaquel
            and am.fila        = as_fila
            and am.columna     = as_columna
            and trunc(vm.fec_registro) <= trunc(adi_fecha)
          group by vm.almacen,
                 am.nro_pallet,
                 am.anaquel,
                 am.fila,
                 am.columna,
                 am.cod_art,
                 am.nro_lote,
                 am.cus,
                 a.flag_und2,
                 a.factor_conv_und
          having sum(am.cant_procesada * amt.factor_sldo_total) > 0 or sum(am.cant_proc_und2 * amt.factor_sldo_total) > 0;
     
  begin
     ld_fec_registro := to_date(to_char(adi_fecha, 'dd/mm/yyyy') || ' 23:59:59', 'dd/mm/yyyy HH24:mi:ss');
     
     
     for lc_reg in c_pallets loop
       
         select al.cod_origen
           into ls_org_vale
           from almacen al
          where al.almacen = lc_reg.almacen_org;
          
         if lc_reg.almacen_dst is null then
           
            
            ls_org_nro := 'TX';
            
            -- Si el almacen destino es nulo entonces se hace una salida por ajuste de inventario
            ln_inventario_und1 := lc_reg.saldo_total_und;
            ln_inventario_und2 := lc_reg.saldo_total_und2;
            
            ls_nom_receptor    := 'SAL. XAJUSTE ' || trim(is_ing_ajuste_inventario) || '. ALMACEN: ' || 
                                  lc_reg.almacen_org;
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen      = lc_reg.almacen_org
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = is_sal_ajuste_inventario
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      ls_org_vale, ls_nro_Vale, lc_reg.almacen_org, '1', ld_fec_registro, 
                      is_sal_ajuste_inventario, asi_usuario,
                      ls_nom_receptor, ls_nom_receptor, trunc(adi_fecha), lc_reg.almacen_org);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen      = lc_reg.almacen_org
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = is_sal_ajuste_inventario
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Ahora inserto el detalle del pallet
            for lc_detalle in c_detalle(lc_reg.nro_pallet,
                                        lc_reg.anaquel,
                                        lc_reg.fila,
                                        lc_reg.columna) loop
                                        
                if lc_detalle.saldo_total_und2 = 0 and lc_detalle.flag_und2 = '1' then
                   ln_cant_proce_und2 := lc_detalle.saldo_total_und1 * lc_detalle.factor_conv_und;
                else
                   ln_cant_proce_und2 := lc_detalle.saldo_total_und2;
                end if; 
                
                if lc_detalle.saldo_total_und1 = 0 or lc_detalle.importe = 0 then
                   ln_precio_unit := 1;
                else
                   ln_precio_unit := lc_detalle.importe / lc_detalle.saldo_total_und1;
                end if;
                
                -- Valido si hay stock para la salida
                 select count(*)
                   into ln_count
                   from articulo_almacen t
                  where t.cod_art    = lc_detalle.cod_art
                    and t.almacen    = lc_reg.almacen_org;
                 
                 if ln_count = 0 then
                    insert into articulo_almacen(
                           cod_art, almacen, sldo_total, sldo_total_und2)
                    values(
                           lc_detalle.cod_art,  lc_reg.almacen_org, 
                           lc_detalle.saldo_total_und1,
                           lc_detalle.saldo_total_und2);
                 else
                    update articulo_almacen t
                       set t.sldo_total      = sldo_total + lc_detalle.saldo_total_und1,
                           t.sldo_total_und2 = sldo_total_und2 + lc_detalle.saldo_total_und2
                     where t.cod_art    = lc_detalle.cod_art
                       and t.almacen       = lc_reg.almacen_org;
                 end if;
                 
                 if lc_detalle.nro_lote like '200721%' then
                    null;
                 end if;
                
                 -- Valido si hay stock para la salida
                 select count(*)
                   into ln_count
                   from templa_saldo t
                  where trim(t.cod_templa)   = trim(lc_detalle.nro_lote)
                    and t.cod_art    = lc_detalle.cod_art
                    and t.almacen    = lc_reg.almacen_org;
                 
                 if ln_count > 0 then
                    select t.saldo, t.saldo_und2
                      into ln_Saldo_total_und1, ln_Saldo_total_und2
                      from templa_saldo t
                     where trim(t.cod_templa)   = trim(lc_detalle.nro_lote)
                       and t.cod_art    = lc_detalle.cod_art
                       and t.almacen    = lc_reg.almacen_org;
                 else
                    ln_Saldo_total_und1 := 0.0;
                    ln_Saldo_total_und2 := 0.0;
                 end if;
                 
                 if ln_saldo_total_und1 < lc_detalle.saldo_total_und1 then
                    ln_saldo_total_und1 := lc_detalle.saldo_total_und1;
                 end if;
                 
                 if ln_saldo_total_und2 < lc_detalle.saldo_total_und2 then
                    ln_saldo_total_und2 := lc_detalle.saldo_total_und2;
                 end if;
                 
                 
                 if ln_count = 0 then
                    insert into templa_saldo(
                           cod_templa, cod_art, saldo, saldo_und2, almacen)
                    values(
                           lc_detalle.nro_lote, lc_detalle.cod_art, ln_saldo_total_und1,
                           ln_saldo_total_und2, lc_reg.almacen_org);
                 else
                    update templa_saldo t
                       set t.saldo = ln_saldo_total_und1,
                           t.saldo_und2 = ln_saldo_total_und2
                     where t.cod_templa   = lc_detalle.nro_lote
                       and t.cod_art    = lc_detalle.cod_art
                       and t.almacen    = lc_reg.almacen_org; 
                 end if;
                 
                 
                 
                 -- Valido si hay stock para la salida
                 select count(*)
                   into ln_count
                   from articulo_almacen_cus t
                  where t.almacen    = lc_reg.almacen_org
                    and t.cod_art    = lc_detalle.cod_art
                    and t.nro_lote   = lc_detalle.nro_lote
                    and t.nro_pallet = lc_detalle.nro_pallet
                    and t.cus        = lc_detalle.cus
                    and t.anaquel    = lc_reg.anaquel
                    and t.fila       = lc_reg.fila
                    and t.columna    = lc_reg.columna;
                 
                 if ln_count = 0 then
                    insert into articulo_almacen_cus(
                           almacen, cod_art, nro_lote, nro_pallet, anaquel, fila, columna,
                           cus, saldo_und, saldo_und2)
                    values(
                           lc_reg.almacen_org, lc_detalle.cod_art, lc_detalle.nro_lote, lc_detalle.nro_pallet,
                           lc_reg.anaquel, lc_reg.fila, lc_reg.columna,
                           lc_detalle.cus,
                           lc_detalle.saldo_total_und1,
                           lc_Detalle.saldo_total_und2);
                 else
                    update articulo_almacen_cus t
                       set t.saldo_und = t.saldo_und + lc_detalle.saldo_total_und1,
                           t.saldo_und2 = t.saldo_und2 + lc_detalle.saldo_total_und2
                     where t.almacen    = lc_reg.almacen_org
                       and t.cod_art    = lc_detalle.cod_art
                       and t.nro_lote   = lc_detalle.nro_lote
                       and t.nro_pallet = lc_detalle.nro_pallet
                       and t.cus        = lc_detalle.cus
                       and t.anaquel    = lc_reg.anaquel
                       and t.fila       = lc_reg.fila
                       and t.columna    = lc_reg.columna;
                 end if;
                 
                 -- Valido si hay stock para la salida
                 select count(*)
                   into ln_count
                   from articulo_almacen_pallet t
                  where t.almacen    = lc_reg.almacen_org
                    and t.cod_art    = lc_detalle.cod_art
                    and t.nro_pallet = lc_detalle.nro_pallet
                    and t.anaquel    = lc_reg.anaquel
                    and t.fila       = lc_reg.fila
                    and t.columna    = lc_reg.columna;
                 
                 if ln_count > 0 then
                    select t.saldo_und, t.saldo_und2
                      into ln_Saldo_total_und1, ln_Saldo_total_und2
                      from articulo_almacen_pallet t
                     where t.almacen    = lc_reg.almacen_org
                       and t.cod_art    = lc_detalle.cod_art
                       and t.nro_pallet = lc_detalle.nro_pallet
                       and t.anaquel    = lc_reg.anaquel
                       and t.fila       = lc_reg.fila
                       and t.columna    = lc_reg.columna;
                 else
                    ln_Saldo_total_und1 := 0.0;
                    ln_Saldo_total_und2 := 0.0;
                 end if;
                 
                 if ln_saldo_total_und1 < lc_detalle.saldo_total_und1 then
                    ln_saldo_total_und1 := lc_detalle.saldo_total_und1;
                 end if;
                 
                 if ln_saldo_total_und2 < lc_detalle.saldo_total_und2 then
                    ln_saldo_total_und2 := lc_detalle.saldo_total_und2;
                 end if;
                 
                 
                 if ln_count = 0 then
                    insert into articulo_almacen_pallet(
                           almacen, cod_art, nro_pallet, anaquel, fila, columna,
                           saldo_und, saldo_und2)
                    values(
                           lc_reg.almacen_org, lc_detalle.cod_art, lc_detalle.nro_pallet,
                           lc_reg.anaquel, lc_reg.fila, lc_reg.columna,
                           ln_saldo_total_und1,
                           ln_saldo_total_und2);
                 else
                    update articulo_almacen_pallet t
                       set t.saldo_und = ln_Saldo_total_und1,
                           t.saldo_und2 = ln_Saldo_total_und2
                     where t.almacen    = lc_reg.almacen_org
                       and t.cod_art    = lc_detalle.cod_art
                       and t.nro_pallet = lc_detalle.nro_pallet
                       and t.anaquel    = lc_reg.anaquel
                       and t.fila       = lc_reg.fila
                       and t.columna    = lc_reg.columna;  
                 end if;
                    
                 -- Ahora la salida
                 insert into articulo_mov(
                      cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                      cod_moneda, 
                      cant_proc_und2, nro_lote, nro_pallet, cus, 
                      anaquel, fila, columna)
                 values(
                      ls_org_vale, ls_nro_vale, '1', lc_detalle.cod_art, lc_detalle.saldo_total_und1, 
                      ln_precio_unit, 
                      PKG_LOGISTICA.is_soles,
                      ln_cant_proce_und2, lc_detalle.nro_lote, lc_detalle.nro_pallet, lc_detalle.cus,
                      lc_detalle.anaquel, lc_detalle.fila, lc_detalle.columna);
            end loop;
            
         elsif lc_reg.anaquel <> lc_reg.anaquel_dst or lc_reg.fila <> lc_reg.fila_dst or 
               lc_reg.columna <> lc_reg.columna_dst then
             
             ls_org_nro      := 'RX';
             ls_nom_tabla    := 'TG_PARTE_TRANSFERENCIA';
             ls_nom_receptor := 'TRANSF. INTERNA ' || trim(is_ing_ajuste_inventario) || '. ALMACEN: ' || 
                                  lc_reg.almacen_org;
             
             -- Genero un parte de transferencia  
             select count(*)
               into ln_count
               from num_tablas n
              where n.tabla = ls_nom_tabla
                and n.origen = ls_org_nro;
             
             if ln_count = 0 then
                insert into num_Tablas(
                       Tabla, Origen, Ult_Nro)
                values(
                       ls_nom_tabla, ls_org_nro, 1);
             end if;
             
             select ult_nro
               into ln_ult_nro
               from num_tablas n
              where n.tabla = ls_nom_tabla
                and n.origen = ls_org_nro for update;
             
             ls_parte_transf := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
             
             update num_tablas n
                set n.ult_nro = ln_ult_nro + 1
              where n.tabla = ls_nom_tabla
                and n.origen = ls_org_nro;
             
             insert into tg_parte_transferencia(
                    nro_parte, cod_origen, almacen_org, almacen_dst, fec_registro, fec_transferencia,
                    anaquel_org, fila_org, columna_org, cod_usr, cantidad, nro_cajas, 
                    anaquel_dst, fila_dst, columna_dst, nro_pallet_org, nro_pallet_dst, 
                    flag_estado) 
             values(
                    ls_parte_transf, ls_org_vale, lc_reg.almacen_org, lc_reg.almacen_dst, sysdate, trunc(ld_fec_registro),
                    lc_reg.anaquel, lc_reg.fila, lc_reg.columna, asi_usuario, lc_reg.saldo_total_und, lc_reg.saldo_total_und2,
                    lc_reg.anaquel_dst, lc_reg.fila_dst, lc_reg.columna_dst, lc_reg.nro_pallet, lc_reg.nro_pallet_dst, 
                    '1');
             
             -- Inserto el vale de SALIDA por Transferencia
             -- Genero un nuevo vale de ingreso
             select count(*)
               into ln_count
               from num_vale_mov n
              where n.origen = ls_org_nro;
            
             if ln_count = 0 then
                insert into num_Vale_mov(Ult_Nro, Origen)
                values(1, ls_org_nro);
             end if;
             
             select n.ult_nro
               into ln_ult_nro
               from num_vale_mov n
              where n.origen = ls_org_nro for update;
             
             --Genero nuevo vale
             ls_nro_vale_sal := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
             
             insert into vale_mov(
                    cod_origen, nro_vale, almacen, flag_estado, fec_registro, 
                    tipo_mov,
                    cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                    flag_replicacion, observaciones, fec_produccion)
             values(
                    ls_org_vale, ls_nro_vale_sal, lc_reg.almacen_org, '1', ld_fec_registro, 
                    PKG_PRODUCCION.is_oper_sal_trans_int,
                    asi_usuario, ls_nom_receptor, 'PP', ls_parte_transf,
                    '1', ls_nom_receptor, trunc(ld_fec_registro));
             
             --Genero Vale de Ingreso
             ln_ult_nro := ln_ult_nro + 1;
             ls_nro_vale_ing := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
             
             insert into vale_mov(
                    cod_origen, nro_vale, almacen, flag_estado, fec_registro, 
                    tipo_mov,
                    cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                    flag_replicacion, observaciones, fec_produccion)
             values(
                    ls_org_vale, ls_nro_vale_ing, lc_reg.almacen_org, '1', ld_fec_registro, 
                    PKG_PRODUCCION.is_oper_ing_trans_int,
                    asi_usuario, ls_nom_receptor, 'PP', ls_parte_transf,
                    '1', ls_nom_receptor, trunc(ld_fec_registro));
             
             -- Actualizo el numerador
             update num_vale_mov n
                set n.ult_nro = ln_ult_nro + 1
               where n.origen = ls_org_nro;
             
             -- Inserto el detalle del Parte de Transferencia
             ln_item := 1;
             for lc_detalle in c_detalle(lc_reg.nro_pallet,
                                        lc_reg.anaquel,
                                        lc_reg.fila,
                                        lc_reg.columna) loop
                 
                 -- Inserto el ingreso primero
                 if lc_detalle.saldo_total_und2 = 0 and lc_detalle.flag_und2 = '1' then
                    ln_cant_proce_und2 := lc_detalle.saldo_total_und1 * lc_detalle.factor_conv_und;
                 else
                    ln_cant_proce_und2 := lc_detalle.saldo_total_und2;
                 end if; 
                  
                 if lc_detalle.saldo_total_und1 = 0 or lc_detalle.importe = 0 then
                    ln_precio_unit := 1;
                 else
                    ln_precio_unit := lc_detalle.importe / lc_detalle.saldo_total_und1;
                 end if;
                  
                 insert into articulo_mov(
                        cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, 
                        precio_unit, 
                        cod_moneda, 
                        cant_proc_und2, nro_lote, nro_pallet, cus, 
                        anaquel, fila, columna)
                 values(
                        ls_org_vale, ls_nro_Vale_ing, '1', lc_detalle.cod_art, lc_detalle.saldo_total_und1, 
                        ln_precio_unit, 
                        PKG_LOGISTICA.is_soles,
                        ln_cant_proce_und2, lc_detalle.nro_lote, lc_detalle.nro_pallet, lc_detalle.cus,
                        lc_reg.anaquel_dst, lc_reg.fila_dst, lc_reg.columna_dst);
                 
                 -- Ubico el pk de articulo_mov
                 select cod_origen, nro_mov
                   into ls_org_am_ing, ln_nro_am_ing
                   from (select am.cod_origen, am.nro_mov
                           from articulo_mov am
                          where am.nro_vale   = ls_nro_Vale_ing
                            and am.cus        = lc_detalle.cus
                            and am.cod_art    = lc_detalle.cod_art
                         order by am.nro_mov desc) s
                  where rownum        = 1;
                 
                 select count(*)
                   into ln_count
                   from templa_saldo t
                  where trim(t.cod_templa)   = trim(lc_detalle.nro_lote)
                    and t.cod_art    = lc_detalle.cod_art
                    and t.almacen    = lc_reg.almacen_org;
                 
                 if ln_count > 0 then
                    select t.saldo, t.saldo_und2
                      into ln_Saldo_total_und1, ln_Saldo_total_und2
                      from templa_saldo t
                     where trim(t.cod_templa)   = trim(lc_detalle.nro_lote)
                       and t.cod_art    = lc_detalle.cod_art
                       and t.almacen    = lc_reg.almacen_org;
                 else
                    ln_Saldo_total_und1 := 0.0;
                    ln_Saldo_total_und2 := 0.0;
                 end if;
                 
                 if ln_saldo_total_und1 < lc_detalle.saldo_total_und1 then
                    ln_saldo_total_und1 := lc_detalle.saldo_total_und1;
                 end if;
                 
                 if ln_saldo_total_und2 < lc_detalle.saldo_total_und2 then
                    ln_saldo_total_und2 := lc_detalle.saldo_total_und2;
                 end if;
                 
                 
                 if ln_count = 0 then
                    insert into templa_saldo(
                           cod_templa, cod_art, saldo, saldo_und2, almacen)
                    values(
                           lc_detalle.nro_lote, lc_detalle.cod_art, ln_saldo_total_und1,
                           ln_saldo_total_und2, lc_reg.almacen_org);
                 else
                    update templa_saldo t
                       set t.saldo = ln_saldo_total_und1,
                           t.saldo_und2 = ln_saldo_total_und2
                     where t.cod_templa   = lc_detalle.nro_lote
                       and t.cod_art    = lc_detalle.cod_art
                       and t.almacen    = lc_reg.almacen_org; 
                 end if;

                 -- Valido si hay stock para la salida
                 select count(*)
                   into ln_count
                   from articulo_almacen_cus t
                  where t.almacen    = lc_reg.almacen_org
                    and t.cod_art    = lc_detalle.cod_art
                    and t.nro_lote   = lc_detalle.nro_lote
                    and t.nro_pallet = lc_detalle.nro_pallet
                    and t.cus        = lc_detalle.cus
                    and t.anaquel    = lc_reg.anaquel
                    and t.fila       = lc_reg.fila
                    and t.columna    = lc_reg.columna;
                 
                 if ln_count = 0 then
                    insert into articulo_almacen_cus(
                           almacen, cod_art, nro_lote, nro_pallet, anaquel, fila, columna,
                           cus, saldo_und, saldo_und2)
                    values(
                           lc_reg.almacen_org, lc_detalle.cod_art, lc_detalle.nro_lote, lc_detalle.nro_pallet,
                           lc_reg.anaquel, lc_reg.fila, lc_reg.columna,
                           lc_detalle.cus,
                           lc_detalle.saldo_total_und1,
                           lc_Detalle.saldo_total_und2);
                 end if;
                 
                 -- Valido si hay stock para la salida
                 select count(*)
                   into ln_count
                   from articulo_almacen_pallet t
                  where t.almacen    = lc_reg.almacen_org
                    and t.cod_art    = lc_detalle.cod_art
                    and t.nro_pallet = lc_detalle.nro_pallet
                    and t.anaquel    = lc_reg.anaquel
                    and t.fila       = lc_reg.fila
                    and t.columna    = lc_reg.columna;
                 
                 if ln_count = 0 then
                    insert into articulo_almacen_pallet(
                           almacen, cod_art, nro_pallet, anaquel, fila, columna,
                           saldo_und, saldo_und2)
                    values(
                           lc_reg.almacen_org, lc_detalle.cod_art, lc_detalle.nro_pallet,
                           lc_reg.anaquel, lc_reg.fila, lc_reg.columna,
                           lc_detalle.saldo_total_und1,
                           lc_Detalle.saldo_total_und2);
                 end if;
                    
                 -- Ahora la salida
                 insert into articulo_mov(
                        cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, 
                        precio_unit, 
                        cod_moneda, 
                        cant_proc_und2, nro_lote, nro_pallet, cus, 
                        anaquel, fila, columna)
                 values(
                        ls_org_vale, ls_nro_Vale_sal, '1', lc_detalle.cod_art, lc_detalle.saldo_total_und1, 
                        ln_precio_unit, 
                        PKG_LOGISTICA.is_soles,
                        ln_cant_proce_und2, lc_detalle.nro_lote, lc_detalle.nro_pallet, lc_detalle.cus,
                        lc_reg.anaquel, lc_reg.fila, lc_reg.columna);

                 -- Ubico el pk de articulo_mov
                 select cod_origen, nro_mov
                   into ls_org_am_sal, ln_nro_am_sal
                   from (select am.cod_origen, am.nro_mov
                           from articulo_mov am
                          where am.nro_vale   = ls_nro_Vale_sal
                            and am.cus        = lc_detalle.cus
                            and am.cod_art    = lc_detalle.cod_art
                         order by am.nro_mov desc) s
                  where rownum        = 1;
                                        
                 -- valido el stock si s que no es necesario
                 select count(*)
                   into ln_count
                   from articulo_almacen aa
                  where aa.almacen = lc_reg.almacen_org
                    and aa.cod_art = lc_detalle.cod_art;
                 
                 if ln_count = 0 then
                    select aa.sldo_total, aa.sldo_total_und2
                      into ln_Saldo_total_und1, ln_Saldo_total_und2
                      from articulo_almacen aa
                     where aa.almacen = lc_reg.almacen_org
                       and aa.cod_art = lc_detalle.cod_art for update;
                 else
                    ln_Saldo_total_und1 := 0;
                    ln_saldo_total_und2 := 0;
                 end if;
                 
                 if ln_saldo_total_und1 < ln_cant_proce_und1 then
                    ln_saldo_total_und1 := ln_cant_proce_und1;
                 end if;
                 
                 if ln_saldo_total_und2 < ln_cant_proce_und2 then
                    ln_saldo_total_und2 := ln_cant_proce_und2;
                 end if;
                 
                 if ln_count = 0 then
                    insert into articulo_almacen(
                           almacen, cod_art, sldo_total, sldo_total_und2)
                    values(
                           lc_reg.almacen_org, lc_detalle.cod_art, ln_saldo_total_und1, ln_saldo_total_und2);
                 else
                    update articulo_almacen aa
                       set aa.sldo_total      = ln_Saldo_total_und1,    
                           aa.sldo_total_und2 = ln_Saldo_total_und2
                     where aa.almacen = lc_reg.almacen_org
                       and aa.cod_art = lc_detalle.cod_art;
                 end if;

                 insert into tg_parte_transferencia_und(
                        nro_parte, nro_item, codigo_cu, fec_registro, cod_usr, cod_art, 
                        org_am_ing, nro_am_ing, org_am_sal, nro_am_sal)
                 values(
                        ls_parte_transf, ln_item, lc_detalle.cus, sysdate, asi_usuario, lc_detalle.cod_Art,
                        ls_org_am_ing, ln_nro_am_ing, ls_org_am_sal, ln_nro_am_sal);
                 
                 ln_item := ln_item + 1;
             end loop; 
             
             -- Proceso el parte de transferencia
             --PKG_PRODUCCION.sp_procesar_transferencia(ls_parte_transf);
            
         end if;
         
         commit;
     
     end loop;
     
     ls_org_nro := 'AX';
     for lc_reg in c_datos loop
         select al.cod_origen
           into ls_org_vale
           from almacen al
          where al.almacen = lc_reg.almacen;
          
         if lc_reg.cat_art = ls_cat_conservas then
            ln_inventario_und1 := lc_reg.nro_cajas;
            ln_inventario_und2 := lc_reg.nro_cajas * lc_reg.factor_conv_und;
         else
            ln_inventario_und2 := lc_reg.nro_cajas;
            ln_inventario_und1 := lc_reg.nro_cajas / lc_reg.factor_conv_und;
         end if;
         
         if ln_inventario_und1 > lc_reg.saldo_und1 then
            ln_cant_proce_und1 := ln_inventario_und1 - lc_reg.saldo_und1;
            ln_cant_proce_und2 := ln_cant_proce_und1 * lc_reg.factor_conv_und;
            
            ls_nom_receptor    := 'MOV ' || trim(is_ing_ajuste_inventario) || ' AUTOMATICO ' || lc_reg.almacen || ' INVENTARIO_PALLETS';
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen = lc_reg.almacen
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = is_ing_ajuste_inventario
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      ls_org_vale, ls_nro_Vale, lc_reg.almacen, '1', ld_fec_registro, 
                      is_ing_ajuste_inventario, asi_usuario,
                      ls_nom_receptor, ls_nom_receptor, trunc(adi_fecha), lc_reg.almacen);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen = lc_reg.almacen
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = is_ing_ajuste_inventario
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Obtengo el nro de CU y el nro de lote
            select count(*)
              into ln_count
              from vale_mov          vm,
                   articulo_mov      am,
                   articulo_mov_tipo amt,
                   almacen           al,
                   articulo          a
              where vm.nro_vale = am.nro_vale
                and vm.tipo_mov  = amt.tipo_mov
                and vm.almacen   = al.almacen
                and am.cod_art   = a.cod_art
                and am.flag_estado <> '0'
                and vm.flag_estado <> '0'
                and am.nro_pallet is not null
                and vm.almacen     = asi_almacen
                and am.nro_pallet  = lc_reg.nro_pallet
                and am.anaquel     = lc_reg.anaquel
                and am.fila        = lc_reg.fila
                and am.columna     = lc_reg.columna
                and trunc(vm.fec_registro) <= trunc(adi_fecha);
            
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from tg_parte_empaque te,
                      tg_parte_empaque_und teu
                where te.nro_parte = teu.nro_parte
                  and te.nro_pallet = lc_reg.nro_pallet;
                  
               if ln_count = 0 then
                  RAISE_APPLICATION_ERROR(-20000, 'No hay parte de Empaque para el Pallet ' || lc_reg.nro_pallet || ', por favor corrija!');
               end if;
               
               select te.nro_trazabilidad, teu.codigo_cu
                 into ls_nro_lote, ls_codigo_cu
                 from tg_parte_empaque te,
                      tg_parte_empaque_und teu
                where te.nro_parte = teu.nro_parte
                  and te.nro_pallet = lc_reg.nro_pallet;
            else
               select am.nro_lote,
                      am.cus
                 into ls_nro_lote, ls_codigo_cu
                 from vale_mov          vm,
                      articulo_mov      am,
                      articulo_mov_tipo amt,
                      almacen           al,
                      articulo          a
                 where vm.nro_vale = am.nro_vale
                   and vm.tipo_mov  = amt.tipo_mov
                   and vm.almacen   = al.almacen
                   and am.cod_art   = a.cod_art
                   and am.flag_estado <> '0'
                   and vm.flag_estado <> '0'
                   and am.nro_pallet is not null
                   and vm.almacen     = asi_almacen
                   and am.nro_pallet  = lc_reg.nro_pallet
                   and am.anaquel     = lc_reg.anaquel
                   and am.fila        = lc_reg.fila
                   and am.columna     = lc_reg.columna
                   and trunc(vm.fec_registro) <= trunc(adi_fecha)
                group by am.nro_lote, am.cus;   
            end if;
             
            -- Obtengo el costo_prom_soles
            select count(*)
              into ln_count
              from articulo_almacen aa
             where aa.cod_Art = lc_reg.cod_Art
               and aa.almacen = lc_reg.almacen;
            
            if ln_count = 0 then
               select aa.costo_prom_sol
                 into ln_precio_unit
                 from articulo_almacen aa
                where aa.cod_Art = lc_reg.cod_Art
                  and aa.almacen = lc_reg.almacen;
            else
               ln_precio_unit := 0;
            end if;

            /*select count(*)
              into ln_count
              from articulo_mov am
             where am.nro_vale   = ls_nro_Vale
               and am.cod_art    = lc_reg.cod_art
               and am.nro_pallet = lc_reg.nro_pallet
               and am.nro_lote   = ls_nro_lote
               and am.cus        = ls_codigo_cu
               and am.anaquel    = lc_reg.anaquel
               and am.fila       = lc_reg.fila
               and am.columna    = lc_reg.columna;
            
            if ln_count = 0 then*/
               insert into articulo_mov(
                      cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                      cod_moneda, 
                      cant_proc_und2, nro_lote, nro_pallet, cus, 
                      anaquel, fila, columna)
               values(
                      ls_org_vale, ls_nro_vale, '1', lc_reg.cod_art, ln_cant_proce_und1, ln_precio_unit, 
                      PKG_LOGISTICA.is_soles,
                      ln_cant_proce_und2, ls_nro_lote, lc_reg.nro_pallet, ls_codigo_cu,
                      lc_reg.anaquel, lc_reg.fila, lc_reg.columna);
            --end if;
           
         else   
           
            ln_cant_proce_und1 := lc_reg.saldo_und1 - ln_inventario_und1;
            ln_cant_proce_und2 := ln_cant_proce_und1 * lc_reg.factor_conv_und;
            
            ls_nom_receptor    := 'MOV ' || trim(is_sal_ajuste_inventario) || ' AUTOMATICO ' || lc_reg.almacen || ' INVENTARIO_PALLETS';
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen = lc_reg.almacen
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = is_sal_ajuste_inventario
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(to_char(ln_ult_nro, '00000000'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      ls_org_vale, ls_nro_Vale, lc_reg.almacen, '1', ld_fec_registro, 
                      is_sal_ajuste_inventario, asi_usuario,
                      ls_nom_receptor, ls_nom_receptor, trunc(adi_fecha), lc_reg.almacen);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen = lc_reg.almacen
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = is_sal_ajuste_inventario
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Obtengo el nro de CU y el nro de lote
            select count(*)
              into ln_count
              from vale_mov          vm,
                   articulo_mov      am,
                   articulo_mov_tipo amt,
                   almacen           al,
                   articulo          a
              where vm.nro_vale = am.nro_vale
                and vm.tipo_mov  = amt.tipo_mov
                and vm.almacen   = al.almacen
                and am.cod_art   = a.cod_art
                and am.flag_estado <> '0'
                and vm.flag_estado <> '0'
                and am.nro_pallet is not null
                and vm.almacen     = asi_almacen
                and am.nro_pallet  = lc_reg.nro_pallet
                and am.anaquel     = lc_reg.anaquel
                and am.fila        = lc_reg.fila
                and am.columna     = lc_reg.columna
                and trunc(vm.fec_registro) <= trunc(adi_fecha);
            
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from tg_parte_empaque te,
                      tg_parte_empaque_und teu
                where te.nro_parte = teu.nro_parte
                  and te.nro_pallet = lc_reg.nro_pallet;
                  
               if ln_count = 0 then
                  RAISE_APPLICATION_ERROR(-20000, 'No hay parte de Empaque para el Pallet ' || lc_reg.nro_pallet || ', por favor corrija!');
               end if;
               
               select te.nro_trazabilidad, teu.codigo_cu
                 into ls_nro_lote, ls_codigo_cu
                 from tg_parte_empaque te,
                      tg_parte_empaque_und teu
                where te.nro_parte = teu.nro_parte
                  and te.nro_pallet = lc_reg.nro_pallet;
            else
            
               -- Obtengo el nro de CU y el nro de lote
               select am.nro_lote,
                      am.cus
                 into ls_nro_lote, ls_codigo_cu
                 from vale_mov          vm,
                      articulo_mov      am,
                      articulo_mov_tipo amt,
                      almacen           al,
                      articulo          a
                 where vm.nro_vale = am.nro_vale
                   and vm.tipo_mov  = amt.tipo_mov
                   and vm.almacen   = al.almacen
                   and am.cod_art   = a.cod_art
                   and am.flag_estado <> '0'
                   and vm.flag_estado <> '0'
                   and am.nro_pallet is not null
                   and vm.almacen     = asi_almacen
                   and am.nro_pallet  = lc_reg.nro_pallet
                   and am.anaquel     = lc_reg.anaquel
                   and am.fila        = lc_reg.fila
                   and am.columna     = lc_reg.columna
                   and trunc(vm.fec_registro) <= trunc(adi_fecha)
                group by am.nro_lote, am.cus;
            end if;
            
            -- Obtengo el costo_prom_soles
            select count(*)
              into ln_count
              from articulo_almacen aa
             where aa.cod_Art = lc_reg.cod_Art
               and aa.almacen = lc_reg.almacen;
            
            if ln_count = 0 then
               select aa.costo_prom_sol, aa.sldo_total, aa.sldo_total_und2
                 into ln_precio_unit, ln_Saldo_total_und1, ln_Saldo_total_und2
                 from articulo_almacen aa
                where aa.cod_Art = lc_reg.cod_Art
                  and aa.almacen = lc_reg.almacen;
            else
               ln_precio_unit := 0;
               ln_Saldo_total_und1 := 0;
               ln_Saldo_total_und2 := 0;
            end if;
            
            if ln_Saldo_total_und1 < ln_cant_proce_und1 then
               ln_Saldo_total_und1 := ln_cant_proce_und1;
            end if;
            
            if ln_Saldo_total_und2 < ln_cant_proce_und2 then
               ln_Saldo_total_und2 := ln_cant_proce_und2;
            end if;
            
            if ln_count = 0 then
               insert into articulo_almacen(cod_art, almacen, sldo_total, sldo_total_und2)
               values(lc_reg.cod_Art, lc_reg.almacen, ln_saldo_total_und1, ln_Saldo_total_und2);
            else
               update articulo_almacen aa
                  set aa.sldo_total = ln_Saldo_total_und1,
                      aa.sldo_total_und2 = ln_Saldo_total_und2
                where aa.cod_Art = lc_reg.cod_Art
                  and aa.almacen = lc_reg.almacen;
            end if;

            /*select count(*)
              into ln_count
              from articulo_mov am
             where am.nro_vale   = ls_nro_Vale
               and am.cod_art    = lc_reg.cod_art
               and am.nro_pallet = lc_reg.nro_pallet
               and am.nro_lote   = ls_nro_lote
               and am.cus        = ls_codigo_cu
               and am.anaquel    = lc_reg.anaquel
               and am.fila       = lc_reg.fila
               and am.columna    = lc_reg.columna;
            
            if ln_count = 0 then*/
               insert into articulo_mov(
                      cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                      cod_moneda, 
                      cant_proc_und2, nro_lote, nro_pallet, cus, 
                      anaquel, fila, columna)
               values(
                      ls_org_vale, ls_nro_vale, '1', lc_reg.cod_art, ln_cant_proce_und1, ln_precio_unit, 
                      PKG_LOGISTICA.is_soles,
                      ln_cant_proce_und2, ls_nro_lote, lc_reg.nro_pallet, ls_codigo_cu,
                      lc_reg.anaquel, lc_reg.fila, lc_reg.columna);
            --end if;
           
         end if;
     
         commit;
     end loop;
     
     commit;
  end;  
  
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
   ) is
     --Vale_mov
     ls_tipo_mov               vale_mov.tipo_mov%TYPE;
     ls_nro_Vale               vale_mov.nro_vale%TYPE;
     ls_nom_receptor           vale_mov.nom_receptor%TYPE;
     ld_fec_registro           vale_mov.fec_registro%TYPE;
     ls_fec_registro           varchar2(20);
     
     -- Articulo_mov
     ls_matriz                 articulo_mov.matriz%TYPE;
     ls_cencos                 articulo_mov.cencos%TYPE;
     ls_cnta_prsp              articulo_mov.cnta_prsp%TYPE;
     ln_cant_proc_und1         articulo_mov.cant_procesada%TYPE;
     ln_cant_proc_und2         articulo_mov.cant_proc_und2%TYPE;
     
     -- Articulo_almacen
     ln_Saldo_und1             articulo_almacen.sldo_total%TYPE;
     ln_saldo_und2             articulo_almacen.sldo_total_und2%TYPE;
     
     
     -- Variables;
     ls_org_nro                origen.cod_origen%TYPE;
     ln_count                  number;
     ln_ult_nro                num_vale_mov.ult_nro%TYPE;
     ls_flag_estado            articulo.flag_estado%TYPE;
     
     cursor c_datos is
       select vm.almacen,
              al.cod_origen as org_almacen,
              al.desc_almacen,
              am.cod_art,
              a.desc_art,
              a.und,
              a.sub_cat_art,
              a.flag_und2,
              trim(a.cod_clase) as cod_clase,
              case
                 when a.flag_und2 = '1' then a.factor_conv_und 
                 else 0
              end as factor_conv_und,
              a.flag_cntrl_lote,
              sum(am.cant_procesada * amt.factor_sldo_total) as cant_und1,
              a.und2,
              sum(am.cant_proc_und2 * amt.factor_sldo_total) as cant_und2,
              case
                 when a.flag_und2 = '1' then
                    case
                       when trim(a.cod_clase) in ('01') and a.und2 in ('LTA', 'SAC', 'BLS', 'BOL', 'BLO', 'FCO') then
                          round(sum(am.cant_procesada * amt.factor_sldo_total) * a.factor_conv_und,0)
                       else
                          round(sum(am.cant_procesada * amt.factor_sldo_total) * a.factor_conv_und,8)
                    end
                 else
                    0
              end as cant_real_und2,
              round(sum( case when amt.flag_ajuste_valorizacion = '1' then am.precio_unit else am.cant_procesada * am.precio_unit end * amt.factor_sldo_total),12) as importe
         from vale_mov vm,
              articulo_mov am,
              articulo_mov_tipo amt,
              almacen           al,
              articulo          a
        where vm.nro_vale = am.nro_vale
          and vm.tipo_mov = amt.tipo_mov
          and am.cod_Art  = a.cod_art
          and vm.flag_estado <> '0'
          and am.flag_estado <> '0'
          and vm.almacen     = al.almacen
          --and am.cod_art     = '101213.00028'
          --and al.flag_virtual = '1'
          and to_char(vm.fec_registro, 'yyyymm') <= trim(to_Char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))
       group by vm.almacen,
                al.cod_origen,
                a.factor_conv_und,
                al.desc_almacen,
                am.cod_art,
                a.desc_art,
                a.und,
                a.und2,
                a.flag_und2,
                trim(a.cod_clase),
                a.sub_cat_art,
                a.flag_cntrl_lote,
                case
                   when a.flag_und2 = '1' then a.factor_conv_und 
                   else 0
                end;
   
   begin
     ls_org_nro := 'AJ';
     
     -- Primero ajusto la cantidad para que sea cero
     for lc_reg in c_datos loop
         if lc_reg.cant_und1 < 0 or (lc_reg.cant_und1 <> 0 and trunc(lc_reg.cant_und1, 4) = 0) or
            (lc_reg.cod_clase in ('01') and lc_reg.und2 is not null and 
             lc_reg.und2 in ('LTA', 'SAC', 'BLS', 'BOL', 'FCO') and 
             round(abs(lc_reg.cant_und2),0) = 0) then
            
            ls_fec_registro := to_char(PKG_UTILITY.of_last_day(ani_year, ani_mes), 'dd/mm/yyyy') || ' 23:59:59';
            ld_fec_registro := to_date(ls_fec_registro, 'dd/mm/yyyy hh24:mi:ss');
            
            -- Tipo Mov Ingreso por Ajuste de Inventario
            if lc_reg.cant_und1 < 0 then
               ls_tipo_mov := PKG_ALMACEN.is_ing_ajuste_inventario;
            else
               ls_tipo_mov := PKG_ALMACEN.is_sal_ajuste_inventario;
            end if;
            
            -- Descripcion
            ls_nom_receptor    := 'PASO 1. AJUSTE AUT. CANTIDAD ' || trim(ls_tipo_mov) || '. ALMACEN: ' || 
                                  lc_reg.org_almacen;
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen      = lc_reg.almacen
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = ls_tipo_mov
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(lpad(PKG_UTILITY.of_convert_to_hex(ln_ult_nro), 8, '0'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      lc_reg.org_almacen, ls_nro_Vale, lc_reg.almacen, '1', ld_fec_registro, 
                      ls_tipo_mov, asi_usuario,
                      ls_nom_receptor, ls_nom_receptor, trunc(ld_fec_registro), lc_reg.almacen);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen      = lc_reg.almacen
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = ls_tipo_mov
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Obtengo el centro de costos y la cuenta presupuestal
            if PKG_ALMACEN.of_get_cencos_cnta_prsp(lc_reg.cod_art, ls_tipo_mov, ls_cencos, ls_cnta_prsp) <> 1 then 
               RAISE_APPLICATION_ERROR(-20000, 'Error al ejecutar la funcion PKG_ALMACEN.of_get_cencos_cnta_prsp()');
            end if;
            
            -- Ahora insert el ajuste
            ls_matriz := usf_alm_matriz_contable(ls_tipo_mov, null, null, lc_reg.sub_cat_art);
            
            ln_cant_proc_und1 := abs(lc_reg.cant_und1);
            ln_cant_proc_und2 := abs(lc_reg.cant_und1) * lc_reg.factor_conv_und;
            
            if lc_reg.flag_cntrl_lote = '1' then
               update articulo a
                  set a.flag_cntrl_lote = '0'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            if lc_reg.flag_und2 = '1' and ln_cant_proc_und2 = 0 then
               update articulo a
                  set a.flag_und2 = '0'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            select flag_estado
               into ls_flag_estado
               from articulo a
              where a.cod_art = lc_reg.cod_art;
            
            if ls_flag_estado = '0' then
               update articulo a
                  set a.flag_estado = '1'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            
            -- Si es una salida valido que tanto la cantidad proc und1 y cant_proc_und2 tengan saldo
            if ls_tipo_mov like 'S%' then
               select count(*)
                 into ln_count
                 from articulo_almacen aa
                where aa.cod_art = lc_reg.cod_art
                  and aa.almacen = lc_reg.almacen;
               
               if ln_count = 0 then
                  ln_saldo_und1 := 0;
                  ln_saldo_und2 := 0;
               else
                  select aa.sldo_total, aa.sldo_total_und2
                    into ln_Saldo_und1, ln_saldo_und2
                    from articulo_almacen aa
                   where aa.cod_art = lc_reg.cod_art
                     and aa.almacen = lc_reg.almacen;
               end if;
               
               if ln_saldo_und1 < ln_cant_proc_und1 then
                  ln_saldo_und1 := ln_cant_proc_und1;
               end if;
               
               if ln_saldo_und2 < ln_cant_proc_und2 then
                  ln_saldo_und2 := ln_cant_proc_und2;
               end if;
               
               update articulo_almacen aa
                  set aa.sldo_total = ln_Saldo_und1,
                      aa.sldo_total_und2 = ln_saldo_und2
                where aa.cod_art         = lc_reg.cod_art
                  and aa.almacen         = lc_reg.almacen;
               
               if SQL%NOTFOUND then
                  insert into articulo_almacen(
                         cod_art, almacen, sldo_total, sldo_total_und2)
                  values(
                         lc_reg.cod_Art, lc_reg.almacen, ln_Saldo_und1, ln_saldo_und2);
               end if;
            end if;
            
            insert into articulo_mov(
                  cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                  cod_moneda, 
                  cant_proc_und2, cencos, cnta_prsp, matriz)
            values(
                  lc_reg.org_almacen, ls_nro_vale, '1', lc_reg.cod_art, ln_cant_proc_und1, 
                  0, 
                  PKG_LOGISTICA.is_soles,
                  ln_cant_proc_und2, ls_cencos, ls_cnta_prsp, ls_matriz);
            
            if lc_reg.flag_cntrl_lote = '1' then
               update articulo a
                  set a.flag_cntrl_lote = '1'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            if lc_reg.flag_und2 = '1' and ln_cant_proc_und2 = 0 then
               update articulo a
                  set a.flag_und2 = '1'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            if ls_flag_estado = '0' then
               update articulo a
                  set a.flag_estado = '0'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
         end if;
     end loop;
     
     commit;
     
     -- Segundo ajusto la cantidad und2 si es que es diferente
     for lc_reg in c_datos loop
         if lc_reg.cant_und2 <> lc_reg.cant_real_und2 then
            if lc_reg.cant_und2 > lc_reg.cant_real_und2 then
               ls_tipo_mov := PKG_ALMACEN.is_sal_ajuste_inventario;
            else
               ls_tipo_mov := PKG_ALMACEN.is_ing_ajuste_inventario;
            end if;
            
            -- Tipo Mov Ingreso por Ajuste de Inventario
            ls_fec_registro := to_char(PKG_UTILITY.of_last_day(ani_year, ani_mes), 'dd/mm/yyyy') || ' 23:59:59';
            ld_fec_registro := to_date(ls_fec_registro, 'dd/mm/yyyy hh24:mi:ss');
            
            -- Descripcion
            ls_nom_receptor    := 'PASO 2. AJUSTE AUT. CANTIDAD UND2 ' || trim(ls_tipo_mov) || '. ALMACEN: ' || 
                                  lc_reg.org_almacen;
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen      = lc_reg.almacen
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = ls_tipo_mov
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(lpad(PKG_UTILITY.of_convert_to_hex(ln_ult_nro), 8, '0'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      lc_reg.org_almacen, ls_nro_Vale, lc_reg.almacen, '1', ld_fec_registro, 
                      ls_tipo_mov, asi_usuario,
                      ls_nom_receptor, ls_nom_receptor, trunc(ld_fec_registro), lc_reg.almacen);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen      = lc_reg.almacen
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = ls_tipo_mov
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Obtengo el centro de costos y la cuenta presupuestal
            if PKG_ALMACEN.of_get_cencos_cnta_prsp(lc_reg.cod_art, ls_tipo_mov, ls_cencos, ls_cnta_prsp) <> 1 then 
               RAISE_APPLICATION_ERROR(-20000, 'Error al ejecutar la funcion PKG_ALMACEN.of_get_cencos_cnta_prsp()');
            end if;
            
            -- Matriz Contable
            ls_matriz := usf_alm_matriz_contable(ls_tipo_mov, ls_Cencos, ls_cnta_prsp, lc_reg.sub_cat_art);
            
            -- Ahora insert el ajuste
            if lc_reg.flag_und2 = '1' then
               update articulo a
                  set a.flag_und2 = '0'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            if lc_reg.flag_cntrl_lote = '1' then
               update articulo a
                  set a.flag_cntrl_lote = '0'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            update articulo_mov_tipo amt
               set amt.flag_ajuste_valorizacion  = '1'
             where amt.tipo_mov = ls_tipo_mov;
             
            select flag_estado
               into ls_flag_estado
               from articulo a
              where a.cod_art = lc_reg.cod_art;
            
            if ls_flag_estado = '0' then
               update articulo a
                  set a.flag_estado = '1'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            ln_cant_proc_und1 := 0;
            ln_cant_proc_und2 := abs(lc_reg.cant_und2 - lc_reg.cant_real_und2);
            
            -- Si es una salida valido que tanto la cantidad proc und1 y cant_proc_und2 tengan saldo
            if ls_tipo_mov like 'S%' then
               select count(*)
                 into ln_count
                 from articulo_almacen aa
                where aa.cod_art = lc_reg.cod_art
                  and aa.almacen = lc_reg.almacen;
               
               if ln_count = 0 then
                  ln_saldo_und1 := 0;
                  ln_saldo_und2 := 0;
               else
                  select aa.sldo_total, aa.sldo_total_und2
                    into ln_Saldo_und1, ln_saldo_und2
                    from articulo_almacen aa
                   where aa.cod_art = lc_reg.cod_art
                     and aa.almacen = lc_reg.almacen;
               end if;
               
               if ln_saldo_und1 < ln_cant_proc_und1 then
                  ln_saldo_und1 := ln_cant_proc_und1;
               end if;
               
               if ln_saldo_und2 < ln_cant_proc_und2 then
                  ln_saldo_und2 := ln_cant_proc_und2;
               end if;
               
               update articulo_almacen aa
                  set aa.sldo_total = ln_Saldo_und1,
                      aa.sldo_total_und2 = ln_saldo_und2
                where aa.cod_art         = lc_reg.cod_art
                  and aa.almacen         = lc_reg.almacen;
               
               if SQL%NOTFOUND then
                  insert into articulo_almacen(
                         cod_art, almacen, sldo_total, sldo_total_und2)
                  values(
                         lc_reg.cod_Art, lc_reg.almacen, ln_Saldo_und1, ln_saldo_und2);
               end if;
            end if;
            
            insert into articulo_mov(
                  cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                  cod_moneda, 
                  cant_proc_und2, cencos, cnta_prsp, matriz)
            values(
                  lc_reg.org_almacen, ls_nro_vale, '1', lc_reg.cod_art, 0, 
                  0, 
                  PKG_LOGISTICA.is_soles,
                  ln_cant_proc_und2, ls_cencos, ls_cnta_prsp, ls_matriz);
                  
            if lc_reg.flag_und2 = '1' then
               update articulo a
                  set a.flag_und2 = '1'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            if lc_reg.flag_cntrl_lote = '1' then
               update articulo a
                  set a.flag_cntrl_lote = '1'
                where a.cod_art = lc_reg.cod_art;
            end if;
            
            update articulo_mov_tipo amt
               set amt.flag_ajuste_valorizacion  = '0'
             where amt.tipo_mov = ls_tipo_mov;
             
            if ls_flag_estado = '0' then
               update articulo a
                  set a.flag_estado = '0'
                where a.cod_art = lc_reg.cod_art;
            end if;
                  
         end if;
     end loop;     
     
     commit;

     -- Tercer ajusto la cantidad und2 si es que es diferente
     for lc_reg in c_datos loop
         if lc_reg.cant_und1 = 0 and lc_reg.importe <> 0 then
           
            if lc_reg.importe < 0 then
               ls_tipo_mov := PKG_ALMACEN.is_ing_ajuste_valorizacion;
            else
               ls_tipo_mov := PKG_ALMACEN.is_sal_ajuste_valorizacion;
            end if;
            
            -- Tipo Mov Ingreso por Ajuste de Inventario
            ls_fec_registro := to_char(PKG_UTILITY.of_last_day(ani_year, ani_mes), 'dd/mm/yyyy') || ' 23:59:59';
            ld_fec_registro := to_date(ls_fec_registro, 'dd/mm/yyyy hh24:mi:ss');
            
            -- Descripcion
            ls_nom_receptor    := 'PASO 3. AJUSTE AUT. VALORIZACION ' || trim(ls_tipo_mov) || '. ALMACEN: ' || 
                                  lc_reg.org_almacen;
            
            -- Inserto el vale de ajuste por inventario
            select count(*)
              into ln_count 
              from vale_mov vm
             where vm.almacen      = lc_reg.almacen
               and vm.fec_registro = ld_fec_registro
               and vm.tipo_mov     = ls_tipo_mov
               and vm.nom_receptor = ls_nom_receptor
               and vm.flag_estado  <> '0';
            
            -- Inserto el movimiento de almacen de ajuste
            if ln_count = 0 then
               select count(*)
                 into ln_count
                 from num_vale_mov n
                where n.origen = ls_org_nro;
               
               if ln_count = 0 then
                  insert into num_vale_mov(
                         ult_nro, origen)
                  values(
                         1, ls_org_nro);
               end if;
               
               select n.ult_nro
                 into ln_ult_nro
                 from num_vale_mov n
                where n.origen = ls_org_nro for update;
                
               ls_nro_Vale := trim(ls_org_nro) || trim(lpad(PKG_UTILITY.of_convert_to_hex(ln_ult_nro), 8, '0'));
               
               update num_vale_mov n
                  set n.ult_nro = ln_ult_nro + 1
                where n.origen = ls_org_nro;
              
               insert into vale_mov(
                      cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr,
                      nom_receptor, observaciones, fec_produccion, almacen_old)
               values(
                      lc_reg.org_almacen, ls_nro_Vale, lc_reg.almacen, '1', ld_fec_registro, 
                      ls_tipo_mov, asi_usuario,
                      ls_nom_receptor, ls_nom_receptor, trunc(ld_fec_registro), lc_reg.almacen);
            else
               select vm.nro_vale
                 into ls_nro_Vale
                 from vale_mov vm
                where vm.almacen      = lc_reg.almacen
                  and vm.fec_registro = ld_fec_registro
                  and vm.tipo_mov     = ls_tipo_mov
                  and vm.nom_receptor = ls_nom_receptor
                  and vm.flag_estado  <> '0';
            end if;
            
            -- Obtengo el centro de costos y la cuenta presupuestal
            if PKG_ALMACEN.of_get_cencos_cnta_prsp(lc_reg.cod_art, ls_tipo_mov, ls_cencos, ls_cnta_prsp) <> 1 then 
               RAISE_APPLICATION_ERROR(-20000, 'Error al ejecutar la funcion PKG_ALMACEN.of_get_cencos_cnta_prsp()');
            end if;
            
            -- Matriz Contable
            ls_matriz := usf_alm_matriz_contable(ls_tipo_mov, ls_Cencos, ls_cnta_prsp, lc_reg.sub_cat_art);
            
            -- Ahora insert el ajuste
            select flag_estado
               into ls_flag_estado
               from articulo a
              where a.cod_art = lc_reg.cod_art;
            
            if ls_flag_estado = '0' then
               update articulo a
                  set a.flag_estado = '1'
                where a.cod_art = lc_reg.cod_art;
            end if;
            

            insert into articulo_mov(
                  cod_origen, nro_vale, flag_estado, cod_art, 
                  cant_procesada, 
                  precio_unit, 
                  cod_moneda, 
                  cant_proc_und2, cencos, cnta_prsp, matriz)
            values(
                  lc_reg.org_almacen, ls_nro_vale, '1', lc_reg.cod_art, 
                  0, 
                  abs(lc_reg.importe), 
                  PKG_LOGISTICA.is_soles,
                  0, ls_cencos, ls_cnta_prsp, ls_matriz);
                  
            if ls_flag_estado = '0' then
               update articulo a
                  set a.flag_estado = '0'
                where a.cod_art = lc_reg.cod_art;
            end if;
                  
         end if;
     end loop;     
     
     commit;     
   end ;

   procedure sp_cierre_mensual(
             ani_year          in number,
             ani_mes           in number,
             asi_usuario       in usuario.cod_usr%TYPE
   ) is
     
     cursor c_datos is
       select vm.almacen,
              al.cod_origen as org_almacen,
              al.desc_almacen,
              am.cod_art,
              a.desc_art,
              a.und,
              a.sub_cat_art,
              a.flag_und2,
              trim(a.cod_clase) as cod_clase,
              case
                 when a.flag_und2 = '1' then a.factor_conv_und 
                 else 0
              end as factor_conv_und,
              a.flag_cntrl_lote,
              sum(am.cant_procesada * amt.factor_sldo_total) as cant_und1,
              a.und2,
              sum(am.cant_proc_und2 * amt.factor_sldo_total) as cant_und2,
              case
                 when a.flag_und2 = '1' then
                    case
                       when trim(a.cod_clase) in ('01') and a.und2 in ('LTA', 'SAC', 'BLS', 'BOL', 'BLO', 'FCO') then
                          round(sum(am.cant_procesada * amt.factor_sldo_total) * a.factor_conv_und,0)
                       else
                          round(sum(am.cant_procesada * amt.factor_sldo_total) * a.factor_conv_und,8)
                    end
                 else
                    0
              end as cant_real_und2,
              round(sum( case when amt.flag_ajuste_valorizacion = '1' then am.precio_unit else am.cant_procesada * am.precio_unit end * amt.factor_sldo_total),8) as importe
         from vale_mov vm,
              articulo_mov am,
              articulo_mov_tipo amt,
              almacen           al,
              articulo          a
        where vm.nro_vale = am.nro_vale
          and vm.tipo_mov = amt.tipo_mov
          and am.cod_Art  = a.cod_art
          and vm.flag_estado <> '0'
          and am.flag_estado <> '0'
          and vm.almacen     = al.almacen
          --and am.cod_art     = '101024.00002'
          --and al.flag_virtual = '1'
          and to_char(vm.fec_registro, 'yyyymm') <= trim(to_Char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))
       group by vm.almacen,
                al.cod_origen,
                a.factor_conv_und,
                al.desc_almacen,
                am.cod_art,
                a.desc_art,
                a.und,
                a.und2,
                a.flag_und2,
                trim(a.cod_clase),
                a.sub_cat_art,
                a.flag_cntrl_lote,
                case
                   when a.flag_und2 = '1' then a.factor_conv_und 
                   else 0
                end
        having sum(am.cant_procesada * amt.factor_sldo_total) <= 0;
   
   begin
      -- Valido la información antes del cierre del almacen
      for lc_reg in c_datos loop
          if lc_reg.cant_und1 < 0 then
             RAISE_APPLICATION_ERROR(-20000, 'El Articulo no puede terminar con saldo negativo en und1 antes del cierre, por favor haga el ajuste previo'
                                          || chr(13) || 'Cod Art: ' || lc_reg.cod_art || '-' || lc_reg.desc_art
                                          || chr(13) || 'Almacen: ' || lc_reg.almacen || '-' || lc_reg.desc_almacen
                                          || chr(13) || 'Stok Und1: ' || trim(to_char(lc_reg.cant_und1, '999,990.00000000'))
                                          || chr(13) || 'Und1: ' || lc_reg.und);
                                          
          end if;
          
          if lc_reg.cant_und2 is not null and lc_reg.cant_und2 <> 0 then
             RAISE_APPLICATION_ERROR(-20000, 'El Articulo no tiene Saldo en und1 pero tiene Saldo en und2, por favor haga el ajuste previo'
                                          || chr(13) || 'Cod Art: ' || lc_reg.cod_art || '-' || lc_reg.desc_art
                                          || chr(13) || 'Almacen: ' || lc_reg.almacen || '-' || lc_reg.desc_almacen
                                          || chr(13) || 'Stok Und2: ' || trim(to_char(lc_reg.cant_und2, '999,990.00000000'))
                                          || chr(13) || 'Und2: ' || lc_reg.und2);
                                          
          end if;
          
          if lc_reg.importe <> 0 then
             RAISE_APPLICATION_ERROR(-20000, 'El Articulo no tiene Saldo y termina con importe Total Diferente de CERO, por favor haga el ajuste previo'
                                          || chr(13) || 'Cod Art: ' || lc_reg.cod_art || '-' || lc_reg.desc_art
                                          || chr(13) || 'Almacen: ' || lc_reg.almacen || '-' || lc_reg.desc_almacen
                                          || chr(13) || 'Importe Total: ' || trim(to_char(lc_reg.importe, '999,990.00000000')));
                                          
          end if;

      end loop;
      -- Elimino los registros
      delete almacen_cierre_mensual aa
       where aa.ano = ani_year
         and aa.mes = ani_mes;
      
      insert into almacen_cierre_mensual(
             almacen, cod_art, ano, mes, saldo_total_und1, saldo_total_und2, importe_final, cod_usr)
      select vm.almacen,
             am.cod_art,
             ani_year,
             ani_mes,
             sum(am.cant_procesada * amt.factor_sldo_total) as cant_und1,
             sum(am.cant_proc_und2 * amt.factor_sldo_total) as cant_und2,
             round(sum( case when amt.flag_ajuste_valorizacion = '1' then am.precio_unit else am.cant_procesada * am.precio_unit end * amt.factor_sldo_total),8) as importe,
             asi_usuario
        from vale_mov vm,
             articulo_mov am,
             articulo_mov_tipo amt,
             almacen           al,
             articulo          a
       where vm.nro_vale = am.nro_vale
         and vm.tipo_mov = amt.tipo_mov
         and am.cod_Art  = a.cod_art
         and vm.flag_estado <> '0'
         and am.flag_estado <> '0'
         and vm.almacen     = al.almacen
         and to_char(vm.fec_registro, 'yyyymm') <= trim(to_Char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))
       group by vm.almacen,
                am.cod_art
       having sum(am.cant_procesada * amt.factor_sldo_total) <> 0;
       
      commit;
   
   end ;
   
   procedure sp_ajusta_matriz_cntbl(
             ani_year          in number,
             ani_mes           in number
   ) is
     cursor c_datos is
       select vm.nro_vale,
               vm.tipo_mov,
               am.cod_origen,
               am.nro_mov,
               a.sub_cat_art,
               a2.desc_sub_cat,
               am.cencos,
               am.cnta_prsp,
               cc.grp_cntbl,
               am.matriz,
               usf_alm_matriz_contable(vm.tipo_mov, am.cencos, am.cnta_prsp, a.sub_cat_art) as new_matriz
          from vale_mov vm,
               articulo_mov am,
               articulo     a,
               articulo_sub_categ a2,
               articulo_mov_tipo amt,
               centros_costo     cc
         where vm.nro_Vale       = am.nro_vale
           and am.cod_art        = a.cod_art
           and am.cencos         = cc.cencos       (+)
           and a.sub_cat_art     = a2.cod_sub_cat
           and vm.tipo_mov       = amt.tipo_mov
           and amt.flag_contabiliza = '1'
           and vm.flag_estado       <> '0'
           and am.flag_estado       <> '0'
           and nvl(am.matriz, 'XX') <> usf_alm_matriz_contable(vm.tipo_mov, am.cencos, am.cnta_prsp, a.sub_cat_art)
           and to_number(to_char(vm.fec_registro, 'yyyy')) = ani_year
           and to_number(to_char(vm.fec_registro, 'mm')) = ani_mes;
           
   begin
     for lc_reg in c_Datos loop
         update articulo_mov am
            set am.matriz = lc_reg.new_matriz
          where am.cod_origen = lc_reg.cod_origen
            and am.nro_mov    = lc_reg.nro_mov;
         
         commit;
     end loop;
   end;
    
  
begin
  -- Initialization
  is_ing_ajuste_inventario  := PKG_CONFIG.USF_GET_PARAMETER('LOG_OPER_ING_AJUSTE_INVENTARIO', 'I28');
  is_sal_ajuste_inventario  := PKG_CONFIG.USF_GET_PARAMETER('LOG_OPER_SAL_AJUSTE_INVENTARIO', 'S28');
  
  is_ing_ajuste_valorizacion := PKG_CONFIG.USF_GET_PARAMETER('LOG_OPER_ING_AJUSTE_VALORIZACION', 'I13');
  is_sal_ajuste_valorizacion := PKG_CONFIG.USF_GET_PARAMETER('LOG_OPER_SAL_AJUSTE_VALORIZACION', 'S17');
  
  
  is_ing_devolucion_vta      := PKG_CONFIG.USF_GET_PARAMETER('LOG_OPER_ING_DEVOLUCION_VTA', 'I40');
  
  select l.doc_mov_almacen
    into is_doc_alm
    from logparam l
   where l.reckey = '1';
   
  
end PKG_ALMACEN;
/

prompt
prompt Creating package body PKG_COMERCIALIZACION
prompt ==========================================
prompt
create or replace package body cantabria.PKG_COMERCIALIZACION is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  procedure sp_procesa_letras_terrenos(
            asi_nada varchar2
  ) is
  
  cursor c_datos is
      select distinct
             cc.tipo_doc,
             cc.nro_doc,
             cc.flag_estado
      from  cntas_cobrar   cc,
            cntas_cobrar_det ccd,
          (select ccd1.tipo_ref, ccd1.nro_ref, ccd1.item_ref, cc1.tipo_doc, 
                   cc1.nro_doc, 
                   PKG_FACT_ELECTRONICA.of_get_full_nro(cc1.nro_doc)  as full_nro_doc,
                   cc1.fecha_documento as fecha_emision
              from cntas_cobrar cc1,
                   cntas_cobrar_det ccd1
             where cc1.tipo_doc = ccd1.tipo_doc
               and cc1.nro_doc  = ccd1.nro_doc
               and ccd1.tipo_ref is not null
               and ccd1.nro_ref  is not null
               and cc1.flag_estado <>'0') s
      where cc.tipo_doc       = ccd.tipo_doc
        and cc.nro_doc        = ccd.nro_doc
        and ccd.tipo_doc      = s.tipo_ref 
        and ccd.nro_doc       = s.nro_ref  
        and ccd.item          = s.item_ref  (+)
        and cc.tipo_doc     = 'LTC'
        and cc.flag_estado  = '1';

  
  begin
    -- Cierro las letras ya canjeadas
    
    -- 5 = canjeadas
    -- 6 = bloqueadas
    
    for lc_reg in c_datos loop
        update cntas_cobrar cc
           set cc.flag_estado = '5'
         where cc.tipo_doc = lc_reg.tipo_doc
           and cc.nro_doc  = lc_reg.nro_doc;
    end loop;
    
    -- Bloqueo las letras que ya han pasado mas de 12 días
    update cntas_cobrar cc
       set cc.flag_estado = '6'
     where trunc(sysdate) - trunc(cc.fecha_vencimiento) > 12;
     
    commit;
  end;
  
  -- Obtengo el estado de la letra
  /*
     0. Anulado
     1. Generado
     2. Facturado - Pendiente de PAgo
     3. Pagado
     6. Bloqueado
  */
  function of_estado_letra(
            asi_tipo_doc       in cntas_cobrar.tipo_doc%TYPE,
            asi_nro_doc        in cntas_cobrar.nro_doc%TYPE
        ) 
  return varchar2 is
    ls_return varchar2(1);
    
    ld_fec_vencimiento         date;
    ln_count1                   number;
    ln_count2                   number;
    ls_tipo_doc                 cntas_cobrar.tipo_doc%TYPE;
    ls_nro_doc                  cntas_Cobrar.nro_doc%TYPE;
    ls_cliente                  cntas_cobrar.cod_relacion%TYPE;
  
  begin
    select cc.flag_estado, cc.fecha_vencimiento, cc.cod_relacion
      into ls_return, ld_fec_vencimiento, ls_cliente
      from cntas_cobrar cc
     where cc.tipo_doc = asi_tipo_doc
       and cc.nro_doc  = asi_nro_doc;
    
    if ls_return = '0' then return ls_return; end if;
    
    -- Verifico si tiene factura, ojo que no debe tener nota de credito por anulación de operacion
    select count(*)
      into ln_count1
      from cntas_cobrar cc,
           cntas_cobrar_det ccd,
           (select cc.tipo_doc, cc.nro_doc
              from cntas_cobrar cc
             where cc.flag_estado <> '0'
               and trim(cc.tipo_doc) in (select trim(column_value) from table(split(PKG_CONFIG.USF_GET_PARAMETER('DOCS_CNTAS_COBRAR', 'BVC,FAC'))))
            minus
            select ccd.tipo_ref, ccd.nro_ref
              from cntas_cobrar cc,
                   cntas_cobrar_det ccd
             where cc.tipo_doc = ccd.tipo_doc
               and cc.nro_doc  = ccd.nro_doc
               and ccd.tipo_ref is not null
               and ccd.nro_ref is not null
               and cc.motivo = 'NCC02'
               and cc.flag_estado <> '0') s1
     where cc.tipo_doc = ccd.tipo_doc
       and cc.nro_doc  = ccd.nro_doc
       and cc.tipo_doc = s1.tipo_doc
       and cc.nro_doc  = s1.nro_doc
       and ccd.tipo_ref = asi_tipo_doc
       and ccd.nro_ref  = asi_nro_doc
       and cc.flag_estado <>'0';
    
    if ln_count1 > 0 then
       -- Si tiene factura verifico si ya tiene pago
       select distinct cc.tipo_doc, cc.nro_doc
         into ls_tipo_doc, ls_nro_doc
         from cntas_cobrar cc,
              cntas_cobrar_det ccd,
              (select cc.tipo_doc, cc.nro_doc
                 from cntas_cobrar cc
                where cc.flag_estado <> '0'
                  and trim(cc.tipo_doc) in (select trim(column_value) from table(split(PKG_CONFIG.USF_GET_PARAMETER('DOCS_CNTAS_COBRAR', 'BVC,FAC'))))
               minus
               select ccd.tipo_ref, ccd.nro_ref
                 from cntas_cobrar cc,
                      cntas_cobrar_det ccd
                where cc.tipo_doc = ccd.tipo_doc
                  and cc.nro_doc  = ccd.nro_doc
                  and ccd.tipo_ref is not null
                  and ccd.nro_ref is not null
                   and cc.motivo = 'NCC02'
                  and cc.flag_estado <> '0') s1
        where cc.tipo_doc = ccd.tipo_doc
          and cc.nro_doc  = ccd.nro_doc
          and cc.tipo_doc = s1.tipo_doc
          and cc.nro_doc  = s1.nro_doc
          and ccd.tipo_ref = asi_tipo_doc
          and ccd.nro_ref  = asi_nro_doc
          and cc.flag_estado <>'0'
          and rownum = 1;
       
       select count(*)
         into ln_count2
         from caja_bancos cb,
              caja_bancos_det cbd
        where cb.origen = cbd.origen
          and cb.nro_registro = cbd.nro_registro
          and cbd.cod_relacion  = ls_cliente
          and cbd.tipo_doc    = ls_tipo_doc
          and cbd.nro_doc     = ls_nro_doc
          and cb.flag_estado  <> '0';
       
       if ln_count2 > 0 then
          return '3';  -- Pagado
       end if; 
    end if;
    
    -- Si ya pasaron 12 días, sin pagar entonces la letra esta bloqueada
    if trunc(sysdate) - trunc(ld_fec_vencimiento) >= 12 then
       return '6'; -- Bloqueado
    elsif ln_count1 > 0 then
       return '2'; -- Facturado
    end if;
    
    return '1'; -- Generado
    
    
  end;

  procedure sp_chg_periodo_prov(
       asi_cod_relacion     in proveedor.proveedor%TYPE,
       asi_tipo_doc         in doc_tipo.tipo_doc%TYPE,
       asi_nro_doc          in cntas_pagar.nro_doc%TYPE,
       ani_year             in cntbl_asiento.ano%TYPE,
       ani_mes              in cntbl_asiento.mes%TYPE,
       ani_nro_libro        in cntbl_libro.nro_libro%TYPE
  ) is
    
    ln_count           number;
    ln_nro_Asiento     cntbl_asiento.nro_asiento%TYPE;
    ln_year            cntbl_Asiento.Ano%TYPE;
    ln_mes             cntbl_asiento.mes%TYPE;
    ls_origen          origen.cod_origen%TYPE;
    ln_nro_libro       cntbl_Asiento.nro_libro%TYPE;
    ls_cxp_cxc         char(1);
    ln_ult_nro         cntbl_libro_mes.nro_asiento%TYPE;

  begin
    select count(*)
    into ln_count
    from cntas_pagar cp
   where cp.cod_relacion = asi_cod_relacion
     and cp.tipo_doc     = asi_tipo_doc
     and cp.nro_doc      = asi_nro_doc;
  
  if ln_count = 0 then
     select count(*)
       into ln_count
       from cntas_cobrar cc
      where cc.tipo_doc     = asi_tipo_doc
        and cc.nro_doc      = asi_nro_doc;
     
     if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Error, El documento no pertenece a cuentas por paar ni cuentas por cobrar, por favor verifique'
                                      || chr(13) || 'Cod. Relacion: ' || asi_cod_relacion
                                      || chr(13) || 'Tipo Doc: ' || asi_tipo_doc
                                      || chr(13) || 'Nro Doc: ' || asi_nro_doc );
     else
        ls_cxp_cxc := '2';
        select cc.origen, cc.ano, cc.mes, cc.nro_libro, cc.nro_asiento
          into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento
          from cntas_cobrar cc
         where cc.tipo_doc     = asi_tipo_doc
           and cc.nro_doc      = asi_nro_doc;
     end if;
  else
     ls_cxp_cxc := '1';
     
     select cp.origen, cp.ano, cp.mes, cp.nro_libro, cp.nro_asiento
       into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento
       from cntas_pagar cp
      where cp.cod_relacion = asi_cod_relacion
        and cp.tipo_doc     = asi_tipo_doc
        and cp.nro_doc      = asi_nro_doc;
  end if;
    
    if ls_origen is null or ln_year is null or ln_mes is null or ln_nro_libro is null or ln_nro_asiento is null then
       RAISE_APPLICATION_ERROR(-20000, 'Error, El documento no tiene asignado un voucher de asiento contable, por favor verifique'
                                    || chr(13) || 'Cod. Relacion: ' || asi_cod_relacion
                                    || chr(13) || 'Tipo Doc: ' || asi_tipo_doc
                                    || chr(13) || 'Nro Doc: ' || asi_nro_doc );
    end if; 
    
    if usf_cnt_cierre_cntbl(ln_year, ln_mes, 'R') = '0' then
       RAISE_APPLICATION_ERROR(-20000, 'Error, El Periodo Contable ORIGEN no esta aperturado y no acepta modificaciones, por favor coordine con Contabilidad para su apertura.'
                                    || chr(13) || 'A?o: ' || trim(to_char(ln_year, '0000'))
                                    || chr(13) || 'Mes: ' || trim(to_char(ln_mes, '00')));
    end if;
    
    if usf_cnt_cierre_cntbl(ani_year, ani_mes, 'R') = '0' then
       RAISE_APPLICATION_ERROR(-20000, 'Error, El Periodo Contable DESTINO no esta aperturado y no acepta modificaciones, por favor coordine con Contabilidad para su apertura.'
                                    || chr(13) || 'A?o: ' || trim(to_char(ani_year, '0000'))
                                    || chr(13) || 'Mes: ' || trim(to_char(ani_mes, '00')));
    end if;
    
    --Obtengo el siguiente asiento para el nuevo periodo
    select count(*)
      into ln_count
      from cntbl_libro_mes c
     where c.origen    = ls_origen
       and c.nro_libro = ani_nro_libro
       and c.ano       = ani_year
       and c.mes       = ani_mes;
    
    if ln_count = 0 then
       insert into cntbl_libro_mes(
              origen, nro_libro, ano, mes, nro_asiento)
       values(
              ls_origen, ani_nro_libro, ani_year, ani_mes, 1);
    end if;

    select c.nro_asiento
      into ln_ult_nro
      from cntbl_libro_mes c
     where c.origen    = ls_origen
       and c.nro_libro = ani_nro_libro
       and c.ano       = ani_year
       and c.mes       = ani_mes for update;
    
    loop
        select count(*)
          into ln_count
          from cntbl_asiento ca
         where ca.origen      = ls_origen
           and ca.ano         = ani_year
           and ca.mes         = ani_mes
           and ca.nro_libro   = ani_nro_libro
           and ca.nro_Asiento = ln_ult_nro;
        
        exit when ln_count = 0;
        ln_ult_nro := ln_ult_nro + 1;
    end loop;  
    
    update cntbl_libro_mes c
       set c.nro_asiento = ln_ult_nro + 1
     where c.origen    = ls_origen
       and c.nro_libro = ani_nro_libro
       and c.ano       = ani_year
       and c.mes       = ani_mes;
    
    -- cambiar el periodo completo al asiento 
    
    -- Primero genero una nueva cabecera del asiento contable
    insert into cntbl_asiento(
           origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, tipo_nota, nro_proceso, desc_glosa, fecha_cntbl, 
           fec_registro, cod_usr, flag_estado, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf)  
    select origen, ani_year, ani_mes, ani_nro_libro, ln_ult_nro, cod_moneda, tasa_cambio, tipo_nota, nro_proceso, desc_glosa, fecha_cntbl, 
           fec_registro, cod_usr, flag_estado, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf
    from cntbl_asiento ca
    where ca.origen      = ls_origen
      and ca.ano         = ln_year
      and ca.mes         = ln_mes
      and ca.nro_libro   = ln_nro_libro
      and ca.nro_asiento = ln_nro_Asiento;
    
    -- Cambio en el asiento detalle
    update cntbl_asiento_det cad
       set cad.ano           = ani_year,
           cad.mes           = ani_mes,
           cad.nro_libro     = ani_nro_libro,
           cad.nro_asiento   = ln_ult_nro
     where cad.origen      = ls_origen
       and cad.ano         = ln_year
       and cad.mes         = ln_mes
       and cad.nro_libro   = ln_nro_libro
       and cad.nro_asiento = ln_nro_Asiento;
       
    -- cambio el voucher en cntas x pagar o cntas x cobrar
    if ls_cxp_cxc = '1' then
       update cntas_pagar cp
          set cp.ano           = ani_year,
              cp.mes           = ani_mes,
              cp.nro_libro     = ani_nro_libro,
              cp.nro_asiento   = ln_ult_nro
        where cp.cod_relacion  = asi_cod_relacion
          and cp.tipo_doc      = asi_tipo_doc
          and cp.nro_doc       = asi_nro_doc;
    else
       update cntas_cobrar cc
          set cc.ano           = ani_year,
              cc.mes           = ani_mes,
              cc.nro_libro     = ani_nro_libro,
              cc.nro_asiento   = ln_ult_nro
        where cc.tipo_doc      = asi_tipo_doc
          and cc.nro_doc       = asi_nro_doc;
    end if;
    
    -- Elimino el asiento antiguo que ya no sirve
    delete cntbl_asiento_det cad
     where cad.origen      = ls_origen
       and cad.ano         = ln_year
       and cad.mes         = ln_mes
       and cad.nro_libro   = ln_nro_libro
       and cad.nro_asiento = ln_nro_Asiento;
    
       
           
  end;
  
  -- Function and procedure implementations
  function of_get_puerto_origen(as_tipo_doc cntas_cobrar.tipo_doc%TYPE, 
                                as_nro_doc  cntas_cobrar.nro_doc%TYPE
  ) return varchar2 is
    ls_Return	fl_puertos.descr_puerto%TYPE;
    ln_count  number;
  begin
    select count(*)
      into ln_count
      from cntas_cobrar         cc,
           cntas_cobrar_det     ccd,
           articulo_mov_proy    amp,
           orden_venta          ov,
           fl_puertos           fp
     where cc.tipo_doc          = ccd.tipo_doc
       and cc.nro_doc           = ccd.nro_doc
       and ccd.org_amp_ref      = amp.cod_origen  (+)
       and ccd.nro_amp_ref      = amp.nro_mov     (+)
       and amp.nro_doc          = ov.nro_ov       (+)
       and ov.puerto_org        = fp.puerto       (+)
       and cc.tipo_doc          = as_tipo_doc
       and cc.nro_doc           = as_nro_doc	;
    
    if ln_count = 0 then return ''; end if;
    
    select distinct fp.descr_puerto
      into ls_Return
      from cntas_cobrar         cc,
           cntas_cobrar_det     ccd,
           articulo_mov_proy    amp,
           orden_venta          ov,
           fl_puertos           fp
     where cc.tipo_doc          = ccd.tipo_doc
       and cc.nro_doc           = ccd.nro_doc
       and ccd.org_amp_ref      = amp.cod_origen  (+)
       and ccd.nro_amp_ref      = amp.nro_mov     (+)
       and amp.nro_doc          = ov.nro_ov       (+)
       and ov.puerto_org        = fp.puerto       (+)
       and cc.tipo_doc          = as_tipo_doc
       and cc.nro_doc           = as_nro_doc	;

  
    return NVL(ls_Return, '');
    
  end;
  
  -- Determino el puerto destino
  function of_get_puerto_destino(as_tipo_doc cntas_cobrar.tipo_doc%TYPE, 
                                 as_nro_doc  cntas_cobrar.nro_doc%TYPE
  ) return varchar2 is
    ls_Return	fl_puertos.descr_puerto%TYPE;
    ln_count  number;
  begin
    select count(*)
      into ln_count
      from cntas_cobrar         cc,
           cntas_cobrar_det     ccd,
           articulo_mov_proy    amp,
           orden_venta          ov,
           fl_puertos           fp
     where cc.tipo_doc          = ccd.tipo_doc
       and cc.nro_doc           = ccd.nro_doc
       and ccd.org_amp_ref      = amp.cod_origen  (+)
       and ccd.nro_amp_ref      = amp.nro_mov     (+)
       and amp.nro_doc          = ov.nro_ov       (+)
       and ov.puerto_dst        = fp.puerto       (+)
       and cc.tipo_doc          = as_tipo_doc
       and cc.nro_doc           = as_nro_doc	;
    
    if ln_count = 0 then return ''; end if;
    
    select distinct fp.descr_puerto
      into ls_Return
      from cntas_cobrar         cc,
           cntas_cobrar_det     ccd,
           articulo_mov_proy    amp,
           orden_venta          ov,
           fl_puertos           fp
     where cc.tipo_doc          = ccd.tipo_doc
       and cc.nro_doc           = ccd.nro_doc
       and ccd.org_amp_ref      = amp.cod_origen  (+)
       and ccd.nro_amp_ref      = amp.nro_mov     (+)
       and amp.nro_doc          = ov.nro_ov       (+)
       and ov.puerto_dst        = fp.puerto       (+)
       and cc.tipo_doc          = as_tipo_doc
       and cc.nro_doc           = as_nro_doc	;

  
    return nvl(ls_Return, '');
    
  end;
  
  -- Guias de remision por Orden de Venta
  function of_guias_remision(
           asi_nro_ov orden_venta.nro_ov%TYPE
  ) return varchar2 is
  
    ls_return varchar2(4000);
    
    cursor c_datos is
      select distinct PKG_FACT_ELECTRONICA.of_get_full_nro(gv.nro_guia) as nro_guia
        from vale_mov vm, 
             articulo_mov am,
             guia_vale    gv,
             articulo_mov_proy amp
        where vm.nro_vale = am.nro_vale
          and vm.nro_vale = gv.nro_vale  (+)
          and vm.flag_estado <> '0'
          and am.flag_estado <> '0'
          and am.origen_mov_proy  = amp.cod_origen
          and am.nro_mov_proy     = amp.nro_mov
          and amp.nro_doc         = asi_nro_ov
      order by nro_guia;
  
  begin
    ls_return := '';
    
    for lc_reg in c_datos loop
        if length(lc_reg.nro_guia) + length(ls_return) < 4000 then
           ls_return := ls_return || lc_reg.nro_guia || ', ';
        end if;
    end loop;
    
    if length(ls_return) > 0 then
       ls_return := substr(ls_return, 1, length(ls_return) - 2);
    end if;
    
    return ls_return;
  end;
  
  function sp_validar_linea_credito(
       asi_cod_relacion     in proveedor.proveedor%TYPE,
       ani_imp_soles        in cntas_cobrar.saldo_sol%TYPE,
       ani_imp_dolar        in cntas_cobrar.saldo_dol%TYPE
  ) return number is
    
    ls_flag_linea_credito   proveedor.flag_linea_credito%TYPE;
    ln_count                number;
    ls_nom_cliente          proveedor.nom_proveedor%TYPE;
    ls_mon_credito          proveedor_linea_credito.cod_moneda%TYPE;
    ln_plazo_credito        proveedor_linea_credito.plazo_credito%TYPE;
    ln_imp_credito          proveedor_linea_credito.importe%TYPE;
    ln_saldo                cntas_cobrar.saldo_sol%TYPE;
    ln_dias                 number(4);
    ln_importe              cntas_cobrar.saldo_dol%TYPE;
     
  begin
     -- Verifico que este activo la flag_linea_Credito
     select nvl(p.flag_linea_credito, '0'), p.nom_proveedor
       into ls_flag_linea_credito, ls_nom_cliente
       from proveedor p
      where p.proveedor = asi_cod_relacion;
     
     -- si esta apagado la linea de credito entonces returno OK
     if ls_flag_linea_credito = '0' then 
       return 1;
     end if;
     
     -- ahora obtengo la linea de credito aprobado
     select count(*)
       into ln_count
       from proveedor_linea_credito plc
      where plc.proveedor             = asi_cod_relacion
        and plc.flag_estado           = '1'
        and trunc(sysdate) between trunc(plc.fec_ini_vigencia) and trunc(plc.fec_fin_vigencia);
     
     if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'El Cliente ' || asi_cod_relacion || ' ' || ls_nom_cliente || 
                                        ' no tiene una linea de credito ACTIVA y VIGENTE.' || 
                                        chr(13) || 'Fecha actual: ' || to_char(sysdate, 'dd/mm/yyyy') ||
                                        chr(13) || 'Por favor corrija');
        return 0;
     end if;
     
     if ln_count > 1 then
        RAISE_APPLICATION_ERROR(-20000, 'El Cliente ' || asi_cod_relacion || ' ' || ls_nom_cliente || 
                                        ' tiene MAS de UNA linea de credito ACTIVA y VIGENTE.' || 
                                        chr(13) || 'Fecha actual: ' || to_char(sysdate, 'dd/mm/yyyy') ||
                                        chr(13) || 'Por favor corrija, ya que solo debe tener una sola linea de credito');
        return 0;
     end if;
     
     -- Obtengo el total de la linea de credito asi como tambien los días de credito
     select plc.importe, plc.cod_moneda
       into ln_imp_credito, ls_mon_credito
       from proveedor_linea_credito plc
      where plc.proveedor             = asi_cod_relacion
        and plc.flag_estado           = '1'
        and trunc(sysdate) between trunc(plc.fec_ini_vigencia) and trunc(plc.fec_fin_vigencia);
     
     -- Valido que no tenga cuentas pendientes por cobrar
     select count(*)
       into ln_count
       from vw_fin_pendiente_cobrar cc
      where cc.cod_relacion      = asi_cod_relacion
        and cc.nro_libro         = 4
        and cc.nro_asiento is not null
        and sysdate - trunc(cc.fecha_emision) > ln_plazo_credito
        and (case 
              when ls_mon_credito = PKG_LOGISTICA.of_soles(null) then cc.saldo_sol 
              else
                cc.saldo_dol
             end) > 0;
             
     if ln_count > 0 then
        RAISE_APPLICATION_ERROR(-20000, 'El Cliente ' || asi_cod_relacion || ' ' || ls_nom_cliente || 
                                        ' tiene ' || trim(to_char(ln_count)) || ' comprobantes pendientes de cobro que se han vencido.' || 
                                        chr(13) || 'Fecha actual: ' || to_char(sysdate, 'dd/mm/yyyy') ||
                                        chr(13) || 'Plazo de Credito: ' || trim(to_char(ln_plazo_credito, '999,990')));
        return 0;
     end if;
     
     select nvl(sum(
               case 
                  when ls_mon_credito = PKG_LOGISTICA.of_soles(null) then 
                     cc.saldo_sol 
                  else
                     cc.saldo_dol
               end),0), nvl(max(sysdate - trunc(cc.fecha_emision)),0)
       into ln_saldo, ln_dias
       from vw_fin_pendiente_cobrar cc
      where cc.cod_relacion      = asi_cod_relacion
        and cc.nro_libro         = 4
        and cc.nro_asiento is not null
        and (case 
              when ls_mon_credito = PKG_LOGISTICA.of_soles(null) then cc.saldo_sol 
              else
                cc.saldo_dol
             end) > 0;
      
     if ln_saldo > ln_imp_credito then
        if ln_count > 0 then
           RAISE_APPLICATION_ERROR(-20000, 'El Cliente ' || asi_cod_relacion || ' ' || ls_nom_cliente || 
                                           ' tiene un saldo mayor al de su Linea de Credito.' || 
                                           chr(13) || 'Linea Credito: ' || ls_mon_credito || trim(to_char(ln_imp_credito, '999,990.00')) ||
                                           chr(13) || 'Saldo por Cobrar: ' || ls_mon_credito || trim(to_char(ln_saldo, '999,990.00')) ||
                                           chr(13) || 'Fecha actual: ' || to_char(sysdate, 'dd/mm/yyyy') ||
                                           chr(13) || 'Plazo de Credito: ' || trim(to_char(ln_plazo_credito, '999,990')));
           return 0;
        end if;
     end if;
     
     -- Obtengo el importe segun la moneda
     if ls_mon_credito = PKG_LOGISTICA.of_soles(null) then
        ln_importe := ani_imp_soles;
     else
        ln_importe := ani_imp_dolar;
     end if; 
     
     -- Valido si el saldo pendiente mas el importe nuevo no supera el credito
     if ln_saldo + ln_importe > ln_imp_credito then
        if ln_count > 0 then
           RAISE_APPLICATION_ERROR(-20000, 'El Cliente ' || asi_cod_relacion || ' ' || ls_nom_cliente || 
                                           ' tiene un importe que supera al saldo que le queda al de su Linea de Credito.' || 
                                           chr(13) || 'Linea Credito: ' || ls_mon_credito || trim(to_char(ln_imp_credito, '999,990.00')) ||
                                           chr(13) || 'Saldo por Cobrar: ' || ls_mon_credito || trim(to_char(ln_saldo, '999,990.00')) ||
                                           chr(13) || 'Importe: ' || ls_mon_credito || trim(to_char(ln_importe, '999,990.00')) ||
                                           chr(13) || 'Fecha actual: ' || to_char(sysdate, 'dd/mm/yyyy') ||
                                           chr(13) || 'Plazo de Credito: ' || trim(to_char(ln_plazo_credito, '999,990')));
           return 0;
        end if;
     end if;
      
     
  end;

begin
  -- Initialization
  null;
end PKG_COMERCIALIZACION;
/

prompt
prompt Creating package body PKG_CONFIG
prompt ================================
prompt
create or replace package body cantabria.PKG_CONFIG is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;
  
  -- Funcion para determinar el ultima día de un año y mes
  function LAST_DAY(ani_mes   number, 
                    ani_year  number) return date is
                    
    ld_Result       date;
    ln_year         number;
    ln_mes          number;
    
  begin
    
    ln_mes := ani_mes + 1;
    
    if ln_mes > 12 then 
       ln_mes := 1;
       ln_year := ani_year + 1;
    else
       ln_year := ani_year;
    end if;
    
    ld_Result := to_date('01/' || trim(to_char(ln_mes, '00')) || '/' || trim(to_char(ln_year, '0000')), 'dd/mm/yyyy') - 1;
    
    return ld_Result;
  
  end ;

  -- Function and procedure implementations
  function USF_GET_PARAMETER(asi_parameter  IN configuracion.parametro%TYPE) return date is
    ln_Result configuracion.valor_date%TYPE;
    ln_count  NUMBER(1);
  begin
    SELECT COUNT(*)
      INTO ln_count
      FROM configuracion c
     WHERE c.parametro = asi_parameter;
    
    IF ln_count = 0 THEN
       ROLLBACK;
       insert into configuracion(parametro)
       values( asi_parameter);
       commit;
       
       RAISE_APPLICATION_ERROR(-20000, 'El parametro [' || asi_parameter || '] no existe en la tabla configuracion, por favor verifique');
    END IF;
    
    SELECT c.valor_date
      INTO ln_Result
      FROM configuracion c
     WHERE c.parametro = asi_parameter;

    IF ln_count = 0 THEN
       RAISE_APPLICATION_ERROR(-20000, 'El parametro [' || asi_parameter || '] tiene valor nulo, por favor verifique');
    END IF;

    return(ln_Result);
  end;
  
  -- Obtiene parametros de Tipo String
  function USF_GET_PARAMETER(asi_parameter  IN configuracion.parametro%TYPE, asi_default in configuracion.valor_char%TYPE) return varchar2 is
    PRAGMA AUTONOMOUS_TRANSACTION;
    ls_Result configuracion.valor_char%TYPE;
    ln_count  NUMBER(1);
  begin
    SELECT COUNT(*)
      INTO ln_count
      FROM configuracion c
     WHERE c.parametro = asi_parameter;
    
    IF ln_count = 0 THEN
      
       insert into configuracion(parametro, valor_char)
       values( asi_parameter, asi_default);
       
       ls_Result := asi_default;
       
       commit;
       
    else
      
       SELECT c.valor_char
         INTO ls_Result
         FROM configuracion c
        WHERE c.parametro = asi_parameter;
      
    END IF;
    
    return(ls_Result);
  end;

  -- Obtiene parametros de Tipo Integer
  function USF_GET_PARAMETER(asi_parameter  IN configuracion.parametro%TYPE, ani_Default in configuracion.valor_int%TYPE) return number is
    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_Result configuracion.valor_int%TYPE;
    ln_count  NUMBER(1);
  begin
    SELECT COUNT(*)
      INTO ln_count
      FROM configuracion c
     WHERE c.parametro = asi_parameter;
    
    IF ln_count = 0 THEN
      
       insert into configuracion(parametro, valor_int)
       values( asi_parameter, ani_Default);
       
       ln_Result := ani_Default;
       
       commit;
       
    else
      
       SELECT c.valor_int
         INTO ln_Result
         FROM configuracion c
        WHERE c.parametro = asi_parameter;
      
    END IF;
    
    return(ln_Result);
  end;

  -- Obtiene parametros de Tipo Integer
  function USF_GET_PARAMETER_dec(
           asi_parameter  IN configuracion.parametro%TYPE, 
           ani_default    in configuracion.valor_dec%TYPE
  ) return number is
    PRAGMA AUTONOMOUS_TRANSACTION;
  
    ln_Result configuracion.valor_int%TYPE;
    ln_count  NUMBER(1);
  
  begin
    SELECT COUNT(*)
      INTO ln_count
      FROM configuracion c
     WHERE c.parametro = asi_parameter;
    
    IF ln_count = 0 THEN
      
       insert into configuracion(parametro, valor_dec)
       values( asi_parameter, ani_Default);
       
       ln_Result := ani_Default;
       
       commit;
       
    else
      
       SELECT c.valor_dec
         INTO ln_Result
         FROM configuracion c
        WHERE c.parametro = asi_parameter;
      
    END IF;
    
    return(ln_Result);
  end;
  -- Obtiene la matriz contable según la subcategoría
  function OF_MATRIZ_VTA(
           asi_tipo_doc in doc_tipo.tipo_doc%TYPE,
           asi_sub_cat in articulo_sub_categ.cod_sub_cat%TYPE, 
           asi_moneda in moneda.cod_moneda%TYPE, 
           asi_default in vta_config.valor%TYPE
  ) return varchar2 is
  PRAGMA AUTONOMOUS_TRANSACTION;
  
    ls_Result       vta_config.valor%TYPE;
    ln_count        NUMBER(1);
    ls_concepto     vta_config.concepto%TYPE := 'MATRIZ_VTA';
    
  begin
    SELECT COUNT(*)
      INTO ln_count
      FROM vta_config c
     WHERE c.concepto     = ls_concepto
       and c.tipo_doc     = asi_tipo_doc
       and c.cod_sub_cat	= asi_sub_cat
       and c.cod_moneda   = asi_moneda;
    
    IF ln_count = 0 THEN
      
       insert into vta_config(concepto, tipo_doc, cod_sub_cat, cod_moneda, valor)
       values( ls_concepto, asi_tipo_doc, asi_sub_Cat, asi_moneda, asi_default);
       
       ls_Result := asi_default;
       
       commit;
       
    else
      
       SELECT c.valor
         INTO ls_Result
         FROM vta_config c
        WHERE c.concepto     = ls_concepto
          and c.tipo_doc     = asi_tipo_doc
          and c.cod_sub_cat	 = asi_sub_cat
          and c.cod_moneda   = asi_moneda;
      
    END IF;
    
    return(ls_Result);
  end;

  -- Obtiene el centro de costos de venta según la subcategoría
  function OF_CENCOS_VTA(
           asi_tipo_doc in doc_tipo.tipo_doc%TYPE,
           asi_sub_cat in articulo_sub_categ.cod_sub_cat%TYPE, 
           asi_moneda in moneda.cod_moneda%TYPE, 
           asi_default in vta_config.valor%TYPE
  ) return varchar2 is
  PRAGMA AUTONOMOUS_TRANSACTION;
  
    ls_Result       vta_config.valor%TYPE;
    ln_count        NUMBER(1);
    ls_concepto     vta_config.concepto%TYPE := 'CENCOS_VTA';
    
  begin
    SELECT COUNT(*)
      INTO ln_count
      FROM vta_config c
     WHERE c.concepto     = ls_concepto
       and c.tipo_doc     = asi_tipo_doc
       and c.cod_sub_cat	= asi_sub_cat
       and c.cod_moneda   = asi_moneda;
    
    IF ln_count = 0 THEN
      
       insert into vta_config(concepto, tipo_doc, cod_sub_cat, cod_moneda, valor)
       values( ls_concepto, asi_tipo_doc, asi_sub_Cat, asi_moneda, asi_default);
       
       ls_Result := asi_default;
       
       commit;
       
    else
      
       SELECT c.valor
         INTO ls_Result
         FROM vta_config c
        WHERE c.concepto     = ls_concepto
          and c.tipo_doc     = asi_tipo_doc
          and c.cod_sub_cat	 = asi_sub_cat
          and c.cod_moneda   = asi_moneda;
      
    END IF;
    
    return(ls_Result);
  end;

  -- Obtiene el centro de costos de venta según la subcategoría
  function OF_CENTRO_BENEF_VTA(
           asi_tipo_doc in doc_tipo.tipo_doc%TYPE,
           asi_sub_cat in articulo_sub_categ.cod_sub_cat%TYPE, 
           asi_moneda in moneda.cod_moneda%TYPE, 
           asi_default in vta_config.valor%TYPE
  ) return varchar2 is
  PRAGMA AUTONOMOUS_TRANSACTION;
  
    ls_Result       vta_config.valor%TYPE;
    ln_count        NUMBER(1);
    ls_concepto     vta_config.concepto%TYPE := 'CENTRO_BENEF_VTA';
    
  begin
    SELECT COUNT(*)
      INTO ln_count
      FROM vta_config c
     WHERE c.concepto     = ls_concepto
       and c.tipo_doc     = asi_tipo_doc
       and c.cod_sub_cat	= asi_sub_cat
       and c.cod_moneda   = asi_moneda;
    
    IF ln_count = 0 THEN
      
       insert into vta_config(concepto, tipo_doc, cod_sub_cat, cod_moneda, valor)
       values( ls_concepto, asi_tipo_doc, asi_sub_Cat, asi_moneda, asi_default);
       
       ls_Result := asi_default;
       
       commit;
       
    else
      
       SELECT c.valor
         INTO ls_Result
         FROM vta_config c
        WHERE c.concepto     = ls_concepto
          and c.tipo_doc     = asi_tipo_doc
          and c.cod_sub_cat	 = asi_sub_cat
          and c.cod_moneda   = asi_moneda;
      
    END IF;
    
    return(ls_Result);
  end;

  /*
  (select e.nombre from empresa e where e.cod_empresa = :as_empresa or e.sigla = :as_empresa) as razon_social_empresa,
       (select e.Ruc from empresa e where e.cod_empresa = :as_empresa or e.sigla = :as_empresa) as RUC,
       (select E.DIR_CALLE from empresa e where e.cod_empresa = :as_empresa or e.sigla = :as_empresa) as DIRECCION,
       (select E.fono_fijo from empresa e where e.cod_empresa = :as_empresa or e.sigla = :as_empresa) as FONO_FIJO,
     (select E.celular from empresa e where e.cod_empresa = :as_empresa or e.sigla = :as_empresa) as celular
  */ 
  function OF_RAZON_SOCIAL_EMPRESA(
    asi_empresa in varchar2
  ) return varchar2 is
    ls_return empresa.nombre%TYPE;
    ln_count  number;
  begin
    select count(*)
      into ln_count
      from empresa e
     where e.cod_empresa = asi_empresa 
        or e.sigla       = asi_empresa;
    
    if ln_count = 0 then
       ls_return := 'INDEFINIDO';
    else
       select e.nombre 
         into ls_return
         from empresa e 
        where (e.cod_empresa = asi_empresa 
          or e.sigla        = asi_empresa)
          AND ROWNUM        = 1;
    end if;
    
    return ls_return;
    
  end;
  function OF_RUC_EMPRESA(
    asi_empresa in varchar2
  ) return varchar2 is
  
    ls_return empresa.Ruc%TYPE;
    ln_count  number;
    
  begin
    select count(*)
      into ln_count
      from empresa e
     where e.cod_empresa = asi_empresa 
        or e.sigla       = asi_empresa;
    
    if ln_count = 0 then
       ls_return := 'INDEFINIDO';
    else
       select e.Ruc 
         into ls_return
         from empresa e 
        where (e.cod_empresa = asi_empresa 
          or e.sigla        = asi_empresa)
          AND ROWNUM        = 1;
    end if;
    
    return ls_return;
    
  end;
  function OF_DIRECCION_EMPRESA(
    asi_empresa in varchar2
  ) return varchar2  is
  
    ls_return empresa.direccion%TYPE;
    ln_count  number;
    
  begin
    select count(*)
      into ln_count
      from empresa e
     where e.cod_empresa = asi_empresa 
        or e.sigla       = asi_empresa;
    
    if ln_count = 0 then
       ls_return := 'INDEFINIDO';
    else
       select e.direccion 
         into ls_return
         from empresa e 
        where (e.cod_empresa = asi_empresa 
          or e.sigla        = asi_empresa)
          AND ROWNUM        = 1;
    end if;
    
    return ls_return;
    
  end;
  function OF_DIRECCION_EMPRESA(
    asi_empresa in varchar2,
    asi_origen  in origen.cod_origen%TYPE
  ) return varchar2  is
  
    ls_return origen.dir_calle%TYPE;
    ln_count  number;
    
  begin
    select count(*)
      into ln_count
      from origen e
     where e.cod_origen = asi_origen;
    
    if ln_count = 0 then
       ls_return := 'INDEFINIDO';
    else
       select e.dir_calle || ', ' || e.dir_distrito || '-' || e.dir_provincia || '-' || e.dir_departamento
              || ' - PERU'
         into ls_return
         from origen e 
        where e.cod_origen = asi_origen;
    end if;
    
    return ls_return;
    
  end;
  function OF_FONO_FIJO_EMPRESA(
    asi_empresa in varchar2
  ) return varchar2  is
  
    ls_return empresa.fono_fijo%TYPE;
    ln_count  number;
    
  begin
    select count(*)
      into ln_count
      from empresa e
     where e.cod_empresa = asi_empresa 
        or e.sigla       = asi_empresa;
    
    if ln_count = 0 then
       ls_return := '';
    else
       select e.fono_fijo 
         into ls_return
         from empresa e 
        where (e.cod_empresa = asi_empresa 
          or e.sigla        = asi_empresa)
          AND ROWNUM        = 1;
    end if;
    
    return ls_return;
    
  end; 
  
  function OF_CELULAR_EMPRESA(
    asi_empresa in varchar2
  ) return varchar2 is
  
    ls_return empresa.celular%TYPE;
    ln_count  number;
    
  begin
    select count(*)
      into ln_count
      from empresa e
     where e.cod_empresa = asi_empresa 
        or e.sigla       = asi_empresa;
    
    if ln_count = 0 then
       ls_return := '';
    else
       select e.celular 
         into ls_return
         from empresa e 
        where (e.cod_empresa = asi_empresa 
          or e.sigla        = asi_empresa)
          AND ROWNUM        = 1;
    end if;
    
    return ls_return;
    
  end;

begin
  -- Initialization
  null;
end PKG_CONFIG;
/

prompt
prompt Creating package body PKG_FACT_ELECTRONICA
prompt ==========================================
prompt
create or replace package body cantabria.pkg_fact_electronica is

  -- Private type declarations
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  procedure sp_fs_vale_almacen(
    asi_registro fs_factura_simpl.nro_registro%TYPE
  ) is
    
    ls_nro_vale          vale_mov.nro_vale%TYPE;
    ln_ult_nro           num_vale_mov.ult_nro%TYPE;
    ln_count             number;
    ln_nro_am            articulo_mov.nro_mov%TYPE;
    ls_matriz            matriz_cntbl_finan.matriz%TYPE;
    ln_costo_prom_sol    articulo_almacen.costo_prom_sol%TYPE;
    ls_flag_contabiliza  articulo_mov_tipo.flag_contabiliza%TYPE;
    ls_tipo_mov          articulo_mov_tipo.tipo_mov%TYPE;
    ln_factor_sldo_total articulo_mov_tipo.factor_sldo_total%TYPE;
    ln_saldo_total       articulo_almacen.sldo_total%TYPE;
    ls_almacen           articulo_almacen.almacen%TYPE;
    
    cursor c_almacenes is
      select distinct 
             fd.almacen,
             al.cod_origen,
             am.nro_vale,
             f.fec_movimiento,
             f.cliente,
             p.nom_proveedor as nom_cliente,
             f.observacion,
             f.cod_usr,
             f.tipo_doc_cxc,
             decode(f.nro_doc_cxc, null, of_get_nro_doc(f.serie_cxc, f.nro_cxc), f.nro_doc_cxc) as nro_doc_cxc,
             mn.motivo,
             mn.descripcion as desc_motivo_nota,
             f.vendedor
        from fs_factura_simpl     f,
             fs_factura_simpl_det fd,
             almacen              al,
             articulo_mov         am,
             proveedor            p,
             motivo_nota          mn
       where f.nro_registro  = fd.nro_registro
         and f.cliente       = p.proveedor
         and fd.almacen      = al.almacen
         and fd.org_am       = am.cod_origen	(+)
         and fd.nro_am       = am.nro_mov     (+)
         and f.motivo_nota   = mn.motivo      (+)
         and f.nro_registro  = asi_registro
         and fd.almacen is not null;
    
    cursor c_detalle(as_almacen  almacen.almacen%TYPE)  is
      select fd.cod_art,
             fd.descripcion,
             fd.cant_proyect,
             fd.nro_registro,
             fd.nro_item,
             fd.org_am,
             fd.nro_am,
             a.sub_cat_art
        from fs_factura_simpl_det fd,
             articulo             a
       where fd.cod_art      = a.cod_art
         and fd.nro_registro = asi_registro
         and fd.almacen      = as_almacen
         and fd.almacen is not null;
    
    cursor c_articulo_mov (as_nro_vale vale_mov.nro_vale%TYPE) is
      select *
        from articulo_mov am
       where am.nro_vale = as_nro_Vale;  
  begin
    for lc_almacen in c_almacenes loop
      
        -- Coloco el tipo de movimiento correcto
        if lc_almacen.motivo in (pkg_fact_electronica.is_ncc_devol_total, 
                                 pkg_fact_electronica.is_ncc_devol_parcial) then
           ls_tipo_mov := pkg_almacen.is_ing_devolucion_vta;
        else
           ls_tipo_mov := PKG_LOGISTICA.is_oper_vnta_mat;
        end if;

        -- Si no tiene vale de salida entonces 
        
        if lc_almacen.nro_vale is null then
           -- Obtengo el siguiente numero
           select count(*)
             into ln_count
             from num_vale_mov n
            where n.origen = lc_almacen.cod_origen;
          
           if ln_count = 0 then
              insert into num_vale_mov(origen, ult_nro)
              values(lc_almacen.cod_origen, 1);
           end if;
           
           select n.ult_nro
             into ln_ult_nro
             from num_vale_mov n
            where n.origen = lc_almacen.cod_origen for update;
           
           -- Obtengo el siguiene nro de vale
           ls_nro_vale := trim(lc_almacen.cod_origen) || trim(to_char(ln_ult_nro, '00000000'));
           
           -- Actualizo el numerador
           update num_vale_mov
              set ult_nro = ln_ult_nro + 1
            where origen = lc_almacen.cod_origen;
            
           -- Determino el factor del movimiento de almacen
           select amt.factor_sldo_total
             into ln_factor_sldo_total
             from articulo_mov_tipo amt
            where amt.tipo_mov = ls_tipo_mov;
           
           -- Inserto la cabecera del movimiento de almacen
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov, cod_usr, 
                  proveedor, nom_receptor, tipo_doc_ext, nro_doc_ext, 
                  vendedor,
                  observaciones)
           values(
                  lc_almacen.cod_origen, ls_nro_vale, lc_almacen.almacen, '1', lc_almacen.fec_movimiento,
                  ls_tipo_mov, lc_almacen.cod_usr, lc_almacen.cliente, substr(lc_almacen.nom_cliente, 1, 50),
                  lc_almacen.tipo_doc_cxc, lc_almacen.nro_doc_cxc, 
                  lc_almacen.vendedor,
                  lc_almacen.observacion);
           
        else
           ls_nro_vale := lc_almacen.nro_vale;
           
           -- Determino el factor
           select amt.factor_sldo_total, vm.almacen
             into ln_factor_sldo_total, ls_almacen
             from vale_mov vm,
                  articulo_mov_tipo amt
            where vm.tipo_mov = amt.tipo_mov
              and vm.nro_vale = ls_nro_vale;
           
           if ln_factor_sldo_total = 1 then
              for lc_reg in c_articulo_mov(ls_nro_vale) loop
                
                  -- Si es un ingreso tengo que validar que haya stock suficiente para anular sino lo incremento
                  select aa.sldo_total
                    into ln_saldo_total
                    from articulo_almacen aa
                   where aa.cod_art       = lc_reg.cod_art 
                     and aa.almacen       = ls_almacen  for update;
                  
                  if ln_saldo_total < lc_reg.cant_procesada or ln_saldo_total <= 0 then
                     update articulo_almacen aa
                        set aa.sldo_total    = aa.sldo_total + lc_reg.cant_procesada
                      where aa.cod_art       = lc_reg.cod_art
                        and aa.almacen       = ls_almacen;
                  end if;

              end loop;
              
           end if;
           
           -- Elimino el detalle
           update articulo_mov am
              set am.cant_procesada = 0.00000001
            where am.nro_vale = ls_nro_Vale;
           
           --delete articulo_mov am
           --where am.nro_Vale = ls_nro_Vale;
           
           -- Actualizo el tipo_mov de la cabecera
           update vale_mov vm
              set vm.tipo_mov     = ls_tipo_mov,
                  vm.tipo_doc_ext = lc_almacen.tipo_doc_cxc,
                  vm.nro_doc_ext  = lc_almacen.nro_doc_cxc,
                  vm.vendedor     = lc_almacen.vendedor,
                  vm.almacen      = lc_almacen.almacen,
                  vm.proveedor    = lc_almacen.cliente
             where vm.nro_Vale = ls_nro_vale;
        end if;
        
        -- ahora inserto el detalle del movimiento del almacen
        for lc_detalle in c_detalle(lc_almacen.almacen) loop
            -- Verifico que el tipo de movimiento contabilice
            select amt.flag_contabiliza
              into ls_flag_contabiliza
              from articulo_mov_tipo amt
             where amt.tipo_mov = PKG_LOGISTICA.is_oper_vnta_mat;
            
            -- Si el movimiento si necesita contabilizarse
            if ls_flag_contabiliza = '1' then
               -- Obtengo la matriz contable
               select count(*)
                 into ln_count
                 from tipo_mov_matriz_subcat t
                where t.tipo_mov        = PKG_LOGISTICA.is_oper_vnta_mat
                  and t.grp_cntbl       = PKG_FACT_ELECTRONICA.is_grp_mercaderia
                  and t.cod_sub_cat     = lc_detalle.sub_cat_art;
                
               if ln_count = 0 then
                  ls_matriz := PKG_FACT_ELECTRONICA.is_matriz_VS000;
                  insert into tipo_mov_matriz_subcat(
                         tipo_mov, grp_cntbl, cod_sub_cat, item, matriz)
                  values(
                         PKG_LOGISTICA.is_oper_vnta_mat, PKG_FACT_ELECTRONICA.is_grp_mercaderia, lc_detalle.sub_cat_art,
                         1, ls_matriz);
               else
                   -- Tomo la matriz que existe
                   select MAX(t.matriz)
                     into ls_matriz
                     from tipo_mov_matriz_subcat t
                    where t.tipo_mov        = PKG_LOGISTICA.is_oper_vnta_mat
                      and t.grp_cntbl       = PKG_FACT_ELECTRONICA.is_grp_mercaderia
                      and t.cod_sub_cat     = lc_detalle.sub_cat_art;
                  
               end if;
            else
               ls_matriz := null; 
            end if;   
            
            if lc_detalle.nro_am is null then
              
               select count(*)
                 into ln_count
                 from articulo_almacen aa
                where aa.cod_art = lc_detalle.cod_art
                  and aa.almacen = lc_almacen.almacen;
               
               if ln_count > 0 then
                 
                  -- Obtengo el precio promedio
                  select aa.costo_prom_sol, aa.sldo_total
                    into ln_costo_prom_sol, ln_saldo_total
                    from articulo_almacen aa
                   where aa.cod_art = lc_detalle.cod_art
                     and aa.almacen = lc_almacen.almacen for update;
                     
               else
                 
                  insert into articulo_almacen(
                         cod_art, almacen, sldo_total, costo_prom_sol, costo_prom_dol)
                  values(
                         lc_detalle.cod_art, lc_almacen.almacen, 0, 0, 0);
                         
                  ln_costo_prom_sol := 0;
                  ln_saldo_total    := 0;
                  
               end if;
               
               -- Valido si hay suficiente stock
               if ln_factor_sldo_total = -1 then
                  if ln_saldo_total < lc_detalle.cant_proyect then
                     if PKG_CONFIG.USF_GET_PARAMETER('VTA_VALIDAR_STOCK_FACT_SIMPL', '0') = '0' then
                        -- En caso no haya sufiente stock entonces incremento el stock en el dato exacto 
                        -- Luego tengo que correr el proceso de ajuste de saldos de articulos
                        update articulo_almacen aa
                           set aa.sldo_total = aa.sldo_total + lc_detalle.cant_proyect
                         where aa.cod_art = lc_detalle.cod_art
                           and aa.almacen = lc_almacen.almacen;   
                     else
                        RAISE_APPLICATION_ERROR(-20000, 'No hay saldo disponible suficiente para el despacho'
                                          || chr(13) || 'Nro Vale: ' || ls_nro_vale
                                          || chr(13) || 'Tipo Mov: ' || ls_tipo_mov
                                          || chr(13) || 'Almacen: ' || lc_almacen.almacen
                                          || chr(13) || 'Articulo: ' || lc_detalle.cod_art
                                          || chr(13) || 'Saldo Disponible: ' || trim(to_char(ln_saldo_total, '999,9990.0000'))
                                          || chr(13) || 'Cant. Despacho: ' || trim(to_char(lc_detalle.cant_proyect, '999,9990.0000')) );
                     end if;
                     
                  end if;
               end if;

               -- Inserto el detalle del movimiento contable
               insert into articulo_mov(
                  cod_origen, nro_vale, flag_estado, cod_art, cant_procesada, precio_unit, 
                  cod_moneda, matriz, fec_registro)
               values(
                  lc_almacen.cod_origen, ls_nro_vale, '1', lc_detalle.cod_art, lc_detalle.cant_proyect, ln_costo_prom_sol, 
                  pkg_logistica.is_soles, ls_matriz, sysdate);
               
               -- Obtengo el nro_am
               select am.nro_mov
                 into ln_nro_am
                 from tt_art_mov am;
               
               -- Actualizo en la tabla
               update fs_factura_simpl_det fd
                  set fd.org_am  = lc_almacen.cod_origen,
                      fd.nro_am  = ln_nro_am
                where fd.nro_registro = lc_detalle.nro_registro
                  and fd.nro_item     = lc_detalle.nro_item;
            else
               -- Actualizo en la tabla
               update articulo_mov am
                  set am.matriz  = ls_matriz,
                      am.cant_procesada = lc_detalle.cant_proyect
                where am.cod_origen   = lc_detalle.org_am
                  and am.nro_mov      = lc_detalle.nro_am;
            end if;
        end loop;
    end loop;
  end ;
  
  -- Genera el asiento contable de la provision de la cuenta por cobrar
  procedure sp_fs_asiento_contable	(
    asi_registro fs_factura_simpl.nro_registro%TYPE 
  )is
    
    ls_matriz        matriz_cntbl_finan.matriz%TYPE;
    ls_nro_doc       cntas_cobrar.nro_doc%TYPE;

    
    -- Totales de los asientos
    ln_tot_soldeb    cntbl_asiento.tot_soldeb%TYPE;
    ln_tot_solhab    cntbl_asiento.tot_solhab%TYPE;
    ln_tot_doldeb    cntbl_asiento.tot_doldeb%TYPE;
    ln_tot_dolhab    cntbl_asiento.tot_dolhab%TYPE;
    
    --Elementos de la cabecera del comprobante 
    ls_serie_cxc     fs_factura_simpl.serie_cxc%TYPE;
    ls_nro_cxc       fs_factura_simpl.nro_cxc%TYPE;
    ls_moneda        fs_factura_simpl.cod_moneda%TYPE;
    ld_fec_registro  fs_factura_simpl.fec_registro%TYPE;
    ln_tasa_cambio   fs_factura_simpl.tasa_cambio%TYPE;
    ls_obs           fs_factura_simpl.observacion%TYPE;
    ls_cod_usr       fs_factura_simpl.cod_usr%TYPE;
    ls_origen        fs_factura_simpl.cod_origen%TYPE;
    ls_cliente       fs_factura_simpl.cliente%TYPE;
    ls_tipo_doc      fs_factura_simpl.tipo_doc_cxc%TYPE;
    ls_nom_cliente   proveedor.nom_proveedor%TYPE;
    ls_ruc_dni       proveedor.nro_doc_ident%TYPE;
    
    -- Detalle del asiento contable
    ls_tipo_docref   cntbl_asiento_det.tipo_docref1%TYPE;
    ls_nro_docref    cntbl_asiento_det.nro_docref2%TYPE;
    ls_cencos        cntbl_asiento_det.cencos%TYPE;
    ls_centro_benef  cntbl_asiento_det.centro_benef%TYPE;
    ls_cod_relacion  cntbl_asiento_det.cod_relacion%TYPE;
    ln_item          cntbl_asiento_det.item%TYPE;
    ln_imp_movsol    cntbl_asiento_det.imp_movsol%TYPE;
    ln_imp_movdol    cntbl_asiento_det.imp_movdol%TYPE;
    ln_nro_asiento   cntbl_asiento.nro_asiento%TYPE;
    ln_year          cntbl_asiento.ano%TYPE;
    ln_mes           cntbl_asiento.mes%TYPE;
    ln_count         number;
    
    -- Datos para la cuenta contable del IGV
    ls_cnta_cntbl           cntbl_cnta.cnta_ctbl%TYPE;
    ls_flag_doc_ref         cntbl_cnta.flag_doc_ref%TYPE;
    ls_flag_codrel          cntbl_cnta.flag_codrel%TYPE;
    ls_desc_cnta            cntbl_cnta.desc_cnta%TYPE;
    ls_flag_dh_cxp          impuestos_tipo.flag_dh_cxp%TYPE;
    ls_flag_cencos          cntbl_cnta.flag_cencos%TYPE;
    ls_flag_centro_benef    cntbl_cnta.flag_centro_benef%TYPE;
    ls_flag_debhab          cntbl_asiento_det.flag_debhab%TYPE;
    ln_nro_libro            cntbl_asiento.nro_libro%TYPE;
    
    cursor c_data  is
      select case
                when fd.cod_art is not null then
                  fd.cod_art
                when fd.cod_servicio is not null then
                  fd.cod_servicio
                else
                  null
             end as cod_art,
             fd.descripcion,
             fd.cant_proyect,
             fd.precio_unit,
             fd.descuento,
             fd.importe_igv,
             fd.icbper,
             fd.nro_registro,
             fd.nro_item,
             fd.org_am,
             fd.nro_vale_vd,
             fd.nro_am,
             case
                when a.sub_cat_art is not null then
                  a.sub_cat_art
                when fd.cod_servicio is not null then
                  fd.cod_servicio
                else
                  null
             end as sub_cat_art,
             f.cod_origen,
             f.tipo_doc_cxc,
             f.nro_cxc,
             f.cliente,
             f.fec_movimiento,
             f.cod_moneda,
             fd.tipo_doc_cxc as tipo_doc_ref,
             fd.nro_doc_cxc as nro_doc_ref
             
        from fs_factura_simpl     f,
             fs_factura_simpl_det fd,
             articulo             a
       where f.nro_registro  = fd.nro_registro
         and fd.cod_art      = a.cod_art        (+)
         and fd.nro_registro = asi_registro
       order by fd.nro_item;
    
    cursor c_matriz(as_matriz matriz_cntbl_finan.matriz%TYPE) is
       select md.item,
              md.cnta_ctbl,
              md.flag_debhab,
              md.formula,
              nvl(cc.flag_cencos, '0') as flag_cencos,
              nvl(cc.flag_codrel, '0') as flag_codrel,
              NVL(cc.flag_doc_ref, '0') as flag_doc_ref,
              nvl(cc.flag_centro_benef, '0') as flag_centro_benef
         from matriz_cntbl_finan_det md,
              cntbl_cnta             cc
       where md.cnta_ctbl = cc.cnta_ctbl
         and md.matriz    = as_matriz
      order by md.item;
  
  begin
    -- Obtengo datos necesarios
    select f.cod_origen, f.cod_moneda, f.fec_movimiento, f.tasa_cambio, f.serie_cxc, f.nro_cxc,
           f.cliente, f.tipo_doc_cxc, f.ano, f.mes, f.nro_asiento, p.nom_proveedor,
           decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident), dt.nro_libro
      into ls_origen, ls_moneda, ld_fec_registro, ln_tasa_cambio, ls_serie_cxc, ls_nro_cxc,
           ls_cliente, ls_tipo_doc, ln_year, ln_mes, ln_nro_asiento, ls_nom_cliente,
           ls_ruc_dni, ln_nro_libro
      from fs_factura_simpl f,
           doc_tipo         dt,
           proveedor        p
     where f.cliente      = p.proveedor
       and f.tipo_doc_cxc = dt.tipo_doc
       and f.nro_registro = asi_registro;
    
    ls_nro_doc := PKG_FACT_ELECTRONICA.of_get_nro_doc(ls_serie_cxc, ls_nro_cxc);
    
    if trunc(ld_fec_registro) > trunc(sysdate) then
       ld_fec_registro := sysdate;
    end if;
    
    -- Valido si el periodo es correcto sino creo paso el asiento en el periodo correcto
    if ln_year is not null and ln_mes is not null and ln_nro_asiento is not null then
       if ln_year <> to_number(to_char(ld_fec_registro, 'yyyy')) or ln_mes <> to_number(to_char(ld_fec_registro, 'mm')) then
          -- Procedo a eliminar el asiento y quitar la referencia
          
          update cntas_cobrar cc
             set cc.ano         = null,
                 cc.mes         = null,
                 cc.nro_libro   = null,
                 cc.nro_asiento = null
           where cc.origen      = ls_origen
             and cc.ano         = ln_year
             and cc.mes         = ln_mes
             and cc.nro_libro   = ln_nro_libro
             and cc.nro_asiento = ln_nro_asiento;
           
           update fs_factura_simpl f
             set f.ano          = null,
                 f.mes          = null,
                 f.nro_libro    = null,
                 f.nro_asiento  = null
           where f.nro_registro = asi_registro;
           
          delete cntbl_asiento_det cad
           where cad.origen      = ls_origen
             and cad.ano         = ln_year
             and cad.mes         = ln_mes
             and cad.nro_libro   = ln_nro_libro
             and cad.nro_asiento = ln_nro_asiento;

          delete cntbl_asiento ca
           where ca.origen      = ls_origen
             and ca.ano         = ln_year
             and ca.mes         = ln_mes
             and ca.nro_libro   = ln_nro_libro
             and ca.nro_asiento = ln_nro_asiento;
          
          delete doc_pendientes_cta_cte t
           where t.tipo_doc = ls_tipo_doc
             and t.nro_doc  = ls_nro_doc;

          ln_year := null;
          ln_mes := null;
          ln_nro_asiento := null;
       end if;
    end if;
    
    -- Genero la glosa del asiento
    ls_obs := 'VENTA  DE BIEN / SERVICIO, CLIENTE: ' || ls_nom_cliente || ' RUC: ' || ls_ruc_dni  
           || ', COMPROBANTE: ' || ls_tipo_doc || '/ ' || ls_nro_doc;
    
    -- Si no tiene el año, mes o nro asiento entonces lo creo
    if ln_year is null or ln_mes is null or ln_nro_asiento is null then
      
       ln_year := to_number(to_char(ld_fec_registro, 'yyyy'));
       ln_mes  := to_number(to_char(ld_fec_registro, 'mm'));
       
       -- Obtengo el siguiente numero correlativo del asiento
       select count(*)
         into ln_count
         from cntbl_libro_mes clm
        where clm.origen      = ls_origen
          and clm.nro_libro   = ln_nro_libro
          and clm.ano         = ln_year
          and clm.mes         = ln_mes;
        
       if ln_count = 0 then
          insert into cntbl_libro_mes(
                  origen, nro_libro, ano, mes, nro_asiento)
          values(
                  ls_origen, il_libro_ventas, ln_year, ln_mes, 1);
       end if;
        
       select clm.nro_asiento
         into ln_nro_asiento
         from cntbl_libro_mes clm
        where clm.origen      = ls_origen
          and clm.nro_libro   = ln_nro_libro
          and clm.ano         = ln_year
          and clm.mes         = ln_mes for update;

       update cntbl_libro_mes clm
          set clm.nro_asiento = ln_nro_asiento + 1
        where clm.origen      = ls_origen
          and clm.nro_libro   = ln_nro_libro
          and clm.ano         = ln_year
          and clm.mes         = ln_mes;
           
       -- Inserto la cabecera del asiento contable
       insert into cntbl_asiento(
               origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, desc_glosa, 
               fecha_cntbl, fec_registro, 
               cod_usr, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf)
        values(
               ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ls_moneda, ln_Tasa_cambio, ls_obs,
               ld_fec_registro, sysdate,
               ls_cod_usr, '1', 0, 0, 0, 0, '0');

    else
       -- Elimino el detalle del comprobante
       delete cntbl_asiento_det cad
        where cad.origen        = ls_origen
          and cad.ano           = ln_year
          and cad.mes           = ln_mes
          and cad.nro_libro     = ln_nro_libro
          and cad.nro_asiento   = ln_nro_asiento;
    end if;  
   
    -- Inserto el detalle del comprobante de pago
    for lc_data in c_data loop
      
        -- Si el precio es positivo es la venta del bien o servicio
        if lc_data.precio_unit - lc_data.descuento >= 0 then
           
           -- Obtengo la matriz, dependiendo de la subcategoria y de la moneda
           ls_matriz := PKG_CONFIG.OF_MATRIZ_VTA(lc_data.tipo_doc_cxc, lc_data.sub_cat_art, lc_data.cod_moneda, 'CC-001');
            
           for lc_matriz in c_matriz(ls_matriz) loop
             
               -- Calculo el importe en soles y en dolares
               if instr(lc_matriz.formula, 'IGV') = 0 then
                  if ls_moneda = PKG_LOGISTICA.is_soles then
                     ln_imp_movsol := lc_data.cant_proyect * (lc_data.precio_unit - lc_data.descuento);
                     ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
                  else
                     ln_imp_movdol := lc_data.cant_proyect * (lc_data.precio_unit - lc_data.descuento);
                     ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
                  end if; 
               else
                  -- Si pide el IGV entonces tengo que sumarlo incluyendo el icbper
                  if ls_moneda = PKG_LOGISTICA.is_soles then
                     ln_imp_movsol := lc_data.cant_proyect * (lc_data.precio_unit - lc_data.descuento + lc_data.importe_igv) + lc_data.icbper;
                     ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
                  else
                     ln_imp_movdol := lc_data.cant_proyect * (lc_data.precio_unit - lc_data.descuento + lc_data.importe_igv) +lc_data.icbper;
                     ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
                  end if;
               end if;
               
               if lc_matriz.flag_debhab = 'D' and lc_matriz.cnta_ctbl like '12%' then
                  -- Si la cuenta es la 12 y esta en el Debe entonces valido si es un trabajador
                  select count(*)
                    into ln_count
                    from maestro m
                   where m.cod_trabajador = ls_cliente;
                   
                  if ln_count > 0 then
                     ls_cnta_cntbl := PKG_CONFIG.USF_GET_PARAMETER('CNTA_CNTBL_VENTAS_PERSONAL_' || ls_moneda, '14191001');
                     
                     select count(*)
                       into ln_count
                       from cntbl_cnta cc
                      where cc.cnta_ctbl = ls_cnta_cntbl
                        and cc.flag_estado = '1';
                     
                     if ln_count = 0 then
                        ROLLBACK;
                        RAISE_APPLICATION_ERROR(-20000, 'La Cuenta Contable ' || ls_cnta_cntbl || ' del parametro '
                                                     || 'CNTA_CNTBL_VENTAS_PERSONAL_' || ls_moneda || ' no existe o no se encuentra activo,'
                                                     || chr(13) || 'Por favor coordine con CONTABILIDAD para su correccion');
                     end if;
                     
                     select nvl(cc.flag_cencos, '0'),
                            nvl(cc.flag_centro_benef, '0'),
                            nvl(cc.flag_codrel, '0'),
                            nvl(cc.flag_doc_ref, '0')
                       into ls_flag_cencos, ls_flag_centro_benef, ls_flag_codrel, ls_flag_doc_ref
                       from cntbl_cnta cc
                      where cc.cnta_ctbl = ls_cnta_cntbl
                        and cc.flag_estado = '1';
                  else
                     ls_cnta_cntbl        := lc_matriz.cnta_ctbl;
                     ls_flag_cencos       := lc_matriz.flag_cencos;
                     ls_flag_centro_benef := lc_matriz.flag_centro_benef;
                     ls_flag_codrel       := lc_matriz.flag_codrel;
                     ls_flag_doc_ref      := lc_matriz.flag_doc_ref;
                  end if;
                   
                  
               else
                  ls_cnta_cntbl        := lc_matriz.cnta_ctbl;
                  ls_flag_cencos       := lc_matriz.flag_cencos;
                  ls_flag_centro_benef := lc_matriz.flag_centro_benef;
                  ls_flag_codrel       := lc_matriz.flag_codrel;
                  ls_flag_doc_ref      := lc_matriz.flag_doc_ref;
               end if;

               -- Solicita centros de costo
               if ls_flag_cencos = '1' then
                  ls_cencos := PKG_CONFIG.OF_CENCOS_VTA(lc_data.tipo_doc_cxc, lc_data.sub_cat_art, lc_data.cod_moneda, pkg_config.USF_GET_PARAMETER('CENCOS_VTA_DEFAUL', '70101005'));
               else
                  ls_cencos := null;
               end if;
                
               -- Solicita centro Beneficio
               if ls_flag_centro_benef = '1' then
                  ls_centro_benef := PKG_CONFIG.OF_CENTRO_BENEF_VTA(lc_data.tipo_doc_cxc, lc_data.sub_cat_art, lc_data.cod_moneda, pkg_config.USF_GET_PARAMETER('CENTRO_BENEF_DEFAULT', '1020'));
               else
                  ls_centro_benef := null;
               end if;
               
               -- Solicita Codigo de Relacion 
               if ls_flag_codrel = '1' then
                  ls_cod_relacion := ls_cliente;
               else
                  ls_cod_relacion := null;
               end if;
               
               -- Solicita Documento de referencia
               if ls_flag_doc_ref = '1' then
                  ls_tipo_docref := ls_tipo_doc;
                  ls_nro_docref  := ls_nro_doc;
               else
                  ls_tipo_docref := null;
                  ls_nro_docref  := null;
               end if;
               
               -- Verifico el flag_debhab
               if lc_data.tipo_doc_cxc = PKG_SIGRE_FINANZAS.is_doc_ncc then
                  if lc_matriz.flag_debhab = 'D' then
                     ls_flag_debhab := 'H';
                  else
                     ls_flag_debhab := 'D';
                  end if;
               else
                  ls_flag_debhab := lc_matriz.flag_debhab;
               end if;
               
               -- Verifico si ya existe la cuenta en el asiento
               select count(*)
                 into ln_count
                 from cntbl_asiento_det cad
                where cad.origen           = ls_origen
                  and cad.ano              = ln_year
                  and cad.mes              = ln_mes
                  and cad.nro_libro        = ln_nro_libro
                  and cad.nro_asiento      = ln_nro_asiento
                  and cad.cnta_ctbl        = ls_cnta_cntbl
                  and cad.flag_debhab      = ls_flag_debhab
                  and nvl(cad.cencos, 'X')        = nvl(ls_cencos, 'X')
                  and nvl(cad.centro_benef, 'X')  = nvl(ls_centro_benef, 'X')
                  and nvl(cad.tipo_docref1, 'X')  = nvl(ls_tipo_docref, 'X')
                  and nvl(cad.nro_docref1, 'X')   = nvl(ls_nro_docref, 'X')
                  and nvl(cad.cod_relacion, 'X')  = nvl(ls_cod_relacion, 'X');
               
               if ln_count = 0 then
                  -- Inserto el nuevo registro
                  select nvl(max(cad.item),0)
                    into ln_item
                    from cntbl_asiento_det cad
                   where cad.origen           = ls_origen
                     and cad.ano              = ln_year
                     and cad.mes              = ln_mes
                     and cad.nro_libro        = ln_nro_libro
                     and cad.nro_asiento      = ln_nro_asiento;
                  
                  ln_item := ln_item + 1;
                  
                  insert into cntbl_asiento_det(
                         origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, 
                         fec_cntbl, 
                         det_glosa, flag_gen_aut, flag_debhab, 
                         cencos, tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol, 
                         centro_benef)
                  values(
                         ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, 
                         ld_fec_registro,
                         ls_obs, '0', ls_flag_debhab,
                         ls_cencos, ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol, 
                         ls_centro_benef);
                         
               else
                  select cad.item
                    into ln_item
                    from cntbl_asiento_det cad
                   where cad.origen           = ls_origen
                     and cad.ano              = ln_year
                     and cad.mes              = ln_mes
                     and cad.nro_libro        = ln_nro_libro
                     and cad.nro_asiento      = ln_nro_asiento
                     and cad.cnta_ctbl        = ls_cnta_cntbl
                     and cad.flag_debhab      = ls_flag_debhab
                     and nvl(cad.cencos, 'X')       = nvl(ls_cencos, 'X')
                     and nvl(cad.centro_benef, 'X') = nvl(ls_centro_benef, 'X')
                     and nvl(cad.tipo_docref1, 'X') = nvl(ls_tipo_docref, 'X')
                     and nvl(cad.nro_docref1, 'X')  = nvl(ls_nro_docref, 'X')
                     and nvl(cad.cod_relacion, 'X') = nvl(ls_cod_relacion, 'X');
                  
                  update cntbl_asiento_det cad
                     set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                         cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
                   where cad.origen           = ls_origen
                     and cad.ano              = ln_year
                     and cad.mes              = ln_mes
                     and cad.nro_libro        = ln_nro_libro
                     and cad.nro_asiento      = ln_nro_asiento
                     and cad.item             = ln_item;
                         
               end if;
               
           end loop;
           
        end if;
        
        -- Añado el impuesto, en caso que sea positivo
        if lc_data.importe_igv > 0 then
           
           -- Obtengo los importes
           if ls_moneda = PKG_LOGISTICA.is_soles then
              ln_imp_movsol := lc_data.cant_proyect * lc_data.importe_igv;
              ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
           else
              ln_imp_movdol := lc_data.cant_proyect * lc_data.importe_igv;
              ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
             
           end if;   
        
           select count(*)
             into ln_count
             from cntbl_cnta cc,
                  impuestos_tipo it
            where it.cnta_ctbl = cc.cnta_ctbl 
              and it.tipo_impuesto = PKG_LOGISTICA.is_igv;
           
           if ln_count = 0 then    
              ROLLBACK;
              RAISE_APPLICATION_ERROR(-20000, 'No se ha configurado el tipo de impuesto de IGV, o no existe '
                                           || 'en la tabla de Tipos de Impuestos, o no tiene una cuenta contable asociada. '
                                           || 'Por favor coordine con CONTABILIDAD' 
                                           || chr(13) || 'IGV: ' + NVL(PKG_LOGISTICA.is_igv, '---'));
           end if;
           
           select cc.cnta_ctbl, cc.desc_cnta, nvl(cc.flag_doc_ref, '0'), nvl(cc.flag_codrel, '0'), it.flag_dh_cxp
             into ls_cnta_cntbl, ls_desc_cnta, ls_flag_doc_ref, ls_flag_codrel, ls_flag_dh_cxp
             from cntbl_cnta cc,
                  impuestos_tipo it
            where it.cnta_ctbl = cc.cnta_ctbl 
              and it.tipo_impuesto = PKG_LOGISTICA.is_igv;
           
           -- Coloco el flag de de cod_relacion
           if ls_flag_codrel = '1' then
              ls_cod_relacion := ls_cliente;
           else
              ls_cod_relacion := null;
           end if;
           
           -- Coloco el flag de Documento de referencia
           if ls_flag_doc_ref = '1' then
              ls_tipo_docref := ls_tipo_doc;
              ls_nro_docref  := ls_nro_doc;
           else
              ls_tipo_docref := null;
              ls_nro_docref  := null;
           end if;
           
           -- Invierto el sentido del flag_dh
           if lc_data.tipo_doc_cxc <> PKG_SIGRE_FINANZAS.is_doc_ncc then
              if ls_flag_dh_cxp = 'D' then
                 ls_flag_dh_cxp := 'H';
              else
                 ls_flag_dh_cxp := 'D';
              end if;
           end if;

           select count(*)
             into ln_count
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.cnta_ctbl        = ls_cnta_cntbl
              and cad.flag_debhab      = ls_flag_dh_cxp
              and trim(nvl(cad.tipo_docref1, 'X'))  = trim(nvl(ls_tipo_docref, 'X'))
              and trim(nvl(cad.nro_docref1, 'X'))   = trim(nvl(ls_nro_docref, 'X'))
              and trim(nvl(cad.cod_relacion, 'X'))  = trim(nvl(ls_cod_relacion, 'X'));
           
           if ln_count = 0 then
              -- Inserto el nuevo registro
              select nvl(max(cad.item),0)
                into ln_item
                from cntbl_asiento_det cad
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento;
                  
              ln_item := ln_item + 1;
                  
              insert into cntbl_asiento_det(
                     origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                     det_glosa, flag_gen_aut, flag_debhab, 
                     tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol, centro_benef)
              values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fec_registro,
                     ls_desc_cnta, '0', ls_flag_dh_cxp,
                     ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol, ls_centro_benef);
                         
           else
              select cad.item
                into ln_item
                from cntbl_asiento_det cad
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento
                 and cad.cnta_ctbl        = ls_cnta_cntbl
                 and cad.flag_debhab      = ls_flag_dh_cxp
                 and nvl(cad.tipo_docref1, 'X') = nvl(ls_tipo_docref, 'X')
                 and nvl(cad.nro_docref1, 'X')  = nvl(ls_nro_docref, 'X')
                 and nvl(cad.cod_relacion, 'X') = nvl(ls_cod_relacion, 'X');
                  
              update cntbl_asiento_det cad
                 set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                     cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento
                 and cad.item             = ln_item;
                         
           end if;
           
        end if;
        
        -- Añado el impuesto de consumo de plastico, en caso que sea positivo
        if lc_data.icbper > 0 then
           
           -- Obtengo los importes
           if ls_moneda = PKG_LOGISTICA.is_soles then
              ln_imp_movsol := lc_data.icbper;
              ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
           else
              ln_imp_movdol := lc_data.icbper;
              ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
             
           end if;   
        
           select count(*)
             into ln_count
             from cntbl_cnta cc,
                  impuestos_tipo it
            where it.cnta_ctbl = cc.cnta_ctbl 
              and it.tipo_impuesto = PKG_FACT_ELECTRONICA.is_icbper;
           
           if ln_count = 0 then    
              ROLLBACK;
              RAISE_APPLICATION_ERROR(-20000, 'No se ha configurado el tipo de impuesto' || PKG_FACT_ELECTRONICA.is_icbper 
                                           || ' para el consumo de plastico, o no existe, parametro IMPUESTO_ICBPER, '
                                           || 'en la tabla de Tipos de Impuestos, o no tiene una cuenta contable asociada. '
                                           || 'Por favor coordine con CONTABILIDAD' 
                                           || chr(13) || 'ICBPER: ' || NVL(PKG_FACT_ELECTRONICA.is_icbper, '---'));
           end if;
           
           select cc.cnta_ctbl, cc.desc_cnta, nvl(cc.flag_doc_ref, '0'), nvl(cc.flag_codrel, '0'), it.flag_dh_cxp
             into ls_cnta_cntbl, ls_desc_cnta, ls_flag_doc_ref, ls_flag_codrel, ls_flag_dh_cxp
             from cntbl_cnta cc,
                  impuestos_tipo it
            where it.cnta_ctbl = cc.cnta_ctbl 
              and it.tipo_impuesto = PKG_FACT_ELECTRONICA.is_icbper;
           
           -- Coloco el flag de de cod_relacion
           if ls_flag_codrel = '1' then
              ls_cod_relacion := ls_cliente;
           else
              ls_cod_relacion := null;
           end if;
           
           -- Coloco el flag de Documento de referencia
           if ls_flag_doc_ref = '1' then
              ls_tipo_docref := ls_tipo_doc;
              ls_nro_docref  := ls_nro_doc;
           else
              ls_tipo_docref := null;
              ls_nro_docref  := null;
           end if;
           
           -- Invierto el sentido del flag_dh
           if lc_data.tipo_doc_cxc <> PKG_SIGRE_FINANZAS.is_doc_ncc then
              if ls_flag_dh_cxp = 'D' then
                 ls_flag_dh_cxp := 'H';
              else
                 ls_flag_dh_cxp := 'D';
              end if;
           end if;

           select count(*)
             into ln_count
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.cnta_ctbl        = ls_cnta_cntbl
              and cad.flag_debhab      = ls_flag_dh_cxp
              and trim(nvl(cad.tipo_docref1, 'X'))  = trim(nvl(ls_tipo_docref, 'X'))
              and trim(nvl(cad.nro_docref1, 'X'))   = trim(nvl(ls_nro_docref, 'X'))
              and trim(nvl(cad.cod_relacion, 'X'))  = trim(nvl(ls_cod_relacion, 'X'));
           
           if ln_count = 0 then
              -- Inserto el nuevo registro
              select nvl(max(cad.item),0)
                into ln_item
                from cntbl_asiento_det cad
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento;
                  
              ln_item := ln_item + 1;
                  
              insert into cntbl_asiento_det(
                     origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                     det_glosa, flag_gen_aut, flag_debhab, 
                     tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol, centro_benef)
              values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fec_registro,
                     ls_desc_cnta, '0', ls_flag_dh_cxp,
                     ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol, ls_centro_benef);
                         
           else
              select cad.item
                into ln_item
                from cntbl_asiento_det cad
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento
                 and cad.cnta_ctbl        = ls_cnta_cntbl
                 and cad.flag_debhab      = ls_flag_dh_cxp
                 and nvl(cad.tipo_docref1, 'X') = nvl(ls_tipo_docref, 'X')
                 and nvl(cad.nro_docref1, 'X')  = nvl(ls_nro_docref, 'X')
                 and nvl(cad.cod_relacion, 'X') = nvl(ls_cod_relacion, 'X');
                  
              update cntbl_asiento_det cad
                 set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                     cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento
                 and cad.item             = ln_item;
                         
           end if;
           
        end if;
        
        
        -- Añado el descuento en caso lo hubiera
        if lc_data.precio_unit = 0      and abs(lc_data.descuento) >0   and 
           lc_data.tipo_doc_ref is null and lc_data.nro_doc_ref is null then
          
           -- Obtengo los importes
           if ls_moneda = PKG_LOGISTICA.is_soles then
              ln_imp_movsol := abs(lc_data.cant_proyect * lc_data.descuento);
              ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
           else
              ln_imp_movdol := abs(lc_data.cant_proyect * lc_data.descuento);
              ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
             
           end if;   

           /***********************************************************************/
           -- Primero obtengo los parametros de la cuenta de perdida por redondeo
           /***********************************************************************/
           ls_cnta_cntbl := USP_SIGRE_CNTBL.is_cnta_cntbl_red_deb;
           
           select count(*)
             into ln_count
             from cntbl_cnta cc
            where cc.cnta_ctbl   = ls_cnta_cntbl
              and cc.flag_estado = '1';
           
           if ln_count = 0 then    
              ROLLBACK;
              RAISE_APPLICATION_ERROR(-20000, 'No se ha configurado la cuenta CONTABLE de perdida por redondeo, o no esta activo. '
                                           || 'Por favor coordine con CONTABILIDAD'); 
           end if;
           
           -- Obtengo la configuracion de la cuenta contable
           select cc.cnta_ctbl, cc.desc_cnta, nvl(cc.flag_doc_ref, '0'), nvl(cc.flag_codrel, '0'), 
                  nvl(cc.flag_cencos, '0'), nvl(cc.flag_centro_benef, '0')
             into ls_cnta_cntbl, ls_desc_cnta, ls_flag_doc_ref, ls_flag_codrel, 
                  ls_flag_cencos, ls_flag_centro_benef
             from cntbl_cnta cc
            where cc.cnta_ctbl = ls_cnta_cntbl;
           
           -- Coloco el flag de de cod_relacion
           if ls_flag_codrel = '1' then
              ls_cod_relacion := ls_cliente;
           else
              ls_cod_relacion := null;
           end if;
           
           -- Coloco el flag de Documento de referencia
           if ls_flag_doc_ref = '1' then
              ls_tipo_docref := ls_tipo_doc;
              ls_nro_docref  := ls_nro_doc;
           else
              ls_tipo_docref := null;
              ls_nro_docref  := null;
           end if;
           
           -- Solicita centros de costo
           if ls_flag_cencos = '1' then
              ls_cencos := PKG_CONFIG.USF_GET_PARAMETER('CENCOS_VTA_' || lc_data.sub_cat_art || '_' || lc_data.cod_moneda, 
                           pkg_config.USF_GET_PARAMETER('CENCOS_VTA_DEFAUL', '70101005'));
           else
              ls_cencos := null;
           end if;
                
           -- Solicita centro Beneficio
           if ls_flag_centro_benef = '1' then
              ls_centro_benef := PKG_CONFIG.USF_GET_PARAMETER('CENTRO_BENEF_VTA_' || lc_data.sub_cat_art || '_' || lc_data.cod_moneda, pkg_config.USF_GET_PARAMETER('CENTRO_BENEF_DEFAULT', '1020'));
           else
              ls_centro_benef := null;
           end if;
           
           -- Valido si el centro de costos existe
           if ls_Cencos is not null then
              select count(*)
                into ln_count
                from centros_costo cc
               where cc.cencos = ls_Cencos
                 and cc.flag_estado = '1';
              
              if ln_count = 0 then
                          
                 RAISE_APPLICATION_eRROR(-20000, 'El Centro de Costos ' || ls_Cencos || ' no existe o no se encuentra activo, por favor verifique'
                                              || chr(13) || 'CENCOS_VTA_' || lc_data.sub_cat_art || '_' || lc_data.cod_moneda || ': ' || PKG_CONFIG.USF_GET_PARAMETER('CENCOS_VTA_' || lc_data.sub_cat_art || '_' || lc_data.cod_moneda, 
                                                                                                                                         pkg_config.USF_GET_PARAMETER('CENCOS_VTA_DEFAUL', '70101005')) 
                                              || chr(13) || 'CENCOS_VTA_DEFAUL: ' || pkg_config.USF_GET_PARAMETER('CENCOS_VTA_DEFAUL', '70101005') );
              end if;
           end if;
           
           if ls_centro_benef is not null then
              select count(*)
                into ln_count
                from centro_beneficio cb
               where cb.centro_benef = ls_centro_benef
                 and cb.flag_estado = '1';
              
              if ln_count = 0 then
                 RAISE_APPLICATION_eRROR(-20000, 'El Centro de Beneficio ' || ls_centro_benef || ' no existe o no se encuentra activo, por favor verifique');
              end if;
           end if;
           
           
           -- Invierto el sentido del flag_dh
           ls_flag_dh_cxp := 'D';

           select count(*)
             into ln_count
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.cnta_ctbl        = ls_cnta_cntbl
              and cad.flag_debhab      = ls_flag_dh_cxp
              and trim(nvl(cad.cencos, 'X'))       = trim(nvl(ls_cencos, 'X'))
              and trim(nvl(cad.centro_benef, 'X')) = trim(nvl(ls_centro_benef, 'X'))
              and trim(nvl(cad.tipo_docref1, 'X')) = trim(nvl(ls_tipo_docref, 'X'))
              and trim(nvl(cad.nro_docref1, 'X'))  = trim(nvl(ls_nro_docref, 'X'))
              and trim(nvl(cad.cod_relacion, 'X')) = trim(nvl(ls_cod_relacion, 'X'));
           
           if ln_count = 0 then
              -- Inserto el nuevo registro
              select nvl(max(cad.item),0)
                into ln_item
                from cntbl_asiento_det cad
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento;
                  
              ln_item := ln_item + 1;
                  
              insert into cntbl_asiento_det(
                     origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                     det_glosa, flag_gen_aut, flag_debhab, cencos, centro_benef,
                     tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
              values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fec_registro,
                     lc_data.descripcion, '0', ls_flag_dh_cxp, ls_Cencos, ls_centro_benef,
                     ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol);
                         
           else
              select cad.item
                into ln_item
                from cntbl_asiento_det cad
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento
                 and cad.cnta_ctbl        = ls_cnta_cntbl
                 and cad.flag_debhab      = ls_flag_dh_cxp
                 and trim(nvl(cad.cencos, 'X'))       = trim(nvl(ls_cencos, 'X'))
                 and trim(nvl(cad.centro_benef, 'X')) = trim(nvl(ls_centro_benef, 'X'))
                 and trim(nvl(cad.tipo_docref1, 'X')) = trim(nvl(ls_tipo_docref, 'X'))
                 and trim(nvl(cad.nro_docref1, 'X'))  = trim(nvl(ls_nro_docref, 'X'))
                 and trim(nvl(cad.cod_relacion, 'X')) = trim(nvl(ls_cod_relacion, 'X'));
                  
              update cntbl_asiento_det cad
                 set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                     cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
               where cad.origen           = ls_origen
                 and cad.ano              = ln_year
                 and cad.mes              = ln_mes
                 and cad.nro_libro        = ln_nro_libro
                 and cad.nro_asiento      = ln_nro_asiento
                 and cad.item             = ln_item;
                         
           end if;
           
           /*****************************************************************************/
           -- Busco el documento de referencia para disminuirlo, osea ponerlo en el haber
           /****************************************************************************/
           select count(distinct cad.cnta_ctbl)
             into ln_count
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.flag_debhab      = 'D'
              and trim(nvl(cad.cod_relacion, 'X')) = trim(nvl(ls_cliente, 'X'))
              and trim(nvl(cad.tipo_docref1, 'X')) = trim(nvl(ls_tipo_doc,'X'))
              and trim(nvl(cad.nro_docref1,  'X')) = trim(nvl(ls_nro_doc, 'X'));
           
           if ln_count = 0 then
              RAISE_APPLICATION_ERROR(-20000, 'No se ha definido una cuenta contable que sea cuenta corriente. Por favor coordine con contabilida.'
                                || chr(13) || 'Cod Relacion: ' || ls_cliente
                                || chr(13) || 'Tipo Doc: '     || ls_tipo_doc
                                || chr(13) || 'Nro Doc: '      || ls_nro_doc);
           end if;   
           
           if ln_count > 1 then
              RAISE_APPLICATION_ERROR(-20000, 'Se ha definido mas de una cuenta contable como cuenta corriente, por favor verifique y corrija. Por favor coordine con contabilida.'
                                || chr(13) || 'Cod Relacion: ' || ls_cliente
                                || chr(13) || 'Tipo Doc: '     || ls_tipo_doc
                                || chr(13) || 'Nro Doc: '      || ls_nro_doc);
           end if;   

           -- Obtengo la cuenta contable del documento que es cuenta corriente
           select distinct cad.cnta_ctbl
             into ls_cnta_cntbl
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.flag_debhab      = 'D'
              and trim(nvl(cad.cod_relacion, 'X')) = trim(nvl(ls_cliente, 'X'))
              and trim(nvl(cad.tipo_docref1, 'X')) = trim(nvl(ls_tipo_doc,'X'))
              and trim(nvl(cad.nro_docref1,  'X')) = trim(nvl(ls_nro_doc, 'X'));
           
           -- Obtengo el nro de item para insertar 
           select nvl(max(cad.item),0)
             into ln_item
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento;
                  
           ln_item := ln_item + 1;
                  
           insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
           values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fec_registro,
                 lc_data.descripcion, '0', 'H',
                 ls_tipo_doc, ls_nro_doc, ls_cliente, ln_imp_movsol, ln_imp_movdol);

        end if;
        
        -- Si es un vale de descuento, genero el asiento de descuento del documento
        if lc_data.nro_vale_vd is not null then
           
           -- Calculo el importe en soles y dolares
           if lc_data.cod_moneda = PKG_LOGISTICA.is_soles then
              ln_imp_movsol := abs(lc_data.cant_proyect * (lc_data.precio_unit - lc_data.descuento + lc_data.importe_igv));
              ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
           else
              ln_imp_movdol := abs(lc_data.cant_proyect * (lc_data.precio_unit - lc_data.descuento + lc_data.importe_igv));
              ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
           end if;
              
           
           /*****************************************************************/
           -- Primero obtengo la cuenta contable de la boleta para descontarle
           /*****************************************************************/
           select count(*)
             into ln_count
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.flag_debhab      = 'D'
              and cad.cod_relacion     = ls_cliente
              and cad.tipo_docref1     = ls_tipo_doc
              and cad.nro_docref1      = ls_nro_doc;
           
           if ln_count = 0 then
              RAISE_APPLICATION_ERROR(-20000, 'No se ha configurado ninguna cuenta como cuenta corriente. Por favor verifique!' 
                                || chr(13) || 'Cod. Relacion: ' || ls_cliente
                                || chr(13) || 'Tipo Doc: ' || ls_tipo_doc
                                || chr(13) || 'Nro Doc: ' || ls_nro_doc );
           elsif ln_count > 1 then
              RAISE_APPLICATION_ERROR(-20000, 'Se han configurado ' || to_char(ln_count) || ' cuenta(s) contable(s) como '
                                           || 'cuenta corriente, cuando solo esta permitido una sola cuenta para este tipo de asientos. Por favor verifique y corrija!' 
                                || chr(13) || 'Cod. Relacion: ' || ls_cliente
                                || chr(13) || 'Tipo Doc: ' || ls_tipo_doc
                                || chr(13) || 'Nro Doc: ' || ls_nro_doc );
           end if;
           
           -- Ahora si cojo la unica cuenta que queda
           select cad.cnta_ctbl, cad.flag_debhab
             into ls_cnta_cntbl, ls_flag_debhab
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.flag_debhab      = 'D'
              and cad.cod_relacion     = ls_cliente
              and cad.tipo_docref1     = ls_tipo_doc
              and cad.nro_docref1      = ls_nro_doc;
           
           -- Invierto el flag_debhab
           if ls_flag_debhab = 'D' then
              ls_flag_debhab := 'H';
           else
              ls_flag_debhab := 'D'; 
           end if;
           
           -- Verifico si ya existe
           select count(*)
             into ln_count
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento
              and cad.flag_debhab      = ls_flag_debhab
              and cad.cod_relacion     = ls_cliente
              and cad.tipo_docref1     = ls_tipo_doc
              and cad.nro_docref1      = ls_nro_doc
              and cad.cnta_ctbl        = ls_cnta_cntbl
              and cad.det_glosa        = lc_data.descripcion;
           
           if ln_count > 0 then
               update cntbl_asiento_det cad
                  set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                      cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
                where cad.origen           = ls_origen
                  and cad.ano              = ln_year
                  and cad.mes              = ln_mes
                  and cad.nro_libro        = ln_nro_libro
                  and cad.nro_asiento      = ln_nro_asiento
                  and cad.flag_debhab      = ls_flag_debhab
                  and cad.cod_relacion     = ls_cliente
                  and cad.tipo_docref1     = ls_tipo_doc
                  and cad.nro_docref1      = ls_nro_doc
                  and cad.cnta_ctbl        = ls_cnta_cntbl
                  and cad.det_glosa        = lc_data.descripcion;
           else
               -- Obtengo el nro de item para insertar 
               select nvl(max(cad.item),0)
                 into ln_item
                 from cntbl_asiento_det cad
                where cad.origen           = ls_origen
                  and cad.ano              = ln_year
                  and cad.mes              = ln_mes
                  and cad.nro_libro        = ln_nro_libro
                  and cad.nro_asiento      = ln_nro_asiento;
                      
               ln_item := ln_item + 1;
                      
               insert into cntbl_asiento_det(
                     origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                     det_glosa, flag_gen_aut, flag_debhab, 
                     tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
               values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fec_registro,
                     lc_data.descripcion, '0', ls_flag_debhab,
                     ls_tipo_doc, ls_nro_doc, ls_cliente, ln_imp_movsol, ln_imp_movdol);
           end if;

              
           /***********************************************************************************/
           -- Segundo coloco la cuenta contable del vale de descuento para tambien descontarlo
           /***********************************************************************************/
           -- Invierto el flag_debhab
           if ls_flag_debhab = 'D' then
              ls_flag_debhab := 'H';
           else
              ls_flag_debhab := 'D'; 
           end if;
           
           -- Obtengo los datos necesarios
           select t.cod_relacion
             into ls_cod_relacion
             from zc_vales_descuento t
            where t.nro_vale_vd = lc_data.nro_vale_vd;
           
           ls_tipo_docref := PKG_FACT_ELECTRONICA.IS_DOC_VALE_DCSTO;
           ls_nro_docref  := lc_data.nro_vale_vd;
           ls_cnta_cntbl  := PKG_FACT_ELECTRONICA.is_cntbl_cnta_vd;
           
           -- Obtengo el nro de item para insertar 
           select nvl(max(cad.item),0)
             into ln_item
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento;
                  
           ln_item := ln_item + 1;
                  
           insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
           values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fec_registro,
                 lc_data.descripcion, '0', ls_flag_debhab,   
                 ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol);

        end if;
    
        -- Si es un vale de descuento, genero el asiento de provision
        if lc_data.nro_vale_vd is not null then
           pkg_fact_electronica.sp_provision_vale_dscto(lc_data.nro_vale_vd, 
                                                        abs(lc_data.cant_proyect * lc_data.precio_unit), 
                                                        abs(lc_data.cant_proyect * lc_data.importe_igv),
                                                        lc_data.nro_registro,
                                                        lc_data.nro_item,
                                                        lc_data.descripcion,
                                                        ls_cod_usr);
        end if;
        
        -- Si es una aplicación de un descuento previo entonces realizo la aplicacion
        if lc_data.tipo_doc_ref is not null and lc_data.nro_doc_ref is not null then
           /*
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
                asi_cod_usr       fs_factura_simpl_pagos.cod_usr%TYPE
              ) is
           */          
           pkg_fact_electronica.sp_aplicacion_anticipo(lc_data.nro_registro,
                                                       lc_data.nro_item,
                                                       ls_tipo_doc,
                                                       ls_nro_doc,
                                                       ls_origen,
                                                       ln_year,
                                                       ln_mes,
                                                       il_libro_ventas,
                                                       ln_nro_asiento,
                                                       ls_cod_usr);
        end if;

    
    end loop;
    
    -- Obtengo los totales del asiento
    select nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
      into ln_tot_soldeb, ln_tot_solhab, ln_tot_doldeb, ln_tot_dolhab
      from cntbl_asiento_det cad
     where cad.origen           = ls_origen
       and cad.ano              = ln_year
       and cad.mes              = ln_mes
       and cad.nro_libro        = ln_nro_libro
       and cad.nro_asiento      = ln_nro_asiento;
  
    -- Actualizo los totales en la cabecera del asiento
    update cntbl_asiento ca
       set ca.tot_soldeb = ln_tot_soldeb,
           ca.tot_solhab = ln_tot_solhab,
           ca.tot_doldeb = ln_tot_doldeb,
           ca.tot_dolhab = ln_tot_dolhab
     where ca.origen           = ls_origen
       and ca.ano              = ln_year
       and ca.mes              = ln_mes
       and ca.nro_libro        = ln_nro_libro
       and ca.nro_asiento      = ln_nro_asiento;

    -- actualizo el FK a la tabla fs_factura_smpl
    update fs_factura_simpl f
       set f.ano            = ln_year,
           f.mes            = ln_mes,
           f.nro_libro      = ln_nro_libro,
           f.nro_asiento    = ln_nro_asiento
     where f.nro_registro   = asi_registro;
         
  end ;
  
  -- Proceso que genera la aplicacion de la nota de credito en el pago de la factura
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
    asi_cod_usr       fs_factura_simpl_pagos.cod_usr%TYPE
    
  ) is
    -- Diversas variables
    ln_count           number;
    
    -- Cntbl_asiento_det
    ln_item            cntbl_Asiento_det.Item%TYPE;
    ln_imp_movsol      cntbl_asiento_det.imp_movsol%TYPE;
    ln_imp_movdol      cntbl_asiento_det.imp_movdol%TYPE;
    ls_det_glosa       cntbl_asiento_det.det_glosa%TYPE;
    ls_cod_Relacion    cntbl_asiento_det.cod_relacion%TYPE;
    ls_tipo_docref     cntbl_asiento_det.tipo_docref1%TYPE;
    ls_nro_docref      cntbl_asiento_det.nro_docref1%TYPE;
    ls_flag_debhab     cntbl_asiento_det.flag_debhab%TYPE;
    
    -- Cntbl_Asiento
    ln_tasa_cambio_ref cntas_cobrar.tasa_cambio%TYPE;
    ln_tasa_cambio     cntbl_asiento.tasa_cambio%TYPE;
    ld_fecha_cntbl     cntbl_Asiento.Fecha_Cntbl%TYPE;
    
    -- Cntbl_cnta
    ls_cnta_cntbl      cntbl_cnta.cnta_ctbl%TYPE;
    ls_desc_cnta       cntbl_cnta.desc_cnta%TYPE;
    ls_flag_doc_ref    cntbl_cnta.flag_doc_ref%TYPE;
    ls_flag_codrel     cntbl_cnta.flag_codrel%TYPE;
    
    -- Datos fs_factura_smpl
    ls_moneda_fs       fs_factura_simpl.cod_moneda%TYPE;
    ls_moneda_ref      fs_factura_simpl.cod_moneda%TYPE;
    
    -- Datos de fs_factura_simpl_det
    ls_tipo_ref        fs_factura_simpl_det.tipo_doc_cxc%TYPE;
    ls_nro_ref         fs_factura_simpl_det.nro_doc_cxc%TYPE;
    ls_cliente         fs_factura_simpl.cliente%TYPE;
    ln_importe         number;
    ln_igv             number;
    
    -- Impuestos_tipo
    ls_flag_dh_cxp     impuestos_tipo.flag_dh_cxp%TYPE;
    
  begin
    
    -- Obtengo datos de la cabecera
    select f.cod_moneda, f.cliente
      into ls_moneda_fs, ls_cliente
      from fs_factura_simpl f
     where f.nro_registro   = asi_nro_registro;
    
    select fsd.tipo_doc_cxc, fsd.nro_doc_cxc, fsd.descripcion,
           nvl(abs(fsd.cant_proyect * fsd.precio_unit), 0), 
           nvl(abs(fsd.cant_proyect * fsd.importe_igv), 0)
      into ls_tipo_ref, ls_nro_ref, ls_det_glosa,
           ln_importe,
           ln_igv
      from fs_factura_simpl_det fsd
     where fsd.nro_registro = asi_nro_registro
       and fsd.nro_item     = ani_nro_item;
  
    if ls_tipo_ref is null or ls_nro_ref is null then
       RAISE_APPLICATION_ERROR(-20000, 'No existe documento de referencia del Anticipo para deducirlo.'
                              || chr(13) || 'Nro registro: ' || asi_nro_registro
                              || chr(13) || 'Tipo Doc: ' || nvl(asi_tipo_doc, 'S/R')
                              || chr(13) || 'Nro Doc: ' || nvl(asi_nro_doc, 'S/R'));
    end if;

    -- Valido que el documento de referencia exista
    select count(*)
      into ln_count
      from cntas_cobrar cc
     where cc.tipo_doc = ls_tipo_ref
       and cc.nro_doc  = ls_nro_ref;
       
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No existe el documento en la cuentas por Cobrar, por favor verifique!.'
                              || chr(13) || 'Tipo Doc: ' || ls_tipo_ref
                              || chr(13) || 'Nro Doc: ' || ls_nro_ref);
    end if;

    select cc.cod_moneda, cc.tasa_cambio
      into ls_moneda_ref, ln_tasa_cambio_ref
      from cntas_cobrar cc
     where cc.tipo_doc = ls_tipo_ref
       and cc.nro_doc  = ls_nro_ref;
    
    -- Si no tiene asiento de APLICACION DE DOCUMENTOS entonces creo uno
    if ani_nro_asiento is null then
       RAISE_APPLICATION_ERROR(-20000, 'No se ha especificado el nro del asiento para la aplicacion de los anticipos, por favor verifique!.'
                              || chr(13) || 'Nro registro: ' || asi_nro_registro
                              || chr(13) || 'Tipo Doc: ' || nvl(asi_tipo_doc, 'S/R')
                              || chr(13) || 'Nro Doc: ' || nvl(asi_nro_doc, 'S/R'));
    end if;
    
    select ca.tasa_cambio, ca.fecha_cntbl
      into ln_tasa_cambio, ld_fecha_cntbl
      from cntbl_asiento ca
     where ca.origen      = asi_origen
       and ca.ano         = ani_year
       and ca.mes         = ani_mes
       and ca.nro_libro   = ani_nro_libro
       and ca.nro_asiento = ani_nro_asiento;

    /*****************************************/
    -- Inserto el detalle del asiento contable
    /*****************************************/
    select nvl(max(cad.item), 0)
      into ln_item
      from cntbl_asiento_det cad
     where cad.origen        = asi_origen
       and cad.ano           = ani_year
       and cad.mes           = ani_mes
       and cad.nro_libro     = ani_nro_libro
       and cad.nro_asiento   = ani_nro_Asiento;

    -- Obtenemos los importes
    if ls_moneda_fs = PKG_LOGISTICA.is_soles then
       ln_imp_movsol := ln_importe;
       ln_imp_movdol := ln_importe / ln_tasa_cambio;
    else
       ln_imp_movdol := ln_importe;
       ln_imp_movsol := ln_importe * ln_tasa_cambio;
    end if;
    
    
    /**********************************************************************************************************/
    -- PASO 1. Inserto la cuenta contable del documento de referencia es decir el anticipo
    /*********************************************************************************************************/
    -- Busco la cuenta contable del documento de referencia
    select count(distinct cad.cnta_ctbl)
      into ln_count
      from cntas_cobrar cc,
           cntbl_asiento_det cad
     where cc.origen         = cad.origen
       and cc.ano            = cad.ano
       and cc.mes            = cad.mes
       and cc.nro_libro      = cad.nro_libro
       and cc.nro_asiento    = cad.nro_Asiento
       and cc.tipo_doc       = cad.tipo_docref1
       and cc.nro_doc        = cad.nro_docref1
       and cc.tipo_doc       = ls_tipo_ref
       and cc.nro_doc        = ls_nro_ref
       and cad.flag_debhab   = 'H'
       and cad.cnta_ctbl     like '12%';
         
    if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' || ls_tipo_ref || '-' 
                                                || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_ref)
                                     || chr(13) || 'Nro de Registro: ' || asi_nro_registro || '.' 
                                     || chr(13) || 'No ha especificado una CUENTA CONTABLE de la clase 12 en el HABER como anticipo ' ||
                                        'de cobro. Por favor verifique!');
    end if;
         
    if ln_count > 1 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' || ls_tipo_ref || '-' 
                                     || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_ref)
                          || chr(13) || 'Nro de Registro: ' || asi_nro_registro || '.' 
                          || chr(13) || 'Se ha especificado mas de una CUENTA CONTABLE de la clase 12 en el HABER como anticipo ' 
                                     || 'de cobro. Por favor verifique!');
    end if;

    select distinct cad.cnta_ctbl
      into ls_cnta_cntbl
      from cntas_cobrar cc,
           cntbl_asiento_det cad
     where cc.origen         = cad.origen
       and cc.ano            = cad.ano
       and cc.mes            = cad.mes
       and cc.nro_libro      = cad.nro_libro
       and cc.nro_asiento    = cad.nro_Asiento
       and cc.tipo_doc       = cad.tipo_docref1
       and cc.nro_doc        = cad.nro_docref1
       and cc.tipo_doc       = ls_tipo_ref
       and cc.nro_doc        = ls_nro_ref
       and cad.flag_debhab   = 'H'
       and cad.cnta_ctbl     like '12%';

    
    -- Inserto la cuenta contable en el asiento
    ln_item := ln_item + 1;
                  
    insert into cntbl_asiento_det(
           origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
           det_glosa, flag_gen_aut, flag_debhab, 
           tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
    values(
           asi_origen, ani_year, ani_mes, ani_nro_libro, ani_nro_asiento, ln_item, 
           ls_cnta_cntbl, ld_fecha_cntbl,
           ls_det_glosa, '0', 'D',   
           ls_tipo_ref, ls_nro_ref, ls_cliente, ln_imp_movsol, ln_imp_movdol);
    
    /***********************************************************************************************/
    -- PASO 2. Inserto la cuenta contable de la factura simplificada
    /***********************************************************************************************/
    -- Obtenemos los importes
    if ls_moneda_fs = PKG_LOGISTICA.is_soles then
       ln_imp_movsol := ln_importe + ln_igv;
       ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
    else
       ln_imp_movdol := ln_importe + ln_igv;
       ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
    end if;

    -- Busco la cuenta contable de la factura original
    select count(distinct cad.cnta_ctbl)
      into ln_count
      from cntbl_asiento_det cad
     where cad.origen            = asi_origen
       and cad.ano               = ani_year
       and cad.mes               = ani_mes
       and cad.nro_libro         = ani_nro_libro
       and cad.nro_asiento       = ani_nro_asiento
       and cad.tipo_docref1      = asi_tipo_doc
       and trim(cad.nro_docref1) = trim(asi_nro_doc)
       and cad.flag_debhab       = 'D'
       and cad.cnta_ctbl         like '12%';
         
    if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' 
                                     || asi_tipo_doc || '-' 
                                     || pkg_fact_electronica.of_get_full_nro(asi_nro_doc) 
                          || chr(13) || 'Nro de Registro: ' || asi_nro_registro 
                          || chr(13) || 'No ha especificado una CUENTA CONTABLE de la clase 12 en el DEBE en la provisión ' 
                                     || 'del comprobante. Por favor verifique!');
    end if;
         
    if ln_count > 1 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' 
                                     || asi_tipo_doc || '-' 
                                     || pkg_fact_electronica.of_get_full_nro(asi_nro_doc) 
                          || chr(13) || 'Nro de Registro: ' || asi_nro_registro 
                          || chr(13) || 'Se ha especificado mas de una CUENTA CONTABLE de la clase 12 en el DEBE en la provisión ' 
                                     || 'del comprobante. Por favor verifique!');
    end if;

    select distinct cad.cnta_ctbl
      into ls_cnta_cntbl
      from cntbl_asiento_det cad,
           cntbl_cnta        cc
     where cad.origen            = asi_origen
       and cad.ano               = ani_year
       and cad.mes               = ani_mes
       and cad.nro_libro         = ani_nro_libro
       and cad.nro_asiento       = ani_nro_asiento
       and cad.tipo_docref1      = asi_tipo_doc
       and trim(cad.nro_docref1) = trim(asi_nro_doc)
       and cad.flag_debhab       = 'D'
       and cad.cnta_ctbl         like '12%';

    -- Inserto la cuenta contable en el asiento
    ln_item := ln_item + 1;
                  
    insert into cntbl_asiento_det(
           origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
           det_glosa, flag_gen_aut, flag_debhab, 
           tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
    values(
           asi_origen, ani_year, ani_mes, ani_nro_libro, ani_nro_asiento, ln_item, 
           ls_cnta_cntbl, ld_fecha_cntbl,
           ls_det_glosa, '0', 'H',   
           asi_tipo_doc, asi_nro_doc, ls_cliente, ln_imp_movsol, ln_imp_movdol);
    
    /***********************************************************************************************/
    -- PASO 3. Si tiene igv entonces inserto la linea de descuento del IGV
    /***********************************************************************************************/
    if ln_igv > 0 then
       -- Obtengo los importes
       if ls_moneda_fs = PKG_LOGISTICA.is_soles then
          ln_imp_movsol := ln_igv;
          ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
       else
          ln_imp_movdol := ln_igv;
          ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
               
       end if;   
          
       select count(*)
         into ln_count
         from cntbl_cnta cc,
              impuestos_tipo it
        where it.cnta_ctbl = cc.cnta_ctbl 
          and it.tipo_impuesto = PKG_LOGISTICA.is_igv;
             
       if ln_count = 0 then    
          ROLLBACK;
          RAISE_APPLICATION_ERROR(-20000, 'No se ha configurado el tipo de impuesto de IGV, o no existe '
                                       || 'en la tabla de Tipos de Impuestos, o no tiene una cuenta contable asociada. '
                                       || 'Por favor coordine con CONTABILIDAD' 
                                       || chr(13) || 'IGV: ' + NVL(PKG_LOGISTICA.is_igv, '---'));
       end if;
             
       select cc.cnta_ctbl, cc.desc_cnta, nvl(cc.flag_doc_ref, '0'), nvl(cc.flag_codrel, '0'), it.flag_dh_cxp
         into ls_cnta_cntbl, ls_desc_cnta, ls_flag_doc_ref, ls_flag_codrel, ls_flag_dh_cxp
         from cntbl_cnta cc,
              impuestos_tipo it
        where it.cnta_ctbl = cc.cnta_ctbl 
          and it.tipo_impuesto = PKG_LOGISTICA.is_igv;
             
       -- Coloco el flag de de cod_relacion
       if ls_flag_codrel = '1' then
          ls_cod_relacion := ls_cliente;
       else
          ls_cod_relacion := null;
       end if;
             
       -- Coloco el flag de Documento de referencia
       if ls_flag_doc_ref = '1' then
          ls_tipo_docref := asi_tipo_doc;
          ls_nro_docref  := asi_nro_doc;
       else
          ls_tipo_docref := null;
          ls_nro_docref  := null;
       end if;
             
       -- Invierto el sentido del flag_dh
       if asi_tipo_doc <> PKG_SIGRE_FINANZAS.is_doc_ncc then
          if ls_flag_dh_cxp = 'D' then
             ls_flag_dh_cxp := 'D';
          else
             ls_flag_dh_cxp := 'H';
          end if;
       end if;

       select count(*)
         into ln_count
         from cntbl_asiento_det cad
        where cad.origen           = asi_origen
          and cad.ano              = ani_year
          and cad.mes              = ani_mes
          and cad.nro_libro        = ani_nro_libro
          and cad.nro_asiento      = ani_nro_asiento
          and cad.cnta_ctbl        = ls_cnta_cntbl
          and cad.flag_debhab      = ls_flag_dh_cxp
          and trim(nvl(cad.tipo_docref1, 'X'))  = trim(nvl(ls_tipo_docref, 'X'))
          and trim(nvl(cad.nro_docref1, 'X'))   = trim(nvl(ls_nro_docref, 'X'))
          and trim(nvl(cad.cod_relacion, 'X'))  = trim(nvl(ls_cod_relacion, 'X'));
             
       if ln_count = 0 then
          
          -- Inserto el nuevo registro
          ln_item := ln_item + 1;
                    
          insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, 
                 cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
          values(
                 asi_origen, ani_year, ani_mes, ani_nro_libro, ani_nro_asiento, ln_item, 
                 ls_cnta_cntbl, ld_fecha_cntbl,
                 ls_desc_cnta, '0', ls_flag_dh_cxp,
                 ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol);
                           
       else
          select cad.item
            into ln_item
            from cntbl_asiento_det cad
           where cad.origen           = asi_origen
             and cad.ano              = ani_year
             and cad.mes              = ani_mes
             and cad.nro_libro        = ani_nro_libro
             and cad.nro_asiento      = ani_nro_asiento
             and cad.cnta_ctbl        = ls_cnta_cntbl
             and cad.flag_debhab      = ls_flag_dh_cxp
             and nvl(cad.tipo_docref1, 'X') = nvl(ls_tipo_docref, 'X')
             and nvl(cad.nro_docref1, 'X')  = nvl(ls_nro_docref, 'X')
             and nvl(cad.cod_relacion, 'X') = nvl(ls_cod_relacion, 'X');
                    
          update cntbl_asiento_det cad
             set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                 cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
           where cad.origen           = asi_origen
             and cad.ano              = ani_year
             and cad.mes              = ani_mes
             and cad.nro_libro        = ani_nro_libro
             and cad.nro_asiento      = ani_nro_asiento
             and cad.item             = ln_item;
                           
       end if;
           

    end if;

    /***********************************************************************************************/
    -- PASO 4. Genero el asiento por diferencia en cambio
    /***********************************************************************************************/
    if ln_tasa_cambio <> ln_tasa_cambio_ref then
       select nvl(max(cad.item), 0)
         into ln_item
         from cntbl_asiento_det cad
        where cad.origen        = asi_origen
          and cad.ano           = ani_year
          and cad.mes           = ani_mes
          and cad.nro_libro     = ani_nro_libro
          and cad.nro_asiento   = ani_nro_Asiento;

       -- Si la moneda en referencia es en soles
       if ls_moneda_ref = PKG_LOGISTICA.is_soles then
          if ln_tasa_cambio_ref < ln_tasa_cambio then
             -- Perdida por diferencia de cambio
             ln_imp_movsol  := 0;
             ln_imp_movdol  := (ln_importe + ln_igv) / ln_tasa_cambio_ref - (ln_importe + ln_igv) / ln_tasa_cambio;
             ls_cnta_cntbl  := USP_SIGRE_CNTBL.is_cc_perdida_dif;
             ls_flag_debhab := 'D';
             ls_det_glosa   := 'PERDIDA POR DIFERENCIA EN CAMBIO '  
                            || trim(to_char(ln_tasa_cambio_ref, '990.0000')) || ' >> ' 
                            || trim(to_char(ln_tasa_cambio, '990.0000'));
          else
             -- Ganancia por diferencia de cambio
             ln_imp_movsol  := 0;
             ln_imp_movdol  := (ln_importe + ln_igv) / ln_tasa_cambio - (ln_importe + ln_igv) / ln_tasa_cambio_ref;
             ls_cnta_cntbl  := USP_SIGRE_CNTBL.is_cc_ganancia_dif;
             ls_flag_debhab := 'H';
             ls_det_glosa   := 'GANANCIA POR DIFERENCIA EN CAMBIO '  
                            || trim(to_char(ln_tasa_cambio_ref, '990.0000')) || ' >> ' 
                            || trim(to_char(ln_tasa_cambio, '990.0000'));
          end if;
          
          -- Obtengo los flags adecuados de la cuenta contable
          select nvl(cc.flag_doc_ref,'0'), nvl(cc.flag_codrel,'0')
            into ls_flag_doc_ref, ls_flag_codrel
            from cntbl_cnta cc
           where cc.cnta_ctbl = ls_cnta_cntbl;
          
          if ls_flag_codrel = '1' then
             ls_cod_Relacion := ls_cliente;
          else
             ls_cod_Relacion := null;
          end if;
          
          if ls_flag_doc_ref = '1' then
             ls_tipo_docref := ls_tipo_ref;
             ls_nro_docref  := ls_nro_ref;
          else
             ls_tipo_docref := null;
             ls_nro_docref  := null;
          end if;

          -- Inserto la cuenta contable en el asiento
          ln_item := ln_item + 1;
                  
          insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
          values(
                 asi_origen, ani_year, ani_mes, ani_nro_libro, ani_nro_asiento, ln_item, 
                 ls_cnta_cntbl, ld_fecha_cntbl,
                 ls_det_glosa, '0', ls_flag_debhab,   
                 ls_tipo_docref, ls_nro_docref, ls_cod_Relacion, ln_imp_movsol, ln_imp_movdol);
          
          
          -- Ahora busco la cuenta contable de la factura correspondiente a la cuenta 12
          -- del documento de referencia
          select count(distinct cad.cnta_ctbl)
            into ln_count
            from cntas_cobrar cc,
                 cntbl_asiento_det cad
           where cc.origen         = cad.origen
             and cc.ano            = cad.ano
             and cc.mes            = cad.mes
             and cc.nro_libro      = cad.nro_libro
             and cc.nro_asiento    = cad.nro_Asiento
             and cc.tipo_doc       = cad.tipo_docref1
             and cc.nro_doc        = cad.nro_docref1
             and cc.tipo_doc       = ls_tipo_ref
             and cc.nro_doc        = ls_nro_ref
             and cad.flag_debhab   = 'D'
             and cad.cnta_ctbl     like '12%';
               
          if ln_count = 0 then
              RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' || ls_tipo_ref || '-' 
                                                      || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_ref)
                                           || chr(13) || 'Nro de Registro: ' || asi_nro_registro || '.' 
                                           || chr(13) || 'No ha especificado una CUENTA CONTABLE de la clase 12 en el DEBE en la provisión del documento. Por favor verifique!');
          end if;
               
          if ln_count > 1 then
              RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' || ls_tipo_ref || '-' 
                                           || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_ref)
                                || chr(13) || 'Nro de Registro: ' || asi_nro_registro || '.' 
                                || chr(13) || 'Se ha especificado mas de una CUENTA CONTABLE de la clase 12 en el DEBE en la provisión del documento. Por favor verifique!');
          end if;
          
          select distinct cad.cnta_ctbl, cc.observacion
            into ls_cnta_cntbl, ls_det_glosa
            from cntas_cobrar cc,
                 cntbl_asiento_det cad
           where cc.origen         = cad.origen
             and cc.ano            = cad.ano
             and cc.mes            = cad.mes
             and cc.nro_libro      = cad.nro_libro
             and cc.nro_asiento    = cad.nro_Asiento
             and cc.tipo_doc       = cad.tipo_docref1
             and cc.nro_doc        = cad.nro_docref1
             and cc.tipo_doc       = ls_tipo_ref
             and cc.nro_doc        = ls_nro_ref
             and cad.flag_debhab   = 'D'
             and cad.cnta_ctbl     like '12%';

          
          -- Inserto la cuenta contable en el asiento
          ln_item := ln_item + 1;
                    
          if ls_flag_debhab = 'D' then
             ls_flag_debhab := 'H';
          else
             ls_flag_debhab := 'D';
          end if;
                        
          insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
          values(
                 asi_origen, ani_year, ani_mes, ani_nro_libro, ani_nro_asiento, ln_item, 
                 ls_cnta_cntbl, ld_fecha_cntbl,
                 ls_det_glosa, '0', ls_flag_debhab,   
                 ls_tipo_ref, ls_nro_ref, ls_cliente, ln_imp_movsol, ln_imp_movdol);
          
       end if;
       
       -- Si la moneda en referencia es en dolares
       if ls_moneda_ref = PKG_LOGISTICA.is_dolares then
          if ln_tasa_cambio_ref > ln_tasa_cambio then
             -- Perdida por diferencia de cambio
             ln_imp_movsol  := (ln_importe + ln_igv) * ln_tasa_cambio - (ln_importe + ln_igv) * ln_tasa_cambio_ref;
             ln_imp_movdol  := 0;
             ls_cnta_cntbl  := USP_SIGRE_CNTBL.is_cc_perdida_dif;
             ls_flag_debhab := 'D';
             ls_det_glosa   := 'PERDIDA POR DIFERENCIA EN CAMBIO '  
                            || trim(to_char(ln_tasa_cambio_ref, '990.0000')) || ' >> ' 
                            || trim(to_char(ln_tasa_cambio, '990.0000'));
          else
             -- Ganancia por diferencia de cambio
             ln_imp_movsol  := (ln_importe + ln_igv) * ln_tasa_cambio_ref - (ln_importe + ln_igv) * ln_tasa_cambio;
             ln_imp_movdol  := 0;
             ls_cnta_cntbl  := USP_SIGRE_CNTBL.is_cc_ganancia_dif;
             ls_flag_debhab := 'H';
             ls_det_glosa   := 'GANANCIA POR DIFERENCIA EN CAMBIO '  
                            || trim(to_char(ln_tasa_cambio_ref, '990.0000')) || ' >> ' 
                            || trim(to_char(ln_tasa_cambio, '990.0000'));
          end if;
          
          -- Obtengo los flags adecuados de la cuenta contable
          select nvl(cc.flag_doc_ref,'0'), nvl(cc.flag_codrel,'0')
            into ls_flag_doc_ref, ls_flag_codrel
            from cntbl_cnta cc
           where cc.cnta_ctbl = ls_cnta_cntbl;
          
          if ls_flag_codrel = '1' then
             ls_cod_Relacion := ls_cliente;
          else
             ls_cod_Relacion := null;
          end if;
          
          if ls_flag_doc_ref = '1' then
             ls_tipo_docref := ls_tipo_ref;
             ls_nro_docref  := ls_nro_ref;
          else
             ls_tipo_docref := null;
             ls_nro_docref  := null;
          end if;

          -- Inserto la cuenta contable en el asiento
          ln_item := ln_item + 1;
                  
          insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
          values(
                 asi_origen, ani_year, ani_mes, ani_nro_libro, ani_nro_asiento, ln_item, 
                 ls_cnta_cntbl, ld_fecha_cntbl,
                 ls_det_glosa, '0', ls_flag_debhab,   
                 ls_tipo_docref, ls_nro_docref, ls_cod_Relacion, ln_imp_movsol, ln_imp_movdol);
          
          
          -- Ahora busco la cuenta contable de la factura correspondiente a la cuenta 12
          -- del documento de referencia
          select count(distinct cad.cnta_ctbl)
            into ln_count
            from cntas_cobrar cc,
                 cntbl_asiento_det cad
           where cc.origen         = cad.origen
             and cc.ano            = cad.ano
             and cc.mes            = cad.mes
             and cc.nro_libro      = cad.nro_libro
             and cc.nro_asiento    = cad.nro_Asiento
             and cc.tipo_doc       = cad.tipo_docref1
             and cc.nro_doc        = cad.nro_docref1
             and cc.tipo_doc       = ls_tipo_ref
             and cc.nro_doc        = ls_nro_ref
             and cad.flag_debhab   = 'D'
             and cad.cnta_ctbl     like '12%';
               
          if ln_count = 0 then
              RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' || ls_tipo_ref || '-' 
                                                      || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_ref)
                                           || chr(13) || 'Nro de Registro: ' || asi_nro_registro || '.' 
                                           || chr(13) || 'No ha especificado una CUENTA CONTABLE de la clase 12 en el DEBE en la provisión del documento. Por favor verifique!');
          end if;
               
          if ln_count > 1 then
              RAISE_APPLICATION_ERROR(-20000, 'Error en la provisión del Comprobante ' || ls_tipo_ref || '-' 
                                           || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_ref)
                                || chr(13) || 'Nro de Registro: ' || asi_nro_registro || '.' 
                                || chr(13) || 'Se ha especificado mas de una CUENTA CONTABLE de la clase 12 en el DEBE en la provisión del documento. Por favor verifique!');
          end if;
          
          select distinct cad.cnta_ctbl, cc.observacion
            into ls_cnta_cntbl, ls_det_glosa
            from cntas_cobrar cc,
                 cntbl_asiento_det cad
           where cc.origen         = cad.origen
             and cc.ano            = cad.ano
             and cc.mes            = cad.mes
             and cc.nro_libro      = cad.nro_libro
             and cc.nro_asiento    = cad.nro_Asiento
             and cc.tipo_doc       = cad.tipo_docref1
             and cc.nro_doc        = cad.nro_docref1
             and cc.tipo_doc       = ls_tipo_ref
             and cc.nro_doc        = ls_nro_ref
             and cad.flag_debhab   = 'D'
             and cad.cnta_ctbl     like '12%';

          
          -- Inserto la cuenta contable en el asiento
          ln_item := ln_item + 1;
          
          if ls_flag_debhab = 'D' then
             ls_flag_debhab := 'H';
          else
             ls_flag_debhab := 'D';
          end if;
                        
          insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
          values(
                 asi_origen, ani_year, ani_mes, ani_nro_libro, ani_nro_asiento, ln_item, 
                 ls_cnta_cntbl, ld_fecha_cntbl,
                 ls_det_glosa, '0', ls_flag_debhab,   
                 ls_tipo_ref, ls_nro_ref, ls_cliente, ln_imp_movsol, ln_imp_movdol);
          
       end if;

    end if;
    
  end ;
  
  
  
  /*
  *   ***************************************************************************
  *   Este procedimiento genera el asiento de provision del Vale de Descuento
  *   Si la factura a la que hace referencia tiene mas de un a?o de antiguedad
  *   entonces el IGV ya no es deducible y pasa a ser un gasto 
  *   ***************************************************************************
  */
  procedure sp_provision_vale_dscto(
    asi_vale_vd        zc_vales_descuento.nro_vale_vd%TYPE, 
    ani_base_imponible cntbl_asiento_det.imp_movsol%TYPE, 
    ani_igv            cntbl_asiento_det.imp_movsol%TYPE,
    asi_nro_registro   fs_factura_simpl_det.nro_registro%TYPE,
    ani_nro_item       fs_factura_simpl_det.nro_item%TYPE,
    asi_descripcion    fs_factura_simpl_det.descripcion%TYPE,
    asi_cod_usr        fs_factura_simpl.cod_usr%TYPE
  ) is
  
    -- Variables
    ld_fecha_vd        zc_vales_descuento.fec_vale%TYPE;
    ls_cliente_vd      zc_vales_descuento.cod_relacion%TYPE;
    ld_fecha_fac       cntas_cobrar.fecha_documento%TYPE;
    ls_tipo_doc        cntas_cobrar.tipo_doc%TYPE;
    ls_nro_doc         cntas_cobrar.nro_doc%TYPE;
    ln_count           number;
    ld_fecha           date;
    ls_periodo         varchar2(10);
    
    -- Cabecera de la factura simplificada
    ld_fecha_fs        fs_factura_simpl.fec_registro%TYPE;
    ls_moneda_fs       fs_factura_simpl.cod_moneda%TYPE;
    ln_tasa_cambio     fs_factura_simpl.tasa_cambio%TYPE;
    
    -- Datos para la cabecera del asiento contable
    ls_origen          cntbl_asiento.origen%TYPE;
    ln_year            cntbl_asiento.ano%TYPE;
    ln_mes             cntbl_asiento.mes%TYPE;
    ln_nro_Asiento     cntbl_Asiento.Nro_Asiento%TYPE;
    
    -- Datos para el detalle del asiento contable
    ls_tipo_docref     cntbl_Asiento_det.Tipo_Docref1%TYPE;
    ls_nro_docref      cntbl_asiento_det.nro_docref1%TYPE;
    ls_cod_relacion    cntbl_asiento_det.cod_relacion%TYPE;
    ls_cnta_cntbl      cntbl_Asiento_Det.Cnta_Ctbl%TYPE;
    ln_item            cntbl_asiento_det.item%TYPE := 0;
    ln_imp_movsol      cntbl_asiento_det.imp_movsol%TYPE;
    ln_imp_movdol      cntbl_asiento_det.imp_movdol%TYPE;
    ls_desc_cnta       cntbl_cnta.desc_cnta%TYPE;
    ls_det_glosa       cntbl_asiento_det.det_glosa%TYPE;

    -- Totales de los asientos
    ln_tot_soldeb    cntbl_asiento.tot_soldeb%TYPE;
    ln_tot_solhab    cntbl_asiento.tot_solhab%TYPE;
    ln_tot_doldeb    cntbl_asiento.tot_doldeb%TYPE;
    ln_tot_dolhab    cntbl_asiento.tot_dolhab%TYPE;
  
  
  begin
    -- Obtengo los datos necesarios de la cabecera de la factura simplificada
    select f.fec_movimiento, f.cod_moneda, f.tasa_cambio
      into ld_fecha_fs, ls_moneda_fs, ln_tasa_cambio
      from fs_factura_simpl f
     where f.nro_registro = asi_nro_registro;
     
    -- Verifico si el vale de descuento tiene una factura asociada
    select z.fec_vale, z.tipo_doc, z.nro_doc, z.cod_origen, z.cod_relacion
      into ld_fecha_vd, ls_tipo_doc, ls_nro_doc, ls_origen, ls_cliente_vd
      from zc_vales_descuento z
     where z.nro_vale_vd = asi_vale_vd;
    
    -- Si tiene referencia a una factura obtengo la fecha de la factura
    if ls_tipo_doc is not null and ls_nro_doc is not null then
       select count(*)
         into ln_count
         from cntas_cobrar cc
        where cc.tipo_doc = ls_tipo_doc
          and cc.nro_doc  = ls_nro_doc;
       
       if ln_count = 0 then
          RAISE_APPLICATION_ERROR(-20000, 'No existe el documento ' || ls_tipo_doc || '-' || ls_nro_doc || ' como documento en CNTAS_COBRAR. Por favor verifique!');
       end if;
       
       select trunc(cc.fecha_documento)
         into ld_fecha_fac
         from cntas_cobrar cc
        where cc.tipo_doc = ls_tipo_doc
          and cc.nro_doc  = ls_nro_doc;
    end if;
    
    -- Obtengo le fecha adecuada
    if ld_fecha_fac is not null then
       ld_fecha := ld_fecha_fac;
    else
       ld_fecha := ld_fecha_vd;
    end if;
    
    -- Verifico si el libro contable de provision del Vale de Descuento existe
    select count(*)
      into ln_count
      from cntbl_libro cl
     where cl.nro_libro = PKG_FACT_ELECTRONICA.il_libro_prov_vd;
    
    if ln_count = 0 then
       INSERT INTO cntbl_libro(
              nro_libro, desc_libro, num_provisional)
       values(
              PKG_FACT_ELECTRONICA.il_libro_prov_vd, 'PROVISION DE VALES DE DESCUENTO', 1);
    end if;
    
    -- Verifico si existe el asiento contable o tengo que crearlo para ello lo busco en la tabla 
    select count(*)
      into ln_count
      from zc_vales_descuento_asiento za
     where za.nro_vale_vd      = asi_vale_vd
       and za.nro_registro_ref = asi_nro_registro
       and za.nro_item_ref     = ani_nro_item;
    
    if ln_count = 0 then
       
       -- Obtengo el periodo de provision, que es el mismo de la factura simplificada
       ln_year := to_number(to_char(ld_fecha_fs, 'yyyy'));
       ln_mes  := to_number(to_char(ld_fecha_fs, 'mm'));
      
       -- Obtengo el siguiente numerador del asiento
       select count(*)
         into ln_count
         from cntbl_libro_mes clm
        where clm.origen    = ls_origen
          and clm.nro_libro = PKG_FACT_ELECTRONICA.il_libro_prov_vd
          and clm.ano       = ln_year
          and clm.mes       = ln_mes;
       
       if ln_count = 0 then
          insert into CNTBL_LIBRO_MES(
                 ORIGEN, NRO_LIBRO, ANO, MES, NRO_ASIENTO)
          values(
                 ls_origen, PKG_FACT_ELECTRONICA.il_libro_prov_vd, ln_year, ln_mes, 1);
       end if;
       
       select clm.nro_asiento
         into ln_nro_Asiento
         from cntbl_libro_mes clm
        where clm.origen    = ls_origen
          and clm.nro_libro = PKG_FACT_ELECTRONICA.il_libro_prov_vd
          and clm.ano       = ln_year
          and clm.mes       = ln_mes for update;
       
       -- Creo la cabecera del nuevo asiento
       insert into cntbl_asiento(
               origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, desc_glosa, fecha_cntbl, fec_registro, 
               cod_usr, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf)
        values(
               ls_origen, ln_year, ln_mes, il_libro_prov_vd, ln_nro_asiento, ls_moneda_fs, ln_Tasa_cambio, asi_descripcion, ld_fecha_fs, sysdate,
               asi_cod_usr, '1', 0, 0, 0, 0, '0');

       -- Actualizo el numerador
       update cntbl_libro_mes clm
          set clm.nro_asiento = ln_nro_Asiento + 1
        where clm.origen    = ls_origen
          and clm.nro_libro = PKG_FACT_ELECTRONICA.il_libro_prov_vd
          and clm.ano       = ln_year
          and clm.mes       = ln_mes;
       
       -- Inserto la referencia
       insert into ZC_VALES_DESCUENTO_ASIENTO(
              NRO_VALE_VD, ORIGEN, ANO, MES, NRO_LIBRO, NRO_ASIENTO, NRO_REGISTRO_REF, NRO_ITEM_REF)
       values(
              asi_vale_vd, ls_origen, ln_year, ln_mes, il_libro_prov_vd, ln_nro_Asiento, asi_nro_registro, ani_nro_item);
              
    else
       -- Obtengo los datos del voucher 
       select za.origen, za.ano, za.mes, za.nro_asiento
         into ls_origen, ln_year, ln_mes, ln_nro_Asiento 
         from zc_vales_descuento_asiento za
        where za.nro_vale_vd      = asi_vale_vd
          and za.nro_registro_ref = asi_nro_registro
          and za.nro_item_ref     = ani_nro_item;
          
       -- Elimino el detalle del comprobante
       delete cntbl_asiento_det cad
        where cad.origen        = ls_origen
          and cad.ano           = ln_year
          and cad.mes           = ln_mes
          and cad.nro_libro     = il_libro_prov_vd
          and cad.nro_asiento   = ln_nro_asiento;
    end if;
    
    /*****************************************/
    -- Inserto el detalle del asiento contable
    /*****************************************/
    
    /***********************************************************************************************/
    -- PASO 1. Inserto la cuenta contable de la factura a la que hace referencia el vale de descuento
    /***********************************************************************************************/
    
    -- Busco la cuenta contable de la factura original
    if ls_tipo_doc is not null and ls_nro_doc is not null then
       select count(*)
         into ln_count
         from cntas_cobrar cc,
              cntbl_asiento_det cad
        where cc.origen         = cad.origen
          and cc.ano            = cad.ano
          and cc.mes            = cad.mes
          and cc.nro_libro      = cad.nro_libro
          and cc.nro_asiento    = cad.nro_Asiento
          and cc.tipo_doc       = ls_tipo_doc
          and cc.nro_doc        = ls_nro_doc
          and cad.flag_debhab   = 'H'
          and cad.cnta_ctbl     like '12%';
       
       if ln_count = 0 then
          RAISE_APPLICATION_ERROR(-20000, 'Error en la provision del Comprobante ' || ls_tipo_doc || '-' || ls_nro_doc ||
                                          'No ha especificado una cuenta correcta de la clase 12 en el Haber para provisionar ' ||
                                          'el vale de descuento. Por favor verifique!');
       end if;
       
       select cad.cnta_ctbl, cad.tipo_docref1, cad.nro_docref1, cad.cod_relacion, cad.det_glosa
         into ls_cnta_cntbl, ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ls_det_glosa
         from cntas_cobrar cc,
              cntbl_asiento_det cad
        where cc.origen         = cad.origen
          and cc.ano            = cad.ano
          and cc.mes            = cad.mes
          and cc.nro_libro      = cad.nro_libro
          and cc.nro_asiento    = cad.nro_Asiento
          and cc.tipo_doc       = ls_tipo_doc
          and cc.nro_doc        = ls_nro_doc
          and cad.flag_debhab   = 'H'
          and cad.cnta_ctbl     like '12%'
          and rownum            = 1;
    else
       ls_cnta_cntbl   := is_cc_dscto_institucion;
       ls_tipo_docref  := PKG_FACT_ELECTRONICA.IS_DOC_VALE_DCSTO;
       ls_nro_docref   := asi_vale_vd;
       ls_cod_relacion := ls_cliente_vd;
       
       select cc.desc_cnta
         into ls_det_glosa
         from cntbl_cnta cc
        where cc.cnta_ctbl = ls_cnta_cntbl;
    end if;
    
    -- Obtenemos los importes
    if ls_moneda_fs = PKG_LOGISTICA.is_soles then
       ln_imp_movsol := ani_base_imponible;
       ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
    else
       ln_imp_movdol := ani_base_imponible;
       ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
    end if;
    
    -- Inserto la cuenta contable en el asiento
    ln_item := ln_item + 1;
                  
    insert into cntbl_asiento_det(
           origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
           det_glosa, flag_gen_aut, flag_debhab, 
           tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
    values(
           ls_origen, ln_year, ln_mes, il_libro_prov_vd, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fecha_fs,
           ls_det_glosa, '0', 'D',   
           ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol);
    
    /**********************************************************************************************************/
    -- PASO 2. Inserto la cuenta contable del IGV, si el periodo es menor a un a?o, entonces se carga a una 40, 
    -- si pasa mas del a?o se carga al gasto
    /*********************************************************************************************************/
    
    -- Determino el maximo periodo
    ls_periodo := trim(to_char(to_number(to_char(ld_fecha, 'yyyy')) + 1, '0000')) || trim(to_char(ld_fecha, 'mm'));
    
    if trim(to_char(ld_fecha_fs, 'yyyymm')) <= ls_periodo then
       select it.cnta_ctbl
         into ls_cnta_cntbl
         from impuestos_tipo it
        where it.tipo_impuesto = PKG_LOGISTICA.is_igv;
       
       if ls_cnta_cntbl is null then
          RAISE_APPLICATION_ERROR(-20000, 'No ha especificado la cuenta contable para el tipo de impuesto [' || PKG_LOGISTICA.is_igv || ']. Por favor verifique!');
       end if;
       
    else
       -- Si ha pasado mas de un a?o, entonces pasa al gasto
       ls_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_igv_gasto;
    end if; 
    
    select cc.desc_cnta
      into ls_desc_cnta
      from cntbl_cnta cc
     where cc.cnta_ctbl = ls_cnta_cntbl;
    
    ls_tipo_docref  := PKG_FACT_ELECTRONICA.IS_DOC_VALE_DCSTO;
    ls_nro_docref   := asi_vale_vd;
    ls_cod_relacion := null;
    
    -- Obtenemos los importes
    if ls_moneda_fs = PKG_LOGISTICA.is_soles then
       ln_imp_movsol := ani_igv;
       ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
    else
       ln_imp_movdol := ani_igv;
       ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
    end if;
    
    -- Inserto la cuenta contable en el asiento
    ln_item := ln_item + 1;
                  
    insert into cntbl_asiento_det(
           origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
           det_glosa, flag_gen_aut, flag_debhab, 
           tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
    values(
           ls_origen, ln_year, ln_mes, il_libro_prov_vd, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fecha_fs,
           ls_desc_cnta, '0', 'D',   
           ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol);

    /***********************************************************************************************/
    -- PASO 3. Inserto la cuenta contable del vale de descuento 
    /***********************************************************************************************/
    ls_cnta_cntbl   := is_cntbl_cnta_vd;
    ls_tipo_docref  := PKG_FACT_ELECTRONICA.IS_DOC_VALE_DCSTO;
    ls_nro_docref   := asi_vale_vd;
    ls_cod_relacion := ls_cliente_vd;

    -- Obtenemos los importes
    if ls_moneda_fs = PKG_LOGISTICA.is_soles then
       ln_imp_movsol := ani_base_imponible + ani_igv;
       ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
    else
       ln_imp_movdol := ani_base_imponible + ani_igv;
       ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
    end if;
    
    -- Inserto la cuenta contable en el asiento
    ln_item := ln_item + 1;
                  
    insert into cntbl_asiento_det(
           origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
           det_glosa, flag_gen_aut, flag_debhab, 
           tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
    values(
           ls_origen, ln_year, ln_mes, il_libro_prov_vd, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fecha_fs,
           asi_descripcion, '0', 'H',   
           ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol);

    
    -- Obtengo los totales del asiento
    select nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
      into ln_tot_soldeb, ln_tot_solhab, ln_tot_doldeb, ln_tot_dolhab
      from cntbl_asiento_det cad
     where cad.origen           = ls_origen
       and cad.ano              = ln_year
       and cad.mes              = ln_mes
       and cad.nro_libro        = il_libro_prov_vd
       and cad.nro_asiento      = ln_nro_asiento;
    
    -- Actualizo los totales del asiento contable generado
    update cntbl_asiento ca
       set ca.tot_soldeb = ln_tot_soldeb,
           ca.tot_solhab = ln_tot_solhab,
           ca.tot_doldeb = ln_tot_doldeb,
           ca.tot_dolhab = ln_tot_dolhab
     where ca.origen           = ls_origen
       and ca.ano              = ln_year
       and ca.mes              = ln_mes
       and ca.nro_libro        = il_libro_prov_vd
       and ca.nro_asiento      = ln_nro_asiento;
    
  end;

  
  procedure sp_fs_cntas_cobrar	(
    asi_registro fs_factura_simpl.nro_registro%TYPE 
  )is
    
    --Elementos de la cabecera del comprobante 
    ls_serie_cxc               fs_factura_simpl.serie_cxc%TYPE;
    ls_nro_cxc                 fs_factura_simpl.nro_cxc%TYPE;
    ls_moneda                  fs_factura_simpl.cod_moneda%TYPE;
    ld_fec_registro            fs_factura_simpl.fec_registro%TYPE;
    ln_tasa_cambio             fs_factura_simpl.tasa_cambio%TYPE;
    ls_obs                     fs_factura_simpl.observacion%TYPE;
    ls_cod_usr                 fs_factura_simpl.cod_usr%TYPE;
    ls_origen                  fs_factura_simpl.cod_origen%TYPE;
    ls_cliente                 fs_factura_simpl.cliente%TYPE;
    ls_tipo_doc                fs_factura_simpl.tipo_doc_cxc%TYPE;
    ls_punto_venta             fs_factura_simpl.punto_venta%TYPE;
    ls_vendedor                fs_factura_simpl.vendedor%TYPE;
    ln_item_dir                fs_factura_simpl.item_direccion%TYPE;
    ls_tipo_doc_ref            fs_factura_simpl.tipo_doc_ref%TYPE;
    ls_nro_doc_ref             fs_factura_simpl.nro_doc_ref%TYPE;
    ls_nro_registro_ref        fs_factura_simpl.nro_registro_ref%TYPE;
    ls_origen_ref              fs_factura_simpl.cod_origen%TYPE;
    ln_importe_ref             doc_referencias.importe%TYPE;
    ls_proveedor_ref           fs_factura_simpl.cliente%TYPE;
    ls_nro_envio_id            fs_factura_simpl.nro_envio_id%TYPE;
    ls_nro_rc_id               fs_factura_simpl.nro_rc_id%TYPE;
    ls_nro_ra_id               fs_factura_simpl.nro_ra_id%TYPE;
    
    --Cabecera de Cuentas x Cobrar
    ls_forma_pago              cntas_cobrar.forma_pago%TYPE;
    ld_fec_vencimiento         cntas_cobrar.fecha_vencimiento%TYPE;
    ld_fec_documento           cntas_cobrar.fecha_documento%TYPE;

    -- Detalle del asiento contable
    ls_nro_doc             cntas_cobrar.nro_doc%TYPE;
    ln_year                cntbl_asiento.ano%TYPE;
    ln_mes                 cntbl_asiento.mes%TYPE;
    ln_nro_asiento         cntbl_asiento.nro_asiento%TYPE;
    ln_count               number;
    ln_saldo_sol           cntas_cobrar.saldo_sol%TYPE;
    ln_saldo_dol           cntas_cobrar.saldo_dol%TYPE;
    ln_importe_doc         cntas_cobrar.importe_doc%TYPE;
    ln_base_imponible      cntas_cobrar.importe_doc%TYPE;
    
    -- Detalle de cuentas x cobrar
    ln_item               cntas_cobrar_det.item%TYPE;
    ls_tipo_cred_fiscal   cntas_cobrar_det.tipo_cred_fiscal%TYPE;
    ls_Cencos             cntas_cobrar_det.cencos%TYPE;
    ls_centro_benef       cntas_cobrar_det.centro_benef%TYPE;
    ls_confin             cntas_cobrar_det.confin%TYPE;
    ls_org_amp_Ref        cntas_cobrar_det.org_amp_ref%TYPE;
    ln_nro_amp_ref        cntas_cobrar_det.nro_amp_ref%TYPE;
    
    cursor c_data  is
      select fd.cod_art,
             fd.cod_servicio,
             fd.descripcion,
             fd.cant_proyect,
             fd.precio_unit,
             fd.descuento,
             fd.flag_afecto_igv,
             fd.importe_igv,
             fd.icbper,
             fd.nro_registro,
             fd.nro_item,
             fd.org_am,
             fd.nro_vale_vd,
             fd.nro_am,
             case  
              when a.sub_cat_art is not null then
                   a.sub_cat_art
              when fd.cod_servicio is not null then
                   fd.cod_servicio
              when fd.precio_unit - fd.descuento < 0 then
                   'DSCTO'
              else
                 null
             end as sub_cat_art,
             f.cod_origen,
             f.tipo_doc_cxc,
             f.nro_cxc,
             f.cliente,
             f.fec_movimiento,
             f.cod_moneda,
             a.und,
             a.und2,
             f.cod_usr,
             fd.nro_proforma,
             fd.item_proforma
        from fs_factura_simpl     f,
             fs_factura_simpl_det fd,
             articulo             a
       where f.nro_registro  = fd.nro_registro
         and fd.cod_art      = a.cod_art        (+)
         and fd.nro_registro = asi_registro
       order by fd.nro_item;
  begin 
    -- Obtengo datos necesarios
    select f.cod_origen, f.cod_moneda, f.fec_movimiento, f.fec_registro, f.tasa_cambio, f.serie_cxc, f.nro_cxc,
           f.cliente, f.tipo_doc_cxc, f.ano, f.mes, f.nro_asiento,
           f.punto_venta, f.vendedor, f.item_direccion, 
           f.tipo_doc_ref, f.nro_doc_ref, f.nro_registro_ref,
           f.nro_envio_id, f.nro_rc_id, f.nro_ra_id, f.observacion, f.cod_usr
      into ls_origen, ls_moneda, ld_fec_documento, ld_fec_registro, ln_tasa_cambio, ls_serie_cxc, ls_nro_cxc,
           ls_cliente, ls_tipo_doc, ln_year, ln_mes, ln_nro_asiento,
           ls_punto_venta, ls_vendedor, ln_item_dir,
           ls_tipo_doc_ref, ls_nro_doc_ref, ls_nro_registro_ref,
           ls_nro_envio_id, ls_nro_rc_id, ls_nro_ra_id, ls_obs, ls_cod_usr
      from fs_factura_simpl f
     where f.nro_registro = asi_registro;
     
     
    -- Obtengo el nro de documento
    ls_nro_doc    := PKG_FACT_ELECTRONICA.of_get_nro_doc(ls_serie_cxc, ls_nro_cxc);
    ls_forma_pago := PKG_FACT_ELECTRONICA.of_get_cod_forma_pago(asi_registro, ld_fec_vencimiento);
    
    -- Obtengo los saldos del documento asi como el importe total, y la base imponible
    select nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv) + fd.icbper), 0),
           nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento )),0)
      into ln_importe_doc, ln_base_imponible
      from fs_factura_simpl_det fd
     where fd.nro_registro = asi_registro;
     
    if ls_moneda = PKG_LOGISTICA.is_soles then
       ln_saldo_sol := ln_importe_doc;
       ln_saldo_dol := ln_saldo_sol / ln_tasa_cambio;
    else
       ln_saldo_dol := ln_importe_doc;
       ln_saldo_sol := ln_saldo_dol * ln_tasa_cambio;
    end if;
    
    select count(*)
      into ln_count
      from cntas_cobrar cc
     where cc.tipo_doc = ls_tipo_doc
       and cc.nro_doc  = ls_nro_doc;
       
    if ln_count = 0 then
       -- Inserto en la cabecera de cntas_cobrar
       insert into cntas_cobrar(
               tipo_doc, nro_doc, cod_relacion, flag_estado, fecha_registro, punto_venta, fecha_documento, 
               fecha_vencimiento, cod_moneda, tasa_cambio, forma_pago, 
               origen, ano, mes, nro_libro, nro_asiento, 
               observacion,  fecha_presentacion, flag_provisionado, saldo_sol, saldo_dol, importe_doc, vendedor, 
               flag_detraccion, item_direccion, flag_control_reg, flag_caja_bancos, 
               nro_rc_id, nro_envio_id, nro_ra_id, nro_registro_fs, cod_usr)
       values(
               ls_tipo_doc, ls_nro_doc, ls_cliente, '1', sysdate, ls_punto_venta, ld_fec_documento, 
               ld_fec_vencimiento, ls_moneda, ln_tasa_cambio, ls_forma_pago, 
               ls_origen, ln_year, ln_mes, il_libro_ventas, ln_nro_asiento, 
               ls_obs, ld_fec_registro, 'R', ln_saldo_sol, ln_saldo_dol, ln_importe_doc, ls_vendedor,
               '0', ln_item_dir, '0', '0',
               ls_nro_rc_id, ls_nro_envio_id, ls_nro_ra_id, asi_registro, ls_cod_usr);
    else
       delete cc_doc_det_imp ci
       where ci.tipo_doc = ls_tipo_doc
         and ci.nro_doc  = ls_nro_doc;
         
       delete cntas_cobrar_det ccd
       where ccd.tipo_doc = ls_tipo_doc
         and ccd.nro_doc  = ls_nro_doc;
       
       delete doc_referencias dr
       where dr.tipo_doc = ls_tipo_doc
         and dr.nro_doc  = ls_nro_doc;
       
       update cntas_cobrar cc
          set cc.nro_envio_id = ls_nro_envio_id,
              cc.nro_rc_id    = ls_nro_rc_id,
              cc.nro_ra_id    = ls_nro_ra_id,
              cc.saldo_sol    = ln_saldo_sol,
              cc.saldo_dol    = ln_saldo_dol,
              cc.importe_doc  = ln_importe_doc,
              cc.nro_registro_fs = asi_registro,
              cc.fecha_vencimiento = ld_fec_vencimiento,
              cc.fecha_registro    = ld_fec_registro,
              cc.fecha_documento   = ld_fec_documento,
              cc.forma_pago        = ls_forma_pago,
              cc.observacion       = ls_obs,
              cc.origen            = ls_origen,
              cc.ano               = ln_year,
              cc.mes               = ln_mes,
              cc.nro_libro         = il_libro_ventas,
              cc.nro_asiento       = ln_nro_Asiento,
              cc.cod_relacion      = ls_cliente
       where cc.tipo_doc = ls_tipo_doc
         and cc.nro_doc  = ls_nro_doc;

    end if;
    
    -- Insertar la referencia en caso sea un documento de referencia
    if ls_nro_registro_ref is not null then
       
       -- Obtengo el origen de la referencia asi como el importe
       select f.tipo_doc_cxc, 
              decode(f.nro_doc_cxc, null, PKG_FACT_ELECTRONICA.of_get_nro_doc(f.serie_cxc, f.nro_cxc), f.nro_doc_cxc) as nro_doc_cxc,
              f.cod_origen, f.cliente
         into ls_tipo_doc_ref, 
              ls_nro_doc_ref, 
              ls_origen_ref, 
              ls_proveedor_ref
         from fs_factura_simpl f
        where f.nro_registro = ls_nro_registro_ref;
       
       -- Obtengo el importe total
       select nvl(sum(fd.cant_proyect * (fd.precio_unit - fd.descuento + fd.importe_igv)), 0)
         into ln_importe_ref
         from fs_factura_simpl_det fd
        where fd.nro_registro = ls_nro_registro_ref;
        
       insert into doc_referencias(
               cod_relacion, tipo_doc, nro_doc, tipo_mov, origen_ref, tipo_ref, nro_ref, importe, flab_tabor, proveedor_ref)
       values(
               ls_cliente, ls_tipo_doc, ls_nro_doc, 'C', ls_origen_ref, ls_tipo_doc_ref, ls_nro_doc_ref, ln_importe_ref, '9', ls_proveedor_ref);
    else
       ls_tipo_doc_ref := null;
       ls_nro_doc_ref  := null;
    end if; 
    
    -- Recorro el detalle del comprobante
    for lc_Reg in c_data loop
        -- Obtengo las referencias de AMP
        select count(*)
          into ln_count
          from orden_venta       ov,
               articulo_mov_proy amp
         where amp.nro_doc       = ov.nro_ov
           and amp.tipo_doc      = is_doc_ov
           and amp.nro_proforma  = lc_reg.nro_proforma
           and amp.item_proforma = lc_reg.item_proforma
           and ov.flag_estado    <> '0'
           and amp.flag_estado   <> '0';
        
        if ln_count > 0 then
           -- Obtengo las referencias de AMP
           select amp.cod_origen, amp.nro_mov
             into ls_org_amp_Ref, ln_nro_amp_ref
             from orden_venta       ov,
                  articulo_mov_proy amp
            where amp.nro_doc       = ov.nro_ov
              and amp.tipo_doc      = is_doc_ov
              and amp.nro_proforma  = lc_reg.nro_proforma
              and amp.item_proforma = lc_reg.item_proforma
              and ov.flag_estado    <> '0'
              and amp.flag_estado   <> '0';
        else
           ls_org_amp_ref := null;
           ln_nro_amp_ref := null;
        end if;

        select nvl(max(ccd.item), 0)
          into ln_item
          from cntas_cobrar_det ccd
         where tipo_doc    = ls_tipo_doc
           and nro_doc     = ls_nro_doc;
        
        ln_item := ln_item + 1;
        
        -- Obtenogo la matriz contable
        ls_confin := PKG_CONFIG.OF_MATRIZ_VTA(lc_reg.tipo_doc_cxc, lc_reg.sub_cat_art, lc_reg.cod_moneda, 'CC-001'); --('MATRIZ_VTA_' || lc_reg.sub_cat_art || '_' || lc_reg.cod_moneda, 'CC-001');
        
        -- Solicita centros de costo
        ls_cencos := PKG_CONFIG.OF_CENCOS_VTA(lc_reg.tipo_doc_cxc,lc_reg.sub_cat_art, lc_reg.cod_moneda, pkg_config.USF_GET_PARAMETER('CENCOS_VTA_DEFAUL', '70101005'));--('CENCOS_VTA_' || lc_reg.sub_cat_art || '_' || lc_reg.cod_moneda, '50202001');
        
        -- Solicita centro Beneficio
        ls_centro_benef := PKG_CONFIG.OF_CENTRO_BENEF_VTA(lc_reg.tipo_doc_cxc,lc_reg.sub_cat_art, lc_reg.cod_moneda, pkg_config.USF_GET_PARAMETER('CENTRO_BENEF_DEFAULT', '1020'));--USF_GET_PARAMETER('CENTRO_BENEF_VTA_' || lc_reg.sub_cat_art || '_' || lc_reg.cod_moneda, '2020');
        
        select count(*)
          into ln_count
          from centro_beneficio cb
         where cb.centro_benef = ls_centro_benef
           and cb.flag_estado  = '1';
        
        if ln_count = 0 then
           RAISE_APPLICATION_ERROR(-20000, 'El Centro de Beneficio ' || ls_centro_benef
                                           || ' no existe o no se encuentra activo. ' 
                                           || chr(13) || 'Coordine con contabilidad para su creacion o configuracion');
        end if;
        
        if lc_reg.flag_afecto_igv = '1' then
           ls_tipo_cred_fiscal := '09';  --Venta Nacional Gravada
        elsif lc_reg.flag_afecto_igv = '2' then
           ls_tipo_cred_fiscal := '10'; --Inafectas
        elsif lc_reg.flag_afecto_igv = '3' then
           ls_tipo_cred_fiscal := '11'; --Exonerado
        elsif lc_reg.flag_afecto_igv = '4' then
           ls_tipo_cred_fiscal := '08'; --Exportacion
        elsif lc_reg.flag_afecto_igv = '0' then
           ls_tipo_cred_fiscal := '12'; --Gratuito
        end if;
        
        select count(*)
          into ln_count
          from credito_fiscal cf
         where cf.tipo_cred_fiscal = ls_tipo_cred_fiscal
           and cf.flag_estado      = '1';
        
        if ln_count = 0 then
           RAISE_APPLICATION_ERROR(-20000, 'El tipo de Credito Fiscal ' || ls_tipo_cred_fiscal
                                           || ' no existe o no se encuentra activo. ' 
                                           || chr(13) || 'Coordine con contabilidad para su creacion o configuracion');
        end if;
        
       
        insert into cntas_cobrar_det(
               TIPO_DOC, NRO_DOC, ITEM, FLAG_ESTADO, CONFIN, DESCRIPCION, COD_ART, 
               CANTIDAD, PRECIO_UNITARIO, TIPO_CRED_FISCAL, CENTRO_BENEF, 
               UND, und2, org_am, nro_am, tipo_ref, nro_ref, org_amp_ref, nro_amp_ref)
        VALUES(
               ls_tipo_doc, ls_nro_doc, ln_item, '1', ls_confin, lc_Reg.descripcion, lc_Reg.cod_art,
               lc_Reg.cant_proyect, lc_Reg.precio_unit - lc_reg.descuento, ls_tipo_cred_fiscal, ls_centro_benef,
               lc_Reg.und, lc_reg.und2, lc_reg.org_am, lc_reg.nro_am, ls_tipo_doc_ref, 
               ls_nro_doc_ref, ls_org_amp_Ref, ln_nro_amp_ref);
        
        -- inserto el impuesto 
        if abs(lc_reg.importe_igv * lc_reg.cant_proyect) > 0 then
           insert into cc_doc_det_imp(
                 tipo_doc, nro_doc, item, tipo_impuesto, importe)
           values(
                 ls_tipo_doc, ls_nro_doc, ln_item, PKG_LOGISTICA.is_igv, lc_reg.importe_igv * lc_reg.cant_proyect);
        end if;
        
        if abs(lc_reg.icbper) > 0 then
           insert into cc_doc_det_imp(
                 tipo_doc, nro_doc, item, tipo_impuesto, importe)
           values(
                 ls_tipo_doc, ls_nro_doc, ln_item, PKG_FACT_ELECTRONICA.is_icbper, lc_reg.icbper);
        end if;
    end loop;        
    
    
    
    -- Actualizo la referencia en la cabecera
    update fs_factura_simpl fs
       set fs.nro_doc_cxc = ls_nro_doc
     where fs.nro_registro = asi_registro;
  end ;
  
  /*
  *   ***************************************************************************
  *   Este procedimiento genera el registro en caja_bancos, asi como la aplicacion
  *   de documentos, en caso fuera necesario
  *   ***************************************************************************
  */
  procedure sp_tesoreria_fact_smpl(
    asi_registro fs_factura_simpl.nro_registro%TYPE 
  )is
    -- Variables
    ln_count         number;
    ls_cod_ctabco    caja_bancos.cod_ctabco%TYPE;
    ls_cnta_cntbl    cntbl_cnta.cnta_ctbl%TYPE;
    ls_desc_cnta     cntbl_cnta.desc_cnta%TYPE;
    
    -- Datos Caja Bancos
    ls_org_caja      caja_bancos.origen%TYPE;
    ln_reg_caja      num_caja_bancos.ult_nro%TYPE;
    ls_tipo_doc      caja_bancos.tipo_doc%TYPE;
    ls_nro_doc       caja_bancos.nro_doc%TYPE;
    ls_obs           caja_bancos.obs%TYPE;
    
    -- Cursor con los datos necesarios
    cursor c_datos is
      select fp.nro_registro,
             fp.flag_forma_pago, 
             fp.nro_item,
             fp.tipo_tarjeta, 
             fp.consignatario,
             f.cliente,
             case
               when fp.flag_forma_pago = 'E' then
                 case 
                   when fp.monto_pago > fp.monto then fp.monto
                   else fp.monto_pago
                 end
               else
                 fp.monto_pago
             end as importe_pagado,
             fp.cod_ctabco,
             fp.tipo_doc as tipo_doc_pago,
             fp.nro_doc as nro_doc_pago,
             fp.org_caja,
             fp.ano_caja,
             fp.mes_caja,
             fp.libro_caja,
             fp.asiento_caja,
             f.tipo_doc_cxc as tipo_doc,
             f.nro_doc_cxc as nro_doc,
             f.cod_origen,
             f.ano,
             f.mes,
             f.nro_libro,
             f.nro_asiento,
             fp.cod_usr,
             f.tasa_cambio,
             f.fec_movimiento,
             f.cod_moneda,
             f.observacion,
             fp.reg_caja,
             fp.flag_tipo_credito,
             fp.nro_cuotas,
             fp.porc_interes,
             fp.total_interes,
             fp.nro_registro_ref, 
             fp.tipo_ref,
             fp.nro_ref
        from fs_factura_simpl f,  
             fs_factura_simpl_pagos fp
       where f.nro_registro = fp.nro_registro
         and f.nro_registro = asi_registro
      order by 1, 2 ;

  begin
    for lc_reg in c_datos loop
        ls_obs := 'VENTA BIEN/SERVICIO, FACT. SIMPLIFICADA, ' || trim(lc_reg.tipo_doc) || ' / ' || lc_reg.nro_doc;
              
        -- Ejecuto el procedimiento solo en efectivo y tarjeta
        /*
           E = Efectivo
           T = Tarjeta
           D = Deposito Bancario
           H = Cheque
        */
        if lc_reg.flag_forma_pago in ('E', 'T', 'D', 'H') then

           -- Ubico el codigo de la cuenta bancaria
           if lc_reg.flag_forma_pago in ('E', 'T') then
             
              ls_cod_ctabco := of_get_cod_ctabco(lc_reg.flag_forma_pago,
                                                 lc_reg.tipo_tarjeta,
                                                 lc_reg.cod_origen,
                                                 lc_reg.tipo_doc,
                                                 lc_reg.nro_doc,
                                                 lc_reg.cod_moneda,
                                                 ls_cnta_cntbl,
                                                 ls_desc_cnta);
           else
              ls_cod_ctabco := lc_reg.cod_ctabco;
           end if;
           
           -- Asigno el documento de referencia
           if lc_reg.flag_forma_pago = 'E' then
              ls_tipo_doc := PKG_FACT_ELECTRONICA.is_doc_efectivo;
              ls_nro_doc  := trim(to_char(lc_Reg.fec_movimiento, 'yyyymmdd'));
           elsif lc_reg.flag_forma_pago = 'T' then
              ls_tipo_doc := PKG_FACT_ELECTRONICA.is_doc_tarjeta;
              ls_nro_doc  := '**** **** ';
           elsif lc_reg.flag_forma_pago in ('D', 'H') then
              ls_tipo_doc := lc_reg.tipo_doc_pago;
              ls_nro_doc  := lc_reg.nro_doc_pago;
           end if;
           
           if lc_reg.reg_caja is null or lc_reg.org_caja is null then
             
              ls_org_caja := lc_reg.cod_origen;
              
              -- Genero el nro de registro
              select count(*)
                into ln_count
                from num_caja_bancos n
               where n.origen = ls_org_caja;
              
              if ln_count = 0 then
                 insert into num_caja_bancos(origen, ult_nro)
                 values(ls_org_caja, 1);
              end if;

              select n.ult_nro
                into ln_reg_caja
                from num_caja_bancos n
               where n.origen = ls_org_caja for update;
              
              update num_caja_bancos n  
                 set n.ult_nro = ln_reg_caja + 1
               where n.origen = ls_org_caja;
              
              -- Inserto la cabecera del registro de Caja bancos
              insert into caja_bancos(
                      origen,         nro_registro,     flag_estado, fecha_emision, flag_pago,
                      cod_moneda,     cod_relacion,     cod_usr,     imp_total,     cod_ctabco,
                      confin,         ano,              mes,         nro_libro,     nro_asiento,
                      flag_tiptran,   obs,              tipo_doc,    nro_doc,       flag_conciliacion,
                      tasa_cambio,    flag_replicacion, fec_registro)
              values(
                      ls_org_caja, ln_reg_caja, '1', trunc(lc_reg.fec_movimiento), 'E',
                      lc_reg.cod_moneda, lc_reg.cliente, lc_reg.cod_usr, lc_reg.importe_pagado, ls_cod_ctabco,
                      PKG_FACT_ELECTRONICA.is_confin_FI001,
                      lc_reg.ano_caja,
                      lc_reg.mes_caja,
                      lc_reg.libro_caja,
                      lc_reg.asiento_caja,
                      '3',
                      ls_obs,
                      ls_tipo_doc,
                      ls_nro_doc,
                      '1',
                      lc_reg.tasa_cambio,
                      '1',
                      sysdate);
              
              -- Genero la referencia
              update fs_factura_simpl_pagos fp
                 set fp.org_caja = ls_org_caja,
                     fp.reg_caja = ln_reg_caja
               where fp.nro_registro    = lc_reg.nro_registro
                 and fp.flag_forma_pago = lc_reg.flag_forma_pago
                 and fp.nro_item        = lc_reg.nro_item;
                      
              
           else
              ls_org_caja := lc_reg.org_caja;
              ln_reg_caja := lc_reg.reg_caja;
              
              -- Actualizo la cabecera del registro de Caja Bancos
              update caja_bancos cb
                 set cb.ano         = lc_reg.ano_caja,
                     cb.mes         = lc_reg.mes_caja,
                     cb.nro_libro   = lc_reg.libro_caja,
                     cb.nro_asiento = lc_reg.asiento_caja,
                     cb.fecha_emision = trunc(lc_reg.fec_movimiento),
                     cb.tipo_doc      = ls_tipo_doc,
                     cb.nro_doc       = ls_nro_doc,
                     cb.cod_ctabco    = ls_cod_ctabco,
                     cb.obs           = ls_obs
               where cb.origen       = ls_org_caja
                 and cb.nro_registro = ln_reg_caja;
              
              -- elimino el detalle de caja_bancos
              delete caja_bancos_det cbd
               where cbd.origen       = lc_reg.org_caja
                 and cbd.nro_registro = lc_reg.reg_caja;
           end if;        
           
           -- Inserto el detalle de Caja Bancos
           insert into CAJA_BANCOS_DET(
                  ORIGEN,    
                  NRO_REGISTRO, 
                  ITEM,      
                  COD_RELACION,
                  TIPO_DOC,  
                  NRO_DOC,      
                  IMPORTE,   
                  FLAB_TABOR,
                  CONFIN,    
                  ORIGEN_DOC,
                  IMPT_RET_IGV,
                  FLAG_RET_IGV,
                  FLAG_REFERENCIA,
                  COD_MONEDA,
                  FLAG_FLUJO_CAJA,
                  FACTOR,
                  FLAG_PROVISIONADO,
                  FLAG_REPLICACION,
                  FLAG_APLIC_COMP)
           values(
                  ls_org_caja,
                  ln_reg_caja,
                  1,
                  lc_reg.cliente,
                  lc_reg.tipo_doc,
                  lc_reg.nro_doc,
                  lc_reg.importe_pagado,
                  1,
                  PKG_FACT_ELECTRONICA.is_confin_FI001,
                  lc_reg.cod_origen,
                  0.00,
                  '0',
                  '0',
                  lc_reg.cod_moneda,
                  1,
                  1,
                  'R',
                  '1',
                  '0'); 
                  
        elsif lc_reg.flag_forma_pago = 'O' then
           -- En caso que sea consignacion, creo una nota contable 
           if lc_reg.consignatario is null then
              RAISE_APPLICATION_ERROR(-20000, 'Registro ' || lc_reg.nro_registro || ' que corresponde al comprobante ' 
                                           || lc_reg.tipo_doc 
                                           || '-' || lc_reg.nro_doc || ' tiene como forma de pago CONSIGNACION, pero no ha especificado '
                                           || 'ningun consignatario, por favor verifique!');
           end if;
           
           -- Invoco al procedimiento correspondiente
           of_procesar_consignacion(lc_reg.nro_registro, 
                                    lc_reg.flag_forma_pago, 
                                    lc_reg.nro_item, 
                                    lc_reg.consignatario, 
                                    lc_reg.cod_usr);
                                    
        elsif lc_reg.flag_forma_pago = 'C' and lc_reg.flag_tipo_credito = 'A' then
           -- En caso que sea credito directo
           if lc_reg.nro_cuotas is null or lc_reg.nro_cuotas <= 0 then
              RAISE_APPLICATION_ERROR(-20000, 'Registro ' || lc_reg.nro_registro || ' que corresponde al comprobante ' || lc_reg.tipo_doc 
                                           || '-' || lc_reg.nro_doc || ' tiene credito directo, pero no ha especificado nro de cuotas'
                                           || ', por favor verifique!');
           end if;
           -- En caso que sea credito directo
           if lc_reg.porc_interes is null then
              RAISE_APPLICATION_ERROR(-20000, 'Registro ' || lc_reg.nro_registro || ' que corresponde al comprobante ' || lc_reg.tipo_doc 
                                           || '-' || lc_reg.nro_doc || ' tiene credito directo, pero no ha especificado porcentaje de interes'
                                           || ', por favor verifique!');
           end if;
           
           -- Invoco al procedimiento correspondiente
           of_procesar_cred_directo(lc_reg.nro_registro, 
                                    lc_reg.flag_forma_pago, 
                                    lc_reg.nro_item, 
                                    lc_reg.cod_usr);

        elsif lc_reg.flag_forma_pago = 'C' and lc_reg.flag_tipo_credito = 'D' then
           -- Es un Credito, pero con Descuento Cuenta Corriente
           if lc_reg.nro_cuotas is null or lc_reg.nro_cuotas <= 0 then
              RAISE_APPLICATION_ERROR(-20000, 'Registro ' || lc_reg.nro_registro || ' que corresponde al comprobante ' || lc_reg.tipo_doc 
                                           || '-' || lc_reg.nro_doc || ' es por descuento CUENTA CORRIENTE del trabajador '
                                           || lc_reg.cliente || ', pero no ha especificado nro de cuotas'
                                           || ', por favor verifique!');
           end if;
           
           -- Invoco al procedimiento correspondiente
           of_descuento_cnta_crrte(lc_reg.nro_registro, 
                                    lc_reg.cod_usr);
                                    
        elsif lc_reg.flag_forma_pago = 'N' then
           -- En caso que sea Aplicacion de Nota de Credito, entonces tengo que crear una aplicacion de documento 
           if lc_reg.nro_registro_ref is null then
              RAISE_APPLICATION_ERROR(-20000, 'Registro ' || lc_reg.nro_registro || ' que corresponde al comprobante ' 
                                           || lc_reg.tipo_doc || '-' || lc_reg.nro_doc 
                                           || ' tiene como forma de pago APLICACION DE NOTA DE CREDITO, pero no ha especificado '
                                           || 'ningun documento de referencia, por favor verifique!');
           end if;
           
           -- Proceso que genera la aplicacion de la nota de credito en el pago de la factura
           of_aplicacion_ncc_fs_simpl(lc_reg.nro_registro, 
                                      lc_reg.flag_forma_pago, 
                                      lc_reg.nro_item, 
                                      lc_reg.cod_usr);

        end if;
    end loop;
    
  end ;
  
  -- Genera el asiento contable para la cartera de cobros, en caso de la consignacion crea
  -- la Nota de contabilidad para el canje de la cuenta por cobrar
  procedure sp_cart_cob_asiento_cntbl(
    asi_registro fs_factura_simpl.nro_registro%TYPE 
  )is
    ln_count       number;
    
    -- Datos para el asiento contable
    ls_origen      cntbl_asiento.origen%TYPE;
    ln_year        cntbl_Asiento.Ano%TYPE;
    ln_mes         cntbl_asiento.mes%TYPE;
    ln_nro_libro   cntbl_asiento.nro_libro%TYPE;
    ln_nro_asiento cntbl_libro_mes.nro_asiento%TYPE;
    ls_cnta_cntbl  cntbl_cnta.cnta_ctbl%TYPE;
    ln_item        cntbl_Asiento_det.Item%TYPE;
    ln_imp_movsol  cntbl_asiento_det.imp_movsol%TYPE;
    ln_imp_movdol  cntbl_asiento_det.imp_movsol%TYPE;
    ls_tipo_docref cntbl_Asiento_det.Tipo_Docref1%TYPE;
    ls_nro_docref  cntbl_asiento_det.nro_docref1%TYPE;
    ls_det_glosa   cntbl_asiento_det.det_glosa%TYPE;
    ls_flag_debhab cntbl_asiento_det.flag_debhab%TYPE;
    
    ln_tot_soldeb  cntbl_Asiento.Tot_Soldeb%TYPE;
    ln_tot_solhab  cntbl_Asiento.Tot_Solhab%TYPE;
    ln_tot_doldeb  cntbl_asiento.tot_doldeb%TYPE;
    ln_tot_dolhab  cntbl_asiento.tot_dolhab%TYPE;
    
    -- Datos para banco_cnta
    ls_cod_ctabco         banco_cnta.cod_ctabco%TYPE;
    ls_desc_cnta          cntbl_cnta.desc_cnta%TYPE;
    
    -- Cursor con los datos necesarios
    cursor c_datos is
      select fp.nro_registro,
             fp.flag_forma_pago, 
             fp.nro_item,
             fp.tipo_tarjeta, fp.consignatario,
             f.cliente,
             case
               when fp.flag_forma_pago = 'E' then
                 case 
                   when fp.monto_pago > fp.monto then fp.monto
                   else fp.monto_pago
                 end
               else
                 fp.monto_pago
             end as importe_pagado,
             fp.cod_ctabco,
             fp.tipo_doc as tipo_doc_pago,
             fp.nro_doc as nro_doc_pago,
             fp.org_caja,
             fp.ano_caja,
             fp.mes_caja,
             fp.libro_caja,
             fp.asiento_caja,
             f.tipo_doc_cxc as tipo_doc,
             f.nro_doc_cxc as nro_doc,
             f.cod_origen,
             f.ano,
             f.mes,
             f.nro_libro,
             f.nro_asiento,
             fp.cod_usr,
             f.tasa_cambio,
             f.fec_movimiento,
             f.cod_moneda,
             f.observacion
        from fs_factura_simpl f,  
             fs_factura_simpl_pagos fp
       where f.nro_registro = fp.nro_registro
         and f.nro_registro = asi_registro
      order by 1, 2 ;
        
  begin
    for lc_Reg in c_datos loop
        -- Calculo los importes a colocar en el asiento
        /***************************************************************/
        if lc_reg.cod_moneda = PKG_LOGISTICA.is_soles then
           ln_imp_movsol := lc_reg.importe_pagado;
           ln_imp_movdol := lc_reg.importe_pagado / lc_Reg.tasa_cambio;
        else
           ln_imp_movdol := lc_reg.importe_pagado;
           ln_imp_movsol := lc_reg.importe_pagado * lc_Reg.tasa_cambio;
        end if;

        -- Genero el asiento contable solo para la forma de pago Efectivo
        /***************************************************************/
        if lc_reg.flag_forma_pago IN ('E', 'T', 'D', 'H') then
          
           -- Obtengo el nro de libro adecuado, si el tipo de documento es un NCC entonces corresponde,
           -- a un pago por devolucion de efectivo
           if lc_reg.tipo_doc = PKG_SIGRE_FINANZAS.is_doc_ncc then
              if lc_reg.flag_forma_pago = 'E' then
                 ln_nro_libro := PKG_FACT_ELECTRONICA.il_libro_caja_egr;
              else
                 ln_nro_libro := PKG_FACT_ELECTRONICA.il_libro_pagos;
              end if;
           else
              if lc_reg.flag_forma_pago = 'E' then
                 ln_nro_libro := PKG_FACT_ELECTRONICA.il_libro_caja_ing;
              else
                 ln_nro_libro := PKG_FACT_ELECTRONICA.il_libro_cobranzas;
              end if;
           end if;
           
           if lc_reg.libro_caja <> ln_nro_libro and lc_reg.asiento_caja is not null then
              -- Elimino cualquier referencia al asiento para ponerlo de nuevo
              delete cntbl_asiento_det cad
               where cad.origen        = lc_reg.org_caja
                 and cad.ano           = lc_reg.ano_caja
                 and cad.mes           = lc_reg.mes_caja
                 and cad.nro_libro     = lc_reg.libro_caja
                 and cad.nro_asiento   = lc_reg.asiento_caja;
                 
              -- Quito la Referencia del asiento en CAJA_BANCOS
              update caja_bancos cb
                 set cb.ano           = null,
                     cb.mes           = null,
                     cb.nro_libro     = null,
                     cb.nro_asiento   = null
               where cb.origen        = lc_reg.org_caja
                 and cb.ano           = lc_reg.ano_caja
                 and cb.mes           = lc_reg.mes_caja
                 and cb.nro_libro     = lc_reg.libro_caja
                 and cb.nro_asiento   = lc_reg.asiento_caja;
              
              -- Quito la Referencia del asiento en FS_FACTURA_SIMPL_PAGOS
              update fs_factura_simpl_pagos fp
                 set fp.org_caja      = null,
                     fp.ano_caja      = null,
                     fp.mes_caja      = null,
                     fp.libro_caja    = null,
                     fp.asiento_caja  = null
               where fp.nro_registro    = lc_reg.nro_registro 
                 and fp.flag_forma_pago = lc_reg.flag_forma_pago
                 and fp.nro_item        = lc_Reg.nro_item ;
                 
              -- Elimino cualquier referencia al asiento para ponerlo de nuevo
              delete cntbl_asiento ca
               where ca.origen        = lc_reg.org_caja
                 and ca.ano           = lc_reg.ano_caja
                 and ca.mes           = lc_reg.mes_caja
                 and ca.nro_libro     = lc_reg.libro_caja
                 and ca.nro_asiento   = lc_reg.asiento_caja;
              
              ln_nro_asiento := null;
                 
           elsif lc_reg.asiento_caja is not null then
             
              ln_nro_asiento := lc_reg.asiento_caja;
              
           else
              ln_nro_asiento := null;
           end if;
           
           
           -- Si no tiene asiento creo uno nuevo
           if ln_nro_asiento is null then
              -- Obtengo los datos necesarios
              ls_origen      := lc_reg.cod_origen ;
              ln_year        := lc_reg.ano;
              ln_mes         := lc_reg.mes;
              
              -- Obtengo el siguiente numero de asiento del contador
              select count(*)
                into ln_count
                from cntbl_libro_mes cl
               where cl.origen    = ls_origen
                 and cl.ano       = ln_year
                 and cl.mes       = ln_mes
                 and cl.nro_libro = ln_nro_libro;
              
              if ln_count = 0 then
                 insert into cntbl_libro_mes(
                        origen, nro_libro, ano, mes, nro_asiento)
                 values(
                        ls_origen, ln_nro_libro, ln_year, ln_mes, 1);
              end if;
              
              -- Obtengo el siguiente numerador
              select cl.nro_asiento
                into ln_nro_asiento
                from cntbl_libro_mes cl
               where cl.origen       = ls_origen
                 and cl.ano          = ln_year
                 and cl.mes          = ln_mes
                 and cl.nro_libro    = ln_nro_libro for update;
              
              -- ACtualizo el numerador al siguiente
              update cntbl_libro_mes cl
                 set cl.nro_asiento = ln_nro_asiento + 1
               where cl.origen     = ls_origen
                 and cl.ano        = ln_year
                 and cl.mes        = ln_mes
                 and cl.nro_libro  = ln_nro_libro;
              
              --inserto la cabecera del asiento
              insert into cntbl_asiento(
                     origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, 
                     desc_glosa, fecha_cntbl, fec_registro, 
                     cod_usr, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf)
              values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, lc_reg.cod_moneda, lc_reg.tasa_cambio, 
                     lc_reg.observacion, trunc(lc_reg.fec_movimiento), sysdate,
                     lc_reg.cod_usr, '1', 0, 0, 0, 0, '0');
              
              -- Actualizo los datos de la cabecera en el registro
              update fs_factura_simpl_pagos fp
                 set fp.org_caja      = ls_origen,
                     fp.ano_caja      = ln_year,
                     fp.mes_caja      = ln_mes,
                     fp.libro_caja    = ln_nro_libro,
                     fp.asiento_caja  = ln_nro_asiento
               where fp.nro_registro    = lc_reg.nro_registro
                 and fp.flag_forma_pago = lc_reg.flag_forma_pago
                 and fp.nro_item        = lc_reg.nro_item;
                     
           else
              -- Obtengo los datos 
              ls_origen      := lc_reg.org_caja;
              ln_year        := lc_reg.ano_caja;
              ln_mes         := lc_reg.mes_caja;
              ln_nro_libro   := lc_reg.libro_caja;
              ln_nro_asiento := lc_reg.asiento_caja;
              
              -- elimino el detalle del voucher
              delete cntbl_Asiento_Det cad
               where cad.origen      = ls_origen
                 and cad.ano         = ln_year
                 and cad.mes         = ln_mes
                 and cad.nro_libro   = ln_nro_libro
                 and cad.Nro_Asiento = ln_nro_asiento;
           end if;
           
           -- Inserto la cuenta 10 en el debe
           /*********************************/
           
           -- Obtengo la cuenta del codigo del banco
           if lc_reg.flag_forma_pago not in ('D','H') then
              ls_cod_ctabco := of_get_cod_ctabco(lc_reg.flag_forma_pago,
                                                 lc_reg.tipo_tarjeta,
                                                 lc_reg.cod_origen,
                                                 lc_reg.tipo_doc,
                                                 lc_reg.nro_doc,
                                                 lc_reg.cod_moneda, 
                                                 ls_cnta_cntbl,
                                                 ls_desc_cnta);
           else
             	ls_cod_ctabco := lc_reg.cod_ctabco;
              
              select bc.cnta_ctbl, cc.desc_cnta
                into ls_cnta_cntbl, ls_desc_cnta
                from banco_cnta bc,
                     cntbl_cnta cc
               where bc.cnta_ctbl  = cc.cnta_ctbl
                 and bc.cod_ctabco = ls_cod_ctabco;
           end if;                               
           
           if ls_cod_ctabco is null or nvl(trim(nvl(ls_cod_ctabco, '')), '') = '' then
              RAISE_APPLICATION_ERROR(-20000, 'Cuenta Bancaria es nula. Por favor verifique!');
           end if;      
           
           if ls_cnta_cntbl is null or trim(nvl(ls_cnta_cntbl, '')) = '' then
              RAISE_APPLICATION_ERROR(-20000, 'La cuenta contable es nula para el cuenta bancaria ' || ls_cod_ctabco || ' en el plan de cuentas. Por favor verifique!');
           end if;      

           -- Segundo: Genero los documentos de referencia
           if lc_reg.flag_forma_pago = 'E' then
              ls_tipo_docref := PKG_FACT_ELECTRONICA.is_doc_efectivo;
              ls_nro_docref  := to_char(lc_reg.fec_movimiento, 'yyyymmdd');
           elsif lc_reg.flag_forma_pago = 'T' then
              ls_tipo_docref := PKG_FACT_ELECTRONICA.is_doc_tarjeta;
              ls_nro_docref  := '**** **** ';
           elsif lc_reg.flag_forma_pago in ('D', 'H') then
              ls_tipo_docref := lc_reg.tipo_doc_pago;
              ls_nro_docref  := lc_reg.nro_doc_pago;
           else
              RAISE_APPLICATION_ERROR(-20000, 'Forma de pago no implementada, por favor verifique!');
           end if;
           
           -- Tercero: Inserto el detalle del asiento contable 
           select nvl(max(cad.item),0)
             into ln_item
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento;
           
           -- Cuarto: Aplico el flag_debhab
           if lc_reg.tipo_doc = PKG_SIGRE_FINANZAS.is_doc_ncc then
              ls_flag_debhab := 'H';
           else
              ls_flag_debhab := 'D';
           end if;
           ln_item := ln_item + 1;
                  
           insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1,  cod_ctabco, imp_movsol, imp_movdol)
           values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, trunc(lc_reg.fec_movimiento),
                 ls_desc_cnta, '0', ls_flag_debhab,   
                 ls_tipo_docref, ls_nro_docref, ls_cod_ctabco, ln_imp_movsol, ln_imp_movdol);
           
           -- Inserto la cuenta 12 en el haber, para saldar el documento
           /************************************************************/
           select count(distinct cad.cnta_ctbl)
             into ln_count
             from cntbl_Asiento_det cad
           where cad.origen        = lc_reg.cod_origen
             and cad.ano           = lc_reg.ano
             and cad.mes           = lc_reg.mes
             and cad.nro_libro     = lc_reg.nro_libro
             and cad.nro_asiento   = lc_reg.nro_asiento
             and cad.flag_debhab   = ls_flag_debhab
             and cad.tipo_docref1  = lc_reg.tipo_doc
             and cad.nro_docref1   = lc_reg.nro_doc
             and cad.cod_relacion  = lc_reg.cliente;
           
           if ln_count = 0 then
              RAISE_APPLICATION_ERROR(-20000, 'No hay una cuenta contable tipo cuenta corriente en el asiento de provision '
                                           || 'del Comprobante de Venta. Por favor verifique!.'
                                           || chr(13) || 'Cod Relacion: ' || lc_reg.cliente
                                           || chr(13) || 'Tipo Doc: ' || lc_reg.tipo_doc
                                           || chr(13) || 'Nro Doc: ' || lc_reg.nro_doc
                                           || chr(13) || 'Voucher: ' || lc_reg.cod_origen || trim(to_char(lc_reg.ano, '0000')) 
                                           || trim(to_char(lc_reg.mes, '00')) || trim(to_char(lc_reg.nro_libro, '00')) 
                                           || trim(to_char(lc_reg.nro_asiento, '000000')));
           end if;
           
           if ln_count > 1 then
              RAISE_APPLICATION_ERROR(-20000, 'Se han encontrado ' || to_char(ln_count) || ' cuentas contables tipo cuenta corriente '
                                           || 'en el asiento de provision, cuando solo esta permitido una unica cuenta. '
                                           || 'Por favor verifique y Corrija!.'
                                           || chr(13) || 'Nro Registro: ' || lc_reg.nro_registro
                                           || chr(13) || 'Cod Relacion: ' || lc_reg.cliente
                                           || chr(13) || 'Tipo Doc: ' || lc_reg.tipo_doc
                                           || chr(13) || 'Nro Doc: ' || lc_reg.nro_doc
                                           || chr(13) || 'Voucher: ' || lc_reg.cod_origen || trim(to_char(lc_reg.ano, '0000')) 
                                           || trim(to_char(lc_reg.mes, '00')) || trim(to_char(lc_reg.nro_libro, '00')) 
                                           || trim(to_char(lc_reg.nro_asiento, '000000')));
           end if;  

           select distinct 
                  cad.cnta_ctbl, decode(cad.det_glosa, null, cc.desc_cnta, cad.det_glosa)
             into ls_cnta_cntbl, ls_det_glosa
             from cntbl_Asiento_det cad,
                  cntbl_cnta        cc
           where cad.cnta_ctbl     = cc.cnta_ctbl
             and cad.origen        = lc_reg.cod_origen
             and cad.ano           = lc_reg.ano
             and cad.mes           = lc_reg.mes
             and cad.nro_libro     = lc_reg.nro_libro
             and cad.nro_asiento   = lc_reg.nro_asiento
             and cad.flag_debhab   = ls_flag_debhab
             and cad.tipo_docref1  = lc_reg.tipo_doc
             and cad.nro_docref1   = lc_reg.nro_doc
             and cad.cod_relacion  = lc_reg.cliente;
           
           ls_tipo_docref := lc_reg.tipo_doc;
           ls_nro_docref  := lc_reg.nro_doc;
           
           if ls_flag_debhab = 'D' then    
              ls_flag_debhab := 'H';
           else
              ls_flag_debhab := 'D';
           end if;

           -- Inserto el detalle del asiento contable 
           select nvl(max(cad.item),0)
             into ln_item
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento;
                  
           ln_item := ln_item + 1;
                  
           insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, cod_ctabco, imp_movsol, imp_movdol)
           values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, trunc(lc_reg.fec_movimiento),
                 ls_det_glosa, '0', ls_flag_debhab,   
                 ls_tipo_docref, ls_nro_docref, lc_reg.cliente, null, ln_imp_movsol, ln_imp_movdol);
           
           -- Obtengo los totales del asiento
           select nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
                  nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
                  nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
                  nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
             into ln_tot_soldeb, ln_tot_solhab, ln_tot_doldeb, ln_tot_dolhab
             from cntbl_asiento_det cad
            where cad.origen           = ls_origen
              and cad.ano              = ln_year
              and cad.mes              = ln_mes
              and cad.nro_libro        = ln_nro_libro
              and cad.nro_asiento      = ln_nro_asiento;
     
           -- Actualizo los totales del asiento contable generado
           update cntbl_asiento ca
              set ca.tot_soldeb = ln_tot_soldeb,
                  ca.tot_solhab = ln_tot_solhab,
                  ca.tot_doldeb = ln_tot_doldeb,
                  ca.tot_dolhab = ln_tot_dolhab
            where ca.origen           = ls_origen
              and ca.ano              = ln_year
              and ca.mes              = ln_mes
              and ca.nro_libro        = ln_nro_libro
              and ca.nro_asiento      = ln_nro_asiento;

        end if;
        
    end loop;
  end ;
  
  /*
  *   ***************************************************************************
  *   Este procedimiento genera el registro en CNTA CRRTE del Trabajador, en caso
      sea descuento por planilla, colocando las cuotas y la fecha de inicio de 
      descuento al dia siguiente de la compra del bien
  *   ***************************************************************************
  */
  procedure of_descuento_cnta_crrte(
            asi_registro in fs_factura_simpl.nro_registro%TYPE,
            asi_cod_usr  in usuario.cod_usr%TYPE 
  )is
      ln_count  number;
      
      ls_cliente         fs_factura_simpl.cliente%TYPE;
      ls_tipo_doc        fs_factura_simpl.tipo_doc_cxc%TYPE;
      ls_nro_doc         fs_factura_simpl.nro_doc_cxc%TYPE;
      ls_cod_moneda      fs_factura_simpl.cod_moneda%TYPE;
      ln_importe_doc     cntas_cobrar.importe_doc%TYPE;
      ln_nro_cuotas      proveedor_linea_credito.nro_cuotas%TYPE;
      ld_fec_emision     fs_factura_simpl.fec_movimiento%TYPE;
      ls_concepto        concepto.concep%TYPE;
      
  begin
     ls_concepto := PKG_CONFIG.USF_GET_PARAMETER('RRHH_CONCEPTO_CNTA_CRRTE', '2105');  
   
     -- Obtengo los datos necesarios
     select f.cliente, f.tipo_doc_cxc, f.nro_doc_cxc, trunc(f.fec_movimiento), f.cod_moneda
       into ls_cliente, ls_tipo_doc, ls_nro_doc, ld_fec_emision, ls_cod_moneda
       from fs_factura_simpl f
      where f.nro_registro = asi_registro;
     
     -- Obtengo el importe del documento
     select cc.importe_doc
       into ln_importe_doc
       from cntas_cobrar cc
      where cc.tipo_doc  = ls_tipo_doc
        and cc.nro_doc   = ls_nro_doc;
     
     -- Obtengo el nro de cuotas
     select count(*)
       into ln_count
       from proveedor_linea_credito t
      where t.proveedor = ls_cliente
        and t.flag_estado = '1'
        and t.usr_aprob_rech is not null
        and trunc(ld_fec_emision) between trunc(t.fec_ini_vigencia) and trunc(t.fec_fin_vigencia);
     
     if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'No existe una Linea de Credito ACTIVA ni APROBADA para el Cliente ' || ls_cliente
                          || chr(13) || ' vigente en la fecha ' || to_char(ld_fec_emision, 'dd/mm/yyyy')
                          || chr(13) || 'por favor verifique!' || ls_tipo_doc ||'-'|| ls_nro_doc);
     end if;

     if ln_count > 1 then
        RAISE_APPLICATION_ERROR(-20000, 'Existe mas de una Linea de Credito ACTIVA y APROBADA para el Cliente ' || ls_cliente
                          || chr(13) || ' con la fecha ' || to_char(ld_fec_emision, 'dd/mm/yyyy')
                          || chr(13) || 'por favor verifique!');
     end if;
     
     select t.nro_cuotas
       into ln_nro_cuotas
       from proveedor_linea_credito t
      where t.proveedor = ls_cliente
        and t.flag_estado = '1'
        and t.usr_aprob_rech is not null
        and trunc(ld_fec_emision) between trunc(t.fec_ini_vigencia) and trunc(t.fec_fin_vigencia);

     if ln_nro_cuotas = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'No se ha especificado NRO DE CUOTAS en la Linea de Credito del Cliente ' || ls_cliente
                                        || ', por favor verifique!');
     end if;
     
     
     -- Valido si el registro existe ya en cuenta corriente
     select count(*)
       into ln_count
       from cnta_crrte t
      where t.cod_trabajador = ls_cliente 
        and t.tipo_doc       = ls_tipo_doc
        and t.nro_doc        = ls_nro_doc;
     
     -- Si no hay registro entonces lo inserto
     if ln_count = 0 then
       
        --1 20010728  BVC   B710-6633   03/03/2020  2105  1 5 118.00  23.60 0.00  C 0.00  S/. hviva       1 0     0   100 0 0 0 0 0 0 27/05/2020  26/05/2020 04:01:49 p.m.
        select count(*)
          into ln_count
          from maestro m
         where m.cod_trabajador = ls_cliente;
        
        if ln_count = 0 then
           RAISE_APPLICATION_ERROR(-20000, 'Error al momento de registrar el documento en CTA CTE del Trabajador '
                                        || chr(13) || 'El codigo ' || ls_cliente || ' no corresponde a un trabajador, por favor verifique!'
                                        || chr(13) || 'Documento: ' || ls_tipo_doc || '/' || ls_nro_doc);
        end if;
        
        insert into cnta_crrte(
               cod_trabajador, tipo_doc, nro_doc, fec_prestamo, concep, flag_estado, nro_cuotas, mont_original,
               mont_cuota, sldo_prestamo, cod_sit_prest, porc_interes, cod_moneda, cod_usr, porc_normal, 
               fec_inicio_descto, fec_registro, porc_gratific, porc_utilidad, porc_vacacion, porc_liquidac, 
               porc_otros, porc_quincena)
        values(
               ls_cliente, ls_tipo_doc, ls_nro_doc, ld_fec_emision, ls_concepto, '1', ln_nro_cuotas, ln_importe_doc,
               ln_importe_doc / ln_nro_cuotas, ln_importe_doc, 'A', 0.00, ls_cod_moneda, asi_cod_usr, 100,
               trunc(ld_fec_emision) + 1, sysdate, 0.00, 0.00, 0.00, 0.00,
               0.00, 0.00);
     end if;
  end;
  
  -- Proceso de la consignacion, genero el asiento y el canje de documento por cobrar
  procedure of_procesar_consignacion(
    asi_nro_registro  	  fs_factura_simpl_pagos.nro_registro%TYPE,
    asi_flag_forma_pago   fs_factura_simpl_pagos.flag_forma_pago%TYPE,
    ani_nro_item          fs_factura_simpl_pagos.nro_item%TYPE,
    asi_consignatario     consignatarios.consignatario%TYPE,
    asi_cod_usr           fs_factura_simpl_pagos.cod_usr%TYPE
  ) is
  
  -- Documento de referencia
  ls_tipo_doc_ref     fs_factura_simpl.tipo_doc_cxc%TYPE;
  ls_nro_doc_ref      fs_factura_simpl.nro_doc_cxc%TYPE;
  ld_fec_registro     fs_factura_simpl.fec_registro%TYPE;
  ls_moneda           fs_factura_simpl.cod_moneda%TYPE;
  ln_tasa_cambio      fs_factura_simpl.tasa_cambio%TYPE;
  ls_cliente          fs_factura_simpl.cliente%TYPE;
  
  -- Otras Variables
  ln_count            number;
  ls_tipo_doc         cntas_cobrar.tipo_doc%TYPE;
  ls_nro_doc          cntas_cobrar.nro_doc%TYPE;
  ln_nro_cuotas       fs_factura_simpl_pagos.nro_cuotas%TYPE;
  ln_porc_interes     fs_factura_simpl_pagos.porc_interes%TYPE;
  ln_nro_cuota        fs_factura_simpl_pagos_ref.nro_cuota%TYPE;
  ln_total_capital    fs_factura_simpl_pagos.monto_pago%TYPE;
  ln_total_interes    cntas_cobrar.importe_doc%TYPE;
  ln_capital_cuota    fs_factura_simpl_pagos_ref.capital%TYPE;
  ln_interes_cuota    fs_factura_simpl_pagos_ref.interes%TYPE;
  
  -- datos para el asiento contable
  ls_origen           cntbl_asiento.origen%TYPE;
  ln_year             cntbl_asiento.ano%TYPE;
  ln_mes              cntbl_asiento.mes%TYPE;
  ln_nro_libro        cntbl_Asiento.Nro_Libro%TYPE;
  ln_nro_Asiento      cntbl_asiento.nro_asiento%TYPE;
  ls_desc_glosa       cntbl_asiento.desc_glosa%TYPE;
  ln_tot_soldeb       cntbl_asiento.tot_soldeb%TYPE;
  ln_tot_solhab       cntbl_Asiento.Tot_Solhab%TYPE;
  ln_tot_doldeb       cntbl_asiento.tot_doldeb%TYPE;
  ln_tot_dolhab       cntbl_asiento.tot_dolhab%TYPE;
  
  -- Datos para el detalle del asiento contable
  ln_item             cntbl_asiento_det.item%TYPE;
  ls_cnta_cntbl       cntbl_Asiento_det.Cnta_Ctbl%TYPE;
  ln_imp_movsol       cntbl_asiento_det.imp_movsol%TYPE;
  ln_imp_movdol       cntbl_Asiento_det.Imp_Movdol%TYPE;
  
  -- Variable para la insercion del canje del documento por cobrar
  ls_flag_create      char(1) := '0';
  ln_ult_nro          num_doc_tipo.ultimo_numero%TYPE;
  ld_fec_vencimiento  cntas_cobrar.fecha_vencimiento%TYPE;
  
  begin
    -- Datos de la cabecera
    select f.tipo_doc_cxc, f.nro_doc_cxc, f.fec_movimiento, f.cod_origen, f.cod_moneda,
           f.tasa_cambio, substr(f.observacion, 1, 200), f.cliente
      into ls_tipo_doc_ref, ls_nro_doc_ref, ld_fec_registro, ls_origen, ls_moneda,
           ln_tasa_cambio, ls_desc_glosa, ls_Cliente
      from fs_factura_simpl f
     where f.nro_registro = asi_nro_registro;  
    
    if ls_tipo_doc_ref is null or ls_nro_doc_ref is null then
       RAISE_APPLICATION_ERROR(-20000, 'Error, no se ha especificado un documento de referencia para el regsitro ' || asi_nro_registro
                        || chr(13) || 'Tipo Doc: ' || nvl(ls_tipo_doc_ref, 'S/R')
                        || chr(13) || 'Nro Doc: ' || nvl(ls_nro_doc_ref, 'S/R')
                        || chr(13) || 'Por favor verifique!!!');
    end if;
    
    -- Datos del pago
    select nvl(fp.nro_cuotas, 1), nvl(fp.porc_interes, 0), NVL(fp.monto_pago, 0)
      into ln_nro_cuotas, ln_porc_interes, ln_total_capital
      from fs_factura_simpl_pagos fp
     where fp.nro_registro    = asi_nro_registro
       and fp.flag_forma_pago = asi_flag_forma_pago
       and fp.nro_item        = ani_nro_item;
    
    if ln_nro_cuotas = 0 then ln_nro_cuotas := 1; end if;
    
    if ln_total_capital = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'El capital debe ser mayor a cero. Por favor verifique!'
                         || chr(13) || 'Nro Registro: ' || asi_nro_registro
                         || chr(13) || 'Documento: ' || ls_tipo_doc_ref || '-' || ls_nro_doc_ref);
    end if;

    -- Calculando los intereses
    ln_total_interes := ln_total_capital * ln_porc_interes / 100;
    
    -- Verificando el total de registros en las cuotas
    select count(*)
      into ln_count
      from fs_factura_simpl_pagos_ref pr
     where pr.nro_registro            = asi_nro_registro
       and pr.flag_forma_pago         = asi_flag_forma_pago
       and pr.nro_item                = ani_nro_item;
    
    if ln_count > ln_nro_cuotas then
       RAISE_APPLICATION_ERROR(-20000, 'El numero de cuotas es menor al registrado anteriormente. Por favor verifique!'
                         || chr(13) || 'Nro Cuotas: ' || trim(to_char(ln_nro_cuotas))
                         || chr(13) || 'Cuotas previas: ' || trim(to_char(ln_count)));
    end if;
    
    -- Calculo el valor del capital y el interes por cada cuota
    ln_capital_cuota := ln_total_capital / ln_nro_cuotas;
    ln_interes_cuota := ln_total_interes / ln_nro_cuotas;
    
    ld_fec_vencimiento := ld_fec_registro;
    
    -- recorro cada cuota para generar el documento
    FOR ln_nro_cuota IN 1..ln_nro_cuotas LOOP
        select count(*)
          into ln_count
          from fs_factura_simpl_pagos_ref pr
         where pr.nro_registro            = asi_nro_registro
           and pr.flag_forma_pago         = asi_flag_forma_pago
           and pr.nro_item                = ani_nro_item
           and pr.nro_cuota               = ln_nro_cuota;
        
        if ln_count > 0 then
           -- Obtengo lo datos que necesito
           select pr.org_asiento, pr.ano_asiento, pr.mes_asiento, pr.libro_asiento, pr.nro_asiento,
                  pr.tipo_doc_cxc, pr.nro_doc_cxc
             into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_Asiento,
                  ls_tipo_doc, ls_nro_doc
             from fs_factura_simpl_pagos_ref pr
            where pr.nro_registro            = asi_nro_registro
              and pr.flag_forma_pago         = asi_flag_forma_pago
              and pr.nro_item                = ani_nro_item
              and pr.nro_cuota               = ln_nro_cuota;
           
           -- Elimino el detalle del asiento
           delete cntbl_Asiento_det cad
            where cad.origen        = ls_origen
              and cad.ano           = ln_year
              and cad.mes           = ln_mes
              and cad.nro_libro     = ln_nro_libro
              and cad.nro_Asiento   = ln_nro_asiento;
           
           -- Actualizo datos
           update fs_factura_simpl_pagos_ref pr
              set pr.capital = ln_capital_cuota,
                  pr.interes = ln_interes_cuota
            where pr.nro_registro            = asi_nro_registro
              and pr.flag_forma_pago         = asi_flag_forma_pago
              and pr.nro_item                = ani_nro_item
              and pr.nro_cuota               = ln_nro_cuota;
           
           if ls_nro_Doc is null then
              ls_flag_create := '1';
           else
              ls_flag_create := '0';
           end if;
        else
           ls_flag_create := '1';
           ls_nro_doc := null;
           
           -- Obtengo el periodo
           ln_year := to_number(to_char(ld_fec_registro, 'yyyy'));
           ln_mes  := to_number(to_char(ld_fec_registro, 'mm'));
           
           -- Obtengo el tipo de documento segun el nro de cuotas
           if ln_nro_cuotas <= 1 then
              ls_tipo_doc := PKG_FACT_ELECTRONICA.is_doc_ncnc;
           else
              ls_tipo_doc := PKG_FACT_ELECTRONICA.is_doc_ltc;
           end if;

           -- Realizo algunas validaciones
           select count(*)
             into ln_count
             from doc_tipo dt
            where dt.tipo_doc = ls_tipo_doc;
        
           if ln_count = 0 then
              RAISE_APPLICATION_ERROR(-20000, 'Error, no existe el tipo de documento ' || ls_tipo_doc || '. Por favor verifique!!!');
           end if;
        
           -- Obtengo el libro contable de dicho documento
           select dt.nro_libro
             into ln_nro_libro
             from doc_tipo dt
            where dt.tipo_doc = ls_tipo_doc;
           
           -- Creo el siguiente numero
           select count(*)
             into ln_count
             from cntbl_libro_mes clm
            where clm.origen      = ls_origen
              and clm.ano         = ln_year
              and clm.mes         = ln_mes
              and clm.nro_libro   = ln_nro_libro;
           
           if ln_count = 0 then
              insert into cntbl_libro_mes(
                     origen, nro_libro, ano, mes, nro_asiento)
              values(
                     ls_origen, ln_nro_libro, ln_year, ln_mes, 1);
           end if;
           
           select clm.nro_asiento
             into ln_nro_Asiento
             from cntbl_libro_mes clm
            where clm.origen      = ls_origen
              and clm.ano         = ln_year
              and clm.mes         = ln_mes
              and clm.nro_libro   = ln_nro_libro for update; 
           
           -- Actualizo el numerador del asiento
           update cntbl_libro_mes clm
              set clm.nro_asiento = ln_nro_Asiento + 1
            where clm.origen      = ls_origen
              and clm.ano         = ln_year
              and clm.mes         = ln_mes
              and clm.nro_libro   = ln_nro_libro;

           -- inserto la cabecera del asiento
           insert into cntbl_asiento(
                     origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, 
                     desc_glosa, fecha_cntbl, fec_registro, 
                     cod_usr, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf)
           values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ls_moneda, ln_tasa_cambio, 
                     ls_desc_glosa, trunc(ld_fec_registro), sysdate,
                     asi_cod_usr, '1', 0, 0, 0, 0, '0');
           
           -- Inserto la referencia en la tabla
           insert into fs_factura_simpl_pagos_ref(
                  nro_registro, flag_forma_pago, nro_item, 
                  org_asiento, ano_asiento, mes_asiento, libro_asiento, nro_asiento,
                  tipo_doc_cxc, nro_doc_cxc, nro_cuota, capital, interes)
           values(              
                  asi_nro_registro, asi_flag_forma_pago, ani_nro_item, 
                  ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento,
                  null, null, ln_nro_cuota, ln_capital_cuota, ln_interes_cuota);
        end if;
        
        if ls_nro_doc is null then
           if ls_tipo_doc = PKG_FACT_ELECTRONICA.is_doc_ncnc then
              ls_nro_doc  := ls_nro_doc_ref;
           else
              -- Obtengo el siguiente numero del documento
              select count(*)
                into ln_count
                from num_doc_tipo n
               where n.tipo_doc = ls_tipo_doc
                 and n.nro_serie = '1';
              
              if ln_count = 0 then
                 insert into num_doc_tipo(
                        tipo_doc, ultimo_numero, nro_serie)
                 values(
                        ls_tipo_doc, 1, '1');
              end if; 
              
              select n.ultimo_numero
                into ln_ult_nro
                from num_doc_tipo n
               where n.tipo_doc = ls_tipo_doc
                 and n.nro_serie = '1' for update;
              
              -- Actualizo el numerador
              update num_doc_tipo n
                 set n.ultimo_numero = ln_ult_nro + 1
               where n.tipo_doc = ls_tipo_doc
                 and n.nro_serie = '1';
              
              ls_nro_doc := '1-' || trim(to_char(ln_ult_nro));
           end if;
        end if;
          
        
        -- Primero hago la provision del capital
        if ls_moneda = PKG_LOGISTICA.is_soles then
           ln_imp_movsol := ln_capital_cuota;
           ln_imp_movdol := ln_capital_cuota / ln_Tasa_cambio;
        else
           ln_imp_movdol := ln_capital_cuota;
           ln_imp_movsol := ln_capital_cuota * ln_Tasa_cambio;
        end if;

        ln_item := 1;
        
        -- Obtengo la primera linea del asiento contable, reduzco la cuenta 12 del documento de origen
        /*******************************************************************************************/
        select count(distinct cad.cnta_ctbl)
          into ln_count
          from cntbl_asiento_det cad,
               fs_factura_simpl  f
         where cad.origen        = f.cod_origen
           and cad.ano           = f.ano
           and cad.mes           = f.mes
           and cad.nro_libro     = f.nro_libro
           and cad.nro_Asiento   = f.nro_Asiento
           and cad.flag_debhab   = 'D'
           and cad.cod_relacion  = ls_cliente
           and cad.tipo_docref1  = ls_tipo_doc_ref
           and cad.nro_docref1   = ls_nro_doc_ref   ;
        
        if ln_count = 0 then
           RAISE_APPLICATION_ERROR(-20000, 'No existe una cuenta contable que sea cuenta corriente en el asiento'
                                        || ' de provision del comprobante de venta. Por favor verifique!'
                                        || chr(13) || 'Documento: ' || ls_tipo_doc_ref || '-' || ls_nro_doc_ref); 
        end if;

        if ln_count >1 then
           RAISE_APPLICATION_ERROR(-20000, 'Existen ' || trim(to_char(ln_count)) || ' cuentas contables que son cuenta corriente '
                                        || 'en el asiento de provision del comprobante de venta. Por favor verifique!'
                                        || chr(13) || 'Documento: ' || ls_tipo_doc_ref || '-' || ls_nro_doc_ref); 
        end if;
        
        -- Obtengo la cuenta contable
        select distinct cad.cnta_ctbl
          into ls_cnta_cntbl
          from cntbl_asiento_det cad,
               fs_factura_simpl  f
         where cad.origen        = f.cod_origen
           and cad.ano           = f.ano
           and cad.mes           = f.mes
           and cad.nro_libro     = f.nro_libro
           and cad.nro_Asiento   = f.nro_Asiento
           and cad.flag_debhab   = 'D'
           and cad.cod_relacion  = ls_cliente
           and cad.tipo_docref1  = ls_tipo_doc_ref
           and cad.nro_docref1   = ls_nro_doc_ref   ;
        
        
        insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, cod_ctabco, imp_movsol, imp_movdol)
        values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, trunc(ld_fec_registro),
                 'VENTA EN CONSIGNACION NRO CUOTA: ' || trim(to_char(ln_nro_cuota)), '0', 'H',   
                 ls_tipo_doc_ref, ls_nro_doc_ref, ls_cliente, null, ln_imp_movsol, ln_imp_movdol);

        -- Obtengo la primera linea del asiento contable, reduzco la cuenta 12 del documento de origen
        /*******************************************************************************************/
        ln_item := ln_item + 1;
        
        if ls_moneda = PKG_LOGISTICA.is_soles then
           ls_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_consig_mn;
        else
           ls_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_consig_me;
        end if;
        
        insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, cod_ctabco, imp_movsol, imp_movdol)
        values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, trunc(ld_fec_registro),
                 'VENTA EN CONSIGNACION NRO CUOTA: ' || trim(to_char(ln_nro_cuota)), '0', 'D',   
                 ls_tipo_doc, ls_nro_doc, asi_consignatario, null, ln_imp_movsol, ln_imp_movdol);
        
        -- Provisiono los interes de cada cuota
        /*******************************************************************************************/
        if ln_interes_cuota > 0 then
           -- A?ado la provision del interes devengado por los intereses de cada cuota
           null;
        end if;
        
        -- Obtengo los totales del asiento
        /*******************************************************************************************/
        select nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
               nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
               nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
               nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
          into ln_tot_soldeb, ln_tot_solhab, ln_tot_doldeb, ln_tot_dolhab
          from cntbl_asiento_det cad
         where cad.origen           = ls_origen
           and cad.ano              = ln_year
           and cad.mes              = ln_mes
           and cad.nro_libro        = ln_nro_libro
           and cad.nro_asiento      = ln_nro_asiento;
      
        -- Actualizo los totales del asiento contable generado
        update cntbl_asiento ca
           set ca.tot_soldeb = ln_tot_soldeb,
               ca.tot_solhab = ln_tot_solhab,
               ca.tot_doldeb = ln_tot_doldeb,
               ca.tot_dolhab = ln_tot_dolhab
         where ca.origen           = ls_origen
           and ca.ano              = ln_year
           and ca.mes              = ln_mes
           and ca.nro_libro        = ln_nro_libro
           and ca.nro_asiento      = ln_nro_asiento;
        
        ld_fec_vencimiento := trunc(ld_fec_vencimiento) + 30;
        
        if ls_flag_create = '1' then
           -- Ahora inserto el documento por  el canje de documentos por cobrar
           -- Por ahora solo el capital
           /*******************************************************************/
           insert into cntas_cobrar(
                  tipo_doc,        nro_doc,           cod_relacion,      flag_estado,      fecha_registro,
                  fecha_documento, fecha_vencimiento, cod_moneda,       tasa_cambio, 
                  cod_usr,         forma_pago,        origen,            ano,              mes,
                  nro_libro,       nro_asiento,       observacion,       flag_detraccion,
                  flag_situacion_ltr,
                  nro_ren_ltr,
                  flag_tipo_ltr,
                  flag_provisionado,
                  importe_doc,
                  saldo_sol,
                  saldo_dol)
           values(
                  ls_tipo_doc,     ls_nro_doc,        asi_consignatario, '1', sysdate,
                  ld_fec_registro, ld_fec_vencimiento, ls_moneda, ln_tasa_cambio,
                  asi_cod_usr,     PKG_FACT_ELECTRONICA.is_fp_F30d, ls_origen, ln_year, ln_mes,
                  ln_nro_libro,    ln_nro_Asiento,                  
                  'VENTA EN CONSIGNACION. NRO CUOTA: ' || trim(to_char(ln_nro_cuota)),
                  '0',
                  '1',
                  0,
                  'C',
                  'R',
                  ln_capital_cuota,
                  ln_imp_movsol,
                  ln_imp_movdol);
           
           update fs_factura_simpl_pagos_ref pr
              set pr.tipo_doc_cxc = ls_tipo_doc,
                  pr.nro_doc_cxc  = ls_nro_doc
            where pr.nro_registro    = asi_nro_registro
              and pr.flag_forma_pago = asi_flag_forma_pago
              and pr.nro_item        = ani_nro_item
              and pr.nro_cuota       = ln_nro_cuota;  
        else
           update cntas_cobrar cc
              set cc.fecha_vencimiento = ld_fec_vencimiento,
                  cc.importe_doc       = ln_capital_cuota,
                  cc.saldo_sol         = ln_imp_movsol,
                  cc.saldo_dol         = ln_imp_movdol
            where cc.tipo_doc          = ls_tipo_doc
              and cc.nro_doc           = ls_nro_doc;  
           
           delete doc_referencias dr
            where dr.tipo_doc     = ls_tipo_doc
              and dr.nro_doc      = ls_nro_doc;
        
        end if;
        
        -- Ahora insert el detalle del canje de documentos por cobrar
        -- Por ahora solo el capital
        /*******************************************************************/
        insert into doc_referencias(
               cod_relacion, tipo_doc, nro_doc, tipo_mov, origen_ref, tipo_ref, nro_ref, importe, proveedor_ref)
        values(
               asi_consignatario, ls_tipo_doc, ls_nro_doc, 'C', ls_origen, ls_tipo_doc_ref, ls_nro_doc_ref, ln_capital_cuota, ls_cliente);
        
        -- Actualizo el saldo de la cuenta x cobrar
        /******************************************/
        update cntas_cobrar cc
           set cc.saldo_sol = cc.saldo_sol - ln_imp_movsol,
               cc.saldo_dol = cc.saldo_dol - ln_imp_movdol
         where cc.tipo_doc  = ls_tipo_doc_ref
           and cc.nro_doc   = ls_nro_doc_ref;
           
        -- Actualizo la cuenta corriente
        /*******************************/
        update doc_pendientes_cta_cte dc
           set dc.sldo_sol  = dc.sldo_sol  - ln_imp_movsol,
               dc.saldo_dol = dc.saldo_dol - ln_imp_movdol
         where dc.cod_relacion = ls_cliente
           and dc.tipo_doc     = ls_tipo_doc_ref
           and dc.nro_doc      = ls_nro_doc_ref;
        
        
        
    END LOOP;
    
  end;
  
  -- Proceso que genera la aplicacion de la nota de credito en el pago de la factura
  procedure of_aplicacion_ncc_fs_simpl(
    asi_nro_registro      fs_factura_simpl_pagos.nro_registro%TYPE,
    asi_flag_forma_pago   fs_factura_simpl_pagos.flag_forma_pago%TYPE,
    ani_nro_item          fs_factura_simpl_pagos.nro_item%TYPE,
    asi_cod_usr           fs_factura_simpl_pagos.cod_usr%TYPE
    
  ) is
    -- Diversas variables
    ln_count           number;
    
    -- Cabecera de la factura simplificada
    ld_fecha_fs        fs_factura_simpl.fec_registro%TYPE;
    ls_moneda_fs       fs_factura_simpl.cod_moneda%TYPE;
    ln_tasa_cambio     fs_factura_simpl.tasa_cambio%TYPE;
    ls_origen          fs_factura_simpl.cod_origen%TYPE;
    ls_tipo_doc_cxc    fs_factura_simpl.tipo_doc_cxc%TYPE;
    ls_nro_doc_cxc     fs_factura_simpl.nro_doc_cxc%TYPE;
    ln_imp_pago        fs_factura_simpl_pagos.monto_pago%TYPE;
    ls_cliente         fs_factura_simpl.cliente%TYPE;
    
    -- Referencia a la nota de credito
    ls_tipo_ref             fs_factura_simpl_pagos.tipo_ref%TYPE;
    ls_nro_ref              fs_factura_simpl_pagos.nro_ref%TYPE;
    
    -- Datos para el registro de tesoreria / Aplicacion de documentos
    ls_org_caja        cntbl_asiento.origen%TYPE;
    ln_reg_caja        caja_bancos.nro_registro%TYPE;
   
    -- Datos para la cabecera del asiento contable
    ln_year            cntbl_asiento.ano%TYPE;
    ln_mes             cntbl_asiento.mes%TYPE;
    ln_nro_Asiento     cntbl_Asiento.Nro_Asiento%TYPE;
    ln_nro_libro       cntbl_asiento.nro_libro%TYPE;
    
    -- Datos para el detalle del asiento contable
    ls_tipo_docref     cntbl_Asiento_det.Tipo_Docref1%TYPE;
    ls_nro_docref      cntbl_asiento_det.nro_docref1%TYPE;
    ls_cod_relacion    cntbl_asiento_det.cod_relacion%TYPE;
    ls_cnta_cntbl      cntbl_Asiento_Det.Cnta_Ctbl%TYPE;
    ln_item            cntbl_asiento_det.item%TYPE := 0;
    ln_imp_movsol      cntbl_asiento_det.imp_movsol%TYPE;
    ln_imp_movdol      cntbl_asiento_det.imp_movdol%TYPE;
    ls_det_glosa       cntbl_asiento_det.det_glosa%TYPE;

    -- Totales de los asientos
    ln_tot_soldeb    cntbl_asiento.tot_soldeb%TYPE;
    ln_tot_solhab    cntbl_asiento.tot_solhab%TYPE;
    ln_tot_doldeb    cntbl_asiento.tot_doldeb%TYPE;
    ln_tot_dolhab    cntbl_asiento.tot_dolhab%TYPE;
  
  
  begin
    -- Obtengo los datos necesarios de la cabecera de la factura simplificada
    select f.fec_movimiento, f.cod_moneda, f.tasa_cambio, f.cod_origen, f.tipo_doc_cxc, f.nro_doc_cxc,
           f.cliente
      into ld_fecha_fs, ls_moneda_fs, ln_tasa_cambio, ls_origen, ls_tipo_doc_cxc, ls_nro_doc_cxc,           
           ls_cliente
      from fs_factura_simpl f
     where f.nro_registro = asi_nro_registro;

    -- Valido que el documento de cuenta por cobrar no sea nulo
    if ls_tipo_doc_cxc is null or ls_nro_doc_cxc is null then
       RAISE_APPLICATION_ERROR(-20000, 'No se ha definido el documento por cobrar correctamente.'
                              || chr(13) || 'Tipo Doc: ' || nvl(ls_tipo_doc_cxc, 'S/R')
                              || chr(13) || 'Nro Doc: ' || nvl(ls_nro_doc_cxc, 'S/R'));
    end if;
     
    -- Obtengo los datos del asiento contable
    select fp.org_caja, fp.reg_caja, fp.ano_caja, fp.mes_caja, fp.libro_caja, fp.asiento_caja,
           f.tipo_doc_cxc, f.nro_doc_cxc, fp.monto_pago
      into ls_org_caja, ln_reg_caja, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento,
           ls_tipo_ref, ls_nro_ref, ln_imp_pago
      from fs_factura_simpl_pagos fp,
           fs_factura_simpl       f
     where fp.nro_registro_ref = f.nro_registro
       and fp.nro_registro    = asi_nro_registro
       and fp.flag_forma_pago = asi_flag_forma_pago
       and fp.nro_item        = ani_nro_item;
    
    -- Valido que el documento de referencia (NOTA DE CREDITO) no sea nulo
    if ls_tipo_ref is null or ls_nro_ref is null then
       RAISE_APPLICATION_ERROR(-20000, 'No se ha definido documento de referencia en la pago por aplicacion de nota de credito del '
                                    || 'registro ' || asi_nro_registro);
    end if;
    
    -- Actualizo el documento de referencia en el pago
    update fs_factura_simpl_pagos fp
       set fp.tipo_ref = ls_tipo_ref,
           fp.nro_ref  = ls_nro_ref
     where fp.nro_registro    = asi_nro_registro
       and fp.flag_forma_pago = asi_flag_forma_pago
       and fp.nro_item        = ani_nro_item
       and (fp.tipo_ref <> ls_tipo_Ref or fp.nro_ref <> ls_nro_ref);
    
    -- Creo la glosa adecuada
    ls_det_glosa := 'APLICACION DE NOTA DE CREDITO X COBRAR ' || ls_tipo_ref || '/' 
                 || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_ref)
                 || ' AL COMPROBANTE ' || ls_tipo_doc_cxc || '/' 
                 || PKG_FACT_ELECTRONICA.of_get_full_nro(ls_nro_doc_cxc);

    
    -- Si no tiene asiento de APLICACION DE DOCUMENTOS entonces creo uno
    if ln_nro_asiento is null then
       -- Verifico si el libro contable de provision de la APLICACION existe
       select count(*)
         into ln_count
         from cntbl_libro cl
        where cl.nro_libro = PKG_FACT_ELECTRONICA.il_libro_prov_aplic;
        
       if ln_count = 0 then
          INSERT INTO cntbl_libro(
                 nro_libro, desc_libro, num_provisional)
          values(
                 PKG_FACT_ELECTRONICA.il_libro_prov_aplic, 'PROVISION DE APLICACIONES DE DOCUMENTO', 1);
       end if;
       
       --ASigno el nro de libro por defecto
       ln_nro_libro := PKG_FACT_ELECTRONICA.il_libro_prov_aplic;
       
       -- Obtengo el periodo de provision, que es el mismo de la factura simplificada
       ls_org_caja := ls_origen;
       ln_year     := to_number(to_char(ld_fecha_fs, 'yyyy'));
       ln_mes      := to_number(to_char(ld_fecha_fs, 'mm'));
          
       -- Obtengo el siguiente numerador del asiento
       select count(*)
         into ln_count
         from cntbl_libro_mes clm
        where clm.origen    = ls_origen
          and clm.nro_libro = ln_nro_libro
          and clm.ano       = ln_year
          and clm.mes       = ln_mes;
           
       if ln_count = 0 then
          insert into CNTBL_LIBRO_MES(
                 ORIGEN, NRO_LIBRO, ANO, MES, NRO_ASIENTO)
          values(
                 ls_origen, ln_nro_libro, ln_year, ln_mes, 1);
       end if;
           
       select clm.nro_asiento
         into ln_nro_Asiento
         from cntbl_libro_mes clm
        where clm.origen    = ls_origen
          and clm.nro_libro = ln_nro_libro
          and clm.ano       = ln_year
          and clm.mes       = ln_mes for update;
       
       
       -- Creo la cabecera del nuevo asiento
       insert into cntbl_asiento(
               origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, desc_glosa, fecha_cntbl, 
               fec_registro, cod_usr, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf)
        values(
               ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ls_moneda_fs, ln_Tasa_cambio, ls_det_glosa, ld_fecha_fs, 
               sysdate, asi_cod_usr, '1', 0, 0, 0, 0, '0');

       -- Actualizo el numerador
       update cntbl_libro_mes clm
          set clm.nro_asiento = ln_nro_Asiento + 1
        where clm.origen    = ls_origen
          and clm.nro_libro = ln_nro_libro
          and clm.ano       = ln_year
          and clm.mes       = ln_mes;
       
       -- Actualizo en la tabla fs_factura_simpl_pagos
       update fs_factura_simpl_pagos fp
          set fp.org_caja = ls_org_caja,
              fp.ano_caja = ln_year,
              fp.mes_caja = ln_mes,
              fp.libro_caja = ln_nro_libro,
              fp.asiento_caja = ln_nro_asiento
        where fp.nro_registro = asi_nro_registro
          and fp.flag_forma_pago = asi_flag_forma_pago
          and fp.nro_item        = ani_nro_item;
          
    else
       -- actualizo los datos en la cabecera
       update cntbl_asiento ca
          set ca.desc_glosa = ls_det_glosa
        where ca.origen        = ls_origen
          and ca.ano           = ln_year
          and ca.mes           = ln_mes
          and ca.nro_libro     = ln_nro_libro
          and ca.nro_asiento   = ln_nro_asiento;
          
       -- Elimino el detalle del comprobante
       delete cntbl_asiento_det cad
        where cad.origen        = ls_origen
          and cad.ano           = ln_year
          and cad.mes           = ln_mes
          and cad.nro_libro     = ln_nro_libro
          and cad.nro_asiento   = ln_nro_asiento;
    end if;
    

    /*****************************************/
    -- Inserto el detalle del asiento contable
    /*****************************************/
    ln_item := 0;

    -- Obtenemos los importes
    if ls_moneda_fs = PKG_LOGISTICA.is_soles then
       ln_imp_movsol := ln_imp_pago;
       ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
    else
       ln_imp_movdol := ln_imp_pago;
       ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
    end if;
    
    
    /**********************************************************************************************************/
    -- PASO 1. Inserto la cuenta contable del documento de referencia es decir de la nota de credito
    /*********************************************************************************************************/
    
    -- Busco la cuenta contable del documento de referencia
    select count(distinct cad.cnta_ctbl)
      into ln_count
      from cntas_cobrar cc,
           cntbl_asiento_det cad
     where cc.origen         = cad.origen
       and cc.ano            = cad.ano
       and cc.mes            = cad.mes
       and cc.nro_libro      = cad.nro_libro
       and cc.nro_asiento    = cad.nro_Asiento
       and cc.tipo_doc       = cad.tipo_docref1
       and cc.nro_doc        = cad.nro_docref1
       and cc.tipo_doc       = ls_tipo_ref
       and cc.nro_doc        = ls_nro_ref
       and cad.flag_debhab   = 'H'
       and cad.cnta_ctbl     like '12%';
         
    if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provision del Comprobante ' || ls_tipo_ref || '-' || ls_nro_ref ||
                                        ' Nro de Registro: ' || asi_nro_registro || chr(13) || '.' ||
                                        'No ha especificado una CUENTA CONTABLE de la clase 12 en el HABER para provisionar ' ||
                                        'el comprobante. Por favor verifique!');
    end if;
         
    if ln_count > 1 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provision del Comprobante ' || ls_tipo_ref || '-' || ls_nro_ref ||
                                        ' Nro de Registro: ' || asi_nro_registro || chr(13) || '.' ||
                                        'Se ha especificado mas de una cuenta contable de la clase 12 en el HABER para provisionar ' ||
                                        'el comprobante. Por favor verifique!');
    end if;

    select distinct cad.cnta_ctbl, cad.tipo_docref1, cad.nro_docref1, cad.cod_relacion
      into ls_cnta_cntbl, ls_tipo_docref, ls_nro_docref, ls_cod_relacion
      from cntas_cobrar cc,
           cntbl_asiento_det cad
     where cc.origen         = cad.origen
       and cc.ano            = cad.ano
       and cc.mes            = cad.mes
       and cc.nro_libro      = cad.nro_libro
       and cc.nro_asiento    = cad.nro_Asiento
       and cc.tipo_doc       = cad.tipo_docref1
       and cc.nro_doc        = cad.nro_docref1
       and cc.tipo_doc       = ls_tipo_ref
       and cc.nro_doc        = ls_nro_ref
       and cad.flag_debhab   = 'H'
       and cad.cnta_ctbl     like '12%';

    
    -- Inserto la cuenta contable en el asiento
    ln_item := ln_item + 1;
                  
    insert into cntbl_asiento_det(
           origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
           det_glosa, flag_gen_aut, flag_debhab, 
           tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
    values(
           ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fecha_fs,
           ls_det_glosa, '0', 'D',   
           ls_tipo_docref, ls_nro_docref, ls_cliente, ln_imp_movsol, ln_imp_movdol);
    
    /***********************************************************************************************/
    -- PASO 2. Inserto la cuenta contable de la factura simplificada
    /***********************************************************************************************/
    
    -- Busco la cuenta contable de la factura original
    select count(distinct cad.cnta_ctbl)
      into ln_count
      from cntas_cobrar cc,
           cntbl_asiento_det cad
     where cc.origen         = cad.origen
       and cc.ano            = cad.ano
       and cc.mes            = cad.mes
       and cc.nro_libro      = cad.nro_libro
       and cc.nro_asiento    = cad.nro_Asiento
       and cc.tipo_doc       = cad.tipo_docref1
       and cc.nro_doc        = cad.nro_docref1
       and cc.tipo_doc       = ls_tipo_doc_cxc
       and cc.nro_doc        = ls_nro_doc_cxc
       and cad.flag_debhab   = 'D'
       and cad.cnta_ctbl     like '12%';
         
    if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provision del Comprobante ' || ls_tipo_doc_cxc || '-' || ls_nro_doc_cxc ||
                                        ' Nro de Registro: ' || asi_nro_registro ||
                                        'No ha especificado una CUENTA CONTABLE de la clase 12 en el DEBE para provisionar ' ||
                                        'el comprobante. Por favor verifique!');
    end if;
         
    if ln_count > 1 then
        RAISE_APPLICATION_ERROR(-20000, 'Error en la provision del Comprobante ' || ls_tipo_doc_cxc || '-' || ls_nro_doc_cxc ||
                                        ' Nro de Registro: ' || asi_nro_registro ||
                                        'Se ha especificado mas de una cuenta contable de la clase 12 en el DEBE para provisionar ' ||
                                        'el comprobante. Por favor verifique!');
    end if;

    select distinct cad.cnta_ctbl, cad.tipo_docref1, cad.nro_docref1, cad.cod_relacion
      into ls_cnta_cntbl, ls_tipo_docref, ls_nro_docref, ls_cod_relacion
      from cntas_cobrar cc,
           cntbl_asiento_det cad
     where cc.origen         = cad.origen
       and cc.ano            = cad.ano
       and cc.mes            = cad.mes
       and cc.nro_libro      = cad.nro_libro
       and cc.nro_asiento    = cad.nro_Asiento
       and cc.tipo_doc       = cad.tipo_docref1
       and cc.nro_doc        = cad.nro_docref1
       and cc.tipo_doc       = ls_tipo_doc_cxc
       and cc.nro_doc        = ls_nro_doc_cxc
       and cad.flag_debhab   = 'D'
       and cad.cnta_ctbl     like '12%';

    -- Inserto la cuenta contable en el asiento
    ln_item := ln_item + 1;
                  
    insert into cntbl_asiento_det(
           origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
           det_glosa, flag_gen_aut, flag_debhab, 
           tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol)
    values(
           ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fecha_fs,
           ls_det_glosa, '0', 'H',   
           ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol);
    
    -- Obtengo los totales del asiento
    select nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
      into ln_tot_soldeb, ln_tot_solhab, ln_tot_doldeb, ln_tot_dolhab
      from cntbl_asiento_det cad
     where cad.origen           = ls_origen
       and cad.ano              = ln_year
       and cad.mes              = ln_mes
       and cad.nro_libro        = ln_nro_libro
       and cad.nro_asiento      = ln_nro_asiento;
    
    -- Actualizo los totales del asiento contable generado
    update cntbl_asiento ca
       set ca.tot_soldeb = ln_tot_soldeb,
           ca.tot_solhab = ln_tot_solhab,
           ca.tot_doldeb = ln_tot_doldeb,
           ca.tot_dolhab = ln_tot_dolhab
     where ca.origen           = ls_org_caja
       and ca.ano              = ln_year
       and ca.mes              = ln_mes
       and ca.nro_libro        = ln_nro_libro
       and ca.nro_asiento      = ln_nro_asiento;

    /***********************************************************************************************/
    -- PASO 3. CREO LA APLICACION DE DOCUMENTOS CORRESPONDIENTE
    /***********************************************************************************************/
    if ln_reg_caja is null then
      
       if ls_org_caja is null then
          ls_org_caja := ls_origen;
       end if;
       
       -- Creo un nuevo numero de caja_bancos
       select count(*)
         into ln_count
         from num_caja_bancos n
        where n.origen = ls_org_caja;
       
       if ln_count = 0 then
          insert into num_caja_bancos(
                 origen, ult_nro)
          values(
                 ls_org_caja, 1);
       end if;
       
       select ult_nro
         into ln_reg_caja
         from num_caja_bancos n
        where n.origen = ls_org_caja for update;
       
       -- Incremento el numerador
       update num_caja_bancos n
          set n.ult_nro = ln_reg_caja + 1
        where n.origen = ls_org_caja;
       
       -- Inserto la cabecera en caja_bancos
       insert into caja_bancos(
              origen,  nro_registro, flag_estado, fecha_emision, flag_pago, cod_moneda, cod_relacion,
              cod_usr, imp_total, confin, ano, mes, nro_libro, nro_asiento, flag_tiptran, obs,
              tipo_doc, nro_doc, flag_conciliacion, tasa_cambio, flag_replicacion,
              fec_registro)
       values(
              ls_org_caja, ln_reg_caja, '1', ld_fecha_fs, 'E', ls_moneda_fs, ls_cliente,
              asi_cod_usr, 0.00, 'FI-001', ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, '4', ls_det_glosa,
              ls_tipo_ref, ls_nro_ref, '0', ln_tasa_cambio, '1',
              sysdate);
       
       -- Actualizo la referencia en fs_factura_simpl_pagos
       update fs_factura_simpl_pagos fp
          set fp.org_caja = ls_org_caja,
              fp.reg_caja = ln_reg_caja
        where fp.nro_registro    = asi_nro_registro
          and fp.flag_forma_pago = asi_flag_forma_pago
          and fp.nro_item        = ani_nro_item;
          
    else
       --Elimino el detalle de caja bancos
       delete caja_bancos_det cbd
        where cbd.origen = ls_org_caja
          and cbd.nro_registro = ln_reg_caja;
    end if;
    
    -- Inserto el detalle de la aplicacion de documentos
    ln_item := 1;
    
    -- 1.- Inserto la factura a la que le estoy descontando
    ln_item := ln_item + 1;
    
    insert into caja_bancos_det(
           origen, nro_registro, item,         cod_relacion, tipo_doc,   nro_doc,         importe, flab_tabor,
           confin, origen_doc,   impt_ret_igv, flag_ret_igv, cod_moneda, flag_flujo_caja, factor,  flag_provisionado,
           flag_replicacion)
    values(        
           ls_org_caja, ln_reg_caja, ln_item, ls_cliente, ls_tipo_doc_cxc, ls_nro_doc_cxc, ln_imp_pago, '1',
           'FI-001', ls_origen, 0.00, '0', ls_moneda_fs, '1', -1, 'R',
           '1');
  
    -- 2.- Inserto la nota de credito que estoy descontando
    ln_item := ln_item + 1;
    
    insert into caja_bancos_det(
           origen, nro_registro, item,         cod_relacion, tipo_doc,   nro_doc,         importe, flab_tabor,
           confin, origen_doc,   impt_ret_igv, flag_ret_igv, cod_moneda, flag_flujo_caja, factor,  flag_provisionado,
           flag_replicacion)
    values(        
           ls_org_caja, ln_reg_caja, ln_item, ls_cliente, ls_tipo_ref, ls_nro_ref, ln_imp_pago, '1',
           'FI-001', ls_origen, 0.00, '0', ls_moneda_fs, '1', 1, 'R',
           '1');

  end ;
  
  -- Proceso de credito directo, genero las letras por cobrar
  procedure of_procesar_cred_directo(
    asi_nro_registro  	  in fs_factura_simpl_pagos.nro_registro%TYPE,
    asi_flag_forma_pago   in fs_factura_simpl_pagos.flag_forma_pago%TYPE,
    ani_nro_item          in fs_factura_simpl_pagos.nro_item%TYPE,
    asi_cod_usr           in fs_factura_simpl_pagos.cod_usr%TYPE
  ) is
  
  -- fs_factura_simpl
  ls_tipo_doc_ref     fs_factura_simpl.tipo_doc_cxc%TYPE;
  ls_nro_doc_ref      fs_factura_simpl.nro_doc_cxc%TYPE;
  ld_fec_registro     fs_factura_simpl.fec_registro%TYPE;
  ls_moneda           fs_factura_simpl.cod_moneda%TYPE;
  ln_tasa_cambio      fs_factura_simpl.tasa_cambio%TYPE;
  ls_cliente          fs_factura_simpl.cliente%TYPE;
  
  -- fs_factura_simpl_pagos
  ln_nro_cuotas       fs_factura_simpl_pagos.nro_cuotas%TYPE;
  ln_porc_interes     fs_factura_simpl_pagos.porc_interes%TYPE;
  ln_nro_cuota        fs_factura_simpl_pagos_ref.nro_cuota%TYPE;
  ln_total_capital    fs_factura_simpl_pagos.monto_pago%TYPE;
  ln_capital_cuota    fs_factura_simpl_pagos_ref.capital%TYPE;
  ln_interes_cuota    fs_factura_simpl_pagos_ref.interes%TYPE;
  ls_tipo_doc_interes fs_factura_simpl_pagos.tipo_doc_interes%TYPE;
  ls_nro_doc_interes  fs_factura_simpl_pagos.nro_doc_interes%TYPE;
  ln_interes_acum     fs_factura_simpl_pagos_ref.interes%TYPE;
  ln_capital_acum     fs_factura_simpl_pagos_ref.capital%TYPE;
  
  -- Otras Variables
  ln_count            number;
  ls_tipo_doc_ltc     cntas_cobrar.tipo_doc%TYPE;
  ls_nro_doc_ltc      cntas_cobrar.nro_doc%TYPE;
  ln_total_interes    cntas_cobrar.importe_doc%TYPE;
  
  -- datos para el asiento contable
  ls_origen           cntbl_asiento.origen%TYPE;
  ln_year             cntbl_asiento.ano%TYPE;
  ln_mes              cntbl_asiento.mes%TYPE;
  ln_nro_libro        cntbl_Asiento.Nro_Libro%TYPE;
  ln_nro_Asiento      cntbl_asiento.nro_asiento%TYPE;
  ls_desc_glosa       cntbl_asiento.desc_glosa%TYPE;
  ln_tot_soldeb       cntbl_asiento.tot_soldeb%TYPE;
  ln_tot_solhab       cntbl_Asiento.Tot_Solhab%TYPE;
  ln_tot_doldeb       cntbl_asiento.tot_doldeb%TYPE;
  ln_tot_dolhab       cntbl_asiento.tot_dolhab%TYPE;
  
  -- Datos para el detalle del asiento contable
  ln_item             cntbl_asiento_det.item%TYPE;
  ls_cnta_cntbl       cntbl_Asiento_det.Cnta_Ctbl%TYPE;
  ln_imp_movsol       cntbl_asiento_det.imp_movsol%TYPE;
  ln_imp_movdol       cntbl_Asiento_det.Imp_Movdol%TYPE;
  
  -- Variable para la insercion del canje del documento por cobrar
  ls_flag_create      char(1) := '0';
  ln_ult_nro          num_doc_tipo.ultimo_numero%TYPE;
  ld_fec_vencimiento  cntas_cobrar.fecha_vencimiento%TYPE;
  ls_day              varchar2(2);
  
  begin
    -- Datos de la cabecera
    select f.tipo_doc_cxc, f.nro_doc_cxc, f.fec_movimiento, f.cod_origen, f.cod_moneda,
           f.tasa_cambio, substr(f.observacion, 1, 200), f.cliente
      into ls_tipo_doc_ref, ls_nro_doc_ref, ld_fec_registro, ls_origen, ls_moneda,
           ln_tasa_cambio, ls_desc_glosa, ls_Cliente
      from fs_factura_simpl f
     where f.nro_registro = asi_nro_registro;  
    
    if ls_tipo_doc_ref is null or ls_nro_doc_ref is null then
       RAISE_APPLICATION_ERROR(-20000, 'Error, el tipo o numero de documento es nulo para el regsitro ' 
                        || asi_nro_registro || ', por favor verifique!'
                        || chr(13) || 'Tipo Doc: ' || nvl(ls_tipo_doc_ref, 'S/R')
                        || chr(13) || 'Nro Doc: ' || nvl(ls_nro_doc_ref, 'S/R')
                        || chr(13) || 'Por favor verifique!!!');
    end if;
    
    -- Datos del pago
    select nvl(fp.nro_cuotas, 1), nvl(fp.porc_interes, 0), NVL(fp.monto_pago, 0), fp.tipo_doc_interes, fp.nro_doc_interes,
           fp.primer_vencimiento
      into ln_nro_cuotas, ln_porc_interes, ln_total_capital, ls_tipo_doc_interes, ls_nro_doc_interes,
           ld_fec_vencimiento
      from fs_factura_simpl_pagos fp
     where fp.nro_registro    = asi_nro_registro
       and fp.flag_forma_pago = asi_flag_forma_pago
       and fp.nro_item        = ani_nro_item;
    
    if ln_nro_cuotas = 0 then ln_nro_cuotas := 1; end if;
    
    if ln_total_capital = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'El capital debe ser mayor a cero. Por favor verifique!'
                         || chr(13) || 'Nro Registro: ' || asi_nro_registro
                         || chr(13) || 'Documento: ' || ls_tipo_doc_ref || '-' || ls_nro_doc_ref);
    end if;

    -- Calculando los intereses
    ln_total_interes := round(ln_total_capital * ln_porc_interes / 100,2);
    
    if ln_total_interes > 0 then
       --Genero el crompobante por cobrar por el interes
       of_Generar_cxc_interes(asi_nro_registro, asi_flag_forma_pago, ani_nro_item, ln_total_interes, asi_cod_usr, 
                              ls_tipo_doc_interes, ls_nro_doc_interes);  
    else
       if ls_tipo_doc_interes is not null and ls_nro_doc_interes is not null then
          -- Anulo el comprobante de ventas
          of_anular_cxc(ls_tipo_doc_interes, ls_nro_doc_interes);  
       end if;
       
       -- Pongo el interes en cero
       update fs_factura_simpl_pagos fp
          set fp.total_interes = 0,
              fp.tipo_doc_interes = null,
              fp.nro_doc_interes  = null
        where fp.nro_registro  = asi_nro_registro
          and fp.flag_forma_pago = asi_flag_forma_pago
          and fp.nro_item        = ani_nro_item;
    end if;
    
    -- Verificando el total de registros en las cuotas
    select count(*)
      into ln_count
      from fs_factura_simpl_pagos_ref pr
     where pr.nro_registro            = asi_nro_registro
       and pr.flag_forma_pago         = asi_flag_forma_pago
       and pr.nro_item                = ani_nro_item;
    
    if ln_count > ln_nro_cuotas then
       RAISE_APPLICATION_ERROR(-20000, 'El numero de cuotas es menor al registrado anteriormente. Por favor verifique!'
                         || chr(13) || 'Nro Cuotas: ' || trim(to_char(ln_nro_cuotas))
                         || chr(13) || 'Cuotas previas: ' || trim(to_char(ln_count)));
    end if;
    
    -- Calculo el valor del capital y el interes por cada cuota
    ln_capital_cuota := round(ln_total_capital / ln_nro_cuotas,2);
    ln_interes_cuota := round(ln_total_interes / ln_nro_cuotas,2);
    
    --Si la fecha de vencimiento es nula entonces tomo la fecha de registro
    If ld_fec_vencimiento is null then
       ld_fec_vencimiento := ld_fec_registro + 30;
    end if;
    
    -- Saco el dia del primer vencimiento
    ls_day := trim(to_char(ld_fec_vencimiento, 'dd'));
    
    -- recorro cada cuota para generar el documento
    FOR ln_nro_cuota IN 1..ln_nro_cuotas LOOP
        -- Calculo el interes de la ultima cuota
        if ln_nro_cuota = ln_nro_cuotas then
           select nvl(sum(pr.capital),0), nvl(sum(pr.interes), 0)
             into ln_capital_acum, ln_interes_acum
              from fs_factura_simpl_pagos_ref pr
             where pr.nro_registro            = asi_nro_registro
               and pr.flag_forma_pago         = asi_flag_forma_pago
               and pr.nro_item                = ani_nro_item
               and pr.nro_cuota               < ln_nro_cuota;
          
          ln_interes_cuota := ln_total_interes - ln_interes_acum;
          ln_capital_cuota := ln_total_capital - ln_capital_acum;
          
          if ln_interes_cuota < 0 then ln_interes_cuota := 0; end if;
          if ln_capital_cuota < 0 then ln_capital_cuota := 0; end if;
        end if;
        
        select count(*)
          into ln_count
          from fs_factura_simpl_pagos_ref pr
         where pr.nro_registro            = asi_nro_registro
           and pr.flag_forma_pago         = asi_flag_forma_pago
           and pr.nro_item                = ani_nro_item
           and pr.nro_cuota               = ln_nro_cuota;
        
        if ln_count > 0 then
           -- Obtengo lo datos que necesito
           select pr.org_asiento, pr.ano_asiento, pr.mes_asiento, pr.libro_asiento, pr.nro_asiento,
                  pr.tipo_doc_cxc, pr.nro_doc_cxc
             into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_Asiento,
                  ls_tipo_doc_ltc, ls_nro_doc_ltc
             from fs_factura_simpl_pagos_ref pr
            where pr.nro_registro            = asi_nro_registro
              and pr.flag_forma_pago         = asi_flag_forma_pago
              and pr.nro_item                = ani_nro_item
              and pr.nro_cuota               = ln_nro_cuota;
           
           -- Elimino el detalle del asiento
           delete cntbl_Asiento_det cad
            where cad.origen        = ls_origen
              and cad.ano           = ln_year
              and cad.mes           = ln_mes
              and cad.nro_libro     = ln_nro_libro
              and cad.nro_Asiento   = ln_nro_asiento;
           
           -- Actualizo datos
           update fs_factura_simpl_pagos_ref pr
              set pr.capital = ln_capital_cuota,
                  pr.interes = ln_interes_cuota
            where pr.nro_registro            = asi_nro_registro
              and pr.flag_forma_pago         = asi_flag_forma_pago
              and pr.nro_item                = ani_nro_item
              and pr.nro_cuota               = ln_nro_cuota;
           
           if ls_nro_doc_ltc is null then
              ls_flag_create := '1';
           else
              ls_flag_create := '0';
           end if;
        else
           ls_flag_create := '1';
           ls_nro_doc_ltc := null;
           
           -- Obtengo el periodo
           ln_year := to_number(to_char(ld_fec_registro, 'yyyy'));
           ln_mes  := to_number(to_char(ld_fec_registro, 'mm'));
           
           -- Obtengo el tipo de documento segun el nro de cuotas
           ls_tipo_doc_ltc := PKG_FACT_ELECTRONICA.is_doc_ltc;

           -- Realizo algunas validaciones
           select count(*)
             into ln_count
             from doc_tipo dt
            where dt.tipo_doc = ls_tipo_doc_ltc;
        
           if ln_count = 0 then
              RAISE_APPLICATION_ERROR(-20000, 'Error, no existe el tipo de documento ' || ls_tipo_doc_ltc || '. Por favor verifique!!!');
           end if;
        
           -- Obtengo el libro contable de dicho documento
           select dt.nro_libro
             into ln_nro_libro
             from doc_tipo dt
            where dt.tipo_doc = ls_tipo_doc_ltc;
           
           -- Creo el siguiente numero
           select count(*)
             into ln_count
             from cntbl_libro_mes clm
            where clm.origen      = ls_origen
              and clm.ano         = ln_year
              and clm.mes         = ln_mes
              and clm.nro_libro   = ln_nro_libro;
           
           if ln_count = 0 then
              insert into cntbl_libro_mes(
                     origen, nro_libro, ano, mes, nro_asiento)
              values(
                     ls_origen, ln_nro_libro, ln_year, ln_mes, 1);
           end if;
           
           select clm.nro_asiento
             into ln_nro_Asiento
             from cntbl_libro_mes clm
            where clm.origen      = ls_origen
              and clm.ano         = ln_year
              and clm.mes         = ln_mes
              and clm.nro_libro   = ln_nro_libro for update; 
           
           -- Actualizo el numerador del asiento
           update cntbl_libro_mes clm
              set clm.nro_asiento = ln_nro_Asiento + 1
            where clm.origen      = ls_origen
              and clm.ano         = ln_year
              and clm.mes         = ln_mes
              and clm.nro_libro   = ln_nro_libro;

           -- inserto la cabecera del asiento
           insert into cntbl_asiento(
                     origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, 
                     desc_glosa, fecha_cntbl, fec_registro, 
                     cod_usr, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf)
           values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ls_moneda, ln_tasa_cambio, 
                     ls_desc_glosa, trunc(ld_fec_registro), sysdate,
                     asi_cod_usr, '1', 0, 0, 0, 0, '0');
           
           -- Inserto la referencia en la tabla
           insert into fs_factura_simpl_pagos_ref(
                  nro_registro, flag_forma_pago, nro_item, 
                  org_asiento, ano_asiento, mes_asiento, libro_asiento, nro_asiento,
                  tipo_doc_cxc, nro_doc_cxc, nro_cuota, capital, interes)
           values(              
                  asi_nro_registro, asi_flag_forma_pago, ani_nro_item, 
                  ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento,
                  null, null, ln_nro_cuota, ln_capital_cuota, ln_interes_cuota);
        end if;
        
        if ls_nro_doc_ltc is null then
           -- Obtengo el siguiente numero del documento
           select count(*)
             into ln_count
             from num_doc_tipo n
            where n.tipo_doc = ls_tipo_doc_ltc
              and n.nro_serie = '1';
              
           if ln_count = 0 then
              insert into num_doc_tipo(
                     tipo_doc, ultimo_numero, nro_serie)
              values(
                     ls_tipo_doc_ltc, 1, '1');
           end if; 
              
           select n.ultimo_numero
             into ln_ult_nro
             from num_doc_tipo n
            where n.tipo_doc = ls_tipo_doc_ltc
              and n.nro_serie = '1' for update;
              
           -- Actualizo el numerador
           update num_doc_tipo n
              set n.ultimo_numero = ln_ult_nro + 1
            where n.tipo_doc = ls_tipo_doc_ltc
              and n.nro_serie = '1';
              
           ls_nro_doc_ltc := '1-' || trim(to_char(ln_ult_nro));
        end if;
        
        -- Primero hago la provision del capital
        if ls_moneda = PKG_LOGISTICA.is_soles then
           ln_imp_movsol := ln_capital_cuota;
           ln_imp_movdol := ln_imp_movsol / ln_Tasa_cambio;
        else
           ln_imp_movdol := ln_capital_cuota;
           ln_imp_movsol := ln_imp_movdol * ln_Tasa_cambio;
        end if;

        ln_item := 1;
        
        -- Obtengo la primera linea del asiento contable, reduzco la cuenta 12 del documento de origen
        /*******************************************************************************************/
        select count(distinct cad.cnta_ctbl)
          into ln_count
          from cntbl_asiento_det cad,
               fs_factura_simpl  f
         where cad.origen        = f.cod_origen
           and cad.ano           = f.ano
           and cad.mes           = f.mes
           and cad.nro_libro     = f.nro_libro
           and cad.nro_Asiento   = f.nro_Asiento
           and cad.flag_debhab   = 'D'
           and cad.cod_relacion  = ls_cliente
           and cad.tipo_docref1  = ls_tipo_doc_ref
           and cad.nro_docref1   = ls_nro_doc_ref   ;
        
        if ln_count = 0 then
           RAISE_APPLICATION_ERROR(-20000, 'No existe una cuenta contable que sea cuenta corriente en el asiento'
                                        || ' de provision del comprobante de venta. Por favor verifique!'
                                        || chr(13) || 'Documento: ' || ls_tipo_doc_ref || '-' || ls_nro_doc_ref); 
        end if;

        if ln_count >1 then
           RAISE_APPLICATION_ERROR(-20000, 'Existen ' || trim(to_char(ln_count)) || ' cuentas contables que son cuenta corriente '
                                        || 'en el asiento de provision del comprobante de venta. Por favor verifique!'
                                        || chr(13) || 'Documento: ' || ls_tipo_doc_ref || '-' || ls_nro_doc_ref); 
        end if;
        
        -- Obtengo la cuenta contable
        select distinct cad.cnta_ctbl
          into ls_cnta_cntbl
          from cntbl_asiento_det cad,
               fs_factura_simpl  f
         where cad.origen        = f.cod_origen
           and cad.ano           = f.ano
           and cad.mes           = f.mes
           and cad.nro_libro     = f.nro_libro
           and cad.nro_Asiento   = f.nro_Asiento
           and cad.flag_debhab   = 'D'
           and cad.cod_relacion  = ls_cliente
           and cad.tipo_docref1  = ls_tipo_doc_ref
           and cad.nro_docref1   = ls_nro_doc_ref   ;
        
        
        insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, cod_ctabco, imp_movsol, imp_movdol)
        values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, trunc(ld_fec_registro),
                 'VENTA EN CREDITO DIRECTO. NRO CUOTA: ' || trim(to_char(ln_nro_cuota)), '0', 'H',   
                 ls_tipo_doc_ref, ls_nro_doc_ref, ls_cliente, null, ln_imp_movsol, ln_imp_movdol);
                 
        
        -- Actualizo el saldo de la cuenta x cobrar
        /******************************************/
        update cntas_cobrar cc
           set cc.saldo_sol = cc.saldo_sol - ln_imp_movsol,
               cc.saldo_dol = cc.saldo_dol - ln_imp_movdol
         where cc.tipo_doc  = ls_tipo_doc_ref
           and cc.nro_doc   = ls_nro_doc_ref;
           
        -- Actualizo la cuenta corriente
        /*******************************/
        update doc_pendientes_cta_cte dc
           set dc.sldo_sol  = dc.sldo_sol  - ln_imp_movsol,
               dc.saldo_dol = dc.saldo_dol - ln_imp_movdol
         where dc.cod_relacion = ls_cliente
           and dc.tipo_doc     = ls_tipo_doc_ref
           and dc.nro_doc      = ls_nro_doc_ref;
           


        /*******************************************************************************************/
        -- Hago la provision del interes de la cuota
        /*******************************************************************************************/
        if ls_moneda = PKG_LOGISTICA.is_soles then
           ln_imp_movsol := ln_interes_cuota;
           ln_imp_movdol := ln_imp_movsol / ln_Tasa_cambio;
        else
           ln_imp_movdol := ln_interes_cuota;
           ln_imp_movsol := ln_imp_movdol * ln_Tasa_cambio;
        end if;

        -- Obtengo la linea del asiento contable, reduzco la cuenta 12 del documento de interes
        /*******************************************************************************************/
        if ln_interes_cuota > 0 then
           ln_item := ln_item + 1;
            select count(distinct cad.cnta_ctbl)
              into ln_count
              from cntbl_asiento_det cad,
                   fs_factura_simpl  f
             where cad.nro_libro     = f.nro_libro
               and cad.flag_debhab   = 'D'
               and cad.cod_relacion  = ls_cliente
               and cad.tipo_docref1  = ls_tipo_doc_interes
               and cad.nro_docref1   = ls_nro_doc_interes   ;
            
            if ln_count = 0 then
               RAISE_APPLICATION_ERROR(-20000, 'No existe una cuenta contable que sea cuenta corriente en el asiento'
                                            || ' de provision del comprobante de venta para el interes. Por favor verifique!'
                                            || chr(13) || 'Documento: ' || ls_tipo_doc_interes || '-' || ls_nro_doc_interes); 
            end if;

            if ln_count >1 then
               RAISE_APPLICATION_ERROR(-20000, 'Existen ' || trim(to_char(ln_count)) || ' cuentas contables que son cuenta corriente '
                                            || 'en el asiento de provision del comprobante de venta. Por favor verifique!'
                                            || chr(13) || 'Documento: ' || ls_tipo_doc_interes || '-' || ls_nro_doc_interes); 
            end if;
            
            -- Obtengo la cuenta contable
            select distinct cad.cnta_ctbl
              into ls_cnta_cntbl
              from cntbl_asiento_det cad,
                   fs_factura_simpl  f
             where cad.nro_libro     = f.nro_libro
               and cad.flag_debhab   = 'D'
               and cad.cod_relacion  = ls_cliente
               and cad.tipo_docref1  = ls_tipo_doc_interes
               and cad.nro_docref1   = ls_nro_doc_interes   ;
            
            
            insert into cntbl_asiento_det(
                     origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                     det_glosa, flag_gen_aut, flag_debhab, 
                     tipo_docref1, nro_docref1, cod_relacion, cod_ctabco, imp_movsol, imp_movdol)
            values(
                     ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, trunc(ld_fec_registro),
                     'VENTA EN CREDITO DIRECTO. NRO CUOTA: ' || trim(to_char(ln_nro_cuota)), '0', 'H',   
                     ls_tipo_doc_interes, ls_nro_doc_interes, ls_cliente, null, ln_imp_movsol, ln_imp_movdol);

            -- Actualizo el saldo de la cuenta x cobrar
            /******************************************/
            update cntas_cobrar cc
               set cc.saldo_sol = cc.saldo_sol - ln_imp_movsol,
                   cc.saldo_dol = cc.saldo_dol - ln_imp_movdol
             where cc.tipo_doc  = ls_tipo_doc_interes
               and cc.nro_doc   = ls_nro_doc_interes;

            -- Actualizo la cuenta corriente
            /*******************************/
            update doc_pendientes_cta_cte dc
               set dc.sldo_sol  = dc.sldo_sol  - ln_imp_movsol,
                   dc.saldo_dol = dc.saldo_dol - ln_imp_movdol
             where dc.cod_relacion = ls_cliente
               and dc.tipo_doc     = ls_tipo_doc_interes
               and dc.nro_doc      = ls_nro_doc_interes;
               
        end if;   

        -- Obtengo la TERCERA linea del asiento contable, coloco la cuenta de la letra
        /*******************************************************************************************/
        ln_item := ln_item + 1;
        
        if ls_moneda = PKG_LOGISTICA.is_soles then
           ls_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_ltc_mn;
        else
           ls_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_ltc_me;
        end if;
        
        insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, cod_ctabco, imp_movsol, imp_movdol)
        values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, trunc(ld_fec_registro),
                 'VENTA EN CREDITO DIRECTO. NRO CUOTA: ' || trim(to_char(ln_nro_cuota)), '0', 'D',   
                 ls_tipo_doc_ltc, ls_nro_doc_ltc, ls_cliente, null, ln_imp_movsol, ln_imp_movdol);
        
        -- Obtengo los totales del asiento
        /*******************************************************************************************/
        select nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
               nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
               nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
               nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
          into ln_tot_soldeb, ln_tot_solhab, ln_tot_doldeb, ln_tot_dolhab
          from cntbl_asiento_det cad
         where cad.origen           = ls_origen
           and cad.ano              = ln_year
           and cad.mes              = ln_mes
           and cad.nro_libro        = ln_nro_libro
           and cad.nro_asiento      = ln_nro_asiento;
      
        -- Actualizo los totales del asiento contable generado
        update cntbl_asiento ca
           set ca.tot_soldeb = ln_tot_soldeb,
               ca.tot_solhab = ln_tot_solhab,
               ca.tot_doldeb = ln_tot_doldeb,
               ca.tot_dolhab = ln_tot_dolhab
         where ca.origen           = ls_origen
           and ca.ano              = ln_year
           and ca.mes              = ln_mes
           and ca.nro_libro        = ln_nro_libro
           and ca.nro_asiento      = ln_nro_asiento;
        
        if ls_moneda = PKG_LOGISTICA.is_soles then
           ln_imp_movsol := ln_capital_cuota + ln_interes_cuota;
           ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
        else
           ln_imp_movdol := ln_capital_cuota + ln_interes_cuota;
           ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
        end if;
        
        if ls_flag_create = '1' then
           -- Ahora inserto el documento por  el canje de documentos por cobrar
           -- Por ahora solo el capital
           /*******************************************************************/
           insert into cntas_cobrar(
                  tipo_doc,        nro_doc,           cod_relacion,      flag_estado,      fecha_registro,
                  fecha_documento, fecha_vencimiento, cod_moneda,       tasa_cambio, 
                  cod_usr,         forma_pago,        origen,            ano,              mes,
                  nro_libro,       nro_asiento,       observacion,       flag_detraccion,
                  flag_situacion_ltr,
                  nro_ren_ltr,
                  flag_tipo_ltr,
                  flag_provisionado,
                  importe_doc,
                  saldo_sol,
                  saldo_dol)
           values(
                  ls_tipo_doc_ltc,     ls_nro_doc_ltc,  ls_cliente, '1', sysdate,
                  trunc(ld_fec_registro), ld_fec_vencimiento, ls_moneda, ln_tasa_cambio,
                  asi_cod_usr,     PKG_FACT_ELECTRONICA.is_fp_F30d, ls_origen, ln_year, ln_mes,
                  ln_nro_libro,    ln_nro_Asiento,                  
                  'VENTA POR CREDITO DIRECTO' || ls_tipo_doc_ref || '/' || ls_nro_doc_ref || '. NRO CUOTA: ' || trim(to_char(ln_nro_cuota)),
                  '0',
                  '1',
                  0,
                  'C',
                  'R',
                  ln_capital_cuota + ln_interes_cuota,
                  ln_imp_movsol,
                  ln_imp_movdol);
           
           update fs_factura_simpl_pagos_ref pr
              set pr.tipo_doc_cxc = ls_tipo_doc_ltc,
                  pr.nro_doc_cxc  = ls_nro_doc_ltc
            where pr.nro_registro    = asi_nro_registro
              and pr.flag_forma_pago = asi_flag_forma_pago
              and pr.nro_item        = ani_nro_item
              and pr.nro_cuota       = ln_nro_cuota;  
        else
           update cntas_cobrar cc
              set cc.fecha_vencimiento = ld_fec_vencimiento,
                  cc.importe_doc       = ln_capital_cuota + ln_interes_cuota,
                  cc.saldo_sol         = ln_imp_movsol,
                  cc.saldo_dol         = ln_imp_movdol,
                  cc.fecha_documento   = trunc(ld_fec_registro)
            where cc.tipo_doc          = ls_tipo_doc_ltc
              and cc.nro_doc           = ls_nro_doc_ltc;  
           
           delete doc_referencias dr
            where dr.tipo_doc     = ls_tipo_doc_ltc
              and dr.nro_doc      = ls_nro_doc_ltc;
        
        end if;
        
        -- Ahora insert el detalle del canje de documentos por cobrar
        -- Primero el capital
        /*******************************************************************/
        insert into doc_referencias(
               cod_relacion, tipo_doc, nro_doc, tipo_mov, origen_ref, tipo_ref, nro_ref, importe, 
               proveedor_ref, flag_provisionado)
        values(
               ls_cliente, ls_tipo_doc_ltc, ls_nro_doc_ltc, 'C', ls_origen, ls_tipo_doc_ref, ls_nro_doc_ref, ln_capital_cuota, 
               ls_cliente, 'R');
        
        -- Luego el interes
        /*******************************************************************/
        if ln_interes_cuota > 0 then
            insert into doc_referencias(
                   cod_relacion, tipo_doc, nro_doc, tipo_mov, origen_ref, tipo_ref, nro_ref, importe, 
                   proveedor_ref, flag_provisionado)
            values(
                   ls_cliente, ls_tipo_doc_ltc, ls_nro_doc_ltc, 'C', ls_origen, ls_tipo_doc_interes, ls_nro_doc_interes, ln_interes_cuota, 
                   ls_cliente, 'R');
        end if;
        
        -- Incremento la fecha de vencimiento en 30 dias para el siguiente documento
        /*
        if to_char(ld_fec_vencimiento, 'mm') = '02' then
           ld_fec_vencimiento := trunc(ld_fec_vencimiento) + 28;
        elsif to_char(ld_fec_vencimiento, 'mm') in ('01', '03', '05', '07', '08', '10', '12') then
           ld_fec_vencimiento := trunc(ld_fec_vencimiento) + 31;
        else
           ld_fec_vencimiento := trunc(ld_fec_vencimiento) + 30;
        end if;
        */
        ln_year := to_number(to_char(ld_fec_vencimiento, 'yyyy'));
        ln_mes  := to_number(to_char(ld_fec_vencimiento, 'mm'));
        
        if ln_mes = 12 then
           ln_mes := 1;
           ln_year := ln_year + 1;
        else
           ln_mes := ln_mes + 1;
        end if;
        
        if trim(to_char(ln_year, '0000')) || trim(to_char(ln_mes, '00')) || ls_day > to_char(PKG_UTILITY.of_Last_Day(ln_year, ln_mes), 'yyyymmdd') then
           ld_fec_vencimiento := PKG_UTILITY.of_Last_Day(ln_year, ln_mes);
        else
           ld_fec_vencimiento := to_date(ls_day || '/' || trim(to_char(ln_mes, '00')) || '/' || trim(to_char(ln_year, '0000')), 'dd/mm/yyyy');
        end if;

    END LOOP;
    
  end;

  /***********************************************************************************************************
      Este procedimiento anula todo el comprobante por cobrar
  ************************************************************************************************************/
  procedure of_anular_cxc(
    asi_tipo_doc      in cntas_cobrar.tipo_doc%TYPE,
    asi_nro_doc       in cntas_cobrar.nro_doc%TYPE
  ) is
  
    ls_origen         cntbl_asiento.origen%TYPE;
    ln_year           cntbl_asiento.ano%TYPE;
    ln_mes            cntbl_Asiento.mes%TYPE;
    ln_nro_libro      cntbl_asiento.nro_libro%TYPE;
    ln_nro_asiento    cntbl_asiento.nro_asiento%TYPE;
    
    ln_count          number;
    
  begin
    -- Obtengo el asiento contable de la cuenta por cobrar
    select count(*)
      into ln_count
      from cntas_cobrar cc
     where cc.tipo_doc  = asi_tipo_doc
       and cc.nro_doc   = asi_nro_doc;
    
    if ln_count = 0 then return; end if;
    
    select cc.origen, cc.ano, cc.mes, cc.nro_libro, cc.nro_asiento
      into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento
      from cntas_cobrar cc
     where cc.tipo_doc = asi_tipo_doc
       and cc.nro_doc  = asi_nro_doc;
    
    -- anulo el asiento contable
    update cntbl_asiento_det cad
       set cad.imp_movsol = 0,
           cad.imp_movdol = 0
     where cad.origen      = ls_origen
       and cad.ano         = ln_year
       and cad.mes         = ln_mes
       and cad.nro_libro   = ln_nro_libro
       and cad.nro_asiento = ln_nro_asiento;

    update cntbl_asiento ca
       set ca.tot_soldeb = 0,
           ca.tot_solhab = 0,
           ca.tot_doldeb = 0,
           ca.tot_dolhab = 0,
           ca.flag_estado = '0'
     where ca.origen      = ls_origen
       and ca.ano         = ln_year
       and ca.mes         = ln_mes
       and ca.nro_libro   = ln_nro_libro
       and ca.nro_asiento = ln_nro_asiento;

    -- Anulo la cuenta por cobrar
    update cc_doc_det_imp ci
       set ci.importe = 0
      where ci.tipo_doc = asi_tipo_doc
        and ci.nro_doc  = asi_nro_doc;
         
    update cntas_cobrar_det ccd
       set ccd.precio_unitario = 0,
           ccd.cantidad        = 0
      where ccd.tipo_doc = asi_tipo_doc
        and ccd.nro_doc  = asi_nro_doc;

    update cntas_cobrar cc
       set cc.saldo_sol = 0,
           cc.saldo_dol = 0,
           cc.importe_doc = 0,
           cc.flag_estado = '0'
      where cc.tipo_doc = asi_tipo_doc
        and cc.nro_doc  = asi_nro_doc;

  end;
  
  /***********************************************************************************************************
      Este procedimiento general el documento por cobrar y el asiento correspondiente para los intereses
  ************************************************************************************************************/
  procedure of_Generar_cxc_interes(
     asi_nro_registro      in fs_factura_simpl_pagos.nro_registro%TYPE,
     asi_flag_forma_pago   in fs_factura_simpl_pagos.flag_forma_pago%TYPE,
     ani_nro_item          in fs_factura_simpl_pagos.nro_item%TYPE,
     ani_total_interes     in cntas_cobrar.importe_doc%TYPE,
     asi_cod_usr           in fs_factura_simpl_pagos.cod_usr%TYPE,
     aso_tipo_doc_interes  out fs_factura_simpl_pagos.tipo_doc_interes%TYPE,
     aso_nro_doc_interes   out fs_factura_simpl_pagos.nro_doc_interes%TYPE
  ) is
     
     -- Tabla fs_factura_simpl
     ls_tipo_ref           fs_factura_simpl.tipo_doc_cxc%TYPE;
     ls_nro_ref            fs_factura_simpl.nro_cxc%TYPE;
     ld_Fec_registro       fs_factura_simpl.fec_registro%TYPE;
     ls_origen_fs          fs_factura_simpl.cod_origen%TYPE;
     ls_moneda             fs_factura_simpl.cod_moneda%TYPE;
     ln_tasa_cambio        fs_factura_simpl.tasa_cambio%TYPE;
     ls_cliente            fs_factura_simpl.cliente%TYPE;
     ls_serie_doc          fs_factura_simpl.serie_cxc%TYPE;
     ls_vendedor           fs_factura_simpl.vendedor%TYPE;
     ls_punto_venta        fs_factura_simpl.punto_venta%TYPE;
     ln_item_dir           fs_factura_simpl.item_direccion%TYPE;
     ls_nro_rc_id          fs_factura_simpl.nro_rc_id%TYPE;
     ls_nro_envio_id       fs_factura_simpl.nro_envio_id%TYPE;
     ls_nro_ra_id          fs_factura_simpl.nro_ra_id%TYPE;
     
     -- Cntas_cobrar
     ld_Fec_emision        cntas_cobrar.fecha_documento%TYPE;
     
     -- Cntbl_asiento
     ls_origen             cntbl_asiento.origen%TYPE;
     ln_year               cntbl_asiento.ano%TYPE;
     ln_mes                cntbl_Asiento.Mes%TYPE;
     ln_nro_libro          cntbl_asiento.nro_libro%TYPE;
     ln_nro_Asiento        cntbl_Asiento.Nro_Asiento%TYPE;
     ls_desc_glosa         cntbl_Asiento.Desc_Glosa%TYPE;
     ln_tot_soldeb         cntbl_asiento.tot_soldeb%TYPE;
     ln_tot_solhab         cntbl_asiento.tot_solhab%TYPE;
     ln_tot_doldeb         cntbl_asiento.tot_doldeb%TYPE;
     ln_tot_dolhab         cntbl_asiento.tot_dolhab%TYPE;
     
     -- Cntbl_asiento_det
     ls_cnta_cntbl         cntbl_Asiento_det.Cnta_Ctbl%TYPE;
     ln_item               cntbl_asiento_det.item%TYPE;
     ln_imp_movsol         cntbl_asiento_det.imp_movsol%TYPE;
     ln_imp_movdol         cntbl_asiento_det.imp_movdol%TYPE;
     ls_cencos             cntbl_Asiento_det.Cencos%TYPE;
     ls_nro_docref         cntbl_asiento_det.nro_docref1%TYPE;
     ls_tipo_docref        cntbl_asiento_det.tipo_docref1%TYPE;
     ls_cod_relacion       cntbl_asiento_det.cod_relacion%TYPE;
     ls_centro_benef       cntbl_asiento_det.centro_benef%TYPE;
     ls_flag_debhab        cntbl_asiento_det.flag_debhab%TYPE;
     
     -- Cntbl_Cnta
     ls_desc_cnta          cntbl_cnta.desc_cnta%TYPE;
     ls_flag_doc_ref       cntbl_cnta.flag_doc_ref%TYPE;
     ls_flag_codrel        cntbl_cnta.flag_codrel%TYPE;
     
     -- Impuestos_tipo
     ls_flag_dh_cxp        impuestos_tipo.flag_dh_cxp%TYPE;
     
     -- Variables diversas
     ln_count              number;
     ls_matriz             matriz_cntbl_finan.matriz%TYPE;
     ln_base_imponible     cntas_cobrar.importe_doc%TYPE;
     ln_porc_igv           impuestos_tipo.tasa_impuesto%TYPE;
     ln_igv                cntas_cobrar.importe_doc%TYPE;
     ln_ult_nro            num_doc_tipo.ultimo_numero%TYPE;
     
     -- Cntas_cobrar
     ln_saldo_sol          cntas_cobrar.saldo_sol%TYPE;
     ln_saldo_dol          cntas_cobrar.saldo_dol%TYPE;
     ls_obs                cntas_cobrar.observacion%TYPE;
     
     -- Cntas Cobrar Det
     ls_tipo_cred_fiscal   cntas_cobrar_det.tipo_cred_fiscal%TYPE;
     

    cursor c_matriz(as_matriz matriz_cntbl_finan.matriz%TYPE) is
       select md.item,
              md.cnta_ctbl,
              md.flag_debhab,
              md.formula,
              cc.desc_cnta,
              nvl(cc.flag_cencos, '0') as flag_cencos,
              nvl(cc.flag_codrel, '0') as flag_codrel,
              NVL(cc.flag_doc_ref, '0') as flag_doc_ref,
              nvl(cc.flag_centro_benef, '0') as flag_centro_benef
         from matriz_cntbl_finan_det md,
              cntbl_cnta             cc
       where md.cnta_ctbl = cc.cnta_ctbl
         and md.matriz    = as_matriz
      order by md.item;     
     
  begin
     
    if ani_total_interes <= 0 then
       RAISE_APPLICATION_ERROR(-20000, 'El interes debe ser mayor que cero, no se puede continuar. Nro Registro: ' || asi_nro_registro);
    end if;
    
    -- Obtengo el nro de docuemnto del registro original
    select f.tipo_doc_cxc, f.nro_doc_cxc, trunc(f.fec_movimiento), f.cod_origen, 
           f.cod_moneda, f.tasa_cambio, f.cliente, f.punto_venta, f.vendedor,
           f.item_direccion, f.nro_rc_id, f.nro_ra_id, f.nro_envio_id
      into ls_tipo_ref, ls_nro_ref, ld_fec_registro, ls_origen_fs,
           ls_moneda, ln_tasa_cambio, ls_cliente, ls_punto_venta, ls_vendedor,
           ln_item_dir, ls_nro_rc_id, ls_nro_ra_id, ls_nro_envio_id
      from fs_factura_simpl f,
           fs_factura_simpl_pagos fp
     where f.nro_registro = fp.nro_registro
       and fp.nro_registro = asi_nro_registro
       and fp.flag_forma_pago = asi_flag_forma_pago
       and fp.nro_item        = ani_nro_item;
    
    -- Valido la fecha de emision del nuevo documento
    if ls_nro_ref is null or trim(ls_nro_ref) = '' then
       RAISE_APPLICATION_ERROR(-20000, 'El numero de documento es nulo, por favor verifique. Nro Registro: ' || asi_nro_registro
                                    || 'Tipo Doc: ' || ls_tipo_ref);
    end if; 

    -- Valido la fecha de emision del nuevo documento
    if ls_tipo_ref not in (PKG_SIGRE_FINANZAS.is_doc_bvc, PKG_SIGRE_FINANZAS.is_doc_fac) then
       RAISE_APPLICATION_ERROR(-20000, 'El cobro por letras se hacen solo sobre FACTURAS o BOLETAS. Nro Registro: ' || asi_nro_registro
                                    || 'Tipo Doc: ' || ls_tipo_ref
                                    || 'Nro Doc: ' || ls_nro_ref);
    end if; 
    
    -- Verifico si tiene documento de referencia de pago 
    if aso_tipo_doc_interes is not null and aso_nro_doc_interes is not null then
       -- Obtengo el numero del voucher
       select cc.origen, cc.ano, cc.mes, cc.nro_libro, cc.nro_asiento, cc.fecha_documento
         into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ld_Fec_emision
         from cntas_cobrar cc
        where cc.tipo_doc = aso_tipo_doc_interes
          and cc.nro_doc  = aso_nro_doc_interes;
    end if;

    
    -- Si el documento de interes es nulo entonces lo lleno de acuerdo al tipo de documento de origen
    if aso_tipo_doc_interes is null then
       aso_tipo_doc_interes := ls_tipo_ref;
    end if;
    
    
    if aso_nro_doc_interes is null then
      
       if trim(ls_tipo_ref) = trim(PKG_SIGRE_FINANZAS.is_doc_bvc) then
          ls_serie_doc := PKG_FACT_ELECTRONICA.is_serie_bvc_int;
       else
          ls_serie_doc := PKG_FACT_ELECTRONICA.is_serie_fvc_int;
       end if;
       
       -- Obtengo el siguiente numero del documento
       select count(*)
         into ln_count
         from num_doc_tipo n
        where n.tipo_doc  = aso_tipo_doc_interes
          and n.nro_serie = ls_serie_doc;
       
       if ln_count = 0 then
          insert into num_doc_tipo(
                 tipo_doc, ultimo_numero, nro_serie)
          values(
                 aso_tipo_doc_interes, 1, ls_serie_doc);
       end if;

       select n.ultimo_numero
         into ln_ult_nro
         from num_doc_tipo n
        where n.tipo_doc  = aso_tipo_doc_interes
          and n.nro_serie = ls_serie_doc for update;
       
       aso_nro_doc_interes := PKG_FACT_ELECTRONICA.of_get_nro_doc(ls_serie_doc, trim(to_char(ln_ult_nro)));

       update num_doc_tipo n
          set n.ultimo_numero = ln_ult_nro + 1
        where n.tipo_doc  = aso_tipo_doc_interes
          and n.nro_serie = ls_serie_doc;
       
    end if;
    
    
    if ld_Fec_emision is null then
       -- Si pasa mas de los 7 dias entonces paso la fecha de emision para la fecha limite
       if trunc(sysdate) - ld_Fec_registro > 7 then
          ld_fec_emision := trunc(sysdate) - 7;
       else
          ld_fec_emision := ld_Fec_registro;
       end if;
    end if;
    
    -- Valido si el periodo es correcto en el asiento sino lo anulo para insertar uno nuevo
    if ln_year is not null and ln_mes is not null and ln_nro_libro is not null and ln_nro_Asiento is not null then
       if ln_year <> to_number(to_char(ld_fec_emision, 'yyyy')) or ln_mes <> to_number(to_char(ld_fec_emision, 'mm')) then
          -- Anulo el detalle del asiento
          update cntbl_Asiento_det cad
             set cad.imp_movsol = 0,
                 cad.imp_movdol = 0
           where cad.origen      = ls_origen
             and cad.ano         = ln_year
             and cad.mes         = ln_mes
             and cad.nro_libro   = ln_nro_libro
             and cad.nro_Asiento = ln_nro_Asiento;
             
          -- Anulo la cabecera del asiento
          update cntbl_Asiento ca
             set ca.tot_soldeb = 0,
                 ca.tot_solhab = 0,
                 ca.tot_doldeb = 0,
                 ca.tot_dolhab = 0,
                 ca.flag_estado = '0'
           where ca.origen      = ls_origen
             and ca.ano         = ln_year
             and ca.mes         = ln_mes
             and ca.nro_libro   = ln_nro_libro
             and ca.nro_Asiento = ln_nro_Asiento;
          
          -- Quito la referencia de este asiento en el documento de cobro de interes
          update cntas_cobrar cc
             set cc.ano       = null,
                 cc.mes       = null,
                 cc.nro_libro = null,
                 cc.nro_asiento = null
          where cc.tipo_doc = aso_tipo_doc_interes
            and cc.nro_doc  = aso_nro_doc_interes;
          
          -- Pongo en nulo las referencias
          ln_year := null; ln_mes  := null; ln_nro_libro := null; ln_nro_Asiento := null;
             
       end if;
     end if;
     
     if ls_origen is null then
        ls_origen := ls_origen_fs;
     end if;
     
     -- Si el nro de libro esta vacio lo obtengo del documento principal
     if ln_nro_libro is null then
        select nro_libro
          into ln_nro_libro
          from cntas_cobrar cc
         where cc.tipo_doc = ls_tipo_ref
           and cc.nro_doc  = ls_nro_ref;
     end if;
     
     if ln_year is null then
        ln_year := to_number(to_char(ld_Fec_emision, 'yyyy'));
     end if;
     
     if ln_mes is null then
        ln_mes := to_number(to_char(ld_Fec_emision, 'mm'));
     end if;
     /*************************************************/ 
     -- Primer paso. Genero o actualizo el asiento
     /*************************************************/

     if ln_nro_asiento is null then
        -- Obtengo el numerador del asiento contable
        select count(*)
          into ln_count
          from cntbl_libro_mes cl
         where cl.origen       = ls_origen
           and cl.ano          = ln_year
           and cl.mes          = ln_mes
           and cl.nro_libro    = ln_nro_libro;
        
        if ln_count = 0 then
           insert into cntbl_libro_mes(
                  origen, nro_libro, ano, mes, nro_asiento)
           values(
                  ls_origen, ln_nro_libro, ln_year, ln_mes, 1);
        end if;
        
        select cl.nro_asiento
          into ln_nro_asiento
          from cntbl_libro_mes cl
         where cl.origen       = ls_origen
           and cl.ano          = ln_year
           and cl.mes          = ln_mes
           and cl.nro_libro    = ln_nro_libro for update;
        
        -- Actualizo el numerador
        update cntbl_libro_mes cl
           set cl.nro_asiento = ln_nro_asiento + 1
         where cl.origen       = ls_origen
           and cl.ano          = ln_year
           and cl.mes          = ln_mes
           and cl.nro_libro    = ln_nro_libro;
        
        -- Glosa de la cabecera del asiento
        ls_desc_glosa := 'ASIENTO POR INTERESES DIFERIDOS DE COMPROBANTE ' || ls_tipo_ref || '/' || ls_nro_ref;
        
        -- inserto la cabecera del asiento
        insert into cntbl_asiento(
                 origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, desc_glosa, 
                 fecha_cntbl, fec_registro, 
                 cod_usr, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, flag_asnt_transf, flag_estado)
        values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ls_moneda, ln_tasa_cambio, ls_desc_glosa, 
                 ld_fec_emision, sysdate,
                 asi_cod_usr, '1', 0, 0, 0, 0, '0', '1');

     else
        -- Elimino el detalle del asiento
        delete cntbl_Asiento_det cad
         where cad.origen        = ls_origen
           and cad.ano           = ln_year
           and cad.mes           = ln_mes
           and cad.nro_libro     = ln_nro_libro
           and cad.nro_Asiento   = ln_nro_asiento;
     end if;
     
     -- Valido el codigo de servicio
     select count(*)
       into ln_count
       from servicios_cxc s
      where s.cod_servicio = PKG_FACT_ELECTRONICA.is_serv_interes;
     
     if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'No existe codigo de servicio ' || PKG_FACT_ELECTRONICA.is_serv_interes || ',  por favoe verifique!');
     end if;
     
     -- Obtengo la matriz, dependiendo de la subcategoria y de la moneda
     if ls_moneda = PKG_LOGISTICA.is_soles then
        ls_matriz := PKG_CONFIG.OF_MATRIZ_VTA(aso_tipo_doc_interes, PKG_FACT_ELECTRONICA.is_serv_interes, ls_moneda, PKG_FACT_ELECTRONICA.is_matriz_int_sol);
     else
        ls_matriz := PKG_CONFIG.OF_MATRIZ_VTA(aso_tipo_doc_interes, PKG_FACT_ELECTRONICA.is_serv_interes, ls_moneda, PKG_FACT_ELECTRONICA.is_matriz_int_sol);
     end if;
   
     select count(*)
       into ln_count
       from matriz_cntbl_finan m
      where m.matriz = ls_matriz;
     
     if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'No existe la matriz contable ' || ls_matriz || ',  por favor verifique!');
     end if;
     
     -- Calculo la base imponible y el IGV
     select count(distinct fd.porc_igv)
       into ln_count
       from fs_factura_simpl_det fd
      where fd.nro_registro      = asi_nro_registro;
     
     if ln_count = 0 then
        RAISE_APPLICATION_ERROR(-20000, 'No existe detalle en el comprobante ' || asi_nro_registro || ',  por favor verifique!');
     end if;
     
     if ln_count > 1 then
        RAISE_APPLICATION_ERROR(-20000, 'Existe mas de un porcentaje de IGV en el comprobante ' || asi_nro_registro || ',  por favor verifique!');
     end if;

     select distinct(fd.porc_igv)
       into ln_porc_igv
       from fs_factura_simpl_det fd
      where fd.nro_registro      = asi_nro_registro;
     
     ln_base_imponible := round(ani_total_interes / (1 + ln_porc_igv / 100),2);
     ln_igv            := ani_total_interes - ln_base_imponible;

     -- Recorro la matriz con las cuentas contables
     for lc_matriz in c_matriz(ls_matriz) loop
             
         -- Calculo el importe en soles y en dolares
         if instr(lc_matriz.formula, 'IGV') = 0 then
            if ls_moneda = PKG_LOGISTICA.is_soles then
               ln_imp_movsol := ln_base_imponible;
               ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
            else
               ln_imp_movdol := ln_base_imponible;
               ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
            end if; 
         else
            -- Si pide el IGV entonces tengo que sumarlo
            if ls_moneda = PKG_LOGISTICA.is_soles then
               ln_imp_movsol := ani_total_interes;
               ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
            else
               ln_imp_movdol := ani_total_interes;
               ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
            end if;
         end if;

         -- Solicita centros de costo
         if lc_matriz.flag_cencos = '1' then
            ls_cencos := PKG_CONFIG.OF_CENCOS_VTA(aso_tipo_doc_interes, PKG_FACT_ELECTRONICA.is_serv_interes, ls_moneda, pkg_config.USF_GET_PARAMETER('CENCOS_VTA_DEFAUL', '70101005'));
         else
            ls_cencos := null;
         end if;
                
         -- Solicita centro Beneficio
         if lc_matriz.flag_centro_benef = '1' then
            ls_centro_benef := PKG_CONFIG.OF_CENTRO_BENEF_VTA(aso_tipo_doc_interes, PKG_FACT_ELECTRONICA.is_serv_interes, ls_moneda, pkg_config.USF_GET_PARAMETER('CENTRO_BENEF_DEFAULT', '1020'));
         else
            ls_centro_benef := null;
         end if;
               
         -- Solicita Codigo de Relacion 
         if lc_matriz.flag_codrel = '1' then
            ls_cod_relacion := ls_cliente;
         else
            ls_cod_relacion := null;
         end if;
               
         -- Solicita Documento de referencia
         if lc_matriz.flag_doc_ref = '1' then
            ls_tipo_docref := aso_tipo_doc_interes;
            ls_nro_docref  := aso_nro_doc_interes;
         else
            ls_tipo_docref := null;
            ls_nro_docref  := null;
         end if;
               
         -- Verifico el flag_debhab
         ls_flag_debhab := lc_matriz.flag_debhab;
               
         -- Verifico si ya existe la cuenta en el asiento
         select count(*)
           into ln_count
           from cntbl_asiento_det cad
          where cad.origen                  = ls_origen
            and cad.ano                     = ln_year
            and cad.mes                     = ln_mes
            and cad.nro_libro               = ln_nro_libro
            and cad.nro_asiento             = ln_nro_asiento
            and cad.cnta_ctbl               = lc_matriz.cnta_ctbl
            and cad.flag_debhab             = ls_flag_debhab
            and nvl(cad.cencos, 'X')        = nvl(ls_cencos, 'X')
            and nvl(cad.centro_benef, 'X')  = nvl(ls_centro_benef, 'X')
            and nvl(cad.tipo_docref1, 'X')  = nvl(ls_tipo_docref, 'X')
            and nvl(cad.nro_docref1, 'X')   = nvl(ls_nro_docref, 'X')
            and nvl(cad.cod_relacion, 'X')  = nvl(ls_cod_relacion, 'X');
               
         if ln_count = 0 then
            -- Inserto el nuevo registro
            select nvl(max(cad.item),0)
              into ln_item
              from cntbl_asiento_det cad
             where cad.origen           = ls_origen
               and cad.ano              = ln_year
               and cad.mes              = ln_mes
               and cad.nro_libro        = ln_nro_libro
               and cad.nro_asiento      = ln_nro_asiento;
                  
            ln_item := ln_item + 1;
                  
            insert into cntbl_asiento_det(
                   origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, 
                   fec_cntbl, 
                   det_glosa, flag_gen_aut, flag_debhab, 
                   cencos, tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol, centro_benef)
            values(
                   ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, lc_matriz.cnta_ctbl, 
                   ld_fec_registro,
                   lc_matriz.desc_cnta, '0', ls_flag_debhab,
                   ls_cencos, ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol, ls_centro_benef);
                         
         else
            select cad.item
              into ln_item
              from cntbl_asiento_det cad
             where cad.origen                 = ls_origen
               and cad.ano                    = ln_year
               and cad.mes                    = ln_mes
               and cad.nro_libro              = ln_nro_libro
               and cad.nro_asiento            = ln_nro_asiento
               and cad.cnta_ctbl              = lc_matriz.cnta_ctbl
               and cad.flag_debhab            = ls_flag_debhab
               and nvl(cad.cencos, 'X')       = nvl(ls_cencos, 'X')
               and nvl(cad.centro_benef, 'X') = nvl(ls_centro_benef, 'X')
               and nvl(cad.tipo_docref1, 'X') = nvl(ls_tipo_docref, 'X')
               and nvl(cad.nro_docref1, 'X')  = nvl(ls_nro_docref, 'X')
               and nvl(cad.cod_relacion, 'X') = nvl(ls_cod_relacion, 'X');
                  
            update cntbl_asiento_det cad
               set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                   cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
             where cad.origen           = ls_origen
               and cad.ano              = ln_year
               and cad.mes              = ln_mes
               and cad.nro_libro        = ln_nro_libro
               and cad.nro_asiento      = ln_nro_asiento
               and cad.item             = ln_item;
                         
         end if;
               
     end loop;
           
        
    -- A?ado el impuesto, en caso que sea positivo
    if ln_igv > 0 then
           
       -- Obtengo los importes
       if ls_moneda = PKG_LOGISTICA.is_soles then
          ln_imp_movsol := ln_igv;
          ln_imp_movdol := ln_imp_movsol / ln_tasa_cambio;
       else
          ln_imp_movdol := ln_igv;
          ln_imp_movsol := ln_imp_movdol * ln_tasa_cambio;
             
       end if;   
        
       select count(*)
         into ln_count
         from cntbl_cnta cc,
              impuestos_tipo it
        where it.cnta_ctbl = cc.cnta_ctbl 
          and it.tipo_impuesto = PKG_LOGISTICA.is_igv;
           
       if ln_count = 0 then    
          ROLLBACK;
          RAISE_APPLICATION_ERROR(-20000, 'No se ha configurado el tipo de impuesto de IGV, o no existe '
                                       || 'en la tabla de Tipos de Impuestos, o no tiene una cuenta contable asociada. '
                                       || 'Por favor coordine con CONTABILIDAD' 
                                       || chr(13) || 'IGV: ' + NVL(PKG_LOGISTICA.is_igv, '---'));
       end if;
           
       select cc.cnta_ctbl, cc.desc_cnta, nvl(cc.flag_doc_ref, '0'), nvl(cc.flag_codrel, '0'), it.flag_dh_cxp
         into ls_cnta_cntbl, ls_desc_cnta, ls_flag_doc_ref, ls_flag_codrel, ls_flag_dh_cxp
         from cntbl_cnta cc,
              impuestos_tipo it
        where it.cnta_ctbl = cc.cnta_ctbl 
          and it.tipo_impuesto = PKG_LOGISTICA.is_igv;
           
       -- Coloco el flag de de cod_relacion
       if ls_flag_codrel = '1' then
          ls_cod_relacion := ls_cliente;
       else
          ls_cod_relacion := null;
       end if;
           
       -- Coloco el flag de Documento de referencia
       if ls_flag_doc_ref = '1' then
          ls_tipo_docref := aso_tipo_doc_interes;
          ls_nro_docref  := aso_nro_doc_interes;
       else
          ls_tipo_docref := null;
          ls_nro_docref  := null;
       end if;
           
       -- Invierto el sentido del flag_dh
       if ls_flag_dh_cxp = 'D' then
          ls_flag_dh_cxp := 'H';
       else
          ls_flag_dh_cxp := 'D';
       end if;

       select count(*)
         into ln_count
         from cntbl_asiento_det cad
        where cad.origen                        = ls_origen
          and cad.ano                           = ln_year
          and cad.mes                           = ln_mes
          and cad.nro_libro                     = ln_nro_libro
          and cad.nro_asiento                   = ln_nro_asiento
          and cad.cnta_ctbl                     = ls_cnta_cntbl
          and cad.flag_debhab                   = ls_flag_dh_cxp
          and trim(nvl(cad.tipo_docref1, 'X'))  = trim(nvl(ls_tipo_docref, 'X'))
          and trim(nvl(cad.nro_docref1, 'X'))   = trim(nvl(ls_nro_docref, 'X'))
          and trim(nvl(cad.cod_relacion, 'X'))  = trim(nvl(ls_cod_relacion, 'X'));
           
       if ln_count = 0 then
          -- Inserto el nuevo registro
          select nvl(max(cad.item),0)
            into ln_item
            from cntbl_asiento_det cad
           where cad.origen           = ls_origen
             and cad.ano              = ln_year
             and cad.mes              = ln_mes
             and cad.nro_libro        = ln_nro_libro
             and cad.nro_asiento      = ln_nro_asiento;
                  
          ln_item := ln_item + 1;
                  
          insert into cntbl_asiento_det(
                 origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, fec_cntbl, 
                 det_glosa, flag_gen_aut, flag_debhab, 
                 tipo_docref1, nro_docref1, cod_relacion, imp_movsol, imp_movdol, centro_benef)
          values(
                 ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, ln_item, ls_cnta_cntbl, ld_fec_registro,
                 ls_desc_cnta, '0', ls_flag_dh_cxp,
                 ls_tipo_docref, ls_nro_docref, ls_cod_relacion, ln_imp_movsol, ln_imp_movdol, ls_centro_benef);
                         
       else
          select cad.item
            into ln_item
            from cntbl_asiento_det cad
           where cad.origen                 = ls_origen
             and cad.ano                    = ln_year
             and cad.mes                    = ln_mes
             and cad.nro_libro              = ln_nro_libro
             and cad.nro_asiento            = ln_nro_asiento
             and cad.cnta_ctbl              = ls_cnta_cntbl
             and cad.flag_debhab            = ls_flag_dh_cxp
             and nvl(cad.tipo_docref1, 'X') = nvl(ls_tipo_docref, 'X')
             and nvl(cad.nro_docref1, 'X')  = nvl(ls_nro_docref, 'X')
             and nvl(cad.cod_relacion, 'X') = nvl(ls_cod_relacion, 'X');
                  
          update cntbl_asiento_det cad
             set cad.imp_movsol = cad.imp_movsol + ln_imp_movsol,
                 cad.imp_movdol = cad.imp_movdol + ln_imp_movdol
           where cad.origen           = ls_origen
             and cad.ano              = ln_year
             and cad.mes              = ln_mes
             and cad.nro_libro        = ln_nro_libro
             and cad.nro_asiento      = ln_nro_asiento
             and cad.item             = ln_item;
                         
       end if;
           
    end if;
     
    -- Obtengo los totales del asiento
    select nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
           nvl(sum(Decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
      into ln_tot_soldeb, ln_tot_solhab, ln_tot_doldeb, ln_tot_dolhab
      from cntbl_asiento_det cad
     where cad.origen           = ls_origen
       and cad.ano              = ln_year
       and cad.mes              = ln_mes
       and cad.nro_libro        = ln_nro_libro
       and cad.nro_asiento      = ln_nro_asiento;
  
    -- Actualizo los totales en la cabecera del asiento
    update cntbl_asiento ca
       set ca.tot_soldeb = ln_tot_soldeb,
           ca.tot_solhab = ln_tot_solhab,
           ca.tot_doldeb = ln_tot_doldeb,
           ca.tot_dolhab = ln_tot_dolhab
     where ca.origen           = ls_origen
       and ca.ano              = ln_year
       and ca.mes              = ln_mes
       and ca.nro_libro        = ln_nro_libro
       and ca.nro_asiento      = ln_nro_asiento;


    /********************************************************/ 
     -- Segundo paso. Genero o actualizo la cuenta poc cobrar
    /********************************************************/
    if ls_moneda = PKG_LOGISTICA.is_soles then
       ln_saldo_sol := ani_total_interes;
       ln_saldo_dol := ln_saldo_sol / ln_tasa_cambio;
    else
       ln_saldo_dol := ani_total_interes;
       ln_saldo_sol := ln_saldo_dol * ln_tasa_cambio;
    end if;
    
    -- Obtengo la glosa de la cuenta por cobrar
    ls_obs := 'PROVISION DE INTERES DE COMPROBANTE ' || ls_tipo_docref || '/' || ls_nro_docref;
    
    select count(*)
      into ln_count
      from cntas_cobrar cc
     where cc.tipo_doc = aso_tipo_doc_interes
       and cc.nro_doc  = aso_nro_doc_interes;
    
    if ln_count = 0 then
       
       -- Inserto en la cabecera de cntas_cobrar
       insert into cntas_cobrar(
               tipo_doc, nro_doc, cod_relacion, flag_estado, fecha_registro, punto_venta, fecha_documento, fecha_vencimiento, 
               cod_moneda, tasa_cambio, cod_usr, forma_pago, 
               origen, ano, mes, nro_libro, nro_asiento, 
               observacion,  fecha_presentacion, flag_provisionado, saldo_sol, saldo_dol, importe_doc, vendedor, 
               flag_detraccion, item_direccion, flag_control_reg, flag_caja_bancos, 
               nro_rc_id, nro_envio_id, nro_ra_id, nro_registro_fs)
       values(
               aso_tipo_doc_interes, aso_nro_doc_interes, ls_cliente, '1', sysdate, ls_punto_venta, ld_Fec_emision, ld_fec_emision + 1,
               ls_moneda, ln_tasa_cambio, asi_cod_usr,  is_fp_pcon, 
               ls_origen, ln_year, ln_mes, ln_nro_libro, ln_nro_asiento, 
               ls_obs, ld_fec_emision, 'R', ln_saldo_sol, ln_saldo_dol, ani_total_interes, ls_vendedor,
               '0', ln_item_dir, '0', '0',
               ls_nro_rc_id, ls_nro_envio_id, ls_nro_ra_id, asi_nro_registro);
    else
       delete cc_doc_det_imp ci
       where ci.tipo_doc = aso_tipo_doc_interes
         and ci.nro_doc  = aso_nro_doc_interes;
         
       delete cntas_cobrar_det ccd
       where ccd.tipo_doc = aso_tipo_doc_interes
         and ccd.nro_doc  = aso_nro_doc_interes;
       
       delete doc_referencias dr
       where dr.tipo_doc = aso_tipo_doc_interes
         and dr.nro_doc  = aso_nro_doc_interes;
       
       update cntas_cobrar cc
          set cc.nro_envio_id      = ls_nro_envio_id,
              cc.nro_rc_id         = ls_nro_rc_id,
              cc.nro_ra_id         = ls_nro_ra_id,
              cc.saldo_sol         = ln_saldo_sol,
              cc.saldo_dol         = ln_saldo_dol,
              cc.importe_doc       = ani_total_interes,
              cc.nro_registro_fs   = asi_nro_registro,
              cc.fecha_vencimiento = ld_Fec_emision,
              cc.fecha_registro    = ld_fec_registro,
              cc.forma_pago        = is_fp_pcon,
              cc.observacion       = ls_obs
       where cc.tipo_doc = aso_tipo_doc_interes
         and cc.nro_doc  = aso_nro_doc_interes;

    end if;
    
    -- Inserto el detalle del comprobante Cntas x Cpbrar
    select nvl(max(ccd.item), 0)
      into ln_item
      from cntas_cobrar_det ccd
     where tipo_doc    = aso_tipo_doc_interes
       and nro_doc     = aso_nro_doc_interes;
        
    ln_item := ln_item + 1;
        
    -- Solicita centros de costo
    ls_cencos := PKG_CONFIG.OF_CENCOS_VTA(aso_tipo_doc_interes, PKG_FACT_ELECTRONICA.is_serv_interes, ls_moneda, pkg_config.USF_GET_PARAMETER('CENCOS_VTA_DEFAUL', '70101005'));
        
    -- Solicita centro Beneficio
    ls_centro_benef := PKG_CONFIG.OF_CENTRO_BENEF_VTA(aso_tipo_doc_interes, PKG_FACT_ELECTRONICA.is_serv_interes, ls_moneda, pkg_config.USF_GET_PARAMETER('CENTRO_BENEF_DEFAULT', '1020'));
        
    if ln_igv <> 0 then
       ls_tipo_cred_fiscal := '09';  --Venta Nacional Gravada
    else
       ls_tipo_cred_fiscal := '10'; --Inafectas
    end if;
        
       
    insert into cntas_cobrar_det(
           TIPO_DOC, NRO_DOC, ITEM, FLAG_ESTADO, CONFIN, DESCRIPCION, COD_ART, 
           CANTIDAD, PRECIO_UNITARIO, TIPO_CRED_FISCAL, CENTRO_BENEF, 
           UND, CENCOS, und2, org_am, nro_am, tipo_ref, nro_ref)
    VALUES(
           aso_tipo_doc_interes, aso_nro_doc_interes, ln_item, '1', ls_matriz, ls_obs, null,
           1, ln_base_imponible, ls_tipo_cred_fiscal, ls_centro_benef,
           null, ls_cencos, null, null, null, null, null);
        
    -- inserto el impuesto 
    if ln_igv > 0 then
       insert into cc_doc_det_imp(
             tipo_doc, nro_doc, item, tipo_impuesto, importe)
       values(
             aso_tipo_doc_interes, aso_nro_doc_interes, ln_item, PKG_LOGISTICA.is_igv, ln_igv);
    end if;
    
    -- Actualizo la referencia en la cabecera
    update fs_factura_simpl_pagos fp
       set fp.tipo_doc_interes = aso_tipo_doc_interes,
           fp.nro_doc_interes  = aso_nro_doc_interes,
           fp.total_interes    = ani_total_interes
     where fp.nro_registro     = asi_nro_registro
       and fp.flag_forma_pago  = asi_flag_forma_pago
       and fp.nro_item         = ani_nro_item;

  end;


  -- Anulo el pago y todo lo que esta asociado
  procedure sp_anular_pago_fs_simpl(
     asi_registro    in fs_factura_simpl_pagos.nro_registro%TYPE,
     asi_forma_pago  in fs_factura_simpl_pagos.flag_forma_pago%TYPE,
     ani_nro_item    in fs_factura_simpl_pagos.nro_item%TYPE
            
  )is
     -- Cursor con las notas contables y letras
     cursor c_datos_pagos_ref is
       select f.*
         from fs_factura_simpl_pagos_ref f
        where f.nro_registro = asi_registro
          and f.flag_forma_pago = asi_forma_pago
          and f.nro_item        = ani_nro_item;
  
     -- Cursor para los movimientos de cobro
     cursor c_datos_pago is
        select fp.org_caja,
               fp.ano_caja,
               fp.mes_caja,
               fp.libro_caja,
               fp.asiento_caja,
               fp.reg_caja
          from fs_factura_simpl_pagos fp
         where fp.nro_registro    = asi_registro
           and fp.flag_forma_pago = asi_forma_pago
           and fp.nro_item        = ani_nro_item;
  
  begin
    -- Anulo los documentos de notas contables y letras por cobrar
    for lc_ref in c_datos_pagos_ref loop
        -- Anulo el asiento contable de la provision
        update cntbl_asiento_det cad
           set cad.imp_movsol = 0,
               cad.imp_movdol = 0
         where cad.origen      = lc_ref.org_asiento
           and cad.ano         = lc_ref.ano_asiento
           and cad.mes         = lc_ref.mes_asiento
           and cad.nro_libro   = lc_ref.libro_asiento
           and cad.nro_asiento = lc_ref.nro_asiento;
        
        update cntbl_Asiento ca
           set ca.tot_soldeb = 0,
               ca.tot_solhab = 0,
               ca.tot_doldeb = 0,
               ca.tot_dolhab = 0,
               ca.flag_estado = '0'
         where ca.origen      = lc_ref.org_asiento
           and ca.ano         = lc_ref.ano_asiento
           and ca.mes         = lc_ref.mes_asiento
           and ca.nro_libro   = lc_ref.libro_asiento
           and ca.nro_asiento = lc_ref.nro_asiento;
        
        -- Elimino el detalle de caja_bancos
        delete doc_referencias dr
        where dr.tipo_doc  = lc_ref.tipo_doc_cxc
          and dr.nro_doc   = lc_ref.nro_doc_cxc;
        
        update cntas_cobrar cc
           set cc.importe_doc = 0,
               cc.saldo_sol   = 0,
               cc.saldo_dol   = 0,
               cc.flag_estado = '0'
        where cc.tipo_doc     = lc_ref.tipo_doc_cxc
          and cc.nro_doc      = lc_ref.nro_doc_cxc;
      
    end loop;
    
    -- Anulo los asientos de pago y registro de caja bancos
    for lc_reg in c_datos_pago loop
        -- Anulo el asiento contable de la provision
        update cntbl_asiento_det cad
           set cad.imp_movsol = 0,
               cad.imp_movdol = 0
         where cad.origen      = lc_reg.org_caja
           and cad.ano         = lc_reg.ano_caja
           and cad.mes         = lc_reg.mes_caja
           and cad.nro_libro   = lc_reg.libro_caja
           and cad.nro_asiento = lc_reg.asiento_Caja;
        
        update cntbl_Asiento ca
           set ca.tot_soldeb = 0,
               ca.tot_solhab = 0,
               ca.tot_doldeb = 0,
               ca.tot_dolhab = 0,
               ca.flag_estado = '0'
         where ca.origen      = lc_reg.org_caja
           and ca.ano         = lc_reg.ano_caja
           and ca.mes         = lc_reg.mes_caja
           and ca.nro_libro   = lc_reg.libro_caja
           and ca.nro_asiento = lc_reg.asiento_Caja;
        
        -- Elimino el detalle de caja_bancos
        delete caja_bancos_det cbd
        where cbd.origen       = lc_reg.org_caja
          and cbd.nro_registro = lc_reg.reg_caja; 
        
        update caja_bancos cb
           set cb.flag_estado = '0',
               cb.imp_total   = 0
        where cb.origen       = lc_reg.org_caja
          and cb.nro_registro = lc_reg.reg_caja; 

    end loop;
   
  end;

  -- Anulo el comprobante
  procedure sp_anular_fs_simpl(
            asi_registro fs_factura_simpl.nro_registro%TYPE 
  )is
     
     -- datos del asiento contable
     ls_origen            cntbl_asiento.origen%TYPE;
     ln_year              cntbl_Asiento.Ano%TYPE;
     ln_mes               cntbl_asiento.mes%TYPE;
     ln_nro_Asiento       cntbl_asiento.nro_asiento%TYPE;
     ln_count             number;
     ls_tipo_doc          cntas_cobrar.tipo_doc%TYPE;
     ls_nro_doc           cntas_cobrar.nro_doc%TYPE;
     
     -- Cursor para los movimientos de almacen
     cursor c_datos_almacen is
        select fd.org_am, fd.nro_am, am.nro_vale
          from fs_factura_simpl f,
               fs_factura_simpl_det fd,
               articulo_mov         am
         where f.nro_registro = fd.nro_registro
           and fd.org_am      = am.cod_origen
           and fd.nro_am      = am.nro_mov
           and f.nro_registro = asi_registro;
           
     -- Cursor con las notas contables y letras
     cursor c_datos_pagos_ref is
       select f.*
         from fs_factura_simpl_pagos_ref f
        where f.nro_registro = asi_registro;
       
     -- Cursor para los movimientos de cobro
     cursor c_datos_pago is
        select fp.org_caja,
               fp.ano_caja,
               fp.mes_caja,
               fp.libro_caja,
               fp.asiento_caja,
               fp.reg_caja
          from fs_factura_simpl f,
               fs_factura_simpl_pagos fp
         where f.nro_registro = fp.nro_registro
           and f.nro_registro = asi_registro;
     
     
  begin
    -- Obtengo datos necesarios
    select f.cod_origen, f.ano, f.mes, f.nro_asiento, f.tipo_doc_cxc, f.nro_doc_cxc
      into ls_origen, ln_year, ln_mes, ln_nro_asiento, ls_tipo_doc, ls_nro_doc
      from fs_factura_simpl f
     where f.nro_registro = asi_registro;
    
    
    -- Genero el asiento de la provision del comprobante de venta
    sp_fs_asiento_contable(asi_registro);
    -- Genero el registro del comprobante de venta (Reg. Ventas)
    sp_fs_cntas_cobrar(asi_registro);
    
    -- Anulo los documentos de notas contables y letras por cobrar
    for lc_ref in c_datos_pagos_ref loop

        select count(*)
          into ln_count
          from cntas_cobrar cc
         where cc.tipo_doc     = lc_ref.tipo_doc_cxc
           and cc.nro_doc      = lc_ref.nro_doc_cxc;
        
        if ln_count = 0 then
           -- Genero el asiento de la provision del comprobante de venta
           sp_fs_asiento_contable(asi_registro);
           -- Genero el registro del comprobante de venta (Reg. Ventas)
           sp_fs_cntas_cobrar(asi_registro);
           
        end if;

        -- Anulo el asiento contable de la provision
        update cntbl_asiento_det cad
           set cad.imp_movsol = 0,
               cad.imp_movdol = 0
         where cad.origen      = lc_ref.org_asiento
           and cad.ano         = lc_ref.ano_asiento
           and cad.mes         = lc_ref.mes_asiento
           and cad.nro_libro   = lc_ref.libro_asiento
           and cad.nro_asiento = lc_ref.nro_asiento;
        
        update cntbl_Asiento ca
           set ca.tot_soldeb = 0,
               ca.tot_solhab = 0,
               ca.tot_doldeb = 0,
               ca.tot_dolhab = 0,
               ca.flag_estado = '0'
         where ca.origen      = lc_ref.org_asiento
           and ca.ano         = lc_ref.ano_asiento
           and ca.mes         = lc_ref.mes_asiento
           and ca.nro_libro   = lc_ref.libro_asiento
           and ca.nro_asiento = lc_ref.nro_asiento;
        
        -- Elimino el detalle de caja_bancos
        delete doc_referencias dr
        where dr.tipo_doc  = lc_ref.tipo_doc_cxc
          and dr.nro_doc   = lc_ref.nro_doc_cxc;
        
        
        update cntas_cobrar cc
           set cc.importe_doc = 0,
               cc.saldo_sol   = 0,
               cc.saldo_dol   = 0,
               cc.flag_estado = '0'
        where cc.tipo_doc     = lc_ref.tipo_doc_cxc
          and cc.nro_doc      = lc_ref.nro_doc_cxc;
      
    end loop;
    
    -- Anulo los asientos de pago y registro de caja bancos
    for lc_reg in c_datos_pago loop
        -- Anulo el asiento contable de la provision
        update cntbl_asiento_det cad
           set cad.imp_movsol = 0,
               cad.imp_movdol = 0
         where cad.origen      = lc_reg.org_caja
           and cad.ano         = lc_reg.ano_caja
           and cad.mes         = lc_reg.mes_caja
           and cad.nro_libro   = lc_reg.libro_caja
           and cad.nro_asiento = lc_reg.asiento_Caja;
        
        update cntbl_Asiento ca
           set ca.tot_soldeb = 0,
               ca.tot_solhab = 0,
               ca.tot_doldeb = 0,
               ca.tot_dolhab = 0,
               ca.flag_estado = '0'
         where ca.origen      = lc_reg.org_caja
           and ca.ano         = lc_reg.ano_caja
           and ca.mes         = lc_reg.mes_caja
           and ca.nro_libro   = lc_reg.libro_caja
           and ca.nro_asiento = lc_reg.asiento_Caja;
        
        -- Elimino el detalle de caja_bancos
        delete caja_bancos_det cbd
        where cbd.origen       = lc_reg.org_caja
          and cbd.nro_registro = lc_reg.reg_caja; 
        
        update caja_bancos cb
           set cb.flag_estado = '0',
               cb.imp_total   = 0
        where cb.origen       = lc_reg.org_caja
          and cb.nro_registro = lc_reg.reg_caja; 

    end loop;
    
    -- Anulo el asiento contable de la provision
    update cntbl_asiento_det cad
       set cad.imp_movsol = 0,
           cad.imp_movdol = 0
     where cad.origen      = ls_origen
       and cad.ano         = ln_year
       and cad.mes         = ln_mes
       and cad.nro_libro   = il_libro_ventas
       and cad.nro_asiento = ln_nro_Asiento;
    
    update cntbl_Asiento ca
       set ca.tot_soldeb = 0,
           ca.tot_solhab = 0,
           ca.tot_doldeb = 0,
           ca.tot_dolhab = 0,
           ca.flag_estado = '0'
     where ca.origen      = ls_origen
       and ca.ano         = ln_year
       and ca.mes         = ln_mes
       and ca.nro_libro   = il_libro_ventas
       and ca.nro_asiento = ln_nro_Asiento; 
    
    -- Anulo el vale de salida
    for lc_reg in c_datos_almacen loop
        update articulo_mov am
           set am.cant_procesada = 0,
               am.flag_estado    = '0'
         where am.cod_origen   = lc_reg.org_am
           and am.nro_mov      = lc_reg.nro_am;
        
        -- Si no hay mas detalles del movimiento de almacen activos entonces anulo la cabecera
        select count(*)
          into ln_count
          from articulo_mov am
         where am.nro_vale = lc_reg.nro_Vale
           and am.flag_estado <> '0';
        
        if ln_count = 0 then
           update vale_mov vm
              set vm.flag_estado = '0'
            where vm.nro_vale = lc_reg.nro_vale;
        end if;
    end loop;     
    
    -- Anulo el comprobante en cntas_cobrar
    update cc_doc_det_imp ci
       set ci.importe = 0
     where ci.tipo_doc = ls_tipo_doc
       and ci.nro_doc  = ls_nro_doc;
     
    update cntas_cobrar_det ccd
       set ccd.precio_unitario = 0,
           ccd.cantidad        =  0,
           ccd.flag_estado     = '0'
     where ccd.tipo_doc = ls_tipo_doc
       and ccd.nro_doc  = ls_nro_doc;
       
    update cntas_cobrar cc
       set cc.importe_doc      = 0,
           cc.saldo_sol        = 0,
           cc.saldo_dol        = 0,
           cc.flag_estado      = '0'
     where cc.tipo_doc = ls_tipo_doc
       and cc.nro_doc  = ls_nro_doc;
    
    -- Elimino la cuenta corriente
    delete doc_pendientes_cta_cte d
     where d.tipo_doc = ls_tipo_doc
       and d.nro_doc  = ls_nro_doc;

  end ;

  procedure sp_cxc_factura_smpl(asi_registro fs_factura_simpl.nro_registro%TYPE ) is
  begin
    
    -- Genera el vale de salida
    sp_fs_vale_almacen(asi_registro);
    -- Genero el asiento de la provision del comprobante de venta
    sp_fs_asiento_contable(asi_registro);
    -- Genero el registro del comprobante de venta (Reg. Ventas)
    sp_fs_cntas_cobrar(asi_registro);
    -- Genero el asiento contable de la cobranza
    sp_cart_cob_asiento_cntbl(asi_registro);
    -- Genero el Registro de Caja y Bancos
    sp_tesoreria_fact_smpl(asi_registro);
    
    -- Elimino de doc_pendiente_cta_cte los que estan ya saldados
    delete doc_pendientes_cta_cte c
     where (c.sldo_sol = 0 and c.cod_moneda = PKG_LOGISTICA.is_soles) 
        or (c.saldo_dol = 0 and c.cod_moneda = PKG_LOGISTICA.is_dolares);
     
    return;
  end;

  -- Procedimiento para procesar un mes completo
  procedure sp_procesar_periodo(
            ani_year number, 
            ani_mes number
) is
    cursor c_datos is
       select f.nro_registro, f.flag_estado
         from fs_factura_simpl f
        where to_number(to_char(f.fec_movimiento, 'yyyy')) = ani_year
          and to_number(to_char(f.fec_movimiento, 'mm')) = ani_mes;
  begin
    
    -- Recorro el cursor
    for lc_reg in c_Datos loop
        
        
        if lc_reg.flag_estado = '0' then
           PKG_FACT_ELECTRONICA.sp_anular_fs_simpl(lc_reg.nro_registro);
        else
           PKG_FACT_ELECTRONICA.sp_cxc_factura_smpl(lc_reg.nro_registro);
        end if;
    end loop;
    
    -- Actualizo el cuaenta corriente de las cuentas por cobrar
    pkg_sigre_finanzas.of_actualiza_saldo_cc(null);
    
    PKG_ALMACEN.sp_act_saldo_all(null);
    
    commit;
  end;  
  
  -- Procedimiento para procesar un dia completo
  procedure sp_procesar_dia(adi_Fecha date) is
    cursor c_datos is
       select f.nro_registro, f.flag_estado
         from fs_factura_simpl f
        where trunc(f.fec_movimiento) = trunc(adi_Fecha);
  begin
    
    -- Recorro el cursor
    for lc_reg in c_Datos loop
        PKG_FACT_ELECTRONICA.sp_cxc_factura_smpl(lc_reg.nro_registro);
        
        if lc_reg.flag_estado = '0' then
           PKG_FACT_ELECTRONICA.sp_anular_fs_simpl(lc_reg.nro_registro);
        end if;
    end loop;
    commit;
  end;  

  -- Function que devuelve el nro de documento simplificado
  function of_get_nro_doc(
           as_serie   in fs_factura_simpl.serie_cxc%TYPE, 
           as_nro_doc in fs_factura_simpl.nro_cxc%TYPE
  ) return varchar2 as
    
    ls_nro_doc    cntas_cobrar.nro_doc%TYPE;
    ls_nro        varchar2(10);
    ln_longitud   number;
    ln_i          number;
    ls_char       char(1);
    ln_flag       number(1);
  
  begin
    ls_nro_doc := '';
    ln_flag := 0;
    
    -- Primero proceso la serie
    if as_serie is not null and length(trim(as_serie)) > 0 then
        ln_longitud := length(trim(as_Serie));
        for ln_i in 1..ln_longitud loop
            ls_char := substr(as_serie, ln_i, 1);
            if ls_char in ('B', 'F', 'E') then
               ls_nro_doc := trim(ls_nro_doc) || ls_char;
            elsif ls_char = '0' and ln_flag = 0 then
               ln_flag := 1;
            elsif ls_char <> '0' and ln_flag >= 0 then
               ls_nro_doc := trim(ls_nro_doc) || ls_char;
               if ln_flag = 1 or ln_i > 1 then ln_flag := -1; end if;
            elsif ln_flag = -1 then
               ls_nro_doc := trim(ls_nro_doc) || ls_char;
            end if;
        end loop;
    else
       ls_nro_doc := null;
    end if;
    
    if ls_nro_doc is not null then
       ls_nro_doc := trim(ls_nro_doc) || '-';
    else
       ls_nro_doc := '';
    end if;
    
    -- Segundo proceso el numero
    if ls_nro_doc is not null and length(trim(ls_nro_doc)) > 0 then
       ln_longitud := 10 - length(trim(ls_nro_doc));
    else
       ln_longitud := 10;
    end if;
    if length(trim(as_nro_doc)) > ln_longitud then
       ls_nro := substr(trim(as_nro_doc), length(trim(as_nro_doc)) - ln_longitud + 1, ln_longitud);
    else
       ls_nro := trim(as_nro_doc);
    end if;    
    
    -- Quito los ceros
    if ls_nro is not null and length(trim(ls_nro)) > 0 then
        ln_longitud :=  length(trim(ls_nro));
        ln_flag := 0;
        for ln_i in 1..ln_longitud loop
            ls_char := substr(ls_nro, ln_i, 1);
            if ls_char = '0' and ln_flag = 0 then
               ln_flag := 1;
            elsif ls_char <> '0' and ln_flag >= 0 then
               ls_nro_doc := trim(ls_nro_doc) || ls_char;
               ln_flag := -1; 
            elsif ln_flag = -1 then
               ls_nro_doc := trim(ls_nro_doc) || ls_char;
            end if;
        end loop;
    end if;
    return ls_nro_doc;
  end;
  
  -- Function para obtener el nro de Serie de un Numero de documento completo
  function of_get_serie(as_nro_doc in cntas_cobrar.nro_doc%TYPE) return varchar2 as
    
    ls_serie      varchar2(20);
  
  begin
    ls_serie := replace(as_nro_doc, '.', '-');
    ls_serie := replace(ls_serie, '--', '-');
    
    if instr(ls_serie, '-') > 0 then
       ls_serie := trim(substr(ls_serie, 1, instr(ls_serie, '-') - 1));
       
       if ls_Serie is not null then
          if substr(ls_serie, 1, 1) in ('B', 'F', 'T', 'E', 'A') then
             ls_serie := substr(ls_serie, 1, 1) || lpad(trim(substr(ls_serie, 2)), 3, '0');
          else
             if length(trim(ls_serie)) < 4 then
                ls_Serie := lpad(trim(ls_serie), 4, '0');
             else
                ls_Serie := trim(ls_serie);
             end if;
          end if;
       else
          ls_serie := '0000';
       end if;
       
    else
       ls_serie := '';
    end if;
    
    return ls_Serie;
  
  end;

  -- Function para obtener el nro de Serie de un Numero de documento completo
  function of_get_nro(as_nro_doc in cntas_cobrar.nro_doc%TYPE) return varchar2 as
    
    ls_nro      varchar2(20);
    ls_serie    varchar2(20);
    long_serie  number;
  
  begin
    ls_nro := replace(as_nro_doc, '.', '-');
    ls_nro := replace(ls_nro, '--', '-');
    
    ls_serie := PKG_FACT_ELECTRONICA.of_get_serie(ls_nro);
    
    if ls_serie is null then
       long_serie := 0;
    else
       long_serie := length(ls_serie);
    end if;
    
    
    
    if instr(ls_nro, '-') > 0 then
       ls_nro := trim(substr(ls_nro, instr(ls_nro, '-') + 1));
       
       if length(ls_nro) + length(ls_serie) < 12 then
          ls_nro := lpad(ls_nro, 12 - length(ls_Serie), '0');   
       else
          ls_nro := substr(ls_nro, length(ls_nro) + long_serie - 12);
       end if;
       
       
    else
       ls_nro := trim(ls_nro);
    end if;
    
    return ls_nro;
  
  end;
  
  -- Function para obtener el nro completo del Documento
  function of_get_full_nro(as_nro_doc in cntas_cobrar.nro_doc%TYPE) return varchar2 as
    
    ls_nro      varchar2(20);
    ls_serie    varchar2(20);
  
  begin
    ls_serie := pkg_fact_electronica.of_get_serie(as_nro_doc);
    
    ls_nro := ls_serie || case when length(ls_serie) > 0 then '-' else '' end  || pkg_fact_electronica.of_get_nro(as_nro_doc);
    
    return ls_nro;
  
  end;
  
  -- Function para obtener la forma de pago de la factura simplificada
  function of_get_forma_pago(
    as_nro_registro in fs_factura_simpl.nro_registro%TYPE
  ) return varchar2 as
    
    ls_return         varchar2(200);
    ln_count          number;
    ln_count_vd       number;
    ln_count_ref      number;
    ls_tipo_doc       fs_factura_simpl.tipo_doc_cxc%TYPE;
    ls_motivo_nota	  motivo_nota.descripcion%TYPE;
    ls_observacion    fs_factura_simpl.observacion%TYPE;
  
  begin
    
    select f.tipo_doc_cxc, mn.descripcion, f.observacion
      into ls_tipo_doc, ls_motivo_nota, ls_observacion
      from fs_factura_simpl f,
           motivo_nota      mn
     where f.motivo_nota  = mn.motivo   (+)
       and f.nro_registro = as_nro_registro;
    
    if ls_tipo_doc in (PKG_SIGRE_FINANZAS.is_doc_ncc, PKG_SIGRE_FINANZAS.is_doc_ndc) then
       return ls_motivo_nota || '.';
    end if;
    
    select count(*)
      into ln_count
      from fs_factura_simpl_pagos fp
     where fp.nro_registro = as_nro_registro;
     
    if ln_count > 1 then
             
       ls_return := 'VARIOS';
        
    elsif ln_count = 0 then
      
      select count(*) 
        into ln_count_vd
        from fs_factura_simpl_det fd
       where fd.nro_registro = as_nro_registro
         and fd.nro_vale_vd is not null;

      select count(*) 
        into ln_count_ref
        from fs_factura_simpl_det fd
       where fd.nro_registro = as_nro_registro
         and fd.nro_doc_cxc is not null;
             
       if ln_count_vd > 0 then
                   
          ls_return := 'DESCUENTO POR VALE DE DESCUENTO';
            
       elsif ln_count_ref > 0 then
          
          ls_return := 'DESCUENTO POR ANTICIPOS';
          
       ELSE
         
          ls_return := 'NO DEFINIDO';
          
       END if;
    else
       select decode(fp.flag_forma_pago, 'E', 'EFECTIVO', 'C', 'CREDITO', 'T', 'TARJETA', 'O', 'CONSIGNACION', 'N', 'NOTA DE CREDITO')
         into ls_return
         from fs_factura_simpl_pagos fp
        where fp.nro_registro = as_nro_registro;
    END if;
    
    return ls_return;
  
  end;

  -- Function para obtener la forma de pago de la factura simplificada
  function of_get_cod_forma_pago(
    asi_nro_registro       in  fs_factura_simpl.nro_registro%TYPE,
    ado_fec_vencimiento    out cntas_cobrar.fecha_vencimiento%TYPE
  ) return forma_pago.forma_pago%TYPE as
    
    ln_count                   number;
    ls_motivo_nota	           motivo_nota.descripcion%TYPE;
    
    -- Tabla fs_factura_simpl
    ls_tipo_doc                fs_factura_simpl.tipo_doc_cxc%TYPE;
    ls_observacion             fs_factura_simpl.observacion%TYPE;
    ls_flag_forma_pago         fs_factura_simpl_pagos.flag_forma_pago%TYPE;
    ls_flag_tipo_credito       fs_factura_simpl_pagos.flag_tipo_credito%TYPE;
    ld_fec_emision             fs_factura_simpl.fec_registro%TYPE;
    ls_cliente                 fs_factura_simpl.cliente%TYPE;
    
    --Tabla Forma_pago
    ln_dias_vencimiento        forma_pago.dias_vencimiento%TYPE;
    ls_forma_pago              forma_pago.forma_pago%TYPE;
    ls_desc_forma_pago         forma_pago.desc_forma_pago%TYPE;
  
  begin
    
    select f.tipo_doc_cxc, mn.descripcion, f.observacion, trunc(f.fec_movimiento),
           f.cliente
      into ls_tipo_doc, ls_motivo_nota, ls_observacion, ld_fec_emision,
           ls_cliente
      from fs_factura_simpl f,
           motivo_nota      mn
     where f.motivo_nota  = mn.motivo   (+)
       and f.nro_registro = asi_nro_registro;
    
    if ls_tipo_doc in (PKG_SIGRE_FINANZAS.is_doc_ncc, PKG_SIGRE_FINANZAS.is_doc_ndc) then
       return is_fp_pcon;
    end if;
    
    select count(*)
      into ln_count
      from fs_factura_simpl_pagos fp
     where fp.nro_registro = asi_nro_registro;
     
    if ln_count > 1 then
             
       ls_forma_pago := 'PVAR';
       ls_desc_forma_pago := 'PAGOS VARIOS';
       ln_dias_vencimiento := 1;
        
    elsif ln_count = 0 then
        
       ls_forma_pago := 'COMP'; 
       ls_desc_forma_pago := 'COMPENSACION DE PAGO';
       ln_dias_vencimiento := 1;
       
    else
       select fp.flag_forma_pago, fp.flag_tipo_credito
         into ls_flag_forma_pago, ls_flag_tipo_credito
         from fs_factura_simpl_pagos fp
        where fp.nro_registro = asi_nro_registro;
       
       if ls_flag_forma_pago = 'E' then
          -- Pago en efectivo
          ls_forma_pago := 'PEFE';
          ls_desc_forma_pago := 'PAGO EN EFECTIVO';
          ln_dias_vencimiento := 1;
          
       elsif ls_flag_forma_pago = 'T' then
         
          -- Pago con tarjeta
          ls_forma_pago := 'PTAR';
          ls_desc_forma_pago := 'PAGO CON TARJETA';
          ln_dias_vencimiento := 1;
         
       elsif ls_flag_forma_pago = 'O' then
         
          -- Pago con tarjeta
          ls_forma_pago := 'PCSG';
          ls_desc_forma_pago := 'PAGO A CONSIGNATARIO';
          ln_dias_vencimiento := 30;

       elsif ls_flag_forma_pago = 'D' then
         
          -- Pago con deposito bancario
          ls_forma_pago := 'DBAN';
          ls_desc_forma_pago := 'PAGO CON DEPOSITO BANCARIO';
          ln_dias_vencimiento := 1;

       elsif ls_flag_forma_pago = 'H' then
         
          -- Pago con cheque
          ls_forma_pago := 'PCHQ';
          ls_desc_forma_pago := 'PAGO CON CHEQUE';
          ln_dias_vencimiento := 1;

       elsif ls_flag_forma_pago = 'N' then
         
          -- Aplicacion de nota de credito
          ls_forma_pago := 'PNCC';
          ls_desc_forma_pago := 'APLICACION DE NOTA DE CREDITO';
          ln_dias_vencimiento := 1;

       elsif ls_flag_forma_pago = 'C' then
          if ls_flag_tipo_credito = '1' then
             -- Factura a 7 dias
             ls_forma_pago := 'F07';
             ls_desc_forma_pago := 'FACTURA 07 DIAS';
             ln_dias_vencimiento := 7;
          elsif ls_flag_tipo_credito = '2' then
             -- Factura a 15 dias
             ls_forma_pago := 'F15';
             ls_desc_forma_pago := 'FACTURA 15 DIAS';
             ln_dias_vencimiento := 15;
          elsif ls_flag_tipo_credito = '3' then
             -- Factura a 30 dias
             ls_forma_pago := 'F30';
             ls_desc_forma_pago := 'FACTURA 30 DIAS';
             ln_dias_vencimiento := 30;
          elsif ls_flag_tipo_credito = '4' then
             -- Factura a 60 dias
             ls_forma_pago := 'F60';
             ls_desc_forma_pago := 'FACTURA 60 DIAS';
             ln_dias_vencimiento := 60;
          elsif ls_flag_tipo_credito = '5' then
             -- Factura a 90 dias
             ls_forma_pago := 'F90';
             ls_desc_forma_pago := 'FACTURA 90 DIAS';
             ln_dias_vencimiento := 90;
          elsif ls_flag_tipo_credito = '6' then
             -- Factura a 120 dias
             ls_forma_pago := 'F120';
             ls_desc_forma_pago := 'FACTURA 120 DIAS';
             ln_dias_vencimiento := 120;
          elsif ls_flag_tipo_credito = '7' then
             -- Factura a 150 dias
             ls_forma_pago := 'F150';
             ls_desc_forma_pago := 'FACTURA 150 DIAS';
             ln_dias_vencimiento := 150;
          elsif ls_flag_tipo_credito = '8' then
             -- Factura a 180 dias
             ls_forma_pago := 'F180';
             ls_desc_forma_pago := 'FACTURA 180 DIAS';
             ln_dias_vencimiento := 180;
          elsif ls_flag_tipo_credito = '9' then
             -- Factura a 45 dias
             ls_forma_pago := 'F45';
             ls_desc_forma_pago := 'FACTURA 45 DIAS';
             ln_dias_vencimiento := 45;
          elsif ls_flag_tipo_credito = 'A' then
             -- Credito Directo
             ls_forma_pago := 'CLET';
             ls_desc_forma_pago := 'CREDITO A LETRAS';
             ln_dias_vencimiento := 30;
          elsif ls_flag_tipo_credito = 'B' then
             -- Credito bancario
             ls_forma_pago := 'CCON ';
             ls_desc_forma_pago := 'CREDITO CONVENCIONAL';
             ln_dias_vencimiento := 15;
          elsif ls_flag_tipo_credito = 'D' then
             -- Descuento por Planilla
             ls_forma_pago := 'DPLA';
             ls_desc_forma_pago := 'DESCUENTO POR PLANILLA';
             
             -- Obtengo el numero de dias
             select count(*)
               into ln_count
               from proveedor_linea_credito t
              where t.proveedor = ls_cliente
                and trunc(ld_fec_emision) between t.fec_ini_vigencia and t.fec_fin_vigencia;
             
             if ln_count > 0 then
                select t.nro_cuotas
                  into ln_dias_vencimiento
                  from proveedor_linea_credito t
                 where t.proveedor = ls_cliente
                   and trunc(ld_fec_emision) between t.fec_ini_vigencia and t.fec_fin_vigencia
                   and rownum = 1;
             else
                ln_dias_vencimiento := 0;
             end if;
             
             ln_dias_vencimiento := 15;
          end if;
             
          
       end if;
       
    end if;
       
    --Verifico la forma de Pago
    if ls_forma_pago is null or trim(ls_forma_pago) = '' then
       RAISE_APPLICATION_ERROR(-20000, 'Se ha devuelto una forma de pago nula para el registro ' 
                                    || asi_nro_registro || '. Por favor verifique!');
    end if;
    
    -- Nueva Fecha Vencimiento
    ado_fec_vencimiento := ld_fec_emision + ln_dias_vencimiento;
    
    select count(*)
      into ln_count
      from forma_pago fp
     where fp.forma_pago = ls_forma_pago;
       
    if ln_count = 0 then
       insert into forma_pago(
              forma_pago, desc_forma_pago, dias_vencimiento, flag_estado, flag_no_cobrable)
       values(
              ls_forma_pago, ls_desc_forma_pago, ln_dias_vencimiento, '1', '0');
    else
       update forma_pago fp
           set fp.desc_forma_pago = ls_desc_forma_pago,
               fp.dias_vencimiento  = ln_dias_vencimiento
         where fp.forma_pago = ls_forma_pago;
    end if;
    
    return ls_forma_pago;
  
  end;

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
  )return banco_cnta.cod_ctabco%TYPE as
   
    ls_cod_ctabco       banco_cnta.cod_ctabco%TYPE;
    ls_desc_banco_cnta  banco_cnta.descripcion%TYPE;
    ls_cod_banco        banco.cod_banco%TYPE;
    ln_count            number;
    ls_mensaje_Error    varchar2(3000);
  
  begin
     if asi_flag_forma_pago in ('E', 'T') then
         if asi_flag_forma_pago = 'E' then
            --Busco la caja mas adecuada al origen, moneda, codigo de banco, flag_uso interno
            select count(*)
              into ln_count
              from banco_cnta bc
             where bc.cod_banco   = is_banco_caja
               and bc.cod_origen  = asi_origen
               and bc.cod_moneda  = asi_moneda
               and bc.flag_uso_interno = '2';
               
            -- Si solo hay un registro hay un problema
            if ln_count = 0 then
               RAISE_APPLICATION_ERROR(-20000, 'No existe registro de BANCO_CNTA para uso interno de acuerdo a los siguiente datos: '
                                 || chr(13) || 'Origen: ' || asi_origen
                                 || chr(13) || 'Moneda: ' || asi_moneda
                                 || chr(13) || 'Cod Banco: ' || is_banco_caja
                                 || chr(13) || 'Uso Interno: 2'
                                 || chr(13) || 'Documento:' || asi_nro_doc );
            end if;
            -- Si existe mas de un registro tambien hay un problema
            if ln_count > 1 then
               RAISE_APPLICATION_ERROR(-20000, 'No existe mas de un registro de BANCO_CNTA para uso interno de acuerdo a los siguiente datos: '
                                 || chr(13) || 'Origen: ' || asi_origen
                                 || chr(13) || 'Moneda: ' || asi_moneda
                                 || chr(13) || 'Cod Banco: ' || is_banco_caja
                                 || chr(13) || 'Uso Interno: 2');
            end if;
            
            select bc.cod_ctabco, bc.cnta_ctbl, cc.desc_cnta
              into ls_cod_ctabco, aso_cnta_cntbl, aso_desc_cnta_cntbl
              from banco_cnta bc,
                   cntbl_cnta cc
             where bc.cnta_ctbl   = cc.cnta_ctbl
               and bc.cod_banco   = is_banco_caja
               and bc.cod_origen  = asi_origen
               and bc.cod_moneda  = asi_moneda
               and bc.flag_uso_interno = '2';
            
            --Valido la cuenta contable
            if aso_cnta_cntbl is null or trim(aso_cnta_cntbl) = '' then
               RAISE_APPLICATION_ERROR(-20000, 'La cuenta de banco ' || ls_cod_ctabco || ' no tiene cuenta contable asociada, por favor verifique!');
            end if;

            if aso_desc_cnta_cntbl is null or trim(aso_desc_cnta_cntbl) = '' then
               RAISE_APPLICATION_ERROR(-20000, 'La cuenta contable ' || aso_cnta_cntbl || ' no tiene existe en el plan de cuentas, por favor verifique!');
            end if;
            
            -- Retorno la cuenta contable no hay mas nada que hace
            return ls_cod_ctabco;
               
         elsif asi_tipo_tarjeta = 'V' then -- Tarjeta Visa
            aso_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_tarjeta_visa;
         elsif asi_tipo_tarjeta = 'M' then -- Tarjeta Mastercard
            aso_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_tarjeta_mast;
         elsif asi_tipo_tarjeta = 'A' then -- American Express
            aso_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_tarjeta_american;
         elsif asi_tipo_tarjeta = 'S' then -- Estilos
            aso_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_tarjeta_estilos;
         elsif asi_tipo_tarjeta = 'D' then -- Dinners Club
            aso_cnta_cntbl := PKG_FACT_ELECTRONICA.is_cc_tarjeta_din_club;
         end if;
                   
         -- Segundo: Valido si la cuenta contable existe en el plan de cuentas
         select count(*)
           into ln_count
           from cntbl_cnta cc
          where cc.cnta_ctbl = aso_cnta_cntbl;
                   
         if ln_count = 0 then
            ls_mensaje_error := 'NO EXISTE LA CUENTA CONTABLE: ' || aso_cnta_cntbl || ' PARA LA FORMA DE PAGO ' ;
            if asi_tipo_tarjeta = 'V' then -- Tarjeta Visa
               ls_mensaje_error := ls_mensaje_error || 'TARJETA VISA ';
            elsif asi_tipo_tarjeta = 'M' then -- Tarjeta Mastercard
               ls_mensaje_error := ls_mensaje_error || 'TARJETA MASTERCARD ';
            elsif asi_tipo_tarjeta = 'A' then -- American Express
               ls_mensaje_error := ls_mensaje_error || 'TARJETA AMERICAN EXPRESS ';
            elsif asi_tipo_tarjeta = 'S' then -- Estilos
               ls_mensaje_error := ls_mensaje_error || 'TARJETA ESTILOS ';
            elsif asi_tipo_tarjeta = 'D' then -- Dinners Club
               ls_mensaje_error := ls_mensaje_error || 'TARJETA DINNERS CLUB ';
            end if;
                      
            ls_mensaje_error := ls_mensaje_error || ' PARA EL DOCUMENTO ' || asi_tipo_doc || '/' || asi_nro_doc;
                      
            RAISE_APPLICATION_ERROR(-20000, ls_mensaje_error);
         end if;
                   
         -- Tercero: Paso averiguo la Codigo de la cuenta de Caja /Bancos asociado a la cuenta contable
         select count(*)
           into ln_count
           from banco_cnta bc
          where bc.cnta_ctbl = aso_cnta_cntbl;
                   
         if ln_count > 1 then
            RAISE_APPLICATION_ERROR(-2000, 'Existen dos codigos de cuenta bancaria que tienen la misma cuenta contable ' || aso_cnta_cntbl || ', por favor verifique!');
         end if;
                   
         if ln_count = 0 then
            if asi_tipo_tarjeta = 'V' then -- Tarjeta Visa
               ls_cod_ctabco      := 'TARJETA_VISA';
               ls_desc_banco_cnta := 'TARJETA VISA';
            elsif asi_tipo_tarjeta = 'M' then -- Tarjeta Mastercard
               ls_cod_ctabco      := 'TARJETA_MASTER';
               ls_desc_banco_cnta := 'TARJETA MASTERCARD';
            elsif asi_tipo_tarjeta = 'A' then -- American Express
               ls_cod_ctabco      := 'TARJETA_AE';
               ls_desc_banco_cnta := 'TARJETA AMERICAN EXPRESS';
            elsif asi_tipo_tarjeta = 'S' then -- Estilos
               ls_cod_ctabco      := 'TARJETA_ESTILOS';
               ls_desc_banco_cnta := 'TARJETA ESTILOS';
            elsif asi_tipo_tarjeta = 'D' then -- Dinners Club
               ls_cod_ctabco      := 'TARJETA_DC';
               ls_desc_banco_cnta := 'TARJETA DINNERS CLUB';
            end if;
                      
            -- Elijo el codigo de banco
            ls_cod_banco := '101';
            
            insert into banco_cnta(
                   cod_ctabco, cnta_ctbl, cod_banco, tipo_ctabco, descripcion, cod_moneda, cod_origen, flag_estado, 
                   flag_flujo_caja, flag_uso_interno)
            values(
                   ls_cod_ctabco, aso_cnta_cntbl, ls_cod_banco, 'A', ls_desc_banco_cnta, asi_moneda, asi_origen, '1', 
                   '1', '1');
         else
            -- Obtengo el codigo de la cuenta de caja / bancos
            select bc.cod_ctabco
              into ls_cod_ctabco
              from banco_cnta bc
             where bc.cnta_ctbl = aso_cnta_cntbl;
         end if;
     end if;   
     
     return ls_cod_ctabco; 
  end;
  
  -- Anulo el comprobante de interes que esta demas
  procedure sp_anular_ce_interes(
     asi_nada        in char
  ) is
    cursor c_datos is
      select cc.tipo_doc, cc.nro_doc, cc.importe_doc,
         cc.fecha_documento, cc.flag_estado, 
         fp.nro_registro, fp.total_interes,
         cc.origen, cc.ano, cc.mes, cc.nro_libro, cc.nro_Asiento
      from cntas_cobrar cc,
           fs_factura_simpl_pagos fp,
           fs_factura_simpl       f
      where cc.tipo_doc = fp.tipo_doc_interes (+)
        and cc.nro_doc  = fp.nro_doc_interes  (+)
        and fp.nro_registro = f.nro_registro  (+)
        and substr(cc.nro_doc,1,2) in ('BI', 'FI')  
        and (fp.total_interes is null or f.flag_estado = '0');
      
  begin
    for lc_reg in c_Datos loop
        -- Anulo el asiento contable
        update cntbl_Asiento_det cad
           set cad.imp_movsol = 0,
               cad.imp_movdol = 0
         where cad.origen = lc_reg.origen
           and cad.ano    = lc_reg.ano
           and cad.mes    = lc_reg.mes
           and cad.nro_libro = lc_reg.nro_libro
           and cad.nro_asiento = lc_Reg.nro_Asiento;
           
        update cntbl_Asiento ca
           set ca.tot_soldeb = 0,
               ca.tot_solhab = 0,
               ca.tot_doldeb = 0,
               ca.tot_dolhab = 0,
               ca.flag_estado = '0'
         where ca.origen = lc_reg.origen
           and ca.ano    = lc_reg.ano
           and ca.mes    = lc_reg.mes
           and ca.nro_libro = lc_reg.nro_libro
           and ca.nro_asiento = lc_Reg.nro_Asiento;
           
        -- Procedo a anular los comprobantes de Interes que estan incorrectos
        update cc_doc_det_imp ci
           set ci.importe = 0
         where ci.tipo_doc = lc_Reg.Tipo_Doc
           and ci.nro_doc  = lc_reg.nro_doc;
           
        update cntas_cobrar_det ccd
           set ccd.cantidad = 0,
               ccd.precio_unitario = 0
         where ccd.tipo_doc = lc_Reg.Tipo_Doc
           and ccd.nro_doc  = lc_reg.nro_doc;

        update cntas_cobrar cc
           set cc.importe_doc = 0,
               cc.flag_estado = '0'
         where cc.tipo_doc = lc_Reg.Tipo_Doc
           and cc.nro_doc  = lc_reg.nro_doc;

    end loop;
      
  end ;
  
  -- Corrige los comprobantes electronicos que estan defectuosos y los elimina
  ----------------------------------------------------------------------------
  procedure sp_corregir_ce_defectuosos(
     asi_nada        in char
  ) is
    cursor c_datos is
      select t.tipo_doc, t.nro_doc,
             t.origen, t.ano, t.mes, t.nro_libro, t.nro_asiento
      from cntas_cobrar t
      where t.tipo_doc in ('BVC', 'FAC')
        and substr(t.nro_doc, 1, 1) in ('F', 'B')
        and ((t.tipo_doc = 'BVC' and substr(t.nro_doc, 1, 1) = 'F')
          or (t.tipo_doc = 'FAC' and substr(t.nro_doc, 1, 1) = 'B'));
    
  begin
    for lc_reg in c_Datos loop
        -- Procedo a anular los comprobantes de Interes que estan incorrectos
        delete cc_doc_det_imp ci
         where ci.tipo_doc = lc_Reg.Tipo_Doc
           and ci.nro_doc  = lc_reg.nro_doc;
           
        delete cntas_cobrar_det ccd
         where ccd.tipo_doc = lc_Reg.Tipo_Doc
           and ccd.nro_doc  = lc_reg.nro_doc;

        delete cntas_cobrar cc
         where cc.tipo_doc = lc_Reg.Tipo_Doc
           and cc.nro_doc  = lc_reg.nro_doc;

    end loop;
  end ;
  
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
  ) is
  
    ls_nro_ov          orden_venta.nro_ov%TYPE;
    ln_count           number;
    ln_ult_nro         number;
    ls_forma_pago      orden_venta.forma_pago%TYPE;
    ls_forma_embaque   orden_venta.forma_embarque%TYPE := 'EXW';
    ls_impuesto        articulo_mov_proy.tipo_impuesto1%TYPE;
    ls_tabla           num_tablas.tabla%TYPE;
    
    -- Articulo_mov_proy
    ls_org_amp          articulo_mov_proy.cod_origen%TYPE;
    ln_nro_amp          articulo_mov_proy.nro_mov%TYPE;
    
    -- Vale_mov
    ls_org_vm           vale_mov.cod_origen%TYPE := 'AX';
    ls_nom_receptor     vale_mov.nom_receptor%TYPE;
    ld_fec_registro     vale_mov.fec_registro%TYPE;
    ls_tipo_mov         vale_mov.tipo_mov%TYPE;
    ls_nro_Vale         vale_mov.nro_vale%TYPE;
    
    -- Articulo_mov
    ls_matriz           articulo_mov.matriz%TYPE;
    ln_precio_unit      articulo_mov.precio_unit%TYPE;
    ls_org_am           articulo_mov.cod_origen%TYPE;
    ln_nro_am           articulo_mov.nro_mov%TYPE;
    
    -- Guia de remision
    ls_nro_gr           guia.nro_guia%TYPE;
    
    -- Factura Simplificada
    ls_tipo_ce          fs_factura_simpl.tipo_doc_cxc%TYPE;
    ls_nro_cxc          fs_factura_simpl.nro_cxc%TYPE;
    ls_nro_doc          fs_factura_simpl.nro_doc_cxc%TYPE;
    ls_nro_registro     fs_factura_simpl.nro_registro%TYPE;
    ln_tasa_cambio      fs_factura_simpl.tasa_cambio%TYPE;
    ls_punto_venta      fs_factura_simpl.punto_venta%TYPE;
    
    -- Articulo_almacen
    ln_sldo_total       articulo_almacen.sldo_total%TYPE;
    ln_sldo_total_und2  articulo_almacen.sldo_total_und2%TYPE;
    
    -- FActuracion simplificada det
    ln_nro_item        fs_factura_simpl_det.nro_item%TYPE;
    ls_flag_afecto_igv fs_factura_simpl_det.flag_afecto_igv%TYPE;
    ln_porc_igv        fs_factura_simpl_det.porc_igv%TYPE;
    
    -- Facturacion Pago
    ln_monto           fs_factura_simpl_pagos.monto%TYPE;
    
    cursor c_proforma is
      select p.nro_proforma,
             p.cod_origen,
             p.cliente, 
             pr.nom_proveedor as nom_cliente,
             pr.tipo_doc_ident,
             decode(pr.tipo_doc_ident, '6', pr.ruc, pr.tipo_doc_ident) as ruc_dni,
             p.item_direccion,
             d.ubigeo,
             d.zona_despacho,
             p.vendedor, 
             v.nom_vendedor,
             p.cod_moneda,
             p.tasa_cambio,
             p.flag_tranf_gratuita,
             PKG_LOGISTICA.of_get_direccion(p.cliente, p.item_direccion) as full_direccion,
             pd.nro_item,
             pd.cod_art,
             pd.cantidad,
             a.und,
             a.und2,
             a.sub_cat_art,
             pd.cantidad_und2,
             pd.almacen, 
             al.cod_origen as org_almacen,
             al.direccion as dir_almacen,
             pd.precio_vta,
             pd.igv,
             av.cencos_ingreso,
             av.cnta_prsp_ingreso,
             av.cnta_prsp_vale_sal,
             (Select max(cba.centro_benef)
                from centro_benef_articulo cba
               where cba.cod_art = pd.cod_art) as centro_benef,
             pd.descripcion
        from proforma     p,
             proforma_det pd,
             direcciones  d,
             vendedor     v,
             almacen      al,
             articulo     a,
             articulo_Venta av,
             proveedor      pr
       where p.nro_proforma   = pd.nro_proforma
         and p.cliente        = d.codigo
         and p.cliente        = pr.proveedor
         and p.item_direccion = d.item
         and p.vendedor       = v.vendedor
         and pd.almacen       = al.almacen
         and pd.cod_art       = av.cod_art         (+)
         and pd.cod_art       = a.cod_Art          
         and p.nro_proforma   = asi_nro_proforma
       order by pd.nro_item;
     
  begin
     
     -- Recorro los registros
     for lc_reg in c_proforma loop
         if lc_reg.flag_tranf_gratuita = '1' then
            ls_forma_pago := 'TGRAT';
         else
            ls_forma_pago := 'PCON';
         end if;
         
         ---------------------
         -- Valido información
         ---------------------
         if substr(asi_serie_ce, 1, 1) = 'F' and lc_reg.tipo_doc_ident <> '6' then
           
            RAISE_APPLICATION_ERROR(-20000, 'La serie comienza con F, por lo que el Tipo de Documento de Identidad del Cliente debe ser RUC unicamente'
                                      || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                                      || chr(13) || 'Cliente: ' || lc_reg.cliente
                                      || chr(13) || 'Producto: ' || lc_reg.descripcion);
                                      
         elsif substr(asi_serie_ce, 1, 1) = 'B' and lc_reg.tipo_doc_ident = '6' then  
                                            
            RAISE_APPLICATION_ERROR(-20000, 'La serie comienda con B, por lo que el Tipo de Documento de Identidad del Cliente no debe ser RUC'
                                      || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                                      || chr(13) || 'Cliente: ' || lc_reg.cliente
                                      || chr(13) || 'Producto: ' || lc_reg.descripcion);
                                      
         end if;
         
         ------------------------------
         -- Creo la orden de Venta
         ------------------------------
         select count(*)
           into ln_count
           from orden_Venta ov
          where ov.flag_estado    <> '0'
            and ov.tipo_doc       = is_doc_prof
            and ov.nro_doc        = lc_reg.nro_proforma;
         
         -- Si no existe ninguna OV que apunte a la proforma entonces creo una nueva orden de venta
         if ln_count = 0 then
            select count(*)
              into ln_count
              from num_orden_venta n
             where n.origen        = ls_org_vm;
            
            if ln_count = 0 then
               insert into num_orden_venta(
                      ult_nro, origen)
               values(
                      1, ls_org_vm);
            end if;
            
            select n.ult_nro
              into ln_ult_nro
              from num_orden_venta n
             where n.origen        = ls_org_vm for update;
            
            ls_nro_ov := trim(ls_org_vm) || trim(to_char(ln_ult_nro, '0000000'));
            
            update num_orden_venta n
               set n.ult_nro = ln_ult_nro + 1
             where n.origen  = ls_org_vm;
             
            
            -- Inserto la cabecera de la orden de Venta 
            insert into orden_venta(
                   cod_origen, nro_ov, flag_estado, fec_registro, forma_pago, cod_moneda, monto_total,
                   monto_facturado, nom_vendedor, cod_usr, cliente, comprador_final, 
                   destino, obs, flag_mercado, punto_partida,
                   fecha_doc, vendedor, 
                   monto_flete, monto_seguro, ubigeo_dst, tipo_doc, nro_doc)
            values(
                   lc_reg.cod_origen, ls_nro_ov, '1', sysdate, ls_forma_pago, lc_reg.cod_moneda, 0,
                   0, lc_reg.nom_vendedor, asi_usuario, lc_reg.cliente, lc_reg.cliente, 
                   lc_reg.full_direccion, asi_observaciones, 'L', lc_reg.dir_almacen,
                   adi_fec_inicio_traslado, lc_reg.vendedor,
                   0, 0, lc_reg.ubigeo, is_doc_prof, lc_reg.nro_proforma);
            
         else
            select distinct ov.nro_ov
              into ls_nro_ov
              from orden_Venta ov
             where ov.flag_estado    <> '0'
               and ov.tipo_doc       = is_doc_prof
               and ov.nro_doc        = lc_reg.nro_proforma;    
            
         end if;
         
         -- Valido si existe o no el detalle
         select count(*)
           into ln_count
           from articulo_mov_proy amp
          where amp.tipo_doc      = is_doc_ov
            and amp.nro_doc       = ls_nro_ov
            and amp.flag_estado   <> '0'
            and amp.nro_proforma  = lc_reg.nro_proforma
            and amp.item_proforma = lc_reg.nro_item;
            
         if ln_count = 0 then
            -- Inserto el detalle de la orden de Venta
            if lc_reg.igv > 0 then
               ls_impuesto := 'IGV18';
            else
               ls_impuesto := null;
            end if;
            
            if lc_Reg.Cencos_Ingreso is null then
               RAISE_APPLICATION_ERROR(-20000, 'Código de Articulo no tiene asignado Centro de Costos de Ingreso, por favor verifique!'
                              || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                              || chr(13) || 'Cliente: ' || lc_reg.cliente
                              || chr(13) || 'Cod Art: ' || lc_reg.cod_art);
            end if;
            
            if lc_Reg.cnta_prsp_ingreso is null then
               RAISE_APPLICATION_ERROR(-20000, 'Código de Articulo no tiene asignado Cuenta Presupuestal de Ingreso, por favor verifique!'
                              || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                              || chr(13) || 'Cliente: ' || lc_reg.cliente
                              || chr(13) || 'Cod Art: ' || lc_reg.cod_art);
            end if;
                 
            insert into articulo_mov_proy(
                   cod_origen, flag_estado, cod_art, tipo_mov, tipo_doc, nro_doc, fec_registro,
                   fec_proyect, cant_proyect, cant_procesada, cant_facturada, cant_despacho,
                   precio_unit, und, factor_conv,
                   impuesto, cod_moneda, cencos, cnta_prsp, almacen, cod_usr, decuento,
                   cant_reservado, tipo_impuesto1, centro_benef, nro_proforma, item_proforma)
            values(
                   lc_reg.cod_origen, '1', lc_reg.cod_art, 'S02', is_doc_ov, ls_nro_ov, sysdate,
                   trunc(adi_fec_inicio_traslado), lc_reg.cantidad, 0, 0, 
                   lc_reg.cantidad, lc_reg.precio_vta, lc_reg.und, 1,
                   lc_reg.cantidad * lc_reg.igv, lc_reg.cod_moneda, lc_reg.cencos_ingreso, 
                   lc_reg.cnta_prsp_ingreso, lc_reg.almacen, asi_usuario, 0,
                   0, ls_impuesto, lc_reg.centro_benef,  lc_reg.nro_proforma, lc_reg.nro_item);   
         end if;   
         
         -- Obtengo el org_amp y el nro_amp
         select amp.cod_origen, amp.nro_mov
           into ls_org_amp, ln_nro_amp
           from articulo_mov_proy amp
          where amp.tipo_doc      = is_doc_ov
            and amp.nro_doc       = ls_nro_ov
            and amp.flag_estado   <> '0'
            and amp.nro_proforma  = lc_reg.nro_proforma
            and amp.item_proforma = lc_reg.nro_item;
         
         if ls_org_amp is null then
            RAISE_APPLICATION_ERROR(-20000, 'ORG AMP es nulo, por favor verifique!'
                              || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                              || chr(13) || 'Cliente: ' || lc_reg.cliente
                              || chr(13) || 'Item : ' || trim(to_char(lc_reg.nro_item))
                              || chr(13) || 'Cod Art: ' || lc_reg.cod_art);
         end if;
         
         if ln_nro_amp is null then
            RAISE_APPLICATION_ERROR(-20000, 'NRO AMP es nulo, por favor verifique!'
                              || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                              || chr(13) || 'Cliente: ' || lc_reg.cliente
                              || chr(13) || 'Item : ' || trim(to_char(lc_reg.nro_item))
                              || chr(13) || 'Cod Art: ' || lc_reg.cod_art);
         end if;
            
         ------------------------------
         -- Genero el Vale de Salida
         ------------------------------
         ld_fec_registro := to_date(to_char(adi_fec_inicio_traslado, 'dd/mm/yyyy') || ' 23:59:59', 'dd/mm/yyyy HH24:mi:ss');
         
         if ld_fec_registro > sysdate then
            ld_fec_registro := sysdate;
         end if;
         
         -- Ahora busco un vale de salida que tenga la proforma
         select count(distinct vm.nro_vale)
           into ln_count
           from vale_mov vm,
                articulo_mov am
          where vm.nro_Vale     = am.nro_Vale
            and vm.flag_estado  <> '0'
            and am.flag_estado  <> '0'
            and am.nro_proforma = lc_reg.nro_proforma
            and vm.almacen      = lc_reg.almacen
            and vm.tipo_mov     = PKG_LOGISTICA.is_oper_vnta_terc;
         
         if ln_count > 1 then
            RAISE_APPLICATION_ERROR(-20000, 'Se ha generado mas de un Vale de Salida por el Item de la Proforma, por favor verifique!'
                              || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                              || chr(13) || 'Cliente: ' || lc_reg.cliente
                              || chr(13) || 'Almacen : ' || lc_reg.almacen
                              || chr(13) || 'Cod Art: ' || lc_reg.cod_art);
         elsif ln_count = 0 then
            -- Inserto una cabecera un vale de salida
            select count(*)
              into ln_count
              from num_vale_mov n
             where n.origen     = ls_org_vm;
            
            if ln_count = 0 then
               insert into num_vale_mov(
                      ult_nro, origen)
               values(
                      1, ls_org_vm);
            end if;
            
            select ult_nro
              into ln_ult_nro
              from num_vale_mov n
             where n.origen     = ls_org_vm for update;
            
            ls_nro_Vale := trim(ls_org_vm) || trim(to_char(ln_ult_nro, '00000000'));
            
            update num_vale_mov n
               set n.ult_nro    = ln_ult_nro + 1
             where n.origen     = ls_org_vm;
            
            ls_nom_receptor := 'DESPACHO AUTOMATIZADO';
            
            insert into vale_mov(
                   cod_origen, nro_vale, almacen, flag_estado,
                   fec_registro, tipo_mov, cod_usr, proveedor, nom_receptor, 
                   tipo_doc_int, nro_doc_int, 
                   origen_refer, tipo_refer, nro_refer,
                   observaciones, vendedor, fec_produccion, almacen_old)
            values(
                   lc_reg.org_almacen, ls_nro_Vale, lc_reg.almacen, '1',
                   ld_fec_registro, 
                   PKG_LOGISTICA.is_oper_vnta_terc, 
                   asi_usuario, lc_reg.cliente, ls_nom_receptor,
                   is_doc_prof, lc_reg.nro_proforma, 
                   lc_reg.cod_origen, is_doc_ov, ls_nro_ov,
                   asi_observaciones, lc_reg.vendedor, trunc(ld_fec_registro), lc_reg.almacen);
         else
            select distinct
                   vm.nro_vale
              into ls_nro_Vale
              from vale_mov vm,
                   articulo_mov am
             where vm.nro_Vale     = am.nro_Vale
               and vm.flag_estado  <> '0'
               and am.flag_estado  <> '0'
               and am.nro_proforma = lc_reg.nro_proforma
               and vm.almacen      = lc_reg.almacen
               and vm.tipo_mov     = PKG_LOGISTICA.is_oper_vnta_terc;
            
            update vale_mov vm
               set vm.fec_registro = ld_fec_registro,
                   vm.fec_produccion = trunc(ld_fec_registro)
             where vm.nro_vale       = ls_nro_vale;
         end if;   
         
         -- Ahora busco el detalle
         select count(*)
           into ln_count
           from articulo_mov am
          where am.nro_Vale  = ls_nro_Vale
            and am.flag_estado <> '0'
            and am.nro_proforma = lc_reg.nro_proforma
            and am.item_proforma  = lc_reg.nro_item;
         
         if ln_count = 0 then
            -- Busco el precio del articulo (costo), asi como su saldo en und1 y en und2
            select count(*)
              into ln_count
              from articulo_almacen aa
             where aa.almacen       = lc_reg.almacen
               and aa.cod_art       = lc_reg.cod_art;
            
            if ln_count > 0 then
               select aa.costo_prom_sol, aa.sldo_total, aa.sldo_total_und2
                 into ln_precio_unit, ln_sldo_total, ln_sldo_total_und2
                 from articulo_almacen aa
                where aa.almacen       = lc_reg.almacen
                  and aa.cod_art       = lc_reg.cod_art;
            else
               ln_precio_unit := 0;
               ln_sldo_total := 0;
               ln_sldo_total_und2 := 0;
            end if;
            
            select count(*)
              into ln_count 
              from articulo_composicion ac
             where ac.cod_art = lc_reg.cod_art;
             
            if ln_count > 0 and (ln_sldo_total < lc_reg.cantidad or ln_sldo_total_und2 < lc_reg.cantidad_und2) then
               -- Es un articulo compuesto y por lo tanto puedo hacer una salida e ingreso por transformación
               PKG_ALMACEN.sp_mov_transformacion(lc_reg.almacen,
                                                 lc_reg.cod_art,
                                                 ld_fec_registro,
                                                 lc_reg.nro_proforma,
                                                 lc_reg.nro_item,
                                                 lc_reg.cantidad,
                                                 lc_reg.cantidad_und2,
                                                 lc_reg.vendedor,
                                                 asi_usuario);
                                           
            else
               -- de lo contrario valido si tiene stock suficiente
               if ln_sldo_total < lc_reg.cantidad then
                  -- El saldo total en Und1 es mucho menor al esperado
                  RAISE_APPLICATION_ERROR(-20000, 'El Saldo Actual en Und1 no es suficiente para atender la Proforma, por favor verifique!'
                              || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                              || chr(13) || 'Cliente: ' || lc_reg.cliente
                              || chr(13) || 'Cod Art: ' || lc_reg.cod_art
                              || CHR(13) || 'Almacen: ' || lc_reg.almacen
                              || chr(13) || 'Saldo Actual : ' || trim(to_char(ln_sldo_total, '999,990.00000000'))
                              || chr(13) || 'Cant. Proforma : ' || trim(to_char(lc_reg.cantidad, '999,990.00000000'))
                              || chr(13) || 'Und1 : ' || lc_reg.und);
               end if;
               
               -- de lo contrario valido si tiene stock suficiente
               if ln_sldo_total_und2 < lc_reg.cantidad_und2 then
                  -- El saldo total en Und1 es mucho menor al esperado
                  RAISE_APPLICATION_ERROR(-20000, 'El Saldo Actual en Und1 no es suficiente para atender la Proforma, por favor verifique!'
                              || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                              || chr(13) || 'Cliente: ' || lc_reg.cliente
                              || chr(13) || 'Cod Art: ' || lc_reg.cod_art
                              || CHR(13) || 'Almacen: ' || lc_reg.almacen
                              || chr(13) || 'Saldo Actual : ' || trim(to_char(ln_sldo_total_und2, '999,990.00000000'))
                              || chr(13) || 'Cant. Proforma : ' || trim(to_char(lc_reg.cantidad_und2, '999,990.00000000'))
                              || chr(13) || 'Und2 : ' || lc_reg.und2);
               end if;
            end if;
               
            
            ls_matriz := usf_alm_matriz_contable(ls_tipo_mov, lc_reg.cencos_ingreso, 
                                                 lc_reg.cnta_prsp_vale_sal, lc_reg.sub_cat_art);
                                                 
            if lc_reg.cnta_prsp_vale_sal is null then
               RAISE_APPLICATION_ERROR(-20000, 'No se ha especificado Cuenta Presupuestal de Egreso para el ARTICULO, por favor verifique!'
                                  || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                                  || chr(13) || 'Cliente: ' || lc_reg.cliente
                                  || chr(13) || 'Item : ' || trim(to_char(lc_reg.nro_item))
                                  || chr(13) || 'Cod Art: ' || lc_reg.cod_art);
            end if;                                     
            
            -- Inserto el detalle
            insert into articulo_mov(
                   cod_origen, origen_mov_proy, nro_mov_proy, nro_vale, flag_estado, cod_art, 
                   cant_procesada, precio_unit, cod_moneda, cencos, cnta_prsp, matriz, 
                   peso_neto_tm, cant_proc_und2, nro_proforma, item_proforma, 
                   centro_benef)
            values(
                   lc_reg.cod_origen, ls_org_amp, ln_nro_amp, ls_nro_Vale, '1', lc_reg.cod_art,
                   lc_reg.cantidad, ln_precio_unit, PKG_LOGISTICA.is_soles, 
                   lc_reg.cencos_ingreso, lc_reg.cnta_prsp_vale_sal, ls_matriz,
                   0, lc_reg.cantidad_und2, lc_reg.nro_proforma, lc_reg.nro_item, 
                   lc_reg.centro_benef);
         end if;
         
         select am.cod_origen, am.nro_mov
           into ls_org_am, ln_nro_am
           from articulo_mov am
          where am.nro_Vale  = ls_nro_Vale
            and am.flag_estado <> '0'
            and am.nro_proforma = lc_reg.nro_proforma
            and am.item_proforma  = lc_reg.nro_item;
            
         ------------------------------
         -- Genero la Guia de REmisión
         ------------------------------
         select count(*)
           into ln_count
           from guia g
          where g.almacen                      = lc_reg.almacen
            and g.cod_origen                   = lc_reg.org_almacen
            and g.cliente                      = lc_reg.cliente
            and nvl(g.nom_chofer, 'XX')        = nvl(asi_nom_chofer, 'XX')
            and nvl(g.nro_placa, 'XX')         = nvl(asi_nro_placa, 'XX')
            and nvl(g.nro_brevete, 'XX')       = nvl(asi_nro_brevete, 'XX')
            and nvl(g.nro_placa_carreta, 'XX') = nvl(asi_nro_placa_carreta, 'XX')
            and trunc(g.fec_inicio_traslado)   = trunc(adi_fec_inicio_traslado)
            and nvl(g.marca_vehiculo, 'XX')    = nvl(asi_marca_vehiculo, 'XX')
            and nvl(g.motivo_traslado, 'XX')   = nvl(asi_motivo_traslado, 'XX')
            and nvl(g.obs, 'XX')               = nvl(asi_observaciones, 'XX')
            and nvl(g.prov_transp, 'XX')       = nvl(asi_prov_transp, 'XX')
            and g.zona_despacho                = lc_reg.zona_despacho;
         
         if ln_count = 0 then
            select count(*)
              into ln_count
              from num_doc_tipo n
             where n.tipo_doc   = is_doc_gr
               and n.nro_serie  = asi_serie_gr;
            
            if ln_count = 0 then
               insert into num_doc_tipo(
                      tipo_doc, ultimo_numero, nro_serie)
               values(
                      is_doc_gr, 1, asi_serie_gr);
            end if;
            
            select n.ultimo_numero
              into ln_ult_nro
              from num_doc_tipo n
             where n.tipo_doc   = is_doc_gr
               and n.nro_serie  = asi_serie_gr for update;
            
            ls_nro_gr := PKG_FACT_ELECTRONICA.of_get_nro_doc(asi_serie_gr, trim(to_char(ln_ult_nro)));
            
            update num_doc_tipo n
               set n.ultimo_numero = ln_ult_nro + 1
             where n.tipo_doc   = is_doc_gr
               and n.nro_serie  = asi_serie_gr;
            
            insert into guia(
                   cod_origen, nro_guia, almacen, fec_registro, flag_estado, motivo_traslado, cliente, 
                   destinatario, nom_chofer, nro_brevete, nro_placa, nro_placa_carreta, 
                   destino,
                   cod_usr, prov_transp, obs, fec_inicio_traslado, marca_vehiculo, 
                   cliente_final, ubigeo_dst, zona_despacho)
            values(
                   lc_reg.org_almacen, ls_nro_gr, lc_reg.almacen, sysdate, '1', asi_motivo_traslado, lc_reg.cliente,
                   lc_reg.nom_cliente, asi_nom_chofer, asi_nro_brevete, asi_nro_placa, asi_nro_placa_carreta, 
                   lc_reg.full_direccion,
                   asi_usuario, asi_prov_transp, asi_observaciones, adi_fec_inicio_traslado, asi_marca_vehiculo,
                   lc_reg.cliente, lc_reg.ubigeo, lc_reg.zona_despacho);
               
         else
             select g.nro_guia
               into ls_nro_gr
               from guia g
              where g.almacen                      = lc_reg.almacen
                and g.cod_origen                   = lc_reg.org_almacen
                and g.cliente                      = lc_reg.cliente
                and nvl(g.nom_chofer, 'XX')        = nvl(asi_nom_chofer, 'XX')
                and nvl(g.nro_placa, 'XX')         = nvl(asi_nro_placa, 'XX')
                and nvl(g.nro_brevete, 'XX')       = nvl(asi_nro_brevete, 'XX')
                and nvl(g.nro_placa_carreta, 'XX') = nvl(asi_nro_placa_carreta, 'XX')
                and trunc(g.fec_inicio_traslado)   = trunc(adi_fec_inicio_traslado)
                and nvl(g.marca_vehiculo, 'XX')    = nvl(asi_marca_vehiculo, 'XX')
                and nvl(g.motivo_traslado, 'XX')   = nvl(asi_motivo_traslado, 'XX')
                and nvl(g.obs, 'XX')               = nvl(asi_observaciones, 'XX')
                and nvl(g.prov_transp, 'XX')       = nvl(asi_prov_transp, 'XX')
                and g.zona_despacho                = lc_reg.zona_despacho; 
         end if;
         
         select count(*)
           into ln_count
           from guia_vale gv
          where gv.nro_guia = ls_nro_gr
            and gv.nro_vale = ls_nro_Vale;
         
         if ln_count = 0 then
            insert into guia_Vale(
                   Nro_Guia, Nro_Vale, Origen_Guia, Origen_Vale)
            values(
                   ls_nro_gr, ls_nro_Vale, lc_reg.org_almacen, lc_reg.org_almacen);
         end if;
           
         
         ----------------------------------
         -- Genero la factura simplificada
         ----------------------------------
         
         if substr(asi_serie_ce, 1, 1) = 'F' then
            ls_tipo_ce  := 'FAC';
         elsif substr(asi_serie_ce, 1, 1) = 'B' then  
            ls_tipo_ce := 'BVC';
         else
            RAISE_APPLICATION_ERROR(-20000, 'Serie no valido para simplificacion de comprobantes'
                                      || chr(13) || 'Serie: ' || asi_serie_ce
                                      || chr(13) || 'Nro Proforma: ' || lc_reg.nro_proforma
                                      || chr(13) || 'Cliente: ' || lc_reg.cliente
                                      || chr(13) || 'Cod.Art: ' || lc_reg.cod_art);
         end if;
         
         select count(*)
           into ln_count
           from fs_factura_simpl f,
                fs_factura_simpl_det fd
          where f.nro_registro  = fd.nro_registro
            and fd.nro_proforma = lc_reg.nro_proforma
            and f.flag_estado   <> '0';
         
         if ln_count = 0 then
            
            select count(*)
              into ln_count
              from num_doc_tipo n
             where n.tipo_doc   = ls_tipo_ce
               and n.nro_serie  = asi_serie_ce;
            
            if ln_count = 0 then
               insert into num_doc_tipo(
                      tipo_doc, ultimo_numero, nro_serie)
               values(
                      ls_tipo_ce, 1, asi_serie_ce);
            end if;
            
            select n.ultimo_numero
              into ln_ult_nro
              from num_doc_tipo n
             where n.tipo_doc   = ls_tipo_ce
               and n.nro_serie  = asi_serie_ce for update;
            
            ls_nro_doc := PKG_FACT_ELECTRONICA.of_get_nro_doc(ls_tipo_ce, trim(to_char(ln_ult_nro)));
            ls_nro_cxc := trim(to_char(ln_ult_nro));
            
            update num_doc_tipo n
               set n.ultimo_numero = ln_ult_nro + 1
             where n.tipo_doc   = ls_tipo_ce
               and n.nro_serie  = asi_serie_ce;
            
            -- Nro de registro
            ls_tabla := 'fs_factura_simpl';
            
            select count(*)
              into ln_count
              from num_tablas t
             where t.tabla  = ls_tabla
               and t.origen = ls_org_vm;
            
            if ln_count = 0 then
               insert into num_tablas(
                      tabla, origen, ult_nro)
               values(
                      ls_tabla, ls_org_vm, 1);
            end if;
               
                
            select t.ult_nro
              into ln_ult_nro
              from num_tablas t
             where t.tabla  = ls_tabla
               and t.origen = ls_org_vm for update;
               
            ls_nro_registro := trim(ls_org_vm) || trim(to_char(ln_ult_nro, '00000000'));
                
            update num_tablas n
               set n.ult_nro = ln_ult_nro + 1
             where n.tabla  = ls_tabla
               and n.origen = ls_org_vm;
            
            ln_tasa_cambio := usf_fin_tasa_cambio(adi_fec_inicio_traslado);
            
            select count(*)
              into ln_count
              from puntos_venta pv
             where pv.cod_origen = lc_reg.cod_origen;
            
            if ln_count = 0 then
               RAISE_APPLICATION_ERROR(-20000, 'El Origen ' || lc_reg.cod_origen || ' no tiene asignado un punto de Venta, por favor verifique!');
            end if;
            
            select max(pv.punto_venta)
              into ls_punto_venta
              from puntos_venta pv
             where pv.cod_origen = lc_reg.cod_origen;
            
            insert into fs_factura_simpl(
                   nro_registro, cod_origen, fec_registro, fec_movimiento, cliente, 
                   cod_moneda, tasa_cambio,
                   punto_venta, cod_usr, serie_cxc, vendedor, observacion, flag_estado, 
                   tipo_doc_cxc, nro_cxc, item_direccion)
            values(
                   ls_nro_registro, lc_reg.cod_origen, sysdate, adi_fec_inicio_traslado, lc_reg.cliente,
                   lc_reg.cod_moneda, ln_tasa_cambio, 
                   ls_punto_venta, asi_usuario, asi_serie_ce, lc_reg.vendedor, asi_observaciones, '1',
                   ls_tipo_ce, ls_nro_cxc, lc_reg.item_direccion);

         else
            select distinct
                   f.nro_registro
              into ls_nro_registro
              from fs_factura_simpl f,
                   fs_factura_simpl_det fd
             where f.nro_registro  = fd.nro_registro
               and fd.nro_proforma = lc_reg.nro_proforma
               and f.flag_estado   <> '0';  
         end if;
         
         -- Detalle de la factura simplificada
         select count(*)
           into ln_count
           from fs_factura_simpl_det fd
          where fd.nro_registro  = ls_nro_registro
            and fd.nro_proforma  = lc_reg.nro_proforma
            and fd.item_proforma = lc_reg.nro_item;
         
         if ln_count = 0 then
            select nvl(max(fd.nro_item), 0)
              into ln_nro_item
              from fs_factura_simpl_det fd
             where fd.nro_registro  = ls_nro_registro
               and fd.nro_proforma  = lc_reg.nro_proforma;
            
            ln_nro_item := ln_nro_item + 1;
            
            if lc_reg.igv > 0 then
               ls_flag_afecto_igv := '1';
               ln_porc_igv := 18.00;
            else
               ls_flag_afecto_igv := '2';
               ln_porc_igv := 0.00;
            end if;
            
            insert into fs_factura_simpl_det(
                   nro_registro, nro_item, cod_art, cant_proyect, precio_unit, importe_igv, 
                   prov_transporte, nro_placa, nro_placa_carreta, nom_chofer, nro_brevete, 
                   cert_insc_mtc, marca_vehiculo, org_guia, nro_guia, org_vale, nro_vale, 
                   nro_proforma, item_proforma, org_am, nro_am, fec_registro,almacen, 
                   descripcion,
                   flag_afecto_igv, importe_impuesto, flag_bolsa_plastica, icbper, porc_igv, 
                   cant_proyect_und2, flag_estado, cod_usr)
            values(
                  ls_nro_registro, ln_nro_item, lc_reg.cod_art, lc_reg.cantidad, lc_reg.precio_vta, lc_reg.igv,
                  asi_prov_transp, asi_nro_placa, asi_nro_placa_carreta, asi_nom_chofer, asi_nro_brevete,
                  asi_cert_insc_mtc, asi_marca_vehiculo, lc_reg.org_almacen, ls_nro_gr, lc_reg.org_almacen, ls_nro_Vale,
                  lc_reg.nro_proforma, lc_reg.nro_item, ls_org_am, ln_nro_am, sysdate, lc_reg.almacen, 
                  lc_reg.descripcion,
                  ls_flag_afecto_igv, 0.00, '0', 0.00, ln_porc_igv,
                  lc_reg.cantidad_und2, '1', asi_usuario);
                   
         end if;
         
         -- Obtengo el monto de la factura simplificada
         select nvl(sum(fd.cant_proyect * (fd.precio_unit + fd.importe_igv)), 0)
           into ln_monto
           from fs_factura_simpl_det fd
          where fd.nro_registro = ls_nro_registro;
          
         -- Detalle de la forma de pago
         select count(*)
           into ln_count
           from fs_factura_simpl_pagos fp
          where fp.nro_registro  = ls_nro_registro;
        
         if ln_count = 0 then
            insert into fs_factura_simpl_pagos(
                   nro_registro, monto, monto_pago, fec_registro, flag_forma_pago, cod_usr,
                   factor, nro_cuotas, flag_tipo_credito, porc_interes, nro_item, primer_vencimiento)
            values(
                   ls_nro_registro, ln_monto, ln_monto, sysdate, 'C', asi_usuario,
                   1, 1, '1', 0.00, 1, trunc(adi_fec_inicio_traslado));
         else
            update fs_factura_simpl_pagos fp
               set fp.monto  = ln_monto,
                   fp.monto_pago = ln_monto
             where fp.nro_registro = ls_nro_registro;
         end if;
            
     end loop;
  end ;
  
  -- Anular la proforma
  ----------------------------------------------------------------------------
  procedure sp_anular_proforma(
     asi_nro_proforma        in proforma.nro_proforma%TYPE
  ) is
    ln_result number;
  begin
    select nvl(sum(am.cant_procesada),0)
      into ln_result
      from vale_mov     vm,
           articulo_mov am,
           proforma_det pd,
           proforma     p
     where vm.nro_Vale = am.nro_vale
       and am.nro_proforma = pd.nro_proforma
       and am.item_proforma  = pd.nro_item
       and pd.nro_proforma   = p.nro_proforma
       and vm.flag_estado    <> '0'
       and am.flag_estado    <> '0'
       and p.flag_estado     <> '0'
       and p.nro_proforma    = asi_nro_proforma;
    
    if ln_result > 0 then
       RAISE_APPLICATION_ERROR(-20000, 'La proforma ' || asi_nro_proforma || ' tiene movimientos de almacen, no se puede ANULAR');
    end if;   
    
    select nvl(sum(fd.cant_proyect),0)
      into ln_result
      from fs_factura_simpl f,
           fs_factura_simpl_det fd,
           proforma_det         pd,
           proforma             p
     where f.nro_registro    = fd.nro_registro
       and fd.nro_proforma   = pd.nro_proforma
       and fd.item_proforma  = pd.nro_item
       and f.flag_estado     <> '0'
       and p.flag_estado     <> '0'
       and p.nro_proforma    = asi_nro_proforma;
    
    if ln_result > 0 then
       RAISE_APPLICATION_ERROR(-20000, 'La proforma ' || asi_nro_proforma || ' tiene facturación Simplificada realizada, no se puede ANULAR');
    end if;
        
    update proforma_det pd
       set pd.cantidad  = 0,
           pd.precio_vta = 0,
           pd.igv        = 0,
           pd.icbper     = 0
     where pd.nro_proforma = asi_nro_proforma;
   
    update proforma p
       set p.flag_estado = '0'
     where p.nro_proforma = asi_nro_proforma; 
    
    commit;
  end;
  
begin
  -- Initialization
  is_grp_mercaderia        := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_CNTBL_MERCADERIA', '20');
  is_matriz_VS000          := PKG_CONFIG.USF_GET_PARAMETER('MATRIZ_CNTBL_VS-000', 'VS-000');
  is_ncc_devol_total       := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_NCC_DEVOL_TOTAL', 'NCC02');
  is_ncc_devol_parcial     := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_NCC_DEVOL_PARCIAL', 'NCC05');
  is_cntbl_cnta_vd         := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_VALES_DSCTO', '12104101');
  IS_DOC_VALE_DCSTO        := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_DOC_VALE_DCSTO', 'VD');
  is_banco_caja            := PKG_CONFIG.USF_GET_PARAMETER('FIN_COD_BANCO_CAJA', '001');
  
  is_cc_efectivo_mn        := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_EFECTIVO_MN', '10101101');
  is_cc_efectivo_me        := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_EFECTIVO_ME', '10101102');
  is_cc_tarjeta_visa       := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_TARJETA_VISA', '10301101');
  is_cc_tarjeta_mast       := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_TARJETA_MASTERCARD', '10301102');
  is_cc_tarjeta_din_club   := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_TARJETA_DINNERS', '10301104');
  is_cc_tarjeta_estilos    := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_TARJETA_ESTILOS', '10301105');
  is_cc_tarjeta_american   := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_TARJETA_AMERICAN', '10301103');
  is_cc_igv_gasto          := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_IGV_GASTO', '94401101');
  is_cc_dscto_institucion  := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_DSCTO_INSTITUCION', '12102102');
  
  -- Cuentas Contables para la consignacion
  is_cc_consig_mn          := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_CONSIGNACION_MN', '12102103');
  is_cc_consig_mn          := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_CONSIGNACION_ME', '12102103');

  -- Cuentas Contables para las letras
  is_cc_ltc_mn             := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_LETRAS_CXC_MN', '12301101');
  is_cc_ltc_me             := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_CNTA_LETRAS_CXC_ME', '12301102');

  is_doc_efectivo          := PKG_CONFIG.USF_GET_PARAMETER('FIN_DOC_EFECTIVO', 'EFE');
  is_doc_tarjeta           := PKG_CONFIG.USF_GET_PARAMETER('FIN_DOC_TARJETA', 'TAR');
  
  il_libro_prov_vd         := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_LIBRO_PROVISION_VALE_DSCTO', '87');
  
  select l.doc_ov, l.doc_gr
    into is_doc_ov, is_doc_gr
    from logparam l
   where l.reckey = '1';
  il_libro_prov_aplic      := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_LIBRO_PROVSION_APLICACIONES', '6');
  il_libro_caja_egr        := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_LIBRO_CAJA_EGRESO', '2');
  il_libro_caja_ing        := PKG_CONFIG.USF_GET_PARAMETER('CNTBL_LIBRO_CAJA_INGRESO', '1');
  is_confin_FI001          := PKG_CONFIG.USF_GET_PARAMETER('FIN_CONFIN_FI-001', 'FI-001');
  is_doc_ncnc              := PKG_CONFIG.USF_GET_PARAMETER('DOC_NOTA_CONTABILIDAD_COBRAR', 'NCNC');
  is_fp_F30d               := PKG_CONFIG.USF_GET_PARAMETER('FIN_FORMA_PAGO_F30_DIAS', 'F30');
  
  -- Matrices contables por defecto
  is_matriz_int_sol        := PKG_CONFIG.USF_GET_PARAMETER('MATRIZ_INTERES_SOL', 'CC-085');
  is_matriz_int_dol        := PKG_CONFIG.USF_GET_PARAMETER('MATRIZ_INTERES_DOL', 'CC-086');
  
  -- Servicios por defecto
  is_serv_interes          := PKG_CONFIG.USF_GET_PARAMETER('SERVICIO_CXC_INTERES', '005');
  is_Serie_bvc_int         := PKG_CONFIG.USF_GET_PARAMETER('SERIE_BVC_INTERES', 'BI01');
  is_Serie_fvc_int         := PKG_CONFIG.USF_GET_PARAMETER('SERIE_FVC_INTERES', 'FI01');

  -- Impuesto por consumo de bolsa plastica
  is_icbper                := PKG_CONFIG.USF_GET_PARAMETER('IMPUESTO_ICBPER', 'ICBPE');
  
  -- Documento PROFORMA
  is_doc_prof              := PKG_CONFIG.USF_GET_PARAMETER('DOC_PROFORMA', 'PROF');
    
  select f.libro_ventas, f.pago_contado, f.libro_cobranzas, f.libro_pagos, f.doc_letra_cobrar
    into il_libro_ventas, is_fp_pcon, il_libro_cobranzas, il_libro_pagos, is_doc_ltc
    from finparam f
   where f.reckey = '1';
  
  

  
end pkg_fact_electronica;
/

prompt
prompt Creating package body PKG_LOGISTICA
prompt ===================================
prompt
create or replace package body cantabria.PKG_LOGISTICA is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;
  
  -- Funciones para Programa de Compras
  function of_get_nro_OT(
       asi_nro_programa    in prog_compras_det.nro_programa%TYPE,
       ani_nro_item        in prog_compras_det.nro_item%TYPE
  ) return varchar2 is
    ln_Result varchar2(10);
  begin

    select min(op.nro_orden)
      into ln_Result
      from articulo_mov_proy amp,
           prog_compras_det  pcd,
           operaciones       op
     where pcd.org_amp_ot_ref   = amp.cod_origen
       and pcd.nro_amp_ot_ref   = amp.nro_mov
       and amp.oper_sec         = op.oper_sec
       and pcd.nro_programa     = asi_nro_programa
       and pcd.nro_item         = ani_nro_item;

    return(ln_Result);
  end of_get_nro_OT;

  -- Function and procedure implementations
  function of_dolares(
    asi_nada varchar2
  ) return varchar2 is
  
  begin
    return is_dolares;
  end;
  
  function of_euros(
    asi_nada varchar2
  ) return varchar2 is
  
  begin
    return is_euros;
  end;

  function of_soles(
    asi_nada varchar2
  ) return varchar2 is
  
  begin
    return is_soles;
  end;
  
  function of_doc_oc(
    asi_nada varchar2
  ) return varchar2 is
  
  begin
    return is_doc_oc;
  end;

  function of_get_urbanizacion(
    as_proveedor proveedor.proveedor%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_DIR_URBANIZACION  direcciones.dir_urbanizacion%TYPE;   

  begin
    
    select count(*)
      into ln_count
      from direcciones d
     where d.codigo = as_proveedor
       and d.flag_uso in ('1', '3');
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select dir_urbanizacion
         into ls_dir_urbanizacion
         from direcciones d
        where codigo = as_proveedor
          and d.flag_uso in ('1', '3')
          and rownum = 1
       order by d.item;
       
       -- Urbanizacion
       if ls_dir_urbanizacion is not null and length(trim(ls_dir_urbanizacion)) > 0 then
          ls_direccion := ' URB. ' || trim(ls_dir_urbanizacion);
       end if;

    end if;
    
    return upper(ls_direccion);
  end;

  function of_get_distrito(
    as_proveedor proveedor.proveedor%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_DIR_DISTRITO  direcciones.dir_distrito%TYPE;   

  begin
    
    select count(*)
      into ln_count
      from direcciones d
     where d.codigo = as_proveedor
       and d.flag_uso in ('1', '3');
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select dir_distrito
         into ls_DIR_DISTRITO
         from direcciones d
        where codigo = as_proveedor
          and d.flag_uso in ('1', '3')
          and rownum = 1
       order by d.item;
       
       if ls_DIR_DISTRITO is not null and length(trim(ls_DIR_DISTRITO)) > 0 then
          ls_direccion := trim(ls_DIR_DISTRITO);
       end if;

    end if;
    
    return upper(ls_direccion);
  end;

  function of_get_provincia(
    as_proveedor proveedor.proveedor%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_DIR_PROVINCIA  direcciones.dir_provincia%TYPE;   

  begin
    
    select count(*)
      into ln_count
      from direcciones d
     where d.codigo = as_proveedor
       and d.flag_uso in ('1', '3');
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select dir_provincia
         into ls_DIR_PROVINCIA
         from direcciones d
        where codigo = as_proveedor
          and d.flag_uso in ('1', '3')
          and rownum = 1
       order by d.item;
       
       if ls_DIR_PROVINCIA is not null and length(trim(ls_DIR_PROVINCIA)) > 0 then
          ls_direccion := trim(ls_DIR_PROVINCIA);
       end if;

    end if;
    
    return upper(ls_direccion);
  end;

  function of_get_departamento(
    as_proveedor proveedor.proveedor%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_DIR_DEPARTAMENTO  direcciones.dir_dep_estado%TYPE;   

  begin
    
    select count(*)
      into ln_count
      from direcciones d
     where d.codigo = as_proveedor
       and d.flag_uso in ('1', '3');
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select dir_dep_estado
         into ls_DIR_DEPARTAMENTO
         from direcciones d
        where codigo = as_proveedor
          and d.flag_uso in ('1', '3')
          and rownum = 1
       order by d.item;
       
       if ls_DIR_DEPARTAMENTO is not null and length(trim(ls_DIR_DEPARTAMENTO)) > 0 then
          ls_direccion := trim(ls_DIR_DEPARTAMENTO);
       end if;

    end if;
    
    return upper(ls_direccion);
  end;

  function of_get_pais(
    as_proveedor proveedor.proveedor%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_DIR_PAIS     direcciones.DIR_PAIS%TYPE;   

  begin
    
    select count(*)
      into ln_count
      from direcciones d
     where d.codigo = as_proveedor
       and d.flag_uso in ('1', '3');
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select DIR_SIGLAS_PAIS
         into ls_DIR_PAIS
         from direcciones d
        where codigo = as_proveedor
          and d.flag_uso in ('1', '3')
          and rownum = 1
       order by d.item;
       
       if ls_DIR_PAIS is not null and length(trim(ls_DIR_PAIS)) > 0 then
          ls_direccion := trim(ls_DIR_PAIS);
       end if;

    end if;
    
    return upper(ls_direccion);
  end;

  function of_get_dir_comercial(
    as_proveedor proveedor.proveedor%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_dir_pais          direcciones.dir_pais%TYPE;
    ls_DIR_DEP_ESTADO    direcciones.dir_dep_estado%TYPE;
    ls_DIR_PROVINCIA     direcciones.dir_provincia%TYPE;
    ls_DIR_CIUDAD        direcciones.dir_ciudad%TYPE;         
    ls_DIR_DISTRITO      direcciones.dir_distrito%TYPE;       
    ls_DIR_URBANIZACION  direcciones.dir_urbanizacion%TYPE;   
    ls_DIR_DIRECCION     direcciones.dir_direccion%TYPE;      
    ls_DIR_MNZ           direcciones.dir_mnz%TYPE;            
    ls_DIR_LOTE          direcciones.dir_lote%TYPE;           
    ls_DIR_NUMERO        direcciones.dir_numero%TYPE;         
    ls_DIR_COD_POSTAL    direcciones.dir_cod_postal%TYPE;     
    ls_DIR_DIRECCION2    direcciones.dir_direccion2%TYPE;                                   
    ls_DIR_REFERENCIA    direcciones.dir_referencia%TYPE;                                   
    ls_DIR_INTERIOR      direcciones.dir_interior%TYPE;                                   

  begin
    
    select count(*)
      into ln_count
      from direcciones d
     where d.codigo = as_proveedor
       and d.flag_uso in ('1', '3');
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select dir_pais, dir_dep_estado, dir_provincia, dir_ciudad, dir_distrito, dir_urbanizacion, dir_direccion, 
              dir_mnz, dir_lote, dir_mnz, dir_numero, dir_cod_postal, dir_direccion2, dir_referencia, dir_interior
         into ls_dir_pais, ls_dir_dep_estado, ls_dir_provincia, ls_dir_ciudad, ls_dir_distrito, ls_dir_urbanizacion, ls_dir_direccion, 
              ls_dir_mnz, ls_dir_lote, ls_dir_mnz, ls_dir_numero, ls_dir_cod_postal, ls_dir_direccion2, ls_dir_referencia, ls_dir_interior
         from direcciones d
        where codigo = as_proveedor
          and d.flag_uso in ('1', '3')
          and rownum = 1
       order by d.item;
       
       ls_direccion := '';
       if ls_DIR_DIRECCION is not null and length(trim(ls_DIR_DIRECCION)) > 0 then
          ls_direccion := trim(ls_direccion) || trim(ls_dir_direccion);
       end if;
       
       -- Numero
       if ls_dir_numero is not null and length(trim(ls_dir_numero)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Nro. ' || trim(ls_dir_numero);
       end if;

       -- Interior
       if ls_dir_interior is not null and length(trim(ls_dir_interior)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Int. ' || trim(ls_dir_interior);
       end if;

       -- Urbanizacion
       if ls_dir_urbanizacion is not null and length(trim(ls_dir_urbanizacion)) > 0 then
          ls_direccion := trim(ls_direccion) || ' URB. ' || trim(ls_dir_urbanizacion);
       end if;

       -- Manzana
       if ls_dir_mnz is not null and length(trim(ls_dir_mnz)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Mza. ' || trim(ls_dir_mnz);
       end if;

       -- Lote
       if ls_DIR_LOTE is not null and length(trim(ls_DIR_LOTE)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Lt. ' || trim(ls_DIR_LOTE);
       end if;

       -- Referencia
       if ls_dir_referencia is not null and length(trim(ls_dir_referencia)) > 0 then
          ls_direccion := trim(ls_direccion) || ' (Ref. ' || trim(ls_dir_referencia) || ')';
       end if;

       -- Cod. Postal
       if ls_dir_cod_postal is not null and length(trim(ls_dir_cod_postal)) > 0 then
          ls_direccion := trim(ls_direccion) || ' [';
         if ls_dir_dep_estado is not null and length(trim(ls_dir_dep_estado)) > 0 then
            ls_direccion := trim(ls_direccion) || trim(ls_dir_dep_estado) || ' ' ;
         end if;
          ls_direccion := trim(ls_direccion) || trim(ls_dir_cod_postal) || ']';
       end if;

       -- Ciudad
       if ls_dir_ciudad is not null and length(trim(ls_dir_ciudad)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_ciudad);
       end if;
       
       -- Distrito
       if ls_dir_distrito is not null and length(trim(ls_dir_distrito)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' ||  trim(ls_dir_distrito);
       end if;
       
       -- Provincia
       if ls_dir_provincia is not null and length(trim(ls_dir_provincia)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_provincia);
       end if;
       
       -- Departamento / Estado
       if ls_dir_dep_estado is not null and length(trim(ls_dir_dep_estado)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_dep_estado);
       end if;

       -- Pais
       if ls_dir_pais is not null and length(trim(ls_dir_pais)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_pais);
       end if;
    end if;
    
    return upper(ls_direccion);
  end;

  function of_get_direccion(
    as_proveedor proveedor.proveedor%TYPE,
    an_item     direcciones.item%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_dir_pais          direcciones.dir_pais%TYPE;
    ls_DIR_DEP_ESTADO    direcciones.dir_dep_estado%TYPE;
    ls_DIR_PROVINCIA     direcciones.dir_provincia%TYPE;
    ls_DIR_CIUDAD        direcciones.dir_ciudad%TYPE;         
    ls_DIR_DISTRITO      direcciones.dir_distrito%TYPE;       
    ls_DIR_URBANIZACION  direcciones.dir_urbanizacion%TYPE;   
    ls_DIR_DIRECCION     direcciones.dir_direccion%TYPE;      
    ls_DIR_MNZ           direcciones.dir_mnz%TYPE;            
    ls_DIR_LOTE          direcciones.dir_lote%TYPE;           
    ls_DIR_NUMERO        direcciones.dir_numero%TYPE;         
    ls_DIR_COD_POSTAL    direcciones.dir_cod_postal%TYPE;     
    ls_DIR_DIRECCION2    direcciones.dir_direccion2%TYPE;                                   
    ls_DIR_REFERENCIA    direcciones.dir_referencia%TYPE;                                   
    ls_DIR_INTERIOR      direcciones.dir_interior%TYPE;                                   

  begin
    
    select count(*)
      into ln_count
      from direcciones d
     where d.codigo = as_proveedor
       and d.item   = an_item;
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select dir_pais, dir_dep_estado, dir_provincia, dir_ciudad, dir_distrito, dir_urbanizacion, dir_direccion, 
              dir_mnz, dir_lote, dir_mnz, dir_numero, dir_cod_postal, dir_direccion2, dir_referencia, dir_interior
         into ls_dir_pais, ls_dir_dep_estado, ls_dir_provincia, ls_dir_ciudad, ls_dir_distrito, ls_dir_urbanizacion, ls_dir_direccion, 
              ls_dir_mnz, ls_dir_lote, ls_dir_mnz, ls_dir_numero, ls_dir_cod_postal, ls_dir_direccion2, ls_dir_referencia, ls_dir_interior
         from direcciones d
        where codigo = as_proveedor
          and d.item   = an_item;
       
       ls_direccion := '';
       if ls_DIR_DIRECCION is not null and length(trim(ls_DIR_DIRECCION)) > 0 then
          ls_direccion := trim(ls_direccion) || trim(ls_dir_direccion);
       end if;
       
       -- Numero
       if ls_dir_numero is not null and length(trim(ls_dir_numero)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Nro. ' || trim(ls_dir_numero);
       end if;

       -- Interior
       if ls_dir_interior is not null and length(trim(ls_dir_interior)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Int. ' || trim(ls_dir_interior);
       end if;

       -- Urbanizacion
       if ls_dir_urbanizacion is not null and length(trim(ls_dir_urbanizacion)) > 0 then
          ls_direccion := trim(ls_direccion) || ' URB. ' || trim(ls_dir_urbanizacion);
       end if;

       -- Manzana
       if ls_dir_mnz is not null and length(trim(ls_dir_mnz)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Mza. ' || trim(ls_dir_mnz);
       end if;

       -- Lote
       if ls_dir_lote is not null and length(trim(ls_dir_lote)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Lt. ' || trim(ls_dir_lote);
       end if;

       -- Cod. Postal
       if ls_dir_cod_postal is not null and length(trim(ls_dir_cod_postal)) > 0 then
          ls_direccion := trim(ls_direccion) || ' [';
         if ls_dir_dep_estado is not null and length(trim(ls_dir_dep_estado)) > 0 then
            ls_direccion := trim(ls_direccion) || trim(ls_dir_dep_estado) || ' ' ;
         end if;
          ls_direccion := ls_direccion || trim(ls_dir_cod_postal) || ']';
       end if;

       -- Ciudad
       if ls_dir_ciudad is not null and length(trim(ls_dir_ciudad)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_ciudad);
       end if;
       
       -- Distrito
       if ls_dir_distrito is not null and length(trim(ls_dir_distrito)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' ||  trim(ls_dir_distrito);
       end if;
       
       -- Provincia
       if ls_dir_provincia is not null and length(trim(ls_dir_provincia)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_provincia);
       end if;
       
       -- Departamento / Estado
       if ls_dir_dep_estado is not null and length(trim(ls_dir_dep_estado)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_dep_estado);
       end if;

       -- Pais
       if ls_dir_pais is not null and length(trim(ls_dir_pais)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_pais);
       end if;
    end if;
    
    return upper(ls_direccion);
  end;

  function of_get_direccion(
    asi_origen origen.cod_origen%TYPE
  ) return varchar2 is
  
    ln_count        number;
    ls_direccion    varchar2(3000);
    
    ls_DIR_DEPARTAMENTO  origen.dir_departamento%TYPE;
    ls_DIR_PROVINCIA     origen.dir_provincia%TYPE;
    ls_DIR_DISTRITO      origen.dir_distrito%TYPE;       
    ls_DIR_URBANIZACION  origen.dir_urbanizacion%TYPE;   
    ls_DIR_DIRECCION     origen.dir_calle%TYPE;      
    ls_DIR_MNZ           origen.dir_mnz%TYPE;            
    ls_DIR_LOTE          origen.dir_lote%TYPE;           
    ls_DIR_NUMERO        origen.dir_numero%TYPE;         
    ls_DIR_COD_POSTAL    origen.dir_cod_postal%TYPE;     

  begin
    
    select count(*)
      into ln_count
      from origen o
     where o.cod_origen = asi_origen;
    
    if ln_count = 0 then
       ls_direccion := null;
    else
       select dir_departamento, dir_provincia, dir_distrito, dir_urbanizacion, dir_calle, 
              dir_mnz,          dir_lote,      dir_numero,   dir_cod_postal   
         into ls_DIR_DEPARTAMENTO, ls_DIR_PROVINCIA, ls_DIR_DISTRITO, ls_DIR_URBANIZACION, ls_DIR_DIRECCION, 
              ls_DIR_MNZ         , ls_DIR_LOTE     , ls_DIR_NUMERO  , ls_DIR_COD_POSTAL
         from origen o
        where o.cod_origen = asi_origen;
       
       ls_direccion := '';
       if ls_DIR_DIRECCION is not null and length(trim(ls_DIR_DIRECCION)) > 0 then
          ls_direccion := trim(ls_direccion) || trim(ls_dir_direccion);
       end if;
       
       -- Numero
       if ls_dir_numero is not null and length(trim(ls_dir_numero)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Nro. ' || trim(ls_dir_numero);
       end if;

       -- Urbanizacion
       if ls_dir_urbanizacion is not null and length(trim(ls_dir_urbanizacion)) > 0 then
          ls_direccion := trim(ls_direccion) || ' URB. ' || trim(ls_dir_urbanizacion);
       end if;

       -- Manzana
       if ls_dir_mnz is not null and length(trim(ls_dir_mnz)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Mza. ' || trim(ls_dir_mnz);
       end if;

       -- Lote
       if ls_dir_lote is not null and length(trim(ls_dir_lote)) > 0 then
          ls_direccion := trim(ls_direccion) || ' Lt. ' || trim(ls_dir_lote);
       end if;

       -- Cod. Postal
       if ls_dir_cod_postal is not null and length(trim(ls_dir_cod_postal)) > 0 then
          ls_direccion := trim(ls_direccion) || ' [';
         if ls_DIR_DEPARTAMENTO is not null and length(trim(ls_DIR_DEPARTAMENTO)) > 0 then
            ls_direccion := trim(ls_direccion) || trim(ls_DIR_DEPARTAMENTO) || ' ' ;
         end if;
          ls_direccion := ls_direccion || trim(ls_dir_cod_postal) || ']';
       end if;

       -- Distrito
       if ls_dir_distrito is not null and length(trim(ls_dir_distrito)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' ||  trim(ls_dir_distrito);
       end if;
       
       -- Provincia
       if ls_dir_provincia is not null and length(trim(ls_dir_provincia)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_dir_provincia);
       end if;
       
       -- Departamento / Estado
       if ls_DIR_DEPARTAMENTO is not null and length(trim(ls_DIR_DEPARTAMENTO)) > 0 then
          ls_direccion := trim(ls_direccion) || ' - ' || trim(ls_DIR_DEPARTAMENTO);
       end if;
    end if;
    
    return upper(ls_direccion);
  end;

  function of_tasa_cambio_euros(
      adi_fecha in date
  ) return number is
    ln_count  number;
    ln_result number;
  begin
    select count(*) 
      into ln_count
      from calendario c
     where trunc(c.fecha) = trunc(adi_fecha);
    
    if ln_count > 1 then
       RAISE_APPLICATION_ERROR(-20000, 'Existe mas de un registro en Tipo de Cambio para la fecha ' || to_char(adi_Fecha, 'dd/mm/yyyy'));
    end if;
    
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No Existe registros en Tipo de Cambio para la fecha ' || to_char(adi_Fecha, 'dd/mm/yyyy'));
    end if;
    
    select NVL(c.vta_eur_bnc,0)
      into ln_result
      from calendario c
     where trunc(c.fecha) = trunc(adi_fecha);
    
    -- Si no hay tipo de cambio para esa fecha entonces envio un mensaje de error
    if ln_result = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No ha ingresado un Tipo de Cambio para el EURO en la fecha ' || to_char(adi_Fecha, 'dd/mm/yyyy'));
    end if;
    
    
    return ln_result;
  end of_tasa_cambio_euros;
  
  
  -- Para reportes de almacen
  function of_cant_ingresada_periodo(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number is
  
    ln_cantidad     number;
  begin
    
    select nvl(abs(sum(am.cant_procesada * amt.factor_sldo_total )),0)
      into ln_cantidad
      from vale_mov vm,
           articulo_mov am,
           articulo_mov_tipo amt
     where vm.nro_Vale = am.nro_vale
       and vm.tipo_mov = amt.tipo_mov
       and am.origen_mov_proy = asi_org_amp
       and am.nro_mov_proy    = ani_nro_amp
       and vm.flag_estado     <> '0'
       and am.flag_estado     <> '0'
       and to_number(to_char(vm.fec_registro, 'yyyy')) = ani_year
       and to_number(to_char(vm.fec_registro, 'mm'))   = ani_mes;
       
    
    return ln_cantidad;
    
  end;
  
  function of_importe_ingreso(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number is
  
    ln_cantidad     number;
  begin
    
    select nvl(abs(sum(am.cant_procesada * am.precio_unit * amt.factor_sldo_total )),0)
      into ln_cantidad
      from vale_mov vm,
           articulo_mov am,
           articulo_mov_tipo amt
     where vm.nro_Vale = am.nro_vale
       and vm.tipo_mov = amt.tipo_mov
       and am.origen_mov_proy = asi_org_amp
       and am.nro_mov_proy    = ani_nro_amp
       and vm.flag_estado     <> '0'
       and am.flag_estado     <> '0'
       and to_number(to_char(vm.fec_registro, 'yyyy')) = ani_year
       and to_number(to_char(vm.fec_registro, 'mm'))   = ani_mes;
       
    
    return ln_cantidad;
    
  end;

  function of_cant_provision_periodo(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number is
  
    ln_cantidad     number;
  begin
    
    select nvl(abs(sum(cpd.cantidad)),0)
      into ln_cantidad
      from cntas_pagar cp,
           cntas_pagar_det cpd
     where cp.cod_relacion = cpd.cod_relacion
       and cp.tipo_doc     = cpd.tipo_doc
       and cp.nro_doc      = cpd.nro_doc
       and cp.flag_estado  <> '0'
       and cpd.org_amp_ref = asi_org_amp
       and cpd.nro_amp_ref = ani_nro_amp
       and cp.ano          = ani_year
       and cp.mes          = ani_mes;
    
    return ln_cantidad;
    
  end;

  function of_importe_provision(
       asi_org_amp in articulo_mov_proy.cod_origen%TYPE,
       ani_nro_amp in articulo_mov_proy.nro_mov%TYPE,
       ani_year    in number,
       ani_mes     in number
  ) return number is
  
    ln_cantidad     number;
  begin
    
    select nvl(abs(sum(cpd.importe)),0)
      into ln_cantidad
      from cntas_pagar cp,
           cntas_pagar_det cpd
     where cp.cod_relacion = cpd.cod_relacion
       and cp.tipo_doc     = cpd.tipo_doc
       and cp.nro_doc      = cpd.nro_doc
       and cp.flag_estado  <> '0'
       and cpd.org_amp_ref = asi_org_amp
       and cpd.nro_amp_ref = ani_nro_amp
       and cp.ano          = ani_year
       and cp.mes          = ani_mes;
    
    return ln_cantidad;
    
  end;

begin
  select cod_soles, cod_dolares, l.oper_cons_interno, l.oper_ing_oc, l.oper_ing_prod, l.doc_oc, l.oper_vnta_terc,
         l.oper_vnta_mat, l.cod_igv
    into is_soles, is_dolares, is_oper_cons_int, is_oper_ing_oc, is_oper_ing_prod, is_doc_oc, is_oper_vnta_terc,
         is_oper_vnta_mat, is_igv
    from logparam l
   where l.reckey = '1';
  
  is_euros := pkg_config.USF_GET_PARAMETER('MONEDA_EUROS', 'EU');
  is_oper_vnta_nac_sinov := pkg_config.USF_GET_PARAMETER('ALMACEN_VENTA_NACIONAL_SIN_OV', 'S48');
  is_prsp_cnta_vta_mp := pkg_config.USF_GET_PARAMETER('PRSP_CNTA_VTA_MAT_PRIMA', 'SERCOME026');
  
  
end PKG_LOGISTICA;
/

prompt
prompt Creating package body PKG_PRODUCCION
prompt ====================================
prompt
create or replace package body cantabria.PKG_PRODUCCION is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;
  
  -- Obtiene el tipo de documento OT
  function of_doc_ot(
    asi_nada varchar2
  ) return varchar2 is
  
  begin
    return is_doc_ot;
  end;
  
  function of_oper_ing_prod(
    asi_nada varchar2
  ) return varchar2 is
  
  begin
    return is_oper_ing_prod;
  end;
  
  function of_ing_mp_propia(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo     a,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and am.cod_Art  = a.cod_art
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and trim(am.cod_art)   in (select trim(column_value)
                                 from table(split(PKG_CONFIG.USF_GET_PARAMETER('COD_ARTICULO_PESCA_PROPIA', '016001.0002'))))
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and vm.tipo_mov      = 'I09'
      and al.flag_tipo_almacen = 'P'
      and am.cod_Art           in (select distinct amp.cod_art
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and vm.almacen           in (select distinct amp.almacen
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;

  function of_ing_mp_tercero(adi_fecha date, 
                             asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo     a,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and am.cod_Art  = a.cod_art
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and trim(am.cod_art)   not in (select trim(column_value)
                                       from table(split(PKG_CONFIG.USF_GET_PARAMETER('COD_ARTICULO_PESCA_PROPIA', '016001.0002'))))
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = 1
      and al.flag_tipo_almacen = 'P'
      and am.cod_Art           in (select distinct amp.cod_art
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and vm.almacen           in (select distinct amp.almacen
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;  

  function of_saldo_inicial_mp(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada * amt.factor_sldo_total),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and al.flag_tipo_almacen = 'P'
      and am.cod_Art           in (select distinct amp.cod_art
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and vm.almacen           in (select distinct amp.almacen
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and trunc(vm.fec_registro) < trunc(adi_fecha);
  
    return ln_return;
  end;  
  
  function of_saldo_final_mp(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada * amt.factor_sldo_total),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and al.flag_tipo_almacen = 'P'
      and am.cod_Art           in (select distinct amp.cod_art
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and vm.almacen           in (select distinct amp.almacen
                                     from articulo_mov_proy amp,
                                          orden_trabajo     ot
                                    where ot.nro_orden      = amp.nro_doc
                                      and ot.nro_orden      = asi_nro_ot
                                      and amp.tipo_doc      = PKG_PRODUCCION.of_doc_ot(null))
      and trunc(vm.fec_registro) <= trunc(adi_fecha);
  
    return ln_return;
  end;   
  

  function of_consumo_mp(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total   = -1
      and al.flag_tipo_almacen = 'P'
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;    

  function of_consumo_petroleo_diesel(adi_fecha date, 
                               asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and trim(am.cod_art)   in (select trim(column_value)
                                       from table(split(PKG_CONFIG.USF_GET_PARAMETER('PETROLEO_DIESEL', '003004.0008, 002001.0002'))))

      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end; 
  
  function of_consumo_petroleo_r500(adi_fecha date, 
                                    asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and trim(am.cod_art)   in (select trim(column_value)
                                       from table(split(PKG_CONFIG.USF_GET_PARAMETER('PETROLEO_R500', '002001.0001'))))

      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end; 
  
  function of_consumo_antioxidante(adi_fecha date, 
                                    asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo     a,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and am.cod_art         = a.cod_art
      and trim(am.cod_art)   in (select trim(column_value)
                                   from table(split(PKG_CONFIG.USF_GET_PARAMETER('ANTIOXIDANTE', '006001.0002, 008002.0006'))))

      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;

  
  function of_consumo_polimero(adi_fecha date, 
                                    asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo     a,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and am.cod_art         = a.cod_art
      and trim(am.cod_art)   in (select trim(column_value)
                                   from table(split(PKG_CONFIG.USF_GET_PARAMETER('POLIMERO', '011001.0324'))))

      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;
  

  
  function of_consumo_coagulante(adi_fecha date, 
                                    asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo     a,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and am.cod_art         = a.cod_art
      and trim(am.cod_art)   in (select trim(column_value)
                                   from table(split(PKG_CONFIG.USF_GET_PARAMETER('COAGULANTE', '009001.0080'))))

      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;
  
  
  function of_consumo_sacos(adi_fecha date, 
                                    asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada * amt.factor_sldo_total * -1),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo     a,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and am.cod_art         = a.cod_art
      and trim(am.cod_art)   in (select trim(column_value)
                                       from table(split(PKG_CONFIG.USF_GET_PARAMETER('SACO_HP_PPTT', '003004.0004'))))

      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      --and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;   
  
  function of_reproceso_ton(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and trim(am.cod_art)   in (select trim(column_value)
                               from table(split(PKG_CONFIG.USF_GET_PARAMETER('COD_ARTICULO_HARINA_PESCADO', '015001.0001'))))
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;    
  
  function of_reproceso_sac(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_proc_und2),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and trim(am.cod_art)   in (select trim(column_value)
                               from table(split(PKG_CONFIG.USF_GET_PARAMETER('COD_ARTICULO_HARINA_PESCADO', '015001.0001'))))
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = -1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;   
  
  -- Producción de Aceites de pescado
    function of_prod_aceite_ch(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and trim(am.cod_art)   in (select trim(column_value)
                               from table(split(PKG_CONFIG.USF_GET_PARAMETER('ACEITE_CH', '015002.0001'))))
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = 1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end; 
  
    function of_prod_aceite_chi(adi_fecha date, 
                            asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and trim(am.cod_art)   in (select trim(column_value)
                               from table(split(PKG_CONFIG.USF_GET_PARAMETER('ACEITE_CHI', '015002.0003'))))
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = 1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end; 
  
    function of_prod_aceite_pama(adi_fecha date, 
                                 asi_nro_ot orden_trabajo.nro_orden%TYPE
	) return number is
  
    ln_return number;
    
  begin
    
    select nvl(sum(am.cant_procesada),0)
      into ln_return
      from articulo_mov am,
           vale_mov     vm,
           almacen      al,
           articulo_mov_proy amp,
           articulo_mov_tipo amt
    where am.nro_vale = vm.nro_Vale
      and vm.almacen  = al.almacen
      and vm.tipo_mov = amt.tipo_mov
      and am.origen_mov_proy = amp.cod_origen
      and am.nro_mov_proy    = amp.nro_mov
      and trim(am.cod_art)   in (select trim(column_value)
                               from table(split(PKG_CONFIG.USF_GET_PARAMETER('ACEITE_CHI', '015002.0002'))))
      and vm.flag_estado   <> '0'
      and am.flag_estado   <> '0'
      and amt.factor_sldo_total = 1
      and amp.tipo_doc       = PKG_PRODUCCION.of_doc_ot(null)
      and amp.nro_doc        = asi_nro_ot
      and trunc(vm.fec_registro) = trunc(adi_fecha);
  
    return ln_return;
  end;  
  
  -- Parte de empaque
  procedure sp_procesar_parte(
            asi_nro_parte in tg_parte_empaque.nro_parte%TYPE
  ) is
    
    ln_count            number;
    ln_ult_nro          num_vale_mov.ult_nro%TYPE;
    ls_obs_templa       templas.obs%TYPE;
    ln_total_cajas      tg_parte_empaque.total_caja%TYPE;

    -- Vale_mov
    ls_nro_vale         vale_mov.nro_vale%TYPE;
    ld_fec_registro     vale_mov.fec_registro%TYPE;
    ls_tipo_mov         vale_mov.tipo_mov%TYPE;
    
    -- Articulo_mov
    ls_matriz           articulo_mov.matriz%TYPE;
    ls_centro_benef     articulo_mov.centro_benef%TYPE;
    ln_nro_am           articulo_mov.nro_mov%TYPE;
    ls_org_am           articulo_mov.cod_origen%TYPE;
    ln_cant_und2        articulo_mov.cant_proc_und2%TYPE;
    ln_cant_proyect     articulo_mov_proy.cant_proyect%TYPE;
    ln_cant_procesada   articulo_mov_proy.cant_procesada%TYPE;

    cursor c_cabecera is
      select distinct
             te.nro_parte,
             te.org_vale_ing,
             am.nro_Vale as nro_vale_ing,
             te.fec_registro,
             te.fec_produccion,
             te.fec_reproceso,
             te.fec_cavalier,
             al.cod_origen,
             te.fec_empaque,
             te.almacen_pptt,
             te.cod_usr,
             ot.cod_origen as origen_ot,
             te.nro_ot,
             te.der,
             u.nombre as nom_usuario,
             te.flag_tipo_proceso
        from tg_parte_empaque_und teu,
             tg_parte_empaque     te,
             articulo             a,
             usuario              u,
             orden_trabajo        ot,
             almacen              al,
             articulo_mov         am
       where te.nro_parte        = teu.nro_parte
         and te.nro_ot           = ot.nro_orden
         and te.cod_art_pptt     = a.cod_art
         and te.cod_usr          = u.cod_usr
         and te.almacen_pptt     = al.almacen
         and teu.org_am          = am.cod_origen   (+)
         and teu.nro_am          = am.nro_mov      (+)
         and te.nro_parte        = asi_nro_parte;  
         
    cursor c_detalle is
      select te.nro_parte,
             a.cod_art,
             a.desc_art,
             a.flag_und2,
             case
               when te.total_caja = 0 then
                    0
               else
                    te.cant_producida / te.total_caja 
             end as cantidad,
             teu.org_am,
             teu.nro_am,
             u.nombre as nom_usuario,
             te.cod_usr,
             te.org_amp_ing,
             te.nro_amp_ing,
             te.nro_trazabilidad,
             teu.fec_registro,
             amp.oper_sec,
             teu.codigo_cu,
             te.nro_pallet
        from tg_parte_empaque_und teu,
             tg_parte_empaque     te,
             articulo             a,
             usuario              u,
             articulo_mov_proy    amp
       where te.nro_parte        = teu.nro_parte
         and te.cod_art_pptt     = a.cod_art
         and te.cod_usr          = u.cod_usr
         and te.org_amp_ing      = amp.cod_origen (+)
         and te.nro_amp_ing      = amp.nro_mov    (+)
         and te.nro_parte        = asi_nro_parte;
             
    
  begin

    for lc_cab in c_cabecera loop
        -- Genero la fecha de registro
        if PKG_CONFIG.USF_GET_PARAMETER('PROD_CAMBIO_FEC_VALE_EMPAQUE', '1') = '1' then
           if lc_cab.flag_tipo_proceso = '1' then
              ld_fec_registro := lc_cab.fec_produccion;
           elsif lc_cab.flag_tipo_proceso = '2' then
              ld_fec_registro := lc_cab.fec_reproceso;
           elsif lc_cab.flag_tipo_proceso in ('3', '4') then
              ld_fec_registro := lc_cab.fec_empaque;
           else
              RAISE_APPLICATION_ERROR(-20000, 'Flag Tipo Proceso no esta implementado: ' 
                                           || lc_cab.flag_tipo_proceso || ', por favor verifique!');
           end if;
           
           ld_fec_registro := to_date(to_char(ld_fec_registro, 'dd/mm/yyyy') || ' 00:00:01', 'dd/mm/yyyy hh24:Mi:ss');
        else
           ld_fec_registro := to_date(to_char(lc_cab.fec_empaque, 'dd/mm/yyyy') || ' ' || to_char(lc_cab.fec_registro, 'hh24:Mi:ss'), 'dd/mm/yyyy hh24:Mi:ss');
        end if;
        
        
        -- verifico si no tiene un vale de ingreso
        if lc_cab.org_vale_ing is null or lc_cab.nro_vale_ing is null then
           -- Genero un nuevo vale de ingreso
           select count(*)
             into ln_count
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen;
          
           if ln_count = 0 then
              insert into num_Vale_mov(Ult_Nro, Origen)
              values(1, lc_cab.cod_origen);
           end if;
           
           select n.ult_nro
             into ln_ult_nro
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen for update;
           
           --Genero nuevo vale
           ls_nro_vale := trim(lc_cab.cod_origen) || trim(to_char(ln_ult_nro, '00000000'));
           
           -- Seleccion un movimiento de Almacen adecuado
           if lc_cab.flag_tipo_proceso = '1' then
              ls_tipo_mov := is_oper_ing_prod;
           elsif lc_cab.flag_tipo_proceso = '2' then
              ls_tipo_mov := is_oper_ing_reproceso;
           elsif lc_cab.flag_tipo_proceso = '3' then
              ls_tipo_mov := is_oper_ing_reempaque;
           elsif lc_cab.flag_tipo_proceso = '4' then
              ls_tipo_mov := is_oper_ing_reclasif;
           end if;
           
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov,
                  cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                  origen_refer, tipo_refer, nro_refer,
                  flag_replicacion, observaciones, fec_produccion)
           values(
                  lc_cab.cod_origen, ls_nro_vale, lc_cab.almacen_pptt, '1', ld_fec_registro, 
                  ls_tipo_mov,
                  lc_cab.cod_usr, lc_cab.nom_usuario, 'PP', lc_cab.nro_parte,
                  lc_cab.origen_ot, is_doc_ot, lc_cab.nro_ot,
                  '1', 'PRODUCCION REALIZADA POR EL PARTE DE RECEPCION. DER ' || lc_cab.der, lc_cab.fec_produccion);
           
/*           -- Actualizo el nro de vale
           update tg_parte_empaque te
              set te.org_vale_ing = lc_cab.cod_origen,
                  te.nro_vale_ing = ls_nro_vale
            where te.nro_parte = asi_nro_parte;*/
           
           -- Actualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro + 1
             where n.origen = lc_cab.cod_origen;
                  
        else
          
          ls_nro_vale := lc_cab.nro_vale_ing;
          
          --Actualizo el almacen
          update vale_mov vm
             set vm.almacen = lc_cab.almacen_pptt,
                 vm.fec_registro = ld_fec_registro
           where vm.nro_vale = ls_nro_vale;
              
        end if;
        
        -- Actualizo el nro de cajas
        select count(*)
          into ln_total_cajas
          from tg_parte_empaque_und teu
         where teu.nro_parte = asi_nro_parte;
        
        if ln_total_cajas > 0 then
           update tg_parte_empaque te
              set te.total_caja = ln_total_cajas
            where te.nro_parte = asi_nro_parte;
        end if;
        
        -- Ahora inserto el detalle
        for lc_det in c_detalle loop
            -- Valido si existe o no la templa
            select count(*)
              into ln_count
              from templas te
            where trim(te.cod_templa) = trim(lc_det.nro_trazabilidad);
            
            if ln_count = 0 then
               ls_obs_templa := 'TRAZABILIDAD DE PRODUCCION.';
               
               if lc_cab.der is not null then
                  ls_obs_templa := ls_obs_templa || ' DER: ' || lc_cab.der;
               end if;
               
               insert into templas(
                      cod_templa, fec_registro, flag_estado, fec_produccion, obs)
               values(
                      lc_det.nro_trazabilidad, lc_det.fec_registro, '1', lc_cab.fec_produccion, 
                      ls_obs_templa);
            else
              select te.obs
                into ls_obs_templa
                from templas te
              where trim(te.cod_templa) = trim(lc_det.nro_trazabilidad);
              
              if instr(ls_obs_templa, 'DER: ' ||lc_cab.der) = 0 then
                 ls_obs_templa := ls_obs_templa || 'DER: ' ||lc_cab.der;
                 
                 update templas te
                    set obs = ls_obs_templa
                  where trim(te.cod_templa) = trim(lc_det.nro_trazabilidad);
              end if;
            end if;
            
            if lc_det.org_am is null or lc_det.nro_am is null then
               -- Valido la cantidad proyectada y cantidad procesada
               select amp.cant_proyect, amp.cant_procesada 
                 into ln_cant_proyect, ln_cant_procesada
                 from articulo_mov_proy amp
                where amp.cod_origen = lc_det.org_amp_ing
                  and amp.nro_mov    = lc_det.nro_amp_ing;
               
               if ln_cant_procesada + lc_det.cantidad > ln_cant_proyect then
                  update articulo_mov_proy amp
                     set amp.cant_proyect = amp.cant_proyect +  lc_det.cantidad, --(ln_cant_procesada + lc_det.cantidad - ln_cant_proyect),
                         amp.flag_estado  = '1'
                   where amp.cod_origen = lc_det.org_amp_ing
                     and amp.nro_mov    = lc_det.nro_amp_ing;
               end if;
               
               -- Valido la cantidad de ls segunda unidad
               if lc_det.flag_und2 = '1' then
                  ln_cant_und2 := 1;
               else
                  ln_cant_und2 := 0;
               end if;
               
               insert into articulo_mov(
                       cod_origen, origen_mov_proy, nro_mov_proy, nro_vale, flag_estado, cod_art, 
                       cant_procesada,
                       precio_unit, cod_moneda, matriz, nro_lote, precio_unit_ant, oper_sec, cant_proc_und2,
                       flag_replicacion, fec_registro, centro_benef, anaquel, fila, columna,
                       fec_cavalier, cus, nro_pallet, fec_produccion)
               values(
                       lc_cab.cod_origen, lc_det.org_amp_ing, lc_det.nro_amp_ing, ls_nro_vale, '1', lc_det.cod_art, 
                       lc_det.cantidad,
                       0, PKG_LOGISTICA.is_soles, ls_matriz, lc_det.nro_trazabilidad, 0, lc_det.oper_sec, ln_cant_und2,
                       '1', lc_det.fec_registro, ls_centro_benef, '00', '00', '00',
                       lc_cab.fec_cavalier, lc_det.codigo_cu, lc_det.nro_pallet, lc_cab.fec_produccion);
               
               -- Ubico el pk de articulo_mov
               select am.cod_origen, am.nro_mov
                 into ls_org_am, ln_nro_am
                 from articulo_mov am
                where am.nro_vale  = ls_nro_vale
                  and am.cus       = lc_det.codigo_cu
                  and am.cod_art   = lc_det.cod_art;
               
               -- actualizo el id en la tabla detalle
               update tg_parte_empaque_und teu
                  set teu.org_am = ls_org_am,
                      teu.nro_am = ln_nro_am
                where teu.codigo_cu = lc_det.codigo_cu; 
                  
            else
               update articulo_mov am
                  set am.cant_procesada = lc_det.cantidad,
                      am.cant_proc_und2 = 1,
                      am.nro_lote       = lc_det.nro_trazabilidad,
                      am.nro_pallet     = lc_det.nro_pallet,
                      am.cus            = lc_det.codigo_cu,
                      am.cod_art        = lc_det.cod_art
                where am.cod_origen = lc_det.org_am
                  and am.nro_mov    = lc_det.nro_am;
            end if;
        end loop;
        
    end loop;
  end;
  
    procedure sp_procesar_parte_sin_cu(
            asi_nro_parte in tg_parte_empaque.nro_parte%TYPE
  ) is
    
    ln_count            number;
    ln_ult_nro          num_vale_mov.ult_nro%TYPE;
    
    ls_obs_templa       templas.obs%TYPE;
    ls_tabla            num_tablas.tabla%TYPE;
    ls_codigo_cu        tg_parte_empaque_und.codigo_cu%TYPE;
    
    -- Articulo_mov_proy
    ln_cant_proyect     articulo_mov_proy.cant_proyect%TYPE;
    ln_cant_procesada   articulo_mov_proy.cant_procesada%TYPE;

    -- Vale_mov
    ls_tipo_mov         vale_mov.tipo_mov%TYPE;
    ls_nro_vale         vale_mov.nro_vale%TYPE;
    ld_fec_registro     vale_mov.fec_registro%TYPE;
    
    -- Articulo_mov
    ls_matriz           articulo_mov.matriz%TYPE;
    ls_centro_benef     articulo_mov.centro_benef%TYPE;
    ls_org_am           articulo_mov.cod_origen%TYPE;
    ln_nro_am           articulo_mov.nro_mov%TYPE;
    ln_cant_und2        articulo_mov.cant_proc_und2%TYPE;

    cursor c_datos is
      select distinct
             te.nro_parte,
             te.org_vale_ing,
             (select max(am.nro_vale)
                from tg_parte_empaque_und teu,
                     articulo_mov         am
               where teu.org_am   = am.cod_origen
                 and teu.nro_am   = am.nro_mov
                 and teu.nro_parte = te.nro_parte) nro_vale_ing,
             te.fec_registro,
             te.fec_produccion,
             te.fec_empaque,
             te.fec_cavalier,
             te.flag_tipo_proceso,
             al.cod_origen,
             te.almacen_pptt,
             te.cod_usr,
             ot.cod_origen as origen_ot,
             te.nro_ot,
             te.der,
             te.cant_producida,
             a.factor_conv_und,
             a.flag_und2,
             te.org_amp_ing,
             te.nro_amp_ing,
             a.cod_art,
             a.desc_art,
             te.nro_trazabilidad,
             te.nro_pallet,
             amp.oper_sec,
             u.nombre as nom_usuario
        from tg_parte_empaque     te,
             articulo             a,
             usuario              u,
             orden_trabajo        ot,
             almacen              al,
             articulo_mov_proy    amp
       where te.nro_ot           = ot.nro_orden
         and te.cod_art_pptt     = a.cod_art
         and te.cod_usr          = u.cod_usr
         and te.almacen_pptt     = al.almacen
         and te.org_amp_ing      = amp.cod_origen
         and te.nro_amp_ing      = amp.nro_mov
         and te.nro_parte        = asi_nro_parte;  
         
  begin

    for lc_reg in c_datos loop
        -- Genero la fecha de registro
        if PKG_CONFIG.USF_GET_PARAMETER('PROD_CAMBIO_FEC_VALE_EMPAQUE', '1') = '1' then
           if lc_reg.flag_tipo_proceso = '1' then
              ld_fec_registro := lc_reg.fec_produccion;
           elsif lc_reg.flag_tipo_proceso = '2' then
              ld_fec_registro := lc_reg.fec_produccion;
           elsif lc_reg.flag_tipo_proceso in ('3', '4') then
              ld_fec_registro := lc_reg.fec_empaque;
           else
              RAISE_APPLICATION_ERROR(-20000, 'Flag Tipo Proceso no esta implementado: ' 
                                           || lc_reg.flag_tipo_proceso || ', por favor verifique!');
           end if;
           
           ld_fec_registro := to_date(to_char(ld_fec_registro, 'dd/mm/yyyy') || ' 00:00:01', 'dd/mm/yyyy hh24:Mi:ss');
        else
           ld_fec_registro := to_date(to_char(lc_reg.fec_empaque, 'dd/mm/yyyy') || ' ' || to_char(lc_reg.fec_registro, 'hh24:Mi:ss'), 'dd/mm/yyyy hh24:Mi:ss');
        end if;

        -- verifico si no tiene un vale de ingreso
        if lc_reg.org_vale_ing is null or lc_reg.nro_vale_ing is null then
           -- Genero un nuevo vale de ingreso
           select count(*)
             into ln_count
             from num_vale_mov n
            where n.origen = lc_reg.cod_origen;
          
           if ln_count = 0 then
              insert into num_Vale_mov(Ult_Nro, Origen)
              values(1, lc_reg.cod_origen);
           end if;
           
           select n.ult_nro
             into ln_ult_nro
             from num_vale_mov n
            where n.origen = lc_reg.cod_origen for update;
           
           --Genero nuevo vale
           ls_nro_vale := trim(lc_reg.cod_origen) || trim(to_char(ln_ult_nro, '00000000'));
           
           -- Seleccion un movimiento de Almacen adecuado
           if lc_reg.flag_tipo_proceso = '1' then
              ls_tipo_mov := is_oper_ing_prod;
           elsif lc_reg.flag_tipo_proceso = '2' then
              ls_tipo_mov := is_oper_ing_reproceso;
           elsif lc_reg.flag_tipo_proceso = '3' then
              ls_tipo_mov := is_oper_ing_reempaque;
           elsif lc_reg.flag_tipo_proceso = '4' then
              ls_tipo_mov := is_oper_ing_reclasif;
           end if;

           
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, tipo_mov,
                  cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                  origen_refer, tipo_refer, nro_refer,
                  flag_replicacion, observaciones, fec_produccion)
           values(
                  lc_reg.cod_origen, ls_nro_vale, lc_reg.almacen_pptt, '1', ld_fec_registro, 
                  ls_tipo_mov,
                  lc_reg.cod_usr, lc_reg.nom_usuario, 'PP', lc_reg.nro_parte,
                  lc_reg.origen_ot, is_doc_ot, lc_reg.nro_ot,
                  '1', 'PRODUCCION REALIZADA POR EL PARTE DE EMPAQUE. DER ' || lc_reg.der, lc_reg.fec_produccion);
           
           -- Actualizo el nro de vale
/*           update tg_parte_empaque te
              set te.org_vale_ing = lc_reg.cod_origen,
                  te.nro_vale_ing = ls_nro_vale
            where te.nro_parte = asi_nro_parte;*/
           
           -- Actualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro + 1
             where n.origen = lc_reg.cod_origen;
                  
        else
          
          ls_nro_vale := lc_reg.nro_vale_ing;
          
          --Actualizo el almacen
          update vale_mov vm
             set vm.almacen = lc_reg.almacen_pptt,
                 vm.fec_registro = ld_fec_registro
           where vm.nro_vale = ls_nro_vale;
              
        end if;
        
        -- Valido si existe o no la templa
        select count(*)
          into ln_count
          from templas te
         where trim(te.cod_templa) = trim(lc_reg.nro_trazabilidad);
        
        if ln_count = 0 then
           ls_obs_templa := 'TRAZABILIDAD DE PRODUCCION.';
               
           if lc_reg.der is not null then
              ls_obs_templa := ls_obs_templa || ' DER: ' || lc_reg.der;
           end if;
               
           insert into templas(
                  cod_templa, fec_registro, flag_estado, fec_produccion, obs)
           values(
                  lc_reg.nro_trazabilidad, lc_reg.fec_registro, '1', lc_reg.fec_produccion, 
                  ls_obs_templa);
        else
          select te.obs
            into ls_obs_templa
            from templas te
          where trim(te.cod_templa) = trim(lc_reg.nro_trazabilidad);
          
          if lc_reg.der is not null then
             if instr(ls_obs_templa, 'DER: ' ||lc_reg.der) = 0 then
                ls_obs_templa := ls_obs_templa || 'DER: ' ||lc_reg.der;
                    
                update templas te
                   set obs = ls_obs_templa
                 where trim(te.cod_templa) = trim(lc_reg.nro_trazabilidad);
             end if;
          end if;
          
        end if;
        
        -- Verifico la cantidad en und2
        if lc_reg.flag_und2 = '1' then
            ln_cant_und2 := lc_reg.cant_producida * lc_reg.factor_conv_und;
        else
            ln_cant_und2 := 0;
        end if;
         
         
        -- Valido la cantidad proyectada y cantidad procesada
        select amp.cant_proyect, amp.cant_procesada 
          into ln_cant_proyect, ln_cant_procesada
          from articulo_mov_proy amp
         where amp.cod_origen = lc_reg.org_amp_ing
           and amp.nro_mov    = lc_reg.nro_amp_ing;
               
        if ln_cant_procesada + lc_reg.cant_producida > ln_cant_proyect then
           RAISE_APPLICATION_ERROR(-20000, 'No se puede exceder la cantidad producida a la cantidada proyectada en la OT'
                                     || chr(13) || 'OT: ' || lc_reg.nro_ot
                                     || chr(13) || 'Nro AMP: ' || trim(lc_reg.org_amp_ing) || trim(to_Char(lc_reg.nro_amp_ing)
                                     || chr(13) || 'Articulo : ' || lc_Reg.cod_Art || ' ' || lc_reg.desc_Art));
        end if;
        
        -- Creo el CU que es unico con la misma cantidad de cajas
        select count(*)
		      into ln_count
	        from tg_parte_empaque_und
	       where nro_parte = lc_reg.nro_parte;
        
        if ln_count = 0 then
           ls_tabla := 'CODIGO_CU_CAJA';
            
           select count(*)
             into ln_count
           from NUM_TABLAS
           where tabla  = ls_tabla
             and origen = lc_reg.cod_origen;
              
           if ln_count = 0 then
             insert into NUM_TABLAS(tabla, origen, ult_nro)
             values( ls_tabla, lc_reg.cod_origen, 1);
           end if;  
           
           SELECT ult_nro
              INTO ln_ult_nro
            FROM NUM_TABLAS
            where tabla  = ls_tabla
              and origen = lc_reg.cod_origen for update;
            
           --Verifico que el numero del oper_sec no exista
           loop
              
               ls_codigo_cu := trim(lc_reg.cod_origen) || lpad(PKG_UTILITY.of_convert_to_hex(ln_ult_nro), 13 - length(trim(lc_reg.cod_origen)), '0');
              
               SELECT count(*)
                 into ln_count
               from tg_parte_empaque_und t
               where t.CODIGO_CU = ls_codigo_cu;

               if ln_count > 0 then 
                  ln_ult_nro := ln_ult_nro + 1;
               end if;
               
               exit when ln_count = 0;
              
            end loop;
            
            update NUM_TABLAS
              set ult_nro = ln_ult_nro + 1
            where tabla  = ls_tabla
              and origen = lc_reg.cod_origen;
            
            insert into tg_parte_empaque_und(
                   NRO_PARTE, NRO_ITEM, CODIGO_CU, FEC_REGISTRO, COD_USR, NRO_CAJA)
            values(
                   lc_reg.nro_parte, 1, ls_codigo_cu, sysdate, lc_reg.cod_usr, lc_reg.cant_producida);
      
        else
           select teu.codigo_cu, teu.org_am, teu.nro_am
             into ls_codigo_cu, ls_org_am, ln_nro_am
             from tg_parte_empaque_und teu
            where teu.nro_parte = lc_reg.nro_parte;
        end if;
  
        if ln_nro_am is null or ln_nro_am is null then
           -- Inserto el detalle del movimiento de almacen
           insert into articulo_mov(
                  cod_origen, origen_mov_proy, nro_mov_proy, nro_vale, flag_estado, cod_art, 
                  cant_procesada,
                  precio_unit, cod_moneda, matriz, nro_lote, precio_unit_ant, oper_sec, cant_proc_und2,
                  flag_replicacion, fec_registro, centro_benef, anaquel, fila, columna,
                  fec_cavalier, cus, nro_pallet, fec_produccion)
           values(
                   lc_reg.cod_origen, lc_reg.org_amp_ing, lc_reg.nro_amp_ing, ls_nro_vale, '1', lc_reg.cod_art, 
                   lc_reg.cant_producida,
                   0, PKG_LOGISTICA.is_soles, ls_matriz, lc_reg.nro_trazabilidad, 0, lc_reg.oper_sec, ln_cant_und2,
                   '1', lc_reg.fec_registro, ls_centro_benef, '00', '00', '00',
                   lc_reg.fec_cavalier, ls_codigo_cu, lc_reg.nro_pallet, lc_reg.fec_produccion);
           
           select am.cod_origen, am.nro_mov
             into ls_org_am, ln_nro_am
             from articulo_mov am
            where am.nro_vale  = ls_nro_vale;
           
           update tg_parte_empaque_und teu
              set teu.org_am = ls_org_am,
                  teu.nro_am = ln_nro_am
            where teu.nro_parte  = lc_reg.nro_parte;
        else
           update articulo_mov am
              set am.cant_procesada = lc_reg.cant_producida,
                  am.cant_proc_und2 = ln_cant_und2,
                  am.cus            = ls_codigo_cu,
                  am.nro_pallet     = lc_reg.nro_pallet,
                  am.nro_lote       = lc_reg.nro_trazabilidad
            where am.cod_origen     = ls_org_am
              and am.nro_mov        = ln_nro_am;
        end if;
            
    end loop;
  end;
  
  
  procedure sp_procesar_recepcion(
            asi_nro_parte in tg_parte_recepcion.nro_parte%TYPE
  ) is
    
    ln_count            number;
    ln_ult_nro          num_vale_mov.ult_nro%TYPE;
    ls_nro_vale_ing     vale_mov.nro_vale%TYPE;
    ls_nro_vale_sal     vale_mov.nro_vale%TYPE;
    ln_cant_und2        articulo_mov.cant_proc_und2%TYPE;
    ln_total_cajas      number;
    ln_nro_am           articulo_mov.nro_mov%TYPE;
    ls_org_am           articulo_mov.cod_origen%TYPE;
    ld_fec_registro     vale_mov.fec_registro%TYPE;
    

    cursor c_cabecera is
      select distinct
             tr.nro_parte,
             tr.org_vale_ing,
             tr.nro_vale_ing,
             tr.org_vale_sal,
             tr.nro_vale_sal,
             tr.fec_registro,
             tr.fec_recepcion,
             te.almacen_pptt,
             tr.almacen_dst,
             tr.cod_usr,
             u.nombre as nom_usuario,
             tr.anaquel,
             tr.fila, 
             tr.columna,
             al1.cod_origen as cod_origen1,
             al2.cod_origen as cod_origen2,
             te.flag_estado as flag_estado_emp,
             te.nro_parte as nro_parte_empaque,
             am.nro_vale as vale_ing_empaque
        from tg_parte_recepcion_und tru,
             tg_parte_recepcion     tr,
             usuario                u,
             tg_parte_empaque       te,
             tg_parte_empaque_und   teu,
             almacen                al1,
             almacen                al2,
             articulo_mov           am
       where tr.nro_parte        = tru.nro_parte
         and tr.cod_usr          = u.cod_usr
         and te.nro_parte        = teu.nro_parte
         and teu.codigo_cu       = tru.codigo_cu
         and te.almacen_pptt     = al1.almacen
         and tr.almacen_dst      = al2.almacen
         and tr.nro_parte        = asi_nro_parte
         and teu.org_am          = am.cod_origen (+)
         and teu.nro_am          = am.nro_mov    (+)
         
         and tr.flag_estado      <> '0';  
         
    cursor c_detalle(as_almacen  almacen.almacen%TYPE) is
      select tru.nro_parte,
             tru.nro_item,
             tru.codigo_cu,
             te.nro_pallet,
             tru.fec_registro,
             tru.cod_usr,
             te.cod_art_pptt,
             tru.org_am_ing,
             tru.nro_am_ing,
             tru.org_am_sal,
             tru.nro_am_sal,
             a.flag_und2,
             (select distinct te1.nro_trazabilidad
                from tg_parte_empaque te1,
                     tg_parte_empaque_und teu1
                where te1.nro_parte = teu1.nro_parte
                  and teu1.codigo_cu = teu.codigo_cu ) as nro_trazabilidad,
             (select sum(am.cant_procesada)
                from articulo_mov am,
                     tg_parte_empaque_und teu1
                where am.cod_origen = teu1.org_am
                  and am.nro_mov    = teu1.nro_am
                  and teu1.codigo_cu = teu.codigo_cu ) as cantidad_und,
             (select sum(am.cant_proc_und2)
                from articulo_mov am,
                     tg_parte_empaque_und teu1
                where am.cod_origen = teu1.org_am
                  and am.nro_mov    = teu1.nro_am
                  and teu1.codigo_cu = teu.codigo_cu ) as cantidad_und2 
        from tg_parte_recepcion_und tru,
             tg_parte_empaque       te,
             tg_parte_empaque_und   teu,
             articulo               a
       where te.nro_parte     = teu.nro_parte
         and teu.codigo_cu    = tru.codigo_cu
         and te.cod_art_pptt  = a.cod_art
         and te.almacen_pptt  = as_almacen
         and tru.nro_parte    = asi_nro_parte;
             
    
  begin

    for lc_cab in c_cabecera loop
        if lc_cab.vale_ing_empaque is null then
           RAISE_APPLICATION_ERROR(-20000, 'El Nro de Parte de EMPAQUE '  || lc_cab.nro_parte_empaque 
                                           || ' no tiene Vale de Ingreso por Produccion, por favor corrija!');
        end if;
        
        -- Genero la fecha de registro
        ld_fec_registro := to_date(to_char(lc_cab.fec_recepcion, 'dd/mm/yyyy') || ' ' || to_char(lc_cab.fec_registro, 'hh24:Mi:ss'), 'dd/mm/yyyy hh24:Mi:ss');
        
        -- verifico si no tiene un vale de ingreso
        if lc_cab.org_vale_sal is null or lc_cab.nro_vale_sal is null then
           -- Genero un nuevo vale de ingreso
           select count(*)
             into ln_count
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen1;
          
           if ln_count = 0 then
              insert into num_Vale_mov(Ult_Nro, Origen)
              values(1, lc_cab.cod_origen1);
           end if;
           
           select n.ult_nro
             into ln_ult_nro
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen1 for update;
           
           --Genero nuevo vale
           ls_nro_vale_sal := trim(lc_cab.cod_origen1) || trim(to_char(ln_ult_nro, '00000000'));
           
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, 
                  tipo_mov,
                  cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                  flag_replicacion, observaciones, fec_produccion)
           values(
                  lc_cab.cod_origen1, ls_nro_vale_sal, lc_cab.almacen_pptt, '1', ld_fec_registro, 
                  is_oper_sal_trans_int,
                  lc_cab.cod_usr, lc_cab.nom_usuario, 'PP', lc_cab.nro_parte,
                  '1', 'RECEPCION DE PRODUCCCION. NRO PARTE: ' || lc_cab.nro_parte, lc_cab.fec_registro);
           
           -- Actualizo el nro de vale
           update tg_parte_recepcion te
              set te.org_vale_sal = lc_cab.cod_origen1,
                  te.nro_vale_sal = ls_nro_vale_sal
            where te.nro_parte = asi_nro_parte;
           
           -- Actualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro + 1
             where n.origen = lc_cab.cod_origen1;
                  
        else
          
          ls_nro_vale_sal := lc_cab.nro_vale_sal;
          
          update vale_mov vm
             set vm.almacen      = lc_cab.almacen_pptt,
                 vm.fec_registro = ld_fec_registro
           where vm.nro_vale = ls_nro_vale_sal;
              
        end if;
        
        -- Ahora con el vale de ingreso
        if lc_cab.org_vale_ing is null or lc_cab.nro_vale_ing is null then
           -- Genero un nuevo vale de ingreso
           select count(*)
             into ln_count
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen2;
          
           if ln_count = 0 then
              insert into num_Vale_mov(Ult_Nro, Origen)
              values(1, lc_cab.cod_origen2);
           end if;
           
           select n.ult_nro
             into ln_ult_nro
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen2 for update;
           
           --Genero nuevo vale
           ls_nro_vale_ing := trim(lc_cab.cod_origen2) || trim(to_char(ln_ult_nro, '00000000'));
           
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, 
                  tipo_mov,
                  cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                  flag_replicacion, observaciones, fec_produccion)
           values(
                  lc_cab.cod_origen2, ls_nro_vale_ing, lc_cab.almacen_dst, '1', ld_fec_registro, 
                  is_oper_ing_trans_int,
                  lc_cab.cod_usr, lc_cab.nom_usuario, 'PP', lc_cab.nro_parte,
                  '1', 'RECEPCION DE PRODUCCCION. NRO PARTE: ' || lc_cab.nro_parte, lc_cab.fec_registro);
           
           -- Actualizo el nro de vale
           update tg_parte_recepcion te
              set te.org_vale_ing = lc_cab.cod_origen2,
                  te.nro_vale_ing = ls_nro_vale_ing
            where te.nro_parte = asi_nro_parte;
           
           -- Actualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro + 1
             where n.origen = lc_cab.cod_origen2;
                  
        else
          
          ls_nro_vale_ing := lc_cab.nro_vale_ing;
          
          update vale_mov vm
             set vm.almacen      = lc_cab.almacen_dst,
                 vm.fec_registro = ld_fec_registro
           where vm.nro_vale = ls_nro_vale_ing;
              
        end if;
        
        -- Actualizo el nro de cajas
        select count(*)
          into ln_total_cajas
          from tg_parte_recepcion_und teu
         where teu.nro_parte = asi_nro_parte;
        
        -- Ahora inserto el detalle
        for lc_det in c_detalle(lc_cab.almacen_pptt) loop
            -- Valido la cantidad de ls segunda unidad
            if lc_det.flag_und2 = '1' then
               ln_cant_und2 := lc_det.cantidad_und2;
            else
               ln_cant_und2 := 0;
            end if;
            
            if lc_det.org_am_sal is null or lc_det.nro_am_sal is null then
               -- Actualizo el saldo_tota
               /*
               select aa.sldo_total, aa.sldo_total_und2
                 into ln_saldo_total, ln_saldo_total_und2
                 from articulo_almacen aa
                where aa.cod_art = lc_det.cod_art_pptt
                  and aa.almacen = lc_cab.almacen_pptt for update;
               
               if ln_saldo_total - lc_det.peso_prom < 0 then
                  ln_saldo_total := ln_saldo_total + lc_det.peso_prom;
               end if;
               
               if ln_saldo_total_und2 - ln_cant_und2 < 0 then
                  ln_saldo_total_und2 := ln_saldo_total_und2 + ln_cant_und2;
               end if;
               
               update articulo_almacen aa
                  set aa.sldo_total = ln_saldo_total,
                      aa.sldo_total_und2 = ln_saldo_total_und2
                where aa.cod_art = lc_det.cod_art_pptt
                  and aa.almacen = lc_cab.almacen_pptt;
               */
               insert into articulo_mov(
                       cod_origen, nro_vale, flag_estado, cod_art, 
                       cant_procesada,
                       precio_unit, cod_moneda, nro_lote, precio_unit_ant, 
                       cant_proc_und2,
                       flag_replicacion, fec_registro, 
                       anaquel, fila, columna,
                       cus, nro_pallet)
               values(
                       lc_cab.cod_origen1, ls_nro_vale_sal, '1', lc_det.cod_art_pptt, 
                       lc_det.cantidad_und,
                       0, PKG_LOGISTICA.is_soles, lc_det.nro_trazabilidad, 0, 
                       ln_cant_und2,
                       '1', sysdate, 
                       '00', '00', '00',
                       lc_det.codigo_cu, 
                       lc_det.nro_pallet);
               
               -- Ubico el pk de articulo_mov
               select cod_origen, nro_mov
                 into ls_org_am, ln_nro_am
                 from (select am.cod_origen, am.nro_mov
                         from articulo_mov am
                        where am.nro_vale   = ls_nro_vale_sal
                          and am.cus        = lc_det.codigo_cu
                          and am.cod_art    = lc_det.cod_art_pptt
                       order by am.nro_mov desc) s
                where rownum        = 1;
               
               -- actualizo el id en la tabla detalle
               update tg_parte_recepcion_und teu
                  set teu.org_am_sal = ls_org_am,
                      teu.nro_am_sal = ln_nro_am
                where teu.nro_parte  = lc_det.nro_parte
                   and teu.nro_item  = lc_det.nro_item; 
            
            else
                update articulo_mov am
                   set am.nro_lote       = lc_det.nro_trazabilidad,
                       am.cant_procesada = lc_det.cantidad_und,
                       am.cant_proc_und2 = ln_cant_und2
                 where am.cod_origen = lc_det.org_am_sal
                   and am.nro_mov    = lc_det.nro_am_sal;      
            end if;
            
            -- Valido la cantidad de ls segunda unidad
            if lc_det.flag_und2 = '1' then
               ln_cant_und2 := lc_det.cantidad_und2;
            else
               ln_cant_und2 := 0;
            end if;
            
            if lc_det.org_am_ing is null or lc_det.nro_am_ing is null then
               
               
               
               insert into articulo_mov(
                       cod_origen, nro_vale, flag_estado, cod_art, 
                       cant_procesada,
                       precio_unit, cod_moneda, nro_lote, precio_unit_ant, 
                       cant_proc_und2,
                       flag_replicacion, fec_registro, 
                       anaquel, fila, columna,
                       cus, nro_pallet)
               values(
                       lc_cab.cod_origen2, ls_nro_vale_ing, '1', lc_det.cod_art_pptt, 
                       lc_det.cantidad_und,
                       0, PKG_LOGISTICA.is_soles, lc_det.nro_trazabilidad, 0, 
                       ln_cant_und2,
                       '1', lc_det.fec_registro, 
                       lc_cab.anaquel, lc_cab.fila, lc_cab.columna,
                       lc_det.codigo_cu, lc_det.nro_pallet);
               
               -- Ubico el pk de articulo_mov
               select cod_origen, nro_mov
                 into ls_org_am, ln_nro_am
                 from (select am.cod_origen, am.nro_mov
                         from articulo_mov am
                        where am.nro_vale   = ls_nro_vale_ing
                          and am.cus        = lc_det.codigo_cu
                          and am.cod_art    = lc_det.cod_art_pptt
                       order by am.nro_mov desc) s
                where rownum        = 1;

               
               -- actualizo el id en la tabla detalle
               update tg_parte_recepcion_und teu
                  set teu.org_am_ing = ls_org_am,
                      teu.nro_am_ing = ln_nro_am
                where teu.nro_parte  = lc_det.nro_parte
                   and teu.nro_item  = lc_det.nro_item; 
                  
            else
                update articulo_mov am
                   set am.nro_lote       = lc_det.nro_trazabilidad,
                       am.cant_procesada = lc_det.cantidad_und,
                       am.cant_proc_und2 = ln_cant_und2
                 where am.cod_origen = lc_det.org_am_ing
                   and am.nro_mov    = lc_det.nro_am_ing;      
            end if;

        end loop;
        
    end loop;
  end;
  
  procedure sp_procesar_transferencia(
            asi_nro_parte in tg_parte_transferencia.nro_parte%TYPE
  ) is
    
    ln_count            number;
    ln_ult_nro          num_vale_mov.ult_nro%TYPE;
    ls_nro_vale_ing     vale_mov.nro_vale%TYPE;
    ls_nro_vale_sal     vale_mov.nro_vale%TYPE;
    ln_cant_und2        articulo_mov.cant_proc_und2%TYPE;
    ln_total_cajas      number;
    ln_nro_am           articulo_mov.nro_mov%TYPE;
    ls_org_am           articulo_mov.cod_origen%TYPE;
    --ln_saldo_total      articulo_almacen.sldo_total%TYPE;
    --ln_saldo_total_und2 articulo_almacen.sldo_total_und2%TYPE;
    ld_fec_registro     vale_mov.fec_registro%TYPE;
    

    cursor c_cabecera is
      select distinct
             tf.nro_parte,
             (select distinct
                     am.nro_vale
                from articulo_mov am
               where am.cod_origen = tfu.org_am_ing
                 and am.nro_mov    = tfu.nro_am_ing) as nro_Vale_ing,
             (select distinct
                     am.nro_vale
                from articulo_mov am
               where am.cod_origen = tfu.org_am_sal
                 and am.nro_mov    = tfu.nro_am_sal) as nro_Vale_sal,
             tf.fec_registro,
             tf.fec_transferencia,
             tf.almacen_org,
             tf.almacen_dst,
             tf.cod_usr,
             u.nombre as nom_usuario,
             tf.anaquel_org,
             tf.fila_org,
             tf.columna_org,
             tf.anaquel_dst,
             tf.fila_dst,
             tf.columna_dst,
             al1.cod_origen as cod_origen1,
             al2.cod_origen as cod_origen2,
             tf.nro_pallet_org,
             tf.nro_pallet_dst
        from tg_parte_transferencia_und tfu,
             tg_parte_transferencia     tf,
             usuario                    u,
             tg_parte_empaque_und       teu,
             almacen                    al1,
             almacen                    al2
       where tf.nro_parte        = tfu.nro_parte
         and tf.cod_usr          = u.cod_usr
         and teu.codigo_cu       = tfu.codigo_cu
         and tf.almacen_org      = al1.almacen
         and tf.almacen_dst      = al2.almacen
         and tf.nro_parte        = asi_nro_parte
         and tf.flag_estado      <> '0';  
         
    cursor c_detalle(as_almacen_org   almacen.almacen%TYPE) is
      select tfu.nro_parte,
             tfu.nro_item,
             tfu.codigo_cu,
             tfu.fec_registro,
             tfu.cod_usr,
             tfu.cod_art,
             tfu.org_am_ing,
             tfu.nro_am_ing,
             tfu.org_am_sal,
             tfu.nro_am_sal,
             vw.flag_und2,
             vw.nro_lote as nro_trazabilidad,
             vw.cant_proc_und1 as cant_procesada,
             vw.cant_proc_und2 as cant_proc_und2
        from tg_parte_transferencia_und tfu,
             (select a.flag_und2, am.cus, am.nro_lote,
                     abs(sum(am.cant_procesada * amt.factor_sldo_total)) as cant_proc_und1,
                     abs(sum(am.cant_proc_und2 * amt.factor_sldo_total)) as cant_proc_und2
                from vale_mov          vm,
                     articulo_mov      am,
                     articulo_mov_tipo amt,
                     articulo          a
               where vm.nro_vale  = am.nro_Vale
                 and am.cod_art   = a.cod_art
                 and vm.tipo_mov  = amt.tipo_mov
                 and vm.almacen   = as_almacen_org
                 and vm.flag_estado <> '0'
                 and am.flag_estado <> '0'
           group by a.flag_und2, am.cus, am.nro_lote
           having abs(sum(am.cant_procesada * amt.factor_sldo_total)) > 0
               or abs(sum(am.cant_proc_und2 * amt.factor_sldo_total)) > 0) vw
       where tfu.codigo_cu    = vw.cus
         and tfu.nro_parte    = asi_nro_parte;
             
    
  begin
    -- Actualizo los totales en la cabecera
    --update tg_parte_transferencia tf
    --   set tf.cantidad = (select nvl(sum(te.cant_producida / te.total_caja),0)
    --                             from tg_parte_empaque te,
    --                                  tg_parte_empaque_und teu,
    --                                  tg_parte_transferencia_und tfu
    --                            where te.nro_parte = teu.nro_parte
    --                              and teu.codigo_cu = tfu.codigo_cu
    --                              and tfu.nro_parte = tf.nro_parte),
    --       tf.nro_cajas = (select count(*)
    --                         from tg_parte_transferencia_und tfu
    --                        where tfu.nro_parte = tf.nro_parte)
    -- where tf.nro_parte     = asi_nro_parte; 

    for lc_cab in c_cabecera loop
        -- Genero la fecha de registro
        ld_fec_registro := to_date(to_char(lc_cab.fec_transferencia, 'dd/mm/yyyy') || ' ' || to_char(lc_cab.fec_registro, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
        
        -- verifico si no tiene un vale de ingreso
        if lc_cab.nro_vale_sal is null then
           -- Genero un nuevo vale de ingreso
           select count(*)
             into ln_count
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen1;
          
           if ln_count = 0 then
              insert into num_Vale_mov(Ult_Nro, Origen)
              values(1, lc_cab.cod_origen1);
           end if;
           
           select n.ult_nro
             into ln_ult_nro
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen1 for update;
           
           --Genero nuevo vale
           ls_nro_vale_sal := trim(lc_cab.cod_origen1) || trim(to_char(ln_ult_nro, '00000000'));
           
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, 
                  tipo_mov,
                  cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                  flag_replicacion, observaciones, fec_produccion)
           values(
                  lc_cab.cod_origen1, ls_nro_vale_sal, lc_cab.almacen_org, '1', ld_fec_registro, 
                  is_oper_sal_trans_int,
                  lc_cab.cod_usr, lc_cab.nom_usuario, 'PP', lc_cab.nro_parte,
                  '1', 'TRANSFERENCIA DE PRODUCCION. NRO PARTE: ' || lc_cab.nro_parte, lc_cab.fec_registro);
           
           
           -- Actualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro + 1
             where n.origen = lc_cab.cod_origen1;
                  
        else
          
          ls_nro_vale_sal := lc_cab.nro_vale_sal;
          
          update vale_mov vm
             set vm.almacen      = lc_cab.almacen_org,
                 vm.fec_registro = ld_fec_registro
           where vm.nro_vale = ls_nro_vale_sal;
              
        end if;
        
        -- Ahora con el vale de ingreso
        if lc_cab.nro_vale_ing is null then
           -- Genero un nuevo vale de ingreso
           select count(*)
             into ln_count
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen2;
          
           if ln_count = 0 then
              insert into num_Vale_mov(Ult_Nro, Origen)
              values(1, lc_cab.cod_origen2);
           end if;
           
           select n.ult_nro
             into ln_ult_nro
             from num_vale_mov n
            where n.origen = lc_cab.cod_origen2 for update;
           
           --Genero nuevo vale
           ls_nro_vale_ing := trim(lc_cab.cod_origen2) || trim(to_char(ln_ult_nro, '00000000'));
           
           insert into vale_mov(
                  cod_origen, nro_vale, almacen, flag_estado, fec_registro, 
                  tipo_mov,
                  cod_usr, nom_receptor, tipo_doc_int, nro_doc_int,
                  flag_replicacion, observaciones, fec_produccion)
           values(
                  lc_cab.cod_origen2, ls_nro_vale_ing, lc_cab.almacen_dst, '1', ld_fec_registro, 
                  is_oper_ing_trans_int,
                  lc_cab.cod_usr, lc_cab.nom_usuario, 'PP', lc_cab.nro_parte,
                  '1', 'TRANSFERENCIA DE PRODUCCCION. NRO PARTE: ' || lc_cab.nro_parte, lc_cab.fec_registro);
           
           -- Actualizo el numerador
           update num_vale_mov n
              set n.ult_nro = ln_ult_nro + 1
             where n.origen = lc_cab.cod_origen2;
                  
        else
          
          ls_nro_vale_ing := lc_cab.nro_vale_ing;
          
          update vale_mov vm
             set vm.almacen      = lc_cab.almacen_dst,
                 vm.fec_registro = ld_fec_registro
           where vm.nro_vale = ls_nro_vale_ing;
              
        end if;
        
        -- Actualizo el nro de cajas
        select count(*)
          into ln_total_cajas
          from tg_parte_recepcion_und teu
         where teu.nro_parte = asi_nro_parte;
        
        -- Ahora inserto el detalle
        for lc_det in c_detalle(lc_cab.almacen_org) loop
            -- Valido la cantidad de ls segunda unidad
            if lc_det.flag_und2 = '1' then
               ln_cant_und2 := 1;
            else
               ln_cant_und2 := 0;
            end if;
            
            if lc_det.org_am_sal is null or lc_det.nro_am_sal is null then

               
               insert into articulo_mov(
                       cod_origen, nro_vale, flag_estado, cod_art, 
                       cant_procesada,
                       cant_proc_und2,
                       precio_unit, cod_moneda, nro_lote, precio_unit_ant, 
                       flag_replicacion, fec_registro, 
                       anaquel, fila, columna,
                       cus, nro_pallet)
               values(
                       lc_cab.cod_origen1, ls_nro_vale_sal, '1', lc_det.cod_art, 
                       lc_det.cant_procesada,
                       lc_det.cant_proc_und2,
                       0, PKG_LOGISTICA.is_soles, lc_det.nro_trazabilidad, 0, 
                       '1', sysdate, 
                       lc_cab.anaquel_org, lc_cab.fila_org, lc_cab.columna_org,
                       lc_det.codigo_cu, 
                       trim(lc_cab.nro_pallet_org));
               
               -- Ubico el pk de articulo_mov
               select cod_origen, nro_mov
                 into ls_org_am, ln_nro_am
                 from (select am.cod_origen, am.nro_mov
                         from articulo_mov am
                        where am.nro_vale   = ls_nro_vale_sal
                          and am.cus        = lc_det.codigo_cu
                          and am.cod_art    = lc_det.cod_art
                       order by am.nro_mov desc) s
                where rownum        = 1;
               
               -- actualizo el id en la tabla detalle
               update tg_parte_transferencia_und teu
                  set teu.org_am_sal = ls_org_am,
                      teu.nro_am_sal = ln_nro_am
                where teu.nro_parte  = lc_det.nro_parte
                   and teu.nro_item  = lc_det.nro_item; 
            
            else
                update articulo_mov am
                   set am.nro_lote       = lc_det.nro_trazabilidad,
                       am.cant_procesada = lc_det.cant_procesada,
                       am.cant_proc_und2 = lc_det.cant_proc_und2,
                       am.anaquel        = lc_cab.anaquel_org,
                       am.fila           = lc_cab.fila_org,
                       am.columna        = lc_cab.columna_org,
                       am.nro_pallet     = trim(lc_cab.nro_pallet_org),
                       am.cus            = lc_det.codigo_cu
                 where am.cod_origen = lc_det.org_am_sal
                   and am.nro_mov    = lc_det.nro_am_sal;      
            end if;
            
            -- Valido la cantidad de ls segunda unidad
            if lc_det.flag_und2 = '1' then
               ln_cant_und2 := 1;
            else
               ln_cant_und2 := 0;
            end if;
            
            if lc_det.org_am_ing is null or lc_det.nro_am_ing is null then
               
               
               
               insert into articulo_mov(
                       cod_origen, nro_vale, flag_estado, cod_art, 
                       cant_procesada,
                       cant_proc_und2,
                       precio_unit, cod_moneda, nro_lote, precio_unit_ant, 
                       flag_replicacion, fec_registro, 
                       anaquel, fila, columna,
                       cus, nro_pallet)
               values(
                       lc_cab.cod_origen2, ls_nro_vale_ing, '1', lc_det.cod_art, 
                       lc_det.cant_procesada,
                       lc_det.cant_proc_und2,
                       0, PKG_LOGISTICA.is_soles, lc_det.nro_trazabilidad, 0, 
                       '1', lc_det.fec_registro, 
                       lc_cab.anaquel_dst, 
                       lc_cab.fila_dst, lc_cab.columna_dst,
                       lc_det.codigo_cu, trim(lc_cab.nro_pallet_dst));
               
               -- Ubico el pk de articulo_mov
               select cod_origen, nro_mov
                 into ls_org_am, ln_nro_am
                 from (select am.cod_origen, am.nro_mov
                         from articulo_mov am
                        where am.nro_vale   = ls_nro_vale_ing
                          and am.cus        = lc_det.codigo_cu
                          and am.cod_art    = lc_det.cod_art
                       order by am.nro_mov desc) s
                where rownum        = 1;

               
               -- actualizo el id en la tabla detalle
               update tg_parte_transferencia_und teu
                  set teu.org_am_ing = ls_org_am,
                      teu.nro_am_ing = ln_nro_am
                where teu.nro_parte  = lc_det.nro_parte
                   and teu.nro_item  = lc_det.nro_item; 
                  
            else
                update articulo_mov am
                   set am.nro_lote       = lc_det.nro_trazabilidad,
                       am.cant_procesada = lc_det.cant_procesada,
                       am.cant_proc_und2 = lc_det.cant_proc_und2,
                       am.anaquel        = lc_cab.anaquel_dst,
                       am.fila           = lc_cab.fila_dst,
                       am.columna        = lc_cab.columna_dst,
                       am.nro_pallet     = trim(lc_cab.nro_pallet_dst),
                       am.cus            = lc_det.codigo_cu
                 where am.cod_origen = lc_det.org_am_ing
                   and am.nro_mov    = lc_det.nro_am_ing;      
            end if;

        end loop;
        
    end loop;
  end;
  
  procedure sp_procesar_empaque_all(
          asi_nada in varchar2
  ) is
    cursor c_datos is
      select nro_parte
        from tg_parte_empaque te
       where te.flag_estado = '1';
  begin
    for lc_cab in c_datos loop
        PKG_PRODUCCION.sp_procesar_parte(lc_cab.nro_parte);
        commit;
    end loop;
  end;
  
  procedure sp_procesar_recepcion_all(
          asi_nada in varchar2
  ) is
    cursor c_datos is
      select nro_parte
        from tg_parte_recepcion te
       where te.flag_estado = '1'
      order by 1;
  begin
    for lc_cab in c_datos loop
        PKG_PRODUCCION.sp_procesar_recepcion(lc_cab.nro_parte);
        commit;
    end loop;
  end;
  
  procedure sp_procesar_transferencia_all(
          asi_nada in varchar2
  ) is
    cursor c_datos is
      select nro_parte
        from tg_parte_transferencia tf
       where tf.flag_estado = '1'
      order by 1;
  begin
    for lc_cab in c_datos loop
        PKG_PRODUCCION.sp_procesar_transferencia(lc_cab.nro_parte);
        commit;
    end loop;
  end;
  
  procedure sp_anular_parte_empaque(
            asi_nro_parte in tg_parte_empaque.nro_parte%TYPE
  ) is
    
    ln_count       number; 
    ls_nro_parte   tg_parte_recepcion.nro_parte%TYPE; 
    ls_nro_vale    vale_mov.nro_vale%TYPE;
  
    cursor c_detalle is
      select teu.nro_parte,
             teu.nro_item,
             teu.codigo_cu,
             teu.fec_registro,
             teu.org_am,
             teu.nro_am
        from tg_parte_empaque_und teu
       where teu.nro_parte    = asi_nro_parte;
  begin
    
    -- Anulo los items del articulo_mov
    for lc_cab in c_detalle loop
        -- Valido si el CU no ha sido recebido en el parte de recepcion
        select count(*)
          into ln_count
          from tg_parte_recepcion_und tru,
               tg_parte_recepcion     tr
         where tr.nro_parte  = tru.nro_parte
           and tru.codigo_cu = lc_cab.codigo_cu
           and tr.flag_estado  = '1';
       
        if ln_count <> 0 then
          -- Obtengo el nro de parte
          select max(tr.nro_parte)
            into ls_nro_parte
            from tg_parte_recepcion_und tru,
                 tg_parte_recepcion     tr
           where tr.nro_parte  = tru.nro_parte
             and tru.codigo_cu = lc_cab.codigo_cu
             and tr.flag_estado  = '1';
         
           RAISE_APPLICATION_ERROR(-20000, 'El código de CU ' || lc_cab.codigo_cu 
                                        || ' no se puede anular, porque ya ha sido recibido en el'
                                        || ' Parte de Recepcion Nro ' || ls_nro_parte);
        end if;
        
        update articulo_mov am
           set am.cant_procesada = 0,
               am.cant_proc_und2 = 0,
               am.precio_unit    = 0,
               am.flag_estado    = '0'
         where am.cod_origen     = lc_cab.org_am
           and am.nro_mov        = lc_cab.nro_am;
        
    end loop;
    -- Obtengo el nro del vale
    select max(am.nro_vale)
      into ls_nro_vale
      from tg_parte_empaque_und teu,
           articulo_mov         am
     where teu.org_am   = am.cod_origen
       and teu.nro_am   = am.nro_mov
       and teu.nro_parte = asi_nro_parte;
    
    -- Anulo la cabecera del vale_mov
    update vale_mov vm
       set vm.flag_estado = '0'
      where vm.nro_vale = ls_nro_vale;
      
    update tg_parte_empaque te
       set te.flag_estado = '0'
     where te.nro_parte = asi_nro_parte;
     
    
  end;
  
  procedure sp_anular_parte_empaque_sin_cu(
            asi_nro_parte in tg_parte_empaque.nro_parte%TYPE
  ) is
    
  
    cursor c_datos is
      select teu.nro_parte,
             max(am.nro_vale) as nro_Vale_ing
        from tg_parte_empaque_und teu,
             articulo_mov         am
       where teu.org_am   = am.cod_origen
         and teu.nro_am   = am.nro_mov
         and teu.nro_parte = asi_nro_parte
      group by teu.nro_parte;
  begin
    
    -- Anulo los items del articulo_mov
    for lc_reg in c_datos loop
      
        update articulo_mov am
           set am.cant_procesada = 0,
               am.cant_proc_und2 = 0,
               am.precio_unit    = 0,
               am.flag_estado    = '0'
         where am.nro_vale       = lc_reg.nro_vale_ing;
        
        -- Anulo la cabecera del vale_mov
        update vale_mov vm
           set vm.flag_estado = '0'
          where vm.nro_vale = lc_reg.nro_vale_ing;
            
          update tg_parte_empaque te
             set te.flag_estado = '0'
           where te.nro_parte = asi_nro_parte;
        
    end loop;
    
      
    update tg_parte_empaque te
       set te.flag_estado = '0'
     where te.nro_parte = asi_nro_parte;
    
  end;
  
  
  procedure sp_anular_parte_recepcion(
            asi_nro_parte in tg_parte_empaque.nro_parte%TYPE
  ) is
    
    cursor c_detalle is
      select tr.nro_vale_sal, tr.nro_vale_ing, tr.nro_parte
        from tg_parte_recepcion tr
       where tr.nro_parte    = asi_nro_parte;
  begin
    
    -- Anulo los items del articulo_mov
    for lc_cab in c_detalle loop
        --Elimino el detalle del parte de recepcion
        delete tg_parte_recepcion_und tru
         where tru.nro_parte = lc_cab.nro_parte;
         
        update articulo_mov am
           set am.cant_procesada = 0,
               am.cant_proc_und2 = 0,
               am.precio_unit    = 0,
               am.flag_estado    = '0'
         where am.nro_vale       = lc_cab.nro_vale_sal;
         
        update vale_mov vm
           set vm.flag_estado    = '0'
         where vm.nro_vale       = lc_cab.nro_vale_sal;
         
         update articulo_mov am
           set am.cant_procesada = 0,
               am.cant_proc_und2 = 0,
               am.precio_unit    = 0,
               am.flag_estado    = '0'
         where am.nro_vale       = lc_cab.nro_vale_ing;   
         
         update vale_mov vm
           set vm.flag_estado    = '0'
         where vm.nro_vale       = lc_cab.nro_vale_ing;
         
         -- Anulo el parte
         update tg_parte_recepcion tr
            set tr.flag_estado = '0'
           where tr.nro_parte = lc_cab.nro_parte;
         
          
    end loop;
    
     
    
  end;
  
  procedure sp_anular_parte_tranferencia(
            asi_nro_parte in tg_parte_transferencia.nro_parte%TYPE
  ) is
    
    cursor c_detalle is
      select (select distinct am.nro_vale
                from articulo_mov am,
                     tg_parte_transferencia_und tfu
               where am.cod_origen        = tfu.org_am_sal
                 and am.nro_mov           = tfu.nro_am_sal
                 and tfu.nro_parte        = tr.nro_parte) as nro_vale_sal, 
             (select distinct am.nro_vale
                from articulo_mov am,
                     tg_parte_transferencia_und tfu
               where am.cod_origen        = tfu.org_am_ing
                 and am.nro_mov           = tfu.nro_am_ing
                 and tfu.nro_parte        = tr.nro_parte) as nro_vale_ing, 
             tr.nro_parte
        from tg_parte_transferencia tr
       where tr.nro_parte    = asi_nro_parte;
  begin
    
    -- Anulo los items del articulo_mov
    for lc_cab in c_detalle loop
        --Elimino el detalle del parte de recepcion
        delete tg_parte_recepcion_und tru
         where tru.nro_parte = lc_cab.nro_parte;
         
        update articulo_mov am
           set am.cant_procesada = 0,
               am.cant_proc_und2 = 0,
               am.precio_unit    = 0,
               am.flag_estado    = '0'
         where am.nro_vale       = lc_cab.nro_vale_sal;
         
        update vale_mov vm
           set vm.flag_estado    = '0'
         where vm.nro_vale       = lc_cab.nro_vale_sal;
         
         update articulo_mov am
           set am.cant_procesada = 0,
               am.cant_proc_und2 = 0,
               am.precio_unit    = 0,
               am.flag_estado    = '0'
         where am.nro_vale       = lc_cab.nro_vale_ing;   
         
         update vale_mov vm
           set vm.flag_estado    = '0'
         where vm.nro_vale       = lc_cab.nro_vale_ing;
         
         -- Anulo el parte
         update tg_parte_transferencia tr
            set tr.flag_estado = '0'
           where tr.nro_parte = lc_cab.nro_parte;
         
          
    end loop;
    
     
    
  end;
  
  
  procedure sp_anular_recepcion_duplicada(
            asi_nada in varchar2
  ) is
    cursor c_datos is
      select distinct t.nro_parte, t.nro_pallet
      from tg_parte_recepcion_und t
      where t.codigo_cu in (select t.codigo_cu
                                  from TG_PARTE_RECEPCION_UND t
                                  group by t.codigo_cu
                                  having count(*) > 1);
  begin
    for lc_reg in c_datos loop
        PKG_PRODUCCION.sp_anular_parte_recepcion(lc_reg.nro_parte);
        commit;
    end loop;
    
  end;
  
  procedure sp_anular_recep_cu_anulados(
            asi_nada in varchar2
  ) is
    
    cursor c_datos is
      select tru.codigo_cu, tru.org_am_ing, tru.nro_am_ing, tru.org_am_sal, tru.nro_am_sal
        from tg_parte_recepcion_und tru
      where tru.codigo_cu not in(select teu.codigo_cu
                                    from tg_parte_empaque te,
                                         tg_parte_empaque_und teu
                                   where te.nro_parte = teu.nro_parte
                                     and te.flag_estado = '1' );
             
    
  begin

    for lc_reg in c_datos loop
        --Elimino el detalle del parte de recepcion
        delete tg_parte_recepcion_und tru
         where tru.codigo_cu = lc_reg.codigo_cu;
         
        delete articulo_mov am
         where am.cod_origen     = lc_reg.org_am_sal
           and am.nro_mov        = lc_reg.nro_am_sal;
         
        delete articulo_mov am
         where am.cod_origen     = lc_reg.org_am_ing
           and am.nro_mov        = lc_reg.nro_am_ing;
        
        commit;
         
    end loop;
  end;
begin
  -- Initialization
  select l.doc_ot, l.oper_ing_prod
    into is_doc_ot, is_oper_ing_prod
    from logparam l
   where l.reckey = '1';
  
  is_oper_sal_trans_int := PKG_CONFIG.USF_GET_PARAMETER('OPERACION_SAL_TRANSF_INTERNO', 'S49');
  is_oper_ing_trans_int := PKG_CONFIG.USF_GET_PARAMETER('OPERACION_ING_TRANSF_INTERNO', 'I41');
  
  -- Tipos de movimientos
  is_oper_ing_reproceso := PKG_CONFIG.USF_GET_PARAMETER('PROD_ING_REPROCESO', 'I16');
  is_oper_ing_reempaque := PKG_CONFIG.USF_GET_PARAMETER('PROD_ING_REEMPAQUE', 'I17');
  is_oper_ing_reclasif  := PKG_CONFIG.USF_GET_PARAMETER('PROD_ING_RECLASIFICACION', 'I29');
  
end PKG_PRODUCCION;
/

prompt
prompt Creating package body PKG_RRHH
prompt ==============================
prompt
create or replace package body cantabria.PKG_RRHH is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  procedure of_borra_mov_calculo ( asi_origen         in origen.cod_origen%TYPE,
                                   adi_fec_proceso    in date,
                                   asi_cod_trabajador in maestro.cod_trabajador%TYPE,
                                   asi_tipo_planilla  in calculo.tipo_planilla%TYPE
  ) is
  
    ls_doc_autom    rrhhparam.doc_reg_automatico%TYPE;

  begin

    SELECT doc_reg_automatico
      INTO ls_doc_autom
      FROM rrhhparam
     WHERE reckey = '1';

    --  *******************************************************
    --  ***   ELIMINA MOVIMIENTO DE LA PLANILLA CALCULADA   ***
    --  *******************************************************
    delete from calculo c
      where c.cod_trabajador = asi_cod_trabajador 
        and c.tipo_planilla = asi_tipo_planilla
        and c.cod_origen    = asi_origen;

    delete from cnta_crrte_detalle cc
      where cc.fec_dscto = adi_fec_proceso
        and cc.cod_trabajador = asi_cod_trabajador;

    delete from diferido d
      where d.fec_proceso = adi_fec_proceso
        and d.cod_trabajador = asi_cod_trabajador;

    delete from quinta_categoria q
      where q.fec_proceso = adi_fec_proceso
        and q.cod_trabajador = asi_cod_trabajador 
        and q.tipo_planilla  = asi_tipo_planilla;

    commit ;
    
  end;
  
  function of_dias_laborados   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 asi_tipo_trabaj    in maestro.tipo_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date)
  return number is
    ln_dias_destajo              number;
    ln_dias_jornal               number;
    ln_dias_asistencia           number;
    ln_dias_faena                number;
    ln_dias_periodo              number;
    ln_dias_inasistencia         number;
    ln_return                    number;
    ld_fecha1                    date;
    ld_fecha2                    date;
    ld_fec_ingreso               date;
    ld_fec_cese                  date;
    
  begin
    -- Obteniendo los días del periodo
    ln_dias_periodo := adi_fecha2 - adi_fecha1 + 1;
    
    if ln_dias_periodo <= 0 then return 0; end if;
    
    -- Obtengo el tipo de trabajador
    select m.fec_ingreso, m.fec_cese
      into ld_fec_ingreso, ld_fec_cese
      from maestro m
     where m.cod_trabajador = asi_trabajador;
    
    if asi_tipo_trabaj <> 'EMP' then
       select count(distinct a.fec_parte)
         into ln_dias_destajo
         from tg_pd_destajo a,
              tg_pd_destajo_det b
        where a.nro_parte = b.nro_parte
          and b.cod_trabajador = asi_trabajador
          and trunc(a.fec_parte) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
       select count(distinct a.fecha)
         into ln_dias_jornal
         from pd_jornal_campo a
        where a.cod_trabajador = asi_trabajador
          and trunc(a.fecha) between trunc(adi_Fecha1) and trunc(adi_fecha2);
          
       select count(a.fec_movim)
         into ln_dias_asistencia
         from asistencia a
        where a.cod_trabajador = asi_trabajador
          and trunc(a.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
          
       select count(distinct a.fecha)
         into ln_dias_faena
         from fl_asistencia a
        where a.tripulante = asi_trabajador
          and trunc(a.fecha) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
       ln_return := ln_dias_destajo + ln_dias_jornal + ln_dias_faena + ln_dias_asistencia;
    else
       -- Obtengo el nuevo rango de fechas
       if ld_fec_ingreso > adi_fecha1 then
          ld_fecha1 := ld_fec_ingreso;
       else
          ld_fecha1 := adi_fecha1;
       end if;
       
       if ld_fec_cese is null then
          ld_fecha2 := adi_fecha2;
       else
          if ld_fec_cese < adi_fecha2 then
             ld_fecha2 := ld_fec_cese;
          else
             ld_fecha2 := adi_fecha2;
          end if;
       end if;
       
       ln_dias_periodo := ld_fecha2 - ld_fecha1 + 1;
       if ln_dias_periodo <= 0 then return 0; end if;
       
       -- Obtengo los días de inasistencia
       select nvl(sum(i.dias_inasist),0)
         into ln_dias_inasistencia
         from inasistencia i
        where i.cod_trabajador = asi_trabajador 
          and trunc(i.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
       ln_return := ln_dias_periodo - ln_dias_inasistencia;
    end if; 

    if ln_return > ln_dias_periodo then ln_return := ln_dias_periodo; end if;
    
    return ln_return;
    
  end ;
  
  function of_dias_laborados   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date)
  return number is
    ln_dias_destajo              number;
    ln_dias_jornal               number;
    ln_dias_asistencia           number;
    ln_dias_faena                number;
    ln_dias_periodo              number;
    ln_dias_inasistencia         number;
    ln_return                    number;
    ls_tipo_trabajador           maestro.tipo_trabajador%TYPE;
    ld_fecha1                    date;
    ld_fecha2                    date;
    ld_fec_ingreso               date;
    ld_fec_cese                  date;
    
  begin
    -- Obteniendo los días del periodo
    ln_dias_periodo := adi_fecha2 - adi_fecha1 + 1;
    
    if ln_dias_periodo <= 0 then return 0; end if;
    
    -- Obtengo el tipo de trabajador
    select tipo_trabajador, m.fec_ingreso, m.fec_cese
      into ls_tipo_trabajador, ld_fec_ingreso, ld_fec_cese
      from maestro m
     where m.cod_trabajador = asi_trabajador;
    
    if ls_tipo_trabajador <> 'EMP' then
       select count(distinct a.fec_parte)
         into ln_dias_destajo
         from tg_pd_destajo a,
              tg_pd_destajo_det b
        where a.nro_parte = b.nro_parte
          and b.cod_trabajador = asi_trabajador
          and trunc(a.fec_parte) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
       select count(distinct a.fecha)
         into ln_dias_jornal
         from pd_jornal_campo a
        where a.cod_trabajador = asi_trabajador
          and trunc(a.fecha) between trunc(adi_Fecha1) and trunc(adi_fecha2);
          
       select count(a.fec_movim)
         into ln_dias_asistencia
         from asistencia a
        where a.cod_trabajador = asi_trabajador
          and trunc(a.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
          
       select count(distinct a.fecha)
         into ln_dias_faena
         from fl_asistencia a
        where a.tripulante = asi_trabajador
          and trunc(a.fecha) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
       ln_return := ln_dias_destajo + ln_dias_jornal + ln_dias_faena + ln_dias_asistencia;
    else
       -- Obtengo el nuevo rango de fechas
       if ld_fec_ingreso > adi_fecha1 then
          ld_fecha1 := ld_fec_ingreso;
       else
          ld_fecha1 := adi_fecha1;
       end if;
       
       if ld_fec_cese is null then
          ld_fecha2 := adi_fecha2;
       else
          if ld_fec_cese < adi_fecha2 then
             ld_fecha2 := ld_fec_cese;
          else
             ld_fecha2 := adi_fecha2;
          end if;
       end if;
       
       ln_dias_periodo := ld_fecha2 - ld_fecha1 + 1;
       if ln_dias_periodo <= 0 then return 0; end if;
       
       -- Obtengo los días de inasistencia
       select nvl(sum(i.dias_inasist),0)
         into ln_dias_inasistencia
         from inasistencia i
        where i.cod_trabajador = asi_trabajador 
          and trunc(i.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
       ln_return := ln_dias_periodo - ln_dias_inasistencia;
    end if; 

    if ln_return > ln_dias_periodo then ln_return := ln_dias_periodo; end if;
    
    return ln_return;
    
  end ;
  
  function of_dias_laborados   ( 
           asi_trabajador     in maestro.cod_trabajador%TYPE,
           ani_year           in number,
           ani_mes            in number)
  return number is
    ln_dias_destajo              number;
    ln_dias_jornal               number;
    ln_dias_faena                number;
    ln_dias_periodo              number;
    ln_dias_inasistencia         number;
    ln_return                    number;
    ls_tipo_trabajador           maestro.tipo_trabajador%TYPE;
    ld_fecha1                    date;
    ld_fecha2                    date;
    ld_fec_ingreso               date;
    ld_fec_cese                  date;
    
  begin
    ld_fecha1 := to_date('01/' || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year, '0000')), 'dd/mm/yyyy');
    ld_fecha2 := usf_last_day(ld_fecha1);
    
    -- Obteniendo los días del periodo
    ln_dias_periodo := ld_fecha2 - ld_fecha1 + 1;
    
    if ln_dias_periodo <= 0 then return 0; end if;
    
    -- Obtengo el tipo de trabajador
    select tipo_trabajador, m.fec_ingreso, m.fec_cese
      into ls_tipo_trabajador, ld_fec_ingreso, ld_fec_cese
      from maestro m
     where m.cod_trabajador = asi_trabajador;
    
    if ls_tipo_trabajador <> 'EMP' then
       select count(distinct a.fec_parte)
         into ln_dias_destajo
         from tg_pd_destajo a,
              tg_pd_destajo_det b
        where a.nro_parte = b.nro_parte
          and b.cod_trabajador = asi_trabajador
          and trunc(a.fec_parte) between trunc(ld_fecha1) and trunc(ld_fecha2);
       
       select count(distinct a.fecha)
         into ln_dias_jornal
         from pd_jornal_campo a
        where a.cod_trabajador = asi_trabajador
          and trunc(a.fecha) between trunc(ld_fecha1) and trunc(ld_fecha2);
          
       select count(distinct a.fecha)
         into ln_dias_faena
         from fl_asistencia a
        where a.tripulante = asi_trabajador
          and trunc(a.fecha) between trunc(ld_fecha1) and trunc(ld_fecha2);
       
       ln_return := ln_dias_destajo + ln_dias_jornal + ln_dias_faena; 
    else
       -- Obtengo el nuevo rango de fechas
       if ld_fec_ingreso > ld_fecha1 then
          ld_fecha1 := ld_fec_ingreso;
       end if;
       
       if ld_fec_cese is not null then
        if ld_fec_cese < ld_fecha2 then
             ld_fecha2 := ld_fec_cese;
           end if;
       end if;
       
       ln_dias_periodo := ld_fecha2 - ld_fecha1 + 1;
       if ln_dias_periodo <= 0 then return 0; end if;
       
       -- Obtengo los días de inasistencia
       select nvl(sum(i.dias_inasist),0)
         into ln_dias_inasistencia
         from inasistencia i
        where i.cod_trabajador = asi_trabajador 
          and trunc(i.fec_movim) between trunc(ld_fecha1) and trunc(ld_fecha2);
       
       ln_return := ln_dias_periodo - ln_dias_inasistencia;
    end if; 

    if ln_return > ln_dias_periodo then ln_return := ln_dias_periodo; end if;
    
    return ln_return;
    
  end ;
  function of_dias_no_laborados  ( 
           asi_trabajador     in maestro.cod_trabajador%TYPE,
           ani_year           in number,
           ani_mes            in number
  ) return number is
    ld_fecha1        date;
    ld_fecha2        date;
    ld_fecha         date;
    ln_dia           number;
    ln_dias_periodo  number;
    ln_count         number;
    ln_Result        number;
  begin
    ld_fecha1 := to_date('01/' || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year, '0000')), 'dd/mm/yyyy');
    ld_fecha2 := usf_last_day(ld_fecha1);
    
    ln_dias_periodo := ld_Fecha2 - ld_fecha1 + 1;
    
    ln_Result := 0;
    
    FOR ln_dia IN 0..ln_dias_periodo - 1 LOOP
        ld_fecha := ld_fecha1 + ln_dia;
        
        select count(*)
          into ln_count
          from fl_asistencia fla
         where fla.tripulante = asi_trabajador
           and trunc(fla.fecha) = ld_fecha;
       
       if ln_count = 0 then
          ln_Result := ln_Result +1;
       end if;
        
    end loop;
    
    return ln_Result;
  end;
   
  function of_dias_vacaciones   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date)
  return number is
    ln_return                    number;
    
  begin
    -- Obtengo los días de inasistencia
    select nvl(sum(i.dias_inasist),0)
      into ln_return
      from inasistencia i,
           grupo_calculo_det gcd
     where i.concep = gcd.concepto_calc
       and gcd.grupo_calculo = is_grp_vacaciones
       and i.cod_trabajador = asi_trabajador 
       and trunc(i.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
    return ln_return;
  end ;

  function of_dias_subsidios   ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date)
  return number is
    ln_return                    number;
    
  begin
    -- Obtengo los días de inasistencia
    select nvl(sum(i.dias_inasist),0)
      into ln_return
      from inasistencia i,
           grupo_calculo_det gcd
     where i.concep = gcd.concepto_calc
       and gcd.grupo_calculo = is_grp_subsidios
       and i.cod_trabajador = asi_trabajador 
       and trunc(i.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
    return ln_return;
  end ;

  function of_dias_permisos    ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date)
  return number is
    ln_return                    number;
    
  begin
    -- Obtengo los días de inasistencia
    select nvl(sum(i.dias_inasist),0)
      into ln_return
      from inasistencia i,
           grupo_calculo_det gcd
     where i.concep = gcd.concepto_calc
       and gcd.grupo_calculo = is_grp_permisos
       and i.cod_trabajador = asi_trabajador 
       and trunc(i.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
    return ln_return;
  end ;

  -- Calculo los domingos
  function of_dias_domingo    ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date)
  return number is
    ln_return                    number;
    ls_tipo_trabajador           maestro.tipo_trabajador%TYPE;
    ln_dias_periodo              number;
    ld_fecha                     date;
    ln_dia                       number;
    ln_count                     number;
    ld_fecha1                    date;
    ld_fecha2                    date;
    ld_fec_ingreso               date;
    ld_fec_cese                  date;
    
  begin
    select tipo_trabajador, m.fec_ingreso, m.fec_cese
      into ls_tipo_trabajador, ld_fec_ingreso, ld_fec_cese
      from maestro m
     where m.cod_trabajador = asi_trabajador;
    
    if ls_tipo_trabajador = 'EMP' then return 0; end if;
    
    if ld_fec_cese is null then
       ld_fecha2 := adi_Fecha2;
    else
       if ld_fec_cese < adi_fecha2 then
          ld_fecha2 := ld_fec_cese;
       else
          ld_fecha2 := adi_fecha2;
       end if;
    end if;
    
    
    if ld_fec_ingreso > adi_fecha1 then
       ld_fecha1 := ld_fec_ingreso;
    else
       ld_fecha1 := adi_fecha1;
    end if;
    
    ln_dias_periodo := ld_fecha2 - ld_fecha1 + 1;
    if ln_dias_periodo <= 0 then return 0; end if;
    
    ld_fecha := ld_fecha1;
    ln_return := 0;
    FOR ln_dia IN 0..ln_dias_periodo - 1 LOOP
        ld_fecha := ld_fecha + ln_dia;
        
        -- Si el día es un domingo
        if to_char(ld_fecha, 'd') = '1' then
           select count(*)
             into ln_count
             from tg_pd_destajo a,
                  tg_pd_destajo_det b
            where a.nro_parte = b.nro_parte
              and b.cod_trabajador = asi_trabajador
              and trunc(a.fec_parte) = trunc(ld_fecha);
           
           if ln_count = 0 then
              select count(*)
                into ln_count
                from pd_jornal_campo a
               where a.cod_trabajador  = asi_trabajador
                 and trunc(a.fecha) = trunc(ld_fecha);
           end if;   
           
           if ln_count = 0 then
              select count(*)
                into ln_count
                from fl_asistencia a
               where a.tripulante       = asi_trabajador
                 and trunc(a.fecha) = trunc(ld_fecha);
           end if;   
           
           if ln_count = 0 then
             ln_return := ln_return + 1;
           end if;
           
        end if;
    end loop;
    return ln_return;
    
  end ;

  -- Calculo los domingos
  function of_dias_feriado ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                             adi_fecha1         in date,
                             adi_fecha2         in date)
  return number is
    ln_return                    number;
    ls_tipo_trabajador           maestro.tipo_trabajador%TYPE;
    ln_dias_periodo              number;
    ld_fecha                     date;
    ln_dia                       number;
    ln_count                     number;
    ld_fecha1                    date;
    ld_fecha2                    date;
    ld_fec_ingreso               date;
    ld_fec_cese                  date;
    ls_origen                    maestro.cod_origen%TYPE;
    
  begin
    select tipo_trabajador, m.fec_ingreso, m.fec_cese, m.cod_origen
      into ls_tipo_trabajador, ld_fec_ingreso, ld_fec_cese, ls_origen
      from maestro m
     where m.cod_trabajador = asi_trabajador;
    
    if ls_tipo_trabajador = 'EMP' then return 0; end if;
    
    if ld_fec_cese is null then
       ld_fecha2 := adi_Fecha2;
    else
       if ld_fec_cese < adi_fecha2 then
          ld_fecha2 := ld_fec_cese;
       else
          ld_fecha2 := adi_fecha2;
       end if;
    end if;
    
    
    if ld_fec_ingreso > adi_fecha1 then
       ld_fecha1 := ld_fec_ingreso;
    else
       ld_fecha1 := adi_fecha1;
    end if;
    
    ln_dias_periodo := ld_fecha2 - ld_fecha1 + 1;
    if ln_dias_periodo <= 0 then return 0; end if;
    
    ld_fecha := ld_fecha1;
    ln_return := 0;
    FOR ln_dia IN 0..ln_dias_periodo - 1 LOOP
        ld_fecha := ld_fecha + ln_dia;
        
        -- Si el día es un domingo
        select count(*)
          into ln_count
          from calendario_feriado cf
         where cf.origen          = ls_origen
           and cf.mes             = to_number(to_char(ld_fecha, 'mm'))
           and cf.dia             = to_number(to_char(ld_fecha, 'dd'));
           
        if ln_count > 0 then
           select count(*)
             into ln_count
             from tg_pd_destajo a,
                  tg_pd_destajo_det b
            where a.nro_parte = b.nro_parte
              and b.cod_trabajador = asi_trabajador
              and trunc(a.fec_parte) = trunc(ld_fecha);
           
           if ln_count = 0 then
              select count(*)
                into ln_count
                from pd_jornal_campo a
               where a.cod_trabajador  = asi_trabajador
                 and trunc(a.fecha) = trunc(ld_fecha);
           end if;   
           
           if ln_count = 0 then
              select count(*)
                into ln_count
                from fl_asistencia a
               where a.tripulante       = asi_trabajador
                 and trunc(a.fecha) = trunc(ld_fecha);
           end if;   
           
           if ln_count = 0 then
             ln_return := ln_return + 1;
           end if;
           
        end if;
    end loop;
    return ln_return;
    
  end ;

  function of_dias_inasistencia( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 adi_fecha1         in date,
                                 adi_fecha2         in date)
  return number is
    ln_return                    number;
    
  begin
    -- Obtengo los días de inasistencia
    select nvl(sum(i.dias_inasist),0)
      into ln_return
      from inasistencia i,
           grupo_calculo_det gcd
     where i.concep = gcd.concepto_calc
       and gcd.grupo_calculo = is_grp_inasistencia
       and i.cod_trabajador = asi_trabajador 
       and trunc(i.fec_movim) between trunc(adi_Fecha1) and trunc(adi_fecha2);
       
    return ln_return;
  end ;
  
  -- Dias Habiles del periodo
  function of_dias_habiles     ( 
           asi_origen         in origen.cod_origen%TYPE,
           asi_trabajador     in maestro.cod_trabajador%TYPE,
           adi_fec_proceso    in date,
           asi_tipo_planilla  in calculo.tipo_planilla%TYPE
  ) return number is
  
    ln_return                    number;
    ld_fecha1                    date;
    ld_fecha2                    date;
    ld_fecha                     date;
    ln_count                     number;
    ls_tipo_trabaj               tipo_trabajador.tipo_trabajador%TYPE;
    ld_fec_ingreso               maestro.fec_ingreso%TYPE;
    ld_fec_cese                  maestro.fec_cese%TYPE;
    
  begin
    -- Obtengo los datos del trabajador
    select tipo_trabajador, fec_ingreso, fec_cese
      into ls_tipo_trabaj, ld_fec_ingreso, ld_fec_cese
    from maestro m
    where m.cod_trabajador = asi_trabajador;
    
    -- Obtengo el rango de fecha
    select count(*)
      into ln_count
    from rrhh_param_org t
    where t.fec_proceso     = adi_fec_proceso
      and t.tipo_trabajador = ls_tipo_trabaj
      and t.tipo_planilla   = asi_tipo_planilla
      and t.origen          = asi_origen;
    
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No existe parametros de fecha de calculo para los datos ingresados'
                           || chr(13) || 'Fecha Calculo: ' || to_char(adi_fec_proceso, 'dd/mm/yyyy')
                           || chr(13) || 'Origen: ' || to_char(adi_fec_proceso, 'dd/mm/yyyy')
                           || chr(13) || 'Tipo Trabaj: ' || ls_tipo_trabaj
                           || chr(13) || 'Tipo Planilla: ' || asi_tipo_planilla);
    end if;
    
    select t.fec_inicio, t.fec_final
      into ld_fecha1, ld_fecha2
    from rrhh_param_org t
    where t.fec_proceso     = adi_fec_proceso
      and t.tipo_trabajador = ls_tipo_trabaj
      and t.tipo_planilla   = asi_tipo_planilla
      and t.origen          = asi_origen;
    
    ld_fecha := ld_fecha1;
    ln_return := 0;
    while ld_fecha <= ld_fecha2
    loop
      -- si el dia no es un domingo
      if to_char(ld_Fecha, 'D') <> '1'then
         -- Si el dia no es un feriado
         select count(*)
           into ln_count
           from calendario_feriado cf
          where cf.origen          = asi_origen
            and cf.mes             = to_number(to_char(ld_fecha, 'mm'))
            and cf.dia             = to_number(to_char(ld_fecha, 'dd'));
         
         if ln_count = 0 then
            ln_return := ln_return + 1;
         end if;
      end if;
      ld_fecha := ld_fecha + 1;
    end loop;
    
    return ln_return;
  end ;


  -- Dias de vacaciones que ha tenido en los días habiles
  function of_dias_habiles_vacaciones     ( 
           asi_origen         in origen.cod_origen%TYPE,
           asi_trabajador     in maestro.cod_trabajador%TYPE,
           adi_fec_proceso    in date,
           asi_tipo_planilla  in calculo.tipo_planilla%TYPE
  ) return number is
  
    ln_return                    number;
    ld_fecha1                    date;
    ld_fecha2                    date;
    ld_fecha                     date;
    ln_count                     number;
    ls_tipo_trabaj               tipo_trabajador.tipo_trabajador%TYPE;
    ld_fec_ingreso               maestro.fec_ingreso%TYPE;
    ld_fec_cese                  maestro.fec_cese%TYPE;
    
  begin
    -- Obtengo los datos del trabajador
    select tipo_trabajador, fec_ingreso, fec_cese
      into ls_tipo_trabaj, ld_fec_ingreso, ld_fec_cese
    from maestro m
    where m.cod_trabajador = asi_trabajador;
    
    -- Obtengo el rango de fecha
    select count(*)
      into ln_count
    from rrhh_param_org t
    where t.fec_proceso     = adi_fec_proceso
      and t.tipo_trabajador = ls_tipo_trabaj
      and t.tipo_planilla   = asi_tipo_planilla
      and t.origen          = asi_origen;
    
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No existe parametros de fecha de calculo para los datos ingresados'
                           || chr(13) || 'Fecha Calculo: ' || to_char(adi_fec_proceso, 'dd/mm/yyyy')
                           || chr(13) || 'Origen: ' || to_char(adi_fec_proceso, 'dd/mm/yyyy')
                           || chr(13) || 'Tipo Trabaj: ' || ls_tipo_trabaj
                           || chr(13) || 'Tipo Planilla: ' || asi_tipo_planilla);
    end if;
    
    select t.fec_inicio, t.fec_final
      into ld_fecha1, ld_fecha2
    from rrhh_param_org t
    where t.fec_proceso     = adi_fec_proceso
      and t.tipo_trabajador = ls_tipo_trabaj
      and t.tipo_planilla   = asi_tipo_planilla
      and t.origen          = asi_origen;
    
    -- Si ingreso despues entonces no cuento nada
    if ld_fec_ingreso > ld_fecha2 then return 0; end if;
    
    if ld_fec_ingreso > ld_fecha1 then
       ld_fecha1 := ld_fec_ingreso;
    end if;
    
    -- ahora con la fecha de cese
    if ld_fec_cese is not null then
       -- Si ceso antes del ingreso entonces tampoco lo cuento
       if ld_Fec_cese < ld_fecha1 then return 0; end if;
       
       if ld_fec_cese < ld_Fecha2 then
          ld_fecha2 := ld_fec_cese;
       end if;
    end if;
    
    if ld_fecha2 < ld_fecha1 then return 0; end if;
    
    ld_fecha := ld_fecha1;
    ln_return := 0;
    while ld_fecha <= ld_fecha2
    loop
      -- si el dia no es un domingo
      if to_char(ld_Fecha, 'D') <> '1'then
         -- Si el dia no es un feriado
         select count(*)
           into ln_count
           from calendario_feriado cf
          where cf.origen          = asi_origen
            and cf.mes             = to_number(to_char(ld_fecha, 'mm'))
            and cf.dia             = to_number(to_char(ld_fecha, 'dd'));
         
         if ln_count = 0 then
            -- Es un día habil, por lo que hay que verificar si ha estado en vacaciones
            select count(*)
              into ln_count
              from inasistencia i
             where i.cod_trabajador = asi_trabajador
               and trunc(ld_fecha) between trunc(i.fec_desde) and trunc(i.fec_hasta)
               and i.concep        in (Select * from table(SPLIT(PKG_CONFIG.USF_GET_PARAMETER('CONCEPTOS_VACACIONES', '1463'))));
            
            if ln_count > 0 then
               ln_return := ln_return + 1;
            end if;
         end if;
      end if;
      ld_fecha := ld_fecha + 1;
    end loop;
    
    return ln_return;
  end ;

  function of_total_dias_utilidad( 
           ani_periodo      in utl_distribucion.periodo%TYPE,
           ani_item         in utl_distribucion.item%TYPE
  ) return number is
  
    ln_return                    number;
    ld_Fecha1                    date;
    ld_fecha2                    date;
    ls_grp_afecto_utilidad       grupo_calculo.grupo_calculo%TYPE;
    ln_dias                      number;
    ln_dias_periodo              utl_distribucion.dias_periodo%TYPE;
    
    cursor c_datos is
       SELECT hc.COD_TRABAJADOR, 
              max(hc.tipo_trabajador) as tipo_trabajador 
         FROM HISTORICO_CALCULO HC,
              grupo_calculo_det gcd
        WHERE hc.concep         = gcd.concepto_calc
          and gcd.grupo_calculo = ls_grp_afecto_utilidad
          and to_number(TO_CHAR(HC.FEC_CALC_PLAN, 'YYYY')) = ani_periodo
          and hc.tipo_trabajador <> 'SER'
       group by hc.cod_trabajador;
    
  begin
    select t.dias_periodo
      into ln_dias_periodo
      from utl_distribucion t
     where t.periodo        = ani_periodo
       and t.item           = ani_item;  
  
    --Grupo de Calculo para la utilidad
    ls_grp_afecto_utilidad := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_AFECTO_UTILIDAD', '090');
    
    -- Parametros de días del periodo
    ld_Fecha1 := to_Date('01/01/' || trim(to_char(ani_periodo)), 'dd/mm/yyyy');
    ld_Fecha2 := to_Date('31/12/' || trim(to_char(ani_periodo)), 'dd/mm/yyyy');
    
    -- Obtengo los días de inasistencia
    ln_return := 0;
    for lc_reg in c_datos loop
        ln_dias := PKG_RRHH.of_dias_laborados (lc_reg.cod_trabajador, lc_reg.tipo_trabajador, ld_fecha1, ld_Fecha2) +
                   PKG_RRHH.of_dias_vacaciones(lc_reg.cod_trabajador, ld_fecha1, ld_Fecha2) +
                   PKG_RRHH.of_dias_subsidios (lc_reg.cod_trabajador, ld_fecha1, ld_Fecha2) +
                   PKG_RRHH.of_dias_permisos  (lc_reg.cod_trabajador, ld_fecha1, ld_Fecha2);
        
        if ln_dias > ln_dias_periodo then
           ln_dias := ln_dias_periodo;
        end if;
        
        if ln_dias >= 30 then
           ln_Return := ln_Return + ln_dias;
        end if;
    end loop;

    return ln_return;
  end ;
  
  function of_total_dias_utilidad( 
           asi_trabajador  in maestro.cod_trabajador%TYPE,
           ani_year        in number,
           ani_mes         in number
  ) return number is
  
    ld_Fecha1                    date;
    ld_fecha2                    date;
    ln_dias                      number;
    ln_dias_periodo              utl_distribucion.dias_periodo%TYPE;

    
  begin
    -- Parametros de días del periodo
    ld_Fecha1 := to_Date('01/' || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year)), 'dd/mm/yyyy');
    ld_Fecha2 := PKG_UTILITY.of_last_day(ani_year, ani_mes);
    
    ln_dias_periodo := ld_Fecha2 - ld_Fecha1 + 1;
  
    -- Obtengo los días de inasistencia
    ln_dias := PKG_RRHH.of_dias_laborados (asi_trabajador, ld_fecha1, ld_Fecha2) +
               PKG_RRHH.of_dias_vacaciones(asi_trabajador, ld_fecha1, ld_Fecha2) +
               PKG_RRHH.of_dias_subsidios (asi_trabajador, ld_fecha1, ld_Fecha2) +
               PKG_RRHH.of_dias_permisos  (asi_trabajador, ld_fecha1, ld_Fecha2);
        
    if ln_dias > ln_dias_periodo then
       ln_dias := ln_dias_periodo;
    end if;

    return ln_dias;
  end ;

  function of_total_dias_utilidad( 
           asi_trabajador  in maestro.cod_trabajador%TYPE,
           ani_periodo     in number
  ) return number is
  
    ld_Fecha1                    date;
    ld_fecha2                    date;
    ln_dias                      number;
    ln_dias_periodo              utl_distribucion.dias_periodo%TYPE;

    
  begin
    -- Parametros de días del periodo
    ld_Fecha1 := to_Date('01/01/' || trim(to_char(ani_periodo)), 'dd/mm/yyyy');
    ld_Fecha2 := to_Date('31/12/' || trim(to_char(ani_periodo)), 'dd/mm/yyyy');
    
    ln_dias_periodo := ld_Fecha2 - ld_Fecha1 + 1;
  
    -- Obtengo los días de inasistencia
    ln_dias := PKG_RRHH.of_dias_laborados (asi_trabajador, ld_fecha1, ld_Fecha2) +
               PKG_RRHH.of_dias_vacaciones(asi_trabajador, ld_fecha1, ld_Fecha2) +
               PKG_RRHH.of_dias_subsidios (asi_trabajador, ld_fecha1, ld_Fecha2) +
               PKG_RRHH.of_dias_permisos  (asi_trabajador, ld_fecha1, ld_Fecha2);
        
    if ln_dias > ln_dias_periodo then
       ln_dias := ln_dias_periodo;
    end if;

    return ln_dias;
  end ;  

  function of_total_remun_utilidad( 
           ani_periodo      in number
  ) return number is
  
    ln_return                    number;
    
    cursor c_datos is
      select hc.cod_trabajador,
             nvl(sum(hc.imp_soles * decode(substr(hc.concep,1,1), '1', 1, '2', -1, 0)),0) as importe
        from historico_calculo hc,
             grupo_calculo_det gcd
       where hc.concep = gcd.concepto_calc
         and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_periodo
         and gcd.grupo_calculo = is_grp_utilidad
         and hc.tipo_trabajador <> 'SER'
      group by hc.cod_trabajador;	
    
  begin
    ln_return := 0;
    -- Obtengo el total remunerado pero que sobrepasen los 30 días
    for lc_reg in c_datos loop
        if PKG_RRHH.of_total_dias_utilidad(lc_reg.cod_trabajador, ani_periodo) >= 30 then
           ln_Return := ln_return + lc_reg.importe;
        end if;
    end loop;
       
    return ln_return;
  end ;

  -- Obtengo el rmv minimo vital
  function of_get_rmv          ( 
           asi_tipo_trabaj    in maestro.cod_trabajador%TYPE,
           adi_fec_proceso    in date
  ) return number is
    ln_return number;
  begin
    select s.rmv 
      into ln_return
      from (select r.*
              from rmv_x_tipo_trabaj r 
             where r.fecha_desde <= trunc(adi_fec_proceso)
               and r.tipo_trabajador = asi_tipo_trabaj
            order by r.fecha_desde desc) s
     where rownum = 1;
    
    return ln_return;
  end;
  
  -- Obtengo el rmv minimo vital
  function of_get_uit          ( 
           ani_year           in number
  ) return number is
    ln_return number;
  begin
    select count(*)
      into ln_return
      from uit t
     where t.ano = ani_year;
   
    if ln_Return = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No existe la UIT para el año: ' || trim(to_char(ani_year, '0000')));
    end if;
    
    select t.importe
      into ln_return
      from uit t
     where t.ano = ani_year;
    
    return ln_return;
  end;
  
  function of_dias_asist_sin_domingo(
         asi_origen          in origen.cod_origen%TYPE,
         asi_codtra          in maestro.cod_trabajador%TYPE ,
         asi_tipo_trabaj     in tipo_trabajador.tipo_trabajador%TYPE,
         adi_fec_proceso     in date,
         asi_tipo_planilla   in calculo.tipo_planilla%TYPE
  )return number is

  ls_grp_dias_inasis         rrhhparam_cconcep.dias_inasis_dsccont%TYPE;
  ls_tipo_trabaj             maestro.tipo_trabajador%TYPE;
  ls_cnc_vacaciones          concepto.concep%TYPE;
  ln_dias                    number;
  ld_fec_desde               date ;
  ld_fec_hasta               date ;
  ln_dias_trabajados         number(4,2) ;
  ln_faltas                  number ;
  ln_count                   number;
  ld_fec_ing_trab            maestro.fec_ingreso%TYPE;
  ld_fec_cese                maestro.fec_cese%TYPE;
  ls_flag_tipo_sueldo        tipo_trabajador.flag_ingreso_boleta%TYPE;
  
  --  Cursor de inasistencias a descontar
  cursor c_inasistencias is
    select i.dias_inasist 
      from inasistencia i
     where i.cod_trabajador = asi_codtra
       and (i.concep in ( select d.concepto_calc
                           from grupo_calculo_det d
                          where d.grupo_calculo = ls_grp_dias_inasis ) 
            or i.concep = ls_cnc_vacaciones)    
       and trunc(i.fec_movim) between trunc(ld_fec_desde) and trunc(ld_fec_hasta)
       and i.flag_vacac_adelantadas = '0' ;

  begin

    --  ***********************************************************************
    --  ***   REALIZA CALCULO DE DIAS TRABAJADOS PARA CALCULO DE PLANILLA   ***
    --  ***********************************************************************

    -- Determinar si el pago es por jornal o fijo
    select t.flag_ingreso_boleta, t.tipo_trabajador
      into ls_flag_tipo_sueldo, ls_tipo_trabaj
      from tipo_trabajador t
     where t.tipo_trabajador = asi_tipo_trabaj;
     
    select c.dias_inasis_dsccont
      into ls_grp_dias_inasis
      from rrhhparam_cconcep c
     where c.reckey = '1' ;
    
    -- Obtengo el concepto de vacaciones
    select gc.concepto_gen
      into ls_cnc_vacaciones
      from grupo_calculo gc
     where gc.grupo_calculo = (select t.gan_fij_calc_vacac from rrhhparam_cconcep t);
    
    select count(*)
      into ln_count
     from rrhh_param_org p
     where p.origen          = asi_origen
       and p.tipo_trabajador = asi_tipo_trabaj
       and trunc(p.fec_proceso) = trunc(adi_fec_proceso)
       and p.tipo_planilla      = asi_tipo_planilla;

    if ln_count = 0 then
         RAISE_APPLICATION_ERROR(-20000, 'Error, no ha especificado parametros para el origen ' || asi_origen ||
                                         ', fecha proceso: ' || to_char(adi_fec_proceso, 'dd/mm/yyyy') ||
                                         ', tipo_trabajador: ' || asi_tipo_trabaj ||
                                         ', Tipo Planilla: ' || asi_tipo_planilla);
    end if;

    select trunc(t.fec_inicio), trunc(t.fec_final)
      into ld_fec_desde, ld_fec_hasta
      from rrhh_param_org t
     where trunc(t.fec_proceso) = trunc(adi_fec_proceso)
       and t.origen             = asi_origen
       and t.tipo_trabajador    = asi_tipo_trabaj
       and t.tipo_planilla      = asi_tipo_planilla;

    -- Obtengo la fecha de inicio de trabajo del trabajador
    select m.fec_ingreso, m.fec_cese
      into ld_fec_ing_trab, ld_fec_cese
      from maestro m
     where m.cod_trabajador = asi_codtra;
    
    if ld_fec_hasta < ld_fec_ing_trab then
       -- El trabajador ha ingresado despues del rango por lo que no corresponde nada
       return 0;
    end if;
    
    -- Verifico si la fecha de inicio de calculo es mayor o menor de la fecha de inicio de trabajo
    if ld_fec_desde < ld_fec_ing_trab then
       ld_fec_desde := ld_fec_ing_trab;
    end if;

    --Fecha de cese
    if ld_fec_cese is not null then
       if ld_fec_cese < ld_fec_desde then return 0; end if;
       if ld_fec_cese < ld_fec_hasta then
          ld_fec_hasta := ld_fec_cese;
       end if;
    end if;

    if ld_fec_desde > ld_fec_hasta then
       RAISE_APPLICATION_ERROR(-20000, 'Error, la fecha de inicio es mayor a la fecha de fin ' || asi_codtra);
    end if;
    
    if asi_tipo_trabaj = USP_SIGRE_RRHH.is_tipo_trip then
       
       if asi_tipo_planilla = 'B' then
          -- Calculo los dias fijos
          select nvl(sum(f.nro_dias),0)
            into ln_dias_trabajados 
            from fl_dias_motorista f
           where f.anio            = to_number(to_char(adi_fec_proceso, 'yyyy'))
             and f.mes             = to_number(to_char(adi_fec_proceso, 'mm'))
             and f.cod_motorista   = asi_codtra;
       else 
          -- Si el flag de bonificacion de pesca no esta activa entoces no lo calculo nada mas
          select count(distinct fa.fecha)
            into ln_dias_trabajados
            from fl_asistencia fa
           where fa.tripulante = asi_codtra
             and trunc(fa.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);
       end if;
       
    elsif asi_tipo_trabaj in (USP_SIGRE_RRHH.is_tipo_des, USP_SIGRE_RRHH.is_tipo_ser) then
    
       select count(distinct p.fec_parte)
         into ln_dias_trabajados
         from tg_pd_destajo p,
              tg_pd_destajo_det pd
        where p.nro_parte = pd.nro_parte
          and pd.cod_trabajador = asi_codtra
          and trunc(p.fec_parte) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta)
          and to_char(p.fec_parte, 'd') <> '1'
          and p.flag_estado <> '0';
        
    else
        IF ls_tipo_trabaj in (USP_SIGRE_RRHH.is_tipo_jor) or ls_flag_tipo_sueldo = 'J' THEN
           -- Dias Trabajados
           SELECT COUNT(DISTINCT a.fec_movim)
             INTO ln_dias_trabajados
             FROM asistencia a
            WHERE a.cod_trabajador = asi_codtra
              and to_char(a.fec_movim, 'd') <> '1'
              AND trunc(a.fec_movim) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           
        ELSE
           ln_faltas := 0 ;
           for rc_ina in c_inasistencias loop
             ln_faltas := ln_faltas + nvl(rc_ina.dias_inasist,0) ;
           end loop ;
           
           ln_dias := ld_fec_hasta - ld_fec_desde + 1;
           
           if to_char(adi_fec_proceso, 'mm') = '02' then 
              if trunc(ld_fec_hasta) = trunc(Last_day(adi_fec_proceso)) then
                 --ln_dias := trunc(usf_last_day(adi_fec_proceso)) - trunc(to_date('01/02/' || trim(to_char(adi_fec_proceso, 'yyyy')), 'dd/mm/yyyy')) + 1;
                 ln_dias := 30;
              end if;
           end if;
           
           if ln_dias > 30 then
              ln_dias := 30;
           end if;

           if ln_dias < ln_faltas then
              ln_dias_trabajados := 0;
           else
              ln_dias_trabajados := ln_dias - ln_faltas ;
           end if;

        END IF;
    end if;
    
    if ln_dias_trabajados > ln_dias then
       ln_dias_trabajados := ln_dias ;
    end if ;

    if ln_dias_trabajados > 30 then
       ln_dias_trabajados := 30;
    end if;

    return(nvl(ln_dias_trabajados,0)) ;

  end ;
  
  function of_string_dias_lab  ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 ani_year           in number,
                                 ani_mes            in number
  ) return varchar2 is
    ld_fecha1        date;
    ld_fecha2        date;
    ld_fecha         date;
    ln_dia           number;
    ln_dias_periodo  number;
    ln_count         number;
    ls_Result        varchar2(2000);
  begin
    ld_fecha1 := to_date('01/' || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year, '0000')), 'dd/mm/yyyy');
    ld_fecha2 := usf_last_day(ld_fecha1);
    
    ln_dias_periodo := ld_Fecha2 - ld_fecha1 + 1;
    
    ls_Result := '';
    
    FOR ln_dia IN 0..ln_dias_periodo - 1 LOOP
        ld_fecha := ld_fecha1 + ln_dia;
        
        select count(*)
          into ln_count
          from fl_asistencia fla
         where fla.tripulante = asi_trabajador
           and trunc(fla.fecha) = ld_fecha;
       
       if ln_count > 0 then
          ls_Result := ls_Result || trim(to_char(ld_fecha, 'dd')) || ', ';
       end if;
        
    end loop;
    
    if length(ls_Result) > 0 then
       ls_Result := substr(ls_Result, 1, length(ls_Result) - 2);
    end if;
    
    return ls_Result;
  end;
  
  function of_string_dias_no_lab  ( asi_trabajador     in maestro.cod_trabajador%TYPE,
                                 ani_year           in number,
                                 ani_mes            in number
  ) return varchar2 is
    ld_fecha1        date;
    ld_fecha2        date;
    ld_fecha         date;
    ln_dia           number;
    ln_dias_periodo  number;
    ln_count         number;
    ls_Result        varchar2(2000);
  begin
    ld_fecha1 := to_date('01/' || trim(to_char(ani_mes, '00')) || '/' || trim(to_char(ani_year, '0000')), 'dd/mm/yyyy');
    ld_fecha2 := usf_last_day(ld_fecha1);
    
    ln_dias_periodo := ld_Fecha2 - ld_fecha1 + 1;
    
    ls_Result := '';
    
    FOR ln_dia IN 0..ln_dias_periodo - 1 LOOP
        ld_fecha := ld_fecha1 + ln_dia;
        
        select count(*)
          into ln_count
          from fl_asistencia fla
         where fla.tripulante = asi_trabajador
           and trunc(fla.fecha) = ld_fecha;
       
       if ln_count = 0 then
          ls_Result := ls_Result || trim(to_char(ld_fecha, 'dd')) || ', ';
       end if;
        
    end loop;
    
    if length(ls_Result) > 0 then
       ls_Result := substr(ls_Result, 1, length(ls_Result) - 2);
    end if;
    
    return ls_Result;
  end;
                           
  procedure usp_calcula_utilidad ( 
    ani_periodo     in utl_distribucion.periodo%TYPE, 
    ani_item        in utl_distribucion.item%TYPE 
  ) is

    ln_count                  number;
    ls_grp_afecto_utilidad    grupo_calculo.grupo_calculo%TYPE;
    
    --utl_distribucion
    ln_tot_remun_ejer         utl_distribucion.tot_remun_ejer%TYPE;
    ln_tot_dias_ejer          utl_distribucion.tot_dias_ejer%TYPE;
    ln_remuneracion           utl_distribucion.utilidad_neta%TYPE;
    ln_utilidad_neta          utl_distribucion.utilidad_neta%TYPE;
    ln_porc_remuneracion      utl_distribucion.porc_remuneracion%TYPE;
    ln_porc_asistencia        utl_distribucion.porc_dias_laborados%TYPE;
    ln_utl_remun_distrib      utl_distribucion.utilidad_neta%TYPE;
    ln_utl_asist_distrib      utl_distribucion.utilidad_neta%TYPE;
    ln_dias_periodo           utl_distribucion.dias_periodo%TYPE;
    
    ln_diferencia             number;
    ls_trabajador             maestro.cod_trabajador%TYPE;              
    
    --utl_movim_general
    ln_utl_remuneracion       utl_movim_general.utl_remuneracion%TYPE;
    ln_utl_asistencia         utl_movim_general.utl_asistencia%TYPE;
    ln_total_utl_rem          utl_movim_general.utl_asistencia%TYPE;
    ln_total_utl_dias         utl_movim_general.utl_asistencia%TYPE;
    ln_dias_total             utl_movim_general.dias_total%TYPE;
    ln_dias_subsidiados       utl_movim_general.dias_subsidiados%TYPE;
    ln_dias_laborados         utl_movim_general.dias_laborados%TYPE;
    ln_dias_permiso           utl_movim_general.dias_permiso%TYPE;
    ln_dias_vacaciones        utl_movim_general.dias_vacaciones%TYPE;
    ln_dias_inasistencia      utl_movim_general.dias_inasist%TYPE;
               

    
    ld_fecha1                 date;
    ld_fecha2                 date;


    --  Lectura del maestro de trabajadores para calculo de utilidades
    cursor c_maestro is
      select distinct 
             m.cod_trabajador, m.fec_ingreso, m.fec_cese,
             m.cod_origen,
             m.porc_jud_util, max(hc.tipo_trabajador) as tipo_trabajador
      from maestro m,
           historico_calculo hc,
           grupo_calculo_det gcd
      where m.cod_trabajador   = hc.cod_trabajador
        and hc.concep          = gcd.concepto_calc
        and gcd.grupo_calculo  = ls_grp_afecto_utilidad
        and to_number(to_char(hc.fec_calc_plan,'yyyy')) = ani_periodo
        --and hc.cod_trabajador  = '20012514'
        and hc.tipo_trabajador <> 'SER'
      group by  m.cod_trabajador, m.fec_ingreso, m.fec_cese,
             m.porc_jud_util, m.cod_origen
      order by m.cod_trabajador ;

  begin

    --  *******************************************************************
    --  ***   CALCULO DE DISTRIBUCION POR PARTICIPACION DE UTILIDADES   ***
    --  *******************************************************************

    --Grupo de Calculo para la utilidad
    ls_grp_afecto_utilidad := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_AFECTO_UTILIDAD', '090');

    select count(*) 
      into ln_count 
      from utl_distribucion d
      where d.periodo = ani_periodo 
        and d.item    = ani_item;
      
    if ln_count = 0 then
      raise_application_error (-20000, 'Registre informacion para proceso de Utilidades') ;
    end if ;

    select u.porc_remuneracion, u.porc_dias_laborados,
           u.utilidad_neta, u.dias_periodo
      into ln_porc_remuneracion, ln_porc_asistencia,
           ln_utilidad_neta, ln_dias_periodo
      from utl_distribucion u 
      where u.periodo = ani_periodo
        and u.item    = ani_item;
    
    -- Elimino el historico
    delete utl_movim_general t
     where t.periodo = ani_periodo
       and t.item    = ani_item;
    
    
    -- Calculo de dias totales de asistencia
    ln_tot_dias_ejer := PKG_RRHH.of_total_dias_utilidad(ani_periodo, ani_item);
       
    if ln_tot_dias_ejer = 0 then return; end if;
       
    update utl_distribucion t
       set t.tot_dias_ejer = ln_tot_dias_ejer
     where t.periodo       = ani_periodo
       and t.item          = ani_item;
    
    -- Actualizo el total de la remuneracion
    ln_tot_remun_ejer := PKG_RRHH.of_total_remun_utilidad(ani_periodo);
       
    if ln_tot_remun_ejer = 0 then return; end if;
       
    update utl_distribucion t
       set t.tot_remun_ejer = ln_tot_remun_ejer
     where t.periodo       = ani_periodo
       and t.item          = ani_item;

    
    -- Fecha del periodo
    ld_fecha1 := to_date('01/01/' || trim(to_char(ani_periodo)), 'dd/mm/yyyy');
    ld_fecha2 := to_date('31/12/' || trim(to_char(ani_periodo)), 'dd/mm/yyyy');
    
    -- Calculo el importe
    ln_utl_remun_distrib := ln_utilidad_neta * ln_porc_remuneracion / 100;
    ln_utl_asist_distrib := ln_utilidad_neta * ln_porc_asistencia / 100;
    
    --  Determina remuneraciones y dias efectivos del ejercicio por trabajador
    for lc_reg in c_maestro loop
      
        -- Obtengo los días de asistencia
        ln_dias_laborados      := PKG_RRHH.of_dias_laborados    (lc_reg.cod_trabajador, lc_reg.tipo_trabajador, ld_fecha1, ld_fecha2);
        ln_dias_subsidiados    := PKG_RRHH.of_dias_subsidios    (lc_reg.cod_trabajador, ld_fecha1, ld_fecha2);
        ln_dias_permiso        := PKG_RRHH.of_dias_permisos     (lc_reg.cod_trabajador, ld_fecha1, ld_fecha2);
        ln_dias_vacaciones     := PKG_RRHH.of_dias_vacaciones   (lc_reg.cod_trabajador, ld_fecha1, ld_fecha2);
        ln_dias_inasistencia   := PKG_RRHH.of_dias_inasistencia (lc_reg.cod_trabajador, ld_fecha1, ld_fecha2);

        ln_dias_total := ln_dias_laborados + ln_dias_subsidiados + ln_dias_permiso + ln_dias_vacaciones;
        
        if ln_dias_total > ln_dias_periodo then
           ln_dias_total := ln_dias_periodo;
        end if;
        
        if ln_dias_total >= 30 then
           -- calculo la utilidad por los días
           ln_utl_asistencia := ln_utl_asist_distrib * ln_dias_total / ln_tot_dias_ejer;
         
           -- Obtengo el total pagado, que esta afecto a utilidades
           select nvl(sum(hc.imp_soles * decode(substr(hc.concep,1,1), '1', 1, '2', -1, 0)),0)
             into ln_remuneracion
             from historico_calculo hc,
                  grupo_calculo_det gcd
            where hc.concep         = gcd.concepto_calc
              and to_number(to_char(hc.fec_calc_plan, 'yyyy' )) = ani_periodo
              and hc.cod_trabajador = lc_reg.cod_trabajador
              and gcd.grupo_calculo = ls_grp_afecto_utilidad;
           
           ln_utl_remuneracion := ln_utl_remun_distrib * ln_remuneracion / ln_tot_remun_ejer;
         
           if ln_utl_remuneracion <0 then 
              ln_utl_remuneracion := 0;
           end if;
         
           if ln_utl_asistencia <0 then 
              ln_utl_asistencia := 0;
           end if;

           -- Inserto los días
           if ln_utl_remuneracion > 0 or ln_utl_asistencia > 0 then
               insert into utl_movim_general(
                      periodo, item, proveedor, tipo_trabajador, pagos, utl_remuneracion, 
                      dias_total, utl_asistencia, utl_total, 
                      dias_laborados, dias_subsidiados, dias_permiso, dias_vacaciones, dias_inasist, 
                      dias_domingo, dias_feriado, dsctos, cod_origen)
               values(
                      ani_periodo, ani_item, lc_reg.cod_trabajador, lc_reg.tipo_trabajador, ln_remuneracion, ln_utl_remuneracion,
                      ln_dias_total, ln_utl_asistencia, ln_utl_remuneracion + ln_utl_asistencia,
                      ln_dias_laborados, ln_dias_subsidiados, ln_dias_permiso, ln_dias_vacaciones, ln_dias_inasistencia, 
                        0, 0, 0, lc_reg.cod_origen);
           end if;
        end if;
         
    end loop ;


    --  Ajuste de pagos de utilidades al ultimo trabajador
    select nvl(sum(t.utl_remuneracion),0), nvl(sum(t.utl_asistencia),0)
      into ln_total_utl_rem, ln_total_utl_dias
      from utl_movim_general t
     where t.periodo = ani_periodo
       and t.item    = ani_item;
    
    if ln_total_utl_rem <> ln_utl_remun_distrib then
       ln_diferencia := ln_utl_remun_distrib - ln_total_utl_rem;
       
       -- Obtengo el proveedor con el importe mas alto
       select s.proveedor
         into ls_trabajador
         from (select proveedor, u.utl_remuneracion
                 from utl_movim_general u
                where u.periodo = ani_periodo
                  and u.item    = ani_item
               order by u.utl_remuneracion desc) s
        where rownum = 1;
               
       -- Lo actualizo a la tabla
       update utl_movim_general t
          set t.utl_remuneracion = t.utl_remuneracion + ln_diferencia
        where t.periodo = ani_periodo
          and t.item    = ani_item
          and t.proveedor = ls_trabajador;
          
    end if;
    
    if ln_total_utl_dias <> ln_utl_asist_distrib then
       ln_diferencia := ln_utl_asist_distrib - ln_total_utl_dias;
       
       -- Obtengo el proveedor con el importe mas alto
       select s.proveedor
         into ls_trabajador
         from (select proveedor, u.utl_asistencia
                 from utl_movim_general u
                where u.periodo = ani_periodo
                  and u.item    = ani_item
               order by u.utl_asistencia desc) s
        where rownum = 1;
               
       -- Lo actualizo a la tabla
       update utl_movim_general t
          set t.utl_asistencia = t.utl_asistencia + ln_diferencia
        where t.periodo = ani_periodo
          and t.item    = ani_item
          and t.proveedor = ls_trabajador;
          
    end if;
    
    update utl_movim_general u
       set u.utl_total = u.utl_asistencia + u.utl_remuneracion
     where u.periodo = ani_periodo
       and u.item    = ani_item
       and u.utl_total <> u.utl_asistencia + u.utl_remuneracion;
    
    -- Hago el commit
    commit;
  end ;


  procedure usp_rh_asiento_prov_cts(
    asi_origen      in origen.cod_origen%type ,
    asi_ttrab       in tipo_trabajador.tipo_trabajador%type ,
    asi_usuario     in usuario.cod_usr%type   ,
    ani_year        in cntbl_asiento.ano%TYPE,
    ani_mes         in cntbl_asiento.mes%TYPE
  ) is

    ln_tasa_cambio     calendario.cmp_dol_libre%type    ;
    
    -- Cntbl_asiento_det
    ln_item            cntbl_asiento_det.item%TYPE      ;
    
    -- Cntbl_asiento
    ln_tot_soldeb      cntbl_Asiento.Tot_Soldeb%TYPE    ;
    ln_tot_doldeb      cntbl_Asiento.Tot_Doldeb%TYPE    ;
    ln_tot_solhab      cntbl_Asiento.Tot_Solhab%TYPE    ;
    ln_tot_dolhab      cntbl_asiento.tot_dolhab%TYPE    ;
    ln_nro_Asiento     cntbl_asiento.nro_asiento%TYPE   ;
    ls_desc_glosa      cntbl_Asiento.Desc_Glosa%TYPE    ;
    
    
    -- Cntbl_libro
    ln_nro_libro       cntbl_libro.nro_libro%type       ;
    
    ls_cnta_debe       cntbl_cnta.cnta_ctbl%type        ;
    ls_cnta_haber      cntbl_cnta.cnta_ctbl%type        ;
    ln_count           number;
    


    --  Personal activo para generacion de asientos
    Cursor c_cabecera is
      select distinct
             c.fec_proceso,
             t.desc_tipo_tra
        from maestro              m, 
             cts_decreto_urgencia c,
             tipo_trabajador      t
       where m.cod_trabajador     = c.cod_trabajador     
         and t.tipo_trabajador    = c.tipo_trabajador
         and m.cod_origen         = asi_origen            
         and c.tipo_trabajador    = asi_ttrab             
         and c.liquidacion        > 0                   
         and to_number(to_char(c.fec_proceso, 'yyyy')) = ani_year
         and to_number(to_char(c.fec_proceso, 'mm'))   = ani_mes
      order by 1;
    
    Cursor c_datos(ad_fec_proceso  in date) is
      select m.cod_trabajador, 
             m.tipo_trabajador, 
             decode(c.cencos, null, m.cencos, c.cencos) as cencos,
             c.liquidacion as imp_soles,
             m.centro_benef,
             c.fec_proceso
        from maestro              m, 
             cts_decreto_urgencia c
       where m.cod_trabajador     = c.cod_trabajador     
         and m.cod_origen         = asi_origen            
         and c.tipo_trabajador    = asi_ttrab             
         and c.liquidacion        > 0                   
         and trunc(c.fec_proceso) = trunc(ad_fec_proceso)
      order by m.cod_seccion, m.cencos, m.cod_trabajador ;


    begin

    --Recupero nro de libro de cts por tipo de trbajador
    select t.cnta_ctbl_cts_cargo, t.cnta_ctbl_cts_abono, 
           t.libro_prov_cts 
      into ls_cnta_debe, ls_cnta_haber ,
           ln_nro_libro 
      from tipo_trabajador t
     where t.tipo_trabajador = asi_ttrab ;

    if ln_nro_libro is null or ln_nro_libro = 0 then
       Raise_Application_Error(-20000,'Nro de Libro no esta Asignado al tipo de trabajador ,Comuniquese con RRHH!') ;
    end if ;

    --  Elimina movimiento de asiento contable generado
    delete cntbl_Asiento_det cad
     where cad.origen        = asi_origen
       and cad.ano           = ani_year
       and cad.mes           = ani_mes
       and cad.nro_libro     = ln_nro_libro;
    
    delete cntbl_Asiento ca
     where ca.origen        = asi_origen
       and ca.ano           = ani_year
       and ca.mes           = ani_mes
       and ca.nro_libro     = ln_nro_libro;
    
    select count(*)
      into ln_count
      from cntbl_libro_mes clm
     where clm.origen      = asi_origen
       and clm.nro_libro   = ln_nro_libro
       and clm.ano         = ani_year
       and clm.mes         = ani_mes;
    
    if ln_count = 0 then
       insert into cntbl_libro_mes(
              origen, nro_libro, ano, mes, nro_asiento, flag_replicacion)
       values(
              asi_origen, ln_nro_libro, ani_year, ani_mes, 1, '1');
    end if;
    
    -- Reinicio el numerador de asiento en 1
    ln_nro_Asiento := 1;
    
    -- Recorro el bucle de la cabecera
    for lc_reg1 in c_cabecera loop

        --RECUPERO TIPO DE CAMBIO DE ACUERDO A FECHA DE PROCESO
        ln_tasa_cambio := usf_fin_tasa_cambio(lc_reg1.fec_proceso) ;

        if ln_tasa_cambio = 0 then
           Raise_Application_Error(-20000,'Fecha de Proceso ' || to_char(lc_reg1.fec_proceso, 'dd/mm/yyyy') || ' No tiene tipo de Cambio ,Comuniquese con Contabilidad!') ;
        end if ;
        
        -- generar una glosa al asiento
        ls_desc_glosa := 'ASIENTO DE PROVISION DE CTS ' || to_Char(lc_reg1.fec_proceso, 'dd/mm/yyyy') || ' TIPO TRABAJADOR: ' || lc_reg1.desc_tipo_tra;

        --inserta asiento unico de cabecera
        Insert Into cntbl_asiento(
               origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, desc_glosa, fecha_cntbl,
               fec_registro, 
               cod_usr, flag_estado, flag_tabla,
               tot_soldeb,
               tot_solhab,
               tot_doldeb,
               tot_dolhab,
               flag_replicacion)
        Values(
               asi_origen, ani_year, ani_mes, ln_nro_libro, ln_nro_Asiento,
               PKG_LOGISTICA.is_soles,
               ln_tasa_cambio,
               ls_desc_glosa,
               lc_reg1.fec_proceso,
               sysdate,
               asi_usuario,
               '1',
               'D',
               0,
               0,
               0,
               0,
               '1');
        
        --contador de detalles de pre asientos
        ln_item := 0;

        For lc_reg2 in c_datos(lc_reg1.fec_proceso) Loop
            
            /*
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
                     asi_flag_ctrl_debh in cntbl_asiento_det.flag_debhab%TYPE     ,
                     asi_flag_debhab    in cntbl_asiento_det.flag_debhab%TYPE     ,
                     asi_glosa_det      in cntbl_pre_asiento_det.det_glosa%TYPE   ,
                     ani_imp_soles      in cntbl_pre_asiento_det.imp_movsol%type  ,
                     ani_imp_dolares    in cntbl_pre_asiento_det.imp_movsol%type  ,
                     asi_concep         in concepto.concep%type                   ,
                     asi_cbenef         in maestro.centro_benef%type              ,
                     asi_cod_trabajador in maestro.cod_trabajador%TYPE
              );
            */
            -- Inserto el debe primero
            USP_SIGRE_CNTBL.SP_INSERT_ASIENTO(asi_origen,
                                              ani_year,
                                              ani_mes,
                                              ln_nro_libro,
                                              ln_nro_Asiento,
                                              ln_item,
                                              lc_reg1.fec_proceso,
                                              lc_reg2.cencos,
                                              ls_cnta_debe,
                                              null                  ,
                                              null                  ,
                                              lc_reg2.cod_trabajador ,
                                              null,
                                              '1',  -- No invertir los flag deb/hab
                                              'D',
                                              null,
                                              Abs(lc_reg2.imp_soles) ,
                                              Abs(lc_reg2.imp_soles / ln_tasa_cambio) ,
                                              null                  ,
                                              lc_reg2.centro_benef   ,
                                              lc_reg2.cod_trabajador);

            --INSERTA ASIENTO
            USP_SIGRE_CNTBL.SP_INSERT_ASIENTO(asi_origen,
                                              ani_year,
                                              ani_mes,
                                              ln_nro_libro,
                                              ln_nro_Asiento,
                                              ln_item,
                                              lc_reg1.fec_proceso,
                                              lc_reg2.cencos,
                                              ls_cnta_haber,
                                              null                  ,
                                              null                  ,
                                              lc_reg2.cod_trabajador ,
                                              null,
                                              '1',  -- No invertir los flag deb/hab
                                              'H',
                                              null,
                                              Abs(lc_reg2.imp_soles) ,
                                              Abs(lc_reg2.imp_soles / ln_tasa_cambio) ,
                                              null                  ,
                                              lc_reg2.centro_benef   ,
                                              lc_reg2.cod_trabajador);
        End Loop;


        --INSERTA TOTALES DE ASIENTO
        --suma total de detalle del debe
        select nvl(Sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)), 0),
               nvl(Sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)), 0),
               nvl(Sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)), 0),
               nvl(Sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)), 0)
          into ln_tot_soldeb,
               ln_tot_solhab,
               ln_tot_doldeb,
               ln_tot_dolhab
          from cntbl_asiento_det cad
         where cad.origen        = asi_origen
           and cad.ano           = ani_year
           and cad.mes           = ani_mes
           and cad.nro_libro     = ln_nro_libro
           and cad.nro_asiento   = ln_nro_Asiento;



        --Actualiza totales de asiento
        Update cntbl_asiento ca
          set ca.tot_soldeb = ln_tot_soldeb,
              ca.tot_solhab = ln_tot_solhab,
              ca.tot_doldeb = ln_tot_doldeb,
              ca.tot_dolhab = ln_tot_dolhab
         where ca.origen        = asi_origen
           and ca.ano           = ani_year
           and ca.mes           = ani_mes
           and ca.nro_libro     = ln_nro_libro
           and ca.nro_asiento   = ln_nro_Asiento;




        --ACTUALIZA NUMERADOR DE LIBRO CONTABLE
        --incrementa contador de Asiento
        ln_nro_asiento := ln_nro_asiento + 1;

        Update cntbl_libro_mes clm
           set clm.nro_asiento  = ln_nro_Asiento
         Where clm.origen     = asi_origen
           and clm.nro_libro  = ln_nro_libro
           and clm.ano        = ani_year
           and clm.mes        = ani_mes;

    end loop;

  end;

  
  -- Procedure para distribuir la asignacion familiar
  procedure sp_ajustar_asig_familiar(
    ani_year        in cntbl_asiento.ano%TYPE,
    ani_mes         in cntbl_asiento.mes%TYPE,
    asi_flag_ajuste in varchar2
  ) is
    
    ln_rmv             rmv_x_tipo_trabaj.rmv%TYPE;
    ln_importe_af      historico_calculo.imp_soles%TYPE;
    ln_diferencia      historico_calculo.imp_soles%TYPE;
    ln_dif_row         historico_calculo.imp_soles%TYPE;
    ln_tasa_cambio     calendario.vta_dol_prom%TYPE;
    ld_Fec_proceso     historico_calculo.fec_calc_plan%TYPE;
    ls_tipo_planilla   historico_calculo.tipo_planilla%TYPE;
    ln_item            historico_calculo.item%TYPE;
    ls_concepto        historico_calculo.concep%TYPE;
    ln_cant_fechas     number;
    
    ln_imp_sol         historico_calculo.imp_soles%TYPE;
    ln_imp_dol         historico_calculo.imp_dolar%TYPE;
    ln_dif_sol         historico_calculo.imp_soles%TYPE;
    ln_dif_dol         historico_calculo.imp_dolar%TYPE;
    

    --  Personal activo para generacion de asientos
    Cursor c_datos is
      select distinct
             hc.cod_trabajador,
             hc.CONCEP, 
             hc.fec_calc_plan,
             hc.TIPO_PLANILLA, 
             hc.ITEM,
             hc.tipo_trabajador,
             hc.imp_soles
        from historico_calculo hc
       where to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
         and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
         and hc.concep                                    = is_cnc_asig_familiar
         --and hc.cod_trabajador = '20007019'
      order by 1, 2, 3;
    
    Cursor c_Trabajadores is
      select distinct
             hc.cod_trabajador,
             hc.tipo_trabajador
        from historico_calculo hc
       where to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
         and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
         and hc.concep                                    = is_cnc_asig_familiar
         --and hc.cod_trabajador = '20007019'
      group by hc.cod_trabajador, hc.tipo_trabajador;
    
    Cursor c_ajustes is
      select hc.cod_trabajador,
             hc.tipo_trabajador,
             sum(hc.dif_soles) as dif_soles
        from historico_calculo hc
       where to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
         and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
         and hc.concep                                    = is_cnc_asig_familiar
         --and hc.cod_trabajador = '20007019'
      group by hc.cod_trabajador, hc.tipo_trabajador;
      
  begin
     update historico_calculo hc
        set hc.dif_soles  = 0,
            hc.dif_dolar  = 0
      where to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
        and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
        and (hc.dif_soles <> 0 or hc.dif_dolar <> 0);
        
     if asi_flag_ajuste = '1' then
         for lc_reg in c_datos loop
             -- Primero tengo que obtener cuanto es la RMV
             ln_rmv := PKG_RRHH.of_get_rmv(lc_reg.tipo_trabajador, lc_reg.fec_calc_plan);
             
             -- Obtengo el tipo de cambio
             ln_tasa_cambio := usf_fin_tasa_cambio(lc_reg.fec_calc_plan);
             
             -- Obtengo el importe total de asignacion familiar que ha percibido en el mes
             select sum(hc.imp_soles), count(distinct hc.fec_calc_plan)
               into ln_importe_af, ln_cant_fechas
               from historico_calculo hc
              where hc.cod_trabajador = lc_reg.cod_trabajador
                and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
                and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
                and hc.concep                                    = is_cnc_asig_familiar;
             
             -- Verifico si hay diferencia
             ln_diferencia := ln_rmv / 10 - ln_importe_af;
             
             -- Prorrateo la diferencia con el importe
             ln_dif_row := ln_diferencia / ln_importe_af * lc_reg.imp_soles;
             
             -- Actualizo la diferencia         
             update historico_calculo hc
                 set hc.dif_soles  = ln_dif_row,
                     hc.dif_dolar  = ln_dif_row / ln_tasa_cambio
               where hc.cod_trabajador = lc_reg.cod_trabajador
                 and hc.CONCEP         = is_cnc_asig_familiar
                 and hc.fec_calc_plan  = lc_reg.fec_calc_plan
                 and hc.TIPO_PLANILLA  = lc_reg.tipo_planilla
                 and hc.ITEM           = lc_reg.item;
             
         end loop;
         
         for lc_reg in c_Trabajadores loop
             -- Hago un ajuste final para que se cumplan el minimo mensual de ASIGNACION FAMILIAR
             -- Obtengo la minima fecha de proceso de historico de calculo
             select min(hc.fec_calc_plan), sum(hc.imp_soles + hc.dif_soles), sum(hc.imp_dolar + hc.dif_dolar)
               into ld_fec_proceso, ln_imp_sol, ln_imp_dol
               from historico_calculo hc
              where hc.cod_trabajador  = lc_reg.cod_trabajador
                and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
                and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
                and hc.concep                                    = is_cnc_asig_familiar;
             
             -- Obtengo que obtener cuanto es la RMV
             ln_rmv := PKG_RRHH.of_get_rmv(lc_reg.tipo_trabajador, ld_fec_proceso) ;
             
             -- Obtengo el tipo de cambio
             ln_tasa_cambio := usf_fin_tasa_cambio(ld_fec_proceso);
             
             ln_dif_sol := ln_rmv / 10 - ln_imp_sol;
             ln_dif_dol := (ln_rmv / 10) / ln_tasa_cambio - ln_imp_dol;
             
             if ln_dif_sol <> 0 or ln_dif_dol <> 0 then
                -- Obtengo el item con la mayor contidad de diferencia
                select hc.fec_calc_plan, hc.tipo_planilla, hc.item
                  into ld_Fec_proceso, ls_tipo_planilla, ln_item
                  from historico_calculo hc
                 where hc.cod_trabajador  = lc_reg.cod_trabajador
                   and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
                   and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
                   and hc.concep = is_cnc_asig_familiar
                   and rownum    = 1
                order by hc.imp_soles desc;
                       
                 -- Actulizo la diferencia
                 update historico_calculo hc
                     set hc.dif_soles  = hc.dif_soles + ln_dif_sol,
                         hc.dif_dolar  = hc.dif_dolar + ln_dif_dol
                   where hc.cod_trabajador = lc_reg.cod_trabajador
                     and hc.CONCEP         = is_cnc_asig_familiar
                     and hc.fec_calc_plan  = ld_Fec_proceso
                     and hc.TIPO_PLANILLA  = ls_tipo_planilla
                     and hc.ITEM           = ln_item;
                 
             end if;             
         end loop;
         
         
         -- Ahora ya con la diferencia obtenida correctamente voy a ajustar el concepto de ingreso
         -- que sea el menor en el codigo de concepto
         for lc_reg in c_ajustes loop
             if lc_reg.dif_soles <> 0 then
                -- Obtengo el item con la mayor contidad de diferencia
                select hc.fec_calc_plan, hc.tipo_planilla, hc.item, hc.concep
                  into ld_Fec_proceso, ls_tipo_planilla, ln_item, ls_concepto
                  from historico_calculo hc
                 where hc.cod_trabajador  = lc_reg.cod_trabajador
                   and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
                   and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
                   and hc.concep not in (is_cnc_asig_familiar, '1499')
                   and hc.concep like '1%'
                   and rownum    = 1
                   and hc.imp_soles > lc_reg.dif_soles
                order by hc.imp_soles desc;
                   
                 -- Actulizo la diferencia
                 update historico_calculo hc
                     set hc.dif_soles  = hc.dif_soles - lc_reg.dif_soles,
                         hc.dif_dolar  = hc.dif_dolar - lc_reg.dif_soles / ln_tasa_cambio
                   where hc.cod_trabajador = lc_reg.cod_trabajador
                     and hc.CONCEP         = ls_concepto
                     and hc.fec_calc_plan  = ld_Fec_proceso
                     and hc.TIPO_PLANILLA  = ls_tipo_planilla
                     and hc.ITEM           = ln_item;
             
             end if;
         end loop;
     end if;   
     
     commit;

  end;

  procedure sp_cal_quinta_categ_sueldo (
      asi_codtra          in maestro.cod_trabajador%TYPE,
      adi_fec_proceso     in date,
      ani_tipcam          in number,
      asi_origen          in origen.cod_origen%TYPE,
      ani_dias_trabaj     IN NUMBER,
      asi_tipo_planilla   in calculo.tipo_planilla%TYPE
  ) is

  ls_grp_quinta_categ    grupo_calculo.grupo_calculo%TYPE ;
  ls_grp_ganan_imprec    grupo_calculo.grupo_calculo%TYPE ;
  ls_grp_gratif_jul      grupo_calculo.grupo_calculo%TYPE ;
  ls_grp_gratif_dic      grupo_calculo.grupo_calculo%TYPE ;
  ls_flag_reg_laboral    maestro.flag_reg_laboral%TYPE;

  ln_count               number ;
  ls_cnc_ret_quinta      concepto.concep%TYPE ;
  ls_cnc_ret_quinta_man  concepto.concep%TYPE := '2204';

  -- Quinta Categoria
  ln_acu_imprecisa       quinta_categoria.rem_imprecisa%TYPE ;
  ln_acu_retencion       quinta_categoria.rem_retencion%TYPE ;
  ln_acu_sueldo          quinta_categoria.sueldo%TYPE ;
  ln_ganancias_ext       quinta_categoria.rem_externa%TYPE;
  ln_retencion_ext       quinta_categoria.rem_retencion%TYPE;


  -- Otros
  ln_gratificacion       number(13,2) ;

  ln_rem_precisa         quinta_categoria.rem_proyectable%TYPE; 
  ln_rem_imprecisa       quinta_categoria.rem_imprecisa%TYPE;
  ln_rem_gratif          calculo.imp_soles%TYPE;

  ln_sueldo_proy         number(13,2) ;
  ln_retencion           quinta_categoria.rem_retencion%TYPE;
  ln_imp_calculo         calculo.imp_soles%TYPE;

  lc_flag_estado         concepto.flag_estado%type ;
  ln_UIT                 UIT.IMPORTE%TYPE;
  ln_base_imponible      historico_calculo.imp_soles%TYPE;
  ln_base_imponible1     historico_calculo.imp_soles%TYPE;
  ln_base_imponible2     historico_calculo.imp_soles%TYPE;
  ln_porc_ret_bi02       rrhh_impuesto_renta.tasa%TYPE;


  ln_importe             NUMBER;
  ln_soles_ret           calculo.imp_soles%TYPE;
  ln_dolar_ret           calculo.imp_dolar%TYPE;
  ln_meses_proy          number(2) := 0;
  ln_meses_divide        number(2) := 0;
  ln_mes                 number(2) := 0;
  ln_ret_dscto_fijo      gan_desct_fijo.imp_gan_desc%TYPE;
  ls_grp_vacaciones      grupo_calculo.grupo_calculo%TYPE;


  --  Cursor que determina los porcentajes y los topes de retencion
  cursor c_topes is
  select r.secuencia, r.tasa, r.tope_ini, r.tope_fin
    from rrhh_impuesto_renta r
    where adi_fec_proceso between r.fecha_vig_ini and r.fecha_vig_fin
    order by r.secuencia ;

  begin
    
    --  **************************************************************
    --  ***   REALIZA CALCULO DE QUINTA CATEGORIA POR TRABAJADOR   ***
    --  **************************************************************
    -- Busco el UIT de acuerdo a la fecha
    SELECT COUNT(*)
      INTO ln_count
      FROM uit t
     WHERE trunc(fec_ini_vigen) <= trunc(adi_fec_proceso);

    IF ln_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20000, '"NO HA ESPECIFICADO LA UIT PARA EL AÑO ' || to_char(adi_fec_proceso, 'YYYY'));
    END IF;

    SELECT importe
      INTO LN_UIT
      FROM (SELECT t.importe
              FROM UIT T
             WHERE TRUNC(FEC_INI_VIGEN) <= TRUNC(ADI_FEC_PROCESO)
             ORDER BY t.ano DESC, t.fec_ini_vigen DESC)
     WHERE ROWNUM = 1;
    
    select m.flag_reg_laboral
      into ls_flag_reg_laboral
      from maestro m
     where m.cod_trabajador = asi_codtra;
    
    -- Calculo de la base imponible, que vendria a ser 7 veces la UIT
    ln_base_imponible := ln_UIT * 7;

    -- Obtengo los parametros necesarios para trabajar
    select c.quinta_cat_proyecta, c.quinta_cat_imprecisa, c.grati_medio_ano, c.grati_fin_ano
      into ls_grp_quinta_categ, ls_grp_ganan_imprec, ls_grp_gratif_jul, ls_grp_gratif_dic
      from rrhhparam_cconcep c
      where c.reckey = '1' ;

    -- Obtengo el estado del concepto de Retencion de Quinta Categoria
    select count(*)
      into ln_count
      from grupo_calculo g
     where g.grupo_calculo = ls_grp_quinta_categ ;

    IF ln_count = 0 THEN RETURN; END IF;

    select con.flag_estado, con.concep
      into lc_flag_estado, ls_cnc_ret_quinta
      from concepto con
     where con.concep in ( select g.concepto_gen
                             from grupo_calculo g
                            where g.grupo_calculo = ls_grp_quinta_categ) ;

    -- Si el concepto esta anulado entonces no tengo nada mas que hacer
    if lc_flag_estado = '0'  then return; end if ;
    
    ls_grp_vacaciones     := PKG_CONFIG.USF_GET_PARAMETER('RRHH_GRUPO_VACACIONES', '067');
    
     --  Acumula importes a la fecha en el periodo
     select NVL(SUM(q.rem_externa),0) + NVL(SUM(q.rem_imprecisa),0) + NVL(SUM(q.rem_gratif),0), NVL(SUM(q.rem_retencion),0)
       into ln_ganancias_ext, ln_retencion_ext
       from quinta_categoria q
      where q.cod_trabajador  = asi_codtra
        and q.flag_automatico = '0'
        and to_char(q.fec_proceso,'yyyy') = to_char(adi_fec_proceso,'yyyy') 
        AND trunc(q.fec_proceso) <= trunc(adi_fec_proceso);

     
     /******************************************************************************************
     PASO 4 : Monto de la retencion
        Finalmente, para obtener el monto que se debe retener cada mes, se sigue el procedimiento siguiente:
        ?	En los meses de enero a marzo, el impuesto anual se divide entre doce. 
        ?	En el mes de abril, al impuesto anual se le deducen las retenciones efectuadas de enero a marzo. 
          El resultado se divide entre 9. 
        ?	En los meses de mayo a julio, al impuesto anual se le deducen las retenciones efectuadas en los meses de enero 
          a abril. El resultado se divide entre 8. 
        ?	En agosto, al impuesto anual se le deducen las retenciones efectuadas en los meses de enero a julio. 
          El resultado se divide entre 5. 
        ?	En los meses de septiembre a noviembre, al impuesto anual se le deducen las retenciones efectuadas en 
          los meses de enero a agosto. El resultado se divide entre 4. 
        ?	En diciembre, con motivo de la regularizacion anual, al impuesto anual se le deducira las retenciones 
          efectuadas en los meses de enero a noviembre del mismo ejercicio. 
          
        El monto obtenido en cada mes por el procedimiento antes indicado sera el impuesto que el agente de retencion 
        se encargara de retener en cada mes.
        
        Base Legal:
        Articulo 53? del TUO de la Ley del Impuesto a la Renta - Decreto Supremo 179-2004-EF y modificatorias.
        Articulo 40? del Reglamento de la Ley del Impuesto a la Renta - Decreto Supremo N? 122-94-EF y modificatorias.

     ******************************************************************************************/
     -- Obtengo el mes
     ln_mes         := to_number(to_char(adi_fec_proceso, 'mm'));

     -- Meses que faltan
     ln_meses_proy := 12 - ln_mes;
     ln_meses_divide := ln_meses_proy + 1;

     -- Acumulado de la retencion
     select NVL(SUM(hc.imp_soles),0)
       into ln_acu_retencion
       from historico_calculo hc
      where hc.cod_trabajador = asi_codtra
        and to_char(hc.fec_calc_plan,'yyyy') = to_char(adi_fec_proceso,'yyyy') 
        and to_char(hc.fec_calc_plan,'mm') <= ln_mes
        AND trunc(hc.fec_calc_plan) < trunc(adi_fec_proceso)
        and hc.concep in (ls_cnc_ret_quinta, ls_cnc_ret_quinta_man);
    
     
     -- Calculo de lo que se le ha pagado la remuneracion proyectable
     select NVL(sum(c.imp_soles),0)
       into ln_rem_precisa
       from calculo c
      where c.cod_trabajador = asi_codtra
        and c.tipo_planilla  = asi_tipo_planilla
        and c.concep in ( select d.concepto_calc
                            from grupo_calculo_det d
                           where d.grupo_calculo = ls_grp_quinta_categ ) ;
     
     -- Calculo cuanto se le ha pagado de sueldo hasta ahora
     select NVL(sum(c.imp_soles),0)
       into ln_acu_sueldo
       from historico_calculo c
      where c.cod_trabajador = asi_codtra
        and to_char(c.fec_calc_plan,'yyyy') = to_char(adi_fec_proceso,'yyyy')
        and trunc(c.fec_calc_plan) < trunc(adi_fec_proceso)
        and c.concep in ( select d.concepto_calc
                            from grupo_calculo_det d
                           where d.grupo_calculo = ls_grp_quinta_categ ) ;
     
     -- Calculo la remuneracion imprecisa de lo que se le ha calculado
     select NVL(sum(c.imp_soles),0)
       into ln_rem_imprecisa
       from calculo c
      where c.cod_trabajador = asi_codtra
        and c.tipo_planilla  = asi_tipo_planilla
        and c.concep in ( select d.concepto_calc
                            from grupo_calculo_det d
                           where d.grupo_calculo = ls_grp_ganan_imprec ) ;

     -- Calculo la remuneracion imprecisa de lo que se le ha calculado
     select NVL(sum(hc.imp_soles),0)
       into ln_acu_imprecisa
       from historico_calculo hc
      where hc.cod_trabajador = asi_codtra
        and to_char(hc.fec_calc_plan,'yyyy') = to_char(adi_fec_proceso,'yyyy')
        and trunc(hc.fec_calc_plan) < trunc(adi_fec_proceso)
        and hc.concep in ( select d.concepto_calc
                            from grupo_calculo_det d
                           where d.grupo_calculo = ls_grp_ganan_imprec ) ;                         
        
     -- Saco el sueldo proyectado (sueldo bruto) para la remuneracion proyectada
     SELECT NVL(SUM(t.imp_gan_desc),0)
       INTO ln_sueldo_proy
       FROM gan_desct_fijo t
      WHERE t.cod_trabajador = asi_codtra
        and t.concep in ( select d.concepto_calc
                          from grupo_calculo_det d
                         where d.grupo_calculo = ls_grp_quinta_categ );
     
     
     -- Calculo la remuneracion aplicable a la gratificacion
     select NVL(sum(g.imp_gan_desc),0)
       into ln_rem_gratif
       from gan_desct_fijo g
      where g.cod_trabajador = asi_codtra
        and g.concep in ( select d.concepto_calc
                          from grupo_calculo_det d
                         where d.grupo_calculo = (select grati_medio_ano 
                                                    from rrhhparam_cconcep 
                                                   where reckey = '1'));
     
     if ln_mes < 7 then
        ln_gratificacion := ln_rem_gratif * 2 * 1.09;
     elsif ln_mes between 7 and 11 then
        ln_gratificacion := ln_rem_gratif * 1.09;
     else
        ln_gratificacion := 0;
     end if;
     
     -- Ahora con los datos necesarios procedo a calcular la quinta categoria
    ln_imp_calculo := ln_sueldo_proy * ln_meses_proy + ln_gratificacion + ln_rem_imprecisa 
                    + ln_rem_precisa + ln_acu_sueldo + ln_acu_imprecisa + ln_ganancias_ext;
        
    ln_imp_calculo := ln_imp_calculo - ln_base_imponible ;
        
    if ln_imp_calculo <= 0 then return; end if;
    
    --Obtengo el porcentaje para base_imponible02
    for rc_top in c_topes loop
        if ln_imp_calculo between rc_top.tope_ini and rc_top.tope_fin then
           ln_porc_ret_bi02 := nvl(rc_top.tasa, 0);
           exit;
        end if ;
    end loop ; 
    
    -- Obtengo la base imponible 02, en base a los conceptos imprecisos nada mas, que estan en calculo
    select NVL(sum(c.imp_soles),0)
       into ln_base_imponible2
       from calculo c
      where c.cod_trabajador = asi_codtra
        and c.tipo_planilla  = asi_tipo_planilla
        and c.concep in ( select d.concepto_calc
                            from grupo_calculo_det d
                           where d.grupo_calculo = ls_grp_ganan_imprec ) 
        and c.concep not in ( select d.concepto_calc
                                from grupo_calculo_det d
                               where d.grupo_calculo = ls_grp_vacaciones ) ;
    
    ln_base_imponible1 := ln_imp_calculo - ln_base_imponible2;
    
    --Si la base imponible 1 es negativa lo pongo en cero
    if ln_base_imponible1 < 0 then ln_base_imponible1 := 0; end if;
        
    ln_importe   := 0 ; ln_retencion := 0 ;
    --  Calcula porcentaje a retener de base_imponible 1
    for rc_top in c_topes loop
        if ln_base_imponible1 <= rc_top.tope_fin then
           ln_importe := ln_base_imponible1 - rc_top.tope_ini ;
           
           if ln_importe <= 0 then exit; end if;
           
           ln_importe   := ln_importe * nvl(rc_top.tasa,0)/100  ;
           ln_retencion := ln_retencion + ln_importe ;

        else
           ln_importe   := rc_top.tope_fin - rc_top.tope_ini ;
           ln_importe   := ln_importe * nvl(rc_top.tasa,0)/100;
           ln_retencion := ln_retencion + ln_importe ;
        end if ;
    end loop ; 
        
    --  Realiza retencion de quinta categoria del mes de proceso
    if ln_rem_precisa > 0 then
       ln_soles_ret := (ln_retencion - ln_acu_retencion - ln_retencion_ext) / ln_meses_divide;
    else
       ln_soles_ret := 0;
    end if;
    
    ln_soles_ret := ln_soles_ret + ln_base_imponible2 * ln_porc_ret_bi02 / 100;
            
    if ln_soles_ret > 0 then
               
       -- Si el calculo de renta es mayor que cero procedo a convertirlo a dolares
       ln_dolar_ret := ln_soles_ret / ani_tipcam ;
               
               
       --  Inserta registros en la tabla CALCULO
       update calculo
          set imp_soles = ln_soles_ret,
              imp_dolar = ln_dolar_ret
        where cod_trabajador = asi_codtra
          and concep         = ls_cnc_ret_quinta
          and tipo_planilla  = asi_tipo_planilla;
               
       if SQL%NOTFOUND then
           insert into calculo (
                  cod_trabajador, concep, fec_proceso, horas_trabaj, horas_pag,
                  dias_trabaj, imp_soles, imp_dolar, cod_origen, flag_replicacion, item,
                  tipo_planilla )
           values(
                  asi_codtra, ls_cnc_ret_quinta, adi_fec_proceso, 0, 0,
                  0, ln_soles_ret, ln_dolar_ret, asi_origen, '1', 1,
                  asi_tipo_planilla ) ;
       end if;
    end if ;

     
     -- Obtengo algun importe de la retención de quinta que se haya colocado en ganancias fijas para sumarlo
     select nvl(sum(t.imp_gan_desc),0)
       into ln_ret_dscto_fijo
       from gan_desct_fijo t
      where t.cod_trabajador = asi_codtra
        and t.concep         = ls_cnc_ret_quinta;
     
     if ln_ret_dscto_fijo > 0 then
        ln_dolar_ret := ln_ret_dscto_fijo / ani_tipcam ;

        --  Inserta registros en la tabla CALCULO
        update calculo
          set imp_soles = imp_soles + ln_ret_dscto_fijo,
              imp_dolar = imp_dolar + ln_dolar_ret
         where cod_trabajador = asi_codtra
           and concep         = ls_cnc_ret_quinta;
               
        if SQL%NOTFOUND then
             insert into calculo (
                    cod_trabajador, concep, fec_proceso, horas_trabaj, horas_pag,
                    dias_trabaj, imp_soles, imp_dolar, cod_origen, flag_replicacion, item, tipo_planilla )
             values(
                    asi_codtra, ls_cnc_ret_quinta, adi_fec_proceso, 0, 0,
                    0, ln_ret_dscto_fijo, ln_dolar_ret, asi_origen, '1', 1, asi_tipo_planilla ) ;
        end if;      
     end if;
     
     --  Inserta registros en la tabla QUINTA_CATEGORIA
     IF ln_soles_ret IS NULL THEN ln_soles_ret := 0; END IF;
     
     if ln_soles_ret  + ln_ret_dscto_fijo > 0 then
     
         insert into quinta_categoria (
                cod_trabajador, fec_proceso, rem_proyectable,
                rem_imprecisa, rem_retencion, rem_gratif, flag_replicacion, 
                nro_dias, sueldo, flag_automatico, gratif_proyect, tipo_planilla  )
         values (
                asi_codtra, adi_fec_proceso, ln_sueldo_proy,
                ln_rem_imprecisa, ln_soles_ret + ln_ret_dscto_fijo, ln_gratificacion, '1', 
                ani_dias_trabaj, ln_rem_precisa, '1', ln_gratificacion, asi_tipo_planilla ) ;
     end if;


  end sp_cal_quinta_categ_sueldo ;

begin
  -- Initialization
  is_grp_utilidad       := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_AFECTO_UTILIDAD', '090');
  
  -- Inasistencias
  is_grp_subsidios := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_CALCULO_SUBSIDIO', '094');
  is_grp_permisos := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_CALCULO_PERMISOS', '095');
  is_grp_vacaciones := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_CALCULO_VACACIONES', '096');
  is_grp_inasistencia := PKG_CONFIG.USF_GET_PARAMETER('GRUPO_CALCULO_INASISTENCIA', '097');
  
  -- Tipos de Trabajadores
  is_tipo_ejo         := PKG_CONFIG.USF_GET_PARAMETER('RRHH_TIPO_EMPLEADO_JORNALERO', 'EJO');
  
  -- Conceptos generales 
  is_cnc_movilidad    := PKG_CONFIG.USF_GET_PARAMETER('RRHH_CONCEPTO_MOVILIDAD', '1006');
  
  -- Concepto de asignacion familiar
  select a.cnc_asig_familiar
    into is_cnc_asig_familiar
    from asistparam a
   where a.reckey = '1';
end PKG_RRHH;
/

prompt
prompt Creating package body PKG_SIGRE_FINANZAS
prompt ========================================
prompt
create or replace package body cantabria.PKG_SIGRE_FINANZAS is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  function of_confin_vta_vd_sol(asi_nada varchar2) 
    return varchar2 is
  begin
    return PKG_SIGRE_FINANZAS.is_confin_vta_vd_sol;
  end ;
  
  function of_confin_vta_vd_dol(asi_nada varchar2) 
    return varchar2 is
  begin
    return PKG_SIGRE_FINANZAS.is_confin_vta_vd_dol;
  end ;

  function of_fin_caja_saldo_anterior(
           adi_fecha date,
           asi_origen origen.cod_origen%TYPE
  ) return number is
  
    ln_return       number;
    ln_tasa_cambio  calendario.vta_dol_prom%TYPE;
    
  begin
   select	nvl(
            sum(
                case 
                  when vw.cod_moneda = pkg_logistica.of_soles(null) then
                    vw.imp_neto / ln_tasa_cambio
                  else
                    vw.imp_neto
                end
               ), 0
            ) as importe
     into ln_return
     from vw_fin_flujo_caja vw
    where trunc(vw.fecha_emision) < trunc(adi_fecha)
      and vw.origen          like asi_origen;

    return ln_return;
  end;

  function of_fin_caja_saldo_anterior(
           adi_fecha  in date,
           asi_origen in origen.cod_origen%TYPE,
           asi_moneda in moneda.cod_moneda%TYPE
  ) return number is
  
    ln_return       number;
    
  begin
   select	nvl(
            sum(
                case 
                  when asi_moneda = pkg_logistica.of_soles(null) then
                    vw.ingresos_sol + vw.egresos_sol
                  else
                    vw.ingresos_dol + vw.egresos_dol
                end
               ), 0
            ) as importe
     into ln_return
     from vw_fin_flujo_caja vw
    where trunc(vw.fecha_emision) < trunc(adi_fecha)
      and vw.origen          like asi_origen;

    return ln_return;
  end;

  function of_fin_caja_saldo_anterior(
           ani_year   in number,
           ani_mes    in number,
           asi_origen in origen.cod_origen%TYPE,
           asi_moneda in moneda.cod_moneda%TYPE
  ) return number is
  
    ln_return       number;
    
  begin
   select	nvl(
            sum(
                case 
                  when asi_moneda = pkg_logistica.of_soles(null) then
                    vw.ingresos_sol + vw.egresos_sol
                  else
                    vw.ingresos_dol + vw.egresos_dol
                end
               ), 0
            ) as importe
     into ln_return
     from vw_fin_flujo_caja vw
    where vw.periodo < trim(to_char(ani_year, '0000')) || trim(to_char(ani_mes, '00'))
      and vw.origen          like asi_origen;

    return ln_return;
  end;

  function of_fecha_primer_ingreso(
          asi_proveedor in proveedor.proveedor%TYPE, 
          asi_tipo_doc  in cntas_pagar.tipo_doc%TYPE, 
          asi_nro_doc   in cntas_pagar.nro_doc%TYPE
  ) return date is
    
    ld_fecha date;
    ln_count number;
    
  begin
    
    select count(*)
      into ln_count
      from vale_mov        vm,
           articulo_mov    am,
           cntas_pagar_det cpd
     where vm.nro_vale = am.nro_vale
       and cpd.org_am         = am.cod_origen
       and cpd.nro_am         = am.nro_mov
       and vm.flag_estado     <> '0'
       and am.flag_estado     <> '0'
       and cpd.cod_relacion   = asi_proveedor
       and cpd.tipo_doc       = asi_tipo_doc
       and cpd.nro_doc        = asi_nro_doc;
    
    if ln_count > 0 then
       -- Si es una cuenta por pagar, busco la primera fecha de ingreso
       select min(vm.fec_registro)
         into ld_fecha
         from vale_mov        vm,
              articulo_mov    am,
              cntas_pagar_det cpd
        where vm.nro_vale = am.nro_vale
          and cpd.org_am         = am.cod_origen
          and cpd.nro_am         = am.nro_mov
          and vm.flag_estado     <> '0'
          and am.flag_estado     <> '0'
          and cpd.cod_relacion   = asi_proveedor
          and cpd.tipo_doc       = asi_tipo_doc
          and cpd.nro_doc        = asi_nro_doc;
    else
       select count(*)
         into ln_count
        from cntas_cobrar     cc,
             cntas_cobrar_det ccd,
             articulo_mov     am,
             vale_mov         vm
        where cc.tipo_doc     = ccd.tipo_doc
          and cc.nro_doc      = ccd.nro_doc
          and ccd.org_amp_ref = am.origen_mov_proy
          and ccd.nro_amp_ref = am.nro_mov_proy
          and am.nro_vale     = vm.nro_Vale
          and am.flag_estado  <> '0'
          and vm.flag_estado  <> '0'
          and cc.tipo_doc     = asi_tipo_doc
          and cc.nro_doc      = asi_nro_doc;
       
       if ln_count > 0 then
          select max(vm.fec_registro)
            into ld_fecha
           from cntas_cobrar     cc,
                cntas_cobrar_det ccd,
                articulo_mov     am,
                vale_mov         vm
           where cc.tipo_doc     = ccd.tipo_doc
             and cc.nro_doc      = ccd.nro_doc
             and ccd.org_amp_ref = am.origen_mov_proy
             and ccd.nro_amp_ref = am.nro_mov_proy
             and am.nro_vale     = vm.nro_Vale
             and am.flag_estado  <> '0'
             and vm.flag_estado  <> '0'
             and cc.tipo_doc     = asi_tipo_doc
             and cc.nro_doc      = asi_nro_doc;
       else
          ld_fecha := null;
       end if;
    end if;
    
    return ld_fecha;
  
  end;
  
  -- Obtiene el IGV de la transferencia Gratuita, solo cuando el valor de la boleta es cero
  -- y no deba incluir descuentos ni anticipos
  function of_IGV_gratuito(
           asi_tipo_doc    in cntas_cobrar.tipo_doc%TYPE, 
           asi_nro_doc     in cntas_cobrar.tipo_doc%TYPE 
  ) return number is
  
    ln_return       number;
    
  begin
   select	nvl(sum(ccd.cantidad * ccd.precio_unitario), 0) 
     into ln_return
     from cntas_cobrar_det ccd
    where ccd.tipo_doc     = asi_tipo_doc
      and ccd.nro_doc      = asi_nro_doc;
   
   -- Si tiene importe entonces no es una transferencia gratuita
   if ln_return > 0 then return 0; end if;
   
   -- De lo contrario cojo el IGV de lo que sea como transferencia gratuita
   select nvl(sum(ci.importe) , 0) * -1
     into ln_return
     from cntas_cobrar_det ccd,
          cc_doc_det_imp   ci
    where ccd.tipo_doc     = ci.tipo_doc
      and ccd.nro_doc      = ci.nro_doc
      and ccd.item         = ci.item
      and ccd.tipo_doc     = asi_tipo_doc
      and ccd.nro_doc      = asi_nro_doc
      and ccd.tipo_cred_fiscal = '09'    -- Venta nacional gravada
      and ccd.descripcion  like '%GRATUITA%';
      
   return ln_return;
  end;


  procedure sp_cambiar_periodo(asi_proveedor in proveedor.proveedor%TYPE, 
                               asi_tipo_doc  in cntas_pagar.tipo_doc%TYPE, 
                               asi_nro_doc   in cntas_pagar.nro_doc%TYPE,
                               ani_new_year  in number,
                               ani_new_mes   in number) is
                               
    ln_new_asiento cntbl_libro_mes.nro_asiento%TYPE;
    ln_old_asiento cntbl_asiento.nro_asiento%TYPE;
    ln_nro_libro   cntbl_libro_mes.nro_libro%TYPE;
    ls_origen      cntbl_libro_mes.origen%TYPE;
    ln_year        cntbl_libro_mes.ano%TYPE;
    ln_mes         cntbl_libro_mes.mes%TYPE;
    ln_count       number;
                
  begin
    select count(*)
      into ln_count
      from cntas_pagar cp
     where cp.cod_relacion = asi_proveedor
       and cp.tipo_doc     = asi_tipo_doc
       and cp.nro_doc      = asi_nro_doc;
    
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'El comprobante por pagar ' || asi_proveedor || ' ' || asi_tipo_doc || ' ' || asi_nro_doc 
                                    || ', no existe en cntas_pagar, por favor verifique!');
    end if; 
    
    -- Obtengo los datos actuales
    select cp.origen, cp.ano, cp.mes, cp.nro_libro, cp.nro_asiento
      into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_old_asiento
      from cntas_pagar cp
     where cp.cod_relacion = asi_proveedor
       and cp.tipo_doc     = asi_tipo_doc
       and cp.nro_doc      = asi_nro_doc;
    
    if ln_nro_libro is null or ln_year is null or ln_mes is null then
      return;
    end if;
    
    select count(*)
      into ln_count
      from cntbl_libro_mes c
     where c.origen    = ls_origen
       and c.ano       = ani_new_year
       and c.mes       = ani_new_mes
       and c.nro_libro = ln_nro_libro;
    
    if ln_count = 0 then
       insert into cntbl_libro_mes(
              origen, ano, mes, nro_libro, nro_asiento)
       values(
              ls_origen, ani_new_year, ani_new_mes, ln_nro_libro, 1);
    end if;
    
    select c.nro_asiento
      into ln_new_asiento
      from cntbl_libro_mes c
     where c.origen    = ls_origen
       and c.ano       = ani_new_year
       and c.mes       = ani_new_mes
       and c.nro_libro = ln_nro_libro for update;
     
    
    -- Creo un duplicado de la cabecera del asiento
    insert into cntbl_asiento(
           origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, tipo_nota, nro_proceso, desc_glosa, 
           fecha_cntbl, fec_registro, cod_usr, flag_estado, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, 
           flag_replicacion, flag_asnt_transf)
    select ca.origen, ani_new_year, ani_new_mes, ca.nro_libro, ln_new_asiento, ca.cod_moneda, ca.tasa_cambio, ca.tipo_nota, ca.nro_proceso, ca.desc_glosa, 
           ca.fecha_cntbl, sysdate, ca.cod_usr, ca.flag_estado, ca.flag_tabla, ca.tot_soldeb, ca.tot_solhab, ca.tot_doldeb, ca.tot_dolhab, 
           '1', ca.flag_asnt_transf
      from cntbl_asiento ca
     where ca.origen      = ls_origen
       and ca.ano         = ln_year
       and ca.mes         = ln_mes
       and ca.nro_libro   = ln_nro_libro
       and ca.nro_asiento = ln_old_asiento;
    
    -- Cambio el detalle del asiento para que apunte a la nueva cabecera
    update cntbl_asiento_det cad
       set cad.ano          = ani_new_year,
           cad.mes          = ani_new_mes,
           cad.nro_asiento  = ln_new_asiento
     where cad.origen      = ls_origen
       and cad.ano         = ln_year
       and cad.mes         = ln_mes
       and cad.nro_libro   = ln_nro_libro
       and cad.nro_asiento = ln_old_asiento;
    
    -- cambio en la cabecera de la cartera de pagos
    update cntas_pagar cp
       set cp.ano          = ani_new_year,
           cp.mes          = ani_new_mes,
           cp.nro_asiento  = ln_new_asiento
     where cp.origen      = ls_origen
       and cp.ano         = ln_year
       and cp.mes         = ln_mes
       and cp.nro_libro   = ln_nro_libro
       and cp.nro_asiento = ln_old_asiento;
    
    -- Elimino la cabecera del asiento que ya no la necesito
    delete cntbl_Asiento ca
     where ca.origen      = ls_origen
       and ca.ano         = ln_year
       and ca.mes         = ln_mes
       and ca.nro_libro   = ln_nro_libro
       and ca.nro_asiento = ln_old_asiento;
    

    -- Actualizo el numerador del asiento
    update cntbl_libro_mes c
       set c.nro_asiento = ln_new_asiento + 1
     where c.origen    = ls_origen
       and c.ano       = ani_new_year
       and c.mes       = ani_new_mes
       and c.nro_libro = ln_nro_libro;
    
    -- Actualizo los cambios
    commit;
    
  end sp_cambiar_periodo;  

  procedure sp_cambiar_periodo_vta(asi_proveedor in proveedor.proveedor%TYPE, 
                                   asi_tipo_doc  in cntas_cobrar.tipo_doc%TYPE, 
                                   asi_nro_doc   in cntas_cobrar.nro_doc%TYPE,
                                   ani_new_year  in number,
                                   ani_new_mes   in number) is
                               
    ln_new_asiento cntbl_libro_mes.nro_asiento%TYPE;
    ln_old_asiento cntbl_asiento.nro_asiento%TYPE;
    ln_nro_libro   cntbl_libro_mes.nro_libro%TYPE;
    ls_origen      cntbl_libro_mes.origen%TYPE;
    ln_year        cntbl_libro_mes.ano%TYPE;
    ln_mes         cntbl_libro_mes.mes%TYPE;
    ln_count       number;
                
  begin
    select count(*)
      into ln_count
      from cntas_cobrar cc
     where cc.tipo_doc     = asi_tipo_doc
       and cc.nro_doc      = asi_nro_doc;
    
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'El comprobante por cobrar ' || asi_tipo_doc || ' ' || asi_nro_doc 
                                    || ', no existe en cntas_cobrar, por favor verifique!');
    end if; 
    
    -- Obtengo los datos actuales
    select cc.origen, cc.ano, cc.mes, cc.nro_libro, cc.nro_asiento
      into ls_origen, ln_year, ln_mes, ln_nro_libro, ln_old_asiento
      from cntas_cobrar cc
     where cc.tipo_doc     = asi_tipo_doc
       and cc.nro_doc      = asi_nro_doc;
    
    if ln_nro_libro is null or ln_year is null or ln_mes is null then
      return;
    end if;
    
    select count(*)
      into ln_count
      from cntbl_libro_mes c
     where c.origen    = ls_origen
       and c.ano       = ani_new_year
       and c.mes       = ani_new_mes
       and c.nro_libro = ln_nro_libro;
    
    if ln_count = 0 then
       insert into cntbl_libro_mes(
              origen, ano, mes, nro_libro, nro_asiento)
       values(
              ls_origen, ani_new_year, ani_new_mes, ln_nro_libro, 1);
    end if;
    
    select c.nro_asiento
      into ln_new_asiento
      from cntbl_libro_mes c
     where c.origen    = ls_origen
       and c.ano       = ani_new_year
       and c.mes       = ani_new_mes
       and c.nro_libro = ln_nro_libro for update;
     
    
    -- Creo un duplicado de la cabecera del asiento
    insert into cntbl_asiento(
           origen, ano, mes, nro_libro, nro_asiento, cod_moneda, tasa_cambio, tipo_nota, nro_proceso, desc_glosa, 
           fecha_cntbl, fec_registro, cod_usr, flag_estado, flag_tabla, tot_soldeb, tot_solhab, tot_doldeb, tot_dolhab, 
           flag_replicacion, flag_asnt_transf)
    select ca.origen, ani_new_year, ani_new_mes, ca.nro_libro, ln_new_asiento, ca.cod_moneda, ca.tasa_cambio, ca.tipo_nota, ca.nro_proceso, ca.desc_glosa, 
           ca.fecha_cntbl, sysdate, ca.cod_usr, ca.flag_estado, ca.flag_tabla, ca.tot_soldeb, ca.tot_solhab, ca.tot_doldeb, ca.tot_dolhab, 
           '1', ca.flag_asnt_transf
      from cntbl_asiento ca
     where ca.origen      = ls_origen
       and ca.ano         = ln_year
       and ca.mes         = ln_mes
       and ca.nro_libro   = ln_nro_libro
       and ca.nro_asiento = ln_old_asiento;
    
    -- Cambio el detalle del asiento para que apunte a la nueva cabecera
    update cntbl_asiento_det cad
       set cad.ano          = ani_new_year,
           cad.mes          = ani_new_mes,
           cad.nro_asiento  = ln_new_asiento
     where cad.origen      = ls_origen
       and cad.ano         = ln_year
       and cad.mes         = ln_mes
       and cad.nro_libro   = ln_nro_libro
       and cad.nro_asiento = ln_old_asiento;
    
    -- cambio en la cabecera de la cartera de pagos
    update cntas_cobrar cc
       set cc.ano          = ani_new_year,
           cc.mes          = ani_new_mes,
           cc.nro_asiento  = ln_new_asiento
     where cc.origen      = ls_origen
       and cc.ano         = ln_year
       and cc.mes         = ln_mes
       and cc.nro_libro   = ln_nro_libro
       and cc.nro_asiento = ln_old_asiento;
    
    -- Elimino la cabecera del asiento que ya no la necesito
    delete cntbl_Asiento ca
     where ca.origen      = ls_origen
       and ca.ano         = ln_year
       and ca.mes         = ln_mes
       and ca.nro_libro   = ln_nro_libro
       and ca.nro_asiento = ln_old_asiento;
    

    -- Actualizo el numerador del asiento
    update cntbl_libro_mes c
       set c.nro_asiento = ln_new_asiento + 1
     where c.origen    = ls_origen
       and c.ano       = ani_new_year
       and c.mes       = ani_new_mes
       and c.nro_libro = ln_nro_libro;
    
    -- Actualizo los cambios
    commit;
    
  end sp_cambiar_periodo_vta;  

  procedure of_actualiza_saldo_cc(
       asi_nada in varchar2
  ) is

    cursor c_datos_dtrc is
      select cc.tipo_doc, cc.nro_doc, cc.flag_estado, cc.importe_doc, cc.saldo_sol, cc.saldo_dol
        from cntas_cobrar cc
       where cc.tipo_doc = 'DTRC'
         and cc.flag_estado <> '0';

    cursor c_datos is
      select cc.cod_relacion, cc.tipo_doc, cc.nro_doc, cc.tasa_cambio, cc.importe_doc, cc.cod_moneda,
             cc.flag_control_reg, cc.flag_provisionado,
             cc.fecha_documento as fec_emision,
             cc.fecha_vencimiento,
             'CC' as referencia,
             cc.flag_estado
        from cntas_cobrar cc
       where ((cc.flag_provisionado = 'D' and cc.flag_control_reg in ('0', '1')) 
           or (cc.flag_provisionado = 'R'))
         --and cc.nro_doc = '004-000185'
    order by referencia, tipo_doc, nro_doc;

    cursor c_caja_bancos_det (as_tipo_doc  cntas_cobrar.tipo_doc%TYPE,
                              as_nro_doc   cntas_cobrar.nro_doc%TYPE) is
      select cb.fecha_emision, cb.nro_registro, cbd.cod_moneda, cb.flag_tiptran, cb.tasa_cambio,
             cbd.importe
      from caja_bancos_det cbd,
           caja_bancos     cb
      where cb.origen    = cbd.origen
        and cb.nro_registro  = cbd.nro_registro
        and cbd.tipo_doc     = as_tipo_doc
        and cbd.nro_doc      = as_nro_doc
        and cb.flag_estado   <> '0'
        and ((cb.flag_tiptran = '3'         and cbd.factor = 1)
          or (cb.flag_tiptran in ('2', '4') and cbd.factor = -1)
          or (cbd.tipo_doc = 'NCC'          and ((cbd.factor = 1  and cb.flag_tiptran = '2') 
                                              or (cbd.factor = -1 and cb.flag_tiptran = '3')
                                              or (cbd.factor = 1 and cb.flag_tiptran = '4'))));

    cursor c_canje_documentos(as_tipo_doc  cntas_cobrar.tipo_doc%TYPE,
                              as_nro_doc   cntas_cobrar.nro_doc%TYPE) is
      select cc.cod_moneda, dr.importe, cc.tasa_cambio
      from cntas_cobrar cc,
           doc_referencias dr
      where cc.tipo_doc      = dr.tipo_ref
        and cc.nro_doc       = dr.nro_ref
        and dr.tipo_ref      = as_tipo_doc
        and dr.nro_ref       = as_nro_doc
        and cc.flag_estado   <> '0'
        and dr.tipo_mov      = 'C'
        and dr.tipo_doc      in ('LTC', 'NCNC');


    ln_saldo_sol            cntas_cobrar.saldo_sol%TYPE;
    ln_saldo_dol            cntas_cobrar.saldo_dol%TYPE;
    ln_imp_sol              cntas_cobrar.saldo_sol%TYPE;
    ln_imp_dol              cntas_cobrar.saldo_dol%TYPE;
    ls_flag_estado          cntas_cobrar.flag_estado%TYPE;
    ln_count                number;
    ln_importe_doc          cntas_cobrar.importe_doc%TYPE;
    ln_tasa_cambio          cntas_cobrar.tasa_cambio%TYPE;
    ls_moneda               cntas_cobrar.cod_moneda%TYPE;
    ln_imp_detraccion       cntas_cobrar.imp_detraccion%TYPE;
    ls_flag_detraccion      cntas_cobrar.flag_detraccion%TYPE;
    ln_porc_detraccion      cntas_cobrar.porc_detraccion%TYPE;
    ln_temp_sol             cntas_cobrar.saldo_sol%TYPE;
    ln_temp_dol             cntas_cobrar.saldo_dol%TYPE;
    ls_cnta_cntbl           doc_pendientes_cta_cte.cnta_ctbl%TYPE;
    ls_flag_debhab          cntbl_asiento_det.flag_debhab%TYPE;
    
  begin
    
    -- Borro lo que no esta doc_pendientes_Cnta_cnta
    delete doc_pendientes_cta_cte d
     where d.sldo_sol = 0
       and d.saldo_dol = 0;
   
    --Recorro el cursor de datos con la detracción
    for lc_reg in c_datos_dtrc loop
        select count(*)
          into ln_count
          from cntas_cobrar cc
         where cc.nro_detraccion = lc_reg.nro_doc;
        
        if ln_count = 0 then
           -- Si no existe entoces lo anulo
           update cntas_cobrar_det ccd
              set ccd.precio_unitario = 0
            where ccd.tipo_doc   = lc_reg.tipo_doc
              and ccd.nro_doc    = lc_reg.nro_doc;
              
           update cntas_cobrar cc
              set cc.importe_doc = 0, 
                  cc.saldo_sol   = 0,
                  cc.saldo_dol   = 0,
                  cc.flag_estado = '0'
            where cc.tipo_doc  = lc_reg.tipo_doc
              and cc.nro_doc   = lc_reg.nro_doc;
        end if;
        
        if ln_count > 0 then
            -- Verifico el estado del comprobante original y de ser activo calculo el importe de detraccion
            select cc.flag_estado, cc.tasa_cambio, cc.cod_moneda,
                   cc.flag_detraccion, cc.porc_detraccion,
                   ((select nvl(sum(ccd.cantidad * ccd.precio_unitario), 0)
                       from cntas_cobrar_det ccd
                      where ccd.tipo_doc = cc.tipo_doc
                        and ccd.nro_doc  = cc.nro_doc) +
                    (select nvl(sum(ci.importe), 0)
                       from cc_doc_det_imp ci
                      where ci.tipo_doc = cc.tipo_doc
                        and ci.nro_doc  = cc.nro_doc))
              into ls_flag_estado, ln_tasa_cambio, ls_moneda,
                   ls_flag_detraccion, ln_porc_detraccion,
                   ln_importe_doc
              from cntas_cobrar cc
             where cc.nro_detraccion = lc_reg.nro_doc;
           
            if ls_flag_estado = '0' or ls_flag_detraccion = '0' then
               -- Si no existe entoces lo anulo
               update cntas_cobrar_det ccd
                  set ccd.precio_unitario = 0
                where ccd.tipo_doc   = lc_reg.tipo_doc
                  and ccd.nro_doc    = lc_reg.nro_doc;
                  
               update cntas_cobrar cc
                  set cc.importe_doc = 0, 
                      cc.saldo_sol   = 0,
                      cc.saldo_dol   = 0,
                      cc.flag_estado = '0'
                where cc.tipo_doc  = lc_reg.tipo_doc
                  and cc.nro_doc   = lc_reg.nro_doc;
            end if;
            
            -- Calculo el importe de la detraccion
            if ls_moneda = PKG_LOGISTICA.of_dolares(null) then
               ln_imp_sol := ln_importe_doc * ln_tasa_cambio;
            else
               ln_imp_sol := ln_importe_doc;
            end if;
            
            ln_imp_detraccion := round(ln_imp_sol * ln_porc_detraccion / 100, in_nro_decimales);
            
            -- Calculo la diferencia
            if ls_moneda = PKG_LOGISTICA.of_soles(null) then
               ln_importe_doc := ln_importe_doc - ln_imp_detraccion;
               ln_saldo_sol   := ln_importe_doc;
               ln_saldo_dol   := ln_importe_doc / ln_tasa_cambio ;
            else
               ln_importe_doc := ln_importe_doc - ln_imp_detraccion / ln_tasa_cambio;
               ln_saldo_dol   := ln_importe_doc;
               ln_saldo_sol   := ln_importe_doc * ln_tasa_cambio ;
            end if;
            
            -- Actualizo el importe del documento
            update cntas_cobrar cc
               set cc.importe_doc = ln_importe_doc,
                   cc.saldo_sol   = ln_saldo_sol,
                   cc.saldo_dol   = ln_saldo_dol,
                   cc.flag_estado = '1'
             where cc.Nro_Detraccion = lc_reg.nro_doc;
            
            -- Actualizo el importe de la detraccion
            ln_saldo_sol := ln_imp_detraccion;
            ln_saldo_dol := ln_saldo_sol / ln_tasa_cambio;
            
            -- Actualizo el documetno de detracción
            update cntas_cobrar_det ccd
               set ccd.precio_unitario = ln_imp_detraccion
             where ccd.tipo_doc        = lc_reg.tipo_doc
               and ccd.nro_doc         = lc_Reg.nro_doc;
               
            update cntas_cobrar cc
               set cc.importe_doc   = ln_imp_detraccion,
                   cc.saldo_sol     = ln_saldo_sol,
                   cc.saldo_dol     = ln_saldo_dol,
                   cc.flag_estado   = '1',
                   cc.flag_provisionado = 'D',
                   cc.flag_control_reg  = '0'
             where cc.tipo_doc      = lc_Reg.Tipo_Doc
               and cc.nro_doc       = lc_reg.nro_doc;
        end if;        
    end loop;
    
    for lc_reg in c_datos loop
        if lc_reg.flag_estado in ('0', '4') then

           -- Si el documento esta anulado simplemente lo elimino de la tabla de cuenta corriente
           delete doc_pendientes_cta_cte t
           where t.tipo_doc     = lc_Reg.Tipo_Doc
             and t.nro_doc      = lc_reg.nro_doc;

        elsif lc_reg.flag_provisionado = 'R' or (lc_reg.flag_provisionado = 'D' and lc_reg.flag_control_reg = '0') then
          
          -- si el documento esta activo verifico el saldo del artículo
          if lc_reg.cod_moneda = pkg_logistica.is_soles then
             ln_saldo_sol := lc_reg.importe_doc;
             ln_saldo_dol := lc_reg.importe_doc / lc_reg.tasa_cambio;
          else
             ln_saldo_sol := lc_reg.importe_doc * lc_reg.tasa_cambio;
             ln_saldo_dol := lc_reg.importe_doc;
          end if;

          -- Detalle en Cartera de Cobros
          for lc_caja in c_caja_bancos_det(lc_reg.tipo_doc, lc_reg.nro_doc) loop
              if lc_caja.cod_moneda = pkg_logistica.is_soles then
                 ln_imp_sol := lc_caja.importe;
                 ln_imp_dol := lc_caja.importe / lc_caja.tasa_cambio;
              else
                 ln_imp_sol := lc_caja.importe * lc_caja.tasa_cambio;
                 ln_imp_dol := lc_caja.importe;
              end if;

              ln_saldo_sol := ln_saldo_sol - ln_imp_sol;
              ln_saldo_dol := ln_saldo_dol - ln_imp_dol;
          end loop;

          if ln_saldo_sol < 0 then ln_saldo_sol := 0; end if;
          if ln_saldo_dol < 0 then ln_saldo_dol := 0; end if;

          -- detalle en Canje de Documentos
          if ln_saldo_sol > 0 or ln_saldo_dol > 0 then
             for lc_reg2 in c_canje_documentos(lc_reg.tipo_doc, lc_reg.nro_doc) loop
                 if lc_reg2.cod_moneda = pkg_logistica.is_soles then
                    ln_imp_sol := lc_reg2.importe;
                    ln_imp_dol := lc_reg2.importe / lc_reg2.tasa_cambio;
                 else
                    ln_imp_sol := lc_reg2.importe * lc_reg2.tasa_cambio;
                    ln_imp_dol := lc_reg2.importe;
                 end if;

                 ln_saldo_sol := ln_saldo_sol - ln_imp_sol;
                 ln_saldo_dol := ln_saldo_dol - ln_imp_dol;
             end loop;

             if ln_saldo_sol < 0 then ln_saldo_sol := 0; end if;
             if ln_saldo_dol < 0 then ln_saldo_dol := 0; end if;
          end if;

          -- Detalle en Cuenta Corriente
          if ln_saldo_sol > 0 or ln_saldo_dol > 0 then
             select NVL(sum(usf_fl_conv_mon(ccd.imp_dscto, cc.mont_original, pkg_logistica.is_soles, ccd.fec_dscto)), 0),
                    NVL(sum(usf_fl_conv_mon(ccd.imp_dscto, cc.mont_original, pkg_logistica.is_dolares, ccd.fec_dscto)), 0)
               into ln_imp_sol, ln_imp_dol
               from cnta_crrte_detalle ccd,
                    cnta_crrte         cc
              where cc.cod_trabajador  = ccd.cod_trabajador
                and cc.tipo_doc        = ccd.tipo_doc
                and cc.nro_doc         = ccd.nro_doc
                and cc.cod_trabajador  = lc_reg.cod_relacion
                and cc.tipo_doc        = lc_reg.tipo_doc
                and cc.nro_doc         = lc_reg.nro_doc;
             
             ln_saldo_sol := ln_saldo_sol - ln_imp_sol;
             ln_saldo_dol := ln_saldo_dol - ln_imp_dol;

             if ln_saldo_sol < 0 then ln_saldo_sol := 0; end if;
             if ln_saldo_dol < 0 then ln_saldo_dol := 0; end if;
          end if;          

          -- Actualizo los datos en cntas_cobrar
          -- Si es un gasto directo entonces simplemente actualizo el flag de estado según el saldo
          if lc_reg.cod_moneda = pkg_logistica.is_soles then
            
             if ln_saldo_sol <= 0 then --pagado totalmente
                ls_flag_estado := '3' ;
             elsif lc_reg.importe_doc = ln_saldo_sol then --generado
                ls_flag_estado := '1';
             elsif ln_saldo_sol > 0 then    --pagado parcialmente
                ls_flag_estado := '2';
             end if ;
             
          elsif lc_reg.cod_moneda = pkg_logistica.is_dolares then
            
             if ln_saldo_dol <= 0 then --pagado totalmente
                ls_flag_estado := '3' ;
             elsif lc_reg.importe_doc = ln_saldo_dol then --generado
                ls_flag_estado := '1';
             elsif ln_saldo_dol > 0 then    --pagado parcialmente
                ls_flag_estado := '2';
             end if ;
             
          end if;

          -- Actualizo las cuentas por cobrar
          UPDATE cntas_cobrar
             SET flag_estado = ls_flag_estado ,
                 saldo_sol   = ln_saldo_sol,
                 saldo_dol   = ln_saldo_dol
           WHERE tipo_doc     = lc_reg.tipo_doc
             AND nro_doc      = lc_reg.nro_doc;
          
          -- Actualizo el saldo en soles y dolares
          if (lc_reg.cod_moneda = pkg_logistica.is_soles   and ln_saldo_sol <= 0) or 
             (lc_reg.cod_moneda = pkg_logistica.is_dolares and ln_saldo_dol <= 0) then
                
             delete doc_pendientes_cta_cte d
              where d.tipo_doc     = lc_reg.tipo_doc
                and d.nro_doc      = lc_reg.nro_doc;
          else
             
             select count(*)
               into ln_count
               from doc_pendientes_cta_cte t
              WHERE t.tipo_doc     = lc_reg.tipo_doc
                AND t.nro_doc      = lc_reg.nro_doc;
             
             if ln_count > 1 then
                delete doc_pendientes_cta_cte t
                 WHERE t.tipo_doc     = lc_reg.tipo_doc
                   AND t.nro_doc      = lc_reg.nro_doc;
             end if;
             
             -- Indico el flag adecuado
             if lc_reg.tipo_doc = 'NCC' then
                ls_flag_debhab := 'H';
             else
                ls_flag_debhab := 'D';
             end if;
             
             -- Busco la cuenta contable para la cuenta contable
             select count(distinct cad.cnta_ctbl)
               into ln_count
               from cntas_cobrar cc,
                    cntbl_asiento_det cad
              where cc.origen = cad.origen
                and cc.ano    = cad.ano
                and cc.mes    = cad.mes
                and cc.nro_libro = cad.nro_libro
                and cc.nro_asiento = cad.nro_asiento
                and cad.cod_relacion = lc_reg.cod_relacion
                and cad.tipo_docref1 = lc_reg.tipo_doc
                and cad.nro_docref1  = lc_reg.nro_doc
                and cad.flag_debhab  = ls_flag_debhab;
             
             if ln_count = 1 then
                select distinct cad.cnta_ctbl
                  into ls_cnta_cntbl
                  from cntas_cobrar cc,
                       cntbl_asiento_det cad
                 where cc.origen = cad.origen
                   and cc.ano    = cad.ano
                   and cc.mes    = cad.mes
                   and cc.nro_libro = cad.nro_libro
                   and cc.nro_asiento = cad.nro_asiento
                   and cad.cod_relacion = lc_reg.cod_relacion
                   and cad.tipo_docref1 = lc_reg.tipo_doc
                   and cad.nro_docref1  = lc_reg.nro_doc
                   and cad.flag_debhab  = ls_flag_debhab;
                   
             elsif ln_count > 1 then
                RAISE_APPLICATION_ERROR(-20000, 'El documento ' || trim(lc_reg.tipo_doc) || ' / ' 
                                             || lc_reg.nro_doc 
                                             || ' tiene mas de una cuenta contable en el DEBE / HABER en el asiento de provision.');
             else
                ls_cnta_cntbl := null;
             end if;  
             
             -- Actualizo el monto del documento pendiente
             update doc_pendientes_cta_cte t
                set t.sldo_sol     = ln_saldo_sol,
                    t.saldo_dol    = ln_saldo_dol,
                    t.cod_relacion = lc_reg.cod_relacion,
                    t.flag_debhab  = ls_flag_debhab,
                    t.cnta_ctbl    = ls_cnta_cntbl
              WHERE tipo_doc     = lc_reg.tipo_doc
                AND nro_doc      = lc_reg.nro_doc;
              
             if SQL%NOTFOUND then
                insert into doc_pendientes_cta_cte(
                       cod_relacion, tipo_doc, nro_doc, flag_tabla, cnta_ctbl, cod_moneda, flag_debhab, 
                       sldo_sol, saldo_dol, fecha_doc, factor, flag_replicacion, fecha_vencimiento)
                values(
                       lc_reg.cod_relacion, lc_reg.tipo_doc, lc_reg.nro_doc, '1', ls_cnta_cntbl, lc_reg.cod_moneda, ls_flag_debhab,
                       ln_saldo_sol, ln_saldo_dol, lc_reg.fec_emision, 1, '1', lc_reg.fecha_vencimiento);
             end if;
            
          end if;

        else
          -- Para documentos que son Cuentas por Cobrar Directo tipo cuenta corriente  
          
          -- Verifico si lo han cobrado
          select nvl(sum(case 
                           when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then 
                             cbd.importe 
                           else 
                             cbd.importe * cb.tasa_cambio 
                         end), 0),
                 nvl(sum(case 
                           when cbd.cod_moneda = PKG_LOGISTICA.of_dolares(null) then 
                             cbd.importe 
                           else 
                             cbd.importe / cb.tasa_cambio 
                         end), 0)
            into ln_temp_sol,
                 ln_temp_dol
            from caja_bancos cb,
                 caja_bancos_det cbd
           where cb.origen = cbd.origen
             and cb.nro_registro = cbd.nro_registro
             and cbd.cod_relacion = lc_reg.cod_relacion
             and cbd.tipo_doc     = lc_reg.tipo_doc
             and cbd.nro_doc      = lc_reg.nro_doc
             and cb.flag_estado   <> '0'
             and ((cb.flag_tiptran = '3' and cbd.factor = 1) 
               or (cb.flag_tiptran in ('2', '4') and cbd.factor = -1));
          
          ln_Saldo_sol := ln_temp_sol;
          ln_saldo_dol := ln_temp_dol;
          
          -- No lo han pagado por lo tanto los saldos originales son los que determina el documento
          if ln_Saldo_sol = 0 and ln_saldo_dol = 0 then
             if lc_reg.cod_moneda = pkg_logistica.is_soles then
                ln_saldo_sol := lc_reg.importe_doc;
                ln_saldo_dol := lc_reg.importe_doc / lc_reg.tasa_cambio;
             else
                ln_saldo_sol := lc_reg.importe_doc * lc_reg.tasa_cambio;
                ln_saldo_dol := lc_reg.importe_doc;
             end if;
              
             update cntas_cobrar cc
                set cc.saldo_sol = ln_saldo_sol,
                    cc.saldo_dol = ln_saldo_dol,
                    cc.flag_caja_bancos = '0',
                    cc.flag_estado      = '1'
              where cc.tipo_doc = lc_reg.tipo_doc
                and cc.nro_doc  = lc_reg.nro_doc;

          else
             -- Actualizo el estado de la cuenta por cobrar
             update cntas_cobrar cc
                set cc.saldo_sol = ln_saldo_sol,
                    cc.saldo_dol = ln_saldo_dol,
                    cc.flag_caja_bancos = '1',
                    cc.flag_estado      = '1'
              where cc.tipo_doc = lc_reg.tipo_doc
                and cc.nro_doc  = lc_reg.nro_doc;
            
            -- Verifico si lo han cobrado o aplicado
            select nvl(sum(case when cbd.cod_moneda = PKG_LOGISTICA.of_soles(null) then cbd.importe else cbd.importe * cb.tasa_cambio end), 0),
                   nvl(sum(case when cbd.cod_moneda = PKG_LOGISTICA.of_dolares(null) then cbd.importe else cbd.importe / cb.tasa_cambio end), 0)
              into ln_temp_sol,
                   ln_temp_dol
              from caja_bancos cb,
                   caja_bancos_det cbd
             where cb.origen = cbd.origen
               and cb.nro_registro = cbd.nro_registro
               and cbd.cod_relacion = lc_reg.cod_relacion
               and cbd.tipo_doc     = lc_reg.tipo_doc
               and cbd.nro_doc      = lc_reg.nro_doc
               and cb.flag_estado   <> '0'
               and ((cb.flag_tiptran = '3' and cbd.factor = -1) 
                 or (cb.flag_tiptran in ('2', '4') and cbd.factor = 1));
            
            ln_saldo_sol := ln_saldo_sol - ln_temp_sol;
            ln_saldo_dol := ln_saldo_dol - ln_temp_dol;
            
            if ln_saldo_sol < 0 then ln_saldo_sol := 0; end if;
            if ln_saldo_dol < 0 then ln_saldo_dol := 0; end if;
            
            if (lc_reg.cod_moneda = PKG_LOGISTICA.is_soles and ln_saldo_sol = 0) 
              or (lc_reg.cod_moneda = PKG_LOGISTICA.is_dolares and ln_saldo_dol = 0) then
               ls_flag_estado := '3';
            else
               ls_flag_estado := '1';
            end if;
             
             update cntas_cobrar cc
                set cc.saldo_sol = ln_saldo_sol,
                    cc.saldo_dol = ln_saldo_dol,
                    cc.flag_caja_bancos = '1',
                    cc.flag_estado      = ls_flag_estado
              where cc.tipo_doc = lc_reg.tipo_doc
                and cc.nro_doc  = lc_reg.nro_doc;
            
            if ln_saldo_sol > 0 or ln_saldo_dol > 0 then
               select count(*)
                 into ln_count
                 from caja_bancos cb,
                      caja_bancos_det cbd,
                      cntbl_Asiento_det cad
                where cb.origen         = cbd.origen
                  and cb.nro_registro   = cbd.nro_registro
                  and cb.origen         = cad.origen
                  and cb.ano            = cad.ano
                  and cb.mes            = cad.mes
                  and cb.nro_libro      = cad.nro_libro
                  and cb.nro_Asiento    = cad.nro_Asiento
                  and cad.cod_relacion  = lc_reg.cod_relacion
                  and cad.tipo_docref1  = lc_reg.tipo_doc
                  and cad.nro_docref1   = lc_reg.nro_doc
                  and cb.flag_estado   <> '0'
                  and ((cb.flag_tiptran = '3' and cbd.factor = 1) 
                    or (cb.flag_tiptran in ('2', '4') and cbd.factor = -1));
               
               if ln_count > 0 then
                  -- Obtengo la cuenta contable
                  select s.cnta_ctbl, s.flag_debhab
                    into ls_cnta_cntbl, ls_flag_debhab
                    from (select distinct cad.item, cad.cnta_ctbl, cad.flag_debhab
                           from caja_bancos cb,
                                caja_bancos_det cbd,
                                cntbl_Asiento_det cad
                          where cb.origen         = cbd.origen
                            and cb.nro_registro   = cbd.nro_registro
                            and cb.origen         = cad.origen
                            and cb.ano            = cad.ano
                            and cb.mes            = cad.mes
                            and cb.nro_libro      = cad.nro_libro
                            and cb.nro_Asiento    = cad.nro_Asiento
                            and cad.cod_relacion  = lc_reg.cod_relacion
                            and cad.tipo_docref1  = lc_reg.tipo_doc
                            and cad.nro_docref1   = lc_reg.nro_doc
                            and cb.flag_estado   <> '0'
                            and ((cb.flag_tiptran = '3' and cbd.factor = 1) 
                              or (cb.flag_tiptran in ('2', '4') and cbd.factor = -1))
                          order by cad.item) s
                     where rownum = 1;
               else
                  ls_cnta_cntbl := null;
                  ls_flag_debhab := null;
               end if; 
               
               update doc_pendientes_cta_cte t
                  set t.cnta_ctbl = ls_cnta_cntbl
                where t.cod_relacion         = lc_reg.cod_relacion
                  and t.tipo_doc             = lc_Reg.tipo_Doc
                  and t.nro_Doc              = lc_reg.nro_doc; 
            end if; 
            
          end if;
        
        end if;
    end loop;
    
    commit;

  end of_actualiza_saldo_cc;

  procedure of_actualiza_saldo_cp(
         asi_nada in varchar2
  ) is

    cursor c_datos_dtrp is
      select cp.cod_relacion, cp.tipo_doc, cp.nro_doc, cp.flag_estado, cp.importe_doc, cp.saldo_sol, cp.saldo_dol
        from cntas_pagar cp
       where cp.tipo_doc = PKG_SIGRE_FINANZAS.is_doc_dtrp
         and cp.flag_estado <> '0';

    cursor c_datos is
      select cp.cod_relacion, cp.tipo_doc, cp.nro_doc, cp.tasa_cambio, cp.importe_doc, cp.cod_moneda,
             cp.flag_control_reg, cp.flag_provisionado,
             'CP' as referencia,
             cp.flag_estado
        from cntas_pagar cp
       where ((cp.flag_provisionado = 'D' and cp.flag_control_reg in ('0', '1')) or (cp.flag_provisionado = 'R'))
      union
      select cri.proveedor as cod_relacion,
             'CRI' as tipo_doc,
             cri.nro_certificado as nro_doc,
             cri.tasa_cambio,
             cri.importe_doc,
             (select cod_soles from logparam where reckey = '1') as cod_moneda,
             '0' as flag_control_reg,
             '0' as flag_provisionado,
             'CRI' as referencia,
             cri.flag_estado
        from retencion_igv_crt cri
       where cri.flag_estado <> '0'
    order by referencia, tipo_doc, nro_doc;

    cursor c_og_det (as_proveedor cntas_pagar.cod_relacion%TYPE,
                     as_tipo_doc  cntas_pagar.tipo_doc%TYPE,
                     as_nro_doc   cntas_pagar.nro_doc%TYPE) is
      select s.tasa_cambio, s.cod_moneda, s.importe
        from solicitud_giro_liq_det s
       where s.proveedor = as_proveedor
         and s.tipo_doc  = as_tipo_doc
         and s.nro_doc   = as_nro_doc;

    cursor c_caja_bancos_det (as_proveedor cntas_pagar.cod_relacion%TYPE,
                              as_tipo_doc  cntas_pagar.tipo_doc%TYPE,
                              as_nro_doc   cntas_pagar.nro_doc%TYPE) is
      select cb.fecha_emision, cb.nro_registro, cbd.cod_moneda, cb.flag_tiptran, cb.tasa_cambio,
             cbd.importe
      from caja_bancos_det cbd,
           caja_bancos     cb
      where cb.origen    = cbd.origen
        and cb.nro_registro  = cbd.nro_registro
        and cbd.cod_relacion = as_proveedor
        and cbd.tipo_doc     = as_tipo_doc
        and cbd.nro_doc      = as_nro_doc
        and cb.flag_estado   <> '0'
        and ((cb.flag_tiptran= '3'          and cbd.factor = -1)
          or (cb.flag_tiptran in ('2', '4') and cbd.factor = 1)
          or (cbd.tipo_doc = 'NCP'          and cbd.factor = -1));

    cursor c_canje_documentos(as_proveedor cntas_pagar.cod_relacion%TYPE,
                              as_tipo_doc  cntas_pagar.tipo_doc%TYPE,
                              as_nro_doc   cntas_pagar.nro_doc%TYPE) is
      select cp.cod_moneda, dr.importe, cp.tasa_cambio
      from cntas_pagar cp,
           doc_referencias dr
      where cp.cod_relacion  = dr.proveedor_ref
        and cp.tipo_doc      = dr.tipo_ref
        and cp.nro_doc       = dr.nro_ref
        and dr.proveedor_ref = as_proveedor
        and dr.tipo_ref      = as_tipo_doc
        and dr.nro_ref       = as_nro_doc
        and cp.flag_estado   <> '0'
        and dr.tipo_mov      = 'P'
        and dr.flag_provisionado is not null;

    ln_count                number;
    ln_tasa_cambio          cntas_pagar.tasa_cambio%TYPE;
    ln_imp_detraccion       cntas_pagar.imp_detraccion%TYPE;
    ls_flag_detraccion      cntas_pagar.flag_detraccion%TYPE;
    ln_porc_detraccion      cntas_pagar.porc_detraccion%TYPE;
    ln_importe_doc          cntas_pagar.importe_doc%TYPE;
    ls_moneda               cntas_pagar.cod_moneda%TYPE;
    ln_saldo_sol            cntas_pagar.saldo_sol%TYPE;
    ln_saldo_dol            cntas_pagar.saldo_dol%TYPE;
    ln_imp_sol              cntas_pagar.saldo_sol%TYPE;
    ln_imp_dol              cntas_pagar.saldo_dol%TYPE;
    ls_flag_estado          cntas_pagar.flag_estado%TYPE;
    
  begin

    --Recorro el cursor de datos con la detracción
    for lc_reg in c_datos_dtrp loop
        select count(*)
          into ln_count
          from cntas_pagar cp
         where cp.nro_detraccion = lc_reg.nro_doc;
        
        if ln_count = 0 then
           -- Si no existe entoces lo anulo
           update cntas_pagar_det cpd
              set cpd.precio_unit = 0
            where cpd.cod_relacion = lc_reg.cod_relacion
              and cpd.tipo_doc     = lc_reg.tipo_doc
              and cpd.nro_doc      = lc_reg.nro_doc;
              
           update cntas_pagar cp
              set cp.importe_doc = 0, 
                  cp.saldo_sol   = 0,
                  cp.saldo_dol   = 0,
                  cp.flag_estado = '0'
            where cp.cod_relacion = lc_reg.cod_relacion
              and cp.tipo_doc     = lc_reg.tipo_doc
              and cp.nro_doc      = lc_reg.nro_doc;
        end if;
        
        if ln_count > 0 then
            -- Verifico el estado del comprobante original y de ser activo calculo el importe de detraccion
            select cp.flag_estado, cp.tasa_cambio, cp.cod_moneda,
                   cp.flag_detraccion, cp.porc_detraccion,
                   cp.imp_detraccion,
                   ((select nvl(sum(cpd.cantidad * cpd.precio_unit), 0)
                       from cntas_pagar_det cpd
                      where cpd.cod_relacion = cp.cod_relacion
                        and cpd.tipo_doc     = cp.tipo_doc
                        and cpd.nro_doc      = cp.nro_doc) +
                    (select nvl(sum(ci.importe), 0)
                       from cp_doc_det_imp ci
                      where ci.cod_relacion = cp.cod_relacion
                        and ci.tipo_doc     = cp.tipo_doc
                        and ci.nro_doc      = cp.nro_doc))
              into ls_flag_estado, ln_tasa_cambio, ls_moneda,
                   ls_flag_detraccion, ln_porc_detraccion,
                   ln_imp_detraccion,
                   ln_importe_doc
              from cntas_pagar cp
             where cp.nro_detraccion = lc_reg.nro_doc;
           
            if ls_flag_estado = '0' or ls_flag_detraccion = '0' then
               -- Si no existe entoces lo anulo
               update cntas_pagar_det cpd
                  set cpd.precio_unit = 0
                where cpd.cod_relacion = lc_reg.cod_relacion
                  and cpd.tipo_doc     = lc_reg.tipo_doc
                  and cpd.nro_doc      = lc_reg.nro_doc;
                  
               update cntas_pagar cp
                  set cp.importe_doc = 0, 
                      cp.saldo_sol   = 0,
                      cp.saldo_dol   = 0,
                      cp.flag_estado = '0'
                where cp.cod_relacion = lc_reg.cod_relacion
                  and cp.tipo_doc     = lc_reg.tipo_doc
                  and cp.nro_doc      = lc_reg.nro_doc;
            end if;
            
            -- Calculo el importe de la detraccion
            if ls_moneda = PKG_LOGISTICA.of_dolares(null) then
               ln_imp_sol := ln_importe_doc * ln_tasa_cambio;
            else
               ln_imp_sol := ln_importe_doc;
            end if;
            
            --ln_imp_detraccion := round(ln_imp_sol * ln_porc_detraccion / 100, in_nro_decimales);
            
            -- Calculo la diferencia
            if ls_moneda = PKG_LOGISTICA.of_soles(null) then
               ln_importe_doc := ln_importe_doc - ln_imp_detraccion;
               ln_saldo_sol   := ln_importe_doc;
               ln_saldo_dol   := ln_importe_doc / ln_tasa_cambio ;
            else
               ln_importe_doc := ln_importe_doc - ln_imp_detraccion / ln_tasa_cambio;
               ln_saldo_dol   := ln_importe_doc;
               ln_saldo_sol   := ln_importe_doc * ln_tasa_cambio ;
            end if;
            
            -- Actualizo el importe del documento
            update cntas_pagar cp
               set cp.importe_doc = ln_importe_doc,
                   cp.saldo_sol   = ln_saldo_sol,
                   cp.saldo_dol   = ln_saldo_dol,
                   cp.flag_estado = '1'
             where cp.Nro_Detraccion = lc_reg.nro_doc;
            
            -- Actualizo el importe de la detraccion
            ln_saldo_sol := ln_imp_detraccion;
            ln_saldo_dol := ln_saldo_sol / ln_tasa_cambio;
            
            -- Actualizo el documento de detracción
            update cntas_pagar_det cpd
               set cpd.precio_unit    = ln_imp_detraccion
             where cpd.cod_relacion    = lc_reg.cod_relacion
               and cpd.tipo_doc        = lc_reg.tipo_doc
               and cpd.nro_doc         = lc_Reg.nro_doc;
               
            update cntas_pagar cp
               set cp.importe_doc   = ln_imp_detraccion,
                   cp.saldo_sol     = ln_saldo_sol,
                   cp.saldo_dol     = ln_saldo_dol,
                   cp.flag_estado   = '1',
                   cp.flag_control_reg = '0'
             where cp.cod_relacion  = lc_reg.cod_relacion
               and cp.tipo_doc      = lc_Reg.Tipo_Doc
               and cp.nro_doc       = lc_reg.nro_doc;
               
        end if;        
        
        
    end loop;
    

    for lc_reg in c_datos loop
        if lc_reg.flag_estado in ('0', '4') then

           -- Si el documento esta anulado o Cerrado manualmente por el usuario
           delete doc_pendientes_cta_cte t
           where t.cod_relacion = lc_reg.cod_relacion
             and t.tipo_doc     = lc_Reg.Tipo_Doc
             and t.nro_doc      = lc_reg.nro_doc;

        else
          -- si el documento esta activo verifico el saldo del artículo

          if lc_reg.cod_moneda = pkg_logistica.is_soles then
             ln_saldo_sol := lc_reg.importe_doc;
             ln_saldo_dol := lc_reg.importe_doc / lc_reg.tasa_cambio;
          else
             ln_saldo_sol := lc_reg.importe_doc * lc_reg.tasa_cambio;
             ln_saldo_dol := lc_reg.importe_doc;
          end if;

          -- Detalle en Cartera de Pagos
          for lc_reg2 in c_caja_bancos_det(lc_reg.cod_relacion, lc_reg.tipo_doc, lc_reg.nro_doc) loop
              if lc_reg2.cod_moneda = pkg_logistica.is_soles then
                 ln_imp_sol := lc_reg2.importe;
                 ln_imp_dol := lc_reg2.importe / lc_reg2.tasa_cambio;
              else
                 ln_imp_sol := lc_reg2.importe * lc_reg2.tasa_cambio;
                 ln_imp_dol := lc_reg2.importe;
              end if;

              ln_saldo_sol := ln_saldo_sol - ln_imp_sol;
              ln_saldo_dol := ln_saldo_dol - ln_imp_dol;
          end loop;

          if ln_saldo_sol < 0 then ln_saldo_sol := 0; end if;
          if ln_saldo_dol < 0 then ln_saldo_dol := 0; end if;

          -- detalle en Orden de Giro
          if ln_saldo_sol > 0 or ln_saldo_dol > 0 then
             for lc_reg2 in c_og_det(lc_reg.cod_relacion, lc_reg.tipo_doc, lc_reg.nro_doc) loop
                 if lc_reg2.cod_moneda = pkg_logistica.is_soles then
                    ln_imp_sol := lc_reg2.importe;
                    ln_imp_dol := lc_reg2.importe / lc_reg2.tasa_cambio;
                 else
                    ln_imp_sol := lc_reg2.importe * lc_reg2.tasa_cambio;
                    ln_imp_dol := lc_reg2.importe;
                 end if;

                 ln_saldo_sol := ln_saldo_sol - ln_imp_sol;
                 ln_saldo_dol := ln_saldo_dol - ln_imp_dol;
             end loop;

             if ln_saldo_sol < 0 then ln_saldo_sol := 0; end if;
             if ln_saldo_dol < 0 then ln_saldo_dol := 0; end if;
          end if;

          -- detalle en Canje de Documentos
          if ln_saldo_sol > 0 or ln_saldo_dol > 0 then
             for lc_reg2 in c_canje_documentos(lc_reg.cod_relacion, lc_reg.tipo_doc, lc_reg.nro_doc) loop
                 if lc_reg2.cod_moneda = pkg_logistica.is_soles then
                    ln_imp_sol := lc_reg2.importe;
                    ln_imp_dol := lc_reg2.importe / lc_reg2.tasa_cambio;
                 else
                    ln_imp_sol := lc_reg2.importe * lc_reg2.tasa_cambio;
                    ln_imp_dol := lc_reg2.importe;
                 end if;

                 ln_saldo_sol := ln_saldo_sol - ln_imp_sol;
                 ln_saldo_dol := ln_saldo_dol - ln_imp_dol;
             end loop;

             if ln_saldo_sol < 0 then ln_saldo_sol := 0; end if;
             if ln_saldo_dol < 0 then ln_saldo_dol := 0; end if;
          end if;

          -- Actualizo los datos en cntas_pagar
          -- Si es un gasto directo entonces simplemente actualizo el flag de estado según el saldo
          if lc_reg.flag_control_reg = '0' then
             if lc_reg.cod_moneda = pkg_logistica.is_soles then
                if ln_saldo_sol <= 0 then --pagado totalmente
                   ls_flag_estado := '3' ;
                elsif lc_reg.importe_doc = ln_saldo_sol then --generado
                   ls_flag_estado := '1';
                elsif ln_saldo_sol > 0 then    --pagado parcialmente
                   ls_flag_estado := '2';
                end if ;
             end if;

             if lc_reg.cod_moneda = pkg_logistica.is_dolares then
                if ln_saldo_dol <= 0 then --pagado totalmente
                   ls_flag_estado := '3' ;
                elsif lc_reg.importe_doc = ln_saldo_dol then --generado
                   ls_flag_estado := '1';
                elsif ln_saldo_dol > 0 then    --pagado parcialmente
                   ls_flag_estado := '2';
                end if ;
             end if;

             if lc_reg.referencia = 'CP' then
                UPDATE cntas_pagar
                   SET flag_estado = ls_flag_estado ,
                       saldo_sol   = ln_saldo_sol,
                       saldo_dol   = ln_saldo_dol,
                       flag_replicacion = '0'
                 WHERE cod_relacion = lc_reg.cod_relacion
                   AND tipo_doc     = lc_reg.tipo_doc
                   AND nro_doc      = lc_reg.nro_doc;

             elsif lc_reg.referencia = 'CRI' then

                UPDATE retencion_igv_crt cri
                    SET flag_estado = ls_flag_estado ,
                       saldo_sol   = ln_saldo_sol,
                       saldo_dol   = ln_saldo_dol,
                       flag_replicacion = '0'
                 WHERE cri.nro_certificado = lc_reg.nro_doc;
             end if;

             if (lc_reg.cod_moneda = pkg_logistica.is_soles and ln_saldo_sol = 0) or (lc_reg.cod_moneda = pkg_logistica.is_dolares and ln_saldo_dol = 0) then
                delete doc_pendientes_cta_cte d
                 where d.cod_relacion = lc_reg.cod_relacion
                   and d.tipo_doc     = lc_reg.tipo_doc
                   and d.nro_doc      = lc_reg.nro_doc;
             end if;
          end if;
        end if;
    end loop;

    commit;

  end of_actualiza_saldo_cp;
  
  --procedimiento para cambiar el tipo y nro de documento de una cuenta por pagar
  procedure sp_change_nro_doc(
            asi_cod_rel        in cntas_pagar.cod_relacion%type ,
            asi_tipo_doc       in cntas_pagar.tipo_doc%type     ,
            asi_nro_doc        in cntas_pagar.nro_doc%type      ,
            asi_new_cod_rel    in cntas_pagar.cod_relacion%type ,
            asi_new_tipo_doc   in cntas_pagar.tipo_doc%Type     ,
            asi_new_nro_doc    in cntas_pagar.nro_doc%type) is
    
  
  -- Datos del asiento contable
  ls_origen            cntas_pagar.origen%TYPE;
  ln_ano               cntas_pagar.ano%TYPE;
  ln_mes               cntas_pagar.mes%TYPE;
  ln_nro_libro         cntas_pagar.nro_libro%TYPE;
  ln_nro_asiento       cntas_pagar.nro_asiento%TYPE;

  begin
    -- Obtengo los datos del asiento
    select cp.origen, cp.ano, cp.mes, cp.nro_libro, cp.nro_asiento
      into ls_origen, ln_ano, ln_mes, ln_nro_libro, ln_nro_asiento
      from cntas_pagar cp
     where cp.cod_relacion = asi_cod_rel
       and cp.tipo_doc     = asi_tipo_doc
       and cp.nro_doc      = asi_nro_doc;


    --actualiza detalle del asiento x nro documento de cuentas por pagar
    update cntbl_asiento_det cad  
       set cad.cod_relacion  = trim(asi_new_cod_rel),
           cad.tipo_docref1  = asi_new_tipo_doc,
           cad.nro_docref1   = asi_new_nro_doc
     where cad.cod_relacion       = asi_cod_rel
       and cad.tipo_docref1       = asi_tipo_doc
       and trim(cad.nro_docref1)  = trim(asi_nro_doc);


    --nuevo numero
    Insert Into cntas_pagar(
           cod_relacion, tipo_doc, nro_doc, 
           flag_estado, fecha_registro, fecha_emision, vencimiento,
           forma_pago, cod_moneda, tasa_cambio, total_pagar, total_pagado, cod_usr, job, motivo,
           origen, ano, mes, nro_libro, nro_asiento, descripcion, porc_ret_igv, nro_const_deposito,
           fecha_const_deposito, flag_retencion, nro_detraccion, flag_detraccion, porc_detraccion,
           flag_situacion_ltr, banco_ltr, nro_ren_ltr, flag_tipo_ltr, flag_provisionado, importe_doc,
           saldo_sol, saldo_dol, nro_certificado, flag_replicacion, flag_control_reg, flag_caja_bancos,
           saldo_aplicado_sol, saldo_aplicado_dol, oper_detr, bien_serv, fecha_presentacion, nro_sol_cred_rrhh,
           flag_cntr_almacen, importe_doc_referencial, fecha_pago_rtps, flag_ret_4categ, cod_aduana, 
           nro_correlativo, nom_proveedor, tipo_doc_ident, nro_doc_ident, fec_impresion, imp_detraccion, 
           flag_redondear, confin, serie_cp, numero_cp, clase_bien_serv)
    select asi_new_cod_rel, asi_new_tipo_doc, asi_new_nro_doc, 
           flag_estado, fecha_registro, fecha_emision, vencimiento,
           forma_pago, cod_moneda, tasa_cambio, total_pagar, total_pagado, cod_usr, job, motivo,
           origen, ano, mes, nro_libro, nro_asiento, descripcion, porc_ret_igv, nro_const_deposito,
           fecha_const_deposito, flag_retencion, nro_detraccion, flag_detraccion, porc_detraccion,
           flag_situacion_ltr, banco_ltr, nro_ren_ltr, flag_tipo_ltr, flag_provisionado, importe_doc,
           saldo_sol, saldo_dol, nro_certificado, flag_replicacion, flag_control_reg, flag_caja_bancos,
           saldo_aplicado_sol, saldo_aplicado_dol, oper_detr, bien_serv, fecha_presentacion, nro_sol_cred_rrhh,
           flag_cntr_almacen, importe_doc_referencial, fecha_pago_rtps, flag_ret_4categ, cod_aduana, 
           nro_correlativo, nom_proveedor, tipo_doc_ident, nro_doc_ident, fec_impresion, imp_detraccion, 
           flag_redondear, confin, serie_cp, numero_cp, clase_bien_serv
      from cntas_pagar a
     where a.cod_relacion = asi_cod_rel
       and a.tipo_doc     = asi_tipo_doc     
       and a.nro_doc      = asi_nro_doc      ;


    --inserto linea adicional en cntas_pagar_det
    insert into cntas_pagar_det(
          cod_relacion, tipo_doc,nro_doc,
          item, descripcion, cod_art, confin, cantidad, importe, cencos, cnta_prsp, 
          tipo_cred_fiscal, flag_replicacion, org_amp_ref, nro_amp_ref, centro_benef, 
          origen_ref, tipo_ref, nro_ref, item_ref, fec_movilidad, mov_desde, mov_hasta, 
          org_os, nro_os, item_os, org_am, nro_am, nro_vale_trans, item_vale_trans, precio_unit)
    select asi_new_cod_rel, asi_new_tipo_doc, asi_new_nro_doc,
           item, descripcion, cod_art, confin, cantidad, importe, cencos, cnta_prsp, 
           tipo_cred_fiscal, flag_replicacion, org_amp_ref, nro_amp_ref, centro_benef, 
           origen_ref, tipo_ref, nro_ref, item_ref, fec_movilidad, mov_desde, mov_hasta, 
           org_os, nro_os, item_os, org_am, nro_am, nro_vale_trans, item_vale_trans, precio_unit
      from cntas_pagar_det cpd
     where cpd.cod_relacion = asi_cod_rel 
       and cpd.tipo_doc     = asi_tipo_doc     
       and cpd.nro_doc      = asi_nro_doc      ;


    --cambio en tabla impuestos
    update cp_doc_det_imp cpi
       set cpi.cod_relacion = asi_new_cod_rel,
           cpi.tipo_doc     = asi_new_tipo_doc,
           cpi.nro_doc      = asi_new_nro_doc
     where cpi.cod_relacion = asi_cod_rel 
       and cpi.tipo_doc     = asi_tipo_doc     
       and cpi.nro_doc      = asi_nro_doc       ;


    --cambio el documento de referencia
    update doc_referencias dr
       set dr.cod_relacion = asi_new_cod_rel,
           dr.tipo_doc     = asi_new_tipo_doc,
           dr.nro_doc      = asi_new_nro_doc
     where dr.cod_relacion = asi_cod_rel 
       and dr.tipo_doc     = asi_tipo_doc     
       and dr.nro_doc      = asi_nro_doc      ;


    --Elimino el detalle de cntas_pagar
    delete cntas_pagar_det cpd
     where cpd.cod_relacion = asi_cod_rel
       and cpd.tipo_doc     = asi_tipo_doc     
       and cpd.nro_doc      = asi_nro_doc      ;

    --actualiza caja bancos detalle
    update caja_bancos_det cbd
       set cbd.cod_relacion = asi_new_cod_rel  ,
           cbd.tipo_doc     = asi_new_tipo_doc  ,
           cbd.nro_doc      = asi_new_nro_doc
     where cbd.cod_relacion = asi_cod_rel
       and cbd.tipo_doc     = asi_tipo_doc     
       and cbd.nro_doc      = asi_nro_doc      ;


    --actuliza de doc_referencias
    update doc_referencias dr
       set dr.cod_relacion = asi_new_cod_rel   ,
           dr.tipo_ref     = asi_new_tipo_doc   ,
           dr.nro_ref      = asi_new_nro_doc
     where dr.cod_relacion = asi_cod_rel 
       and dr.tipo_ref     = asi_tipo_doc    
       and dr.nro_ref      = asi_nro_doc      
       and dr.tipo_mov     in ('C','P')      ;


    --actualiza solictud giro
    update solicitud_giro_liq_det sgld
       set sgld.nro_doc   = asi_new_nro_doc,
           sgld.proveedor = asi_new_cod_rel  ,
           sgld.tipo_doc  = asi_new_tipo_doc
     where sgld.proveedor     = asi_cod_rel  
       and sgld.tipo_doc      = asi_tipo_doc      
       and sgld.nro_doc       = asi_nro_doc       ;



    --actualiza liquidacion pesca
    update liquidacion_det lqd
       set lqd.cxp_cod_rel  = asi_new_cod_rel,
           lqd.cxp_tipo_doc = asi_new_tipo_doc,
           lqd.cxp_nro_doc  = asi_new_nro_doc
     where lqd.cxp_cod_rel  = asi_cod_rel 
       and lqd.cxp_tipo_doc = asi_tipo_doc    
       and lqd.cxp_nro_doc  = asi_nro_doc     ;
    ---


    --actualiza programacion pago
    update programacion_pagos_det_doc pp
       set pp.prov_cnta_pagar = asi_new_cod_rel ,
           pp.doc_cnta_pagar  = asi_new_tipo_doc ,
           pp.nro_cnta_pagar  = asi_new_nro_doc
     where pp.prov_cnta_pagar = asi_cod_rel 
       and pp.doc_cnta_pagar  = asi_tipo_doc     
       and pp.nro_cnta_pagar  = asi_nro_doc      ;


    --actualiza planilla cobranza
    update pln_cobranza_det pcd
       set pcd.nro_doc_cxp = asi_new_nro_doc   ,
           pcd.cod_rel_cxp = asi_new_cod_rel ,
           pcd.doc_cxp     = asi_new_tipo_doc
     where pcd.cod_rel_cxp = asi_cod_rel 
       and pcd.doc_cxp     = asi_tipo_doc     
       and pcd.nro_doc_cxp = asi_nro_doc      ;


    --elimino cntas pagar
    delete from cntas_pagar cp
     where cp.cod_relacion = asi_cod_rel 
       and cp.tipo_doc     = asi_tipo_doc     
       and cp.nro_doc      = asi_nro_doc     ;
  
  
  end;

begin
  
  -- Documentos esenciales
  select f.doc_detrac_cp, f.doc_fact_cobrar, f.doc_bol_cobrar
    into is_doc_dtrp, is_doc_fac, is_doc_bvc
    from finparam f
   where f.reckey = '1';
   
  
  is_confin_vta_vd_sol := PKG_CONFIG.USF_GET_PARAMETER('CONFIN_VTA_CON_VALES_DCTO_SOL', 'CC-008');
  is_confin_vta_vd_dol := PKG_CONFIG.USF_GET_PARAMETER('CONFIN_VTA_CON_VALES_DCTO_DOL', 'CC-008');
  in_nro_decimales     := PKG_CONFIG.USF_GET_PARAMETER( 'NRO_DECIMALES_DETRACCION', 0);
  
  -- Documentos de notas de Credito / Debito
  is_doc_ncp        := PKG_CONFIG.USF_GET_PARAMETER('DOC_NCP', 'NCP');
  is_doc_ndp        := PKG_CONFIG.USF_GET_PARAMETER('DOC_NDP', 'NCP');
  is_doc_dtrc       := PKG_CONFIG.USF_GET_PARAMETER('DOC_DTRC', 'DTRC');
  is_doc_ncc        := PKG_CONFIG.USF_GET_PARAMETER('DOC_NOTA_CREDITO_X_COBRAR', 'NCC');
  is_doc_ndc        := PKG_CONFIG.USF_GET_PARAMETER('DOC_NOTA_debito_X_COBRAR', 'NDC');
   
end PKG_SIGRE_FINANZAS;
/

prompt
prompt Creating package body PKG_SIGRE_FLOTA
prompt =====================================
prompt
create or replace package body cantabria.PKG_SIGRE_FLOTA is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  function of_get_semana(adi_fecha date) return varchar2 is
    ls_Result varchar2(10);
    ln_count  number;
  begin
    
    select count(*)
      into ln_count
      from semanas s
     where trunc(adi_fecha) between trunc(s.fecha_inicio) and trunc(s.fecha_fin);
   
    if ln_count = 0 then return null; end if;

    select trim(to_char(s.ano, '0000')) || '-' || trim(to_char(s.semana, '00'))
      into ls_Result
      from semanas s
     where trunc(adi_fecha) between trunc(s.fecha_inicio) and trunc(s.fecha_fin);
     
    return ls_Result;
  end;

  function of_get_inicio_descarga(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return date is
    ld_fecha Date;
  begin
    select min(fv.hora_inicio_descarga)
      into ld_fecha
      from fl_venta fv
     where fv.parte_pesca = asi_parte_pesca;
     
    return ld_fecha;
  end;
  
  function of_get_fin_descarga(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return date is
    ld_fecha Date;
  begin
    select max(fv.hora_fin_descarga)
      into ld_fecha
      from fl_venta fv
     where fv.parte_pesca = asi_parte_pesca;
     
    return ld_fecha;
  end;
  
  function of_tiempo_descarga(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number is
    ln_Result number;
    ld_fecha1 date;
    ld_fecha2 date;
  begin
    ld_fecha1 := of_get_inicio_descarga(asi_parte_pesca);
    ld_fecha2 := of_get_fin_descarga(asi_parte_pesca);
    
    if (ld_fecha1 is not null and ld_fecha2 is not null) then
        ln_Result := (ld_fecha2 - ld_fecha1) * 24;
    else
        ln_Result := 0;
    end if;
     
    return ln_Result;
  end;

  function of_pesca_declarada(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number is
    ln_Result number;
  begin
    select nvl(sum(fv.cantidad_estimada),0)
      into ln_Result
      from fl_venta fv
     where fv.parte_pesca = asi_parte_pesca;
     
    return ln_Result;
  end;

  function of_pesca_real(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number is
    ln_Result number;
  begin
    select nvl(sum(fv.cantidad_real),0)
      into ln_Result
      from fl_venta fv
     where fv.parte_pesca = asi_parte_pesca;
     
    return ln_Result;
  end;
    
  function of_pesca_calas(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number is
    ln_Result number;
  begin
    select nvl(sum(fbc.captura_estimada),0)
      into ln_Result
      from fl_bitacora fb,
           fl_bitacora_calas fbc
     where fb.registro_bitacora = fbc.registro_bitacora
       and fb.parte_pesca       = asi_parte_pesca;
     
    return ln_Result;
  end;

  function of_nro_calas(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return number is
    ln_Result number;
  begin
    select count(*)
      into ln_Result
      from fl_bitacora fb,
           fl_bitacora_calas fbc
     where fb.registro_bitacora = fbc.registro_bitacora
       and fb.parte_pesca       = asi_parte_pesca;
     
    return ln_Result;
  end;

  function of_ultima_bitacora(asi_parte_pesca fl_parte_de_pesca.parte_pesca%TYPE) return varchar2 is
    ls_Result fl_bitacora.observaciones%TYPE;
    ln_count  number;
  begin
    select count(*)
      into ln_count
      from fl_bitacora fb
     where fb.parte_pesca       = asi_parte_pesca;
    
    if ln_count = 0 then
       ls_Result := 'NO HAY BITACORA REGISTRADA PARA ESTE PARTE DE PESCA';
    else
        select '(*) ' || trim(to_char(fb.fecha_hora_reg, 'dd/mm/yyyy hh:mi:ss')) || ' => ' ||  trim(fb.observaciones)
          into ls_Result
          from fl_bitacora fb
         where fb.parte_pesca       = asi_parte_pesca
           and rownum               = 1
         ORDER by fb.fecha_hora_reg desc;
    end if;
     
    return ls_Result;
  end;
  
  
  function of_concep_bonif_pesca(asi_nada varchar2) return varchar2 is
  begin
    return is_concep_bonif_pesca;
  end;

begin
  -- Initialization
  null;
end PKG_SIGRE_FLOTA;
/

prompt
prompt Creating package body PKG_SIGRE_OT
prompt ==================================
prompt
create or replace package body cantabria.PKG_SIGRE_OT is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  function uf_costo_proy_ot(asi_nro_ot orden_trabajo.nro_orden%TYPE, asi_moneda moneda.cod_moneda%TYPE) return number is
    ln_Materiales  number;
    ln_servicios   number;
    
  begin
    
    -- Sumo los materiales
    select nvl(sum(usf_fl_conv_mon(amp.precio_unit * amp.cant_proyect, amp.cod_moneda, asi_moneda, amp.fec_proyect)),0)
      into ln_Materiales
      from articulo_mov_proy amp
     where amp.tipo_doc = is_doc_ot
       and amp.nro_doc  = asi_nro_ot
       and amp.flag_estado <> '0';  
  
    -- Sumo los servicios
    select nvl(sum(usf_fl_conv_mon(op.costo_proyect, le.cod_moneda , asi_moneda, op.fec_inicio_est)),0)
      into ln_servicios
      from operaciones op,
           labor_ejecutor le
     where op.cod_labor =  le.cod_labor
       and op.cod_ejecutor = le.cod_ejecutor
       and op.nro_orden = asi_nro_ot
       and op.flag_estado <> '0'; 
        
    return ln_materiales + ln_servicios;
  end;
  
  -- Función para determinar el costo ejecutado de la OT
  function uf_costo_ejec_ot(asi_nro_ot orden_trabajo.nro_orden%TYPE, asi_moneda moneda.cod_moneda%TYPE) return number is
    ln_Materiales  number;
    ln_servicios   number;
    
  begin
    
    -- Sumo los materiales
    select nvl(sum(usf_fl_conv_mon(am.precio_unit * am.cant_procesada * vm.tipo_mov * -1, am.cod_moneda, asi_moneda, vm.fec_registro)),0)
      into ln_Materiales
      from articulo_mov_proy amp,
           articulo_mov      am,
           vale_mov          vm,
           articulo_mov_tipo amt
     where vm.nro_vale = am.nro_vale
       and am.origen_mov_proy = am.cod_origen
       and am.nro_mov_proy    = am.nro_mov
       and vm.tipo_mov        = amt.tipo_mov
       and am.flag_estado     <> '0'
       and vm.flag_estado     <> '0'
       and amp.tipo_doc       = is_doc_ot
       and amp.nro_doc        = asi_nro_ot
       and amp.flag_estado    <> '0';  
  
    -- Sumo los servicios
    select nvl(sum(usf_fl_conv_mon(osd.importe, os.cod_moneda , asi_moneda, osd.fec_proyect)),0)
      into ln_servicios
      from operaciones op,
           orden_servicio os,
           orden_Servicio_det osd
     where os.nro_os       = osd.nro_os
       and osd.oper_sec    = op.oper_sec
       and op.nro_orden    = asi_nro_ot
       and osd.flag_estado <> '0'; 
        
    return ln_materiales + ln_servicios;
  end;  

  function uf_porc_avance_atencion(asi_nro_ot orden_trabajo.nro_orden%TYPE) return number is
    ln_cant_proy  number;
    ln_cant_ejec  number;
    
  begin
    -- Primero la cantidad proyectada
    select nvl(sum(case when amp.flag_estado in ('1', '3') then amp.cant_proyect else amp.cant_procesada end ), 0)
      into ln_cant_proy
      from articulo_mov_proy amp
     where amp.tipo_doc = is_doc_ot
       and amp.nro_doc  = asi_nro_ot
       and amp.flag_estado <> '0';

    -- Segundo la cantidad procesada
    select nvl(sum(amp.cant_procesada), 0)
      into ln_cant_ejec
      from articulo_mov_proy amp
     where amp.tipo_doc = is_doc_ot
       and amp.nro_doc  = asi_nro_ot
       and amp.flag_estado <> '0';
    
    return case when ln_cant_proy = 0 then 1 else ln_cant_ejec / ln_cant_proy end;
       
  end ;

  function uf_material_pend_aprob(asi_nro_ot orden_trabajo.nro_orden%TYPE) return number is
    ln_count  number;
  begin
    select count(*)
      into ln_count
      from articulo_mov_proy amp
     where amp.tipo_doc = is_doc_ot
       and amp.nro_doc  = asi_nro_ot
       and amp.flag_estado = '3';
    
    return ln_count;    
  end;  
  
begin
  -- Initialization
  select l.doc_ot
    into is_doc_ot
    from logparam l
   where l.reckey = '1';
end PKG_SIGRE_OT;
/

prompt
prompt Creating package body PKG_UTILITY
prompt =================================
prompt
create or replace package body cantabria.PKG_UTILITY is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

  -- Function and procedure implementations
  function of_in_search(asi_search varchar2, asi_cadena varchar2) return number is
    ln_return number;
    ln_loop   number := 0;
    ls_cadena varchar2(2000);
    
    cursor c_datos is
      select * 
        from TABLE (SPLIT (asi_cadena, ' '));
  begin
    ln_loop := 0; ln_return := 1;
    for lc_reg in c_datos loop
        -- Incrementando la iteraccion
        ln_loop := ln_loop + 1;
        
        -- Obteniendo la cadena
        ls_cadena := upper(lc_reg.column_value);
        
        if trim(ls_cadena) = '%%' then 
           ln_return :=1; 
           exit; 
        end if;
        
        if substr(ls_cadena, 1, 1) = '%' then
           ls_cadena := substr(ls_cadena, 2);
        end if;
        
        if substr(ls_cadena, -1, 1) = '%' then
           ls_cadena := substr(ls_cadena, 1, length(ls_cadena) - 1);
        end if;
        
        if instr(asi_search, ls_cadena) > 0 then
           if ln_loop <= 1 then
              ln_return := 1;
           else
              if ln_return = 0 then exit; else ln_return := 1; end if;
           end if;
        else
          if ln_loop > 1 then
             -- Si ln_return esta entonces ya no continuo porque todos los registros deben coincidir
             if ln_return = 0 then exit; else ln_return := 0; end if;
          else
             ln_Return := 0;
          end if;
        end if;
    end loop;  
  
    return ln_return;
  end;
  
  -- Funcion que me devuelve la cadena para Codificacion 128b
  function of_convert_to_char128b(asi_yourData varchar2) return varchar2 is
    --ls_temp                varchar2(3000);
    --ls_chunk	             char(1);
    ln_i                   number;
    ln_checkDigitSubtotal  number;
    ln_e                   number;
    ls_return              varchar2(3000);
  begin
    -- Your input, yourData, is a string to be encoded as a Code 128 code set B symbol.
    -- yourData must be the Code 128 code set B character set. Input error checking is your responsibility.

    -- seed the variables
    --ls_temp := '';                 --code set B start glyph
    ln_checkDigitSubtotal := 104;        --code set B start checkdigit value

    --map the input string into the C128Tools character set
    
    /*
    For ln_i in 1..Length(asi_yourData) loop
        ls_chunk := substr(asi_yourData, ln_i, 1);
        Case 
          when ascii(ls_chunk) > 200 then
            --map from above ASCII 200 to the actual character assignments
            ls_temp := ls_temp || chr(Ascii(ls_chunk) - 35);
               
          when ascii(ls_chunk) = 32 then
            -- The space character is at ASCII 194 because TrueType
            -- doesn't allow a glyph in the ASCII 32 slot
            ls_temp := ls_temp || Chr(206);
          Else
            ls_temp := ls_temp || ls_chunk;
        End case;
    end loop;
    */
    --Calculate the Code 128 mod 103 check digit
    For ln_i in 1..Length(asi_yourData) loop
        ln_e := ascii(substr(asi_yourData, ln_i, 1)) - 32;
        If ln_e <> 142 Then
           ln_checkDigitSubtotal := ln_checkDigitSubtotal + (ln_e * ln_i);
        End If;
    end loop;
    
    ln_checkDigitSubtotal :=  MOD(ln_checkDigitSubtotal,103);

    --Put together the final output string
    --code set A start bar, the encoded string, check digit, stop bar
    case 
        when ln_checkDigitSubtotal = 0 then
          ls_return := chr(141) || asi_yourData || '' || Chr(140);
        else
          ls_return := chr(141) || asi_yourData || Chr(ln_checkDigitSubtotal + 32) || Chr(140);
        --when ln_checkDigitSubtotal > 93 then
        --  ls_return := asi_yourData || Chr(ln_checkDigitSubtotal + 32) || Chr(196);
    End case;
    
    return ls_return;

  end;

  -- Public function and procedure declarations
  function of_trim(  
    asi_cadena varchar2, 
    asi_char varchar2
  ) return VARCHAR2 is
  
    ls_return varchar(20);
  
  begin
    
    ls_return := asi_cadena;
    
    while substr(ls_return, 1, 1) = asi_char and length(ls_return) > 0 loop
      
      ls_return := substr(ls_return, 2);
      
    end loop;
  
    return ls_return;
  end;

  -- Funcion que devuelve la semana de una fecha especifica
  function of_semana(
           adi_fecha in date
  ) return VARCHAR2 is
  
    ls_return varchar(2);
    ln_count  number;
  
  begin
    select count(*)
      into ln_count
		  from semanas s
		 where trunc(adi_fecha) between s.fecha_inicio and s.fecha_fin;
    
    if ln_count = 0 then
       ls_return := trim(to_char(adi_fecha, 'ww'));
    else
       select trim(to_char(s.semana, '00'))
         into ls_return
				 from semanas s
				 where trunc(adi_fecha) between s.fecha_inicio and s.fecha_fin
					and rownum = 1;
    end if;
    
    return ls_return;
  end;
  
  -- Funcion que devuelve la ultima fecha de la semana
  function of_last_day_week(
           adi_fecha in date
  ) return date is
  
    ln_year        number;
    ln_semana      number;
    ln_count       number;
    ln_dia         number;
    ld_fecha       date;
    ln_semana_new  number;
  begin
    -- Obtengo la semana
    ln_year := to_number(to_char(adi_fecha, 'yyyy'));
    
    ln_semana := to_number(PKG_UTILITY.of_semana(adi_fecha));
    
    select count(*)
      into ln_count
		  from semanas s
		 where s.ano     = ln_year
       and s.semana  = ln_semana;
    
    if ln_count = 0 then
       
       for ln_dia in 1..7 loop
           ld_fecha := adi_fecha + ln_dia;
           
           if to_number(to_char(adi_fecha, 'yyyy')) <> to_number(to_char(ld_fecha, 'yyyy')) then
              return ld_fecha - 1 ;
           end if;
           
           ln_semana_new := to_number(to_char(ld_fecha, 'ww'));
           
           if ln_semana_new <> ln_semana then
              return ld_fecha - 1 ;
           end if;
           
       end loop;
    
    else
       select s.fecha_fin
         into ld_fecha
         from semanas s
        where s.ano     = ln_year
           and s.semana = ln_semana;
    end if;
    
    return ld_fecha;
  end;

  -- Funcion que devuelve la ultima fecha de la semana
  function of_last_day(
           ani_year in number, 
           ani_mes  in number
  ) return date is
  
    ln_year        number;
    ln_mes         number;
    ld_fecha       date;
  begin
    -- obtengo el periodo siguiente
    if ani_mes = 12 then
       ln_mes := 1;
       ln_year := ani_year +1 ;
    else
       ln_year := ani_year;
       ln_mes  := ani_mes + 1;
    end if;
       
    ld_fecha := to_date('01/' || trim(to_char(ln_mes, '00')) || '/' || trim(to_char(ln_year, '0000')), 'dd/mm/yyyy') - 1;
    
    
    return ld_fecha;
  end;
  
  -- Funcion que convierte en hexadecimal
  function of_convert_to_hex(
           ani_numero in number
   ) return varchar2 is
   begin
     return trim(to_char(ani_numero, 'FMXXXXXXXXXXXXXX'));
   end;
  
begin
  -- Initialization
  null;
end PKG_UTILITY;
/

prompt
prompt Creating package body USP_SIGRE_CNTBL
prompt =====================================
prompt
create or replace package body cantabria.USP_SIGRE_CNTBL is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;

    function SF_CNT_CIERRE_CNTBL(ani_year in cntbl_asiento.ano%type,
                                ani_mes  in cntbl_asiento.mes%type,
                                asi_tipo in string
  ) return varchar2 is

    Result varchar2(1) ;
    ls_flag_reg_cntbl          cntbl_cierre.flag_reg_cntbl%type ;
    ls_flag_mov_banco          cntbl_cierre.flag_mov_banco%type ;
    ls_flag_gen_asnt_autom     cntbl_cierre.flag_gen_asnt_autom%type ;
    ls_flag_cierre_mes         cntbl_cierre.flag_cierre_mes%type ;
    ls_pd_campo                cntbl_cierre.pd_campo%type ;
    ls_pd_dma                  cntbl_cierre.pd_dma%type ;
    ls_pd_mtto_fab             cntbl_cierre.pd_mtto_fab%type ;
    ls_pd_mtto_maq             cntbl_cierre.pd_mtto_maq%type ;
    ln_count                   number(2) ;
  BEGIN
    /* Retorna 0, no debe grabar asiento,
       retorna 1, debe grabar asiento */

    /* as_tipo tiene los siguientes valores, para los siguientes casos:
       R = caso registros de compras y ventas,
       B = caso movimiento bancario (tesoreria),
       M = cualquier asiento contable (por contabilidad) y
       A = para asientos contables por proceso
       C = caso de inventarios -almacenes-
       D = ????????
       F = partes diarios relacionados a OT
       P = parte diario de mantenimiento de maquinarias
    */

    Result := '1';

    SELECT count(*)
    INTO   ln_count
    FROM   cntbl_cierre
    WHERE  ano = ani_year
      and  mes = ani_mes ;

    IF ln_count > 0 then
       SELECT flag_reg_cntbl,    flag_mov_banco,    flag_cierre_mes,     flag_gen_asnt_autom,
              pd_campo,          pd_dma,            pd_mtto_fab,         pd_mtto_maq
       INTO   ls_flag_reg_cntbl, ls_flag_mov_banco, ls_flag_cierre_mes,  ls_flag_gen_asnt_autom,
              ls_pd_campo,       ls_pd_dma,         ls_pd_mtto_fab,      ls_pd_mtto_maq
       FROM   cntbl_cierre
       WHERE  ano = ani_year
         and  mes = ani_mes ;

       /* Registros contables, libros 3 y 4 */
       IF asi_tipo='R' and
          ( NVL(ls_flag_reg_cntbl,'')='0' OR
            NVL(ls_flag_cierre_mes,'')='0' ) then

          Result := '0' ;

       /* Movimientos bancarios, libros 7 y 8 */
       ELSIF asi_tipo='B' and
            ( NVL(ls_flag_mov_banco,'')='0' OR
              NVL(ls_flag_cierre_mes,'')='0' ) then

             Result := '0' ;

       /* Asientos contables, todos */
       ELSIF asi_tipo='M' and NVL(ls_flag_cierre_mes,'')='0' then

             Result := '0' ;

       /* Asientos contables generados por procesos */
       ELSIF asi_tipo='A' and
             ( NVL(ls_flag_gen_asnt_autom,'')='0' OR
               NVL(ls_flag_cierre_mes,'')='0' ) then

             Result := '0' ;

       /* Asientos contables generados por almacen */
       ELSIF asi_tipo='C' and
             ( NVL(ls_pd_campo,'')='0' OR
               NVL(ls_flag_cierre_mes,'')='0' ) then

             Result := '0' ;

       /* Asientos contables generados por parte diario de dma */
       ELSIF asi_tipo='D' and
             ( NVL(ls_pd_dma,'')='0' OR
               NVL(ls_flag_cierre_mes,'')='0' ) then

             Result := '0' ;

       /* Asientos contables generados por parte diario de mantenimiento de fabrica */
       ELSIF asi_tipo='F' and
             ( NVL(ls_pd_mtto_fab,'')='0' OR
               NVL(ls_flag_cierre_mes,'')='0' ) then

             Result := '0' ;

       /* Asientos contables generados por parte diario de mantenimiento de maquinaria */
       ELSIF asi_tipo='P' and
             ( NVL(ls_pd_mtto_maq,'')='0' OR
               NVL(ls_flag_cierre_mes,'')='0' ) then

             Result := '0' ;

       END IF ;
    END IF ;

   RETURN(Result);

  END ;

  function of_get_moneda(asi_cod_relacion in cntbl_asiento_det.cod_relacion%TYPE,
                         asi_tipo_doc     in cntbl_asiento_det.tipo_docref1%TYPE,
                         asi_nro_doc      in cntbl_Asiento_det.Nro_Docref1%TYPE
  ) return varchar2 is

    ls_Result cntbl_Asiento.Cod_Moneda%TYPE;
    ln_count  number;
    
  BEGIN
    select count(*)
      into ln_count
      from cntas_pagar cp
     where cp.cod_relacion = asi_cod_relacion
       and cp.tipo_doc     = asi_tipo_doc
       and cp.nro_doc      = asi_nro_doc;
    
    if ln_count > 0 then
       select cp.cod_moneda
         into ls_result
         from cntas_pagar cp
        where cp.cod_relacion = asi_cod_relacion
          and cp.tipo_doc     = asi_tipo_doc
          and cp.nro_doc      = asi_nro_doc;
      
    else
       select count(*)
         into ln_count
         from cntas_cobrar cc
        where cc.tipo_doc     = asi_tipo_doc
          and cc.nro_doc      = asi_nro_doc;
       
       if ln_count > 0 then
          select cc.cod_moneda
            into ls_result
            from cntas_cobrar cc
           where cc.tipo_doc     = asi_tipo_doc
            and cc.nro_doc      = asi_nro_doc;
       end if;
      
    end if;
    /*
    select cod_moneda
      into ls_Result
      from ( select ca1.fecha_cntbl, ca1.cod_moneda
               from cntbl_Asiento ca1,
                    cntbl_asiento_det cad1
              where ca1.origen = cad1.origen
                and ca1.ano    = cad1.ano
                and ca1.mes    = cad1.mes
                and ca1.nro_libro = cad1.nro_libro
                and ca1.nro_asiento = cad1.nro_asiento
                 and cad1.cod_relacion = asi_cod_relacion
                and cad1.tipo_docref1 = asi_tipo_doc
                and cad1.nro_docref1  = asi_nro_doc
              order by 1) s
     where rownum = 1;
    */

   RETURN(ls_Result);

  END;  
  
  function of_get_ult_cnta_cntbl(
             asi_cod_relacion in cntbl_asiento_det.cod_relacion%TYPE,
             asi_tipo_doc     in cntbl_asiento_det.tipo_docref1%TYPE,
             asi_nro_doc      in cntas_cobrar.nro_doc%TYPE
  ) return varchar2 is

    ls_Result cntbl_asiento_Det.Cnta_Ctbl%TYPE;
    ln_count  number;
    
  BEGIN
    select count(*)
      into ln_count
      from cntbl_asiento ca,
           cntbl_Asiento_det cad
     where ca.origen         = cad.origen
       and ca.ano            = cad.ano
       and ca.mes            = cad.mes
       and ca.nro_libro      = cad.nro_libro
       and ca.nro_Asiento    = cad.nro_Asiento
       and cad.cod_relacion  = asi_cod_relacion
       and cad.tipo_docref1  = asi_tipo_doc
       and cad.nro_docref1   = asi_nro_doc
       and ca.flag_estado    <> '0'
       and cad.tipo_docref1  is not null
       and cad.nro_docref1   is not null
       and cad.cod_relacion  is not null;
    
    if ln_count > 0 then
       select cad.cnta_ctbl
         into ls_result
         from cntbl_asiento ca,
              cntbl_Asiento_det cad
        where ca.origen         = cad.origen
          and ca.ano            = cad.ano
          and ca.mes            = cad.mes
          and ca.nro_libro      = cad.nro_libro
          and ca.nro_Asiento    = cad.nro_Asiento
          and cad.cod_relacion  = asi_cod_relacion
          and cad.tipo_docref1  = asi_tipo_doc
          and cad.nro_docref1   = asi_nro_doc
          and ca.flag_estado    <> '0'
          and cad.tipo_docref1  is not null
          and cad.nro_docref1   is not null
          and cad.cod_relacion  is not null
          and rownum            = 1
       order by ca.ano desc, ca.mes desc, ca.fecha_cntbl desc;
     
    end if;

   RETURN(ls_Result);

  END; 
  
  PROCEDURE sp_asiento_redondeo(
      asi_origen         origen.cod_origen%TYPE, 
      ani_year           number, 
      ani_mes            number,
      asi_cnta_cntbl     cntbl_cnta.cnta_ctbl%TYPE,
      asi_cod_relacion   cntbl_asiento_det.cod_relacion%TYPE,
      asi_tipo_doc       cntbl_asiento_det.tipo_docref1%TYPE,
      asi_nro_doc        cntbl_asiento_det.nro_docref1%TYPE,
      asi_cod_usr        usuario.cod_usr%TYPE
  ) is
    
    ln_nro_Asiento     cntbl_libro_mes.nro_asiento%TYPE;
    ln_count           number;
    ln_tasa_cambio     cntbl_asiento.tasa_cambio%TYPE;
    ld_fecha           date;
    ls_desc_glosa      cntbl_asiento.desc_glosa%TYPE;
    ls_flag_deb_hab    cntbl_asiento_det.flag_debhab%TYPE;    
    ln_item            cntbl_asiento_det.item%TYPE;
    ls_cnta_cntbl      cntbl_asiento_det.cnta_ctbl%TYPE;
    ln_imp_movsol      cntbl_Asiento_Det.Imp_Movsol%TYPE;
    ln_imp_movdol      cntbl_asiento_Det.Imp_Movdol%TYPE;
    
    cursor c_datos is
      select cad.cnta_ctbl,
             cc.desc_cnta,
             cad.cod_relacion,
             p.nom_proveedor, 
             decode(p.ruc, null, p.nro_doc_ident, p.ruc) as ruc_dni,
             cad.tipo_docref1,
             trim(cad.nro_docref1) as nro_docref1,
             case 
               when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) then
                 sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
               else
                 0
             end as saldo_deb_sol,
             case 
               when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) then
                 sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
               else
                 0
             end as saldo_hab_sol,
             case 
               when sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) then
                 sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0))
               else
                 0
             end as saldo_deb_dol,
             case 
               when sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) then
                 sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0))
               else
                 0
             end as saldo_hab_dol
        from cntbl_Asiento     ca,
             cntbl_asiento_det cad,
             proveedor         p,
             cntbl_cnta        cc
       where ca.origen             = cad.origen
         and ca.ano                = cad.ano
         and ca.mes                = cad.mes
         and ca.nro_libro          = cad.nro_libro   
         and ca.nro_asiento        = cad.nro_asiento
         and cad.cod_relacion      = p.proveedor
         and cad.cnta_ctbl         = cc.cnta_ctbl
         and cad.ano               = ani_year
         and cad.mes               <= ani_mes
         and cad.cnta_ctbl         = asi_cnta_cntbl
         and cad.cod_relacion      = asi_cod_relacion
         and cad.tipo_docref1      = asi_tipo_doc 
         and trim(cad.nro_docref1) = trim(asi_nro_doc)
         and ca.flag_estado <> '0'  
    group by cad.cnta_ctbl,
             cc.desc_cnta,
             cad.cod_relacion,
             p.nom_proveedor, 
             decode(p.ruc, null, p.nro_doc_ident, p.ruc),
             cad.tipo_docref1,
             trim(cad.nro_docref1)
    having case 
             when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
             else
               0
           end > 0 or
           case 
             when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
             else
               0
           end > 0 or
           case 
             when sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) then
               sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0))
             else
               0
           end > 0 or
           case 
             when sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) then
               sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0))
             else
               0
           end > 0 ;         
  
  begin
    -- Creo nuevo asiento
    select count(*)
      into ln_count
      from cntbl_Asiento     ca,
           cntbl_asiento_det cad,
           proveedor         p,
           cntbl_cnta        cc
     where ca.origen             = cad.origen
       and ca.ano                = cad.ano
       and ca.mes                = cad.mes
       and ca.nro_libro          = cad.nro_libro   
       and ca.nro_asiento        = cad.nro_asiento
       and cad.cod_relacion      = p.proveedor
       and cad.cnta_ctbl         = cc.cnta_ctbl
       and cad.ano               = ani_year
       and cad.mes               <= ani_mes
       and cad.cnta_ctbl         = asi_cnta_cntbl
       and cad.cod_relacion      = asi_cod_relacion
       and cad.tipo_docref1      = asi_tipo_doc 
       and trim(cad.nro_docref1) = trim(asi_nro_doc)
       and ca.flag_estado <> '0'  
    group by cad.cnta_ctbl,
             cc.desc_cnta,
             cad.cod_relacion,
             p.nom_proveedor, 
             decode(p.ruc, null, p.nro_doc_ident, p.ruc),
             cad.tipo_docref1,
             trim(cad.nro_docref1)
    having case 
             when sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0))
             else
               0
           end > 0 or
           case 
             when sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0)) then
               sum(decode(cad.flag_debhab, 'H', cad.imp_movsol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movsol, 0))
             else
               0
           end > 0 or
           case 
             when sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) > sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) then
               sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) - sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0))
             else
               0
           end > 0 or
           case 
             when sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) > sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0)) then
               sum(decode(cad.flag_debhab, 'H', cad.imp_movdol, 0)) - sum(decode(cad.flag_debhab, 'D', cad.imp_movdol, 0))
             else
               0
           end > 0 ;   
    
    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000, 'No hay registros para procesar. Confirmar por favor.' 
                                     || chr(13) || 'Tipo Doc: ' || asi_tipo_doc
                                     || chr(13) || 'Nro Doc: ' || asi_nro_doc
                                     || chr(13) || 'Cnta Cntbl: ' || asi_cnta_cntbl
                                     || chr(13) || 'Cnta Cntbl: ' || asi_cnta_cntbl);
    end if;    
    
    -- Obtengo un nuevo numerador de asiento
    select count(*)
      into ln_count
      from cntbl_libro_mes c
     where c.origen  = asi_origen
       and c.nro_libro = USP_SIGRE_CNTBL.in_libro_ajuste_red
       and c.ano       = ani_year
       and c.mes       = ani_mes;
    
    if ln_count = 0 then
       insert into cntbl_libro_mes(
              origen, nro_libro, ano, mes, nro_asiento)
       values(
              asi_origen, in_libro_ajuste_red, ani_year, ani_mes, 1);
    end if;   
    
    select c.nro_asiento
      into ln_nro_Asiento
      from cntbl_libro_mes c
     where c.origen  = asi_origen
       and c.nro_libro = in_libro_ajuste_red
       and c.ano       = ani_year
       and c.mes       = ani_mes for update;
    
    -- Obtengo la tasa de cambio
    ld_fecha       := PKG_CONFIG.LAST_DAY(ani_mes, ani_year);
    ln_tasa_cambio := usf_fin_tasa_cambio(ld_fecha);
    ls_desc_glosa  := 'ASIENTO GENERADO AUTOMATICAMENTE';
    
    -- Inserto la cabecera del asiento
    insert into cntbl_Asiento(
           Origen, Ano, Mes, Nro_Libro, Nro_Asiento, Cod_Moneda, 
           Tasa_Cambio, Desc_Glosa, Fecha_Cntbl, Fec_Registro, Cod_Usr,  
           Tot_Soldeb, Tot_Solhab, Tot_Doldeb, Tot_Dolhab)
    values(
           asi_origen, ani_year, ani_mes, in_libro_ajuste_red, ln_nro_asiento, PKG_LOGISTICA.is_soles,
           ln_tasa_cambio, ls_desc_glosa, ld_fecha, sysdate, asi_cod_usr,
           0, 0, 0, 0);
    
    -- Inserto el detalle del asiento
    ln_item := 1;
    for lc_reg in c_datos loop
      
        if lc_reg.saldo_deb_sol > 0 or lc_reg.saldo_deb_dol > 0 then
           ls_flag_deb_hab := 'H';
        else
           ls_flag_deb_hab := 'D';
        end if;
        
        -- Obtengo el monto en soles
        if lc_reg.saldo_deb_sol > 0 then
           ln_imp_movsol := lc_reg.saldo_deb_sol;
        else
           ln_imp_movsol := lc_reg.saldo_hab_sol;
        end if;
        
        -- Obtengo el monto en dolares
        if lc_reg.saldo_deb_dol > 0 then
           ln_imp_movdol := lc_reg.saldo_deb_dol;
        else
           ln_imp_movdol := lc_reg.saldo_hab_dol;
        end if;
        
        -- Inserto el detalle
        insert into cntbl_asiento_det(
               origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, 
               fec_cntbl, det_glosa, flag_gen_aut, flag_debhab, tipo_docref1, 
               nro_docref1, cod_relacion, imp_movsol, imp_movdol)
        values(
               asi_origen, ani_year, ani_mes, in_libro_ajuste_red, ln_nro_Asiento, ln_item, lc_reg.cnta_ctbl,
               ld_Fecha, ls_desc_glosa, '1', ls_flag_deb_hab, lc_reg.tipo_docref1,
               lc_reg.nro_docref1, lc_reg.cod_relacion, ln_imp_movsol, ln_imp_movdol);
        
        -- Incremento el item
        ln_item := ln_item + 1;
        
        -- Ahora inserto el otro detalle
        if ls_flag_deb_hab = 'D' then
           ls_flag_deb_hab := 'H';
        else
           ls_flag_deb_hab := 'D';
        end if;
        
        -- Obtengo la cuenta correcta para al tipo
        if ls_flag_deb_hab = 'D' then
           ls_cnta_cntbl := USP_SIGRE_CNTBL.is_cnta_cntbl_red_deb;
        else
           ls_cnta_cntbl := USP_SIGRE_CNTBL.is_cnta_cntbl_red_hab;
        end if;
        
        -- Inserto el detalle
        insert into cntbl_asiento_det(
               origen, ano, mes, nro_libro, nro_asiento, item, cnta_ctbl, 
               fec_cntbl, det_glosa, flag_gen_aut, flag_debhab, tipo_docref1, 
               nro_docref1, cod_relacion, imp_movsol, imp_movdol)
        values(
               asi_origen, ani_year, ani_mes, in_libro_ajuste_red, ln_nro_Asiento, ln_item, ls_cnta_cntbl,
               ld_Fecha, ls_desc_glosa, '1', ls_flag_deb_hab, lc_reg.tipo_docref1,
               lc_reg.nro_docref1, null, ln_imp_movsol, ln_imp_movdol);

    end loop;
    
    -- Actualizo los totales del asiento contable
    update cntbl_asiento ca
       set ca.tot_soldeb = (select nvl(sum(cad.imp_movsol), 0)
                              from cntbl_asiento_det cad
                             where cad.origen      = asi_origen
                               and cad.ano         = ani_year
                               and cad.mes         = ani_mes
                               and cad.nro_libro   = in_libro_ajuste_red
                               and cad.nro_asiento = ln_nro_asiento
                               and cad.flag_debhab = 'D'),
           ca.tot_solhab = (select nvl(sum(cad.imp_movsol), 0)
                              from cntbl_asiento_det cad
                             where cad.origen      = asi_origen
                               and cad.ano         = ani_year
                               and cad.mes         = ani_mes
                               and cad.nro_libro   = in_libro_ajuste_red
                               and cad.nro_asiento = ln_nro_asiento
                               and cad.flag_debhab = 'H'),                                
           ca.tot_doldeb = (select nvl(sum(cad.imp_movdol), 0)
                              from cntbl_asiento_det cad
                             where cad.origen      = asi_origen
                               and cad.ano         = ani_year
                               and cad.mes         = ani_mes
                               and cad.nro_libro   = in_libro_ajuste_red
                               and cad.nro_asiento = ln_nro_asiento
                               and cad.flag_debhab = 'D'),
           ca.tot_dolhab = (select nvl(sum(cad.imp_movdol), 0)
                              from cntbl_asiento_det cad
                             where cad.origen      = asi_origen
                               and cad.ano         = ani_year
                               and cad.mes         = ani_mes
                               and cad.nro_libro   = in_libro_ajuste_red
                               and cad.nro_asiento = ln_nro_asiento
                               and cad.flag_debhab = 'H')
     where ca.origen      = asi_origen
       and ca.ano         = ani_year
       and ca.mes         = ani_mes
       and ca.nro_libro   = in_libro_ajuste_red
       and ca.nro_asiento = ln_nro_asiento;

    -- Actualizo el numerador
    update cntbl_libro_mes c
       set c.nro_asiento = ln_nro_Asiento + 1
     where c.origen  = asi_origen
       and c.nro_libro = in_libro_ajuste_red
       and c.ano       = ani_year
       and c.mes       = ani_mes;
    
    commit;
    
  end;
  
  -- Function and procedure implementations
  PROCEDURE sp_delete_pre_asiento(
            asi_origen    origen.cod_origen%TYPE, 
            ani_nro_libro cntbl_libro.nro_libro%TYPE, 
            ani_year      number, 
            ani_mes       number
  ) is
    --<LocalVariable> <Datatype>;
  begin
      delete cntbl_pre_asiento_det_aux
       where origen          = asi_origen
         and nro_libro       = ani_nro_libro
         and nro_provisional in (select ca.nro_provisional
                                   from cntbl_pre_asiento ca
                                  where ca.origen = asi_origen
                                    and ca.nro_libro = ani_nro_libro
                                    and to_number(to_char(ca.fec_cntbl, 'yyyy')) = ani_year
                                    and to_number(to_char(ca.fec_cntbl, 'mm'))   = ani_mes);

      delete cntbl_pre_asiento_det
       where origen          = asi_origen
         and nro_libro       = ani_nro_libro
         and nro_provisional in (select ca.nro_provisional
                                   from cntbl_pre_asiento ca
                                  where ca.origen = asi_origen
                                    and ca.nro_libro = ani_nro_libro
                                    and to_number(to_char(ca.fec_cntbl, 'yyyy')) = ani_year
                                    and to_number(to_char(ca.fec_cntbl, 'mm'))   = ani_mes);

      delete cntbl_pre_asiento ca
      where origen          = asi_origen
        and nro_libro       = ani_nro_libro
        and to_number(to_char(ca.fec_cntbl, 'yyyy')) = ani_year
        and to_number(to_char(ca.fec_cntbl, 'mm'))   = ani_mes;



  end;
  

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
  ) is

  ls_cnta_cntbl         cntbl_cnta.cnta_ctbl%type    ;
  ls_desc_cnta          cntbl_cnta.desc_cnta%TYPE    ;
  ls_flag_cencos        cntbl_cnta.flag_cencos%type  ;
  ls_flag_doc           cntbl_cnta.flag_doc_ref%type ;
  ls_flag_crel          cntbl_cnta.flag_codrel%type  ;
  ls_flag_centro_benef  cntbl_cnta.flag_centro_benef%type  ;
  ls_cencos             centros_costo.cencos%type    ;
  ls_tipo_doc           doc_tipo.tipo_doc%Type       ;
  ls_nro_doc            calculo.nro_doc_cc%type      ;
  ls_cod_relacion       maestro.cod_trabajador%type  ;
  ls_flag_debhab        cntbl_asiento_det.flag_debhab%type ;
  ln_count              Number                       ;
  ls_centro_benef       maestro.centro_benef%type    ;
  ls_det_glosa          cntbl_asiento_det.det_glosa%TYPE;

  begin


    if Substr(asi_cnta_ctbl,1,1) = '9' then --es una cuenta de gasto

       if asi_cencos is null then
           RAISE_APPLICATION_ERROR(-20000,'La Cuenta Contable ' || asi_cnta_ctbl || ' pide como referencia centro de costo, pero el Centro de Costo del trabajador '
                                           ||asi_cod_relacion||' esta vacio, por favor verifique.'
                                           || chr(13) || 'Concepto: ' || asi_concep);
           return ;
       end if ;

       select count(*)
         into ln_count
         from matriz_transf_cntbl_cencos mt
        where mt.org_cnta_ctbl = asi_cnta_ctbl
          and mt.cencos        = asi_cencos
          and mt.flag_estado   = '1';

       if ln_count = 0 then
          ls_cnta_cntbl := asi_cnta_ctbl ;
       else
          select dst_cnta_ctbl
            into ls_cnta_cntbl
            from matriz_transf_cntbl_cencos mt
           where mt.org_cnta_ctbl = asi_cnta_ctbl
             and mt.cencos        = asi_cencos
             and mt.flag_estado   = '1';

          if ls_cnta_cntbl is null then
             RAISE_APPLICATION_ERROR(-20000,'Centro de costo y Cuenta Contable NO TIENE Cuenta Destino, '
                                         || 'en la matriz de dstribucion, por favor verifique.'
                                         || chr(13) || 'Centro Costo: ' || asi_cencos
                                         || chr(13) || 'Cnta Cntbl: ' || asi_cnta_ctbl);
                                         
             return ;
          end if ;
        end if ;
    else
       ls_cnta_cntbl := asi_cnta_ctbl ;
    end if;

    --verifico si nueva cuenta existe o esta activa
    select count(*)
      into ln_count
      from cntbl_cnta c
     where c.cnta_ctbl = ls_cnta_cntbl
       and c.flag_estado = '1' ;

    if ln_count = 0 then
       RAISE_APPLICATION_ERROR(-20000,'La Cuenta Contable '||ls_cnta_cntbl||' es inexistente o inactiva');
      return ;
    end if ;

    --verificar valores de datos requeridos segun cuenta
    select Nvl(c.flag_cencos,'0'),Nvl(c.flag_doc_ref,'0'),Nvl(c.flag_codrel,'0'), Nvl(c.flag_centro_benef,'0'),
           c.desc_cnta
      into ls_flag_cencos,ls_flag_doc,ls_flag_crel,ls_flag_centro_benef, ls_desc_cnta
      from cntbl_cnta c
     where c.cnta_ctbl = ls_cnta_cntbl ;


    if ls_flag_cencos = '1' then --requiere centro de costo
       ls_cencos := asi_cencos ;
    else
       ls_cencos := null ;
    end if ;

    if ls_flag_centro_benef = '1' then --requiere centro de beneficio
       ls_centro_benef := asi_cbenef ;
    else
       ls_centro_benef := null ;
    end if ;

    if ls_flag_doc = '1' then --requiere docuemnto de referencia
       if asi_tipo_doc is null then --tipo de documento no puede ser nulo
          RAISE_APPLICATION_ERROR(-20000,'El Concepto ' || asi_concep || ' tiene la Cuenta Contable ' || ls_cnta_cntbl 
                                       || ' la cual esta configurada para que pida Documento de Referencia.'
                                       || chr(13) || 'Cod Trabajador: ' || asi_cod_trabajador
                                       || chr(13) || 'Tipo Doc: ' || ls_tipo_doc
                                       || chr(13) || 'Nro Doc: ' || ls_nro_doc);
       else
          ls_tipo_doc := asi_tipo_doc ;
       end if ;

       if asi_nro_doc is null then --nro de documento no puede ser nulo
          RAISE_APPLICATION_ERROR(-20000,'El Concepto ' || asi_concep || ' tiene la Cuenta Contable ' || ls_cnta_cntbl 
                                       || ' la cual esta configurada para que pida Documento de Referencia.'
                                       || chr(13) || 'Cod Trabajador: ' || asi_cod_trabajador
                                       || chr(13) || 'Tipo Doc: ' || ls_tipo_doc
                                       || chr(13) || 'Nro Doc: ' || ls_nro_doc);
       else
          ls_nro_doc := asi_nro_doc ;
       end if ;
    else --no se coloca tipo ni nro de documento
       ls_tipo_doc := null ;
       ls_nro_doc  := null ;
    end if ;

    if ls_flag_crel = '1' then --requiere codigo de relacion
      if asi_cod_relacion is null then --nro de documento no puede ser nulo
          RAISE_APPLICATION_ERROR(-20000,'El Concepto ' || asi_concep || ' tiene la Cuenta Contable ' || ls_cnta_cntbl 
                                       || ' la cual esta configurada para que pida Código de Relación.'
                                       || chr(13) || 'Cod Trabajador: ' || asi_cod_trabajador
                                       || chr(13) || 'Tipo Doc: ' || ls_tipo_doc
                                       || chr(13) || 'Nro Doc: ' || ls_nro_doc);
       else
          ls_cod_relacion := asi_cod_relacion ;
       end if ;
       
    else
       ls_cod_relacion := null ;
    end if ;



    if asi_flag_negativo = '0' then
       --invertir valor por valores negativos
       if asi_flag_debhab = 'D' THEN
          ls_flag_debhab := 'H';
       else
          ls_flag_debhab := 'D' ;
       end if ;
    else
       ls_flag_debhab := asi_flag_debhab ;
    end if ;
    
    -- detalle de la glosa
    if asi_glosa_det is null or trim(asi_glosa_det) = '' then
       ls_det_glosa := ls_desc_cnta;
    else
       ls_det_glosa := asi_glosa_det;
    end if;
    
    --actualiza asiento si ya existe
    Update cntbl_asiento_det cad
       set cad.imp_movsol = cad.imp_movsol + ani_imp_soles,
           cad.imp_movdol = cad.imp_movdol + ani_imp_dolares
      Where cad.origen                = asi_origen
        and cad.ano                   = ani_year
        and cad.mes                   = ani_mes
        and cad.nro_libro             = ani_nro_libro
        and cad.nro_asiento           = ani_nro_asiento
        and cad.cnta_ctbl             = ls_cnta_cntbl
        and cad.fec_cntbl             = adi_fec_proceso
        and cad.flag_debhab           = ls_flag_debhab
        and Nvl(cad.cencos,'X')       = Nvl(ls_cencos,'X')
        and Nvl(cad.tipo_docref1,'X')  = Nvl(ls_tipo_doc,'X')
        and Nvl(cad.nro_docref1,'X')  = Nvl(ls_nro_doc,'X')
        and Nvl(cad.cod_relacion,'X') = Nvl(ls_cod_relacion,'X')
        and Nvl(cad.centro_benef,'X') = Nvl(ls_centro_benef,'X')
        and nvl(cad.det_glosa, 'X')   = nvl(ls_det_glosa, 'X')
        and nvl(cad.concep, 'X')      = NVL(asi_concep, 'X');



    IF SQL%NOTFOUND THEN
       --CONTADOR DE ITEM
       --incrementa contador del detalle
       -- Se ha aumentado centro de beneficio, MM

       ani_item := ani_item + 1 ;

       Insert Into cntbl_asiento_det(
              origen, ano, mes, nro_libro, nro_asiento, item, 
              cnta_ctbl, fec_cntbl, det_glosa, flag_gen_aut, flag_debhab, 
              cencos, cod_ctabco, tipo_docref1, nro_docref1, cod_relacion,
              imp_movsol, imp_movdol, flag_replicacion, centro_benef, concep )
       Values(
              asi_origen     , ani_year, ani_mes, ani_nro_libro , ani_nro_asiento , ani_item    ,
              ls_cnta_cntbl  , adi_fec_proceso , ls_det_glosa  , '0'             , ls_flag_debhab , 
              ls_cencos      , asi_cod_ctabco , ls_tipo_doc     , ls_nro_doc      , ls_cod_relacion,
              ani_imp_soles  , ani_imp_dolares, '1'             , ls_centro_benef , asi_concep );


    END IF ;

  end;



begin
  -- Initialization
  is_cnta_cntbl_red_hab := PKG_CONFIG.USF_GET_PARAMETER('CNTA_CNTBL_REDONDEO_HAB', '77610102');
  is_cnta_cntbl_red_deb := PKG_CONFIG.USF_GET_PARAMETER('CNTA_CNTBL_REDONDEO_DEB', '97101402');
  in_libro_ajuste_red   := to_number(PKG_CONFIG.USF_GET_PARAMETER('LIBRO_AJUSTE_REDONDEO', '86'));
  
  is_cc_perdida_dif     := PKG_CONFIG.USF_GET_PARAMETER('CNTA_CNTBL_PERDIDA_DIF', '95706101');
  is_cc_ganancia_dif    := PKG_CONFIG.USF_GET_PARAMETER('CNTA_CNTBL_GANANCIA_DIF', '77610102');
  
  select count(*)
    into in_count
    from cntbl_libro cl
   where cl.nro_libro = in_libro_ajuste_red;
  
  if in_count = 0 then
     insert into cntbl_libro(nro_libro, desc_libro, num_provisional)
     values(in_libro_ajuste_red, 'AJUSTES POR REDONDEO', 1);
     
     commit;
  end if;
  
  
end USP_SIGRE_CNTBL;
/

prompt
prompt Creating package body USP_SIGRE_RRHH
prompt ====================================
prompt
create or replace package body cantabria.USP_SIGRE_RRHH is

  -- Private type declarations
  --type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  --<ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  --<VariableName> <Datatype>;
  function of_get_toneladas(asi_origen          rrhh_param_org.origen%TYPE,
                            adi_fec_proceso     rrhh_param_org.fec_proceso%TYPE,
                            asi_tipo_trabajador rrhh_param_org.tipo_trabajador%TYPE,
                            asi_tipo_planilla   rrhh_param_org.tipo_planilla%TYPE,
                            asi_tripulante      maestro.cod_trabajador%TYPE
  ) return number is
    ln_Toneladas  number;
    ld_fecha1     date;
    ld_fecha2     date;
    ln_count      number;
  begin
    select count(*)  
      into ln_count
      from rrhh_param_org r
     where r.origen       = asi_origen
       and r.fec_proceso  = adi_fec_proceso
       and r.tipo_trabajador = asi_tipo_trabajador
       and r.tipo_planilla   = asi_tipo_planilla;
    
    if ln_count = 0 then
       return 0; 
    end if;

    select r.fec_inicio, r.fec_final  
      into ld_fecha1, ld_fecha2
      from rrhh_param_org r
     where r.origen       = asi_origen
       and r.fec_proceso  = adi_fec_proceso
       and r.tipo_trabajador = asi_tipo_trabajador
       and r.tipo_planilla   = asi_tipo_planilla;
  
    select nvl(sum(flpp.pesca_asignada),0)
      into ln_Toneladas
      from fl_participacion_pesca flpp
     where flpp.tripulante = asi_tripulante
       and trunc(flpp.fecha) between trunc(ld_Fecha1) and trunc(ld_Fecha2);
    
    return ln_Toneladas;
  end ;
                              
  function of_total_partic_pesca(adi_fec_proceso     date,
                                 asi_codtra          maestro.cod_trabajador%TYPE
  ) return number is
  begin
    return of_total_concepto(to_number(to_char(adi_fec_proceso, 'yyyy')), 
                             to_number(to_char(adi_fec_proceso, 'mm')),
                             is_cnc_partic_pesca,
                             asi_codtra);
  end ;
  
  -- Funcion que devuelve el total de la bonificación de tripulantes
  function of_total_bonif_pesca(adi_fec_proceso     date,
                                 asi_codtra          maestro.cod_trabajador%TYPE
  ) return number is
  begin
    return of_total_concepto(to_number(to_char(adi_fec_proceso, 'yyyy')), 
                             to_number(to_char(adi_fec_proceso, 'mm')),
                             is_cnc_bonif_tri,
                             asi_codtra);
  end ;
  
  -- total de la base de calculo para la gratificación
  function of_base_calc_gratif(adi_fec_proceso     date,
                                 asi_codtra          maestro.cod_trabajador%TYPE
  ) return number is
    ln_return number;
  begin
    select nvl(sum(hc.imp_soles),0)
      into ln_return
      from historico_calculo hc,
           grupo_calculo_det gcd
     where hc.concep                                    = gcd.concepto_calc
       and gcd.grupo_calculo                            = is_grp_gratif_tri
       and hc.cod_trabajador                            = asi_codtra
       and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = to_number(to_char(adi_fec_proceso, 'yyyy'))
       and to_number(to_char(hc.fec_calc_plan, 'mm'))   = to_number(to_char(adi_fec_proceso, 'mm'));
    
    return ln_Return;
  end ;

  -- total de la base de calculo de acuerdo al tipo de planilla
  function of_base_calculo(adi_fec_proceso     date,
                           asi_tipo_planilla   calculo.tipo_planilla%TYPE,
                           asi_codtra          maestro.cod_trabajador%TYPE
  ) return number is
    ln_return number;
  begin
    
    if asi_tipo_planilla = is_planilla_gratif_tri then
      
       select nvl(sum(hc.imp_soles),0)
         into ln_return
         from historico_calculo hc,
              grupo_calculo_det gcd
        where hc.concep                                    = gcd.concepto_calc
          and gcd.grupo_calculo                            = is_grp_gratif_tri
          and hc.cod_trabajador                            = asi_codtra
          and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = to_number(to_char(adi_fec_proceso, 'yyyy'))
          and to_number(to_char(hc.fec_calc_plan, 'mm'))   = to_number(to_char(adi_fec_proceso, 'mm'));
          
    elsif asi_tipo_planilla = is_planilla_VACAC_tri then
    
       select nvl(sum(hc.imp_soles),0)
         into ln_return
         from historico_calculo hc,
              grupo_calculo_det gcd
        where hc.concep                                    = gcd.concepto_calc
          and gcd.grupo_calculo                            = is_planilla_VACAC_tri
          and hc.cod_trabajador                            = asi_codtra
          and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = to_number(to_char(adi_fec_proceso, 'yyyy'))
          and to_number(to_char(hc.fec_calc_plan, 'mm'))   = to_number(to_char(adi_fec_proceso, 'mm'));

    elsif asi_tipo_planilla = is_planilla_CTS_tri then
    
       select nvl(sum(hc.imp_soles),0)
         into ln_return
         from historico_calculo hc,
              grupo_calculo_det gcd
        where hc.concep                                    = gcd.concepto_calc
          and gcd.grupo_calculo                            = is_planilla_CTS_tri
          and hc.cod_trabajador                            = asi_codtra
          and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = to_number(to_char(adi_fec_proceso, 'yyyy'))
          and to_number(to_char(hc.fec_calc_plan, 'mm'))   = to_number(to_char(adi_fec_proceso, 'mm'));

    else
       ln_Return := 0;
    end if;
    
    return ln_Return;
  end ;

  -- Obtengo el total obtenido por concepto, de manera mensual
  function of_total_concepto(ani_year            number,
                             ani_mes             number,
                             asi_concepto        concepto.concep%TYPE,
                             asi_codtra          maestro.cod_trabajador%TYPE
  ) return number is
    ln_total_hist     number;
    ln_total_calc     number;
  begin
  
    select nvl(sum(hc.imp_soles),0)
      into ln_total_hist
      from historico_calculo hc
     where hc.cod_trabajador                            = asi_codtra
       and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = ani_year
       and to_number(to_char(hc.fec_calc_plan, 'mm'))   = ani_mes
       and hc.concep                                    = asi_concepto;
    
    select nvl(sum(ca.imp_soles),0)
      into ln_total_calc
      from calculo ca,
           maestro m
     where ca.cod_trabajador                            = m.cod_trabajador
       and ca.cod_trabajador                            = asi_codtra
       and to_number(to_char(ca.fec_proceso, 'yyyy'))   = ani_year
       and to_number(to_char(ca.fec_proceso, 'mm'))     = ani_mes
       and ca.concep                                    = asi_concepto;

    return ln_total_calc + ln_total_hist;
  end ;

  function of_tipo_planilla(
          asi_tipo_planilla   rrhh_param_org.tipo_planilla%TYPE
  ) return varchar2 is
    ls_Return varchar2(1000);
  begin
    select decode(asi_tipo_planilla, 'N', 'Planilla Normal', 
                                     'B', 'Bonificaciones Tripulante', 
                                     'G', 'Gratificacion Tripulante', 
                                     'C', 'CTS Tripulante', 
                                     'V', 'Vacaciones Tripulante')    
      into ls_Return
      from dual;
  
    return ls_Return;
  end ;

  function of_get_tipo_emp(asi_nada varchar2) return varchar2 is
  begin
    return is_tipo_emp;
  end;
  function of_get_tipo_trip(asi_nada varchar2) return varchar2 is
  begin
    return is_tipo_trip;
  end;
    
  function of_dias_asist(
           asi_codtra  maestro.cod_trabajador%TYPE, 
           adi_fecha1  date, 
           adi_Fecha2  date
  ) return decimal is
  
    ln_dias_asistencia   number;
    ln_dias_periodo      number;
    
    ls_grp_dias_inasis         rrhhparam_cconcep.dias_inasis_dsccont%TYPE;
    ls_cnc_vacaciones          concepto.concep%TYPE;
    ln_dias                    number;
    ld_fec_desde               date ;
    ld_fec_hasta               date ;
    ln_faltas                  number ;
    ln_dias_obrero             NUMBER;
    ln_dias_campo              NUMBER;
    ld_fec_ing_trab            maestro.fec_ingreso%TYPE;
    ld_fec_cese                maestro.fec_cese%TYPE;
    ls_flag_tipo_sueldo        tipo_trabajador.flag_ingreso_boleta%TYPE;
    ls_tipo_trabajador         tipo_trabajador.tipo_trabajador%TYPE;
    
    --  Cursor de inasistencias a descontar
    cursor c_inasistencias is
      select i.dias_inasist from inasistencia i
       where i.cod_trabajador = asi_codtra
         and (i.concep in ( select d.concepto_calc
                             from grupo_calculo_det d
                            where d.grupo_calculo = ls_grp_dias_inasis )
              or i.concep = ls_cnc_vacaciones)
         and trunc(i.fec_movim) between trunc(adi_fecha1) and trunc(adi_fecha2)
         and i.flag_vacac_adelantadas = '0' ;
    
  begin
    
    --  ***********************************************************************
    --  ***   REALIZA CALCULO DE DIAS TRABAJADOS PARA CALCULO DE PLANILLA   ***
    --  ***********************************************************************
    
    ld_fec_desde := adi_fecha1;
    ld_fec_hasta := adi_Fecha2;
    
    
    
    ln_dias_periodo := adi_fecha2 - adi_fecha1 + 1;
    
    -- Obtengo la fecha de inicio de trabajo del trabajador
    select m.fec_ingreso, m.fec_cese, m.tipo_trabajador, tt.flag_ingreso_boleta
      into ld_fec_ing_trab, ld_fec_cese, ls_tipo_trabajador, ls_flag_tipo_sueldo
      from maestro m,
           tipo_trabajador tt
     where m.tipo_trabajador = tt.tipo_trabajador
       and m.cod_trabajador = asi_codtra;
     
    -- Grupo de dias de inasistencia
    select c.dias_inasis_dsccont
      into ls_grp_dias_inasis
      from rrhhparam_cconcep c
     where c.reckey = '1' ;


    -- Obtengo el concepto de vacaciones
    select gc.concepto_gen
      into ls_cnc_vacaciones
      from grupo_calculo gc
     where gc.grupo_calculo = (select t.gan_fij_calc_vacac from rrhhparam_cconcep t);

    if ld_fec_hasta < ld_fec_ing_trab then
       -- El trabajador ha ingresado despues del rango por lo que no corresponde nada
       return 0;
    end if;

    -- Verifico si la fecha de inicio de calculo es mayor o menor de la fecha de inicio de trabajo
    if ld_fec_desde < ld_fec_ing_trab then
       ld_fec_desde := ld_fec_ing_trab;
    end if;

    --Fecha de cese
    if ld_fec_cese is not null then
       if ld_fec_cese < ld_fec_desde then return 0; end if;
       if ld_fec_cese < ld_fec_hasta then
          ld_fec_hasta := ld_fec_cese;
       end if;
    end if;

    if ld_fec_desde > ld_fec_hasta then
       RAISE_APPLICATION_ERROR(-20000, 'Error, la fecha de inicio es mayor a la fecha de fin ' || asi_codtra);
    end if;

    if ls_tipo_trabajador = is_tipo_trip then
       select count(distinct fa.fecha)
         into ln_dias_asistencia
         from fl_asistencia fa
        where fa.tripulante = asi_codtra
          and trunc(fa.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

    elsif ls_tipo_trabajador in (is_tipo_des, is_tipo_ser) then

       select count(distinct p.fec_parte)
         into ln_dias_asistencia
         from tg_pd_destajo p,
              tg_pd_destajo_det pd
        where p.nro_parte = pd.nro_parte
          and pd.cod_trabajador = asi_codtra
          and trunc(p.fec_parte) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta)
          and p.flag_estado <> '0';

    else
        IF ls_flag_tipo_sueldo = 'J' THEN
           -- Dias Trabajados
           SELECT COUNT(DISTINCT a.fec_movim)
             INTO ln_dias_obrero
             FROM asistencia a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fec_movim) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           SELECT COUNT(DISTINCT a.fecha)
             INTO ln_dias_campo
             FROM pd_jornal_campo a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           ln_dias_asistencia := ln_dias_campo + ln_dias_obrero;
        ELSE
           ln_faltas := 0 ;
           for rc_ina in c_inasistencias loop
             ln_faltas := ln_faltas + nvl(rc_ina.dias_inasist,0) ;
           end loop ;

           ln_dias := ld_fec_hasta - ld_fec_desde + 1;

           if ln_dias > ln_dias_periodo then
              ln_dias := ln_dias_periodo;
           end if;

           if ln_dias < ln_faltas then
              ln_dias_asistencia := 0;
           else
              ln_dias_asistencia := ln_dias - ln_faltas ;
           end if;

        END IF;
    end if;


    if ln_dias_asistencia > ln_dias then
       ln_dias_asistencia := ln_dias ;
    end if ;

    if ln_dias_asistencia > ln_dias_periodo then
       ln_dias_asistencia := ln_dias_periodo;
    end if;

    return(nvl(ln_dias_asistencia,0)) ;
      
               
  end;
  
  -- Asistencia por fecha de proceso
  function of_dias_asist(
           asi_codtra         maestro.cod_trabajador%TYPE, 
           adi_fec_proceso    date,
           asi_origen         origen.cod_origen%TYPE
  ) return decimal is
  
    ln_dias_asistencia   number;
    ln_dias_periodo      number;
    
    ls_grp_dias_inasis         rrhhparam_cconcep.dias_inasis_dsccont%TYPE;
    ls_cnc_vacaciones          concepto.concep%TYPE;
    ln_dias                    number;
    ld_fec_desde               date ;
    ld_fec_hasta               date ;
    ln_faltas                  number ;
    ln_dias_obrero             NUMBER;
    ln_dias_campo              NUMBER;
    ld_fec_ing_trab            maestro.fec_ingreso%TYPE;
    ld_fec_cese                maestro.fec_cese%TYPE;
    ls_flag_tipo_sueldo        tipo_trabajador.flag_ingreso_boleta%TYPE;
    ls_tipo_trabajador         tipo_trabajador.tipo_trabajador%TYPE;
    
    --  Cursor de inasistencias a descontar
    cursor c_inasistencias is
      select i.dias_inasist from inasistencia i
       where i.cod_trabajador = asi_codtra
         and (i.concep in ( select d.concepto_calc
                             from grupo_calculo_det d
                            where d.grupo_calculo = ls_grp_dias_inasis )
              or i.concep = ls_cnc_vacaciones)
         and trunc(i.fec_movim) between trunc(ld_fec_desde) and trunc(ld_fec_hasta)
         and i.flag_vacac_adelantadas = '0' ;
    
  begin
    
    --  ***********************************************************************
    --  ***   REALIZA CALCULO DE DIAS TRABAJADOS PARA CALCULO DE PLANILLA   ***
    --  ***********************************************************************
    
    -- Obtengo la fecha de inicio de trabajo del trabajador
    select m.fec_ingreso, m.fec_cese, m.tipo_trabajador, tt.flag_ingreso_boleta
      into ld_fec_ing_trab, ld_fec_cese, ls_tipo_trabajador, ls_flag_tipo_sueldo
      from maestro m,
           tipo_trabajador tt
     where m.tipo_trabajador = tt.tipo_trabajador
       and m.cod_trabajador = asi_codtra;
    
    -- Obtengo el rando de fechas de la fecha de proceso
    select r.fec_inicio, r.fec_final
      into ld_fec_desde, ld_fec_hasta
      from rrhh_param_org r
     where r.origen          = asi_origen
       and r.tipo_trabajador = ls_tipo_trabajador
       and r.fec_proceso     = adi_fec_proceso
       and r.tipo_planilla   = 'N';
    
    if to_char(adi_fec_proceso, 'mm') = '02' then
       ln_dias_periodo := 30;
    else
       ln_dias_periodo := ld_fec_hasta - ld_fec_desde + 1;
    end if;
    
    if ln_dias_periodo > 31 then
       ln_dias_periodo := 30;
    end if;

    -- Grupo de dias de inasistencia
    select c.dias_inasis_dsccont
      into ls_grp_dias_inasis
      from rrhhparam_cconcep c
     where c.reckey = '1' ;


    -- Obtengo el concepto de vacaciones
    select gc.concepto_gen
      into ls_cnc_vacaciones
      from grupo_calculo gc
     where gc.grupo_calculo = (select t.gan_fij_calc_vacac from rrhhparam_cconcep t);

    if ld_fec_hasta < ld_fec_ing_trab then
       -- El trabajador ha ingresado despues del rango por lo que no corresponde nada
       return 0;
    end if;

    -- Verifico si la fecha de inicio de calculo es mayor o menor de la fecha de inicio de trabajo
    if ld_fec_desde < ld_fec_ing_trab then
       ld_fec_desde := ld_fec_ing_trab;
    end if;

    --Fecha de cese
    if ld_fec_cese is not null then
       if ld_fec_cese < ld_fec_desde then return 0; end if;
       if ld_fec_cese < ld_fec_hasta then
          ld_fec_hasta := ld_fec_cese;
       end if;
    end if;

    if ld_fec_desde > ld_fec_hasta then
       RAISE_APPLICATION_ERROR(-20000, 'Error, la fecha de inicio es mayor a la fecha de fin ' || asi_codtra);
    end if;

    if ls_tipo_trabajador = is_tipo_trip then
       select count(distinct fa.fecha)
         into ln_dias_asistencia
         from fl_asistencia fa
        where fa.tripulante = asi_codtra
          and trunc(fa.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

    elsif ls_tipo_trabajador in (is_tipo_des, is_tipo_ser) then

       select count(distinct p.fec_parte)
         into ln_dias_asistencia
         from tg_pd_destajo p,
              tg_pd_destajo_det pd
        where p.nro_parte = pd.nro_parte
          and pd.cod_trabajador = asi_codtra
          and trunc(p.fec_parte) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta)
          and p.flag_estado <> '0';

    else
        IF ls_flag_tipo_sueldo = 'J' THEN
           -- Dias Trabajados
           SELECT COUNT(DISTINCT a.fec_movim)
             INTO ln_dias_obrero
             FROM asistencia a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fec_movim) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           SELECT COUNT(DISTINCT a.fecha)
             INTO ln_dias_campo
             FROM pd_jornal_campo a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           ln_dias_asistencia := ln_dias_campo + ln_dias_obrero;
        ELSE
           ln_faltas := 0 ;
           for rc_ina in c_inasistencias loop
             ln_faltas := ln_faltas + nvl(rc_ina.dias_inasist,0) ;
           end loop ;

           ln_dias := ld_fec_hasta - ld_fec_desde + 1;

           if ln_dias > ln_dias_periodo then
              ln_dias := ln_dias_periodo;
           end if;

           if ln_dias < ln_faltas then
              ln_dias_asistencia := 0;
           else
              ln_dias_asistencia := ln_dias - ln_faltas ;
           end if;

        END IF;
    end if;


    if ln_dias_asistencia > ln_dias then
       ln_dias_asistencia := ln_dias ;
    end if ;

    if ln_dias_asistencia > ln_dias_periodo then
       ln_dias_asistencia := ln_dias_periodo;
    end if;

    return(nvl(ln_dias_asistencia,0)) ;
      
               
  end;

  -- Asistencia por fecha de proceso y tipo de planilla
  function of_dias_asist(
           asi_codtra        maestro.cod_trabajador%TYPE, 
           adi_fec_proceso   date,
           asi_origen        origen.cod_origen%TYPE,
           asi_tipo_planilla calculo.tipo_planilla%TYPE
  ) return decimal is
  
    ln_dias_asistencia   number;
    ln_dias_periodo      number;
    
    ls_grp_dias_inasis         rrhhparam_cconcep.dias_inasis_dsccont%TYPE;
    ls_cnc_vacaciones          concepto.concep%TYPE;
    ln_dias                    number;
    ld_fec_desde               date ;
    ld_fec_hasta               date ;
    ln_faltas                  number ;
    ln_dias_obrero             NUMBER;
    ln_dias_campo              NUMBER;
    ld_fec_ing_trab            maestro.fec_ingreso%TYPE;
    ld_fec_cese                maestro.fec_cese%TYPE;
    ls_flag_tipo_sueldo        tipo_trabajador.flag_ingreso_boleta%TYPE;
    ls_tipo_trabajador         tipo_trabajador.tipo_trabajador%TYPE;
    
    --  Cursor de inasistencias a descontar
    cursor c_inasistencias is
      select i.dias_inasist from inasistencia i
       where i.cod_trabajador = asi_codtra
         and (i.concep in ( select d.concepto_calc
                             from grupo_calculo_det d
                            where d.grupo_calculo = ls_grp_dias_inasis )
              or i.concep = ls_cnc_vacaciones)
         and trunc(i.fec_movim) between trunc(ld_fec_desde) and trunc(ld_fec_hasta)
         and i.flag_vacac_adelantadas = '0' ;
    
  begin
    
    --  ***********************************************************************
    --  ***   REALIZA CALCULO DE DIAS TRABAJADOS PARA CALCULO DE PLANILLA   ***
    --  ***********************************************************************
    
    -- Obtengo la fecha de inicio de trabajo del trabajador
    select m.fec_ingreso, m.fec_cese, m.tipo_trabajador, tt.flag_ingreso_boleta
      into ld_fec_ing_trab, ld_fec_cese, ls_tipo_trabajador, ls_flag_tipo_sueldo
      from maestro m,
           tipo_trabajador tt
     where m.tipo_trabajador = tt.tipo_trabajador
       and m.cod_trabajador = asi_codtra;
    
    -- Obtengo el rando de fechas de la fecha de proceso
    select r.fec_inicio, r.fec_final
      into ld_fec_desde, ld_fec_hasta
      from rrhh_param_org r
     where r.origen          = asi_origen
       and r.tipo_trabajador = ls_tipo_trabajador
       and r.fec_proceso     = adi_fec_proceso
       and r.tipo_planilla   = asi_tipo_planilla;
    
    if to_char(adi_Fec_proceso, 'mm') = '02' then
       ln_dias_periodo := 30;
    else
       ln_dias_periodo := ld_fec_hasta - ld_fec_desde + 1;
    end if;
    
    if ln_dias_periodo > 31 then
       ln_dias_periodo := 30;
    end if;

    -- Grupo de dias de inasistencia
    select c.dias_inasis_dsccont
      into ls_grp_dias_inasis
      from rrhhparam_cconcep c
     where c.reckey = '1' ;


    -- Obtengo el concepto de vacaciones
    select gc.concepto_gen
      into ls_cnc_vacaciones
      from grupo_calculo gc
     where gc.grupo_calculo = (select t.gan_fij_calc_vacac from rrhhparam_cconcep t);

    if ld_fec_hasta < ld_fec_ing_trab then
       -- El trabajador ha ingresado despues del rango por lo que no corresponde nada
       return 0;
    end if;

    -- Verifico si la fecha de inicio de calculo es mayor o menor de la fecha de inicio de trabajo
    if ld_fec_desde < ld_fec_ing_trab then
       ld_fec_desde := ld_fec_ing_trab;
    end if;

    --Fecha de cese
    if ld_fec_cese is not null then
       if ld_fec_cese < ld_fec_desde then return 0; end if;
       if ld_fec_cese < ld_fec_hasta then
          ld_fec_hasta := ld_fec_cese;
       end if;
    end if;

    if ld_fec_desde > ld_fec_hasta then
       RAISE_APPLICATION_ERROR(-20000, 'Error, la fecha de inicio es mayor a la fecha de fin ' || asi_codtra);
    end if;

    if ls_tipo_trabajador = is_tipo_trip then
       if asi_tipo_planilla = 'B' then
          -- Calculo los días fijos
          select nvl(sum(f.nro_dias),0)
            into ln_dias_asistencia 
            from fl_dias_motorista f
           where f.anio            = to_number(to_char(adi_fec_proceso, 'yyyy'))
             and f.mes             = to_number(to_char(adi_fec_proceso, 'mm'))
             and f.cod_motorista   = asi_codtra;
       else
          select count(distinct fa.fecha)
            into ln_dias_asistencia
            from fl_asistencia fa
           where fa.tripulante = asi_codtra
             and trunc(fa.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);
       end if;
    elsif ls_tipo_trabajador in (is_tipo_des, is_tipo_ser) then

       select count(distinct p.fec_parte)
         into ln_dias_asistencia
         from tg_pd_destajo p,
              tg_pd_destajo_det pd
        where p.nro_parte = pd.nro_parte
          and pd.cod_trabajador = asi_codtra
          and trunc(p.fec_parte) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta)
          and p.flag_estado <> '0';

    else
        IF ls_flag_tipo_sueldo = 'J' THEN
           -- Dias Trabajados
           SELECT COUNT(DISTINCT a.fec_movim)
             INTO ln_dias_obrero
             FROM asistencia a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fec_movim) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           SELECT COUNT(DISTINCT a.fecha)
             INTO ln_dias_campo
             FROM pd_jornal_campo a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           ln_dias_asistencia := ln_dias_campo + ln_dias_obrero;
        ELSE
           ln_faltas := 0 ;
           for rc_ina in c_inasistencias loop
             ln_faltas := ln_faltas + nvl(rc_ina.dias_inasist,0) ;
           end loop ;

           ln_dias := ld_fec_hasta - ld_fec_desde + 1;

           if ln_dias > ln_dias_periodo then
              ln_dias := ln_dias_periodo;
           end if;

           if ln_dias < ln_faltas then
              ln_dias_asistencia := 0;
           else
              ln_dias_asistencia := ln_dias - ln_faltas ;
           end if;

        END IF;
    end if;


    if ln_dias_asistencia > ln_dias then
       ln_dias_asistencia := ln_dias ;
    end if ;

    if ln_dias_asistencia > ln_dias_periodo then
       ln_dias_asistencia := ln_dias_periodo;
    end if;

    return(nvl(ln_dias_asistencia,0)) ;
      
               
  end;

  -- Total de Horas Ordinarias
  function of_hras_normales(
           asi_codtra        maestro.cod_trabajador%TYPE, 
           adi_fec_proceso   date,
           asi_origen        origen.cod_origen%TYPE,
           asi_tipo_planilla rrhh_param_org.tipo_planilla%TYPE
  ) return decimal is
  
    ln_dias_asistencia   number;
    ln_hrs_normal        number;
    ln_dias_periodo      number;
    
    ls_grp_dias_inasis         rrhhparam_cconcep.dias_inasis_dsccont%TYPE;
    ls_cnc_vacaciones          concepto.concep%TYPE;
    ln_dias                    number;
    ld_fec_desde               date ;
    ld_fec_hasta               date ;
    ln_faltas                  number ;
    ln_hras_obrero             NUMBER;
    ln_hras_campo              NUMBER;
    ld_fec_ing_trab            maestro.fec_ingreso%TYPE;
    ld_fec_cese                maestro.fec_cese%TYPE;
    ls_flag_tipo_sueldo        tipo_trabajador.flag_ingreso_boleta%TYPE;
    ls_tipo_trabajador         tipo_trabajador.tipo_trabajador%TYPE;
    
    --  Cursor de inasistencias a descontar
    cursor c_inasistencias is
      select i.dias_inasist from inasistencia i
       where i.cod_trabajador = asi_codtra
         and (i.concep in ( select d.concepto_calc
                             from grupo_calculo_det d
                            where d.grupo_calculo = ls_grp_dias_inasis )
              or i.concep = ls_cnc_vacaciones)
         and trunc(i.fec_movim) between trunc(ld_fec_desde) and trunc(ld_fec_hasta)
         and i.flag_vacac_adelantadas = '0' ;
    
  begin
    
    --  ***********************************************************************
    --  ***   REALIZA CALCULO DE DIAS TRABAJADOS PARA CALCULO DE PLANILLA   ***
    --  ***********************************************************************
    
    -- Obtengo la fecha de inicio de trabajo del trabajador
    select m.fec_ingreso, m.fec_cese, m.tipo_trabajador, tt.flag_ingreso_boleta
      into ld_fec_ing_trab, ld_fec_cese, ls_tipo_trabajador, ls_flag_tipo_sueldo
      from maestro m,
           tipo_trabajador tt
     where m.tipo_trabajador = tt.tipo_trabajador
       and m.cod_trabajador = asi_codtra;
    
    -- Obtengo el rando de fechas de la fecha de proceso
    select r.fec_inicio, r.fec_final
      into ld_fec_desde, ld_fec_hasta
      from rrhh_param_org r
     where r.origen          = asi_origen
       and r.tipo_trabajador = ls_tipo_trabajador
       and r.fec_proceso     = adi_fec_proceso
       and r.tipo_planilla   = asi_tipo_planilla;
       
    ln_dias_periodo := ld_fec_hasta - ld_fec_desde + 1;
    
    if ln_dias_periodo > 31 then
       ln_dias_periodo := 30;
    end if;

    -- Grupo de dias de inasistencia
    select c.dias_inasis_dsccont
      into ls_grp_dias_inasis
      from rrhhparam_cconcep c
     where c.reckey = '1' ;

    -- Obtengo el concepto de vacaciones
    select gc.concepto_gen
      into ls_cnc_vacaciones
      from grupo_calculo gc
     where gc.grupo_calculo = (select t.gan_fij_calc_vacac from rrhhparam_cconcep t);

    if ld_fec_hasta < ld_fec_ing_trab then
       -- El trabajador ha ingresado despues del rango por lo que no corresponde nada
       return 0;
    end if;

    -- Verifico si la fecha de inicio de calculo es mayor o menor de la fecha de inicio de trabajo
    if ld_fec_desde < ld_fec_ing_trab then
       ld_fec_desde := ld_fec_ing_trab;
    end if;

    --Fecha de cese
    if ld_fec_cese is not null then
       if ld_fec_cese < ld_fec_desde then return 0; end if;
       if ld_fec_cese < ld_fec_hasta then
          ld_fec_hasta := ld_fec_cese;
       end if;
    end if;

    if ld_fec_desde > ld_fec_hasta then
       RAISE_APPLICATION_ERROR(-20000, 'Error, la fecha de inicio es mayor a la fecha de fin ' || asi_codtra);
    end if;

    if ls_tipo_trabajador = is_tipo_trip then
       select nvl(sum(fa.horas), 0)
         into ln_hrs_normal
         from fl_asistencia fa
        where fa.tripulante = asi_codtra
          and trunc(fa.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

    elsif ls_tipo_trabajador in (is_tipo_des, is_tipo_ser) then

       select count(distinct p.fec_parte)
         into ln_dias_asistencia
         from tg_pd_destajo p,
              tg_pd_destajo_det pd
        where p.nro_parte = pd.nro_parte
          and pd.cod_trabajador = asi_codtra
          and trunc(p.fec_parte) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta)
          and p.flag_estado <> '0';
          
       ln_hrs_normal := ln_dias_asistencia * 8;

    else
        IF ls_flag_tipo_sueldo = 'J' THEN
           -- Dias Trabajados
           SELECT nvl(sum(nvl(a.hor_diu_nor,0) + nvl(a.hor_noc_nor,0)),0)
             INTO ln_hras_obrero
             FROM asistencia a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fec_movim) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           SELECT nvl(sum(a.hrs_normales),0)
             INTO ln_hras_campo
             FROM pd_jornal_campo a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           ln_hrs_normal := ln_hras_campo + ln_hras_obrero;
        ELSE
           ln_faltas := 0 ;
           for rc_ina in c_inasistencias loop
             ln_faltas := ln_faltas + nvl(rc_ina.dias_inasist,0) ;
           end loop ;

           ln_dias := ld_fec_hasta - ld_fec_desde + 1;

           if ln_dias > ln_dias_periodo then
              ln_dias := ln_dias_periodo;
           end if;

           if ln_dias < ln_faltas then
              ln_dias_asistencia := 0;
           else
              ln_dias_asistencia := ln_dias - ln_faltas ;
           end if;
           
           ln_hrs_normal := ln_dias_asistencia * 8;
           
        END IF;
    end if;

    if ln_hrs_normal > ln_dias_periodo * 8 then
       ln_hrs_normal := ln_dias_periodo * 8;
    end if;

    return(nvl(ln_hrs_normal,0)) ;
      
               
  end;

  -- Total de Horas Ordinarias
  function of_hras_extras(
           asi_codtra        maestro.cod_trabajador%TYPE, 
           adi_fec_proceso   date,
           asi_origen        origen.cod_origen%TYPE,
           asi_tipo_planilla rrhh_param_org.tipo_planilla%TYPE     
  ) return decimal is
  
    ln_hrs_extras        number;
    ld_fec_desde               date ;
    ld_fec_hasta               date ;
    ln_hras_obrero             NUMBER;
    ln_hras_campo              NUMBER;
    ld_fec_ing_trab            maestro.fec_ingreso%TYPE;
    ld_fec_cese                maestro.fec_cese%TYPE;
    ls_flag_tipo_sueldo        tipo_trabajador.flag_ingreso_boleta%TYPE;
    ls_tipo_trabajador         tipo_trabajador.tipo_trabajador%TYPE;
    
  begin
    
    --  ***********************************************************************
    --  ***   REALIZA CALCULO DE DIAS TRABAJADOS PARA CALCULO DE PLANILLA   ***
    --  ***********************************************************************
    
    -- Obtengo la fecha de inicio de trabajo del trabajador
    select m.fec_ingreso, m.fec_cese, m.tipo_trabajador, tt.flag_ingreso_boleta
      into ld_fec_ing_trab, ld_fec_cese, ls_tipo_trabajador, ls_flag_tipo_sueldo
      from maestro m,
           tipo_trabajador tt
     where m.tipo_trabajador = tt.tipo_trabajador
       and m.cod_trabajador = asi_codtra;
    
    -- Obtengo el rando de fechas de la fecha de proceso
    select r.fec_inicio, r.fec_final
      into ld_fec_desde, ld_fec_hasta
      from rrhh_param_org r
     where r.origen          = asi_origen
       and r.tipo_trabajador = ls_tipo_trabajador
       and r.fec_proceso     = adi_fec_proceso
       and r.tipo_planilla   = asi_tipo_planilla;
       
    -- Verifico si la fecha de inicio de calculo es mayor o menor de la fecha de inicio de trabajo
    if ld_fec_desde < ld_fec_ing_trab then
       ld_fec_desde := ld_fec_ing_trab;
    end if;

    --Fecha de cese
    if ld_fec_cese is not null then
       if ld_fec_cese < ld_fec_desde then return 0; end if;
       if ld_fec_cese < ld_fec_hasta then
          ld_fec_hasta := ld_fec_cese;
       end if;
    end if;

    if ld_fec_desde > ld_fec_hasta then
       RAISE_APPLICATION_ERROR(-20000, 'Error, la fecha de inicio es mayor a la fecha de fin ' || asi_codtra);
    end if;

    if ls_tipo_trabajador = is_tipo_trip then
       select nvl(sum(case when fa.horas > 8 then fa.horas - 8 else 0 end), 0)
         into ln_hrs_extras
         from fl_asistencia fa
        where fa.tripulante = asi_codtra
          and trunc(fa.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

    elsif ls_tipo_trabajador in (is_tipo_des, is_tipo_ser) then

       ln_hrs_extras := 0;

    else
        IF ls_flag_tipo_sueldo = 'J' THEN
           -- Dias Trabajados
           SELECT nvl(sum(nvl(a.hor_ext_diu_1,0) + nvl(a.hor_ext_diu_2,0) + nvl(a.hor_ext_noc_1,0) + nvl(a.hor_ext_noc_2,0)),0)
             INTO ln_hras_obrero
             FROM asistencia a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fec_movim) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           SELECT nvl(sum(nvl(a.hrs_extras_25,0) + nvl(a.hrs_extras_35,0) + nvl(a.hrs_noc_extras_35,0) + nvl(a.hrs_extras_100,0)),0)
             INTO ln_hras_campo
             FROM pd_jornal_campo a
            WHERE a.cod_trabajador = asi_codtra
              AND trunc(a.fecha) BETWEEN trunc(ld_fec_desde) AND trunc(ld_fec_hasta);

           ln_hrs_extras := ln_hras_campo + ln_hras_obrero;
           
        ELSE
          
           ln_hrs_extras := 0;
           
        END IF;
    end if;

    return(nvl(ln_hrs_extras,0)) ;
      
               
  end;

  
  -- Function and procedure implementations
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
    ) is

    ln_total_dist           distribucion_cntble.nro_horas%type    ;

    ln_imp_sol              cntbl_Asiento_det.Imp_Movsol%TYPE;
    ln_imp_dol              cntbl_asiento_det.imp_movdol%TYPE;
    ln_tot_imp_sol          cntbl_asiento_det.imp_movsol%TYPE;
    ln_tot_imp_dol          cntbl_asiento_det.imp_movdol%TYPE;

    Cursor c_hist_distribucion is
      select hc.cod_trabajador, 
             decode(hc.cencos, null, m.cencos, hc.cencos) as cencos , 
             decode(hc.centro_benef, null, m.centro_benef, hc.centro_benef) as centro_benef,
             sum(hc.nro_horas) as nro_horas
        from historico_distrib_cntble hc ,
             maestro                  m
       where hc.cod_trabajador     = m.cod_trabajador
         and hc.cod_trabajador     = asi_cod_trabajador
         and to_number(to_char(hc.fec_calculo, 'yyyy')) = to_number(to_char(adi_fec_proceso, 'yyyy'))
         and to_number(to_char(hc.fec_calculo, 'mm'))   = to_number(to_char(adi_fec_proceso, 'mm'))
      group by hc.cod_trabajador, 
               decode(hc.cencos, null, m.cencos, hc.cencos), 
               decode(hc.centro_benef, null, m.centro_benef, hc.centro_benef)  
    order by cencos, centro_benef  ;


    begin

      select NVL(Sum(dc.nro_horas),0)
        into ln_total_dist
        from historico_distrib_cntble dc
       where dc.cod_trabajador     = asi_cod_trabajador
         and to_number(to_char(dc.fec_calculo, 'yyyy')) = to_number(to_char(adi_fec_proceso, 'yyyy'))
         and to_number(to_char(dc.fec_calculo, 'mm'))   = to_number(to_char(adi_fec_proceso, 'mm'))
      group by dc.cod_trabajador ;

      --inicializar
      ln_tot_imp_sol := 0; ln_tot_imp_dol := 0;

      For rc_hist_dist in c_hist_distribucion Loop --informacion historica

          /*Porcentaje de horas*/
          ln_imp_sol := Round(ani_imp_movsol * rc_hist_dist.nro_horas / ln_total_dist ,2) ;
          ln_imp_dol := Round(ani_imp_movdol * rc_hist_dist.nro_horas / ln_total_dist ,2) ;

          if ln_tot_imp_sol + ln_imp_sol > ani_imp_movsol then
             ln_imp_sol := ani_imp_movsol - ln_tot_imp_sol;
          end if;

          if ln_tot_imp_dol + ln_imp_dol > ani_imp_movdol then
             ln_imp_dol := ani_imp_movdol - ln_tot_imp_dol;
          end if;

          --acumula porcentaje de participacion
          ln_tot_imp_sol := Nvl(ln_tot_imp_sol,0) + ln_imp_sol ;
          ln_tot_imp_dol := Nvl(ln_tot_imp_dol,0) + ln_imp_dol ;

          --INSERT ASIENTOS DETALLE
          USP_SIGRE_RRHH.SP_RH_INSERT_ASIENTO(adi_fec_proceso     ,
                                              asi_origen    ,
                                              rc_hist_dist.cencos ,
                                              asi_cnta_ctbl      ,
                                              asi_tipo_doc        ,
                                              asi_nro_doc   ,
                                              asi_cod_trabajador   ,
                                              asi_flag_debhab     ,
                                              ani_nro_libro ,
                                              asi_det_glosa       ,
                                              ani_item           ,
                                              ani_nro_provisional ,
                                              ln_imp_sol    ,
                                              ln_imp_dol           ,
                                              asi_concep         ,
                                              rc_hist_dist.centro_benef, 
                                              rc_hist_dist.cod_trabajador);


      End Loop ;


      IF ln_tot_imp_sol <> ani_imp_movsol or ln_tot_imp_dol <> ani_imp_movdol THEN
        --HALLAR COSTO RESTANTE A CENTRO DE COSTO POR DEFECTO DE TRABAJADOR
        ln_imp_sol := NVL(Round(ani_imp_movsol - ln_tot_imp_sol,2),0) ;
        ln_imp_dol := NVL(Round(ani_imp_movdol - ln_tot_imp_dol,2),0) ;
        
        update cntbl_pre_asiento_det cad
           set cad.imp_movsol = cad.imp_movsol + ln_imp_sol,
               cad.imp_movdol = cad.imp_movsol + ln_imp_dol
         where cad.origen     = asi_origen
           and cad.nro_libro  = ani_nro_libro
           and cad.nro_provisional = ani_nro_provisional
           and cad.item            = ani_item - 1;


        --INSERT ASIENTOS DETALLE
        /*
        USP_SIGRE_RRHH.SP_RH_INSERT_ASIENTO(adi_fec_proceso     ,asi_origen       ,asi_cencos         ,asi_cnta_ctbl      ,
                                            asi_tipo_doc        ,asi_nro_doc      ,asi_cod_trabajador ,
                                            asi_flag_debhab     ,ani_nro_libro    ,asi_det_glosa     ,ani_item           ,
                                            ani_nro_provisional ,NVL(ln_imp_sol,0),NVL(ln_imp_dol,0)   ,asi_concep         ,
                                            asi_centro_benef    , asi_cod_trabajador);
       */

      END IF ;


    end ;
  
  
  procedure SP_RH_INSERT_ASIENTO(
         adi_fec_proceso    in date                                   ,
         asi_origen         in origen.cod_origen%type                 ,
         asi_cencos         in centros_costo.cencos%type              ,
         asi_cnta_ctbl      in cntbl_cnta.cnta_ctbl%type              ,
         asi_tipo_doc       in doc_tipo.tipo_doc%type                 ,
         asi_nro_doc        in calculo.nro_doc_cc%type                ,
         asi_cod_relacion   in cntbl_asiento_det.cod_relacion%TYPE   ,
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
  ) is

  ls_grupo_cntbl        centros_costo.grp_cntbl%type ;
  ls_cnta_cntbl         cntbl_cnta.cnta_ctbl%type    ;
  ls_flag_cencos        cntbl_cnta.flag_cencos%type  ;
  ls_flag_doc           cntbl_cnta.flag_doc_ref%type ;
  ls_flag_crel          cntbl_cnta.flag_codrel%type  ;
  ls_flag_centro_benef  cntbl_cnta.flag_centro_benef%type  ;
  ls_cencos             centros_costo.cencos%type    ;
  ls_tipo_doc           doc_tipo.tipo_doc%Type       ;
  ls_nro_doc            calculo.nro_doc_cc%type      ;
  ls_cod_relacion       maestro.cod_trabajador%type  ;
  ln_count              Number                       ;
  ls_centro_benef       maestro.centro_benef%type    ;

  begin


    if Substr(asi_cnta_ctbl,1,1) = '9' then --es una cuenta de gasto

       if asi_cencos is null then
          --inserto en tabla de errores inconsistencia de grupo contable de centros de costo
          Insert Into TT_RH_INC_ASIENTOS(
                 cod_trabajador ,cencos ,concepto ,tipo_doc ,nro_doc ,flag_debhab ,cnta_ctbl,
                 grp_cntbl,obs)
          Values(
                 asi_cod_relacion ,asi_cencos ,asi_concep ,asi_tipo_doc ,asi_nro_doc ,
                 asi_flag_debhab ,asi_cnta_ctbl ,ls_grupo_cntbl ,'Centro de costo no puede ser nulo' ) ;
           --
           RAISE_APPLICATION_ERROR(-20000,'La Cuenta Contable ' || asi_cnta_ctbl || ' pide como referencia centro de costo, pero el Centro de Costo del trabajador '
                                           ||asi_cod_relacion||' esta vacio, por favor verifique.'
                                           || chr(13) || 'Concepto: ' || asi_concep);
           return ;
       end if ;

       select count(*)
         into ln_count
         from matriz_transf_cntbl_cencos mt
        where mt.org_cnta_ctbl = asi_cnta_ctbl
          and mt.cencos        = asi_cencos
          and mt.flag_estado   = '1';

       if ln_count = 0 then
          ls_cnta_cntbl := asi_cnta_ctbl ;
       else
          select dst_cnta_ctbl
            into ls_cnta_cntbl
            from matriz_transf_cntbl_cencos mt
           where mt.org_cnta_ctbl = asi_cnta_ctbl
             and mt.cencos        = asi_cencos
             and mt.flag_estado   = '1';

          if ls_cnta_cntbl is null then
             --inserto en tabla de errores inconsistencia de grupo contable de centros de costo
             Insert Into TT_RH_INC_ASIENTOS(
                    cod_trabajador ,cencos ,concepto ,tipo_doc ,nro_doc ,flag_debhab ,cnta_ctbl,grp_cntbl,obs)
             Values(
                    asi_cod_relacion ,asi_cencos ,asi_concep ,asi_tipo_doc ,asi_nro_doc ,asi_flag_debhab ,
                    asi_cnta_ctbl ,ls_grupo_cntbl ,'Centro de costo y Cuenta Contable NO TIENE Cuenta Destino, '
                                  || 'en la matriz de dstribucion, por favor verifique' ) ;

             RAISE_APPLICATION_ERROR(-20000,'Centro de costo y Cuenta Contable NO TIENE Cuenta Destino, '
                                         || 'en la matriz de dstribucion, por favor verifique.'
                                         || chr(13) || 'Centro Costo: ' || asi_cencos
                                         || chr(13) || 'Cnta Cntbl: ' || asi_cnta_ctbl);
                                         
             --
             return ;
          end if ;
        end if ;
    else
       ls_cnta_cntbl := asi_cnta_ctbl ;
    end if;

    --verifico si nueva cuenta existe o esta activa
    select count(*)
      into ln_count
      from cntbl_cnta c
     where c.cnta_ctbl = ls_cnta_cntbl
       and c.flag_estado = '1' ;

    if ln_count = 0 then
       --inserto en tabla de errores inconsistencia de cnta cntble inexistente o desactivada
       Insert Into TT_RH_INC_ASIENTOS(
              cod_trabajador ,cencos ,concepto ,tipo_doc ,nro_doc ,flag_debhab ,cnta_ctbl,grp_cntbl,obs)
       Values(
              asi_cod_relacion ,asi_cencos ,asi_concep ,asi_tipo_doc ,asi_nro_doc ,asi_flag_debhab ,
              ls_cnta_cntbl ,ls_grupo_cntbl ,'Cuenta Contable no Existe o Esta Desactivada, por favor verifique' ) ;
              
       RAISE_APPLICATION_ERROR(-20000,'La Cuenta Contable '||ls_cnta_cntbl||' es inexistente o inactiva');
      return ;
    end if ;

    --verificar valores de datos requeridos segun cuenta
    select Nvl(c.flag_cencos,'0'),Nvl(c.flag_doc_ref,'0'),Nvl(c.flag_codrel,'0'), Nvl(c.flag_centro_benef,'0')
      into ls_flag_cencos,ls_flag_doc,ls_flag_crel,ls_flag_centro_benef
      from cntbl_cnta c
     where c.cnta_ctbl = ls_cnta_cntbl ;


    if ls_flag_cencos = '1' then --requiere centro de costo
       ls_cencos := asi_cencos ;
    else
       ls_cencos := null ;
    end if ;

    if ls_flag_centro_benef = '1' then --requiere centro de beneficio
       ls_centro_benef := asi_cbenef ;
    else
       ls_centro_benef := null ;
    end if ;

    if ls_flag_doc = '1' then --requiere docuemnto de referencia
       if asi_tipo_doc is null then --tipo de documento no puede ser nulo
          RAISE_APPLICATION_ERROR(-20000,'El Concepto ' || asi_concep || ' tiene la Cuenta Contable ' || ls_cnta_cntbl 
                                       || ' la cual esta configurada para que pida Documento de Referencia.'
                                       || chr(13) || 'Cod Trabajador: ' || asi_cod_trabajador
                                       || chr(13) || 'Tipo Doc: ' || ls_tipo_doc
                                       || chr(13) || 'Nro Doc: ' || ls_nro_doc);
          Insert Into TT_RH_INC_ASIENTOS(
                 cod_trabajador ,cencos ,concepto ,tipo_doc ,nro_doc ,flag_debhab ,cnta_ctbl,grp_cntbl,obs)
          Values(
                 asi_cod_relacion ,asi_cencos ,asi_concep ,asi_tipo_doc ,asi_nro_doc ,asi_flag_debhab ,ls_cnta_cntbl ,
                 ls_grupo_cntbl ,'Cuenta Contable Requiere tipo de Documento' ) ;
          return ;
       else
          ls_tipo_doc := asi_tipo_doc ;
       end if ;

       if asi_nro_doc is null then --nro de documento no puede ser nulo
          --insertar en tabla temporal problema de documento
          Insert Into TT_RH_INC_ASIENTOS(
                 cod_trabajador ,cencos ,concepto ,tipo_doc ,nro_doc ,flag_debhab ,cnta_ctbl,grp_cntbl,obs)
          Values(
                 asi_cod_relacion ,asi_cencos ,asi_concep ,asi_tipo_doc ,asi_nro_doc ,asi_flag_debhab ,ls_cnta_cntbl ,
                 ls_grupo_cntbl ,'Cuenta Contable Requiere Nro de Documento' ) ;
          return ;
       else
          ls_nro_doc := asi_nro_doc ;
       end if ;
    else --no se coloca tipo ni nro de documento
       ls_tipo_doc := null ;
       ls_nro_doc  := null ;
    end if ;

    if ls_flag_crel = '1' then --requiere codigo de relacion
       ls_cod_relacion := asi_cod_relacion ;
    else
       ls_cod_relacion := null ;
    end if ;



    --actualiza asiento si ya existe
    Update cntbl_pre_asiento_det c
       set c.imp_movsol = c.imp_movsol + ani_imp_soles,
           c.imp_movdol = c.imp_movdol + ani_imp_dolares
      Where c.origen                = asi_origen
        and c.nro_libro             = ani_nro_libro
        and c.nro_provisional       = ani_num_prov
        and c.cnta_ctbl             = ls_cnta_cntbl
        and c.fec_cntbl             = adi_fec_proceso
        and c.flag_debhab           = asi_flag_debhab
        and Nvl(c.cencos,' ')       = Nvl(ls_cencos,' ')
        and Nvl(c.tipo_docref,' ')  = Nvl(ls_tipo_doc,' ')
        and Nvl(c.nro_docref1,' ')  = Nvl(ls_nro_doc,' ')
        and Nvl(c.cod_relacion,' ') = Nvl(ls_cod_relacion,' ')
        and Nvl(c.centro_benef,' ') = Nvl(ls_centro_benef,' ')
        and nvl(c.det_glosa, ' ')   = nvl(asi_glosa_det, ' ')
        and c.concep                = asi_concep;



    IF SQL%NOTFOUND THEN
       --CONTADOR DE ITEM
       --incrementa contador del detalle

       Insert Into cntbl_pre_asiento_det   (
              origen      ,nro_libro ,nro_provisional   ,item        ,det_glosa ,flag_debhab ,
              cnta_ctbl   ,fec_cntbl   ,tipo_docref     ,nro_docref1 ,cencos    ,imp_movsol  ,
              imp_movdol  ,cod_relacion, centro_benef   ,concep )
       Values(
              asi_origen     ,ani_nro_libro   ,ani_num_prov   ,ani_item    ,asi_glosa_det ,asi_flag_debhab ,
              ls_cnta_cntbl ,adi_fec_proceso ,ls_tipo_doc     ,ls_nro_doc  ,ls_cencos     ,ani_imp_soles   ,
              ani_imp_dolares,ls_cod_relacion, ls_centro_benef, asi_concep );
       
       ani_item := ani_item + 1;


    END IF ;
    
  END;
  
  procedure PROCESAR_GRATIF_TRIPULANTE (
    asi_codtra             in maestro.cod_trabajador%TYPE,
    asi_codusr             in usuario.cod_usr%TYPE,
    adi_fec_proceso        in date,
    asi_origen             in origen.cod_origen%TYPE
  ) IS
    
    ln_count               number;
    ln_tipcam              calendario.vta_dol_prom%TYPE;
    ls_concepto            concepto.concep%TYPE;
    ln_imp_soles           calculo.imp_soles%TYPE;
    ln_imp_dolar           calculo.imp_soles%TYPE;
    ls_cod_afp             maestro.cod_afp%TYPE;
    ld_fec_nac             maestro.fec_nacimiento%TYPE;
    ln_judicial            maestro.porc_judicial%TYPE;
    ln_judicial_utl        maestro.porc_jud_util%TYPE;
    ls_tipo_trabajador     maestro.tipo_trabajador%TYPE;
  
  begin
    --  *********************************************************
    --  ***   CALCULA LAS GRATIFICACIONES DE LOS TRIPULANTES   ***
    --  *********************************************************
    -- Obtengo el tipo de cambio correspondiente
    select nvl(tc.vta_dol_prom,1)
      into ln_tipcam
      from calendario tc
     where trunc(tc.fecha) = adi_fec_proceso ;

    IF ln_tipcam = 0 THEN
       RAISE_APPLICATION_ERROR(-20000, 'No ha especificado tipo de cambio para ' || to_char(adi_fec_proceso, 'dd/mm/yyyy'));
    END IF;

    -- Obtengo los datos del maestro de trabajadores
    select m.cod_afp, m.fec_nacimiento, nvl(m.porc_judicial,0) ,
           nvl(m.porc_jud_util,0), m.tipo_trabajador
      into ls_cod_afp, ld_fec_nac, ln_judicial, ln_judicial_utl,
           ls_tipo_trabajador
      from maestro m
     where m.cod_trabajador = asi_codtra;
     
    -- Verifico que no exista en calculo ninguna planilla pendiente de tripulantes
    select count(*)
      into ln_count
      from calculo c,
           maestro m
     where c.cod_trabajador = m.cod_trabajador
       and m.tipo_trabajador = usp_sigre_rrhh.is_tipo_trip
       and to_char(c.fec_proceso, 'yyyymm') = to_char(adi_fec_proceso, 'yyyymm')
       and c.cod_trabajador                 = asi_codtra;
    
    if ln_count > 0 then
       RAISE_APPLICATION_ERROR(-20000, 'Existen aun planillas sin cerrar para TRIPULANTES. Para procesar Gratificaciones es necesario que todas las planillas esten cerradas. '
                         || chr(13) || 'Periodo: ' || to_char(adi_fec_proceso, 'yyyy/mm')
                         || chr(13) || 'Registros Encontrados: ' || trim(to_char(ln_count)));
    end if;
    
    -- Limpio la tabla calculo para que no haya nada
    delete calculo c
    where c.cod_trabajador = asi_codtra
      and c.tipo_planilla = USP_SIGRE_RRHH.is_planilla_gratif_tri
      and c.fec_proceso = adi_fec_proceso;


    -- Calculo el importe total
    select nvl(sum(hc.imp_soles),0)
      into ln_imp_soles
      from historico_calculo hc,
           grupo_calculo_det gcd
     where hc.concep          = gcd.concepto_calc
       and gcd.grupo_calculo  = usp_sigre_rrhh.is_grp_gratif_tri 
       and hc.cod_trabajador  = asi_codtra
       and to_char(hc.fec_calc_plan, 'yyyymm') = to_char(adi_Fec_proceso, 'yyyymm');
    
    SELECT gc.concepto_gen
      into ls_concepto
      from grupo_calculo gc
     where gc.grupo_calculo = is_grp_gratif_tri;
    
    if ls_concepto is null then
       RAISE_APPLICATION_ERROR(-20000, 'No existe concepto de planilla enlazado al grupo de calculo ' || is_grp_gratif_tri);
    end if;
    
    -- Si el importe es cero entonces no hay nada mas que hacer
    if ln_imp_soles = 0 then return; end if;
    
    -- Calculo el proporcional
    ln_imp_soles := ln_imp_soles * 0.1666;

    -- Calculo en dolares
    ln_imp_dolar := ln_imp_soles / ln_tipcam ;
          
    UPDATE calculo
       SET horas_trabaj = null,
           horas_pag    = null,
           imp_soles    = imp_soles + ln_imp_soles,
           imp_dolar    = imp_dolar + ln_imp_dolar
      WHERE cod_trabajador = asi_codtra
        AND concep         = ls_concepto
        and tipo_planilla  = 'G';
          
    if SQL%NOTFOUND then
        insert into calculo (
          cod_trabajador, concep, fec_proceso, horas_trabaj, horas_pag,
          dias_trabaj, imp_soles, imp_dolar, cod_origen, flag_replicacion, item, tipo_planilla )
        values (
          asi_codtra, ls_concepto, adi_fec_proceso, null, null,
          null, ln_imp_soles, ln_imp_dolar, asi_origen, '1', 1, 'G' ) ;
    end if;
    
    -- Inserto la bonificación extraordinaria
    if to_number(to_char(adi_fec_proceso, 'yyyy')) between 2015 and 2099 then
       ln_imp_soles := ln_imp_soles * USP_SIGRE_RRHH.in_porc_bonif_ext;
       ln_imp_dolar := ln_imp_soles / ln_tipcam;
             
       update calculo c
          set c.imp_soles   = ln_imp_soles,
              c.imp_dolar   = ln_imp_dolar
        where c.cod_trabajador = asi_codtra
          and c.concep         = USP_SIGRE_RRHH.is_cnc_bonif_ext
          and c.tipo_planilla  = USP_SIGRE_RRHH.is_planilla_gratif_tri;
            
       if SQL%NOTFOUND then
          Insert Into calculo(
                 cod_trabajador, concep, fec_proceso, horas_trabaj, horas_pag,
                 dias_trabaj, imp_soles, imp_dolar, cod_origen, flag_replicacion,item, 
                 tipo_planilla)
          Values(
                 asi_codtra, USP_SIGRE_RRHH.is_cnc_bonif_ext, adi_fec_proceso, 0, 0, 0, 
                 ln_imp_soles, ln_imp_dolar, asi_origen, '1', 1,
                 USP_SIGRE_RRHH.is_planilla_gratif_tri);
       end if;
    end if;
    
    -- Elimino toda participación de pesca si lo hubiera
    delete calculo c
    where c.concep = usp_sigre_rrhh.is_cnc_partic_pesca
      and c.cod_trabajador = asi_codtra
      and c.tipo_planilla = USP_SIGRE_RRHH.is_planilla_gratif_tri;
    
    -- Ganancias Variables
    usp_rh_cal_ganancias_variables( asi_codtra, adi_fec_proceso, asi_origen, ln_tipcam , USP_SIGRE_RRHH.is_tipo_trip ,  USP_SIGRE_RRHH.is_planilla_gratif_tri) ;
    -- Elimino el concepto de participacion de pesca para evitar
    delete calculo c
    where c.cod_trabajador = asi_codtra
      and c.concep         = usp_sigre_rrhh.is_cnc_partic_pesca;

    -- Ahora las sumas
    usp_rh_cal_ganancia_total( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_ingreso, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    --  REALIZA CALCULOS DE DESCUENTOS POR TRABAJADOR
    /*
    if ls_cod_afp is null then
       usp_rh_cal_snp ( asi_codtra, adi_fec_proceso, asi_origen, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;
    else
       usp_rh_cal_afp ( asi_codtra, adi_fec_proceso, asi_origen, ln_tipcam, in_ano_tope_seg_inv, ld_fec_nac, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;
    end if ;
    */
    
    -- Quinta categoria
    -- Ahora se puede elejir si se calcula o no la renta de quinta
    --usp_rh_cal_quinta_categoria( asi_codtra, ls_tipo_trabajador, adi_fec_proceso, ln_tipcam, asi_origen, 0, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    -- Descuentos variables
    usp_rh_cal_descuento_variable( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;    

    -- Judicial
    usp_rh_cal_porcentaje_judicial( asi_codtra, adi_fec_proceso, asi_origen, ln_tipcam, ln_judicial, ln_judicial_utl, asi_codusr, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    -- Cuenta corriente
    usp_rh_cal_cuenta_corriente
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen ,is_cnc_total_ingreso, USP_SIGRE_RRHH.is_planilla_gratif_tri, asi_codusr);

    -- Descuento total
    usp_rh_cal_descuento_total
      ( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_dscto, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    usp_rh_cal_total_pagado
      ( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_ingreso, is_cnc_total_dscto, is_cnc_total_pagado, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    --  REALIZA CALCULOS DE APORTACIONES PATRONALES
    usp_rh_cal_apo_sctr_ipss
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    usp_rh_cal_apo_sctr_onp
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    
    -- Aportacion que se hace al actual REP 5% que le corresponde de ahora en adelante a los tripulantes
    --usp_rh_cal_apo_rep( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    --elimina calculos en cero
    delete from calculo hc
      where hc.cod_trabajador = asi_codtra
        and hc.fec_proceso    = adi_fec_proceso
        and nvl(imp_soles,0)  = 0
        and nvl(imp_dolar,0)  = 0
        and hc.concep         <> is_cnc_total_pagado
        and tipo_planilla     = USP_SIGRE_RRHH.is_planilla_gratif_tri ;
     
    -- Elimino tambien todo aquellos que no tienen neto pagado
    delete calculo c
    where c.cod_trabajador not in (select distinct cod_trabajador
                                      from calculo t
                                      where concep = is_cnc_total_ingreso
                                        and t.tipo_planilla = USP_SIGRE_RRHH.is_planilla_gratif_tri )
       and c.cod_trabajador = asi_codtra
       and c.tipo_planilla  = USP_SIGRE_RRHH.is_planilla_gratif_tri ;
                                      
    -- Aportacion Especial Cred EPS
    usp_rh_cal_apo_total
      ( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_aportes, USP_SIGRE_RRHH.is_planilla_gratif_tri ) ;

    --elimina calculos en cero
    delete from calculo hc
      where hc.cod_trabajador = asi_codtra
        and hc.fec_proceso    = adi_fec_proceso
        and nvl(imp_soles,0)  = 0
        and nvl(imp_dolar,0)  = 0
        and hc.concep         <> is_cnc_total_pagado;

  end;
  
  
  -- Procesa la planilla de Vacaciones de los tripulantes
  procedure PROCESAR_VACAC_TRIPULANTE (
    asi_codtra             in maestro.cod_trabajador%TYPE,
    asi_codusr             in usuario.cod_usr%TYPE,
    adi_fec_proceso        in date,
    asi_origen             in origen.cod_origen%TYPE,
    asi_flag_renta_quinta  in char
  ) IS
    
    ln_count               number;
    ln_tipcam              calendario.vta_dol_prom%TYPE;
    ls_concepto            concepto.concep%TYPE;
    ln_imp_soles           calculo.imp_soles%TYPE;
    ln_imp_dolar           calculo.imp_soles%TYPE;
    ls_cod_afp             maestro.cod_afp%TYPE;
    ld_fec_nac             maestro.fec_nacimiento%TYPE;
    ln_judicial            maestro.porc_judicial%TYPE;
    ln_judicial_utl        maestro.porc_jud_util%TYPE;
    ls_tipo_trabajador     maestro.tipo_trabajador%TYPE;
  
  begin
    --  *********************************************************
    --  ***   CALCULA LAS VACACIONES DE LOS TRIPULANTES   ***
    --  *********************************************************
    -- Obtengo el tipo de cambio correspondiente
    select nvl(tc.vta_dol_prom,1)
      into ln_tipcam
      from calendario tc
     where trunc(tc.fecha) = adi_fec_proceso ;

    IF ln_tipcam = 0 THEN
       RAISE_APPLICATION_ERROR(-20000, 'No ha especificado tipo de cambio para ' || to_char(adi_fec_proceso, 'dd/mm/yyyy'));
    END IF;

    -- Obtengo los datos del maestro de trabajadores
    select m.cod_afp, m.fec_nacimiento, nvl(m.porc_judicial,0) ,
           nvl(m.porc_jud_util,0), m.tipo_trabajador
      into ls_cod_afp, ld_fec_nac, ln_judicial, ln_judicial_utl,
           ls_tipo_trabajador
      from maestro m
     where m.cod_trabajador = asi_codtra;
     
    -- Verifico que no exista en calculo ninguna planilla pendiente de tripulantes
    select count(*)
      into ln_count
      from calculo c,
           maestro m
     where c.cod_trabajador = m.cod_trabajador
       and m.tipo_trabajador = usp_sigre_rrhh.is_tipo_trip
       and to_char(c.fec_proceso, 'yyyymm') = to_char(adi_fec_proceso, 'yyyymm')
       and c.cod_trabajador                 = asi_codtra;
    
    if ln_count > 0 then
       RAISE_APPLICATION_ERROR(-20000, 'Existen aun planillas sin cerrar para TRIPULANTES. Para procesar Gratificaciones es necesario que todas las planillas esten cerradas. '
                         || chr(13) || 'Periodo: ' || to_char(adi_fec_proceso, 'yyyy/mm')
                         || chr(13) || 'Registros Encontrados: ' || trim(to_char(ln_count)));
    end if;

    -- Calculo el importe total
    select nvl(sum(hc.imp_soles),0)
      into ln_imp_soles
      from historico_calculo hc,
           grupo_calculo_det gcd
     where hc.concep          = gcd.concepto_calc
       and gcd.grupo_calculo  = usp_sigre_rrhh.is_grp_VACAC_TRI 
       and hc.cod_trabajador  = asi_codtra
       and to_char(hc.fec_calc_plan, 'yyyymm') = to_char(adi_Fec_proceso, 'yyyymm');
    
    SELECT gc.concepto_gen
      into ls_concepto
      from grupo_calculo gc
     where gc.grupo_calculo = usp_sigre_rrhh.is_grp_VACAC_TRI;
    
    if ls_concepto is null then
       RAISE_APPLICATION_ERROR(-20000, 'No existe concepto de planilla enlazado al grupo de calculo ' || usp_sigre_rrhh.is_grp_VACAC_TRI);
    end if;
    
    -- Si el importe es cero entonces no hay nada mas que hacer
    if ln_imp_soles = 0 then return; end if;
    
    -- Calculo el proporcional
    ln_imp_soles := ln_imp_soles * 8.33 / 100;

    -- Calculo en dolares
    ln_imp_dolar := ln_imp_soles / ln_tipcam ;
          
    UPDATE calculo
       SET horas_trabaj = null,
           horas_pag    = null,
           imp_soles    = imp_soles + ln_imp_soles,
           imp_dolar    = imp_dolar + ln_imp_dolar
      WHERE cod_trabajador = asi_codtra
        AND concep         = ls_concepto
        and tipo_planilla  = usp_sigre_rrhh.is_planilla_VACAC_tri;
          
    if SQL%NOTFOUND then
        insert into calculo (
          cod_trabajador, concep, fec_proceso, horas_trabaj, horas_pag,
          dias_trabaj, imp_soles, imp_dolar, cod_origen, flag_replicacion, item, tipo_planilla )
        values (
          asi_codtra, ls_concepto, adi_fec_proceso, null, null,
          null, ln_imp_soles, ln_imp_dolar, asi_origen, '1', 1, usp_sigre_rrhh.is_planilla_VACAC_tri ) ;
    end if;
    
    
    -- Ahora las sumas
    usp_rh_cal_ganancia_total( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_ingreso, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;

    --  REALIZA CALCULOS DE DESCUENTOS POR TRABAJADOR
    if ls_cod_afp is null then
       usp_rh_cal_snp ( asi_codtra, adi_fec_proceso, asi_origen, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;
    else
       usp_rh_cal_afp ( asi_codtra, adi_fec_proceso, asi_origen, ln_tipcam, in_ano_tope_seg_inv, ld_fec_nac, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;
    end if ;
    
    -- Quinta categoria
    -- Ahora se puede elejir si se calcula o no la renta de quinta
    if asi_flag_renta_quinta = '1' then
       usp_rh_cal_quinta_categoria( asi_codtra, ls_tipo_trabajador, adi_fec_proceso, ln_tipcam, asi_origen, 0, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;
    end if;

    -- Cuenta corriente
    usp_rh_cal_cuenta_corriente
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen ,is_cnc_total_ingreso, USP_SIGRE_RRHH.is_planilla_VACAC_tri, asi_codusr);

    -- Essalud Vida
    usp_rh_cal_essalud_vida
       ( asi_codtra, asi_origen, ln_tipcam, adi_fec_proceso,ls_tipo_trabajador, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;
       
    -- Descuentos variables
    usp_rh_cal_descuento_variable( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;    

    -- Judicial
    usp_rh_cal_porcentaje_judicial( asi_codtra, adi_fec_proceso, asi_origen, ln_tipcam, ln_judicial, ln_judicial_utl, asi_codusr, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;

    -- Descuento total
    usp_rh_cal_descuento_total
      ( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_dscto, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;

    usp_rh_cal_total_pagado
      ( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_ingreso, is_cnc_total_dscto, is_cnc_total_pagado, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;

    --  REALIZA CALCULOS DE APORTACIONES PATRONALES
    usp_rh_cal_apo_sctr_ipss
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;

    usp_rh_cal_apo_sctr_onp
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;
      
    --  Otras Aportaciones indicadas por el trabajador
    usp_rh_cal_otras_aport( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen , is_cnc_total_ingreso, USP_SIGRE_RRHH.is_planilla_VACAC_tri) ;

    
    -- Aportacion que se hace al actual REP 5% que le corresponde de ahora en adelante a los tripulantes
    usp_rh_cal_apo_rep( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;
    
    -- Calculo de ESSALUD
    usp_rh_cal_apo_essalud( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, ls_tipo_trabajador, '0', USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;


    --elimina calculos en cero
    delete from calculo hc
      where hc.cod_trabajador = asi_codtra
        and hc.fec_proceso    = adi_fec_proceso
        and nvl(imp_soles,0)  = 0
        and nvl(imp_dolar,0)  = 0
        and hc.concep         <> is_cnc_total_pagado
        and tipo_planilla     = USP_SIGRE_RRHH.is_planilla_VACAC_tri ;
     
    -- Elimino tambien todo aquellos que no tienen neto pagado
    delete calculo c
    where c.cod_trabajador not in (select distinct cod_trabajador
                                      from calculo t
                                      where concep = is_cnc_total_ingreso
                                        and t.tipo_planilla = USP_SIGRE_RRHH.is_planilla_VACAC_tri )
       and c.cod_trabajador = asi_codtra
       and c.tipo_planilla  = USP_SIGRE_RRHH.is_planilla_gratif_tri ;
                                      
    -- Aportacion Especial Cred EPS
    usp_rh_cal_apo_total( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_aportes, USP_SIGRE_RRHH.is_planilla_VACAC_tri ) ;

    --elimina calculos en cero
    delete from calculo hc
      where hc.cod_trabajador = asi_codtra
        and hc.fec_proceso    = adi_fec_proceso
        and nvl(imp_soles,0)  = 0
        and nvl(imp_dolar,0)  = 0
        and hc.concep         <> is_cnc_total_pagado;

  end;

  -- Procesa la planilla de CTS de los tripulantes
  procedure PROCESAR_CTS_TRIPULANTE (
    asi_codtra             in maestro.cod_trabajador%TYPE,
    asi_codusr             in usuario.cod_usr%TYPE,
    adi_fec_proceso        in date,
    asi_origen             in origen.cod_origen%TYPE
  ) IS
    
    ln_count               number;
    ln_tipcam              calendario.vta_dol_prom%TYPE;
    ls_concepto            concepto.concep%TYPE;
    ln_imp_soles           calculo.imp_soles%TYPE;
    ln_imp_dolar           calculo.imp_soles%TYPE;
    ls_cod_afp             maestro.cod_afp%TYPE;
    ld_fec_nac             maestro.fec_nacimiento%TYPE;
    ln_judicial            maestro.porc_judicial%TYPE;
    ln_judicial_utl        maestro.porc_jud_util%TYPE;
  
  begin
    --  *********************************************************
    --  ***   CALCULA EL CTS DE LOS TRIPULANTES   ***
    --  *********************************************************
    -- Obtengo el tipo de cambio correspondiente
    select nvl(tc.vta_dol_prom,1)
      into ln_tipcam
      from calendario tc
     where trunc(tc.fecha) = adi_fec_proceso ;

    IF ln_tipcam = 0 THEN
       RAISE_APPLICATION_ERROR(-20000, 'No ha especificado tipo de cambio para ' || to_char(adi_fec_proceso, 'dd/mm/yyyy'));
    END IF;

    -- Obtengo los datos del maestro de trabajadores
    select m.cod_afp, m.fec_nacimiento, nvl(m.porc_judicial,0) ,
       nvl(m.porc_jud_util,0) 
      into ls_cod_afp, ld_fec_nac, ln_judicial, ln_judicial_utl
      from maestro m
     where m.cod_trabajador = asi_codtra;
     
    -- Verifico que no exista en calculo ninguna planilla pendiente de tripulantes
    select count(*)
      into ln_count
      from calculo c,
           maestro m
     where c.cod_trabajador                 = m.cod_trabajador
       and m.tipo_trabajador                = usp_sigre_rrhh.is_tipo_trip
       and to_char(c.fec_proceso, 'yyyymm') = to_char(adi_fec_proceso, 'yyyymm')
       and c.cod_trabajador                 = asi_codtra;
    
    if ln_count > 0 then
       RAISE_APPLICATION_ERROR(-20000, 'Existen aun planillas sin cerrar para TRIPULANTES. Para procesar Gratificaciones es necesario que todas las planillas esten cerradas. '
                         || chr(13) || 'Periodo: ' || to_char(adi_fec_proceso, 'yyyy/mm')
                         || chr(13) || 'Registros Encontrados: ' || trim(to_char(ln_count)));
    end if;

    -- Calculo el importe total
    select nvl(sum(hc.imp_soles),0)
      into ln_imp_soles
      from historico_calculo hc,
           grupo_calculo_det gcd
     where hc.concep          = gcd.concepto_calc
       and gcd.grupo_calculo  = usp_sigre_rrhh.is_grp_CTS_TRI 
       and hc.cod_trabajador  = asi_codtra
       and to_char(hc.fec_calc_plan, 'yyyymm') = to_char(adi_Fec_proceso, 'yyyymm');
    
    SELECT gc.concepto_gen
      into ls_concepto
      from grupo_calculo gc
     where gc.grupo_calculo = usp_sigre_rrhh.is_grp_CTS_TRI;
    
    if ls_concepto is null then
       RAISE_APPLICATION_ERROR(-20000, 'No existe concepto de planilla enlazado al grupo de calculo ' || usp_sigre_rrhh.is_grp_CTS_TRI);
    end if;
    
    -- Si el importe es cero entonces no hay nada mas que hacer
    if ln_imp_soles = 0 then return; end if;
    
    -- Calculo el proporcional
    ln_imp_soles := ln_imp_soles * 8.33 / 100;

    -- Calculo en dolares
    ln_imp_dolar := ln_imp_soles / ln_tipcam ;
          
    UPDATE calculo
       SET horas_trabaj = null,
           horas_pag    = null,
           imp_soles    = imp_soles + ln_imp_soles,
           imp_dolar    = imp_dolar + ln_imp_dolar
      WHERE cod_trabajador = asi_codtra
        AND concep         = ls_concepto
        and tipo_planilla  = usp_sigre_rrhh.is_grp_CTS_TRI;
          
    if SQL%NOTFOUND then
        insert into calculo (
          cod_trabajador, concep, fec_proceso, horas_trabaj, horas_pag,
          dias_trabaj, imp_soles, imp_dolar, cod_origen, flag_replicacion, item, tipo_planilla )
        values (
          asi_codtra, ls_concepto, adi_fec_proceso, null, null,
          null, ln_imp_soles, ln_imp_dolar, asi_origen, '1', 1, usp_sigre_rrhh.is_planilla_CTS_tri ) ;
    end if;
    
    
    -- Ahora las sumas
    usp_rh_cal_ganancia_total( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_ingreso, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    --  REALIZA CALCULOS DE DESCUENTOS POR TRABAJADOR
    if ls_cod_afp is null then
       usp_rh_cal_snp ( asi_codtra, adi_fec_proceso, asi_origen, USP_SIGRE_RRHH.is_grp_CTS_TRI ) ;
    else
       usp_rh_cal_afp ( asi_codtra, adi_fec_proceso, asi_origen, ln_tipcam, in_ano_tope_seg_inv, ld_fec_nac, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;
    end if ;
    
    -- Judicial
    usp_rh_cal_porcentaje_judicial( asi_codtra, adi_fec_proceso, asi_origen, ln_tipcam, ln_judicial, ln_judicial_utl, asi_codusr, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    -- Cuenta corriente
    usp_rh_cal_cuenta_corriente
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen ,is_cnc_total_ingreso, USP_SIGRE_RRHH.is_planilla_CTS_tri, asi_codusr);

    -- Descuentos variables
    usp_rh_cal_descuento_variable
       ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    -- Descuento total
    usp_rh_cal_descuento_total
      ( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_dscto, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    usp_rh_cal_total_pagado
      ( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_ingreso, is_cnc_total_dscto, is_cnc_total_pagado, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    --  REALIZA CALCULOS DE APORTACIONES PATRONALES
    usp_rh_cal_apo_sctr_ipss
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    usp_rh_cal_apo_sctr_onp
      ( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    
    -- Aportacion que se hace al actual REP 5% que le corresponde de ahora en adelante a los tripulantes
    usp_rh_cal_apo_rep( asi_codtra, adi_fec_proceso, ln_tipcam, asi_origen, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    --elimina calculos en cero
    delete from calculo hc
      where hc.cod_trabajador = asi_codtra
        and hc.fec_proceso    = adi_fec_proceso
        and nvl(imp_soles,0)  = 0
        and nvl(imp_dolar,0)  = 0
        and hc.concep         <> is_cnc_total_pagado
        and tipo_planilla     = USP_SIGRE_RRHH.is_planilla_CTS_tri ;
     
    -- Elimino tambien todo aquellos que no tienen neto pagado
    delete calculo c
    where c.cod_trabajador not in (select distinct cod_trabajador
                                      from calculo t
                                      where concep = is_cnc_total_ingreso
                                        and t.tipo_planilla = USP_SIGRE_RRHH.is_planilla_CTS_tri )
       and c.cod_trabajador = asi_codtra
       and c.tipo_planilla  = USP_SIGRE_RRHH.is_planilla_CTS_tri ;
                                      
    -- Aportacion Especial Cred EPS
    usp_rh_cal_apo_total( asi_codtra, adi_fec_proceso, asi_origen, is_cnc_total_aportes, USP_SIGRE_RRHH.is_planilla_CTS_tri ) ;

    --elimina calculos en cero
    delete from calculo hc
      where hc.cod_trabajador = asi_codtra
        and hc.fec_proceso    = adi_fec_proceso
        and nvl(imp_soles,0)  = 0
        and nvl(imp_dolar,0)  = 0
        and hc.concep         <> is_cnc_total_pagado;

  end;

  -- Procesa la planilla de historico de calculo
  procedure usp_rh_cal_borra_hist_calculo (
      asi_origen         in origen.cod_origen%TYPE,
      adi_fec_proceso    in date,
      asi_tipo_trabaj    in tipo_trabajador.tipo_trabajador %TYPE,
      asi_tipo_planilla  in calculo.tipo_planilla%TYPE
    
  ) IS
  
    ls_doc_autom    rrhhparam.doc_reg_automatico%TYPE;
    
  begin
    SELECT doc_reg_automatico
      INTO ls_doc_autom
      FROM rrhhparam
     WHERE reckey = '1';

    --  *****************************************************************
    --  ***   ELIMINA MOVIMIENTO DE LA PLANILLA HISTORICA CALCULADA   ***
    --  *****************************************************************
    
    -- Borro la glosa del historico 
    delete historico_calculo_glosa t
     where t.cod_trabajador in (select distinct cod_trabajador 
                                  from historico_calculo hc
                                 where hc.tipo_trabajador = asi_tipo_trabaj
                                   and hc.fec_calc_plan   = adi_fec_proceso
                                   and hc.tipo_planilla   = asi_tipo_planilla
                                   and hc.cod_origen      = asi_origen)
       and t.fecha_calc      = adi_fec_proceso
       and t.tipo_planilla   = asi_tipo_planilla;

    delete from HISTORICO_calculo c
      where c.tipo_trabajador = asi_tipo_trabaj
        and c.fec_calc_plan   = adi_fec_proceso
        and c.cod_origen      = asi_origen 
        and c.tipo_planilla = asi_tipo_planilla;

    delete from quinta_categoria q
      where q.fec_proceso = adi_fec_proceso
        and q.cod_trabajador in ( select m.cod_trabajador
                                    from maestro m
                                   where m.tipo_trabajador = asi_tipo_trabaj
                                     and m.cod_origen      = asi_origen ) 
        and q.tipo_planilla  = asi_tipo_planilla;
    
    delete historico_rrhh_param_org t
     where t.tipo_trabajador = asi_tipo_trabaj
       and t.cod_origen      = asi_origen
       and t.fec_proceso     = adi_fec_proceso
       and t.tipo_planilla   = asi_tipo_planilla;
       

    commit ;
    
  end;

begin
  -- Initialization
  --<Statement>;
  select r.tipo_trab_tripulante , r.tipo_trab_destajo , r.tipo_Trab_servis  , r.tipo_trab_obrero,
         r.cnc_total_ing        , r.cnc_total_dsct    , r.tope_ano_seg_inv  , r.tipo_trab_empleado,
         r.cnc_total_pgd        , r.cnc_total_aport
    into is_tipo_trip           , is_tipo_des         , is_tipo_ser         , is_tipo_jor, 
         is_cnc_total_ingreso   , is_cnc_total_dscto  , in_ano_tope_seg_inv , is_tipo_emp,
         is_cnc_total_pagado    , is_cnc_total_aportes
  from rrhhparam r
  where r.reckey = '1' ;
  
  -- Parmetros de Asistencia
  select a.porc_bonif_ext, a.cnc_bonif_ext
    into in_porc_bonif_ext, is_cnc_bonif_ext
    from asistparam a
   where a.reckey = '1';
   
   
  -- Parametros para is_cod_afp
  is_afp_rep := PKG_CONFIG.USF_GET_PARAMETER('CODIGO_AFP_REP', 'CB');
  
  -- Concepto de bonificacion para tripulantes
  is_cnc_bonif_tri := PKG_CONFIG.USF_GET_PARAMETER('CONCEPTO BONIF ESPECIALIDAD', '1005');
  -- Concepto de Participación de Pesca
  is_cnc_partic_pesca := PKG_CONFIG.USF_GET_PARAMETER('CONCEPTO PARTIC PESCA TRIP', '1301');
  
  -- grupos de Calculo para planilla de tripulantes
  is_grp_gratif_tri := PKG_CONFIG.USF_GET_PARAMETER('GRUPO GRATIF. TRIPULANTE', '064');
  is_grp_VACAC_TRI  := PKG_CONFIG.USF_GET_PARAMETER('GRUPO VACAC. TRIPULANTE', '065');
  is_grp_CTS_TRI    := PKG_CONFIG.USF_GET_PARAMETER('GRUPO C.T.S. TRIPULANTE', '066');
  is_cnc_reint_asig_fam := PKG_CONFIG.USF_GET_PARAMETER('REINTEGRO ASIG. FAMILIAR', '1410');

end USP_SIGRE_RRHH;
/


spool off
