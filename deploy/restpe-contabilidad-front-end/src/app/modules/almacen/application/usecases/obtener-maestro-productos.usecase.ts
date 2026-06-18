import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { MaestroProductoEntity } from '../../domain/models/maestro-producto.entity';

@Injectable()
export class ObtenerMaestroProductosUseCase {
    private readonly repository = inject(IReportesRepository);

    execute(): Observable<MaestroProductoEntity[]> {
        return this.repository.obtenerMaestroProductos();
    }
}
