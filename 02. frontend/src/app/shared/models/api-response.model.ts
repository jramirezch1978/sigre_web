/**
 * Modelo genérico de respuesta de API
 */
export interface ApiResponse<T = any> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
  statusCode?: number;
  timestamp?: string;
}

/**
 * Modelo de respuesta con paginación
 */
export interface PaginatedApiResponse<T = any> extends ApiResponse<T> {
  pagination?: {
    page: number;
    pageSize: number;
    totalItems: number;
    totalPages: number;
  };
}
