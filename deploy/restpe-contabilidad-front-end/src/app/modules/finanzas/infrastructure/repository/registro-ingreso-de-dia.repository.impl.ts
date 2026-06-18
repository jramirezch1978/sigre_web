import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { IRegistroIngresoDeDiaRepository } from '../../domain/repositories/iregistro-ingreso-de-dia.repository';
import { RegistroIngresoDeDiaEntity } from '../../domain/models/registro-ingreso-de-dia.entity';

@Injectable()
export class RegistroIngresoDeDiaRepositoryImpl implements IRegistroIngresoDeDiaRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/tesoreria/registro-ingreso-de-dia.json';

  obtenerIngresos(): Observable<RegistroIngresoDeDiaEntity[]> {
    return this.http.get<RegistroIngresoDeDiaEntity[]>(this.url).pipe(delay(800));
  }
}
