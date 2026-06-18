import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IAsignacionCajaChicaRepository } from '../../domain/repositories/iasignacion-caja-chica.repository';
import { AsignacionCajaChicaEntity } from '../../domain/models/asignacion-caja-chica.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class AsignacionCajaChicaRepositoryImpl implements IAsignacionCajaChicaRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/asignacion-caja-chica.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<AsignacionCajaChicaEntity[]> {
    return this.http.get<AsignacionCajaChicaEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
