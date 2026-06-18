import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { DiagnosticoAlmacenEntity } from '../../domain/models/diagnostico-almacen.entity';

@Injectable()
export class ObtenerReporteDiagnosticoAlmacenesUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<DiagnosticoAlmacenEntity[]> {
        return this.repository.obtenerReporteDiagnosticoAlmacenes();
    }
}
