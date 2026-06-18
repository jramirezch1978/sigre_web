import { Injectable } from '@angular/core';
import { IGestionCatalogoRepository } from '../../domain/repositories/igestion-catalogo.repository';
import { GestionCatalogoStore } from '../../store/gestion-catalogo.store';

@Injectable()
export class ObtenerGestionCatalogoUseCase {
  constructor(
    private repository: IGestionCatalogoRepository,
    private store: GestionCatalogoStore,
  ) {}

  execute(): void {
    this.store.setLoadingObtener(true);
    this.repository.obtenerTodos().subscribe({
      next: (documentos) => this.store.setDocumentos(documentos),
      error: (err) => this.store.setErrorObtener(err?.message ?? 'Error al obtener documentos'),
    });
  }
}
