import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IConsultasRepository } from '../../domain/repositories/iconsultas.repository';
import { KardexConsultaEntity } from '../../domain/models/kardex-consulta.entity';

@Injectable()
export class ObtenerConsultaKardexUseCase {
  private readonly consultasRepository = inject(IConsultasRepository);

  execute(): Observable<KardexConsultaEntity[]> {
    return this.consultasRepository.obtenerConsultaKardex();
  }
}
