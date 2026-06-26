export interface ModuloDto {
  id: number;
  codigo: string;
  nombre: string;
  activo?: boolean;
}

export interface OpcionMenuDto {
  id: number;
  moduloId?: number;
  codigo?: string;
  nombre: string;
  rutaFrontend?: string;
  opcionPadreId?: number | null;
  orden?: number;
  activo?: boolean;
}

export interface AccionDto {
  id: number;
  codigo: string;
  nombre: string;
  activo?: boolean;
}

export interface RolDto {
  id: number;
  empresaId?: number;
  codigo: string;
  nombre: string;
  esAdmin?: boolean;
  activo?: boolean;
}

export interface RolUsuarioDto {
  id: number;
  usuarioId: number;
  rolId: number;
  rol?: RolDto;
  activo?: boolean;
}

export interface RolOpcionMenuDto {
  id: number;
  rolId: number;
  opcionMenuId: number;
  opcionMenu?: OpcionMenuDto;
  activo?: boolean;
}

export interface RolOpcionAccionDto {
  id: number;
  rolOpcionMenuId: number;
  accionId: number;
  accion?: AccionDto;
  permitido?: boolean;
  activo?: boolean;
}

export interface EdicionErpDto {
  id: number;
  codigo: string;
  nombre: string;
  descripcion?: string;
  orden?: number;
  activo?: boolean;
  modulos?: ModuloDto[];
}

export interface GrupoUsuarioDto {
  id: number;
  empresaId?: number;
  codigo: string;
  descripcion: string;
  activo?: boolean;
}

export interface GrupoUsuarioMiembroDto {
  id: number;
  grupoUsuarioId: number;
  usuarioId: number;
  nombreCompleto?: string;
  username?: string;
  email?: string;
  activo?: boolean;
}

export interface UsuarioAdminDto {
  id: number;
  email: string;
  username: string;
  nombres: string;
  apellidos: string;
  nombreCompleto: string;
  activo?: boolean;
  bloqueado?: boolean;
  flagAdminSistema?: boolean;
  fecCreacion?: string;
}

export interface EmpresaListDto {
  id: number;
  codigo: string;
  razonSocial: string;
  ruc: string;
  dbName: string;
}

export interface UbigeoItem {
  id: number;
  codigo: string;
  nombre: string;
}

export interface EmpresaAdminDto {
  id: number;
  codigo: string;
  ruc: string;
  razonSocial: string;
  nombreComercial?: string;
  direccionFiscal?: string;
  departamentoId?: number;
  departamentoNombre?: string;
  provinciaId?: number;
  provinciaNombre?: string;
  distritoId?: number;
  distritoNombre?: string;
  ubigeo?: string;
  representanteLegal?: string;
  dniRepresentanteLegal?: string;
  correoContacto?: string;
  telefonoContacto?: string;
  dbName: string;
  activo?: boolean;
}

/** Payload PUT /auth/seguridad/empresas/{id} */
export interface EmpresaAdminUpdatePayload {
  razonSocial: string;
  nombreComercial?: string;
  direccionFiscal?: string;
  distritoId?: number | null;
  representanteLegal?: string;
  dniRepresentanteLegal?: string;
  correoContacto?: string;
  telefonoContacto?: string;
}

export interface SucursalDto {
  id: number;
  codigo: string;
  nombre: string;
  direccion?: string;
  ciudad?: string;
}

/** Respuesta de GET /api/auth/seguridad/admin/dashboard-telemetry */
export interface AdminDashboardTelemetry {
  empresasBd: EmpresaTamanoItem[];
  totalUsuariosPlataforma: number;
  usuariosPorEmpresa: UsuariosPorEmpresaItem[];
  histogramaSesionesPorEmpresa: SesionHistogramaItem[];
  sesionesIncorrectasUltimos30Dias: number;
  usuariosBloqueadosPorSeguridad: number;
  /** Requiere ms-auth-security reciente. */
  usuariosBloqueadosPorIntentosLogin?: number;
  usuariosProximosDesbloqueoAutomatico?: number;
  latenciaPromedioMsUltimas24h: number | null;
  usuariosConectadosPorEmpresa: UsuariosConectadosItem[];
  sesionesBloqueoPorBaseDatos?: SesionesBloqueoDbItem[];
}

export interface SesionesBloqueoDbItem {
  alcance: string;
  empresaId?: number | null;
  etiqueta: string;
  sesionesEsperandoLock: number;
  sesionesActivasSinEsperaLock: number;
  errorMuestreo?: string | null;
}

export interface EmpresaTamanoItem {
  empresaId: number;
  codigo: string;
  razonSocial: string;
  dbName: string;
  tamanoMb: number;
}

export interface UsuariosPorEmpresaItem {
  empresaId: number;
  razonSocial: string;
  usuarios: number;
}

export interface SesionHistogramaItem {
  dia: string;
  empresaId: number;
  empresaNombre: string;
  sesiones: number;
}

export interface UsuariosConectadosItem {
  empresaId: number;
  razonSocial: string;
  usuariosConectados: number;
}
