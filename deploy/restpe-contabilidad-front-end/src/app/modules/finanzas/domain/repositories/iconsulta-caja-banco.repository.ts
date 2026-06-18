import { Observable } from 'rxjs';
import { ConsultaCajaBancoEntity } from '../models/consulta-caja-banco.entity';

export abstract class IConsultaCajaBancoRepository {
  abstract obtenerTodos(): Observable<ConsultaCajaBancoEntity[]>;
}
