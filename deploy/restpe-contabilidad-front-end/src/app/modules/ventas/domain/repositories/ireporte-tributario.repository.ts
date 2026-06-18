import { Observable } from 'rxjs';
import { ReporteTributarioDetalleEntity, ReporteTributarioConsolidadoEntity } from '../models/reporte-tributario.entity';

export abstract class IReporteTributarioRepository {
  abstract obtenerVentas(): Observable<ReporteTributarioDetalleEntity[]>;
  abstract obtenerCompras(): Observable<ReporteTributarioDetalleEntity[]>;
  abstract obtenerConsolidado(): Observable<ReporteTributarioConsolidadoEntity[]>;
}
