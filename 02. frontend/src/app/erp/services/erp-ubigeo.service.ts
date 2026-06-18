import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ApiResponse } from '../../shared/models/api-response.model';

export interface UbigeoItem {
  id: number;
  codigo: string;
  nombre: string;
}

export interface UbigeoLookup {
  ubigeo: string;
  departamentoId: number;
  departamentoNombre: string;
  provinciaId: number;
  provinciaNombre: string;
  distritoId: number;
  distritoNombre: string;
}

@Injectable({ providedIn: 'root' })
export class ErpUbigeoService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = `${environment.apiUrl}/auth/seguridad/ubigeo`;

  listarDepartamentos(): Observable<UbigeoItem[]> {
    return this.http
      .get<ApiResponse<UbigeoItem[]>>(`${this.baseUrl}/departamentos`)
      .pipe(map((res) => res.data ?? []));
  }

  listarProvincias(departamentoId: number): Observable<UbigeoItem[]> {
    return this.http
      .get<ApiResponse<UbigeoItem[]>>(`${this.baseUrl}/provincias/${departamentoId}`)
      .pipe(map((res) => res.data ?? []));
  }

  listarDistritos(provinciaId: number): Observable<UbigeoItem[]> {
    return this.http
      .get<ApiResponse<UbigeoItem[]>>(`${this.baseUrl}/distritos/${provinciaId}`)
      .pipe(map((res) => res.data ?? []));
  }

  obtenerPorCodigo(codigo: string): Observable<UbigeoLookup> {
    return this.http
      .get<ApiResponse<UbigeoLookup>>(`${this.baseUrl}/por-codigo/${codigo}`)
      .pipe(
        map((res) => {
          if (!res.success || !res.data) {
            throw new Error(res.message || 'No se pudo obtener el ubigeo');
          }
          return res.data;
        }),
      );
  }
}
