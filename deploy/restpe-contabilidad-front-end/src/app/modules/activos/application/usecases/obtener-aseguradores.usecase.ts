import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IAseguradoraRepository } from '../../domain/repositories/iaseguradora.repository';
import { AseguradoraEntity } from '../../domain/models/aseguradora.entity';

@Injectable()
export class ObtenerAseguradoresUseCase {
  private readonly repository = inject(IAseguradoraRepository);

  execute(): Observable<AseguradoraEntity[]> {
    return this.repository.obtenerTodos();
  }
}
