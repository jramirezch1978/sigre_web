import { Injectable } from '@angular/core';
import { GestionGrupoStore } from '../../store/gestion-grupo.store';
import { ObtenerGestionGrupoUseCase } from '../usecases/obtener-gestion-grupo.usecase';
import { GuardarGestionGrupoUseCase } from '../usecases/guardar-gestion-grupo.usecase';
import { ActualizarGestionGrupoUseCase } from '../usecases/actualizar-gestion-grupo.usecase';
import { GestionGrupoEntity } from '../../domain/models/gestion-grupo.entity';

@Injectable()
export class GestionGrupoFacade {
  // Selectores
  readonly grupos = this.store.grupos;
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly resultGuardar = this.store.resultGuardar;
  readonly resultActualizar = this.store.resultActualizar;

  constructor(
    private store: GestionGrupoStore,
    private obtenerUseCase: ObtenerGestionGrupoUseCase,
    private guardarUseCase: GuardarGestionGrupoUseCase,
    private actualizarUseCase: ActualizarGestionGrupoUseCase,
  ) {}

  cargarGrupos(): void {
    this.obtenerUseCase.execute();
  }

  guardarGrupo(grupo: Partial<GestionGrupoEntity>): void {
    this.guardarUseCase.execute(grupo);
  }

  actualizarGrupo(codigo: string, cambios: Partial<GestionGrupoEntity>): void {
    this.actualizarUseCase.execute(codigo, cambios);
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
