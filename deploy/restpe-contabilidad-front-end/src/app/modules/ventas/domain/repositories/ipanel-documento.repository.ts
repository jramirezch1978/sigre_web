import { Observable } from 'rxjs';
import { PanelDocumentoEntity } from '../models/panel-documento.entity';

export abstract class IPanelDocumentoRepository {
  abstract obtenerTodos(): Observable<PanelDocumentoEntity[]>;
}
