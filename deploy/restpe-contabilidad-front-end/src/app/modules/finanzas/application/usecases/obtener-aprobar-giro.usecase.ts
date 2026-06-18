import { Injectable, inject } from '@angular/core';
import { IAprobarGiroRepository } from '../../domain/repositories/iaprobar-giro.repository';
import { AprobarGiroStore } from '../../store/aprobar-giro.store';

@Injectable()
export class ObtenerAprobarGiroUseCase {
  private readonly repo = inject(IAprobarGiroRepository);
  private readonly store = inject(AprobarGiroStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setOrdenes(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener órdenes de giro');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
