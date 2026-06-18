import { Injectable, inject, effect } from '@angular/core';
import { TransaccionPeriodicaFacade } from '../application/facades/transaccion-periodica.facade';

@Injectable()
export class TransaccionPeriodicaSyncEffects {
  private readonly facade = inject(TransaccionPeriodicaFacade);

  constructor() {
    // El store ya se actualiza directamente en los use cases (addTransaccion / updateTransaccion).
    // No es necesario recargar desde el JSON porque eso descartaría los cambios en memoria.
  }
}
