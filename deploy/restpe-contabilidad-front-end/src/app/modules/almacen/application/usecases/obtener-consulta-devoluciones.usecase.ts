import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConsultasRepository } from '../../domain/repositories/iconsultas.repository';
import { DevolucionConsultaEntity } from '../../domain/models/devolucion-consulta.entity';

@Injectable()
export class ObtenerConsultaDevolucionesUseCase {
    private readonly repository = inject(IConsultasRepository);

    execute(): Observable<DevolucionConsultaEntity[]> {
        return this.repository.obtenerConsultaDevoluciones();
    }
}
