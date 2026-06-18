import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IMovimientoPasarelaRepository } from '../../domain/repositories/imovimiento-pasarela.repository';
import { MovimientoPasarelaEntity } from '../../domain/models/movimiento-pasarela.entity';

@Injectable()
export class MovimientoPasarelaRepositoryImpl implements IMovimientoPasarelaRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/conciliaciones/movimientos-pasarela.json';

  obtenerMovimientos(): Observable<MovimientoPasarelaEntity[]> {
    return this.http.get<MovimientoPasarelaEntity[]>(this.url).pipe(delay(800));
  }
}
