import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import {
  BackendCatalogoSunatTipoDocumento,
  BackendTipoDocumento,
} from '@modules/finanzas/application/dto/finanzas-backend.types';
import { TipoDocumentoEntity } from '@modules/finanzas/domain/models/tipo-documento.entity';
import { ISunatTipoDocumentoRepository } from '@modules/finanzas/domain/repositories/isunat-tipo-documento.repository';
import { ITipoDocumentoRepository } from '@modules/finanzas/domain/repositories/itipo-documento.repository';
import { map, Observable } from 'rxjs';

interface ApiResponse<T> {
  data: T;
  message: string;
  success: boolean;
}

interface PagedResponse<T> {
  content: T[];
  page?: {
    size: number;
    number: number;
    totalElements: number;
    totalPages: number;
  };
}

@Injectable()
export class SunatTipoDocumentoRepositoryImpl implements ISunatTipoDocumentoRepository {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = 'api/core/catalogos-sunat/detalles';
  private readonly codigoCatalogo = '12'; //Se debe ajustar según el valor real del catálogo de parametros

  obtenerTiposDocumento(): Observable<BackendCatalogoSunatTipoDocumento[]> {
    return this.http
      .get<
        ApiResponse<
          | BackendCatalogoSunatTipoDocumento[]
          | PagedResponse<BackendCatalogoSunatTipoDocumento>
        >
      >(`${this.apiUrl}?catalogoSunatId=${this.codigoCatalogo}&size=1000`)
      .pipe(
        map(
          (
            response: ApiResponse<
              | BackendCatalogoSunatTipoDocumento[]
              | PagedResponse<BackendCatalogoSunatTipoDocumento>
            >,
          ) => {
            const dataOriginal = response.data;
            if (Array.isArray(dataOriginal)) {
              return dataOriginal;
            }

            if (
              dataOriginal &&
              typeof dataOriginal === 'object' &&
              'content' in dataOriginal
            ) {
              return (
                (
                  dataOriginal as PagedResponse<BackendCatalogoSunatTipoDocumento>
                ).content || []
              );
            }
            return [];
          },
        ),
      );
  }

  obtenerTiposDocumentoActivos(): Observable<
    BackendCatalogoSunatTipoDocumento[]
  > {
    return this.http
      .get<
        ApiResponse<
          | BackendCatalogoSunatTipoDocumento[]
          | PagedResponse<BackendCatalogoSunatTipoDocumento>
        >
      >(`${this.apiUrl}?catalogoSunatId=${this.codigoCatalogo}&size=1000&flagEstado=1`)
      .pipe(
        map(
          (
            response: ApiResponse<
              | BackendCatalogoSunatTipoDocumento[]
              | PagedResponse<BackendCatalogoSunatTipoDocumento>
            >,
          ) => {
            const dataOriginal = response.data;
            if (Array.isArray(dataOriginal)) {
              return dataOriginal;
            }

            if (
              dataOriginal &&
              typeof dataOriginal === 'object' &&
              'content' in dataOriginal
            ) {
              return (
                (
                  dataOriginal as PagedResponse<BackendCatalogoSunatTipoDocumento>
                ).content || []
              );
            }
            return [];
          },
        ),
      );
  }
}
