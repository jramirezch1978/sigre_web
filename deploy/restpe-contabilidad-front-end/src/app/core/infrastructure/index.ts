// ============================================================================
// Barrel exports — Infrastructure (servicios transversales)
// Servicios consumidos por múltiples módulos, sin lógica de negocio propia.
// Importar desde: import { ... } from '@core/infrastructure';
// ============================================================================

// ── HTTP ────────────────────────────────────────────────────────────────────
export { ApiClientService } from './http/api-client.service';
export { CacheService } from './http/cache.service';

// ── Maestros ────────────────────────────────────────────────────────────────
export { ParametroService, Parametro } from './maestros/parametro.service';
export { MonedaService, Moneda, TipoCambio } from './maestros/moneda.service';
export { UbigeoService, Departamento, Provincia, Distrito } from './maestros/ubigeo.service';
export { TipoDocumentoService, TipoDocumento } from './maestros/tipo-documento.service';
export { UnidadMedidaService, UnidadMedida } from './maestros/unidad-medida.service';

// ── Exportación ─────────────────────────────────────────────────────────────
export { ExcelExportService, ExcelColumn } from './export/excel-export.service';
export { PdfExportService } from './export/pdf-export.service';

// ── SUNAT / RENIEC ──────────────────────────────────────────────────────────
export { SunatService, ConsultaRucResult, ConsultaDniResult } from './sunat/sunat.service';
