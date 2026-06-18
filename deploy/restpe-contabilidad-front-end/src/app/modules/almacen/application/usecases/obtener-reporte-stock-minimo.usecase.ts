import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { StockMinimoEntity } from '../../domain/models/stock-minimo.entity';

@Injectable()
export class ObtenerReporteStockMinimoUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<StockMinimoEntity[]> {
        return this.repository.obtenerReporteStockMinimo();
    }
}
