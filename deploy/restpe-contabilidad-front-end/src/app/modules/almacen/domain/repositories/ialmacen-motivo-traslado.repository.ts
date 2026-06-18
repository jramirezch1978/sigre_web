import { Observable } from 'rxjs';
import { MotivoTrasladoAlmacenEntity } from '../models/motivo-traslado-almacen.entity';

export abstract class IAlmacenMotivoTrasladoRepository {
  abstract obtenerMotivosTrasladoAlmacenes(): Observable<
    MotivoTrasladoAlmacenEntity[]
  >;

  abstract guardarMotivoTrasladoAlmacen(
    motivo: MotivoTrasladoAlmacenEntity,
  ): Observable<MotivoTrasladoAlmacenEntity>;
}
