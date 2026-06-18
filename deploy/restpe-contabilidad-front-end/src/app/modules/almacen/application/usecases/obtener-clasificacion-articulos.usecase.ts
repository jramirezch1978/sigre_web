import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { CategoriaArticuloEntity } from '../../domain/models/categoria-articulo.entity';

@Injectable()
export class ObtenerClasificacionArticulosUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<CategoriaArticuloEntity[]> {
        return this.repository.obtenerClasificacionArticulos();
    }
}
