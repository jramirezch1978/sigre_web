import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IMovimientoCruceRepository } from '../../domain/repositories/imovimiento-cruce.repository';
import { MovimientoCruceEntity } from '../../domain/models/movimiento-cruce.entity';

@Injectable()
export class MovimientoCruceRepositoryImpl implements IMovimientoCruceRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/conciliaciones/movimientos-cruce.json';

  obtenerMovimientos(): Observable<MovimientoCruceEntity[]> {
    return this.http.get<MovimientoCruceEntity[]>(this.url).pipe(delay(800));
  }
}
