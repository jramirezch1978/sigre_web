import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiResponse } from '../../shared/models/api-response.model';
import { AbstractAuthenticatedApiService } from './abstract-authenticated-api.service';
import {
  PageData,
  SucursalCatalogoDto,
  SucursalCoreDto,
  UsuarioSucursalSyncResponse,
} from '../models/admin-core-maestros.models';

@Injectable({ providedIn: 'root' })
export class AdminCoreMaestrosApiService extends AbstractAuthenticatedApiService {

  listarSucursalesPagina(page = 0, size = 100): Observable<ApiResponse<PageData<SucursalCoreDto>>> {
    return this.http.get<ApiResponse<PageData<SucursalCoreDto>>>(
      this.buildUrl(`/core/sucursales?page=${page}&size=${size}`),
      { headers: this.bearerHeaders() }
    );
  }

  obtenerSucursal(id: number): Observable<ApiResponse<SucursalCoreDto>> {
    return this.http.get<ApiResponse<SucursalCoreDto>>(
      this.buildUrl(`/core/sucursales/${id}`),
      { headers: this.bearerHeaders() }
    );
  }

  crearSucursal(body: Partial<SucursalCoreDto> & { nombre: string }): Observable<ApiResponse<SucursalCoreDto>> {
    return this.http.post<ApiResponse<SucursalCoreDto>>(
      this.buildUrl('/core/sucursales'),
      body,
      { headers: this.bearerHeaders() }
    );
  }

  actualizarSucursal(id: number, body: Partial<SucursalCoreDto> & { nombre: string }): Observable<ApiResponse<SucursalCoreDto>> {
    return this.http.put<ApiResponse<SucursalCoreDto>>(
      this.buildUrl(`/core/sucursales/${id}`),
      body,
      { headers: this.bearerHeaders() }
    );
  }

  activarSucursal(id: number): Observable<ApiResponse<SucursalCoreDto>> {
    return this.http.patch<ApiResponse<SucursalCoreDto>>(
      this.buildUrl(`/core/sucursales/${id}/activar`),
      null,
      { headers: this.bearerHeaders() }
    );
  }

  desactivarSucursal(id: number): Observable<ApiResponse<SucursalCoreDto>> {
    return this.http.patch<ApiResponse<SucursalCoreDto>>(
      this.buildUrl(`/core/sucursales/${id}/desactivar`),
      null,
      { headers: this.bearerHeaders() }
    );
  }

  /** Catálogo del tenant (admin JWT o provision secret en otros flujos). */
  listarSucursalesEmpresa(empresaId: number): Observable<ApiResponse<SucursalCatalogoDto[]>> {
    return this.http.get<ApiResponse<SucursalCatalogoDto[]>>(
      this.buildUrl(`/core/empresas/${empresaId}/sucursales`),
      { headers: this.bearerHeaders() }
    );
  }

  listarSucursalesAsignadasUsuario(empresaId: number, usuarioId: number): Observable<ApiResponse<SucursalCatalogoDto[]>> {
    return this.http.get<ApiResponse<SucursalCatalogoDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/usuarios/${usuarioId}/sucursales`),
      { headers: this.bearerHeaders() }
    );
  }

  asignarUsuarioSucursal(
    empresaId: number,
    usuarioId: number,
    sucursalId: number
  ): Observable<ApiResponse<UsuarioSucursalSyncResponse>> {
    return this.http.post<ApiResponse<UsuarioSucursalSyncResponse>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/usuarios/${usuarioId}/sucursales/${sucursalId}`),
      null,
      { headers: this.bearerHeaders() }
    );
  }

  retirarUsuarioSucursal(
    empresaId: number,
    usuarioId: number,
    sucursalId: number
  ): Observable<ApiResponse<UsuarioSucursalSyncResponse>> {
    return this.http.delete<ApiResponse<UsuarioSucursalSyncResponse>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/usuarios/${usuarioId}/sucursales/${sucursalId}`),
      { headers: this.bearerHeaders() }
    );
  }
}
