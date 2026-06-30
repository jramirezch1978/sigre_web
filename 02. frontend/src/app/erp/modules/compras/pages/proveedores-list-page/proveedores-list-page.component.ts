import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { ErpMetoxiListPageComponent, ErpMetoxiFiltroTab } from '../../../../shared/erp-metoxi-list-page/erp-metoxi-list-page.component';
import { contarRegistrosPorEstado, filtrarFilasListado } from '../../../../shared/utils/erp-list-filter.util';
import { TablaColumna } from '../../../../shared/models/api-page.model';
import { ErpTablaPageBase } from '../../../../shared/base/erp-tabla-page-base';
import { forkJoin } from 'rxjs';
import { ComprasApiService, RelacionComercialDto } from '../../services/compras-api.service';

const COLUMNAS: TablaColumna[] = [
  { key: 'razonSocial', header: 'Razón social / Nombre', width: '240px' },
  { key: 'nroDocumento', header: 'N° documento', width: '120px' },
  { key: 'tipo', header: 'Relación', width: '130px' },
  { key: 'tipoProveedor', header: 'Tipo de proveedor', width: '160px' },
  { key: 'telefono', header: 'Teléfono', width: '120px' },
  { key: 'email', header: 'Email', width: '190px' },
  { key: 'flagEstado', header: 'Estado', width: '90px', format: 'estado' },
];

/** Maestro de Proveedores/Clientes (CM002) — lista. El alta/edición multipestaña va aparte. */
@Component({
  selector: 'app-proveedores-list-page',
  standalone: true,
  imports: [CommonModule, ErpDataTableComponent, ErpMetoxiListPageComponent],
  templateUrl: './proveedores-list-page.component.html',
})
export class ProveedoresListPageComponent extends ErpTablaPageBase implements OnInit {
  private readonly api = inject(ComprasApiService);

  override codigo = 'CM002';
  override nombre = 'Ficha de Proveedores/Clientes';

  columnas = COLUMNAS;
  filas: Record<string, unknown>[] = [];
  busqueda = '';
  filtroTab: ErpMetoxiFiltroTab = 'todos';
  cargando = true;
  error = '';

  get conteo() {
    return contarRegistrosPorEstado(this.filas);
  }

  get filasVisibles(): Record<string, unknown>[] {
    return filtrarFilasListado(this.filas, this.columnas, this.busqueda, this.filtroTab);
  }

  ngOnInit(): void {
    this.cargarPreferenciasTabla();
    this.cargar();
  }

  recargar(): void {
    this.cargar();
  }

  private cargar(): void {
    this.cargando = true;
    this.error = '';
    forkJoin({
      relaciones: this.api.listarRelaciones(),
      tipos: this.api.listarTiposEntidad(),
    }).subscribe({
      next: ({ relaciones, tipos }) => {
        const nombreTipo = new Map(tipos.map(t => [t.id, t.descripcion || t.tipo]));
        this.filas = relaciones.map(f => ({
          ...f,
          tipo: this.etiquetaTipo(f),
          tipoProveedor: f.tipoEntidadContribuyenteId
            ? (nombreTipo.get(f.tipoEntidadContribuyenteId) ?? '—')
            : '—',
        }));
        this.cargando = false;
      },
      error: err => {
        this.cargando = false;
        this.error = err?.error?.message ?? 'No se pudieron cargar los proveedores/clientes';
        this.filas = [];
      },
    });
  }

  private etiquetaTipo(f: RelacionComercialDto): string {
    if (f.esProveedor && f.esCliente) return 'Proveedor/Cliente';
    if (f.esProveedor) return 'Proveedor';
    if (f.esCliente) return 'Cliente';
    return '—';
  }
}
