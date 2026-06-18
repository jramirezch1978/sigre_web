import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IMovCuentasBancYCajasRepository } from '../../domain/repositories/imov-cuentas-banc-y-cajas.repository';
import { MovCuentasBancYCajasEntity } from '../../domain/models/mov-cuentas-banc-y-cajas.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class MovCuentasBancYCajasRepositoryImpl implements IMovCuentasBancYCajasRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/mov-cuentas-banc-y-cajas.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<MovCuentasBancYCajasEntity[]> {
    return this.http.get<MovCuentasBancYCajasEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
