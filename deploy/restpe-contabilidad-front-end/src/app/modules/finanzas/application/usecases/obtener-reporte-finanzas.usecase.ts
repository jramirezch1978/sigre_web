import { Injectable, inject } from '@angular/core';
import { IReporteFinanzasRepository } from '../../domain/repositories/ireporte-finanzas.repository';

@Injectable()
export class ObtenerReporteFinanzasUseCase {
  private readonly repository = inject(IReporteFinanzasRepository);

  execute() {
    return this.repository.obtenerMovimientos();
  }
}
