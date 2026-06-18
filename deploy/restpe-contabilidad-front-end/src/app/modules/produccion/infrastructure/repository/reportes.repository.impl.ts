import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ReglaAsignacionEntity } from '../../domain/models/regla-asignacion.entity';

@Injectable({ providedIn: 'root' })
export class ReportesRepositoryImpl implements IReportesRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH_REGLAS_ASIGNACION = 'assets/data/produccion/procesos/asignacion-gastos-indirectos.json';

  obtenerReglasAsignacion(): Observable<ReglaAsignacionEntity[]> {
    return this.http.get<ReglaAsignacionEntity[]>(this.JSON_PATH_REGLAS_ASIGNACION).pipe(
      delay(500)
    );
  }
}
