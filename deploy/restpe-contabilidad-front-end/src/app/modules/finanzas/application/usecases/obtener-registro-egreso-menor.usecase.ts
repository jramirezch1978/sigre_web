import { Injectable, inject } from '@angular/core';
import { IRegistroEgresoMenorRepository } from '../../domain/repositories/iregistro-egreso-menor.repository';
import { RegistroEgresoMenorStore } from '../../store/registro-egreso-menor.store';

@Injectable()
export class ObtenerRegistroEgresoMenorUseCase {
  private readonly repo = inject(IRegistroEgresoMenorRepository);
  private readonly store = inject(RegistroEgresoMenorStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setMovimientos(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los registros de egreso menor');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
