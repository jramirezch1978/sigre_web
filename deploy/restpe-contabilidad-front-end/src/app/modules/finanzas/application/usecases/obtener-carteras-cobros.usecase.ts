import { Injectable, inject } from '@angular/core';
import { ICarterasCobrosRepository } from '../../domain/repositories/icarteras-cobros.repository';
import { CarterasCobrosStore } from '../../store/carteras-cobros.store';

@Injectable()
export class ObtenerCarterasCobrosUseCase {
  private readonly repo = inject(ICarterasCobrosRepository);
  private readonly store = inject(CarterasCobrosStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setCobros(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener carteras de cobros');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
