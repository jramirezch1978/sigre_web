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

export interface ApiResponse<T> {
  success: boolean;
  message?: string;
  errorCode?: string;
  data: T;
}

export interface TablaColumna {
  key: string;
  header: string;
  width?: string;
  format?: 'text' | 'estado' | 'fecha' | 'numero';
}

export interface TablaPageConfig {
  titulo: string;
  subtitulo?: string;
  endpoint: 'almacen' | 'core';
  path: string;
  params?: Record<string, string | number | boolean>;
  columnas: TablaColumna[];
  /** Si true, concatena todas las páginas en cliente (para agregados). */
  agregarPaginas?: boolean;
}
