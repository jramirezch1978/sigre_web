import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { ICruceExtractoRepository } from '../../domain/repositories/icruce-extracto.repository';
import { CruceExtractoEntity } from '../../domain/models/cruce-extracto.entity';

@Injectable()
export class CruceExtractoRepositoryImpl implements ICruceExtractoRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/conciliaciones/cruce-extracto.json';

  obtenerCruces(): Observable<CruceExtractoEntity[]> {
    return this.http.get<CruceExtractoEntity[]>(this.url).pipe(delay(800));
  }
}
