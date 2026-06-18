import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IGestionAsientosManualesRepository } from '../../domain/repositories/igestion-asientos-manuales.repository';
import { AsientoManualItem } from '../../domain/models/gestion-asientos-manual.entity';

/**
 * ObtenerGestionAsientosManualesUseCase — Caso de uso de lectura.
 * Orquesta la obtención de la lista de asientos manuales.
 */
@Injectable()
export class ObtenerGestionAsientosManualesUseCase {

  private readonly repository = inject(IGestionAsientosManualesRepository);

  execute(): Observable<AsientoManualItem[]> {
    return this.repository.obtenerTodos();
  }
}

