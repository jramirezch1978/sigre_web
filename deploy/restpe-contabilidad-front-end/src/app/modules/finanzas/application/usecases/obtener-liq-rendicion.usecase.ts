import { Injectable, inject } from '@angular/core';
import { ILiqRendicionRepository } from '../../domain/repositories/iliq-rendicion.repository';
import { LiqRendicionStore } from '../../store/liq-rendicion.store';

@Injectable()
export class ObtenerLiqRendicionUseCase {
  private readonly repo = inject(ILiqRendicionRepository);
  private readonly store = inject(LiqRendicionStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setLiquidaciones(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener liquidaciones');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
