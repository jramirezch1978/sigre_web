import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiResponse } from '../../shared/models/api-response.model';
import { AbstractAuthenticatedApiService } from './abstract-authenticated-api.service';
import {
  ModuloDto, OpcionMenuDto, AccionDto, RolDto,
  RolUsuarioDto, RolOpcionMenuDto, RolOpcionAccionDto,
  UsuarioAdminDto, AdminDashboardTelemetry, EmpresaAdminDto,
  EmpresaAdminUpdatePayload, GrupoUsuarioDto, GrupoUsuarioMiembroDto, EdicionErpDto
} from '../models/admin.models';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class AdminSeguridadApiService extends AbstractAuthenticatedApiService {

  // ── Panel admin: telemetría agregada (BD security) ──

  getDashboardTelemetry(): Observable<ApiResponse<AdminDashboardTelemetry>> {
    return this.http.get<ApiResponse<AdminDashboardTelemetry>>(
      this.buildUrl('/auth/seguridad/admin/dashboard-telemetry'),
      { headers: this.bearerHeaders() }
    );
  }

  // ── Empresas (acepta token temporal o definitivo) ──

  listarEmpresas(): Observable<ApiResponse<EmpresaAdminDto[]>> {
    return this.http.get<ApiResponse<EmpresaAdminDto[]>>(
      this.buildUrl('/auth/seguridad/empresas'),
      { headers: this.bearerHeaders() }
    );
  }

  actualizarEmpresa(id: number, body: EmpresaAdminUpdatePayload): Observable<ApiResponse<EmpresaAdminDto>> {
    return this.http.put<ApiResponse<EmpresaAdminDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${id}`),
      body,
      { headers: this.bearerHeaders() }
    );
  }

  cambiarEstadoEmpresa(id: number, activo: boolean): Observable<ApiResponse<EmpresaAdminDto>> {
    return this.http.patch<ApiResponse<EmpresaAdminDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${id}/estado`),
      { activo },
      { headers: this.bearerHeaders() }
    );
  }

  enviarCorreoBienvenida(id: number): Observable<ApiResponse<{ empresaId: number; codigo: string; razonSocial: string; correoContacto: string; mensaje: string }>> {
    return this.http.post<ApiResponse<{ empresaId: number; codigo: string; razonSocial: string; correoContacto: string; mensaje: string }>>(
      this.buildUrl(`/auth/seguridad/empresas/${id}/correo-bienvenida`),
      {},
      { headers: this.bearerHeaders() }
    );
  }

  listarModulos(): Observable<ApiResponse<ModuloDto[]>> {
    return this.http.get<ApiResponse<ModuloDto[]>>(
      this.buildUrl('/auth/seguridad/modulos'),
      { headers: this.bearerHeaders() }
    );
  }

  crearModulo(body: { codigo: string; nombre: string; activo?: boolean }): Observable<ApiResponse<ModuloDto>> {
    return this.http.post<ApiResponse<ModuloDto>>(
      this.buildUrl('/auth/seguridad/modulos'),
      body, { headers: this.bearerHeaders() }
    );
  }

  actualizarModulo(id: number, body: { codigo: string; nombre: string; activo?: boolean }): Observable<ApiResponse<ModuloDto>> {
    return this.http.put<ApiResponse<ModuloDto>>(
      this.buildUrl(`/auth/seguridad/modulos/${id}`),
      body, { headers: this.bearerHeaders() }
    );
  }

  // ── Opciones de menú ──

  listarOpcionesMenu(moduloId?: number): Observable<ApiResponse<OpcionMenuDto[]>> {
    const q = moduloId != null ? `?moduloId=${moduloId}` : '';
    return this.http.get<ApiResponse<OpcionMenuDto[]>>(
      this.buildUrl(`/auth/seguridad/opciones-menu${q}`),
      { headers: this.bearerHeaders() }
    );
  }

  crearOpcionMenu(body: Partial<OpcionMenuDto> & { moduloId: number; codigo: string; nombre: string }): Observable<ApiResponse<OpcionMenuDto>> {
    return this.http.post<ApiResponse<OpcionMenuDto>>(
      this.buildUrl('/auth/seguridad/opciones-menu'),
      body, { headers: this.bearerHeaders() }
    );
  }

  actualizarOpcionMenu(id: number, body: Partial<OpcionMenuDto>): Observable<ApiResponse<OpcionMenuDto>> {
    return this.http.put<ApiResponse<OpcionMenuDto>>(
      this.buildUrl(`/auth/seguridad/opciones-menu/${id}`),
      body, { headers: this.bearerHeaders() }
    );
  }

  // ── Acciones ──

  listarAcciones(): Observable<ApiResponse<AccionDto[]>> {
    return this.http.get<ApiResponse<AccionDto[]>>(
      this.buildUrl('/auth/seguridad/acciones'),
      { headers: this.bearerHeaders() }
    );
  }

  crearAccion(body: { codigo: string; nombre: string; activo?: boolean }): Observable<ApiResponse<AccionDto>> {
    return this.http.post<ApiResponse<AccionDto>>(
      this.buildUrl('/auth/seguridad/acciones'),
      body, { headers: this.bearerHeaders() }
    );
  }

  actualizarAccion(id: number, body: { codigo: string; nombre: string; activo?: boolean }): Observable<ApiResponse<AccionDto>> {
    return this.http.put<ApiResponse<AccionDto>>(
      this.buildUrl(`/auth/seguridad/acciones/${id}`),
      body, { headers: this.bearerHeaders() }
    );
  }

  // ── Roles por empresa ──

  listarRoles(empresaId: number): Observable<ApiResponse<RolDto[]>> {
    return this.http.get<ApiResponse<RolDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles`),
      { headers: this.bearerHeaders() }
    );
  }

  crearRol(empresaId: number, body: { codigo: string; nombre: string; esAdmin?: boolean; activo?: boolean }): Observable<ApiResponse<RolDto>> {
    return this.http.post<ApiResponse<RolDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles`),
      body, { headers: this.bearerHeaders() }
    );
  }

  actualizarRol(empresaId: number, rolId: number, body: { codigo: string; nombre: string; esAdmin?: boolean; activo?: boolean }): Observable<ApiResponse<RolDto>> {
    return this.http.put<ApiResponse<RolDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles/${rolId}`),
      body, { headers: this.bearerHeaders() }
    );
  }

  // ── Rol ↔ opciones de menú ──

  listarRolOpciones(empresaId: number, rolId: number): Observable<ApiResponse<RolOpcionMenuDto[]>> {
    return this.http.get<ApiResponse<RolOpcionMenuDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles/${rolId}/opciones-menu`),
      { headers: this.bearerHeaders() }
    );
  }

  asignarOpcionARol(empresaId: number, rolId: number, opcionMenuId: number, activo = true): Observable<ApiResponse<RolOpcionMenuDto>> {
    return this.http.post<ApiResponse<RolOpcionMenuDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles/${rolId}/opciones-menu/${opcionMenuId}?activo=${activo}`),
      null, { headers: this.bearerHeaders() }
    );
  }

  quitarOpcionDeRol(empresaId: number, rolId: number, opcionMenuId: number): Observable<ApiResponse<void>> {
    return this.http.delete<ApiResponse<void>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles/${rolId}/opciones-menu/${opcionMenuId}`),
      { headers: this.bearerHeaders() }
    );
  }

  // ── Acciones por rol-opción ──

  listarAccionesRolOpcion(empresaId: number, rolId: number, opcionMenuId: number): Observable<ApiResponse<RolOpcionAccionDto[]>> {
    return this.http.get<ApiResponse<RolOpcionAccionDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles/${rolId}/opciones-menu/${opcionMenuId}/acciones`),
      { headers: this.bearerHeaders() }
    );
  }

  upsertAccionRolOpcion(empresaId: number, rolId: number, opcionMenuId: number, accionId: number,
                         body: { permitido?: boolean; activo?: boolean }): Observable<ApiResponse<RolOpcionAccionDto>> {
    return this.http.put<ApiResponse<RolOpcionAccionDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/roles/${rolId}/opciones-menu/${opcionMenuId}/acciones/${accionId}`),
      body, { headers: this.bearerHeaders() }
    );
  }

  // ── Ediciones del ERP (catálogo: edición + módulos incluidos) ──

  listarEdiciones(): Observable<ApiResponse<EdicionErpDto[]>> {
    return this.http.get<ApiResponse<EdicionErpDto[]>>(
      this.buildUrl('/auth/seguridad/landing/ediciones'),
      { headers: this.bearerHeaders() }
    );
  }

  // ── Grupos de usuario por empresa ──

  listarGruposUsuario(empresaId: number): Observable<ApiResponse<GrupoUsuarioDto[]>> {
    return this.http.get<ApiResponse<GrupoUsuarioDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/grupos-usuario`),
      { headers: this.bearerHeaders() }
    );
  }

  crearGrupoUsuario(empresaId: number, body: { codigo: string; descripcion: string; activo?: boolean; miembrosIds: number[] }): Observable<ApiResponse<GrupoUsuarioDto>> {
    return this.http.post<ApiResponse<GrupoUsuarioDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/grupos-usuario`),
      body, { headers: this.bearerHeaders() }
    );
  }

  actualizarGrupoUsuario(empresaId: number, grupoId: number, body: { codigo: string; descripcion: string; activo?: boolean }): Observable<ApiResponse<GrupoUsuarioDto>> {
    return this.http.put<ApiResponse<GrupoUsuarioDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/grupos-usuario/${grupoId}`),
      body, { headers: this.bearerHeaders() }
    );
  }

  // ── Grupo ↔ miembros ──

  listarMiembrosGrupo(empresaId: number, grupoId: number): Observable<ApiResponse<GrupoUsuarioMiembroDto[]>> {
    return this.http.get<ApiResponse<GrupoUsuarioMiembroDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/grupos-usuario/${grupoId}/miembros`),
      { headers: this.bearerHeaders() }
    );
  }

  asignarMiembroGrupo(empresaId: number, grupoId: number, body: { usuarioId: number; activo?: boolean }): Observable<ApiResponse<GrupoUsuarioMiembroDto>> {
    return this.http.post<ApiResponse<GrupoUsuarioMiembroDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/grupos-usuario/${grupoId}/miembros`),
      body, { headers: this.bearerHeaders() }
    );
  }

  quitarMiembroGrupo(empresaId: number, grupoId: number, usuarioId: number): Observable<ApiResponse<void>> {
    return this.http.delete<ApiResponse<void>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/grupos-usuario/${grupoId}/miembros/${usuarioId}`),
      { headers: this.bearerHeaders() }
    );
  }

  // ── Usuario ↔ roles ──

  listarRolesUsuario(empresaId: number, usuarioId: number): Observable<ApiResponse<RolUsuarioDto[]>> {
    return this.http.get<ApiResponse<RolUsuarioDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/usuarios/${usuarioId}/roles`),
      { headers: this.bearerHeaders() }
    );
  }

  asignarRolUsuario(empresaId: number, usuarioId: number, body: { rolId: number; activo?: boolean }): Observable<ApiResponse<RolUsuarioDto>> {
    return this.http.post<ApiResponse<RolUsuarioDto>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/usuarios/${usuarioId}/roles`),
      body, { headers: this.bearerHeaders() }
    );
  }

  quitarRolUsuario(empresaId: number, usuarioId: number, rolId: number): Observable<ApiResponse<void>> {
    return this.http.delete<ApiResponse<void>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/usuarios/${usuarioId}/roles/${rolId}`),
      { headers: this.bearerHeaders() }
    );
  }

  // ── Usuarios (nuevo endpoint admin) ──

  listarUsuarios(): Observable<ApiResponse<UsuarioAdminDto[]>> {
    return this.http.get<ApiResponse<UsuarioAdminDto[]>>(
      this.buildUrl('/auth/seguridad/usuarios'),
      { headers: this.bearerHeaders() }
    );
  }

  obtenerUsuario(id: number): Observable<ApiResponse<UsuarioAdminDto>> {
    return this.http.get<ApiResponse<UsuarioAdminDto>>(
      this.buildUrl(`/auth/seguridad/usuarios/${id}`),
      { headers: this.bearerHeaders() }
    );
  }

  crearUsuario(body: { email: string; username: string; password: string; nombres: string; apellidos: string; flagAdminSistema?: boolean; tipoSales?: string }): Observable<ApiResponse<UsuarioAdminDto>> {
    return this.http.post<ApiResponse<UsuarioAdminDto>>(
      this.buildUrl('/auth/seguridad/usuarios'),
      body, { headers: this.bearerHeaders() }
    );
  }

  actualizarUsuario(id: number, body: { email?: string; username?: string; nombres?: string; apellidos?: string; activo?: boolean; bloqueado?: boolean; flagAdminSistema?: boolean; tipoSales?: string }): Observable<ApiResponse<UsuarioAdminDto>> {
    return this.http.put<ApiResponse<UsuarioAdminDto>>(
      this.buildUrl(`/auth/seguridad/usuarios/${id}`),
      body, { headers: this.bearerHeaders() }
    );
  }

  listarUsuariosDeEmpresa(empresaId: number): Observable<ApiResponse<UsuarioAdminDto[]>> {
    return this.http.get<ApiResponse<UsuarioAdminDto[]>>(
      this.buildUrl(`/auth/seguridad/empresas/${empresaId}/usuarios`),
      { headers: this.bearerHeaders() }
    );
  }

  // ── Asociar/retirar usuario ↔ empresa (admin provisioning) ──

  asociarUsuarioAEmpresa(empresaId: number, usuarioId: number): Observable<ApiResponse<unknown>> {
    return this.http.post<ApiResponse<unknown>>(
      this.buildUrl(`/admin/empresas/${empresaId}/usuarios/${usuarioId}`),
      null, { headers: this.bearerHeaders({ 'X-Provision-Secret': environment.provisionSecret }) }
    );
  }

  retirarUsuarioDeEmpresa(empresaId: number, usuarioId: number): Observable<ApiResponse<unknown>> {
    return this.http.delete<ApiResponse<unknown>>(
      this.buildUrl(`/admin/empresas/${empresaId}/usuarios/${usuarioId}`),
      { headers: this.bearerHeaders({ 'X-Provision-Secret': environment.provisionSecret }) }
    );
  }
}
