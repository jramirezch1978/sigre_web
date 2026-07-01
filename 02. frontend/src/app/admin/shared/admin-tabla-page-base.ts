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

  // ─── Persistencia de preferencias (orden + tamaño de página) por usuario+ventana ───
  // Admin no siempre tiene contexto de tenant (catálogos globales como Módulos/Acciones
  // viven en sigre_security), así que se persiste en localStorage del navegador en vez
  // de core.configuracion (que usa el ERP vía ErpOrdenConfigService).

  /** Clave de la ventana para persistencia; por defecto el nombre de la clase concreta. */
  protected get claveVentana(): string {
    return this.constructor.name;
  }

  private get claveOrden(): string {
    return `sigre_admin_orden_${this.usuarioId()}_${this.claveVentana}`;
  }

  private get claveTamano(): string {
    return `sigre_admin_pagesize_${this.usuarioId()}_${this.claveVentana}`;
  }

  private usuarioId(): number | string {
    try {
      const raw = localStorage.getItem('rpe_user');
      if (raw) {
        const u = JSON.parse(raw);
        return u?.userId ?? 0;
      }
    } catch { /* ignore */ }
    return 0;
  }

  /** Orden inicial persistido ("columna:direccion"), para `[ordenInicial]` de erp-data-table. */
  readonly ordenInicial: string | null = this.leerLocal(this.claveOrden);

  /** Tamaño de página persistido, para `[tamanoPaginaPersistido]` de erp-data-table. */
  readonly tamanoPaginaPersistido: number | null = this.leerTamanoPersistido();

  /** Handler de `(ordenCambiado)` de erp-data-table: persiste el orden elegido. */
  onOrdenCambiado(valor: string): void {
    this.guardarLocal(this.claveOrden, valor);
  }

  /** Handler de `(tamanoPaginaCambiado)` de erp-data-table: persiste el tamaño elegido. */
  onTamanoPaginaCambiado(tamano: number): void {
    this.guardarLocal(this.claveTamano, String(tamano));
  }

  private leerTamanoPersistido(): number | null {
    const raw = this.leerLocal(this.claveTamano);
    const n = raw != null ? parseInt(raw, 10) : NaN;
    return Number.isFinite(n) && n > 0 ? n : null;
  }

  private leerLocal(clave: string): string | null {
    try { return localStorage.getItem(clave); } catch { return null; }
  }

  private guardarLocal(clave: string, valor: string): void {
    try { localStorage.setItem(clave, valor); } catch { /* preferencia de UI: no bloquear si falla */ }
  }

  // ─── Contadores Todos/Activos/Inactivos (cabecera, igual que el ERP) ───
  filtroEstado: 'todos' | 'activos' | 'inactivos' = 'todos';

  /** Universo completo (sin filtro de texto) para calcular los contadores. Override si difiere de `registrosTabla`. */
  protected get todosLosRegistros(): T[] { return this.registrosTabla; }

  /** Determina si un registro está activo; override si el campo no se llama `activo`. */
  protected activoDe(registro: T): boolean {
    return (registro as unknown as { activo?: boolean }).activo !== false;
  }

  get totalTodos(): number { return this.todosLosRegistros.length; }
  get totalActivosTab(): number { return this.todosLosRegistros.filter(r => this.activoDe(r)).length; }
  get totalInactivosTab(): number { return this.totalTodos - this.totalActivosTab; }

  seleccionarFiltroEstado(filtro: 'todos' | 'activos' | 'inactivos'): void {
    this.filtroEstado = filtro;
    this.paginaActual = 1;
  }

  /** Aplica el filtro Todos/Activos/Inactivos sobre una lista ya filtrada por texto. */
  protected filtrarPorEstado(lista: T[]): T[] {
    if (this.filtroEstado === 'activos') return lista.filter(r => this.activoDe(r));
    if (this.filtroEstado === 'inactivos') return lista.filter(r => !this.activoDe(r));
    return lista;
  }

  // ─── Paginación (para páginas con tabla propia: Empresas, Licencias, etc.) ───
  // Las páginas que usan erp-data-table NO necesitan esto (ese componente pagina solo).
  readonly opcionesTamanoPagina = [10, 20, 50, 100];
  tamanoPagina = this.tamanoPaginaPersistido ?? 10;
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

  onTamanoPaginaChange(): void {
    this.paginaActual = 1;
    this.guardarLocal(this.claveTamano, String(this.tamanoPagina));
  }
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
