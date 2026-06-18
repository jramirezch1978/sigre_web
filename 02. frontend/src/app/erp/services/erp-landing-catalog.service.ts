import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { ApiBaseService } from '../../services/api-base.service';
import { ApiResponse } from '../../shared/models/api-response.model';

export interface ModuloCatalogoDto {
  id: number;
  codigo: string;
  nombre: string;
  activo: boolean;
}

export interface EdicionErpDto {
  id: number;
  codigo: string;
  nombre: string;
  descripcion: string;
  orden: number;
  activo: boolean;
  modulos: ModuloCatalogoDto[];
}

export interface PlanSuscripcionDto {
  id: number;
  codigo: string;
  nombre: string;
  precio: number;
  descripcion: string;
  edicionCodigo: string | null;
  color: string;
  destacado: boolean;
  diasDemo: number | null;
  maxUsuarios: number | null;
  orden: number;
  caracteristicas: string[];
  activo: boolean;
}

export interface LandingCatalogoDto {
  ediciones: EdicionErpDto[];
  planes: PlanSuscripcionDto[];
}

@Injectable({ providedIn: 'root' })
export class ErpLandingCatalogService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  obtenerCatalogo(): Observable<LandingCatalogoDto> {
    return this.http
      .get<ApiResponse<LandingCatalogoDto>>(`${this.apiBase.getApiBaseUrl()}/auth/seguridad/landing/catalogo`)
      .pipe(map(res => res.data ?? { ediciones: [], planes: [] }));
  }
}
