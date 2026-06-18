import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { RetencionEntity } from '../../domain/models/retencion.entity';

/**
 * @summary Caso de uso para obtener retenciones fiscales
 * @description
 * Obtiene el listado de retenciones desde el repositorio.
 * Aplicable en compras, ventas, pagos y planillas.
 */
@Injectable()
export class ObtenerRetencionesUseCase {

  private readonly repository = inject(IReportesRepository);

  /**
   * @summary Ejecuta el caso de uso
   * @returns Observable con el array de retenciones
   */
  execute(): Observable<RetencionEntity[]> {
    return this.repository.obtenerRetenciones();
  }
}
