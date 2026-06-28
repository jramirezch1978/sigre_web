import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { ApiBaseService } from '../../services/api-base.service';
import { ALMACEN_TABLAS_POR_CODIGO, ALMACEN_OPCIONES_POR_CODIGO, ALMACEN_TABLAS_POR_RUTA, rutaFrontendPorCodigoOpcion } from '../modules/almacen/config/almacen-opciones-menu.config';
import { ALMACEN_VISTAS_POR_CODIGO, ALMACEN_VISTAS_POR_RUTA } from '../modules/almacen/config/almacen-vistas.config';
import { iconoModulo } from '../shared/modulos-iconos';
import { moduloDesdeCodigoOpcion, rutaDashboardModulo as buildRutaDashboardModulo } from '../shared/erp-modulos-rutas.config';
import { StorageService } from '../../core/services/storage.service';

export interface OpcionMenuDto {
  id: number;
  moduloId: number;
  codigo: string;
  nombre: string;
  rutaFrontend: string | null;
  /** Ruta RELATIVA del componente Angular a cargar. NULL => opción en construcción. */
  pathUrl: string | null;
  opcionPadreId: number | null;
  orden: number;
  activo: boolean;
}

export interface AccionDto {
  accionId: number;
  codigo: string;
  nombre: string;
  permitido: boolean;
}

export interface MiMenuItemDto {
  origen: 'ROL' | 'LIBRE';
  opcionMenu: OpcionMenuDto;
  acciones: AccionDto[];
}

export interface MiMenuResponse {
  empresaId: number;
  usuarioId: number;
  items: MiMenuItemDto[];
}

export interface MenuModulo {
  moduloId: number;
  codigo: string;
  nombre: string;
  icono: string;
  iconoSvg: string;
  secciones: MenuSeccion[];
}

export interface MenuSeccion {
  id: number;
  codigo: string;
  nombre: string;
  opciones: MenuOpcion[];
}

/** Nodo de menú recursivo: puede ser submenú (con hijos) u opción final (con pathUrl). */
export interface MenuOpcion {
  id: number;
  codigo: string;
  nombre: string;
  rutaFrontend: string | null;
  /** Ruta relativa del componente Angular; null => en construcción. */
  pathUrl: string | null;
  acciones: AccionDto[];
  /** Submenús/items hijos. Vacío => es una hoja navegable. */
  hijos: MenuOpcion[];
}

const ICONOS_MODULO: Record<string, string> = {
  ALMACEN: 'inventory_2',
  COMPRAS: 'shopping_cart',
  APROVISIONAMIENTO: 'local_shipping',
  COMERCIALIZACION: 'storefront',
  FINANZAS: 'account_balance_wallet',
  CONTABILIDAD: 'calculate',
  ACTIVOS_FIJOS: 'domain',
  RRHH: 'groups',
  PRODUCCION: 'precision_manufacturing',
  PRESUPUESTO: 'request_quote',
  FLOTA: 'local_shipping',
  MANTENIMIENTO: 'build',
  AUDITORIA: 'fact_check',
  CAMPO: 'grass',
  COMEDOR: 'restaurant',
  SIG: 'monitoring',
  OPERACIONES: 'hub',
  HORECA: 'hotel',
  SEGURIDAD: 'admin_panel_settings',
};

