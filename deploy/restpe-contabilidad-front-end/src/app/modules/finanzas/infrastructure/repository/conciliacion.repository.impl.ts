import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IConciliacionRepository } from '../../domain/repositories/iconciliacion.repository';
import { ConciliacionEntity } from '../../domain/models/conciliacion.entity';

@Injectable()
export class ConciliacionRepositoryImpl implements IConciliacionRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/conciliaciones/conciliaciones.json';

  obtenerConciliaciones(): Observable<ConciliacionEntity[]> {
    return this.http.get<ConciliacionEntity[]>(this.url).pipe(delay(800));
  }
}
