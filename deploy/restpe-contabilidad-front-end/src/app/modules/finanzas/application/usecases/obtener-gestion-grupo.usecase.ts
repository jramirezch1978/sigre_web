import { Injectable } from '@angular/core';
import { IGestionGrupoRepository } from '../../domain/repositories/igestion-grupo.repository';
import { GestionGrupoStore } from '../../store/gestion-grupo.store';

@Injectable()
export class ObtenerGestionGrupoUseCase {
  constructor(
    private repository: IGestionGrupoRepository,
    private store: GestionGrupoStore,
  ) {}

  execute(): void {
    this.store.setLoadingObtener(true);
    this.repository.obtenerTodos().subscribe({
      next: (grupos) => this.store.setGrupos(grupos),
      error: (err) => this.store.setErrorObtener(err?.message ?? 'Error al obtener grupos'),
    });
  }
}
