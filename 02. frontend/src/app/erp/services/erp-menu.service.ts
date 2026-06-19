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

export interface MenuOpcion {
  id: number;
  codigo: string;
  nombre: string;
  rutaFrontend: string | null;
  acciones: AccionDto[];
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

  private transformarAModulos(data: MiMenuResponse): MenuModulo[] {
    const padresPorModulo = new Map<number, OpcionMenuDto[]>();
    const hijosPorPadre = new Map<number, MiMenuItemDto[]>();
    const moduloNombres = new Map<number, string>();

    for (const item of data.items) {
      const om = item.opcionMenu;
      if (!om.activo) continue;
      if (om.opcionPadreId === null) {
        const arr = padresPorModulo.get(om.moduloId) ?? [];
        arr.push(om);
        padresPorModulo.set(om.moduloId, arr);
      } else {
        const arr = hijosPorPadre.get(om.opcionPadreId) ?? [];
        arr.push(item);
        hijosPorPadre.set(om.opcionPadreId, arr);
      }
    }

    for (const item of data.items) {
      const om = item.opcionMenu;
      if (!om.activo) continue;
      const codModulo = om.codigo.split('_')[0];
      if (!moduloNombres.has(om.moduloId)) {
        moduloNombres.set(om.moduloId, this.nombreModulo(codModulo));
      }
    }

    const modulos: MenuModulo[] = [];

    for (const [moduloId, padres] of padresPorModulo) {
      const primerCodigo = padres[0]?.codigo ?? '';
      const codModulo = primerCodigo.split('_').slice(0, -1).join('_')
        .replace(/_TABLAS|_OPERACIONES|_CONSULTAS|_REPORTES|_PROCESOS|_ADELANTOS|_TESORERIA|_CONCILIACIONES/g, '') || primerCodigo.split('_')[0];

      const secciones: MenuSeccion[] = padres
        .sort((a, b) => a.orden - b.orden)
        .map(padre => {
          const hijos = (hijosPorPadre.get(padre.id) ?? [])
            .sort((a, b) => a.opcionMenu.orden - b.opcionMenu.orden);
          return {
            id: padre.id,
            codigo: padre.codigo,
            nombre: padre.nombre,
            opciones: hijos.map(h => ({
              id: h.opcionMenu.id,
              codigo: h.opcionMenu.codigo,
              nombre: h.opcionMenu.nombre,
              rutaFrontend: this.resolverRutaFrontend(h.opcionMenu.codigo, h.opcionMenu.rutaFrontend),
              acciones: h.acciones,
            })),
          };
        });

      const codigoKey = codModulo || primerCodigo.split('_')[0];
      modulos.push({
        moduloId,
        codigo: codModulo,
        nombre: moduloNombres.get(moduloId) ?? 'Módulo',
        icono: ICONOS_MODULO[codigoKey] ?? 'apps',
        iconoSvg: iconoModulo(codigoKey),
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
