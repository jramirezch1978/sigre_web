import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { CompaniaEntity } from '../../domain/models/compania.entity';

/**
 * @summary Caso de uso para obtener compañías
 * @description Recupera la lista de compañías desde el repositorio
 */
@Injectable()
export class ObtenerCompaniasUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<CompaniaEntity[]> {
        return this.repository.obtenerCompanias();
    }
}
