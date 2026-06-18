import { Observable } from 'rxjs';
import { PanelReenvioEntity } from '../models/panel-reenvio.entity';

export abstract class IPanelReenvioRepository {
  abstract obtenerTodos(): Observable<PanelReenvioEntity[]>;
}
