import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { ActualizacionProductoEntity } from '../../domain/models/actualizacion-producto.entity';

@Injectable()
export class ObtenerActualizacionProductosUC {

    constructor(private readonly repository: IReportesRepository) {}

    execute(): Observable<ActualizacionProductoEntity[]> {
        return this.repository.obtenerActualizacionProductos();
    }
}
