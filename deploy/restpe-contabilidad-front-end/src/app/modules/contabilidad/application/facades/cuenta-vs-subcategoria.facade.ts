import { Injectable, inject } from '@angular/core';
import { CuentaVsSubcategoriaStore } from '../../store/cuenta-vs-subcategoria.store';
import { CuentaVsSubcategoriaEntity } from '../../domain/models/cuenta-vs-subcategoria.entity';
import {
  ObtenerCuentasVsSubcategoriasUseCase,
  ActualizarCuentaVsSubcategoriaUseCase,
} from '../usecases';

@Injectable()
export class CuentaVsSubcategoriaFacade {

  private readonly store = inject(CuentaVsSubcategoriaStore);

  private readonly obtenerUC = inject(ObtenerCuentasVsSubcategoriasUseCase);
  private readonly actualizarUC = inject(ActualizarCuentaVsSubcategoriaUseCase);

  // ── Selectores expuestos al componente ───────────────────────────────────

  readonly items = this.store.items;
  readonly itemSeleccionado = this.store.itemSeleccionado;

  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  readonly errorObtener = this.store.errorObtener;
  readonly errorActualizar = this.store.errorActualizar;

  readonly resultActualizar = this.store.resultActualizar;

  // ── Métodos de orquestación ──────────────────────────────────────────────

  cargarItems(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setItems(items);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message || 'Error al cargar relaciones cuenta-subcategoría');
      },
      complete: () => {
        this.store.setLoadingObtener(false);
      }
    });
  }

  actualizarItem(item: CuentaVsSubcategoriaEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(item).subscribe({
      next: (result) => {
        this.store.setActualizarResultado(result);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message || 'Error al actualizar relación cuenta-subcategoría');
      },
      complete: () => {
        this.store.setLoadingActualizar(false);
      }
    });
  }
}
