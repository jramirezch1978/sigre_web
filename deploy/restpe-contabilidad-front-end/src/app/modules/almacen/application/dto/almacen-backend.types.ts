/**
 * Tipos que reflejan los contratos reales de `ms-almacen` (Spring Boot).
 * Sirven para tipar las respuestas crudas del backend antes de mapearlas a las
 * entidades de dominio del front.
 */

/** Envoltura estándar `pe.restaurant.common.dto.ApiResponse<T>`. */
export interface BackendApiResponse<T> {
  success: boolean;
  message?: string;
  errorCode?: string;
  data?: T;
  timestamp?: string;
}

/** Metadatos de paginación (`PageMeta`). */
export interface BackendPageMeta {
  number: number;
  size: number;
  totalElements: number;
  totalPages: number;
}

/** Página `PageData<T>` del backend. */
export interface BackendPageData<T> {
  content: T[];
  page: BackendPageMeta;
}

/** Resumen de usuario embebido en campos de auditoría (`UsuarioResumenDto`). */
export interface BackendUsuarioResumen {
  id?: number;
  nombre?: string;
  username?: string;
}

/** `AlmacenResponse`. */
export interface BackendAlmacenResponse {
  id: number;
  sucursalId: number;
  sucursalNombre?: string;
  almacenTipoId?: number;
  almacenTipoNombre?: string;
  codigo: string;
  nombre: string;
  flagEstado: string;
  createdBy?: number;
  createdByUsuario?: BackendUsuarioResumen;
  fecCreacion?: string;
  updatedBy?: number;
  updatedByUsuario?: BackendUsuarioResumen;
  fecModificacion?: string;
}

/** `AlmacenRequest` (cuerpo de POST/PUT). */
export interface BackendAlmacenRequest {
  sucursalId: number;
  almacenTipoId?: number | null;
  codigo: string;
  nombre: string;
}

/** `ArticuloMovTipoResponse` (catálogo de tipos de movimiento). */
export interface BackendArticuloMovTipoResponse {
  id: number;
  tipoMov?: string;
  descTipoMov?: string;
  flagClaseMov?: string;
  flagEstado?: string;
}

/** `OrdenTrasladoResponse`. */
export interface BackendOrdenTrasladoResponse {
  id: number;
  almacenOrigenId?: number;
  almacenDestinoId?: number;
  numero?: string;
  fecha?: string;
  flagEstado?: string;
  observacion?: string;
  usuarioId?: number;
}

/** `StockArticuloAlmacenResponse`. */
export interface BackendStockResponse {
  id?: number;
  almacenId?: number;
  articuloId?: number;
  cantidadDisponible?: number;
  cantidadReservada?: number;
  cantidadTotal?: number;
  costoPromedio?: number;
  ultimaActualizacion?: string;
}

/** `KardexResponse` (kardex valorizado). */
export interface BackendKardexResponse {
  id?: number;
  almacenId?: number;
  articuloId?: number;
  articuloCodigo?: string;
  articuloNombre?: string;
  fecha?: string;
  tipo?: string;
  cantidad?: number;
  costoUnitario?: number;
  costoTotal?: number;
  saldoCantidad?: number;
  saldoCostoUnitario?: number;
  saldoCostoTotal?: number;
  valeMovDetId?: number;
}

/** `ValorizacionResponse`. */
export interface BackendValorizacionResponse {
  almacenId?: number;
  articuloId?: number;
  articuloCodigo?: string;
  articuloNombre?: string;
  cantidadDisponible?: number;
  costoPromedio?: number;
  valorTotal?: number;
  ultimaActualizacion?: string;
}

/** `LoteVencimientoResponse`. */
export interface BackendLoteVencimientoResponse {
  id?: number;
  almacenId?: number;
  articuloId?: number;
  articuloCodigo?: string;
  articuloNombre?: string;
  nroLote?: string;
  fechaProduccion?: string;
  fechaVencimiento?: string;
  diasParaVencer?: number;
  observacion?: string;
  flagEstado?: string;
}

/** `MovimientoListItemResponse`. */
export interface BackendMovimientoListItem {
  id?: number;
  sucursalId?: number;
  almacenId?: number;
  articuloMovTipoId?: number;
  nroVale?: string;
  tipoReferenciaOrigen?: string;
  ordenCompraId?: number;
  ordenVentaId?: number;
  fechaMov?: string;
  fecProduccion?: string;
  flagEstado?: string;
}

/** `InventarioConteoResponse`. */
export interface BackendInventarioConteoResponse {
  id?: number;
  almacenId?: number;
  articuloId?: number;
  fechaConteo?: string;
  nroConteo?: number;
  saldoSistema?: number;
  cantidadConteo1?: number;
  cantidadConteo2?: number;
  costoUnitario?: number;
  diferencia?: number;
  flagEstado?: string;
}

/** `StockAFechaResponse`. */
export interface BackendStockAFechaResponse {
  almacenId?: number;
  articuloId?: number;
  articuloCodigo?: string;
  articuloNombre?: string;
  fechaCorte?: string;
  ultimoMovimiento?: string;
  cantidad?: number;
  costoUnitario?: number;
  valorTotal?: number;
}

/** `DiagnosticoAlmacenResponse`. */
export interface BackendDiagnosticoResponse {
  almacenId?: number;
  almacenCodigo?: string;
  almacenNombre?: string;
  totalArticulos?: number;
  totalUnidades?: number;
  valorInventario?: number;
}

/** `PerdidaResponse`. */
export interface BackendPerdidaResponse {
  valeMovId?: number;
  valeMovDetId?: number;
  nroVale?: string;
  fecha?: string;
  almacenId?: number;
  articuloId?: number;
  articuloCodigo?: string;
  articuloNombre?: string;
  articuloMovTipoId?: number;
  tipoMov?: string;
  descTipoMov?: string;
  cantidadPerdida?: number;
  costoUnitario?: number;
  valorPerdida?: number;
  observacion?: string;
}

/** `ComparacionInventarioResponse`. */
export interface BackendComparacionInventarioResponse {
  id?: number;
  almacenId?: number;
  articuloId?: number;
  articuloCodigo?: string;
  articuloNombre?: string;
  fechaConteo?: string;
  saldoSistema?: number;
  cantidadConteo?: number;
  diferencia?: number;
  costoUnitario?: number;
  diferenciaValorizada?: number;
  flagEstado?: string;
}

/** `SolSalidaResponse`. */
export interface BackendSolSalidaResponse {
  id?: number;
  almacenId?: number;
  numero?: string;
  fecha?: string;
  solicitanteId?: number;
  flagEstado?: string;
  observacion?: string;
}
