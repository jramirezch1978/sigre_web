import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IPagosMasivosRepository } from '../../domain/repositories/ipagos-masivos.repository';
import { PagosMasivosEntity } from '../../domain/models/pagos-masivos.entity';
import { PagosMasivosDocumentoEntity } from '../../domain/models/pagos-masivos-documento.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class PagosMasivosRepositoryImpl implements IPagosMasivosRepository {
  private readonly urlRegistros = 'assets/data/finanzas/tesoreria/pagos-masivos.json';
  private readonly urlDocumentos = 'assets/data/finanzas/tesoreria/pagos-masivos-documentos.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<PagosMasivosEntity[]> {
    return this.http.get<PagosMasivosEntity[]>(this.urlRegistros).pipe(delay(DELAY_MS));
  }

  obtenerDocumentos(): Observable<PagosMasivosDocumentoEntity[]> {
    return this.http.get<PagosMasivosDocumentoEntity[]>(this.urlDocumentos).pipe(delay(DELAY_MS));
  }

  guardar(entity: PagosMasivosEntity): Observable<PagosMasivosEntity> {
    return of(entity).pipe(delay(DELAY_MS));
  }
}
