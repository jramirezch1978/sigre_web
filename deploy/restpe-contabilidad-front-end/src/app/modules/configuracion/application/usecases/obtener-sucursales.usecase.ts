import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { SucursalEntity } from '../../domain/models/sucursal.entity';

/**
 * @summary Caso de uso para obtener sucursales
 * @description Recupera la lista de sucursales desde el repositorio
 */
@Injectable()
export class ObtenerSucursalesUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<SucursalEntity[]> {
        return this.repository.obtenerSucursales();
    }
}
