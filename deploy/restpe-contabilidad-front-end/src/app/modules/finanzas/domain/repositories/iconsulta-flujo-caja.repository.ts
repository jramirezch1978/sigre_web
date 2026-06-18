import { Observable } from 'rxjs';
import { ConsultaFlujoCajaEntity } from '../models/consulta-flujo-caja.entity';

export abstract class IConsultaFlujoCajaRepository {
  abstract obtenerTodos(): Observable<ConsultaFlujoCajaEntity[]>;
}
