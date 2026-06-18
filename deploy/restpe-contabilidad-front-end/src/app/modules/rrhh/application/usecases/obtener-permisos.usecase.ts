import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { PermisoEntity } from '../../domain/models/permiso.entity';

@Injectable()
export class ObtenerPermisosUseCase {
  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<PermisoEntity[]> {
    return this.repository.obtenerPermisos();
  }
}
