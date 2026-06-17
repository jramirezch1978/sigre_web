import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiResponse } from '../../shared/models/api-response.model';
import { AbstractAuthenticatedApiService } from './abstract-authenticated-api.service';
import { UbigeoItem } from '../models/admin.models';

@Injectable({ providedIn: 'root' })
export class AdminUbigeoApiService extends AbstractAuthenticatedApiService {

  listarDepartamentos(): Observable<ApiResponse<UbigeoItem[]>> {
    return this.http.get<ApiResponse<UbigeoItem[]>>(
      this.buildUrl('/admin/ubigeo/departamentos'),
      { headers: this.bearerHeaders() }
    );
  }

  listarProvincias(departamentoId: number): Observable<ApiResponse<UbigeoItem[]>> {
    return this.http.get<ApiResponse<UbigeoItem[]>>(
      this.buildUrl(`/admin/ubigeo/provincias/${departamentoId}`),
      { headers: this.bearerHeaders() }
    );
  }

  listarDistritos(provinciaId: number): Observable<ApiResponse<UbigeoItem[]>> {
    return this.http.get<ApiResponse<UbigeoItem[]>>(
      this.buildUrl(`/admin/ubigeo/distritos/${provinciaId}`),
      { headers: this.bearerHeaders() }
    );
  }
}
