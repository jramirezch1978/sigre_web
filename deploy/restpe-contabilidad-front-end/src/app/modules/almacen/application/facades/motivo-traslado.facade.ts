import { inject, Injectable } from '@angular/core';
import { GuardarAlmacenMotivoTrasladoUseCase } from '../usecases/guardar-almacen-motivo-traslado.usecase';
import { ObtenerMotivosTrasladoAlmacenesUseCase } from '../usecases/obtener-motivos-traslado-almacen.usecase';
import { MotivoTrasladoStore } from '@modules/almacen/store/motivo-traslado.store';
import { MotivoTrasladoAlmacenEntity } from '@modules/almacen/domain/models/motivo-traslado-almacen.entity';

@Injectable()
export class MotivoTrasladoFacade {
  private readonly store = inject(MotivoTrasladoStore);

  private readonly obtenerUC = inject(ObtenerMotivosTrasladoAlmacenesUseCase);
  private readonly guardarUC = inject(GuardarAlmacenMotivoTrasladoUseCase);
  // ...

  readonly motivos = this.store.motivos;

  readonly motivoSeleccionado = this.store.motivoSeleccionado;
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly loadingActualizar = this.store.loadingActualizar;

  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorEliminar = this.store.errorEliminar;
  readonly errorActualizar = this.store.errorActualizar;

  readonly resultGuardar = this.store.resultGuardar;
  readonly resultEliminar = this.store.resultEliminar;
  readonly resultActualizar = this.store.resultActualizar;
  // ...

  cargarMotivos(): void {
    this.store.setLoadingObtener(true);
    this.obtenerUC.execute().subscribe({
      next: (motivos) => this.store.setMotivos(motivos),
      error: (err) => this.store.setErrorObtener(err.message),
      complete: () => this.store.setLoadingObtener(false),
    });
  }

  guardarMotivo(motivo: MotivoTrasladoAlmacenEntity): void {
    this.store.setLoadingGuardar(true);
    this.guardarUC.execute(motivo).subscribe({
      next: (result) => this.store.setResultGuardar(result),
      error: (err) => this.store.setErrorGuardar(err.message),
      complete: () => this.store.setLoadingGuardar(false),
    });
  }
}
