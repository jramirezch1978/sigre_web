import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { CondicionPagoCobroEntity } from '../../domain/models/condicion-pago-cobro.entity';

/**
 * @summary Caso de uso para obtener condiciones de pago/cobro
 * @description Recupera la lista de condiciones de pago y cobro desde el repositorio
 */
@Injectable()
export class ObtenerCondicionesPagoCobroUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<CondicionPagoCobroEntity[]> {
        return this.repository.obtenerCondicionesPagoCobro();
    }
}
