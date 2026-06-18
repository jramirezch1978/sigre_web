import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IReporteFinanzasRepository } from '../../domain/repositories/ireporte-finanzas.repository';
import { ReporteFinanzasEntity } from '../../domain/models/reporte-finanzas.entity';

@Injectable()
export class ReporteFinanzasRepositoryImpl implements IReporteFinanzasRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/reportes/finanzas.json';

  obtenerMovimientos(): Observable<ReporteFinanzasEntity[]> {
    return this.http.get<ReporteFinanzasEntity[]>(this.url).pipe(delay(800));
  }
}
