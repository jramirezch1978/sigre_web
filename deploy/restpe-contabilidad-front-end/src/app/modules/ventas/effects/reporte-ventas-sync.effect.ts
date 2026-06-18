import { Injectable } from '@angular/core';

/**
 * @summary Sync effects para el reporte de ventas.
 * @description
 * El reporte de ventas es de sólo lectura (sin operaciones de guardar/anular).
 * Esta clase existe para mantener paridad con el patrón de arquitectura.
 * Puede extenderse para recargar datos tras aplicar filtros avanzados.
 */
@Injectable()
export class ReporteVentasSyncEffects {}
