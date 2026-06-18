import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConsultasRepository } from '../../domain/repositories/iconsultas.repository';
import { PrestamoConsultaEntity } from '../../domain/models/prestamo-consulta.entity';

@Injectable()
export class ObtenerConsultaPrestamosUseCase {
  private readonly consultasRepository = inject(IConsultasRepository);

  execute(): Observable<PrestamoConsultaEntity[]> {
    return this.consultasRepository.obtenerConsultaPrestamos();
  }
}
