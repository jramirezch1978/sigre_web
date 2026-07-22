/**
 * Fuente única de las opciones de la consola de administración.
 * El sidebar (AdminShellComponent) y los accesos rápidos del dashboard
 * (AdminDashboardComponent) consumen este mismo arreglo, evitando listas
 * duplicadas que se desincronizan entre sí.
 */
export interface AdminMenuItem {
  label: string;
  route: string;
  description: string;
  /** Nombre de ligature para <i class="material-icons-outlined"> (sidebar). */
  iconMaterial: string;
  /** Nombre para <ion-icon name="..."> (accesos rápidos del dashboard). */
  iconIon: string;
  /** Si se define, la opción solo se muestra para estos tipoSales. */
  soloTipoSales?: Array<'LICENSING' | 'SALES'>;
}

export const ADMIN_MENU_ITEMS: AdminMenuItem[] = [
  { label: 'Inicio', route: '/admin/inicio', description: 'Panel principal', iconMaterial: 'dashboard', iconIon: 'grid-outline' },
  { label: 'Empresas', route: '/admin/empresas', description: 'Gestión y alta de empresas con BD tenant', iconMaterial: 'business', iconIon: 'business-outline' },
  { label: 'Usuarios', route: '/admin/usuarios', description: 'Gestión de usuarios', iconMaterial: 'group', iconIon: 'people-outline' },
  { label: 'Roles', route: '/admin/roles', description: 'Roles de la empresa', iconMaterial: 'vpn_key', iconIon: 'key-outline' },
  { label: 'Módulos', route: '/admin/modulos', description: 'Catálogo global de módulos', iconMaterial: 'grid_view', iconIon: 'grid-outline' },
  { label: 'Ediciones', route: '/admin/ediciones', description: 'Ediciones del ERP', iconMaterial: 'layers', iconIon: 'layers-outline' },
  { label: 'Opciones de menú', route: '/admin/opciones-menu', description: 'Ítems de menú por módulo', iconMaterial: 'list', iconIon: 'list-outline' },
  { label: 'Acciones', route: '/admin/acciones', description: 'Catálogo de acciones', iconMaterial: 'bolt', iconIon: 'flash-outline' },
  { label: 'Roles x Usuario', route: '/admin/roles-usuario', description: 'Asignar roles a usuarios', iconMaterial: 'person_add', iconIon: 'person-add-outline' },
  { label: 'Acciones por rol', route: '/admin/asignar-acciones-rol', description: 'Permisos por rol', iconMaterial: 'verified_user', iconIon: 'shield-checkmark-outline' },
  { label: 'Grupos de usuario', route: '/admin/grupos-usuario', description: 'Grupos de usuario', iconMaterial: 'groups', iconIon: 'people-circle-outline' },
  { label: 'Sucursales', route: '/admin/sucursales', description: 'Sucursales de empresa', iconMaterial: 'storefront', iconIon: 'storefront-outline' },
  { label: 'Usuarios x Sucursal', route: '/admin/usuarios-sucursales', description: 'Asignar usuarios a sucursales', iconMaterial: 'account_tree', iconIon: 'git-network-outline' },
  { label: 'Dispositivos', route: '/admin/dispositivos', description: 'Dispositivos móviles registrados (Hermes)', iconMaterial: 'devices', iconIon: 'hardware-chip-outline' },
  { label: 'Versiones', route: '/admin/versiones', description: 'Versiones desplegadas', iconMaterial: 'info', iconIon: 'information-circle-outline' },
  { label: 'Licencias', route: '/admin/licencias', description: 'Licencias de empresas', iconMaterial: 'workspace_premium', iconIon: 'ribbon-outline', soloTipoSales: ['LICENSING', 'SALES'] },
];
