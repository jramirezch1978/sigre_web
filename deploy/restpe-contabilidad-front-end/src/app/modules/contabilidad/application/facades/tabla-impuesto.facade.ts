import { Injectable, inject } from '@angular/core';
import { TablaImpuestoStore } from '../../store/tabla-impuesto.store';
import { ObtenerTablaImpuestosUseCase } from '../usecases/obtener-tabla-impuestos.usecase';
import { GuardarTablaImpuestoUseCase } from '../usecases/guardar-tabla-impuesto.usecase';
import { ActualizarTablaImpuestoUseCase } from '../usecases/actualizar-tabla-impuesto.usecase';
import { TablaImpuestoEntity } from '../../domain/models/tabla-impuesto.entity';

@Injectable()
export class TablaImpuestoFacade {

  private readonly store = inject(TablaImpuestoStore);
  private readonly obtenerUC = inject(ObtenerTablaImpuestosUseCase);
  private readonly guardarUC = inject(GuardarTablaImpuestoUseCase);
  private readonly actualizarUC = inject(ActualizarTablaImpuestoUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly items            = this.store.items;
  readonly loadingObtener   = this.store.loadingObtener;
  readonly loadingGuardar   = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly isLoading        = this.store.isLoading;
  readonly errorObtener     = this.store.errorObtener;
  readonly errorGuardar     = this.store.errorGuardar;
  readonly errorActualizar  = this.store.errorActualizar;
  readonly hasError         = this.store.hasError;
  readonly resultGuardar    = this.store.resultGuardar;
  readonly resultActualizar = this.store.resultActualizar;

  // ── Acciones ─────────────────────────────────────────────────────────────

  cargarItems(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: items => {
        this.store.setItems(items);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener impuestos');
      }
    });
  }

  guardarItem(item: TablaImpuestoEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(item).subscribe({
      next: result => {
        this.store.setGuardarResultado(result);
        this.store.setLoadingGuardar(false);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar impuesto');
      }
    });
  }

  actualizarItem(item: TablaImpuestoEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(item).subscribe({
      next: result => {
        this.store.setActualizarResultado(result);
        this.store.setLoadingActualizar(false);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar impuesto');
      }
    });
  }
}
