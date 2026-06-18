import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { IReportesRepository } from '../../domain/repositories/ireportes.repository';
import { UsuarioEntity } from '../../domain/models/usuario.entity';

@Injectable()
export class ObtenerUsuariosUseCase {
  private readonly repository = inject(IReportesRepository);

  execute(): Observable<UsuarioEntity[]> {
    return this.repository.obtenerUsuarios();
  }
}
