import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { PlantillaNotificacionEntity } from '../../domain/models/plantilla-notificacion.entity';

@Injectable()
export class ObtenerPlantillasNotificacionUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<PlantillaNotificacionEntity[]> {
        return this.repository.obtenerPlantillasNotificacion();
    }
}
