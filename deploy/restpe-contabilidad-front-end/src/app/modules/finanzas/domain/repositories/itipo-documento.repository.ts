import { Observable } from 'rxjs';
import { TipoDocumentoEntity } from '../models/tipo-documento.entity';

export abstract class ITipoDocumentoRepository {
  abstract obtenerTiposDocumento(): Observable<TipoDocumentoEntity[]>;

  abstract guardarTipoDocumento(
    tipoDocumento: TipoDocumentoEntity,
  ): Observable<TipoDocumentoEntity>;

  abstract actualizar(
    id: number,
    tipoDocumento: TipoDocumentoEntity,
  ): Observable<TipoDocumentoEntity>;

  abstract eliminar(id: number): Observable<boolean>;

  abstract actualizarEstado(
    id: number,
    estado: string,
  ): Observable<TipoDocumentoEntity>;
}
