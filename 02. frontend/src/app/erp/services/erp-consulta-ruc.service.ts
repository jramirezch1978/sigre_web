import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ApiResponse } from '../../shared/models/api-response.model';

export interface ConsultaRucResult {
  ruc: string;
  razonSocial: string;
  nombreComercial: string;
  direccionFiscal: string;
  estado: string;
  condicion: string;
  ubigeo: string;
}

@Injectable({ providedIn: 'root' })
export class ErpConsultaRucService {
  private readonly http = inject(HttpClient);

  consultarRuc(ruc: string): Observable<ConsultaRucResult> {
    return this.http
      .get<ApiResponse<ConsultaRucResult>>(`${environment.apiUrl}/auth/seguridad/ruc/${ruc}`)
      .pipe(
        map((res) => {
          if (!res.success || !res.data) {
            throw new Error(res.message || 'No se pudo consultar el RUC');
          }
          return res.data;
        }),
      );
  }
}
