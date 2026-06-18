import { Observable } from 'rxjs';
import { ReglaAsignacionEntity } from '../models/regla-asignacion.entity';

export abstract class IReportesRepository {
  abstract obtenerReglasAsignacion(): Observable<ReglaAsignacionEntity[]>;
}
