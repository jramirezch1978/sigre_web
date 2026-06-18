import { Injectable, inject } from '@angular/core';
import { IMovCuentasBancYCajasRepository } from '../../domain/repositories/imov-cuentas-banc-y-cajas.repository';
import { MovCuentasBancYCajasStore } from '../../store/mov-cuentas-banc-y-cajas.store';

@Injectable()
export class ObtenerMovCuentasBancYCajasUseCase {
  private readonly repo = inject(IMovCuentasBancYCajasRepository);
  private readonly store = inject(MovCuentasBancYCajasStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setMovimientos(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener movimientos entre cuentas bancarias y cajas');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
