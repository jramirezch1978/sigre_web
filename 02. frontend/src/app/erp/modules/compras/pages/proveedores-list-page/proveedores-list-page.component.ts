import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { ErpMetoxiListPageComponent, ErpMetoxiFiltroTab } from '../../../../shared/erp-metoxi-list-page/erp-metoxi-list-page.component';
import { contarRegistrosPorEstado, filtrarFilasListado } from '../../../../shared/utils/erp-list-filter.util';
import { TablaColumna } from '../../../../shared/models/api-page.model';
import { ErpTablaPageBase } from '../../../../shared/base/erp-tabla-page-base';
import { ComprasApiService, RelacionComercialDto } from '../../services/compras-api.service';

const COLUMNAS: TablaColumna[] = [
  { key: 'razonSocial', header: 'Razón social / Nombre', width: '260px' },
  { key: 'nroDocumento', header: 'N° documento', width: '120px' },
  { key: 'tipo', header: 'Tipo', width: '120px' },
  { key: 'telefono', header: 'Teléfono', width: '120px' },
  { key: 'email', header: 'Email', width: '200px' },
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
    this.api.listarRelaciones().subscribe({
      next: filas => {
        this.filas = filas.map(f => ({ ...f, tipo: this.etiquetaTipo(f) }));
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
