import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { forkJoin, of, catchError } from 'rxjs';
import { finalize } from 'rxjs/operators';
import { ChartData, ChartOptions } from 'chart.js';
import { StorageService } from '../../../core/services/storage.service';
import { JwtClaimsReaderService } from '../../services/jwt-claims-reader.service';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { AdminCoreMaestrosApiService } from '../../services/admin-core-maestros-api.service';
import { AuthService } from '../../../auth/services/auth.service';
import { ApiResponse } from '../../../shared/models/api-response.model';
import {
  AdminDashboardTelemetry,
  SesionHistogramaItem,
  SesionesBloqueoDbItem,
  UsuariosPorEmpresaItem,
} from '../../models/admin.models';

export interface AdminDashboardKpis {
  usuariosPlataforma: number;
  usuariosEmpresa: number;
  rolesEmpresa: number;
  sucursalesEmpresa: number;
  modulosGlobales: number;
  opcionesMenuGlobales: number;
  accionesGlobales: number;
  empresasEnPerfil: number;
  tieneContextoEmpresa: boolean;
}

interface QuickAccessItem {
  label: string;
  icon: string;
  route: string;
  description: string;
}

const CHART_COLORS = [
  '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6',
  '#EC4899', '#06B6D4', '#84CC16', '#64748B', '#F97316',
];

@Component({
  selector: 'app-admin-dashboard',
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.scss'],
  standalone: false,
})
export class AdminDashboardComponent implements OnInit {

