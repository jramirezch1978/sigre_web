import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IAnulacionPagosRepository } from '../../domain/repositories/ianulacion-pagos.repository';
import { AnulacionPagosEntity } from '../../domain/models/anulacion-pagos.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class AnulacionPagosRepositoryImpl implements IAnulacionPagosRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/anulacion-pagos.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<AnulacionPagosEntity[]> {
    return this.http.get<AnulacionPagosEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
