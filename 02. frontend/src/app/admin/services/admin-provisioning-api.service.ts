import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiResponse } from '../../shared/models/api-response.model';
import { AbstractAuthenticatedApiService } from './abstract-authenticated-api.service';
import { environment } from '../../../environments/environment';

/** Cuerpo compatible con ProvisionEmpresaRequest (ms-auth-security). */
export interface ProvisionEmpresaBody {
  codigo?: string;
  razonSocial: string;
  nombreComercial?: string;
  sigla: string;
  ruc: string;
  personeria?: string;
  tipoIdentif?: string;
  identificacion?: string;
  dirCalle?: string;
  dirNumero?: string;
  dirLote?: string;
  dirMnz?: string;
  dirCodPostal?: string;
  dirUrbanizacion?: string;
  dirDistrito?: string;
  codCiudad?: string;
  ciuCodPais?: string;
  ciuCodDpto?: string;
  ciuCodProv?: string;
  ciuCodDistr?: string;
  logo?: string;
  representante?: string;
  flagReplicacion?: string;
  flagCntrlCd?: string;
  represLegal?: string;
  dniRepresLegal?: string;
  codActividad?: string;
  flagEnviaPersonal?: string;
  direccion?: string;
  dirProvincia?: string;
  dirDepartamento?: string;
  dirPais?: string;
  dirUbigeo?: string;
  fonoFijo?: string;
  celular?: string;
  email?: string;
  correoContacto?: string;
  dbHost?: string;
  dbPort?: number;
  dbUser?: string;
  dbPassword?: string;
}

export interface ProvisionEmpresaResult {
  empresaId?: number;
  codigo?: string;
  ruc?: string;
  dbName?: string;
  tenantDbUser?: string;
  dbHost?: string;
  dbPort?: number;
  exitoso?: boolean;
  mensaje?: string;
}

export interface RecreateEmpresaBody {
  empresaId?: number;
  codigo?: string;
  ruc?: string;
  dbName?: string;
}

export interface RecreateEmpresaResult {
  empresaId?: number;
  codigo?: string;
  ruc?: string;
  dbName?: string;
  mensaje?: string;
}

export interface DeleteEmpresaProvisionBody {
  codigo?: string;
  ruc?: string;
  dbName?: string;
}

export interface DeleteEmpresaProvisionResult {
  empresaId?: number;
  codigo?: string;
  ruc?: string;
  dbName?: string;
  mensaje?: string;
}

/**
 * Aprovisionamiento de tenant (POST /api/admin/empresas/provision).
 * Requiere JWT válido (temporal o definitivo) y cabecera X-Provision-Secret.
 */
@Injectable({ providedIn: 'root' })
export class AdminProvisioningApiService extends AbstractAuthenticatedApiService {

  private get provisionHeaders() {
    return this.bearerHeaders({ 'X-Provision-Secret': environment.provisionSecret });
  }

  provisionar(body: ProvisionEmpresaBody): Observable<ApiResponse<ProvisionEmpresaResult>> {
    return this.http.post<ApiResponse<ProvisionEmpresaResult>>(
      this.buildUrl('/admin/empresas/provision'),
      body,
      { headers: this.provisionHeaders }
    );
  }

  recrearEmpresa(body: RecreateEmpresaBody): Observable<ApiResponse<RecreateEmpresaResult>> {
    return this.http.post<ApiResponse<RecreateEmpresaResult>>(
      this.buildUrl('/admin/empresas/recreate'),
      body,
      { headers: this.provisionHeaders }
    );
  }

  desaprovisionar(body: DeleteEmpresaProvisionBody): Observable<ApiResponse<DeleteEmpresaProvisionResult>> {
    return this.http.delete<ApiResponse<DeleteEmpresaProvisionResult>>(
      this.buildUrl('/admin/empresas/deprovision'),
      {
        headers: this.provisionHeaders,
        body,
      }
    );
  }
}
