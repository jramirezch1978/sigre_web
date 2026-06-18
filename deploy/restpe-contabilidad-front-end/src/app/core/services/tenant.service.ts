import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

const TENANT_KEY = 'rpe_tenant_id';

/**
 * Servicio de gestión del tenant (empresa/razón social) activo.
 * El tenant se envía como header X-Tenant-ID a través del interceptor.
 */
@Injectable({ providedIn: 'root' })
export class TenantService {
  private readonly tenantSubject = new BehaviorSubject<string | null>(
    localStorage.getItem(TENANT_KEY)
  );

  readonly currentTenant$: Observable<string | null> = this.tenantSubject.asObservable();

  getCurrentTenantId(): string | null {
    return this.tenantSubject.getValue();
  }

  setTenant(tenantId: string): void {
    localStorage.setItem(TENANT_KEY, tenantId);
    this.tenantSubject.next(tenantId);
  }

  clearTenant(): void {
    localStorage.removeItem(TENANT_KEY);
    this.tenantSubject.next(null);
  }
}
