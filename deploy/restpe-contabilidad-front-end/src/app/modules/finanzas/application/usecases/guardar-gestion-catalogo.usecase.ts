import { Injectable } from '@angular/core';
import { IGestionCatalogoRepository } from '../../domain/repositories/igestion-catalogo.repository';
import { GestionCatalogoStore } from '../../store/gestion-catalogo.store';
import { GestionCatalogoEntity } from '../../domain/models/gestion-catalogo.entity';

@Injectable()
export class GuardarGestionCatalogoUseCase {
  constructor(
    private repository: IGestionCatalogoRepository,
    private store: GestionCatalogoStore,
  ) {}

  execute(documento: Partial<GestionCatalogoEntity>): void {
    this.store.setLoadingGuardar(true);
    this.repository.guardar(documento).subscribe({
      next: (result) => this.store.setResultGuardar(result),
      error: (err) => this.store.setErrorGuardar(err?.message ?? 'Error al guardar documento'),
    });
  }
}
