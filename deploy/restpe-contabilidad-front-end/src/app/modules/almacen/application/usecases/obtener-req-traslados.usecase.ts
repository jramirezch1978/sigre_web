import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ReqTrasladoEntity } from '../../domain/models/req-traslado.entity';

@Injectable()
export class ObtenerReqTrasladosUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<ReqTrasladoEntity[]> {
        return this.repository.obtenerReqTraslados();
    }
}
