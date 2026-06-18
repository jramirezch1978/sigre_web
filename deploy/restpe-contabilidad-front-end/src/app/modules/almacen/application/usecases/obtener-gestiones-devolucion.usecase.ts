import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { GestionDevolucionEntity } from '../../domain/models/gestion-devolucion.entity';

@Injectable()
export class ObtenerGestionesDevolucionUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<GestionDevolucionEntity[]> {
    return this.repository.obtenerGestionesDevoluciones();
  }
}
