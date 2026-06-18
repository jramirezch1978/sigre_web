import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { CuadreStockEntity } from '../../domain/models/cuadre-stock.entity';

@Injectable()
export class ObtenerCuadreStockUC {

  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<CuadreStockEntity[]> {
    return this.repository.obtenerCuadreStock();
  }
}
