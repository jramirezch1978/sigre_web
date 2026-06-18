import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';

/**
 * Descarga el PDF (vale de movimiento, JasperReports) de un movimiento de
 * almacén por su id. Backend: `GET /api/almacen/movimientos/pdf/{id}` (HU §18.9).
 */
@Injectable()
export class DescargarMovimientoPdfUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(id: number): Observable<Blob> {
        return this.repository.descargarMovimientoPdf(id);
    }
}
