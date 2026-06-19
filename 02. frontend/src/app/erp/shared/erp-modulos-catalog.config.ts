import { MenuModulo } from '../services/erp-menu.service';
import { iconoModulo, MODULOS_ICONOS } from './modulos-iconos';

/** Catálogo fijo de módulos ERP visibles en dashboard y sidebar (18 módulos de negocio). */
export interface ModuloCatalogoDef {
  codigo: string;
  nombre: string;
  icono: string;
}

export const ERP_MODULOS_CATALOGO: readonly ModuloCatalogoDef[] = [
  { codigo: 'ALMACEN', nombre: 'Almacén', icono: 'inventory_2' },
  { codigo: 'COMPRAS', nombre: 'Compras', icono: 'shopping_cart' },
  { codigo: 'APROVISIONAMIENTO', nombre: 'Aprovisionamiento', icono: 'local_shipping' },
  { codigo: 'COMERCIALIZACION', nombre: 'Comercialización', icono: 'storefront' },
  { codigo: 'FINANZAS', nombre: 'Finanzas', icono: 'account_balance_wallet' },
  { codigo: 'CONTABILIDAD', nombre: 'Contabilidad', icono: 'calculate' },
  { codigo: 'ACTIVOS_FIJOS', nombre: 'Activos Fijos', icono: 'domain' },
  { codigo: 'RRHH', nombre: 'RR.HH.', icono: 'groups' },
  { codigo: 'PRODUCCION', nombre: 'Producción', icono: 'precision_manufacturing' },
  { codigo: 'PRESUPUESTO', nombre: 'Presupuesto', icono: 'request_quote' },
  { codigo: 'FLOTA', nombre: 'Flota', icono: 'local_shipping' },
  { codigo: 'MANTENIMIENTO', nombre: 'Mantenimiento', icono: 'build' },
  { codigo: 'AUDITORIA', nombre: 'Auditoría', icono: 'fact_check' },
  { codigo: 'CAMPO', nombre: 'Campo', icono: 'grass' },
  { codigo: 'COMEDOR', nombre: 'Comedor', icono: 'restaurant' },
  { codigo: 'SIG', nombre: 'SIG', icono: 'monitoring' },
  { codigo: 'OPERACIONES', nombre: 'Operaciones', icono: 'hub' },
  { codigo: 'HORECA', nombre: 'HORECA', icono: 'hotel' },
] as const;

/** Módulo de administración (menú de seguridad), aparte de los 18 de negocio. */
export const ERP_MODULO_SEGURIDAD: ModuloCatalogoDef = {
  codigo: 'SEGURIDAD',
  nombre: 'Configuración',
  icono: 'admin_panel_settings',
};

function idModuloSintetico(indice: number): number {
  return -(indice + 1);
}

function menuModuloSintetico(def: ModuloCatalogoDef, indice: number): MenuModulo {
  return {
    moduloId: idModuloSintetico(indice),
    codigo: def.codigo,
    nombre: def.nombre,
    icono: def.icono,
    iconoSvg: MODULOS_ICONOS[def.codigo] ?? iconoModulo(def.codigo),
    secciones: [],
  };
}

/**
 * Fusiona el menú del usuario (API / permisos) con el catálogo completo.
 * Así el sidebar y el dashboard muestran siempre todos los módulos;
 * las secciones/opciones solo aparecen donde el rol tiene permiso.
 */
export function fusionarModulosConCatalogo(
  modulosApi: MenuModulo[],
  incluirSeguridad = true
): MenuModulo[] {
  const mapa = new Map<string, MenuModulo>();
  for (const m of modulosApi) {
    mapa.set(m.codigo.toUpperCase(), m);
  }

  const resultado: MenuModulo[] = ERP_MODULOS_CATALOGO.map((def, i) => {
    const real = mapa.get(def.codigo);
    if (real) {
      return {
        ...real,
        nombre: real.nombre || def.nombre,
        iconoSvg: real.iconoSvg || iconoModulo(def.codigo),
      };
    }
    return menuModuloSintetico(def, i);
  });

  if (incluirSeguridad) {
    const seg = mapa.get('SEGURIDAD');
    resultado.push(
      seg ?? menuModuloSintetico(ERP_MODULO_SEGURIDAD, ERP_MODULOS_CATALOGO.length)
    );
  }

  return resultado;
}
