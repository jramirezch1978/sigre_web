import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { delay } from 'rxjs/operators';
import { ICuentaPagarRepository } from '../../domain/repositories/icuenta-pagar.repository';
import { CuentaPagarEntity } from '../../domain/models/cuenta-pagar.entity';

@Injectable()
export class CuentaPagarRepositoryImpl implements ICuentaPagarRepository {
  private readonly http = inject(HttpClient);
  private readonly url = 'assets/data/finanzas/reportes/cuentas-pagar.json';

  obtenerCuentasPagar(): Observable<CuentaPagarEntity[]> {
    return this.http.get<CuentaPagarEntity[]>(this.url).pipe(delay(800));
  }
}
