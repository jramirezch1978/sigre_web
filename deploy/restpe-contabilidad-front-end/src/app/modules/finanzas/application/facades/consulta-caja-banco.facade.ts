import { Injectable, inject } from '@angular/core';
import { ConsultaCajaBancoStore } from '../../store/consulta-caja-banco.store';
import { ObtenerConsultaCajaBancoUseCase } from '../usecases/obtener-consulta-caja-banco.usecase';

@Injectable()
export class ConsultaCajaBancoFacade {
  private readonly store = inject(ConsultaCajaBancoStore);
  private readonly obtenerUC = inject(ObtenerConsultaCajaBancoUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly cuentas = this.store.cuentas;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
