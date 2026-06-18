// Configuración del sistema de autenticación
export const AUTH_CONFIG = {
  // URLs del API
  API_ENDPOINTS: {
    LOGIN: '/auth/login',
    LOGOUT: '/auth/logout',
    REFRESH: '/auth/refresh',
    PROFILE: '/auth/profile'
  },

  // Configuración de sesión
  SESSION: {
    STORAGE_KEY: 'session',
    TOKEN_KEY: 'authToken',
    EXPIRY_KEY: 'expiresAt'
  },

  // Rutas de redirección
  ROUTES: {
    LOGIN: '/auth/signin',
    HOME: '/home',
    DEFAULT_PROTECTED: '/configuracion'
  },

  // Configuración de seguridad
  SECURITY: {
    TOKEN_HEADER: 'Authorization',
    TOKEN_PREFIX: 'Bearer ',
    REFRESH_THRESHOLD: 5 * 60 * 1000, // 5 minutos antes de expirar
    MAX_RETRY_ATTEMPTS: 3
  },

  // Mensajes de usuario
  MESSAGES: {
    LOGIN_ERROR: 'Verifica los datos de acceso e intenta nuevamente.',
    SESSION_EXPIRED: 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.',
    UNAUTHORIZED: 'No tienes permisos para acceder a este recurso.',
    NETWORK_ERROR: 'Error de conexión. Verifica tu conexión a internet.'
  }
};

// Configuración del entorno
export const ENVIRONMENT_CONFIG = {
  DEVELOPMENT: {
    apiUrl: 'http://localhost:3000/api',
    enableDebugLogs: true,
    mockAuth: false
  },
  PRODUCTION: {
    apiUrl: 'https://api.restaurant.pe/api',
    enableDebugLogs: false,
    mockAuth: false
  }
};
