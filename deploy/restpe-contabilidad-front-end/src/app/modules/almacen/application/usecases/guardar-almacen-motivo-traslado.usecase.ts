import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAlmacenMotivoTrasladoRepository } from '@modules/almacen/domain/repositories/ialmacen-motivo-traslado.repository';
import { MotivoTrasladoAlmacenEntity } from '@modules/almacen/domain/models/motivo-traslado-almacen.entity';

@Injectable()
export class GuardarAlmacenMotivoTrasladoUseCase {
  private readonly repository = inject(IAlmacenMotivoTrasladoRepository);

  execute(
    almacen: MotivoTrasladoAlmacenEntity,
  ): Observable<MotivoTrasladoAlmacenEntity> {
    return this.repository.guardarMotivoTrasladoAlmacen(almacen);
  }
}
