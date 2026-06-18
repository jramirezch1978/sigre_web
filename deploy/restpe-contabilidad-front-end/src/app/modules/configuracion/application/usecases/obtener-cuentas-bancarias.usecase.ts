import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { CuentaBancariaEntity } from '../../domain/models/cuenta-bancaria.entity';

/**
 * @summary Caso de uso para obtener cuentas bancarias
 * @description Recupera la lista de cuentas bancarias desde el repositorio
 */
@Injectable()
export class ObtenerCuentasBancariasUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<CuentaBancariaEntity[]> {
        return this.repository.obtenerCuentasBancarias();
    }
}
