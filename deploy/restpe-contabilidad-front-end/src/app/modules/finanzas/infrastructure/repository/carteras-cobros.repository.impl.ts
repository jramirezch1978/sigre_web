import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { ICarterasCobrosRepository } from '../../domain/repositories/icarteras-cobros.repository';
import { CarterasCobrosEntity } from '../../domain/models/carteras-cobros.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class CarterasCobrosRepositoryImpl implements ICarterasCobrosRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/carteras-cobros.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<CarterasCobrosEntity[]> {
    return this.http.get<CarterasCobrosEntity[]>(this.url).pipe(delay(DELAY_MS));
  }

  actualizar(entity: CarterasCobrosEntity): Observable<CarterasCobrosEntity> {
    return of(entity).pipe(delay(DELAY_MS));
  }
}
