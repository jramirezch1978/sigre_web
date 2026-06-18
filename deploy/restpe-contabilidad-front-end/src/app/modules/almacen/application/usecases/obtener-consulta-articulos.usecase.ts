import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConsultasRepository } from '../../domain/repositories/iconsultas.repository';
import { ArticuloConsultaEntity } from '../../domain/models/articulo-consulta.entity';

@Injectable()
export class ObtenerConsultaArticulosUseCase {
    private readonly repository = inject(IConsultasRepository);

    execute(): Observable<ArticuloConsultaEntity[]> {
        return this.repository.obtenerConsultaArticulos();
    }
}
