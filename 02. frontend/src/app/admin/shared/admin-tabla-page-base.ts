import { TablaColumna } from '../../erp/shared/models/api-page.model';

/**
 * Clase maestra para las páginas de admin que muestran una tabla con `erp-data-table`.
 * Centraliza el mapeo de registros → filas y el manejo del botón Editar, para no
 * repetir el cableado en cada página. Cada subclase solo define:
 *  - `columnasTabla` (las columnas),
 *  - `registrosTabla` (los registros ya filtrados),
 *  - `aFila(r)` (cómo se ve cada fila),
 *  - y, si la tabla permite editar, `editarRegistro(r)`.
 *
 * En el HTML se usa `[columnas]="columnasTabla" [filas]="filasTabla" (editar)="onEditarFila($event)"`.
 */
export abstract class AdminTablaPageBase<T extends { id: number }> {
  /** Columnas de la tabla (las define la subclase). */
  abstract columnasTabla: TablaColumna[];

  /** Registros YA filtrados que se muestran en la tabla. */
  protected abstract get registrosTabla(): T[];

  /** Mapea un registro a la fila que consume erp-data-table. */
  protected abstract aFila(registro: T): Record<string, unknown>;

  /** Abre la edición de un registro. Vacío por defecto (tablas de solo lectura). */
  protected editarRegistro(_registro: T): void { /* override en subclases editables */ }

  /** Filas listas para `erp-data-table`. */
  get filasTabla(): Record<string, unknown>[] {
    return this.registrosTabla.map(r => this.aFila(r));
  }

  /** Handler del evento (editar) de erp-data-table: resuelve el registro por id. */
  onEditarFila(row: Record<string, unknown>): void {
    const r = this.registrosTabla.find(x => x.id === row['id']);
    if (r) this.editarRegistro(r);
  }
}
