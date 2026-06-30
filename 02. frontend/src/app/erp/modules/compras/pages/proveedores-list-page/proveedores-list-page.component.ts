import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { ErpDataTableComponent } from '../../../../shared/erp-data-table/erp-data-table.component';
import { ErpMetoxiListPageComponent, ErpMetoxiFiltroTab } from '../../../../shared/erp-metoxi-list-page/erp-metoxi-list-page.component';
import { contarRegistrosPorEstado, filtrarFilasListado } from '../../../../shared/utils/erp-list-filter.util';
import { TablaColumna } from '../../../../shared/models/api-page.model';
import { ErpTablaPageBase } from '../../../../shared/base/erp-tabla-page-base';
import { forkJoin } from 'rxjs';
import { abrirDialogoMetoxi } from '@sigre-common';
import { ComprasApiService, RelacionComercialDto } from '../../services/compras-api.service';
import { ProveedorDialogComponent, ProveedorDialogData } from '../../components/proveedor-dialog/proveedor-dialog.component';

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
  imports: [CommonModule, MatDialogModule, ErpDataTableComponent, ErpMetoxiListPageComponent],
  templateUrl: './proveedores-list-page.component.html',
})
export class ProveedoresListPageComponent extends ErpTablaPageBase implements OnInit {
  private readonly api = inject(ComprasApiService);
  private readonly dialog = inject(MatDialog);

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

  anadir(): void {
    this.abrirFicha(null);
  }

  editar(fila: Record<string, unknown>): void {
    this.abrirFicha((fila['id'] as number) ?? null);
  }

  private abrirFicha(registroId: number | null): void {
    const data: ProveedorDialogData = { registroId };
    abrirDialogoMetoxi(this.dialog, ProveedorDialogComponent, { data, width: '1100px' })
      .afterClosed()
      .subscribe(() => this.cargar());
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
