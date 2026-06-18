import { Injectable, inject } from '@angular/core';
import { ICerrarLiqAdelantosRepository } from '../../domain/repositories/icerrar-liq-adelantos.repository';
import { CerrarLiqAdelantosStore } from '../../store/cerrar-liq-adelantos.store';

@Injectable()
export class ObtenerCerrarLiqAdelantosUseCase {
  private readonly repo = inject(ICerrarLiqAdelantosRepository);
  private readonly store = inject(CerrarLiqAdelantosStore);

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
