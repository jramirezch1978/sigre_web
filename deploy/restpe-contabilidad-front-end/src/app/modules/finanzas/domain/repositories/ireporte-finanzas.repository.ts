import { Observable } from 'rxjs';
import { ReporteFinanzasEntity } from '../models/reporte-finanzas.entity';

export abstract class IReporteFinanzasRepository {
  abstract obtenerMovimientos(): Observable<ReporteFinanzasEntity[]>;
}