@Injectable({ providedIn: 'root' })
export class ErpMenuService {

  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);
  private readonly storage = inject(StorageService);

  obtenerMiMenu(): Observable<MenuModulo[]> {
    const url = `${this.apiBase.getApiBaseUrl()}/auth/seguridad/mi-menu`;
    const headers = new HttpHeaders({
      Authorization: `Bearer ${this.storage.getToken()}`,
    });
    return this.http.get<{ data: MiMenuResponse }>(url, { headers }).pipe(
      map(res => this.transformarAModulos(res.data))
    );
  }

  /** Prefijo del código de sección (1er token) → código de módulo del catálogo. */
  private static readonly PREFIJO_A_MODULO: Readonly<Record<string, string>> = {
    ALMACEN: 'ALMACEN', COMPRAS: 'COMPRAS', APROV: 'APROVISIONAMIENTO',
    COMERC: 'COMERCIALIZACION', FINANZAS: 'FINANZAS', CONTABILIDAD: 'CONTABILIDAD',
    ACTIVOS: 'ACTIVOS_FIJOS', RRHH: 'RRHH', PRODUCCION: 'PRODUCCION',
    PRESUP: 'PRESUPUESTO', FLOTA: 'FLOTA', MANT: 'MANTENIMIENTO', AUDIT: 'AUDITORIA',
    CAMPO: 'CAMPO', COMEDOR: 'COMEDOR', SIG: 'SIG', OPER: 'OPERACIONES',
    HORECA: 'HORECA', SEGURIDAD: 'SEGURIDAD',
  };

  private codigoModuloDesdeSeccion(codigoSeccion: string): string {
    const prefijo = (codigoSeccion ?? '').split('_')[0].toUpperCase();
    return ErpMenuService.PREFIJO_A_MODULO[prefijo] ?? prefijo;
  }

  private transformarAModulos(data: MiMenuResponse): MenuModulo[] {
    // Índice padre → hijos (raíz = null) para reconstruir el árbol de profundidad arbitraria.
    const hijosPorPadre = new Map<number | null, MiMenuItemDto[]>();
    for (const item of data.items) {
      if (!item.opcionMenu.activo) continue;
      const pid = item.opcionMenu.opcionPadreId ?? null;
      const arr = hijosPorPadre.get(pid) ?? [];
      arr.push(item);
      hijosPorPadre.set(pid, arr);
    }

    const construirHijos = (padreId: number): MenuOpcion[] =>
      (hijosPorPadre.get(padreId) ?? [])
        .sort((a, b) => (a.opcionMenu.orden ?? 0) - (b.opcionMenu.orden ?? 0))
        .map(h => ({
          id: h.opcionMenu.id,
          codigo: h.opcionMenu.codigo,
          nombre: h.opcionMenu.nombre,
          rutaFrontend: h.opcionMenu.rutaFrontend,
          pathUrl: h.opcionMenu.pathUrl ?? null,
          acciones: h.acciones,
          hijos: construirHijos(h.opcionMenu.id),
        }));

    const seccionesPorModulo = new Map<number, MenuSeccion[]>();
    const codigoModuloPorId = new Map<number, string>();

    const raices = (hijosPorPadre.get(null) ?? [])
      .sort((a, b) => (a.opcionMenu.orden ?? 0) - (b.opcionMenu.orden ?? 0));

    for (const sec of raices) {
      const om = sec.opcionMenu;
      const arr = seccionesPorModulo.get(om.moduloId) ?? [];
      arr.push({
        id: om.id,
        codigo: om.codigo,
        nombre: om.nombre,
        opciones: construirHijos(om.id),
      });
      seccionesPorModulo.set(om.moduloId, arr);
      if (!codigoModuloPorId.has(om.moduloId)) {
        codigoModuloPorId.set(om.moduloId, this.codigoModuloDesdeSeccion(om.codigo));
      }
    }

    const modulos: MenuModulo[] = [];
    for (const [moduloId, secciones] of seccionesPorModulo) {
      const codModulo = codigoModuloPorId.get(moduloId) ?? '';
      modulos.push({
        moduloId,
        codigo: codModulo,
        nombre: this.nombreModulo(codModulo),
        icono: ICONOS_MODULO[codModulo] ?? 'apps',
        iconoSvg: iconoModulo(codModulo),
        secciones,
      });
    }

    return modulos.sort((a, b) => a.moduloId - b.moduloId);
  }

  private nombreModulo(codigo: string): string {
    const nombres: Record<string, string> = {
      ALMACEN: 'Almacén',
      COMPRAS: 'Compras',
      APROVISIONAMIENTO: 'Aprovisionamiento',
      COMERCIALIZACION: 'Comercialización',
      VENTAS: 'Comercialización',
      FINANZAS: 'Finanzas',
      CONTABILIDAD: 'Contabilidad',
      ACTIVOS: 'Activos Fijos',
      ACTIVOS_FIJOS: 'Activos Fijos',
      RRHH: 'RR.HH.',
      PRODUCCION: 'Producción',
      PRESUPUESTO: 'Presupuesto',
      FLOTA: 'Flota',
      MANTENIMIENTO: 'Mantenimiento',
      AUDITORIA: 'Auditoría',
      CAMPO: 'Campo',
      COMEDOR: 'Comedor',
      SIG: 'SIG',
      OPERACIONES: 'Operaciones',
      HORECA: 'HORECA',
      SEGURIDAD: 'Configuración',
    };
    return nombres[codigo] ?? codigo;
  }

  /** Resuelve ruta web: catálogo FE → BD → normalización legacy → dashboard del módulo. */
  resolverRutaFrontend(codigo: string, rutaBd: string | null): string | null {
    const codigoUpper = (codigo ?? '').toUpperCase();

    const desdeCatalogo = ALMACEN_OPCIONES_POR_CODIGO[codigoUpper];
    if (desdeCatalogo) return desdeCatalogo;

    const vistaAlmacen = ALMACEN_VISTAS_POR_CODIGO[codigoUpper];
    if (vistaAlmacen) return vistaAlmacen.rutaFrontend;

    const desdeCodigo = this.normalizarRutaFrontend(rutaFrontendPorCodigoOpcion(codigoUpper));
    if (desdeCodigo) return desdeCodigo;

    const normalizada = this.normalizarRutaFrontend(rutaBd);
    if (normalizada) return normalizada;

    const modulo = moduloDesdeCodigoOpcion(codigoUpper);
    if (modulo) return buildRutaDashboardModulo(modulo);

    return null;
  }

  navegarOpcionDesdeMenu(codigo: string, ruta: string | null): string | null {
    return this.resolverRutaFrontend(codigo, ruta);
  }

  /** Ruta absoluta del componente a abrir desde el menú. pathUrl null/vacío => en construcción. */
  rutaDestinoPath(pathUrl: string | null): string {
    const limpio = (pathUrl ?? '').trim().replace(/^\/+/, '');
    return limpio ? `/sigre/${limpio}` : '/sigre/en-construccion';
  }

  /** Ruta del dashboard interno del módulo (al salir del grid principal). */
  rutaDashboardModulo(codigo: string): string {
    return buildRutaDashboardModulo(codigo);
  }

  /** Resuelve módulo activo a partir de la URL actual. */
  resolverModuloPorUrl(url: string, modulos: MenuModulo[]): MenuModulo | null {
    if (url.includes('/almacen')) {
      return modulos.find(m => m.codigo === 'ALMACEN') ?? null;
    }
    const match = url.match(/\/sigre\/m\/([^/?#]+)/i);
    if (match) {
      const slug = match[1].toUpperCase();
      return modulos.find(m => m.codigo.toUpperCase() === slug) ?? null;
    }
    return null;
  }

  /** Convierte rutas legacy RestPE (/almacen/...) a rutas SIGRE (/sigre/almacen/...). */
  normalizarRutaFrontend(ruta: string | null): string | null {
    if (!ruta) return null;
    const trimmed = ruta.trim();
    if (!trimmed || trimmed === '/') return null;

    const alias = this.aliasRutasAlmacen();
    if (alias[trimmed]) return alias[trimmed];

    const canon = ALMACEN_TABLAS_POR_CODIGO[trimmed];
    if (canon) return canon.rutaFrontend;

    const vistaCanon = ALMACEN_VISTAS_POR_RUTA[trimmed];
    if (vistaCanon) return vistaCanon.rutaFrontend;

    const tablaCanon = ALMACEN_TABLAS_POR_RUTA[trimmed];
    if (tablaCanon) return tablaCanon.rutaFrontend;

    const conSigre = trimmed.startsWith('/sigre/almacen/') ? trimmed : `/sigre/almacen/${trimmed.replace(/^\//, '')}`;
    if (ALMACEN_VISTAS_POR_RUTA[conSigre]) return conSigre;

    if (trimmed.startsWith('/sigre/almacen/')) return trimmed;
    if (trimmed.startsWith('/almacen/')) return `/sigre${trimmed}`;

    return trimmed.startsWith('/') ? trimmed : `/${trimmed}`;
  }

  private aliasRutasAlmacen(): Readonly<Record<string, string>> {
    return {
      '/almacen/tablas/tablas-almacenes': '/sigre/almacen/tablas/almacenes',
      '/almacen/tablas/almacenes-movimiento': '/sigre/almacen/tablas/movimientos-almacen',
      '/almacen/tablas/tipos-movimiento': '/sigre/almacen/tablas/tipos-movimiento',
      '/sigre/almacen/tablas/tablas-almacenes': '/sigre/almacen/tablas/almacenes',
      '/sigre/almacen/tablas/almacenes-movimiento': '/sigre/almacen/tablas/movimientos-almacen',
    };
  }
}
