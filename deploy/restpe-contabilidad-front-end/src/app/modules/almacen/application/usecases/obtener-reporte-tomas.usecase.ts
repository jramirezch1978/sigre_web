import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { TomaInventarioEntity } from '../../domain/models/toma-inventario.entity';

@Injectable()
export class ObtenerReporteTomasUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<TomaInventarioEntity[]> {
        return this.repository.obtenerReporteTomas();
    }
}
