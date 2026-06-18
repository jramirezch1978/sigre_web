import { Injectable, inject } from '@angular/core';
import { ILetraCambioRepository } from '../../domain/repositories/iletra-cambio.repository';
import { LetraCambioStore } from '../../store/letra-cambio.store';


@Injectable()
export class ObtenerLetraCambioUseCase {
  private readonly repo = inject(ILetraCambioRepository);
  private readonly store = inject(LetraCambioStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.repo.obtenerTodos().subscribe({
      next: letras => this.store.setLetras(letras),
      error: err => this.store.setErrorObtener(err?.message ?? 'Error al obtener letras de cambio'),
    });
  }
}
