import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ValorizacionProductoEntity } from '../../domain/models/valorizacion-producto.entity';

@Injectable()
export class ObtenerReporteValorizacionUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<ValorizacionProductoEntity[]> {
        return this.repository.obtenerReporteValorizacion();
    }
}
