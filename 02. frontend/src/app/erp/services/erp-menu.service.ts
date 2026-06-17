import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { ApiBaseService } from '../../services/api-base.service';
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
  VENTAS: 'point_of_sale',
  FINANZAS: 'account_balance_wallet',
  CONTABILIDAD: 'calculate',
  ACTIVOS_FIJOS: 'domain',
  RRHH: 'groups',
  PRODUCCION: 'precision_manufacturing',
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
              rutaFrontend: h.opcionMenu.rutaFrontend,
              acciones: h.acciones,
            })),
          };
        });

      modulos.push({
        moduloId,
        codigo: codModulo,
        nombre: moduloNombres.get(moduloId) ?? 'Módulo',
        icono: ICONOS_MODULO[codModulo] ?? ICONOS_MODULO[primerCodigo.split('_')[0]] ?? 'apps',
        secciones,
      });
    }

    return modulos.sort((a, b) => a.moduloId - b.moduloId);
  }

  private nombreModulo(codigo: string): string {
    const nombres: Record<string, string> = {
      ALMACEN: 'Almacén',
      COMPRAS: 'Compras',
      VENTAS: 'Ventas',
      FINANZAS: 'Finanzas',
      CONTABILIDAD: 'Contabilidad',
      ACTIVOS: 'Activos Fijos',
      ACTIVOS_FIJOS: 'Activos Fijos',
      RRHH: 'RR.HH.',
      PRODUCCION: 'Producción',
      SEGURIDAD: 'Configuración',
    };
    return nombres[codigo] ?? codigo;
  }
}
