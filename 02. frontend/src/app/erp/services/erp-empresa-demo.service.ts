import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, map } from 'rxjs';
import { ApiBaseService } from '../../services/api-base.service';
import { ApiResponse } from '../../shared/models/api-response.model';

export interface UsuarioEmpresaDemo {
  id: number;
  username: string;
  email: string;
  nombre_completo: string;
  flag_estado: string;
}

export interface EmpresaDemoInfo {
  esDemo: boolean;
  maxUsuarios: number;
  usados: number;
  usuariosActivos: number;
  proximoExcede: boolean;
  costoUsuarioAdicional: number;
  usuarios: UsuarioEmpresaDemo[];
}

export interface NuevoUsuarioDemo {
  username: string;
  email: string;
  password: string;
  nombres: string;
  apellidos: string;
  numeroDocumento?: string;
}

@Injectable({ providedIn: 'root' })
export class ErpEmpresaDemoService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  private get base(): string {
    return `${this.apiBase.getApiBaseUrl()}/auth/seguridad/empresa-demo`;
  }

  getInfo(): Observable<EmpresaDemoInfo> {
    return this.http
      .get<ApiResponse<EmpresaDemoInfo>>(`${this.base}/info`)
      .pipe(map(r => r.data ?? {
        esDemo: false, maxUsuarios: 5, usados: 0, usuariosActivos: 0,
        proximoExcede: false, costoUsuarioAdicional: 0, usuarios: [],
      }));
  }

  /** Agrega un usuario. Si excede el límite de la licencia, pasar confirmarExceso=true. */
  agregarUsuario(nuevo: NuevoUsuarioDemo, confirmarExceso = false): Observable<ApiResponse<void>> {
    return this.http.post<ApiResponse<void>>(
      `${this.base}/usuarios?confirmarExceso=${confirmarExceso}`, nuevo);
  }
}
