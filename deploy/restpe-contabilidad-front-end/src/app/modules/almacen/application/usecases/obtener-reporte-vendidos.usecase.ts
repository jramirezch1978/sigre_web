import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ProductoVendidoEntity } from '../../domain/models/producto-vendido.entity';

@Injectable()
export class ObtenerReporteVendidosUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<ProductoVendidoEntity[]> {
        return this.repository.obtenerReporteVendidos();
    }
}
