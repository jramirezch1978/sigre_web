import { Observable } from 'rxjs';
import { ProgramPagosPorVencEntity } from '../models/program-pagos-por-venc.entity';

export abstract class IProgramPagosPorVencRepository {
  abstract obtenerTodos(): Observable<ProgramPagosPorVencEntity[]>;
}
