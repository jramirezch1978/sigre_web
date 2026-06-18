import { Injectable } from '@angular/core';
import { IGestionCatalogoRepository } from '../../domain/repositories/igestion-catalogo.repository';
import { GestionCatalogoStore } from '../../store/gestion-catalogo.store';
import { GestionCatalogoEntity } from '../../domain/models/gestion-catalogo.entity';

@Injectable()
export class ActualizarGestionCatalogoUseCase {
  constructor(
    private repository: IGestionCatalogoRepository,
    private store: GestionCatalogoStore,
  ) {}

  execute(codigo: string, cambios: Partial<GestionCatalogoEntity>): void {
    this.store.setLoadingActualizar(true);
    this.repository.actualizar(codigo, cambios).subscribe({
      next: (result) => this.store.setResultActualizar(result),
      error: (err) => this.store.setErrorActualizar(err?.message ?? 'Error al actualizar documento'),
    });
  }
}
