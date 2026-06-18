import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import type { MovimientoCaja, CajaDiaria, CuentaBancaria } from '../models/caja.model';

@Injectable({ providedIn: 'root' })
export class CajaService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiBaseUrl}/caja`;

  getMovimientos(params?: { cajaId?: number; fechaDesde?: string; fechaHasta?: string }): Observable<MovimientoCaja[]> {
    let httpParams = new HttpParams();
    if (params?.cajaId) httpParams = httpParams.set('cajaId', params.cajaId);
    if (params?.fechaDesde) httpParams = httpParams.set('fechaDesde', params.fechaDesde);
    if (params?.fechaHasta) httpParams = httpParams.set('fechaHasta', params.fechaHasta);
    return this.http.get<MovimientoCaja[]>(`${this.baseUrl}/movimientos`, { params: httpParams });
  }

  registrarMovimiento(movimiento: Partial<MovimientoCaja>): Observable<MovimientoCaja> {
    return this.http.post<MovimientoCaja>(`${this.baseUrl}/movimientos`, movimiento);
  }

  getCajasDiarias(): Observable<CajaDiaria[]> {
    return this.http.get<CajaDiaria[]>(`${this.baseUrl}/cajas-diarias`);
  }

  abrirCaja(saldoInicial: number): Observable<CajaDiaria> {
    return this.http.post<CajaDiaria>(`${this.baseUrl}/abrir`, { saldoInicial });
  }

  cerrarCaja(id: number): Observable<CajaDiaria> {
    return this.http.post<CajaDiaria>(`${this.baseUrl}/cerrar/${id}`, {});
  }

  getCuentasBancarias(): Observable<CuentaBancaria[]> {
    return this.http.get<CuentaBancaria[]>(`${this.baseUrl}/cuentas-bancarias`);
  }
}
