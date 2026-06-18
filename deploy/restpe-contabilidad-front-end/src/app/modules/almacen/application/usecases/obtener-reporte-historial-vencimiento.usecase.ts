import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { HistorialVencimientoEntity } from '../../domain/models/historial-vencimiento.entity';

@Injectable()
export class ObtenerReporteHistorialVencimientoUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<HistorialVencimientoEntity[]> {
        return this.repository.obtenerReporteHistorialVencimiento();
    }
}
