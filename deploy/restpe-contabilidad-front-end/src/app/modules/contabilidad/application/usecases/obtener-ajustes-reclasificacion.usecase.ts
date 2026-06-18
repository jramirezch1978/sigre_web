import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAjustesReclasificacionRepository } from '../../domain/repositories/iajustes-reclasificacion.repository';
import { AjustesReclasificacionEntity } from '../../domain/models/ajustes-reclasificacion.entity';

/**
 * ObtenerAjustesReclasificacionUseCase — Caso de uso de aplicación.
 * Encapsula la lógica de negocio: obtener el listado completo de ajustes y reclasificaciones.
 */
@Injectable()
export class ObtenerAjustesReclasificacionUseCase {

  private readonly repo = inject(IAjustesReclasificacionRepository);

  execute(): Observable<AjustesReclasificacionEntity> {
    return this.repo.obtenerTodos();
  }
}
