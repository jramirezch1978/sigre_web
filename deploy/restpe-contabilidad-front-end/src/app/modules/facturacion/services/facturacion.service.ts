import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { Comprobante, ComprobanteFilter } from '../models/facturacion.model';

@Injectable({ providedIn: 'root' })
export class FacturacionService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiBaseUrl}/facturacion`;

  getComprobantes(filter: ComprobanteFilter): Observable<Comprobante[]> {
    let params = new HttpParams()
      .set('page', filter.page)
      .set('size', filter.size);
    if (filter.tipo) params = params.set('tipo', filter.tipo);
    if (filter.estadoSunat) params = params.set('estadoSunat', filter.estadoSunat);
    if (filter.fechaDesde) params = params.set('fechaDesde', filter.fechaDesde);
    if (filter.fechaHasta) params = params.set('fechaHasta', filter.fechaHasta);

    return this.http.get<Comprobante[]>(`${this.baseUrl}/comprobantes`, { params });
  }

  getComprobante(id: number): Observable<Comprobante> {
    return this.http.get<Comprobante>(`${this.baseUrl}/comprobantes/${id}`);
  }

  emitirComprobante(comprobante: Partial<Comprobante>): Observable<Comprobante> {
    return this.http.post<Comprobante>(`${this.baseUrl}/comprobantes`, comprobante);
  }

  anularComprobante(id: number): Observable<Comprobante> {
    return this.http.put<Comprobante>(`${this.baseUrl}/comprobantes/${id}/anular`, {});
  }

  consultarEstadoSunat(id: number): Observable<Comprobante> {
    return this.http.get<Comprobante>(`${this.baseUrl}/comprobantes/${id}/estado-sunat`);
  }
}
