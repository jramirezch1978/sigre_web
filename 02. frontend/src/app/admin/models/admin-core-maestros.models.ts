/** Respuesta paginada de ms-core-maestros ({@code PageData}). */
export interface PageMeta {
  number: number;
  size: number;
  totalElements: number;
  totalPages: number;
}

export interface PageData<T> {
  content: T[];
  page: PageMeta;
}

/** {@code SucursalResponse} — CRUD /api/core/sucursales */
export interface SucursalCoreDto {
  id: number;
  codigo: string;
  nombre: string;
  direccion?: string | null;
  ciudad?: string | null;
  paisId?: number | null;
  departamentoId?: number | null;
  provinciaId?: number | null;
  distritoId?: number | null;
  ubigeo?: string | null;
  flagEstado: string;
}

/** Catálogo enriquecido ({@code SucursalDto}) desde /api/core/empresas/.../sucursales */
export interface SucursalCatalogoDto {
  id: number;
  codigo: string;
  nombre: string;
  direccion?: string | null;
  ciudad?: string | null;
  pais?: string | null;
  departamento?: string | null;
  provincia?: string | null;
  distrito?: string | null;
}

export interface UsuarioSucursalSyncResponse {
  usuarioId: number;
  username?: string;
  empresaId?: number;
  empresaCodigo?: string;
  sucursalId: number;
  flagEstado: string;
  mensaje: string;
}
