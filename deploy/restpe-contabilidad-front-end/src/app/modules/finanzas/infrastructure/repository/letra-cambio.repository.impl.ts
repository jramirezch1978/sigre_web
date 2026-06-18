import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay } from 'rxjs';
import { ILetraCambioRepository } from '../../domain/repositories/iletra-cambio.repository';
import { LetraCambioEntity } from '../../domain/models/letra-cambio.entity';

@Injectable()
export class LetraCambioRepositoryImpl extends ILetraCambioRepository {
  private readonly _url = 'assets/data/finanzas/operaciones/letras-cambio.json';
  private _datos: LetraCambioEntity[] = [];

  constructor(private http: HttpClient) {
    super();
  }

  obtenerTodos(): Observable<LetraCambioEntity[]> {
    return this.http.get<LetraCambioEntity[]>(this._url).pipe(delay(800));
  }

  guardar(letra: LetraCambioEntity): Observable<LetraCambioEntity> {
    return new Observable<LetraCambioEntity>(observer => {
      this._datos.unshift(letra);
      setTimeout(() => {
        observer.next(letra);
        observer.complete();
      }, 800);
    });
  }

  actualizar(letra: LetraCambioEntity): Observable<LetraCambioEntity> {
    return new Observable<LetraCambioEntity>(observer => {
      const index = this._datos.findIndex(l => l.letra_codigo === letra.letra_codigo);
      if (index !== -1) {
        this._datos[index] = letra;
      }
      setTimeout(() => {
        observer.next(letra);
        observer.complete();
      }, 800);
    });
  }
}
