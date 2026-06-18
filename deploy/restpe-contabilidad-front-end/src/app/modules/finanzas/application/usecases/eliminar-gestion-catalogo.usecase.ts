import { Injectable } from '@angular/core';
import { IGestionCatalogoRepository } from '../../domain/repositories/igestion-catalogo.repository';
import { GestionCatalogoStore } from '../../store/gestion-catalogo.store';

@Injectable()
export class EliminarGestionCatalogoUseCase {
  constructor(
    private repository: IGestionCatalogoRepository,
    private store: GestionCatalogoStore,
  ) {}

  /** Elimina por id (backend) y, si tiene éxito, quita la fila del store por código. */
  execute(id: number, codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.repository.eliminar(id).subscribe({
      next: (result) => {
        if (result.success) {
          this.store.removeDocumento(codigo);
        }
        this.store.setResultEliminar(result);
      },
      error: (err) => this.store.setErrorEliminar(err?.message ?? 'Error al eliminar documento'),
    });
  }
}
