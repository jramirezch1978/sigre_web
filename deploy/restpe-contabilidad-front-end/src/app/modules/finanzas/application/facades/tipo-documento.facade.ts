import { computed, inject, Injectable, Signal } from '@angular/core';
import { ObtenerTiposDocumentoUseCase } from '../usecases/obtener-tipo.documento.usecase';
import { TipoDocumentoStore } from '../../store/tipo-documento.store';
import { GuardarTipoDocumentoUseCase } from '../usecases/guardar-tipo-documento.usecase';
import { EliminarTipoDocumentoUseCase } from '../usecases/eliminar-tipo-documento.usecase';
import { ActualizarTipoDocumentoUseCase } from '../usecases/actualizar-tipo-documento.usecase';
import { TipoDocumentoEntity } from '@modules/finanzas/domain/models/tipo-documento.entity';
import { switchMap } from 'rxjs';
import { SunatTipoDocumentoFacade } from './sunat-tipo-documento.facade';

@Injectable()
export class TipoDocumentoFacade {
  private readonly store = inject(TipoDocumentoStore);

  private readonly obtenerUC = inject(ObtenerTiposDocumentoUseCase);
  private readonly guardarUC = inject(GuardarTipoDocumentoUseCase);
  private readonly eliminarUC = inject(EliminarTipoDocumentoUseCase);
  private readonly actualizarUC = inject(ActualizarTipoDocumentoUseCase);

  private readonly sunatTipoFacade = inject(SunatTipoDocumentoFacade);

  readonly tiposDocumentoRaw = this.store.tiposDocumento;

  readonly tipoDocumentoSeleccionado = this.store.tipoDocumentoSeleccionado;
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

  readonly tiposDocumento: Signal<TipoDocumentoEntity[]> = computed(() => {
    const puros = this.tiposDocumentoRaw();
    const sunat = this.sunatTipoFacade.tiposDocumentoActivos();

    if (!puros || puros.length === 0) return [];
    if (!sunat || sunat.length === 0) return puros;

    const data = puros.map((tipoDoc) => ({
      ...tipoDoc,
      sunatCatalogoTipoDocumento:
        sunat.find(
          (s) => String(s.codigoItem) === String(tipoDoc.sunatCodigo),
        ) || null,
    }));
    return data;
  });

  cargarTiposDocumento(): void {
    this.store.setLoadingObtener(true);
    this.obtenerUC.execute().subscribe({
      next: (tiposDocumento) => this.store.setTiposDocumento(tiposDocumento),
      error: (err) => this.store.setErrorObtener(err.message),
      complete: () => this.store.setLoadingObtener(false),
    });
  }

  guardarTipoDocumento(tipoDocumento: TipoDocumentoEntity): void {
    this.store.setLoadingGuardar(true);
    this.guardarUC.execute(tipoDocumento).subscribe({
      next: (result) => {
        this.store.setResultGuardar(result);
        this.cargarTiposDocumento();
      },
      error: (err) => this.store.setErrorGuardar(err.message),
      complete: () => this.store.setLoadingGuardar(false),
    });
  }

  actualizarTipoDocumento(
    id: number,
    tipoDocumento: TipoDocumentoEntity,
  ): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC
      .execute(id, tipoDocumento)
      // .pipe(
      //   switchMap((resultPut) => {
      //     const nuevoEstado = tipoDocumento.flagEstado;

      //     return this.actualizarUC.executeEstado(id, nuevoEstado);
      //   }),
      // )
      .subscribe({
        next: (result) => {
          this.store.setResultActualizar(result);
          this.cargarTiposDocumento();
        },
        error: (err) => this.store.setErrorActualizar(err.message),
        complete: () => this.store.setLoadingActualizar(false),
      });
  }

  eliminarTipoDocumento(id: number): void {
    this.store.setLoadingEliminar(true);
    this.eliminarUC.execute(id).subscribe({
      next: () => {
        this.store.setResultEliminar(true);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err.message);
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
