import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IObligacionVencerRepository } from '../../domain/repositories/iobligacion-vencer.repository';
import { ObligacionVencerEntity } from '../../domain/models/obligacion-vencer.entity';

@Injectable()
export class ObligacionVencerRepositoryImpl implements IObligacionVencerRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/reportes/obligaciones-por-vencer.json';

  obtenerObligaciones(): Observable<ObligacionVencerEntity[]> {
    return this.http.get<ObligacionVencerEntity[]>(this.url).pipe(delay(800));
  }
}
