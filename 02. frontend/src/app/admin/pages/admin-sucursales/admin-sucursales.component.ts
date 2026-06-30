import { Component, OnInit, inject } from '@angular/core';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminCoreMaestrosApiService } from '../../services/admin-core-maestros-api.service';
import { EmpresaAdminDto } from '../../models/admin.models';
import { SucursalCatalogoDto } from '../../models/admin-core-maestros.models';
import { TablaColumna } from '../../../erp/shared/models/api-page.model';

@Component({
  selector: 'app-admin-sucursales',
  templateUrl: './admin-sucursales.component.html',
  styleUrls: ['./admin-sucursales.component.scss'],
  standalone: false,
})
export class AdminSucursalesComponent implements OnInit {

  private readonly apiSeguridad = inject(AdminSeguridadApiService);
  private readonly apiCore = inject(AdminCoreMaestrosApiService);

  empresas: EmpresaAdminDto[] = [];
  loadingEmpresas = true;
  filtroEmpresa = '';

  empresaSeleccionada: EmpresaAdminDto | null = null;
  sucursales: SucursalCatalogoDto[] = [];
  loadingSucursales = false;
  filtroSucursal = '';

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

  seleccionarEmpresa(e: EmpresaAdminDto): void {
    this.empresaSeleccionada = e;
    this.filtroSucursal = '';
    this.cargarSucursales();
  }

  volverAEmpresas(): void {
    this.empresaSeleccionada = null;
    this.sucursales = [];
    this.filtroSucursal = '';
  }

  cargarSucursales(): void {
    if (!this.empresaSeleccionada) return;
    this.loadingSucursales = true;
    this.apiCore.listarSucursalesEmpresa(this.empresaSeleccionada.id).subscribe({
      next: res => {
        this.loadingSucursales = false;
        this.sucursales = res.data ?? [];
      },
      error: () => { this.loadingSucursales = false; },
    });
  }

  get sucursalesFiltradas(): SucursalCatalogoDto[] {
    if (!this.filtroSucursal.trim()) return this.sucursales;
    const q = this.filtroSucursal.toLowerCase();
    return this.sucursales.filter(s =>
      s.nombre?.toLowerCase().includes(q)
      || s.codigo?.toLowerCase().includes(q)
      || s.ciudad?.toLowerCase().includes(q)
    );
  }

  readonly columnasSucursales: TablaColumna[] = [
    { key: 'id', header: 'ID', width: '70px' },
    { key: 'codigo', header: 'Código', width: '110px' },
    { key: 'nombre', header: 'Nombre', width: '200px' },
    { key: 'direccion', header: 'Dirección', width: '220px' },
    { key: 'ciudad', header: 'Ciudad', width: '130px' },
    { key: 'departamento', header: 'Departamento', width: '140px' },
  ];

  get filasSucursales(): Record<string, unknown>[] {
    return this.sucursalesFiltradas.map(s => ({
      id: s.id, codigo: s.codigo || '—', nombre: s.nombre,
      direccion: s.direccion || '—', ciudad: s.ciudad || '—', departamento: s.departamento || '—',
    }));
  }
}
