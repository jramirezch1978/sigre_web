import { Component, EventEmitter, Input, OnChanges, Output, SimpleChanges, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TablaColumna } from '../models/api-page.model';
import { ErpExportService, ExportFormato } from '../utils/erp-export.service';

@Component({
  selector: 'app-erp-data-table',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './erp-data-table.component.html',
  styleUrls: ['./erp-data-table.component.scss'],
})
export class ErpDataTableComponent implements OnChanges {
  @Input({ required: true }) columnas: TablaColumna[] = [];
  @Input() filas: Record<string, unknown>[] = [];
  @Input() cargando = false;
  @Input() error = '';
  @Input() totalRegistros = 0;
  @Input() mostrarAcciones = false;
  @Input() nombreExport = 'sigre-tabla';
  @Input() habilitarExportacion = true;
  @Input() habilitarPaginacion = true;
  @Input() tamanoPaginaInicial = 10;
  /** Orden inicial persistido: "columna:direccion" (ej. "nombre:asc"). Vacío = sin orden. */
  @Input() ordenInicial: string | null = null;
  /** Tamaño de página persistido por usuario+ventana (null = usar el default). */
  @Input() tamanoPaginaPersistido: number | null = null;

  @Output() editar = new EventEmitter<Record<string, unknown>>();
  @Output() anular = new EventEmitter<Record<string, unknown>>();
  @Output() eliminar = new EventEmitter<Record<string, unknown>>();
  /** Emite "columna:direccion" cuando el usuario cambia el ordenamiento (para persistir). */
  @Output() ordenCambiado = new EventEmitter<string>();
  /** Emite la cantidad de registros por página cuando el usuario la cambia (para persistir). */
  @Output() tamanoPaginaCambiado = new EventEmitter<number>();

  ordenColumna: string | null = null;
  ordenDir: 'asc' | 'desc' = 'asc';

  private readonly exportSvc = inject(ErpExportService);

  readonly opcionesTamanoPagina = [10, 20, 50, 100];

  tamanoPagina = 10;
  paginaActual = 1;
  mostrarModalExport = false;
  exportando = false;
  private tamanoInicializado = false;

  ngOnChanges(changes: SimpleChanges): void {
    // Inicializa el tamaño de página UNA sola vez (no pisar la elección del usuario
    // en cada cambio de @Input filas — el padre puede recrear el array por CD).
    if (!this.tamanoInicializado && changes['tamanoPaginaInicial']) {
      this.tamanoPagina = this.tamanoPaginaInicial;
      this.tamanoInicializado = true;
    }
    // Aplica la preferencia persistida cuando llega (async). No emite — solo refleja lo guardado.
    if (changes['tamanoPaginaPersistido'] && this.tamanoPaginaPersistido != null) {
      const n = this.tamanoPaginaPersistido;
      if (this.opcionesTamanoPagina.includes(n)) {
        this.tamanoPagina = n;
        this.tamanoInicializado = true;
        this.paginaActual = 1;
      }
    }
    // Mantener la página actual dentro de rango; NO forzar a 1 en cada cambio.
    if (this.paginaActual > this.totalPaginas) {
      this.paginaActual = this.totalPaginas;
    }
    if (this.paginaActual < 1) {
      this.paginaActual = 1;
    }
    if (changes['ordenInicial']) {
      this.aplicarOrdenInicial();
    }
  }

  private aplicarOrdenInicial(): void {
    const raw = (this.ordenInicial ?? '').trim();
    if (!raw) { this.ordenColumna = null; return; }
    const [col, dir] = raw.split(':');
    if (this.columnas.some(c => c.key === col)) {
      this.ordenColumna = col;
      this.ordenDir = dir === 'desc' ? 'desc' : 'asc';
    } else {
      this.ordenColumna = null;
    }
  }

  ordenarPor(columna: string): void {
    if (!columna) return;
    if (this.ordenColumna === columna) {
      this.ordenDir = this.ordenDir === 'asc' ? 'desc' : 'asc';
    } else {
      this.ordenColumna = columna;
      this.ordenDir = 'asc';
    }
    this.paginaActual = 1;
    this.ordenCambiado.emit(`${this.ordenColumna}:${this.ordenDir}`);
  }

  private comparar(a: Record<string, unknown>, b: Record<string, unknown>, key: string): number {
    const va = a[key];
    const vb = b[key];
    if (va == null && vb == null) return 0;
    if (va == null) return -1;
    if (vb == null) return 1;
    if (typeof va === 'number' && typeof vb === 'number') return va - vb;
    return String(va).localeCompare(String(vb), 'es', { numeric: true, sensitivity: 'base' });
  }

