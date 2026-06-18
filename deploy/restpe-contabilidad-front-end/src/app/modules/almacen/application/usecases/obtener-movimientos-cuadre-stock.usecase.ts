import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { MovimientoCuadreStockEntity } from '../../domain/models/movimiento-cuadre-stock.entity';

@Injectable()
export class ObtenerMovimientosCuadreStockUC {

  constructor(private readonly repository: IReportesRepository) {}

  execute(): Observable<MovimientoCuadreStockEntity[]> {
    return this.repository.obtenerMovimientosCuadreStock();
  }
}
