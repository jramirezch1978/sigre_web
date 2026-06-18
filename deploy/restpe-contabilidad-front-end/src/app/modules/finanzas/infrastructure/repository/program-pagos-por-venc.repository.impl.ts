import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IProgramPagosPorVencRepository } from '../../domain/repositories/iprogram-pagos-por-venc.repository';
import { ProgramPagosPorVencEntity } from '../../domain/models/program-pagos-por-venc.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class ProgramPagosPorVencRepositoryImpl implements IProgramPagosPorVencRepository {
  private readonly url = 'assets/data/finanzas/tesoreria/program-pagos-por-venc.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<ProgramPagosPorVencEntity[]> {
    return this.http.get<ProgramPagosPorVencEntity[]>(this.url).pipe(delay(DELAY_MS));
  }
}
