import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { CanalPagoCobroEntity } from '../../domain/models/canal-pago-cobro.entity';

/**
 * @summary Caso de uso para obtener canales de pago/cobro
 * @description Recupera la lista de canales de pago y cobro desde el repositorio
 */
@Injectable()
export class ObtenerCanalesPagoCobroUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<CanalPagoCobroEntity[]> {
        return this.repository.obtenerCanalesPagoCobro();
    }
}
