import { Injectable, inject } from '@angular/core';
import { CarterasCobrosStore } from '../../store/carteras-cobros.store';
import { ObtenerCarterasCobrosUseCase } from '../usecases/obtener-carteras-cobros.usecase';
import { ActualizarCarterasCobrosUseCase } from '../usecases/actualizar-carteras-cobros.usecase';
import { CarterasCobrosEntity } from '../../domain/models/carteras-cobros.entity';

@Injectable()
export class CarterasCobrosFacade {
  private readonly store = inject(CarterasCobrosStore);
  private readonly obtenerUC = inject(ObtenerCarterasCobrosUseCase);
  private readonly actualizarUC = inject(ActualizarCarterasCobrosUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly cobros = this.store.cobros;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorActualizar = this.store.errorActualizar;
  readonly actualizadoOk = this.store.actualizadoOk;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  actualizar(entity: CarterasCobrosEntity): void {
    this.actualizarUC.execute(entity);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorActualizar(null);
  }

  limpiarExito(): void {
    this.store.setActualizadoOk(false);
  }

  resetState(): void {
    this.store.reset();
  }
}
