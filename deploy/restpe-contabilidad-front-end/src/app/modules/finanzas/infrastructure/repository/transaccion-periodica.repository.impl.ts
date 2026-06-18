import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay, switchMap } from 'rxjs/operators';
import { ITransaccionPeriodicaRepository } from '../../domain/repositories/itransaccion-periodica.repository';
import { TransaccionPeriodicaEntity } from '../../domain/models/transaccion-periodica.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class TransaccionPeriodicaRepositoryImpl implements ITransaccionPeriodicaRepository {
  private readonly url = 'assets/data/finanzas/operaciones/transacciones-periodicas.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<TransaccionPeriodicaEntity[]> {
    return this.http.get<TransaccionPeriodicaEntity[]>(this.url).pipe(delay(DELAY_MS));
  }

  guardar(transaccion: Partial<TransaccionPeriodicaEntity>): Observable<{ success: boolean }> {
    return of({ success: true }).pipe(delay(DELAY_MS));
  }

  actualizar(codigoProgramacion: string, cambios: Partial<TransaccionPeriodicaEntity>): Observable<{ success: boolean }> {
    return of({ success: true }).pipe(delay(DELAY_MS));
  }
}
