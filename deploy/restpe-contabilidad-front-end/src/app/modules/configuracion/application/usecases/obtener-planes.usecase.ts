import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { PlanEntity } from '../../domain/models/plan.entity';

@Injectable()
export class ObtenerPlanesUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<PlanEntity[]> {
        return this.repository.obtenerPlanes();
    }
}
