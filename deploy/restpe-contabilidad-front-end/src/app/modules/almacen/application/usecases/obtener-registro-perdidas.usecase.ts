import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { RegistroPerdidasEntity } from '../../domain/models/registro-perdidas.entity';

@Injectable()
export class ObtenerRegistroPerdidasUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<RegistroPerdidasEntity[]> {
    return this.repository.obtenerRegistroPerdidas();
  }
}
