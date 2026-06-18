import { inject, Injectable } from '@angular/core';
import { MotivoTrasladoAlmacenEntity } from '@modules/almacen/domain/models/motivo-traslado-almacen.entity';
import { IAlmacenMotivoTrasladoRepository } from '@modules/almacen/domain/repositories/ialmacen-motivo-traslado.repository';
import { map, Observable } from 'rxjs';
import { AlmacenHttpService } from '../http/almacen-http.service';
import { BackendApiResponse, BackendPageData } from '@modules/almacen/application/dto/almacen-backend.types';

@Injectable({ providedIn: 'root' })
export class AlmacenMotivoTrasladoRepositoryImpl implements IAlmacenMotivoTrasladoRepository {
  private readonly api = inject(AlmacenHttpService);
  obtenerMotivosTrasladoAlmacenes(): Observable<MotivoTrasladoAlmacenEntity[]> {
    return this.api
      .get<
        BackendPageData<MotivoTrasladoAlmacenEntity>
      >('/maestros/motivos-traslado', { size: 1000 })
      .pipe(
        map((response) => {
          console.log('Response:', response.content);

          return response.content || [];
        }),
      );
  }
  guardarMotivoTrasladoAlmacen(
    motivo: MotivoTrasladoAlmacenEntity,
  ): Observable<MotivoTrasladoAlmacenEntity> {
    return this.api.post<MotivoTrasladoAlmacenEntity>(
      '/maestros/motivos-traslado',
      motivo,
    );
  }
}
