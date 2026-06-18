import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IPagoRecibidoRepository } from '../../domain/repositories/ipago-recibido.repository';
import { PagoRecibidoEntity } from '../../domain/models/pago-recibido.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class PagoRecibidoRepositoryImpl implements IPagoRecibidoRepository {
  private readonly url = 'assets/data/finanzas/operaciones/pagos-recibidos.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<PagoRecibidoEntity[]> {
    return this.http.get<PagoRecibidoEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
