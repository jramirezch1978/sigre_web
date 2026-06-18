import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICuentaPagarRepository } from '../../domain/repositories/icuenta-pagar.repository';
import { CuentaPagarEntity } from '../../domain/models/cuenta-pagar.entity';

@Injectable()
export class ObtenerCuentaPagarUseCase {
  private readonly repository = inject(ICuentaPagarRepository);

  execute(): Observable<CuentaPagarEntity[]> {
    return this.repository.obtenerCuentasPagar();
  }
}
