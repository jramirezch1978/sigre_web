import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IRelacionDocClienteRepository } from '../../domain/repositories/irelaciondoc-cliente.repository';
import { RelacionDocClienteMap } from '../../domain/models/relaciondoc-cliente.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class RelacionDocClienteRepositoryImpl implements IRelacionDocClienteRepository {
  private readonly url = 'assets/data/finanzas/operaciones/relaciondoc-cliente.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<RelacionDocClienteMap> {
    return this.http.get<RelacionDocClienteMap>(this.url).pipe(delay(DELAY_MS));
  }
}
