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

  @Output() editar = new EventEmitter<Record<string, unknown>>();
  @Output() anular = new EventEmitter<Record<string, unknown>>();
  @Output() eliminar = new EventEmitter<Record<string, unknown>>();

  private readonly exportSvc = inject(ErpExportService);

  readonly opcionesTamanoPagina = [10, 25, 50, 100];

  tamanoPagina = 10;
  paginaActual = 1;
  mostrarModalExport = false;
  exportando = false;

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['filas'] || changes['tamanoPaginaInicial']) {
      this.tamanoPagina = this.tamanoPaginaInicial;
      this.paginaActual = 1;
    }
  }

  get totalPaginas(): number {
    if (!this.habilitarPaginacion || this.filas.length === 0) return 1;
    return Math.max(1, Math.ceil(this.filas.length / this.tamanoPagina));
  }

  get filasPagina(): Record<string, unknown>[] {
    if (!this.habilitarPaginacion) return this.filas;
    const inicio = (this.paginaActual - 1) * this.tamanoPagina;
    return this.filas.slice(inicio, inicio + this.tamanoPagina);
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
