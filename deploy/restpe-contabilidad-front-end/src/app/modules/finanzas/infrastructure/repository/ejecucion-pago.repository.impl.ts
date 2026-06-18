import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IEjecucionPagoRepository } from '../../domain/repositories/iejecucion-pago.repository';
import { EjecucionPagoEntity } from '../../domain/models/ejecucion-pago.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class EjecucionPagoRepositoryImpl implements IEjecucionPagoRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/ejecucion-pagos.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<EjecucionPagoEntity[]> {
    return this.http.get<EjecucionPagoEntity[]>(this.url).pipe(delay(DELAY_MS));
  }

  guardar(entity: EjecucionPagoEntity): Observable<EjecucionPagoEntity> {
    return of(entity).pipe(delay(500));
  }

  anular(ep_codigo: string): Observable<void> {
    return of(undefined).pipe(delay(300));
  }
}
