#!/usr/bin/env node
/** Genera seed 14-seed-calculo-referencia-sigre.sql desde CALCULO.json */
const fs = require('fs');
const path = require('path');

const jsonPath = path.resolve(__dirname, '../../../metadata SIGRE/data/CALCULO.json');
const outPath = path.resolve(__dirname, '../ddl/seed/14-seed-calculo-referencia-sigre.sql');

const rows = JSON.parse(fs.readFileSync(jsonPath, 'utf8')).CALCULO;
const lines = [
  '-- Boletas referencia SIGRE (CALCULO.json) en tablas calculo_referencia / calculo_det_referencia',
  '-- Registros: ' + rows.length,
  'BEGIN;',
  'DELETE FROM rrhh.calculo_det_referencia;',
  'DELETE FROM rrhh.calculo_referencia;',
  '',
];

function tipoConcepto(codigo) {
  const n = parseInt(codigo, 10);
  if (codigo === '1499') return 'INGRESO';
  if (codigo === '2398' || codigo === '2399') return 'DESCUENTO';
  if (codigo === '3099') return 'APORTE';
  if (!Number.isNaN(n) && n >= 3000) return 'APORTE';
  if (!Number.isNaN(n) && n >= 2000) return 'DESCUENTO';
  return 'INGRESO';
}

const groups = new Map();
for (const r of rows) {
  const fec = (r.FEC_PROCESO || '').slice(0, 10);
  const key = [r.COD_TRABAJADOR, fec, r.TIPO_PLANILLA || 'N', r.COD_ORIGEN || 'CH'].join('|');
  if (!groups.has(key)) groups.set(key, []);
  groups.get(key).push(r);
}

for (const [key, items] of groups) {
  const [cod, fec, tipoPla, orig] = key.split('|');
  lines.push('-- Boleta ' + cod + ' ' + fec + ' ' + orig);
  lines.push(
    'INSERT INTO rrhh.calculo_referencia (trabajador_id, fec_proceso, tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id, dias_trabajados, periodo, flag_replicacion, flag_estado)'
  );
  lines.push(
    "SELECT t.id, '" + fec + "'::date, tp.id, s.id, 1.0, COALESCE(t.admin_afp_id, (SELECT id FROM rrhh.admin_afp WHERE nombre='ONP' LIMIT 1)), 0, to_char('" +
      fec +
      "'::date,'YYYY-MM'), '1', '1'"
  );
  lines.push('FROM rrhh.trabajador t');
  lines.push("JOIN rrhh.tipo_planilla tp ON tp.codigo='" + tipoPla + "'");
  lines.push("LEFT JOIN auth.sucursal s ON s.codigo='" + orig + "' AND s.flag_estado='1'");
  lines.push("WHERE t.codigo_trabajador='" + cod + "';");
  lines.push('');

  for (const r of items) {
    const impS = Number(r.IMP_SOLES || 0);
    const impD = Number(r.IMP_DOLAR || 0);
    const dias = Number(r.DIAS_TRABAJ || 0);
    const hrsT = Number(r.HORAS_TRABAJ || 0);
    const hrsP = Number(r.HORAS_PAG || 0);
    const item = Number(r.ITEM || 1);
    const tcc = tipoConcepto(String(r.CONCEP));
    lines.push(
      'INSERT INTO rrhh.calculo_det_referencia (calculo_id, concepto_id, item, horas_trabajadas, horas_pagadas, dias_trabajados, imp_soles, imp_dolar, tipo_concepto_calculo_id, flag_estado)'
    );
    lines.push(
      "SELECT c.id, cp.id, " +
        item +
        ', ' +
        hrsT +
        ', ' +
        hrsP +
        ', ' +
        dias +
        ', ' +
        impS +
        ', ' +
        impD +
        ", tcc.id, '1'"
    );
    lines.push('FROM rrhh.calculo_referencia c');
    lines.push("JOIN rrhh.trabajador t ON t.id = c.trabajador_id AND t.codigo_trabajador='" + cod + "'");
    lines.push("JOIN rrhh.tipo_planilla tp ON tp.id = c.tipo_planilla_id AND tp.codigo='" + tipoPla + "'");
    lines.push("LEFT JOIN auth.sucursal s ON s.id = c.sucursal_id AND s.codigo='" + orig + "'");
    lines.push("JOIN rrhh.concepto_planilla cp ON cp.codigo='" + r.CONCEP + "'");
    lines.push("JOIN rrhh.tipo_concepto_calculo tcc ON tcc.codigo='" + tcc + "'");
    lines.push("WHERE c.fec_proceso='" + fec + "'::date;");
    lines.push('');
  }
}

lines.push('COMMIT;');
fs.writeFileSync(outPath, lines.join('\n'), 'utf8');
console.log('boletas=' + groups.size + ' lineas=' + rows.length + ' -> ' + path.basename(outPath));
