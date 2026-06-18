import { Observable } from 'rxjs';
import { SunatTipoDocumentoEntity } from '../models/tipo-documento.entity';

export abstract class ISunatTipoDocumentoRepository {
  abstract obtenerTiposDocumento(): Observable<SunatTipoDocumentoEntity[]>;
  abstract obtenerTiposDocumentoActivos(): Observable<
    SunatTipoDocumentoEntity[]
  >;
}
