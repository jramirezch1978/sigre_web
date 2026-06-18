import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { AfiliacionFondosPensionEntity } from '../../domain/models/afiliacion-fondos-pension.entity';

@Injectable()
export class ObtenerAfiliacionFondosPensionUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<AfiliacionFondosPensionEntity[]> {
    return this.repository.obtenerAfiliacionFondosPension();
  }
}
