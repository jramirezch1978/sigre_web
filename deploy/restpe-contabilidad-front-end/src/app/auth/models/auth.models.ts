export interface SessionData {
  authToken: string;
  userId: number;
  username: string;
  email: string;
  nombreCompleto: string;
  empresaId?: number;
  empresaCodigo?: string;
  empresaNombre?: string;
  temporal: boolean;
  [key: string]: any;
}

export interface LoginCredentials {
  email: string;
  password: string;
  ipAddress: string;
  browser: string;
  sistemaOperativo: string;
  ipPrivada?: string;
}

export interface LoginResponse {
  success: boolean;
  data?: {
    accessToken: string;
    tokenType: string;
    expiresInSeconds: number;
    temporal: boolean;
    userId: number;
    email: string;
    username: string;
    nombres: string;
    apellidos: string;
    nombreCompleto: string;
    empresaId?: number;
    empresaCodigo?: string;
    empresaNombre?: string;
    adminSistema?: boolean;
  };
  message?: string;
  errorCode?: string;
}

export interface User {
  id: number;
  username: string;
  email: string;
  nombreCompleto: string;
}
