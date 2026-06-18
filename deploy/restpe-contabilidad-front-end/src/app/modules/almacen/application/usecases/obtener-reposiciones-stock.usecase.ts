import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ReposicionStockEntity } from '../../domain/models/reposicion-stock.entity';

@Injectable()
export class ObtenerReposicionesStockUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<ReposicionStockEntity[]> {
    return this.repository.obtenerReposicionesStock();
  }
}
