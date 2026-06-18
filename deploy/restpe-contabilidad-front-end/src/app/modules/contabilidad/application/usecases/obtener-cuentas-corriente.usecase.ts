import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ICuentasCorrienteRepository } from '../../domain/repositories/icuentas-corriente.repository';
import { CuentasCorrienteEntity } from '../../domain/models/cuentas-corriente.entity';

/**
 * ObtenerCuentasCorrienteUseCase — Caso de uso de lectura.
 * Orquesta la obtención de los movimientos de cuentas corriente.
 */
@Injectable()
export class ObtenerCuentasCorrienteUseCase {

  private readonly repository = inject(ICuentasCorrienteRepository);

  execute(): Observable<CuentasCorrienteEntity> {
    return this.repository.obtenerTodos();
  }
}