  /** Filas ordenadas según la columna/dirección activa (antes de paginar). */
  get filasOrdenadas(): Record<string, unknown>[] {
    if (!this.ordenColumna) return this.filas;
    const col = this.ordenColumna;
    const factor = this.ordenDir === 'desc' ? -1 : 1;
    return [...this.filas].sort((a, b) => this.comparar(a, b, col) * factor);
  }

  get totalPaginas(): number {
    if (!this.habilitarPaginacion || this.filas.length === 0) return 1;
    return Math.max(1, Math.ceil(this.filas.length / this.tamanoPagina));
  }

  get filasPagina(): Record<string, unknown>[] {
    const fuente = this.filasOrdenadas;
    if (!this.habilitarPaginacion) return fuente;
    const inicio = (this.paginaActual - 1) * this.tamanoPagina;
    return fuente.slice(inicio, inicio + this.tamanoPagina);
  }

  get indiceInicio(): number {
    if (this.filas.length === 0) return 0;
    return (this.paginaActual - 1) * this.tamanoPagina + 1;
  }

  get indiceFin(): number {
    if (this.filas.length === 0) return 0;
    return Math.min(this.paginaActual * this.tamanoPagina, this.filas.length);
  }

  get textoInfoPaginacion(): string {
    if (this.filas.length === 0) return 'Sin registros';
    return `Mostrando ${this.indiceInicio} a ${this.indiceFin} de ${this.filas.length} registros`;
  }

  get paginasVisibles(): number[] {
    const total = this.totalPaginas;
    const max = 6;
    if (total <= max) {
      return Array.from({ length: total }, (_, i) => i + 1);
    }

    let inicio = Math.max(1, this.paginaActual - 2);
    let fin = Math.min(total, inicio + max - 1);
    inicio = Math.max(1, fin - max + 1);

    return Array.from({ length: fin - inicio + 1 }, (_, i) => inicio + i);
  }

  trackFila(row: Record<string, unknown>, index: number): string | number {
    const id = row['id'] ?? row['codigo'] ?? row['codMotivoTraslado'];
    return id != null ? String(id) : index;
  }

  valorCelda(fila: Record<string, unknown>, col: TablaColumna): string {
    const raw = fila[col.key];
    if (raw == null || raw === '') return '—';

    switch (col.format) {
      case 'estado':
        return raw === '1' || raw === 1 || raw === true ? 'Activo' : 'Inactivo';
      case 'fecha': {
        const d = new Date(String(raw));
        if (isNaN(d.getTime())) return String(raw);
        const dd = String(d.getDate()).padStart(2, '0');
        const mm = String(d.getMonth() + 1).padStart(2, '0');
        return `${dd}/${mm}/${d.getFullYear()}`;
      }
      case 'numero':
        return typeof raw === 'number' ? raw.toLocaleString('es-PE') : String(raw);
      default:
        return String(raw);
    }
  }

  estaActivo(fila: Record<string, unknown>): boolean {
    return this.estaActivoValor(fila['flagEstado']);
  }

  estaActivoValor(valor: unknown): boolean {
    return valor === '1' || valor === 1 || valor === true;
  }

  irAPagina(pagina: number): void {
    if (pagina < 1 || pagina > this.totalPaginas) return;
    this.paginaActual = pagina;
  }

  paginaAnterior(): void {
    this.irAPagina(this.paginaActual - 1);
  }

  paginaSiguiente(): void {
    this.irAPagina(this.paginaActual + 1);
  }

  onTamanoPaginaChange(): void {
    this.paginaActual = 1;
    this.tamanoPaginaCambiado.emit(this.tamanoPagina);
  }

  abrirModalExport(): void {
    if (this.filas.length === 0) return;
    this.mostrarModalExport = true;
  }

  cerrarModalExport(): void {
    this.mostrarModalExport = false;
  }

  exportarExcel(): void {
    this.ejecutarExport('xlsx');
  }

  exportarPdf(): void {
    this.ejecutarExport('pdf');
  }

  exportarWord(): void {
    this.ejecutarExport('docx');
  }

  /** El documento lo genera el backend (core-service); aquí solo se descarga. */
  private ejecutarExport(formato: ExportFormato): void {
    if (this.filas.length === 0 || this.exportando) return;
    this.exportando = true;
    this.exportSvc
      .exportar(formato, this.columnas, this.filas, this.nombreExport, (f, c) => this.valorCelda(f, c))
      .subscribe({
        next: () => { this.exportando = false; this.cerrarModalExport(); },
        error: () => { this.exportando = false; this.cerrarModalExport(); },
      });
  }
}
