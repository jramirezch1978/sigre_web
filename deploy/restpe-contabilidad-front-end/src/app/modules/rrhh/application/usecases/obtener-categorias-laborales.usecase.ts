import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IMaestroPersonalRepository } from '../../domain/repositories/imaestro-personal.repository';
import { CategoriaLaboralEntity } from '../../domain/models/categoria-laboral.entity';

@Injectable()
export class ObtenerCategoriasLaboralesUseCase {
  private readonly repository = inject(IMaestroPersonalRepository);

  execute(): Observable<CategoriaLaboralEntity[]> {
    return this.repository.obtenerCategoriasLaborales();
  }
}
