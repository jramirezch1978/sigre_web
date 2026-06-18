import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { PermisoEntity } from '../../domain/models/permiso.entity';

@Injectable()
export class ObtenerPermisosRegistroUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<PermisoEntity[]> {
    return this.repository.obtenerPermisosRegistro();
  }
}
