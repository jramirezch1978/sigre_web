/**
 * Modelos de autenticación para comunicación con ms-auth-security.
 */

export interface LoginRequest {
  username: string;
  password: string;
}

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  tokenType: string;
  expiresIn: number;
  user: UserInfo;
}

export interface UserInfo {
  id: number;
  username: string;
  email: string;
  fullName: string;
  roles: string[];
  tenantId?: string;
  tenantName?: string;
}
