import { Component, OnInit, inject } from '@angular/core';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminCoreMaestrosApiService } from '../../services/admin-core-maestros-api.service';
import { EmpresaAdminDto } from '../../models/admin.models';
import { SucursalCatalogoDto } from '../../models/admin-core-maestros.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';
import { AdminTablaPageBase } from '../../shared/admin-tabla-page-base';

/**
 * Sucursales: acordeón agrupado por empresa (mismo patrón que "Movimientos
 * por almacén" del ERP) — al expandir una empresa se cargan bajo demanda
 * sus sucursales y se muestran con app-erp-data-table (mismo look que el
 * resto de admin: orden por columna, exportar, etc).
 */
@Component({
  selector: 'app-admin-sucursales',
  templateUrl: './admin-sucursales.component.html',
  styleUrls: ['./admin-sucursales.component.scss'],
  standalone: false,
})
export class AdminSucursalesComponent extends AdminTablaPageBase<EmpresaAdminDto> implements OnInit {
  // Tabla propia (acordeón); solo se reusa la paginación de la base.
  columnasTabla: TablaColumna[] = [];
  protected get registrosTabla(): EmpresaAdminDto[] { return this.empresasFiltradas; }
  protected aFila(e: EmpresaAdminDto): Record<string, unknown> { return { id: e.id }; }

  private readonly apiSeguridad = inject(AdminSeguridadApiService);
  private readonly apiCore = inject(AdminCoreMaestrosApiService);

  empresas: EmpresaAdminDto[] = [];
  loadingEmpresas = true;
  filtroEmpresa = '';

  /** Empresas expandidas y sus sucursales, cargadas bajo demanda al expandir. */
  abiertos = new Set<number>();
  sucursalesPorEmpresa: Record<number, SucursalCatalogoDto[]> = {};
  loadingSucursalesPorEmpresa: Record<number, boolean> = {};

  readonly columnasSucursales: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'codigo', header: 'Código', width: '110px' },
    { key: 'nombre', header: 'Nombre', width: '200px' },
    { key: 'direccion', header: 'Dirección', width: '220px' },
    { key: 'ciudad', header: 'Ciudad', width: '130px' },
    { key: 'departamento', header: 'Departamento', width: '140px' },
  ];

  ngOnInit(): void {
    this.cargarEmpresas();
  }

  cargarEmpresas(): void {
    this.loadingEmpresas = true;
    this.apiSeguridad.listarEmpresas().subscribe({
      next: res => {
        this.loadingEmpresas = false;
        this.empresas = (res.data ?? []).filter(e => e.activo);
      },
      error: () => { this.loadingEmpresas = false; },
    });
  }

  get empresasFiltradas(): EmpresaAdminDto[] {
    if (!this.filtroEmpresa.trim()) return this.empresas;
    const q = this.filtroEmpresa.toLowerCase();
    return this.empresas.filter(e =>
      e.razonSocial?.toLowerCase().includes(q)
      || e.ruc?.toLowerCase().includes(q)
      || e.codigo?.toLowerCase().includes(q)
    );
  }

  toggle(empresa: EmpresaAdminDto): void {
    if (this.abiertos.has(empresa.id)) {
      this.abiertos.delete(empresa.id);
      return;
    }
    this.abiertos.add(empresa.id);
    if (!this.sucursalesPorEmpresa[empresa.id]) {
      this.cargarSucursales(empresa);
    }
  }

  estaAbierto(empresaId: number): boolean {
    return this.abiertos.has(empresaId);
  }

  cargarSucursales(empresa: EmpresaAdminDto): void {
    this.loadingSucursalesPorEmpresa[empresa.id] = true;
    this.apiCore.listarSucursalesEmpresa(empresa.id).subscribe({
      next: res => {
        this.loadingSucursalesPorEmpresa[empresa.id] = false;
        this.sucursalesPorEmpresa[empresa.id] = res.data ?? [];
      },
      error: () => { this.loadingSucursalesPorEmpresa[empresa.id] = false; },
    });
  }

  filasSucursalesDe(empresaId: number): Record<string, unknown>[] {
    return (this.sucursalesPorEmpresa[empresaId] ?? []).map(s => ({
      id: s.id, codigo: s.codigo || '—', nombre: s.nombre,
      direccion: s.direccion || '—', ciudad: s.ciudad || '—', departamento: s.departamento || '—',
    }));
  }
}
