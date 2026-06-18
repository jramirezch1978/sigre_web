import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IPagoDetraccionRepository } from '../../domain/repositories/ipago-detraccion.repository';
import { PagoDetraccionEntity } from '../../domain/models/pago-detraccion.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class PagoDetraccionRepositoryImpl implements IPagoDetraccionRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/pago-detraccion.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<PagoDetraccionEntity[]> {
    return this.http.get<PagoDetraccionEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
