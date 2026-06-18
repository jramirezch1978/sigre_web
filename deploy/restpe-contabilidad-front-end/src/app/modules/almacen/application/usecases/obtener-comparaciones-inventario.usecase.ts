import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ComparacionInventarioEntity } from '../../domain/models/catalogo.entity';

@Injectable()
export class ObtenerComparacionesInventarioUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<ComparacionInventarioEntity[]> {
    return this.repository.obtenerComparacionesInventario();
  }
}
