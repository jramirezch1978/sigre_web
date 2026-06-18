import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { RecalculoPrecioEntity } from '../../domain/models/recalculo-precio.entity';

@Injectable()
export class ObtenerRecalculoPreciosUC {
    
    constructor(private readonly repository: IReportesRepository) {}

    execute(): Observable<RecalculoPrecioEntity[]> {
        return this.repository.obtenerRecalculoPrecios();
    }
}
