import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAlmacenRepository } from '../../domain/repositories/ialmacen.repository';
import { TipoAlmacenEntity } from '../../domain/models/tipo-almacen.entity';

/** Obtiene el catálogo de tipos de almacén (`/almacen-tipos`). */
@Injectable()
export class ObtenerTiposAlmacenUseCase {
    private readonly repository = inject(IAlmacenRepository);

    execute(): Observable<TipoAlmacenEntity[]> {
        return this.repository.obtenerTiposAlmacen();
    }
}
