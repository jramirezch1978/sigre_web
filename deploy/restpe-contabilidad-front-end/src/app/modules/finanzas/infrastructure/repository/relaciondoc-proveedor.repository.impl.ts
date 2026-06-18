import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IRelacionDocProveedorRepository } from '../../domain/repositories/irelaciondoc-proveedor.repository';
import { RelacionDocProveedorMap } from '../../domain/models/relaciondoc-proveedor.entity';

const DELAY_MS = 800;

@Injectable({ providedIn: 'root' })
export class RelacionDocProveedorRepositoryImpl implements IRelacionDocProveedorRepository {
  private readonly url = 'assets/data/finanzas/operaciones/relaciondoc-proveedor.json';

  constructor(private http: HttpClient) {}

  obtenerTodos(): Observable<RelacionDocProveedorMap> {
    return this.http.get<RelacionDocProveedorMap>(this.url).pipe(delay(DELAY_MS));
  }
}
