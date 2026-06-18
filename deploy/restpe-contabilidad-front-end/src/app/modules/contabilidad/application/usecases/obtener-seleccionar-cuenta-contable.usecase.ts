import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ISeleccionarCuentaContableRepository } from '../../domain/repositories/iseleccionar-cuenta-contable.repository';
import { SeleccionarCuentaContableEntity } from '../../domain/models/seleccionar-cuenta-contable.entity';

/**
 * ObtenerSeleccionarCuentaContableUseCase — Caso de uso de lectura.
 * Orquesta la obtención del catálogo de cuentas contables para el buscador.
 */
@Injectable()
export class ObtenerSeleccionarCuentaContableUseCase {

  private readonly repository = inject(ISeleccionarCuentaContableRepository);

  execute(): Observable<SeleccionarCuentaContableEntity> {
    return this.repository.obtenerTodos();
  }
}
