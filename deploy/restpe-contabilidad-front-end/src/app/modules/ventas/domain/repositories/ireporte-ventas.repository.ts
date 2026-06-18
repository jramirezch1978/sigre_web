import { Observable } from 'rxjs';
import { ReporteVentasEntity } from '../models/reporte-ventas.entity';

export abstract class IReporteVentasRepository {
  abstract obtenerTodos(): Observable<ReporteVentasEntity[]>;
}
