import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { MovAlmacenEntity } from '../../domain/models/mov-almacen.entity';

@Injectable()
export class ObtenerMovAlmacenesUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<MovAlmacenEntity[]> {
        return this.repository.obtenerMovAlmacenes();
    }
}
