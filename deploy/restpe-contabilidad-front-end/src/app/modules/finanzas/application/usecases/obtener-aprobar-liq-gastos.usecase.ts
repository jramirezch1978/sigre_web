import { Injectable, inject } from '@angular/core';
import { IAprobarLiqGastosRepository } from '../../domain/repositories/iaprobar-liq-gastos.repository';
import { AprobarLiqGastosStore } from '../../store/aprobar-liq-gastos.store';

@Injectable()
export class ObtenerAprobarLiqGastosUseCase {
  private readonly repo = inject(IAprobarLiqGastosRepository);
  private readonly store = inject(AprobarLiqGastosStore);

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
