import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiResponse } from '../../shared/models/api-response.model';
import { AbstractAuthenticatedApiService } from './abstract-authenticated-api.service';

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

  provisionar(body: ProvisionEmpresaBody, provisionSecret: string): Observable<ApiResponse<ProvisionEmpresaResult>> {
    return this.http.post<ApiResponse<ProvisionEmpresaResult>>(
      this.buildUrl('/admin/empresas/provision'),
      body,
      {
        headers: this.bearerHeaders({
          'X-Provision-Secret': provisionSecret,
        }),
      }
    );
  }

  /**
   * Elimina registro en master y la BD tenant. Requiere cabecera X-Provision-Secret.
   * Enviar al menos uno entre codigo, ruc y dbName (coincidentes con el mismo registro).
   */
  desaprovisionar(
    body: DeleteEmpresaProvisionBody,
    provisionSecret: string
  ): Observable<ApiResponse<DeleteEmpresaProvisionResult>> {
    return this.http.delete<ApiResponse<DeleteEmpresaProvisionResult>>(
      this.buildUrl('/admin/empresas/deprovision'),
      {
        headers: this.bearerHeaders({ 'X-Provision-Secret': provisionSecret }),
        body,
      }
    );
  }
}
