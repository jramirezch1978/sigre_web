import { Injectable } from '@angular/core';

/**
 * @summary Effects de sincronización para el reporte tributario por período.
 * @description
 * El reporte tributario es de solo lectura (no tiene operaciones de guardar
 * ni anular), por lo que este archivo existe para mantener paridad estructural
 * con el patrón de almacén. Aquí se pueden agregar en el futuro efectos
 * de recarga automática al cambiar filtros u otras acciones reactivas.
 */
@Injectable()
export class ReporteTributarioSyncEffects {
  // Sin operaciones de mutación — sin efectos de sincronización por ahora.
}
