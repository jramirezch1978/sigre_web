import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { ICrucePasarelaRepository } from '../../domain/repositories/icruce-pasarela.repository';
import { CrucePasarelaEntity } from '../../domain/models/cruce-pasarela.entity';

@Injectable()
export class CrucePasarelaRepositoryImpl implements ICrucePasarelaRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/conciliaciones/cruce-pasarela.json';

  obtenerCruces(): Observable<CrucePasarelaEntity[]> {
    return this.http.get<CrucePasarelaEntity[]>(this.url).pipe(delay(800));
  }
}
