import { Observable } from 'rxjs';
import { TransaccionPeriodicaEntity } from '../models/transaccion-periodica.entity';

export abstract class ITransaccionPeriodicaRepository {
  abstract obtenerTodos(): Observable<TransaccionPeriodicaEntity[]>;
  abstract guardar(transaccion: Partial<TransaccionPeriodicaEntity>): Observable<{ success: boolean }>;
  abstract actualizar(codigoProgramacion: string, cambios: Partial<TransaccionPeriodicaEntity>): Observable<{ success: boolean }>;
}
