import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConsultasRepository } from '../../domain/repositories/iconsultas.repository';
import { OrdenCompraConsultaEntity } from '../../domain/models/orden-compra-consulta.entity';

@Injectable()
export class ObtenerConsultaOrdenesCompraUseCase {
    private readonly repository = inject(IConsultasRepository);

    execute(): Observable<OrdenCompraConsultaEntity[]> {
        return this.repository.obtenerConsultaOrdenesCompra();
    }
}
