// ============================================================================
// Barrel exports — Core module
// Servicios singleton, guards, interceptors, modelos globales e infraestructura.
// Importar desde: import { ... } from '@core';
// ============================================================================

// ── Services ───────────────────────────────────────────────────────────────
export { StorageService } from './services/storage.service';
export { TenantService } from './services/tenant.service';
export { NotificationService } from './services/notification.service';

// ── Guards ─────────────────────────────────────────────────────────────────
export { authGuard } from './guards/auth.guard';
export { noAuthGuard } from './guards/no-auth.guard';

// ── Interceptors ───────────────────────────────────────────────────────────
export { jwtInterceptor } from './interceptors/jwt.interceptor';
export { tenantInterceptor } from './interceptors/tenant.interceptor';
export { errorInterceptor } from './interceptors/error.interceptor';

// ── Models ─────────────────────────────────────────────────────────────────
export * from './models/auth.model';
export * from './models/api-response.model';

// ── Utils ──────────────────────────────────────────────────────────────────
export * from './utils/api-response.util';

// ── Infrastructure (servicios transversales) ───────────────────────────────
export * from './infrastructure';
