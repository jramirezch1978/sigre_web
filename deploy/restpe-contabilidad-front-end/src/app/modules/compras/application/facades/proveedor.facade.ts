import { Injectable, inject } from '@angular/core';
import {
  ObtenerProveedoresUseCase,
  GuardarProveedorUseCase,
  ActualizarProveedorUseCase,
  EliminarProveedorUseCase
} from '../usecases';
import { ProveedorEntity } from '../../domain/models/proveedor.entity';
import { ProveedorStore } from '../../store/proveedor.store';
import { ProveedorFiltro } from '../../domain/repositories/iproveedor.repository';

@Injectable()
export class ProveedorFacade {

  private readonly store = inject(ProveedorStore);

  private readonly obtenerUC = inject(ObtenerProveedoresUseCase);
  private readonly guardarUC = inject(GuardarProveedorUseCase);
  private readonly actualizarUC = inject(ActualizarProveedorUseCase);
  private readonly eliminarUC = inject(EliminarProveedorUseCase);

  // Selectores de proveedores
  readonly proveedores = this.store.proveedores;
  readonly proveedorSeleccionado = this.store.proveedorSeleccionado;

  // Selectores de loading
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly loadingActualizar = this.store.loadingActualizar;

  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  // Selectores de errores
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorEliminar = this.store.errorEliminar;
  readonly errorActualizar = this.store.errorActualizar;

  // Selectores de resultados
  readonly resultGuardar = this.store.resultGuardar;
  readonly resultEliminar = this.store.resultEliminar;
  readonly resultActualizar = this.store.resultActualizar;

  cargarProveedores(filtros?: ProveedorFiltro): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute(filtros).subscribe({
      next: (proveedores) => {
        
        this.store.setProveedores(proveedores);
      },
      error: (err) => {
        this.store.setErrorObtener(err.message || 'Error al cargar proveedores');
      },
      complete: () => {
        this.store.setLoadingObtener(false);
      }
    });
  }

  guardarProveedor(proveedor: ProveedorEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(proveedor).subscribe({
      next: (result) => {
        this.store.setGuardarResultado(result);
      },
      error: (err) => {
        this.store.setErrorGuardar(err.message || 'Error al guardar proveedor');
      },
      complete: () => {
        this.store.setLoadingGuardar(false);
      }
    });
  }

  actualizarProveedor(proveedor: ProveedorEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(proveedor).subscribe({
      next: (result) => {
        this.store.setActualizarResultado(result);
      },
      error: (err) => {
        this.store.setErrorActualizar(err.message || 'Error al actualizar proveedor');
      },
      complete: () => {
        this.store.setLoadingActualizar(false);
      }
    });
  }

  eliminarProveedor(codigo: string): void {
    this.store.setLoadingEliminar(true);

    this.eliminarUC.execute(codigo).subscribe({
      next: (result) => {
        this.store.setEliminarResultado(result);
      },
      error: (err) => {
        this.store.setErrorEliminar(err.message || 'Error al eliminar proveedor');
      },
      complete: () => {
        this.store.setLoadingEliminar(false);
      }
    });
  }

  seleccionarProveedor(proveedor: ProveedorEntity | null): void {
    this.store.setProveedorSeleccionado(proveedor);
  }

  resetErrors(): void {
    this.store.resetErrors();
  }

  resetResults(): void {
    this.store.resetResults();
  }
}
