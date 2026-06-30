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

  // ─── Paginación (para páginas con tabla propia: Empresas, Licencias, etc.) ───
  // Las páginas que usan erp-data-table NO necesitan esto (ese componente pagina solo).
  readonly opcionesTamanoPagina = [10, 20, 50, 100];
  tamanoPagina = 10;
  paginaActual = 1;

  get totalPaginas(): number {
    return Math.max(1, Math.ceil(this.registrosTabla.length / this.tamanoPagina));
  }

  /** Registros de la página actual (rebana `registrosTabla`). */
  get registrosPagina(): T[] {
    if (this.paginaActual > this.totalPaginas) this.paginaActual = this.totalPaginas;
    const inicio = (this.paginaActual - 1) * this.tamanoPagina;
    return this.registrosTabla.slice(inicio, inicio + this.tamanoPagina);
  }

  onTamanoPaginaChange(): void { this.paginaActual = 1; }
  irAPagina(p: number): void { if (p >= 1 && p <= this.totalPaginas) this.paginaActual = p; }
  paginaAnterior(): void { this.irAPagina(this.paginaActual - 1); }
  paginaSiguiente(): void { this.irAPagina(this.paginaActual + 1); }

  get paginasVisibles(): number[] {
    const total = this.totalPaginas;
    const max = 6;
    if (total <= max) return Array.from({ length: total }, (_, i) => i + 1);
    let inicio = Math.max(1, this.paginaActual - 2);
    const fin = Math.min(total, inicio + max - 1);
    inicio = Math.max(1, fin - max + 1);
    return Array.from({ length: fin - inicio + 1 }, (_, i) => inicio + i);
  }

  get textoInfoPaginacion(): string {
    const n = this.registrosTabla.length;
    if (n === 0) return 'Sin registros';
    const ini = (this.paginaActual - 1) * this.tamanoPagina + 1;
    const fin = Math.min(this.paginaActual * this.tamanoPagina, n);
    return `Mostrando ${ini} a ${fin} de ${n} registros`;
  }
}
