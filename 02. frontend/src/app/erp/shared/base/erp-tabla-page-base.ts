import { inject } from '@angular/core';
import { ErpOrdenConfigService } from '../utils/erp-orden-config.service';

/**
 * Clase maestra para páginas que muestran una tabla ERP (erp-data-table).
 * Centraliza la persistencia por usuario+ventana del ORDEN de columnas y del TAMAÑO de página,
 * para no repetir el cableado en cada página. Cada subclase solo asigna `nombre`
 * (código/nombre de la ventana, estilo PowerBuilder: 'AL001', 'AL002', ...) y llama
 * a `cargarPreferenciasTabla()`.
 *
 * `nombre` se usa como:
 *  - clave de persistencia (config.configuracion, por usuario+empresa+ventana), y
 *  - base del nombre de archivo al exportar (se le añade _yyyymmdd_hhmmss).
 */
export abstract class ErpTablaPageBase {
  protected readonly ordenConfig = inject(ErpOrdenConfigService);

  /** Código/nombre de la ventana o reporte (lo asigna la subclase antes de cargarPreferenciasTabla). */
  nombre = '';

  /** Orden inicial persistido: "columna:direccion" (vacío = sin orden). Se pasa a erp-data-table. */
  ordenInicial: string | null = null;
  /** Tamaño de página persistido. Se pasa a erp-data-table. */
  tamanoPaginaPersistido: number | null = null;

  /** Lee del backend las preferencias guardadas (orden + tamaño) para `nombre`. */
  protected cargarPreferenciasTabla(): void {
    if (!this.nombre) return;
    this.ordenConfig.leerOrden(this.nombre).subscribe(v => { this.ordenInicial = v; });
    this.ordenConfig.leerTamanoPagina(this.nombre).subscribe(n => { this.tamanoPaginaPersistido = n; });
  }

  /** Persiste el orden de columna elegido (lo emite erp-data-table). */
  onOrdenCambiado(valor: string): void {
    if (this.nombre) this.ordenConfig.guardarOrden(this.nombre, valor);
  }

  /** Persiste el tamaño de página elegido (lo emite erp-data-table). */
  onTamanoPaginaCambiado(tamano: number): void {
    if (this.nombre) this.ordenConfig.guardarTamanoPagina(this.nombre, tamano);
  }
}
