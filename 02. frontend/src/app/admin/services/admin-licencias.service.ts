import { Injectable } from '@angular/core';
import { HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { ApiResponse } from '../../shared/models/api-response.model';
import { AbstractAuthenticatedApiService } from './abstract-authenticated-api.service';

export interface LicenciaAdminDto {
  id: number;
  empresa_id: number;
  razon_social: string;
  flag_demo: string;
  codigo_licencia: string;
  edicion_codigo: string;
  tipo: string;          // D=demo, P=pago
  estado: string;        // A/V
  fecha_inicio: string;
  fecha_vencimiento: string;
  correo_responsable: string | null;
  dias_restantes: number;
}

@Injectable({ providedIn: 'root' })
export class AdminLicenciasService extends AbstractAuthenticatedApiService {

  listar(): Observable<ApiResponse<LicenciaAdminDto[]>> {
    return this.http.get<ApiResponse<LicenciaAdminDto[]>>(
      this.buildUrl('/auth/seguridad/licencias/admin'),
      { headers: this.bearerHeaders() }
    );
  }

  /** Renueva (un mes) con fecha de pago (yyyy-MM-dd) y voucher del cliente. */
  renovar(empresaId: number, fechaPago: string, voucher: string): Observable<ApiResponse<unknown>> {
    const params = new HttpParams().set('fechaPago', fechaPago).set('voucher', voucher);
    return this.http.post<ApiResponse<unknown>>(
      this.buildUrl(`/auth/seguridad/licencias/admin/${empresaId}/renovar`),
      null, { headers: this.bearerHeaders(), params }
    );
  }

  /** Amplía el vencimiento de una demo (nuevaFecha en ISO). Solo LICENSING. */
  ampliarDemo(empresaId: number, nuevaFechaIso: string): Observable<ApiResponse<unknown>> {
    const params = new HttpParams().set('nuevaFecha', nuevaFechaIso);
    return this.http.post<ApiResponse<unknown>>(
      this.buildUrl(`/auth/seguridad/licencias/admin/${empresaId}/ampliar-demo`),
      null, { headers: this.bearerHeaders(), params }
    );
  }
}
