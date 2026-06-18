import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { EjercicioFiscalEntity } from '../../domain/models/ejercicio-fiscal.entity';

@Injectable()
export class ObtenerEjerciciosFiscalesUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<EjercicioFiscalEntity[]> {
    return this.repository.obtenerEjerciciosFiscales();
  }
}