  private readonly route = inject(ActivatedRoute);
  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);
  private readonly claimsReader = inject(JwtClaimsReaderService);
  private readonly seguridadApi = inject(AdminSeguridadApiService);
  private readonly coreApi = inject(AdminCoreMaestrosApiService);
  private readonly authService = inject(AuthService);

  avisoClave: string | null = null;
  tokenTemporal = false;

  telemetry: AdminDashboardTelemetry | null = null;
  kpis: AdminDashboardKpis | null = null;
  resumenLoading = true;
  telemetryError: string | null = null;
  kpisError: string | null = null;

  donutChartData: ChartData<'doughnut'> = { labels: [], datasets: [{ data: [], backgroundColor: [] }] };
  donutChartOptions: ChartOptions<'doughnut'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { position: 'bottom', labels: { padding: 14, usePointStyle: true, pointStyle: 'circle' } },
    },
  };

  barChartData: ChartData<'bar'> = { labels: [], datasets: [] };
  barChartOptions: ChartOptions<'bar'> = {
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      x: { stacked: true, grid: { display: false } },
      y: { stacked: true, beginAtZero: true },
    },
    plugins: {
      legend: { position: 'bottom', labels: { padding: 14, usePointStyle: true, pointStyle: 'circle' } },
    },
  };

  readonly menuItems: QuickAccessItem[] = [
    { label: 'Empresas', icon: 'business-outline', route: '/admin/empresas', description: 'Gestión y alta de empresas con BD tenant' },
    { label: 'Usuarios', icon: 'people-outline', route: '/admin/usuarios', description: 'Gestión de usuarios' },
    { label: 'Roles', icon: 'key-outline', route: '/admin/roles', description: 'Roles de la empresa' },
    { label: 'Módulos', icon: 'grid-outline', route: '/admin/modulos', description: 'Catálogo global de módulos' },
    { label: 'Opciones de menú', icon: 'list-outline', route: '/admin/opciones-menu', description: 'Ítems de menú por módulo' },
    { label: 'Acciones', icon: 'flash-outline', route: '/admin/acciones', description: 'Catálogo de acciones' },
    { label: 'Roles por usuario', icon: 'person-add-outline', route: '/admin/roles-usuario', description: 'Asignar roles a usuarios' },
    { label: 'Acciones por rol', icon: 'shield-checkmark-outline', route: '/admin/asignar-acciones-rol', description: 'Permisos por rol' },
    { label: 'Sucursales', icon: 'storefront-outline', route: '/admin/sucursales', description: 'Sucursales de empresa' },
    { label: 'Usuarios x Sucursal', icon: 'git-network-outline', route: '/admin/usuarios-sucursales', description: 'Asignar usuarios a sucursales' },
  ];

  /** Pares para layout tipo dashboard ERP (2 botones por fila). */
  get menuItemPairs(): QuickAccessItem[][] {
    const pairs: QuickAccessItem[][] = [];
    for (let i = 0; i < this.menuItems.length; i += 2) {
      pairs.push(this.menuItems.slice(i, i + 2));
    }
    return pairs;
  }

  lockBarChartData: ChartData<'bar'> = { labels: [], datasets: [] };
  lockBarChartOptions: ChartOptions<'bar'> = {
    indexAxis: 'y',
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      x: { stacked: true, beginAtZero: true, grid: { display: false } },
      y: { stacked: true },
    },
    plugins: {
      legend: { position: 'bottom', labels: { padding: 14, usePointStyle: true, pointStyle: 'circle' } },
    },
  };

  ngOnInit(): void {
    const syncAviso = (p: ParamMap) => {
      this.avisoClave = p.get('aviso');
    };
    syncAviso(this.route.snapshot.queryParamMap);
    this.route.queryParamMap.subscribe(syncAviso);

    const token = this.storage.getToken();
    if (token) {
      this.tokenTemporal = this.claimsReader.isTemporal(token);
    }

    this.cargarDashboard();
  }

  limpiarAviso(): void {
    this.avisoClave = null;
    void this.router.navigate([], {
      relativeTo: this.route,
      queryParams: { aviso: null },
      queryParamsHandling: 'merge',
    });
  }

  recargarKpis(): void {
    this.cargarDashboard();
  }

  trackBloqueoRow(_i: number, row: SesionesBloqueoDbItem): string {
    return `${row.alcance}-${row.empresaId ?? 0}-${row.etiqueta}`;
  }

  private cargarDashboard(): void {
    this.resumenLoading = true;
    this.telemetryError = null;
    this.kpisError = null;

    const token = this.storage.getToken();
    const empresaIdRaw = token ? this.claimsReader.getEmpresaId(token) : null;
    const empresaId = empresaIdRaw != null && empresaIdRaw > 0 ? empresaIdRaw : 0;

    const vacio = <T,>(data?: T[]): ApiResponse<T[]> => ({ success: true, message: '', data: data ?? [] });
    const telemetryFallback: ApiResponse<AdminDashboardTelemetry> = { success: false, message: 'El endpoint de telemetría no respondió. Despliegue ms-auth-security.', data: undefined as unknown as AdminDashboardTelemetry };

    forkJoin({
      telemetry: this.seguridadApi.getDashboardTelemetry().pipe(catchError(() => of(telemetryFallback))),
      modulos: this.seguridadApi.listarModulos().pipe(catchError(() => of(vacio<never>()))),
      opcionesMenu: this.seguridadApi.listarOpcionesMenu().pipe(catchError(() => of(vacio<never>()))),
      acciones: this.seguridadApi.listarAcciones().pipe(catchError(() => of(vacio<never>()))),
      usuariosPlataforma: this.seguridadApi.listarUsuarios().pipe(catchError(() => of(vacio<never>()))),
      empresasUsuario: this.authService.listarEmpresas().pipe(catchError(() => of(vacio<never>()))),
      rolesEmpresa:
        empresaId > 0
          ? this.seguridadApi.listarRoles(empresaId).pipe(catchError(() => of(vacio<never>())))
          : of(vacio([])),
      usuariosEmpresa:
        empresaId > 0
          ? this.seguridadApi.listarUsuariosDeEmpresa(empresaId).pipe(catchError(() => of(vacio<never>())))
          : of(vacio([])),
      sucursalesEmpresa:
        empresaId > 0
          ? this.coreApi.listarSucursalesEmpresa(empresaId).pipe(catchError(() => of(vacio<never>())))
          : of(vacio([])),
    })
      .pipe(finalize(() => (this.resumenLoading = false)))
      .subscribe({
        next: (r) => {
          if (!r.telemetry.success || !r.telemetry.data) {
            this.telemetryError = r.telemetry.message ?? 'No se pudo cargar la telemetría.';
            this.telemetry = null;
          } else {
            this.telemetry = r.telemetry.data;
            this.construirGraficos(this.telemetry);
          }

          this.construirKpis(r, empresaId);
        },
        error: () => {
          this.telemetryError = 'Error de red al cargar el panel.';
          this.kpisError = 'Error de red al cargar los conteos.';
          this.telemetry = null;
          this.kpis = null;
        },
      });
  }

  private construirKpis(r: Record<string, ApiResponse<unknown>>, empresaId: number): void {
    const rr = r as Record<string, ApiResponse<{ activo?: boolean }[]>>;
    if (!rr['modulos']?.data || !rr['acciones']?.data || !rr['usuariosPlataforma']?.data) {
      this.kpis = null;
      return;
    }

    const ctxEmpresaOk =
      empresaId > 0 &&
      !!rr['rolesEmpresa']?.data &&
      !!rr['usuariosEmpresa']?.data &&
      !!rr['sucursalesEmpresa']?.data;

    this.kpis = {
      usuariosPlataforma: this.cuentaActivos(rr['usuariosPlataforma'].data),
      usuariosEmpresa: ctxEmpresaOk ? this.cuentaActivos(rr['usuariosEmpresa'].data) : 0,
      rolesEmpresa: ctxEmpresaOk ? this.cuentaActivos(rr['rolesEmpresa'].data) : 0,
      sucursalesEmpresa: ctxEmpresaOk ? (rr['sucursalesEmpresa'].data ?? []).length : 0,
      modulosGlobales: this.cuentaActivos(rr['modulos'].data),
      opcionesMenuGlobales: this.cuentaActivos(rr['opcionesMenu']?.data),
      accionesGlobales: this.cuentaActivos(rr['acciones'].data),
      empresasEnPerfil: (rr['empresasUsuario']?.data ?? []).length,
      tieneContextoEmpresa: ctxEmpresaOk,
    };
  }

  private construirGraficos(t: AdminDashboardTelemetry): void {
    this.construirDonutUsuariosPorEmpresa(t.usuariosPorEmpresa ?? []);
    this.construirHistogramaSesiones(t.histogramaSesionesPorEmpresa ?? []);
    this.construirGraficoSesionesBdBloqueo(t.sesionesBloqueoPorBaseDatos ?? []);
  }

  private construirDonutUsuariosPorEmpresa(items: UsuariosPorEmpresaItem[]): void {
    if (!items.length) {
      this.donutChartData = { labels: ['Sin datos'], datasets: [{ data: [1], backgroundColor: ['#E2E8F0'] }] };
      return;
    }
    const labels = items.map((x) => this.acortarEtiqueta(x.razonSocial, 28));
    const data = items.map((x) => x.usuarios);
    const colors = items.map((_, i) => CHART_COLORS[i % CHART_COLORS.length]);
    this.donutChartData = {
      labels,
      datasets: [{ data, backgroundColor: colors, borderWidth: 1, borderColor: '#fff' }],
    };
  }

  private construirHistogramaSesiones(rows: SesionHistogramaItem[]): void {
    if (!rows.length) {
      this.barChartData = { labels: [], datasets: [] };
      return;
    }

    const totPorEmpresa = new Map<number, number>();
    for (const r of rows) {
      totPorEmpresa.set(r.empresaId, (totPorEmpresa.get(r.empresaId) ?? 0) + r.sesiones);
    }
    const topEmpresaIds = [...totPorEmpresa.entries()]
      .sort((a, b) => b[1] - a[1])
      .slice(0, 10)
      .map(([id]) => id);

    const nombrePorEmpresa = new Map<number, string>();
    for (const r of rows) {
      if (!nombrePorEmpresa.has(r.empresaId)) {
        nombrePorEmpresa.set(r.empresaId, r.empresaNombre || `Empresa ${r.empresaId}`);
      }
    }

    const dias = [...new Set(rows.map((x) => x.dia))].sort();

    const datasets = topEmpresaIds.map((empId, idx) => {
      const label = this.acortarEtiqueta(nombrePorEmpresa.get(empId) ?? `ID ${empId}`, 24);
      const color = CHART_COLORS[idx % CHART_COLORS.length];
      const data = dias.map((dia) => {
        const found = rows.find((x) => x.dia === dia && x.empresaId === empId);
        return found ? found.sesiones : 0;
      });
      return {
        label,
        data,
        backgroundColor: color,
        stack: 's1',
      };
    });

    this.barChartData = {
      labels: dias,
      datasets,
    };
  }

  private construirGraficoSesionesBdBloqueo(items: SesionesBloqueoDbItem[]): void {
    if (!items.length) {
      this.lockBarChartData = { labels: [], datasets: [] };
      return;
    }
    const labels = items.map((row) =>
      this.acortarEtiqueta(
        row.alcance === 'SECURITY' ? `Seguridad · ${row.etiqueta}` : row.etiqueta,
        36,
      ),
    );
    this.lockBarChartData = {
      labels,
      datasets: [
        {
          label: 'Activas esperando lock',
          data: items.map((r) => r.sesionesEsperandoLock),
          backgroundColor: '#DC2626',
          stack: 'db',
        },
        {
          label: 'Activas sin espera lock',
          data: items.map((r) => r.sesionesActivasSinEsperaLock),
          backgroundColor: '#94A3B8',
          stack: 'db',
        },
      ],
    };
  }

  private acortarEtiqueta(s: string, max: number): string {
    const t = (s ?? '').trim();
    if (t.length <= max) return t || '—';
    return `${t.slice(0, max - 1)}…`;
  }

  private cuentaActivos<T extends { activo?: boolean }>(lista: T[] | undefined): number {
    return (lista ?? []).filter((x) => x.activo !== false).length;
  }
}
