import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

/** Cuerpo de creación/actualización de cuenta bancaria (ms-finanzas). */
export interface CuentaBancariaRequest {
  codigo: string;
  planContableDetId: number;
  bancoId: number;
  tipoCtaBco?: string;
  descripcion?: string;
  correlativoCheque?: number;
  monedaId?: number;
  saldoContable: number;
  nroCci?: string;
  nroCuenta?: string;
  sucursalId?: number | null;
}

export interface Opcion { id: number; nombre: string; }

interface ApiResp<T> { success: boolean; message?: string; errorCode?: string; data: T; }
interface PageData<T> { content: T[]; }

/**
 * Escritura de Cuentas bancarias (ms-finanzas, `/api/finanzas/cuentas-bancarias`)
 * + catálogos reales para el formulario: bancos (ms-finanzas), monedas (core) y
 * plan contable detalle (ms-contabilidad). Token/tenant los ponen los interceptores.
 */
@Injectable({ providedIn: 'root' })
export class CuentaBancariaService {

  private readonly http = inject(HttpClient);
  private readonly base = environment.apiBaseUrl;

  crear(body: CuentaBancariaRequest): Observable<any> {
    return this.http.post<ApiResp<any>>(`${this.base}/finanzas/cuentas-bancarias`, body).pipe(map((r) => this.unwrap(r)));
  }

  actualizar(id: number, body: CuentaBancariaRequest): Observable<any> {
    return this.http.put<ApiResp<any>>(`${this.base}/finanzas/cuentas-bancarias/${id}`, body).pipe(map((r) => this.unwrap(r)));
  }

  eliminar(id: number): Observable<any> {
    return this.http.delete<ApiResp<any>>(`${this.base}/finanzas/cuentas-bancarias/${id}`).pipe(map((r) => this.unwrap(r)));
  }

  listarBancos(): Observable<Opcion[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.base}/finanzas/bancos?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((b: any) => ({ id: b.id, nombre: b.nomBanco ?? b.codBanco ?? '' }))));
  }

  listarMonedas(): Observable<Opcion[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.base}/core/monedas?size=100`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((m: any) => ({ id: m.id, nombre: m.nombre ?? m.codigo ?? '' }))));
  }

  /** Sucursales reales (ms-core-maestros, /api/core/sucursales) con id numérico para la FK. */
  listarSucursales(): Observable<Opcion[]> {
    return this.http.get<ApiResp<PageData<any>>>(`${this.base}/core/sucursales?size=1000`).pipe(
      map((r) => (this.unwrap(r)?.content ?? []).map((s: any) => ({
        id: s.id,
        nombre: `${s.codigo ?? ''} - ${s.nombre ?? ''}`.replace(/^ - | - $/, '').trim(),
      }))));
  }

  buscarPlanContable(q = ''): Observable<Opcion[]> {
    const url = `${this.base}/core/plan-contable-det?size=200` + (q ? `&q=${encodeURIComponent(q)}` : '');
    return this.http.get<ApiResp<any[]>>(url).pipe(
      map((r) => (this.unwrap(r) ?? []).map((p: any) => ({ id: p.id, nombre: `${p.cntaCtbl} - ${p.nombre ?? ''}` }))));
  }

  private unwrap<T>(r: ApiResp<T>): T {
    if (r && r.success === false) {
      throw new Error(r.message || r.errorCode || 'Error del servidor');
    }
    return r?.data as T;
  }
}
