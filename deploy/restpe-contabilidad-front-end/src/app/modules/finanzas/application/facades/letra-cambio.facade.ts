import { Injectable, inject } from '@angular/core';
import { LetraCambioStore } from '../../store/letra-cambio.store';
import { ObtenerLetraCambioUseCase } from '../usecases/obtener-letra-cambio.usecase';
import { GuardarLetraCambioUseCase } from '../usecases/guardar-letra-cambio.usecase';
import { ActualizarLetraCambioUseCase } from '../usecases/actualizar-letra-cambio.usecase';
import { LetraCambioEntity } from '../../domain/models/letra-cambio.entity';

@Injectable()
export class LetraCambioFacade {
  private readonly store = inject(LetraCambioStore);
  private readonly obtenerUC = inject(ObtenerLetraCambioUseCase);
  private readonly guardarUC = inject(GuardarLetraCambioUseCase);
  private readonly actualizarUC = inject(ActualizarLetraCambioUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly letras = this.store.letras;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarLetras(): void {
    this.obtenerUC.execute();
  }

  guardarLetra(letra: LetraCambioEntity): void {
    this.guardarUC.execute(letra);
  }

  actualizarLetra(letra: LetraCambioEntity): void {
    this.actualizarUC.execute(letra);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
