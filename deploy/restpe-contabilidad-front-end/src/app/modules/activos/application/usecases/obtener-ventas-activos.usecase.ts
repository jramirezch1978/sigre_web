import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IVentaActivoRepository } from '../../domain/repositories/iventa-activo.repository';
import { VentaActivoEntity } from '../../domain/models/venta-activo.entity';

/**
 * Caso de uso: Obtener listado de ventas/bajas de activos fijos.
 * SRP: única responsabilidad de solicitar todos los registros al repositorio.
 */
@Injectable()
export class ObtenerVentasActivosUseCase {
  private readonly repository = inject(IVentaActivoRepository);

  execute(): Observable<VentaActivoEntity[]> {
    return this.repository.obtenerTodos();
  }
}
