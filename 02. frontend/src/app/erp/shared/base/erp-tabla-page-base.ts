import { inject } from '@angular/core';
import { ErpOrdenConfigService } from '../utils/erp-orden-config.service';

/**
 * Clase maestra para páginas que muestran una tabla ERP (erp-data-table).
 * Centraliza la persistencia por usuario+ventana del ORDEN de columnas y del TAMAÑO de página,
 * para no repetir el cableado en cada página. Cada subclase solo asigna `codigo` y `nombre`
 * y llama a `cargarPreferenciasTabla()`.
 *
 * Cada ventana/opción tiene DOS identificadores:
 *  - `codigo`: estilo PowerBuilder ('AL001', 'AL002', ...). Se usa como **clave de persistencia**
 *    (config.configuracion, por usuario+empresa+ventana) y se muestra como prefijo del título.
 *  - `nombre`: nombre legible de la ventana o reporte ('Maestro de almacenes'). Se usa para
 *    **mostrar** ("(AL001) Maestro de almacenes") y como **base del archivo** al exportar
 *    (slug + _yyyymmdd_hhmmss).
 */
export abstract class ErpTablaPageBase {
  protected readonly ordenConfig = inject(ErpOrdenConfigService);

  /** Código de ventana estilo PowerBuilder (AL001). Clave de persistencia + prefijo del título. */
  codigo = '';
  /** Nombre legible de la ventana/reporte. Display + base del nombre de archivo al exportar. */
  nombre = '';

  /** Orden inicial persistido: "columna:direccion" (vacío = sin orden). Se pasa a erp-data-table. */
  ordenInicial: string | null = null;
  /** Tamaño de página persistido. Se pasa a erp-data-table. */
  tamanoPaginaPersistido: number | null = null;

  /** Clave de persistencia: el código (AL###); si faltara, cae al nombre. */
  protected get claveVentana(): string {
    return this.codigo || this.nombre;
  }

  /** Lee del backend las preferencias guardadas (orden + tamaño) para la ventana. */
  protected cargarPreferenciasTabla(): void {
    const clave = this.claveVentana;
    if (!clave) return;
    this.ordenConfig.leerOrden(clave).subscribe(v => { this.ordenInicial = v; });
    this.ordenConfig.leerTamanoPagina(clave).subscribe(n => { this.tamanoPaginaPersistido = n; });
  }

  /** Persiste el orden de columna elegido (lo emite erp-data-table). */
  onOrdenCambiado(valor: string): void {
    if (this.claveVentana) this.ordenConfig.guardarOrden(this.claveVentana, valor);
  }

  /** Persiste el tamaño de página elegido (lo emite erp-data-table). */
  onTamanoPaginaCambiado(tamano: number): void {
    if (this.claveVentana) this.ordenConfig.guardarTamanoPagina(this.claveVentana, tamano);
  }
}
