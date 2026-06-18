import { Injectable } from '@angular/core';
import { GestionCatalogoStore } from '../../store/gestion-catalogo.store';
import { ObtenerGestionCatalogoUseCase } from '../usecases/obtener-gestion-catalogo.usecase';
import { GuardarGestionCatalogoUseCase } from '../usecases/guardar-gestion-catalogo.usecase';
import { ActualizarGestionCatalogoUseCase } from '../usecases/actualizar-gestion-catalogo.usecase';
import { EliminarGestionCatalogoUseCase } from '../usecases/eliminar-gestion-catalogo.usecase';
import { GestionCatalogoEntity } from '../../domain/models/gestion-catalogo.entity';

@Injectable()
export class GestionCatalogoFacade {
  // Selectores
  readonly documentos = this.store.documentos;
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly resultGuardar = this.store.resultGuardar;
  readonly resultActualizar = this.store.resultActualizar;
  readonly resultEliminar = this.store.resultEliminar;
  readonly errorEliminar = this.store.errorEliminar;

  constructor(
    private store: GestionCatalogoStore,
    private obtenerUseCase: ObtenerGestionCatalogoUseCase,
    private guardarUseCase: GuardarGestionCatalogoUseCase,
    private actualizarUseCase: ActualizarGestionCatalogoUseCase,
    private eliminarUseCase: EliminarGestionCatalogoUseCase,
  ) {}

  cargarDocumentos(): void {
    this.obtenerUseCase.execute();
  }

  guardarDocumento(documento: Partial<GestionCatalogoEntity>): void {
    this.guardarUseCase.execute(documento);
  }

  actualizarDocumento(codigo: string, cambios: Partial<GestionCatalogoEntity>): void {
    this.actualizarUseCase.execute(codigo, cambios);
  }

  eliminarDocumento(id: number, codigo: string): void {
    this.eliminarUseCase.execute(id, codigo);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
  }

  resetState(): void {
    this.store.resetState();
  }
}
