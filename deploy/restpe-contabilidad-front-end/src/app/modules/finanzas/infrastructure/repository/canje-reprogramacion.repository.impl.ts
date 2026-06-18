import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { ICanjeReprogramacionRepository } from '../../domain/repositories/icanje-reprogramacion.repository';
import { CanjeReprogramacionEntity } from '../../domain/models/canje-reprogramacion.entity';

const JSON_PATH = 'assets/data/finanzas/operaciones/canje-reprogramacion.json';

@Injectable({ providedIn: 'root' })
export class CanjeReprogramacionRepositoryImpl implements ICanjeReprogramacionRepository {
  private readonly DELAY_MS = 800;

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<CanjeReprogramacionEntity[]> {
    return this.http.get<CanjeReprogramacionEntity[]>(JSON_PATH).pipe(
      delay(this.DELAY_MS)
    );
  }

  aplicarCanje(nroDocumento: string): Observable<{ success: boolean }> {
    return of({ success: true }).pipe(delay(this.DELAY_MS));
  }

  reprogramarVencimiento(nroDocumento: string, nuevaFechaVencimiento: string): Observable<{ success: boolean }> {
    return of({ success: true }).pipe(delay(this.DELAY_MS));
  }
}
