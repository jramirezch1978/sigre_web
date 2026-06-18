import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { BackendTipoDocumento } from '@modules/finanzas/application/dto/finanzas-backend.types';
import { TipoDocumentoEntity } from '@modules/finanzas/domain/models/tipo-documento.entity';
import { ITipoDocumentoRepository } from '@modules/finanzas/domain/repositories/itipo-documento.repository';
import { map, Observable } from 'rxjs';

interface ApiResponse<T> {
  data: T;
  message: string;
  success: boolean;
}

@Injectable()
export class TipoDocumentoRepositoryImpl implements ITipoDocumentoRepository {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = 'api/core/tipos-documento';

  obtenerTiposDocumento(): Observable<BackendTipoDocumento[]> {
    return this.http
      .get<ApiResponse<BackendTipoDocumento[]>>(this.apiUrl)
      .pipe(
        map(
          (response: ApiResponse<BackendTipoDocumento[]>) =>
            response.data || [],
        ),
      );
  }

  guardarTipoDocumento(
    tipoDocumento: BackendTipoDocumento,
  ): Observable<BackendTipoDocumento> {
    return this.http
      .post<ApiResponse<BackendTipoDocumento>>(this.apiUrl, tipoDocumento)
      .pipe(
        map((response: ApiResponse<BackendTipoDocumento>) => response.data),
      );
  }

  actualizar(
    id: number,
    tipoDocumento: BackendTipoDocumento,
  ): Observable<BackendTipoDocumento> {
    return this.http
      .put<
        ApiResponse<BackendTipoDocumento>
      >(`${this.apiUrl}/${id}`, tipoDocumento)
      .pipe(
        map((response: ApiResponse<BackendTipoDocumento>) => response.data),
      );
  }

  actualizarEstado(
    id: number,
    estado: string,
  ): Observable<BackendTipoDocumento> {
    const accion = estado === '1' ? 'activar' : 'desactivar';
    return this.http
      .patch<
        ApiResponse<BackendTipoDocumento>
      >(`${this.apiUrl}/${id}/${accion}`, {})
      .pipe(map((response) => response.data));
  }

  eliminar(id: number): Observable<boolean> {
    return this.http
      .delete<ApiResponse<boolean>>(`${this.apiUrl}/${id}`)
      .pipe(map((response: ApiResponse<boolean>) => response.data));
  }

  toBackendEntity(tipoDocument: TipoDocumentoEntity): BackendTipoDocumento {
    return {
      codigo: tipoDocument.codigo,
      nombre: tipoDocument.nombre,
      flagEstado: tipoDocument.flagEstado,
      ...(tipoDocument.id ? { id: tipoDocument.id } : {}),
      ...(tipoDocument.sunatCodigo
        ? { sunatCodigo: tipoDocument.sunatCodigo }
        : {}),
    };
  }

  toDomainEntity(tipoDocument: BackendTipoDocumento): TipoDocumentoEntity {
    return {
      nombre: tipoDocument.nombre,
      codigo: tipoDocument.codigo,
      flagEstado: tipoDocument.flagEstado,
      ...(tipoDocument.id ? { id: tipoDocument.id } : {}),
      ...(tipoDocument.sunatCodigo
        ? { sunatCodigo: tipoDocument.sunatCodigo }
        : {}),
    };
  }
}
