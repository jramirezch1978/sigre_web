/**
 * Modelo genérico de respuesta del API backend.
 */
export interface ApiResponse<T = unknown> {
  success: boolean;
  message: string;
  data: T;
  timestamp: string;
  error?: string;
  statusCode?: number;
}

/**
 * Modelo de respuesta paginada.
 */
export interface PageResponse<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  page: number;
  size: number;
  first: boolean;
  last: boolean;
}

/**
 * Modelo de error del API.
 */
export interface ApiError {
  status: number;
  error: string;
  message: string;
  path: string;
  timestamp: string;
  details?: Record<string, string>;
}
