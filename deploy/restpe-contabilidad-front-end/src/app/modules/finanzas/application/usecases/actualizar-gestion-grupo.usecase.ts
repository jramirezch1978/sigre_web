import { Injectable } from '@angular/core';
import { IGestionGrupoRepository } from '../../domain/repositories/igestion-grupo.repository';
import { GestionGrupoStore } from '../../store/gestion-grupo.store';
import { GestionGrupoEntity } from '../../domain/models/gestion-grupo.entity';

@Injectable()
export class ActualizarGestionGrupoUseCase {
  constructor(
    private repository: IGestionGrupoRepository,
    private store: GestionGrupoStore,
  ) {}

  execute(codigo: string, cambios: Partial<GestionGrupoEntity>): void {
    this.store.setLoadingActualizar(true);
    this.repository.actualizar(codigo, cambios).subscribe({
      next: (result) => this.store.setResultActualizar(result),
      error: (err) => this.store.setErrorActualizar(err?.message ?? 'Error al actualizar grupo'),
    });
  }
}
