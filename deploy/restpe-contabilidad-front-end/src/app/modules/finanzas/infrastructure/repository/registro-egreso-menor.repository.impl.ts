import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IRegistroEgresoMenorRepository } from '../../domain/repositories/iregistro-egreso-menor.repository';
import { RegistroEgresoMenorEntity } from '../../domain/models/registro-egreso-menor.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class RegistroEgresoMenorRepositoryImpl implements IRegistroEgresoMenorRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/registro-egreso-menor.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<RegistroEgresoMenorEntity[]> {
    return this.http.get<RegistroEgresoMenorEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
