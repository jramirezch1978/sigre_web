/**
 * Actualiza ms-ventas.postman_collection.json:
 * - Corrige method/url invertidos (bug histórico).
 * - Añade cuerpos JSON de ejemplo alineados a DTOs *Request.
 * - Sincroniza flujos CxC (directo, detracción, NC, pendientes).
 * - Inserta carpeta Issue 5 (propinas, reservaciones, créditos CxC).
 *
 * Uso: node update-ms-ventas-collection.mjs
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const COLLECTION_PATH = path.join(__dirname, '..', 'ms-ventas.postman_collection.json');

function walkItems(items, fn) {
  if (!items) return;
  for (const it of items) {
    if (it.request) fn(it);
    if (it.item) walkItems(it.item, fn);
  }
}

function fixInvertedMethodUrl(item) {
  const r = item.request;
  if (!r || typeof r.method !== 'string' || !r.method.startsWith('/')) return;
  const pathPart = r.method;
  r.url = `{{baseUrl}}${pathPart}`;
  const nm = item.name || '';
  if (/^POST/i.test(nm)) r.method = 'POST';
  else if (/^PUT/i.test(nm)) r.method = 'PUT';
  else if (/^PATCH/i.test(nm)) r.method = 'PATCH';
  else if (/^DELETE/i.test(nm)) r.method = 'DELETE';
  else if (/^GET/i.test(nm)) r.method = 'GET';
  else if (pathPart.includes('/estado')) r.method = 'PATCH';
  else if (pathPart.endsWith('/cerrar')) r.method = 'PATCH';
  else if (pathPart.includes('/items')) r.method = 'POST';
  else r.method = 'POST';
}

function urlPath(url) {
  if (typeof url !== 'string') return '';
  return url.replace(/\{\{baseUrl\}\}/, '').split('?')[0];
}

function ensureJsonHeader(r) {
  if (!r.header) r.header = [];
  if (!r.header.some((h) => h.key === 'Content-Type')) {
    r.header.push({ key: 'Content-Type', value: 'application/json' });
  }
}

function sampleBody(url, method) {
  const p = urlPath(url);
  if (method === 'GET' || method === 'DELETE') {
    return JSON.stringify(
      { _nota: `${method}: sin cuerpo obligatorio en la API`, sugerencia: 'Usar query params o path según el endpoint' },
      null,
      2
    );
  }

  const rules = [
    [/^\/api\/ventas\/zonas(\/\{\{zonaId\}\})?$/, { sucursalId: 1, nombre: 'Salón principal', capacidad: 40 }],
    [/^\/api\/ventas\/mesas(\/\{\{mesaId\}\})?$/, { zonaId: 1, numero: 'M-01', capacidad: 4 }],
    [
      /^\/api\/ventas\/puntos-venta(\/\{\{puntoVentaId\}\})?$/,
      {
        sucursalId: 1,
        almacenId: 1,
        codigo: 'PV01',
        nombre: 'Caja principal',
        serieBoleta: 'B001',
        serieFactura: 'F001',
        tipoImpresora: 'TERMICA',
      },
    ],
    [
      /^\/api\/ventas\/cartas(\/\{\{cartaId\}\})?$/,
      {
        sucursalId: 1,
        nombre: 'Carta almuerzo',
        descripcion: 'Menú demo',
        detalles: [{ articuloId: 1, precio: 25.5, orden: 1 }],
      },
    ],
    [/^\/api\/ventas\/cartas\/\{\{cartaId\}\}\/items$/, { articuloId: 1, precio: 18.0, orden: 2 }],
    [/^\/api\/ventas\/cartas\/\{\{cartaId\}\}\/items\/\{\{itemId\}\}$/, { precio: 20.0, orden: 1 }],
    [
      /^\/api\/ventas\/pedidos-mesa(\/\{\{pedidoMesaId\}\})?$/,
      {
        sucursalId: 1,
        tipo: 'MESA',
        mesaId: 1,
        meseroId: 1,
        turnoId: 1,
        numero: 'SES-001',
        comensales: 2,
        observaciones: 'Demo',
      },
    ],
    [
      /^\/api\/ventas\/comandas$/,
      {
        sucursalId: 1,
        puntoVentaId: 1,
        turnoId: 1,
        clienteId: 1,
        mesa: 'M-01',
        fechaHora: '2026-05-11T12:00:00Z',
        items: [{ articuloId: 1, cantidad: 2, precioUnitario: 15.5, observacion: 'Sin cebolla' }],
      },
    ],
    [/^\/api\/ventas\/comandas\/\{\{comandaId\}\}$/, { sucursalId: 1, puntoVentaId: 1, turnoId: 1, clienteId: 1, mesa: 'M-01', fechaHora: '2026-05-11T12:00:00Z', items: [{ articuloId: 1, cantidad: 1, precioUnitario: 10.0 }] }],
    [/^\/api\/ventas\/comandas\/\{\{comandaId\}\}\/items$/, { items: [{ articuloId: 1, cantidad: 1, precioUnitario: 12.0 }] }],
    [/^\/api\/ventas\/comandas\/\{\{comandaId\}\}\/estado$/, { flagEstado: '1' }],
    [
      /^\/api\/ventas\/facturas-simplificadas(\/\{\{facturaId\}\})?$/,
      {
        sucursalId: 1,
        puntoVentaId: 1,
        clienteId: 1,
        docTipoId: 1,
        serie: 'B001',
        numero: '000001',
        fechaEmision: '2026-05-11',
        monedaId: 1,
        items: [{ articuloId: 1, cantidad: 2, precioUnitario: 15.0 }],
        pagos: [{ formaPagoId: 1, monto: 30.0, referencia: 'Efectivo' }],
      },
    ],
    [
      /^\/api\/ventas\/cuentas-cobrar$/,
      {
        sucursalId: 1,
        clienteId: 1,
        docTipoId: 1,
        serie: 'CC',
        numero: '000010',
        fechaEmision: '2026-05-11',
        fechaVencimiento: '2026-06-11',
        monedaId: 1,
        total: 100.0,
        saldo: 100.0,
        movimientos: [],
      },
    ],
    [
      /^\/api\/ventas\/cuentas-cobrar\/\{\{cuentaCobrarId\}\}$/,
      {
        sucursalId: 1,
        clienteId: 1,
        docTipoId: 1,
        serie: 'CC',
        numero: '000010',
        fechaEmision: '2026-05-11',
        monedaId: 1,
        total: 100.0,
        saldo: 50.0,
      },
    ],
    [
      /^\/api\/ventas\/cuentas-cobrar\/\{\{cuentaCobrarId\}\}\/movimientos$/,
      { fechaMov: '2026-05-11', tipoMov: 'ABONO', monto: 25.0, referencia: 'Pago demo', conceptoFinancieroId: 1 },
    ],
    [/^\/api\/ventas\/cuentas-cobrar\/\{\{cuentaCobrarId\}\}\/anular$/, { motivo: 'Anulación de prueba' }],
    [
      /^\/api\/ventas\/cuentas-cobrar\/directo$/,
      {
        sucursalId: 1,
        clienteId: 5,
        docTipoId: 2,
        serie: 'F001',
        numero: '00099',
        fechaEmision: '2026-05-27',
        fechaVencimiento: '2026-06-27',
        monedaId: 1,
        servicioCxcId: 1,
        descripcion: 'Catering evento corporativo',
        monto: 1500.0,
      },
    ],
    [
      /^\/api\/ventas\/cuentas-cobrar\/\{\{cuentaCobrarId\}\}\/detraccion$/,
      { tasa: 0.12, serie: 'DTR', numero: '000001' },
    ],
    [
      /^\/api\/ventas\/cuentas-cobrar\/notas-credito$/,
      {
        cuentaCobrarOrigenId: 1,
        serie: 'NC01',
        numero: '000001',
        fechaEmision: '2026-05-27',
        monto: 100.0,
        motivo: 'Devolución parcial',
        conceptoFinancieroId: 1,
      },
    ],
    [
      /^\/api\/ventas\/ordenes-venta(\/\{\{ordenVentaId\}\})?$/,
      {
        sucursalId: 1,
        nroOrdenVenta: '',
        clienteId: 1,
        vendedorId: 1,
        fechaEmision: '2026-05-11',
        monedaId: 1,
        docTipoId: 1,
        observaciones: 'OV demo',
        detalles: [{ articuloId: 1, lineaNro: 1, cantProyectada: 10, valorUnitario: 5.5, tipoImpuesto: 'IGV', valorImpuesto: 0.99, almacenId: 1 }],
      },
    ],
    [
      /^\/api\/ventas\/proformas(\/\{\{proformaId\}\})?$/,
      {
        sucursalId: 1,
        clienteId: 1,
        numero: '',
        fecha: '2026-05-11',
        fechaValidez: '2026-06-11',
        monedaId: 1,
        detalles: [{ articuloId: 1, descripcion: 'Ítem demo', cantidad: 5, precioUnitario: 20.0, descuento: 0 }],
      },
    ],
    [
      /^\/api\/ventas\/cierre-caja$/,
      {
        turnoId: 1,
        ventasEfectivo: 100.0,
        ventasTarjeta: 50.0,
        ventasDigital: 0,
        ventasTotal: 150.0,
        propinasTotal: 10.0,
        fondoInicial: 200.0,
        observaciones: 'Turno demo',
      },
    ],
    [/^\/api\/ventas\/cierre-caja\/\{\{cierreCajaId\}\}\/cerrar$/, { fondoFinal: 350.0, diferencia: 0, observaciones: 'Cierre OK' }],
    [
      /^\/api\/ventas\/descuentos-promocion(\/\{\{descuentoPromocionId\}\})?$/,
      {
        nombre: 'Happy hour',
        tipo: 'PORCENTAJE',
        valor: 10.0,
        fechaInicio: '2026-05-01',
        fechaFin: '2026-12-31',
        diasAplicacion: 'LUN-VIE',
        horaInicio: '17:00:00',
        horaFin: '19:00:00',
        montoMinimo: 30.0,
      },
    ],
    [/^\/api\/ventas\/zonas-venta(\/\{\{zonaVentaId\}\})?$/, { zonaVenta: 'ZV01', descZonaVenta: 'Zona venta demo', ubigeo: '150101' }],
    [/^\/api\/ventas\/zonas-despacho(\/\{\{zonaDespachoId\}\})?$/, { zonaDespacho: 'ZD01', descZonaDespacho: 'Despacho demo', ubigeo: '150101' }],
    [/^\/api\/ventas\/zonas-reparto(\/\{\{zonaRepartoId\}\})?$/, { zonaReparto: 'ZR01', descZonaReparto: 'Reparto demo', ubigeo: '150101' }],
    [/^\/api\/ventas\/canales-distribucion(\/\{\{canalDistribucionId\}\})?$/, { codigo: 'LOCAL', nombre: 'Local / salón' }],
    [/^\/api\/ventas\/servicios-cxc(\/\{\{servicioCxcId\}\})?$/, { codServicio: 'S01', descServicio: 'Servicio cobranza demo', tarifa: 5.0, flagAfectoIgv: '1', flagReplicacion: '1', codMoneda: 'PEN' }],
    [/^\/api\/ventas\/vendedores(\/\{\{vendedorId\}\})?$/, { usuarioId: 1, nombre: 'Vendedor demo', comisionPorcentaje: 3.5 }],
  ];

  for (const [re, obj] of rules) {
    if (re.test(p)) return JSON.stringify(obj, null, 2);
  }

  if (method === 'PATCH' || method === 'POST') {
    return JSON.stringify({ _nota: 'Sin payload obligatorio; ajustar si el endpoint lo requiere' }, null, 2);
  }
  return JSON.stringify({ _nota: 'Ver DTO en pe.restaurant.ventas.dto.request' }, null, 2);
}

function enrichBody(item) {
  const r = item.request;
  if (!r || !r.url) return;
  const method = r.method;
  const url = typeof r.url === 'string' ? r.url : '';

  if (method !== 'POST' && method !== 'PUT') return;

  const raw = r.body?.mode === 'raw' ? r.body.raw : null;
  const isEmpty = !raw || raw.trim() === '{}' || raw.trim() === '';

  if (isEmpty) {
    const sample = sampleBody(url, method);
    r.body = { mode: 'raw', raw: sample, options: { raw: { language: 'json' } } };
    ensureJsonHeader(r);
  } else if (r.body?.mode === 'raw' && r.body.raw === '{}') {
    r.body.raw = sampleBody(url, method);
    r.body.options = { raw: { language: 'json' } };
    ensureJsonHeader(r);
  }
}

function stripPlaceholderBodies(items) {
  if (!items) return;
  for (const it of items) {
    if (it.request?.body?.raw?.includes('"_nota"')) {
      delete it.request.body;
      it.request.header = (it.request.header || []).filter((h) => h.key !== 'Content-Type');
    }
    if (it.item) stripPlaceholderBodies(it.item);
  }
}

const JSON_HDR = [{ key: 'Content-Type', value: 'application/json' }];

function mkRequest(name, method, pathSuffix, body, desc) {
  const req = {
    method,
    header: body ? [...JSON_HDR] : [],
    url: `{{baseUrl}}${pathSuffix}`,
    description: desc || '',
  };
  if (body) {
    req.body = {
      mode: 'raw',
      raw: typeof body === 'string' ? body : JSON.stringify(body, null, 2),
      options: { raw: { language: 'json' } },
    };
  }
  return { name, request: req };
}

function syncCuentasCobrarEndpoints(rootFolder) {
  const cxc = rootFolder.item?.find((x) => x.name && x.name.includes('Cuentas por cobrar'));
  if (!cxc || !cxc.item) return;

  const listar = cxc.item.find((x) => x.name === 'GET Listar');
  if (listar?.request) {
    listar.request.description =
      'Filtros opcionales: sucursalId, clienteId, docTipoId, flagEstado, fechaVencimientoDesde/Hasta (dd/MM/yyyy).';
  }

  const crear = cxc.item.find((x) => x.name === 'POST Crear');
  if (crear?.request) {
    crear.request.body = {
      mode: 'raw',
      raw: JSON.stringify(
        {
          sucursalId: 1,
          clienteId: 5,
          docTipoId: 2,
          serie: 'FC01',
          numero: '000001',
          fechaEmision: '2026-05-18',
          fechaVencimiento: '2026-06-18',
          monedaId: 1,
          total: 1180.0,
          saldo: 1180.0,
          movimientos: [
            {
              fechaMov: '2026-05-18',
              tipoMov: 'CARGO',
              monto: 1180.0,
              referencia: 'Cargo inicial',
              conceptoFinancieroId: 1,
            },
          ],
        },
        null,
        2
      ),
      options: { raw: { language: 'json' } },
    };
    crear.request.header = [...JSON_HDR];
  }

  const byUrl = (suffix) =>
    cxc.item.some((x) => {
      const u = x.request?.url;
      return typeof u === 'string' && u.includes(suffix);
    });

  const nuevos = [];
  if (!byUrl('/directo')) {
    nuevos.push(
      mkRequest(
        'POST Documento directo',
        'POST',
        '/api/ventas/cuentas-cobrar/directo',
        `{
  "sucursalId": {{sucursalId}},
  "clienteId": 5,
  "docTipoId": 2,
  "serie": "F001",
  "numero": "00099",
  "fechaEmision": "2026-05-27",
  "fechaVencimiento": "2026-06-27",
  "monedaId": 1,
  "servicioCxcId": {{servicioCxcId}},
  "descripcion": "Catering evento corporativo",
  "monto": 1500.00
}`,
        'Ingreso fuera de POS/OV (HU-FIN-OP-CC-003). Concepto default FI-108. Valida servicios_cxc y límite crédito.'
      )
    );
  }
  if (!byUrl('/detraccion')) {
    nuevos.push(
      mkRequest(
        'POST Generar detracción',
        'POST',
        '/api/ventas/cuentas-cobrar/{{cuentaCobrarId}}/detraccion',
        { tasa: 0.12, serie: 'DTR', numero: '000001' },
        'Genera doc_tipo DTRC cuando total origen ≥ S/ 700. Tasa default 12 %, concepto FI-098. Body opcional.'
      )
    );
  }
  if (!byUrl('/notas-credito')) {
    nuevos.push(
      mkRequest(
        'POST Nota de crédito',
        'POST',
        '/api/ventas/cuentas-cobrar/notas-credito',
        `{
  "cuentaCobrarOrigenId": {{cuentaCobrarId}},
  "serie": "NC01",
  "numero": "000001",
  "fechaEmision": "2026-05-27",
  "monto": 100.00,
  "motivo": "Devolución parcial",
  "conceptoFinancieroId": 1
}`,
        'Emite NCC y aplica abono automático en CxC origen.'
      )
    );
  }
  if (!byUrl('/pendientes/agrupado')) {
    nuevos.push(
      mkRequest(
        'GET Pendientes agrupado',
        'GET',
        '/api/ventas/cuentas-cobrar/pendientes/agrupado?sucursalId={{sucursalId}}&clienteId=5',
        null,
        'Agrupa cuentasCobrar, documentosDirecto, detraccionesCobrar, notasCreditoCobrar. Filtros opcionales: sucursalId, clienteId, fechaDesde/Hasta (dd/MM/yyyy).'
      )
    );
  }
  if (!byUrl('/pendientes/simple')) {
    nuevos.push(
      mkRequest(
        'GET Pendientes simple',
        'GET',
        '/api/ventas/cuentas-cobrar/pendientes/simple?sucursalId={{sucursalId}}&clienteId=5',
        null,
        'Lista plana unificada de pendientes. Filtros opcionales: sucursalId, clienteId, fechaDesde/Hasta (dd/MM/yyyy).'
      )
    );
  }

  if (nuevos.length) cxc.item.push(...nuevos);
}

function issue5Folder() {
  const mk = (name, method, pathSuffix, body, desc) => mkRequest(name, method, pathSuffix, body, desc);

  const propinaBody = `{
  "fsFacturaSimplId": {{fsFacturaSimplId}},
  "trabajadorId": {{usuarioId}},
  "monto": 5.50,
  "fecha": "2026-05-11"
}`;
  const reservaBody = JSON.stringify(
    {
      sucursalId: 1,
      clienteId: 1,
      mesaId: 1,
      fecha: '2026-05-20',
      hora: '20:00:00',
      comensales: 4,
      observaciones: 'Cumpleaños',
      items: [{ articuloId: 1, cantidad: 2, observacion: 'Sin gluten' }],
    },
    null,
    2
  );
  const reservaCancel = JSON.stringify({ motivo: 'Cliente canceló' }, null, 2);
  const creditoBody = `{
  "entidadContribuyenteId": {{entidadContribuyenteId}},
  "monedaId": 1,
  "limiteCredito": 5000.00,
  "diasCredito": 30
}`;

  return {
    name: '18 Issue 5 — Propinas, reservaciones, créditos CxC',
    description: 'Endpoints nuevos (mayo 2026). Variables: propinaId, reservacionId, creditoCxcId, fsFacturaSimplId.',
    item: [
      mk('GET Listar propinas', 'GET', '/api/ventas/propinas?page=0&size=20&sort=id,desc', null, 'Filtros: fsFacturaSimplId, trabajadorId, fechaDesde, fechaHasta, flagEstado'),
      mk('GET Propina por ID', 'GET', '/api/ventas/propinas/{{propinaId}}', null, ''),
      mk('POST Crear propina', 'POST', '/api/ventas/propinas', propinaBody, 'fsFacturaSimplId debe existir y factura no anulada (reglas de negocio).'),
      mk('PUT Actualizar propina', 'PUT', '/api/ventas/propinas/{{propinaId}}', propinaBody, ''),
      mk('PATCH Activar propina', 'PATCH', '/api/ventas/propinas/{{propinaId}}/activar', null, ''),
      mk('PATCH Desactivar propina', 'PATCH', '/api/ventas/propinas/{{propinaId}}/desactivar', null, ''),
      mk('GET Listar reservaciones', 'GET', '/api/ventas/reservaciones?page=0&size=20&sort=id,desc', null, 'Filtros: sucursalId, clienteId, mesaId, estado, fechaDesde, fechaHasta'),
      mk('GET Reservación por ID', 'GET', '/api/ventas/reservaciones/{{reservacionId}}', null, ''),
      mk('POST Crear reservación', 'POST', '/api/ventas/reservaciones', reservaBody, ''),
      mk('PUT Actualizar reservación', 'PUT', '/api/ventas/reservaciones/{{reservacionId}}', reservaBody, 'Solo en estado CONFIRMADA.'),
      mk('POST Confirmar reservación', 'POST', '/api/ventas/reservaciones/{{reservacionId}}/confirmar', null, ''),
      mk('POST Cancelar reservación', 'POST', '/api/ventas/reservaciones/{{reservacionId}}/cancelar', reservaCancel, 'Body opcional (motivo).'),
      mk('PATCH Activar reservación', 'PATCH', '/api/ventas/reservaciones/{{reservacionId}}/activar', null, ''),
      mk('PATCH Desactivar reservación', 'PATCH', '/api/ventas/reservaciones/{{reservacionId}}/desactivar', null, ''),
      mk('GET Listar créditos CxC', 'GET', '/api/ventas/creditos-cxc?page=0&size=20&sort=id,desc', null, 'Filtros: entidadContribuyenteId, monedaId, flagEstado'),
      mk('GET Crédito CxC por ID', 'GET', '/api/ventas/creditos-cxc/{{creditoCxcId}}', null, ''),
      mk('POST Crear crédito CxC', 'POST', '/api/ventas/creditos-cxc', creditoBody, ''),
      mk('PUT Actualizar crédito CxC', 'PUT', '/api/ventas/creditos-cxc/{{creditoCxcId}}', creditoBody, ''),
      mk('PATCH Activar crédito CxC', 'PATCH', '/api/ventas/creditos-cxc/{{creditoCxcId}}/activar', null, ''),
      mk('PATCH Desactivar crédito CxC', 'PATCH', '/api/ventas/creditos-cxc/{{creditoCxcId}}/desactivar', null, ''),
      mk('DELETE Crédito CxC (baja lógica)', 'DELETE', '/api/ventas/creditos-cxc/{{creditoCxcId}}', null, ''),
    ],
  };
}

const col = JSON.parse(fs.readFileSync(COLLECTION_PATH, 'utf8'));

const extraVars = [
  { key: 'propinaId', value: '1' },
  { key: 'reservacionId', value: '1' },
  { key: 'creditoCxcId', value: '1' },
  { key: 'fsFacturaSimplId', value: '1' },
  { key: 'entidadContribuyenteId', value: '1' },
];
for (const v of extraVars) {
  if (!col.variable.some((x) => x.key === v.key)) col.variable.push(v);
}

col.info.description =
  'Colección única ms-ventas: todos los controladores bajo /api/ventas.\n\nVariables:\n- baseUrl (ej. http://localhost:9010)\n- accessToken (JWT Bearer)\n- IDs de ejemplo — actualizar tras listar o usar seed admin.\n\nPOST/PUT/PATCH con body incluyen ejemplos alineados a los DTOs; ajustar FKs (cliente, artículo, turno) al tenant.\n\nMayo 2026: flujos CxC (directo, detracción, NC, pendientes) y carpeta Issue 5 (propinas, reservaciones, créditos CxC).\nScript: postman/tools/update-ms-ventas-collection.mjs';

const rootFolder = col.item.find((x) => x.name && x.name.includes('Endpoints ms-ventas'));
if (rootFolder && rootFolder.item) {
  syncCuentasCobrarEndpoints(rootFolder);
  const has = rootFolder.item.some((x) => x.name && x.name.includes('Issue 5'));
  if (!has) {
    rootFolder.item.push(issue5Folder());
  }
}

walkItems(col.item, (item) => {
  fixInvertedMethodUrl(item);
  enrichBody(item);
});

stripPlaceholderBodies(col.item);

fs.writeFileSync(COLLECTION_PATH, JSON.stringify(col, null, 2) + '\n', 'utf8');
console.log('OK:', COLLECTION_PATH);
