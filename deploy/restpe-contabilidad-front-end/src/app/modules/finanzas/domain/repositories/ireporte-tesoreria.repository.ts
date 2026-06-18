import { Observable } from 'rxjs';
import { ReporteTesoreriaEntity } from '../models/reporte-tesoreria.entity';

export abstract class IReporteTesoreriaRepository {
  abstract obtenerMovimientos(): Observable<ReporteTesoreriaEntity[]>;
}
