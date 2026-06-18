import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { StockFechaEntity } from '../../domain/models/stock-fecha.entity';

@Injectable()
export class ObtenerReporteStockFechaUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<StockFechaEntity[]> {
        return this.repository.obtenerReporteStockFecha();
    }
}
