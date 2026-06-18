import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IAsignacionFondoFijoCajaRepository } from '../../domain/repositories/iasignacion-fondo-fijo-caja.repository';
import { AsignacionFondoFijoCajaEntity } from '../../domain/models/asignacion-fondo-fijo-caja.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class AsignacionFondoFijoCajaRepositoryImpl implements IAsignacionFondoFijoCajaRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/asignacion-fondo-fijo-caja.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<AsignacionFondoFijoCajaEntity[]> {
    return this.http.get<AsignacionFondoFijoCajaEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
