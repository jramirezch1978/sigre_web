import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGestionAsientosAutomaticosRepository } from '../../domain/repositories/igestion-asientos-automaticos.repository';
import { GestionAsientosAutomaticoEntity } from '../../domain/models/gestion-asientos-automatico.entity';

/**
 * ObtenerGestionAsientosAutomaticosUseCase — Caso de uso de lectura.
 * Orquesta la obtención de la lista de asientos automáticos.
 */
@Injectable()
export class ObtenerGestionAsientosAutomaticosUseCase {

  private readonly repository = inject(IGestionAsientosAutomaticosRepository);

  execute(): Observable<GestionAsientosAutomaticoEntity> {
    return this.repository.obtenerTodos();
  }
}
