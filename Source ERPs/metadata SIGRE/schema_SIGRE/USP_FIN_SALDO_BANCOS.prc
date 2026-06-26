create or replace procedure USP_FIN_SALDO_BANCOS (
       asi_nada in varchar2
) is

Cursor c_ctabco is
    SELECT ca.cod_ctabco, bc.descripcion,
           to_number(to_char(ca.fec_cntbl, 'yyyy')) as ano,
           to_number(to_char(ca.fec_cntbl, 'mm')) as mes,
           nvl(sum(DECODE(ca.flag_debhab, 'D',
            decode(bc.cod_moneda,(select cod_soles from logparam where reckey = '1'),ca.imp_movsol,ca.imp_movdol),
            0)),0) as total_ingresos,
           nvl(sum(DECODE(ca.flag_debhab, 'D', 0,
            decode(bc.cod_moneda,(select cod_soles from logparam where reckey = '1'),ca.imp_movsol,ca.imp_movdol))),0) as total_egresos
    FROM cntbl_asiento     c ,
         caja_bancos       cb,
         cntbl_asiento_det ca,
         banco_cnta        bc
   WHERE c.origen        = cb.origen
     AND c.ano           = cb.ano
     AND c.mes           = cb.mes
     AND c.nro_libro     = cb.nro_libro
     AND c.nro_asiento   = cb.nro_asiento
     AND c.origen        = ca.origen
     AND c.ano           = ca.ano
     AND c.mes           = ca.mes
     AND c.nro_libro     = ca.nro_libro
     AND c.nro_asiento   = ca.nro_asiento
     and ca.cod_ctabco   = bc.cod_ctabco
     and cb.flag_estado  <> '0'
group by ca.cod_ctabco, bc.descripcion, to_number(to_char(ca.fec_cntbl, 'yyyy')), to_number(to_char(ca.fec_cntbl, 'mm')) ;

Cursor c_saldo_bancos_mes  is
  SELECT sbm.ano, sbm.mes, sbm.cod_ctabco
    FROM saldo_banco_mes sbm
  order by sbm.cod_ctabco, ano, mes;

Cursor c_cntas_mes  is
  SELECT distinct sbm.cod_ctabco
    FROM saldo_banco_mes sbm
  group by sbm.cod_ctabco;


ln_saldo_mes      saldo_banco_mes.egresos%type    ;
ln_mes_next       saldo_banco_mes.mes%TYPE;
ln_year_next      saldo_banco_mes.ano%TYPE;
ln_year1          saldo_banco_mes.ano%TYPE;
ln_year2          saldo_banco_mes.ano%TYPE;
ln_year           saldo_banco_mes.ano%TYPE;
ln_count          number;


begin

delete from saldo_banco_mes sb
where sb.saldo_conciliado = 0;

update saldo_banco_mes sb
   set sb.ingresos = 0,
       sb.egresos  = 0,
       sb.saldo    = 0;


--el bucle continua mientras haya mas filas que extraer
for lc_reg in c_ctabco loop
    UPDATE saldo_banco_mes
        SET ingresos  = lc_reg.total_ingresos,
            egresos   = lc_reg.total_egresos ,
            saldo     = lc_Reg.Total_Ingresos - lc_Reg.Total_Egresos,
            flag_replicacion = '1'
      WHERE cod_ctabco = lc_reg.cod_ctabco
        and ano        = lc_reg.ano
        and mes        = lc_reg.mes;

     IF SQL%NOTFOUND THEN
        /*Replicacion*/
        INSERT INTO saldo_banco_mes(
               cod_ctabco,ano,mes,ingresos,egresos,saldo,flag_replicacion)
        VALUES(
               lc_reg.cod_ctabco,lc_reg.ano, lc_reg.mes, lc_reg.total_ingresos, lc_reg.total_egresos, lc_reg.total_ingresos - lc_reg.total_egresos,'1');
     END IF ;
End Loop ;

-- Ingreso los movimientos que tienen saldo cero
for lc_reg in c_cntas_mes loop

    -- Obtengo los a?os limites
    SELECT nvl(min(sbm.ano),0), nvl(max(sbm.ano),0)
      into ln_year1, ln_year2
      FROM saldo_banco_mes sbm;

    for ln_year in ln_year1..ln_year2 loop
        for ln_mes in 1..12 loop
            select count(*)
              into ln_count
              from saldo_banco_mes sbm
             where sbm.cod_ctabco = lc_reg.cod_ctabco
               and sbm.ano        = ln_year
               and sbm.mes        = ln_mes;

            if ln_count = 0 then
               insert into saldo_banco_mes(
                      cod_ctabco, ano, mes, ingresos, egresos, saldo, saldo_conciliado)
               values(
                      lc_reg.cod_ctabco, ln_year, ln_mes, 0, 0, 0, 0);
            end if;
        end loop;
    end loop;


end loop;
--saldo anterior
For lc_reg in c_saldo_bancos_mes  Loop
    ln_mes_next      := lc_reg.mes;
    ln_year_next     := lc_reg.ano;

    if ln_mes_next = 12 then
       ln_mes_next := 1;
       ln_year_next := ln_year_next + 1;
    else
       ln_mes_next := ln_mes_next + 1;
    end if;

    /*Actualizacion de Informacion*/
    /*Replicacion*/
    select nvl(sum(sbm.ingresos - sbm.egresos),0)
      into ln_saldo_mes
      from saldo_banco_mes sbm
     where sbm.cod_ctabco  = lc_reg.cod_ctabco
       and trim(to_char(sbm.ano,'0000')) || trim(to_char(sbm.mes, '00')) <= trim(to_char(lc_reg.ano,'0000')) || trim(to_char(lc_reg.mes, '00'));

    UPDATE saldo_banco_mes
       SET saldo = ln_saldo_mes,
           flag_replicacion = '1'
     WHERE cod_ctabco = lc_reg.cod_ctabco
       AND ano        = lc_reg.ano
       and mes        = lc_reg.mes;

     IF SQL%NOTFOUND THEN
        /*Replicacion*/
        INSERT INTO saldo_banco_mes
       (cod_ctabco,ano,mes,ingresos,egresos,saldo,flag_replicacion)
        VALUES
       (lc_reg.cod_ctabco, ln_year_next, ln_mes_next,0.00,0.00,ln_saldo_mes,'1');
    END IF ;

End Loop ;



--Confirmar el trabajo
Commit ;

end USP_FIN_SALDO_BANCOS;
/
