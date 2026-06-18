import { Injectable, inject } from '@angular/core';
import { RegistroFacturaStore } from '../../store/registro-factura.store';
import { ObtenerRegistroFacturaUseCase } from '../usecases/obtener-registro-factura.usecase';
import { GuardarRegistroFacturaUseCase } from '../usecases/guardar-registro-factura.usecase';
import { ActualizarRegistroFacturaUseCase } from '../usecases/actualizar-registro-factura.usecase';
import { RegistroFacturaEntity } from '../../domain/models/registro-factura.entity';

@Injectable()
export class RegistroFacturaFacade {
  private readonly store = inject(RegistroFacturaStore);
  private readonly obtenerUC = inject(ObtenerRegistroFacturaUseCase);
  private readonly guardarUC = inject(GuardarRegistroFacturaUseCase);
  private readonly actualizarUC = inject(ActualizarRegistroFacturaUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly facturas = this.store.facturas;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarFacturas(): void {
    this.obtenerUC.execute();
  }

  guardarFactura(factura: RegistroFacturaEntity): void {
    this.guardarUC.execute(factura);
  }

  actualizarFactura(factura: RegistroFacturaEntity): void {
    this.actualizarUC.execute(factura);
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
