import { Injectable } from '@angular/core';
import { IGestionGrupoRepository } from '../../domain/repositories/igestion-grupo.repository';
import { GestionGrupoStore } from '../../store/gestion-grupo.store';
import { GestionGrupoEntity } from '../../domain/models/gestion-grupo.entity';

@Injectable()
export class GuardarGestionGrupoUseCase {
  constructor(
    private repository: IGestionGrupoRepository,
    private store: GestionGrupoStore,
  ) {}

  execute(grupo: Partial<GestionGrupoEntity>): void {
    this.store.setLoadingGuardar(true);
    this.repository.guardar(grupo).subscribe({
      next: (result) => this.store.setResultGuardar(result),
      error: (err) => this.store.setErrorGuardar(err?.message ?? 'Error al guardar grupo'),
    });
  }
}
