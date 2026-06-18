import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IReporteTesoreriaRepository } from '../../domain/repositories/ireporte-tesoreria.repository';
import { ReporteTesoreriaEntity } from '../../domain/models/reporte-tesoreria.entity';

@Injectable()
export class ReporteTesoreriaRepositoryImpl implements IReporteTesoreriaRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/reportes/tesoreria.json';

  obtenerMovimientos(): Observable<ReporteTesoreriaEntity[]> {
    return this.http.get<ReporteTesoreriaEntity[]>(this.url).pipe(delay(800));
  }
}
