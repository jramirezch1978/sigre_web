import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConsultaCentroCostosRepository } from '../../domain/repositories/iconsulta-centro-costos.repository';
import { ConsultaCentroCostosEntity } from '../../domain/models/consulta-centro-costos.entity';

/**
 * ObtenerConsultaCentroCostosUseCase — Caso de uso de lectura.
 * Orquesta la obtención de movimientos de centros de costo por trabajador.
 */
@Injectable()
export class ObtenerConsultaCentroCostosUseCase {

  private readonly repository = inject(IConsultaCentroCostosRepository);

  execute(): Observable<ConsultaCentroCostosEntity> {
    return this.repository.obtenerTodos();
  }
}
