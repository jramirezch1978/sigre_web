import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { HistorialActualizacionEntity } from '../../domain/models/historial-actualizacion.entity';

@Injectable()
export class ObtenerHistorialDatosGeneralesUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<HistorialActualizacionEntity[]> {
        return this.repository.obtenerHistorialDatosGenerales();
    }
}
