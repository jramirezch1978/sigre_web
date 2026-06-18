import { Injectable, inject } from '@angular/core';
import {
  ObtenerFacturacionRegaliasUseCase,
  GuardarFacturacionRegaliasUseCase,
  AnularFacturacionRegaliasUseCase,
} from '../usecases';
import { FacturacionRegaliasEntity } from '../../domain/models/facturacion-regalias.entity';
import { FacturacionRegaliasStore } from '../../store/facturacion-regalias.store';

@Injectable()
export class FacturacionRegaliasFacade {

  private readonly store = inject(FacturacionRegaliasStore);

  private readonly obtenerUC = inject(ObtenerFacturacionRegaliasUseCase);
  private readonly guardarUC = inject(GuardarFacturacionRegaliasUseCase);
  private readonly anularUC = inject(AnularFacturacionRegaliasUseCase);

  // Selectores
  readonly facturas = this.store.facturas;
  readonly facturaSeleccionada = this.store.facturaSeleccionada;

  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingAnular = this.store.loadingAnular;

  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorAnular = this.store.errorAnular;

  readonly resultGuardar = this.store.resultGuardar;
  readonly resultAnular = this.store.resultAnular;

  cargarFacturas(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: (facturas) => {
        this.store.setFacturas(facturas);
      },
      error: (err) => {
        this.store.setErrorObtener(err.message || 'Error al cargar facturas de regalías');
      },
      complete: () => {
        this.store.setLoadingObtener(false);
      }
    });
  }

  guardarFactura(factura: FacturacionRegaliasEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(factura).subscribe({
      next: (result) => {
        this.store.setGuardarResultado(result);
      },
      error: (err) => {
        this.store.setErrorGuardar(err.message || 'Error al guardar la factura de regalía');
      },
      complete: () => {
        this.store.setLoadingGuardar(false);
      }
    });
  }

  anularFactura(codigo: string, motivo: string): void {
    this.store.setLoadingAnular(true);

    this.anularUC.execute(codigo, motivo).subscribe({
      next: (result) => {
        this.store.setAnularResultado(result);
      },
      error: (err) => {
        this.store.setErrorAnular(err.message || 'Error al anular la factura de regalía');
      },
      complete: () => {
        this.store.setLoadingAnular(false);
      }
    });
  }

  seleccionarFactura(factura: FacturacionRegaliasEntity | null): void {
    this.store.setFacturaSeleccionada(factura);
  }

  limpiarErrores(): void {
    this.store.clearErrors();
  }

  resetState(): void {
    this.store.resetState();
  }
}
