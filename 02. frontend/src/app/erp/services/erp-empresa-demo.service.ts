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
  usuarios: UsuarioEmpresaDemo[];
}

export interface NuevoUsuarioDemo {
  username: string;
  email: string;
  password: string;
  nombres: string;
  apellidos: string;
}

@Injectable({ providedIn: 'root' })
export class ErpEmpresaDemoService {
  private readonly http = inject(HttpClient);
  private readonly apiBase = inject(ApiBaseService);

  getInfo(): Observable<EmpresaDemoInfo> {
    return this.http
      .get<ApiResponse<EmpresaDemoInfo>>(`${this.apiBase.getApiBaseUrl()}/auth/seguridad/empresa-demo/info`)
      .pipe(map(r => r.data ?? { esDemo: false, maxUsuarios: 5, usados: 0, usuarios: [] }));
  }

  agregarUsuario(nuevo: NuevoUsuarioDemo): Observable<ApiResponse<void>> {
    return this.http.post<ApiResponse<void>>(
      `${this.apiBase.getApiBaseUrl()}/auth/seguridad/empresa-demo/usuarios`, nuevo);
  }
}
