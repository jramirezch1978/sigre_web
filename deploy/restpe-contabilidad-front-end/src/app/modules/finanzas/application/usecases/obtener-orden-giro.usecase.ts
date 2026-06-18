import { Injectable, inject } from '@angular/core';
import { IOrdenGiroRepository, OrdenGiroFiltros } from '../../domain/repositories/iorden-giro.repository';
import { OrdenGiroStore } from '../../store/orden-giro.store';

@Injectable()
export class ObtenerOrdenGiroUseCase {
  private readonly repo = inject(IOrdenGiroRepository);
  private readonly store = inject(OrdenGiroStore);

  execute(filtros?: OrdenGiroFiltros): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos(filtros).subscribe({
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
