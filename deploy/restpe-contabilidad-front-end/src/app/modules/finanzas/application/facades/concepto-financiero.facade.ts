import { Injectable, inject } from '@angular/core';
import { ConceptoFinancieroStore } from '../../store/concepto-financiero.store';
import { ObtenerConceptoFinancieroUseCase } from '../usecases/obtener-concepto-financiero.usecase';
import { GuardarConceptoFinancieroUseCase } from '../usecases/guardar-concepto-financiero.usecase';
import { ActualizarConceptoFinancieroUseCase } from '../usecases/actualizar-concepto-financiero.usecase';
import { EliminarConceptoFinancieroUseCase } from '../usecases/eliminar-concepto-financiero.usecase';
import { ConceptoFinancieroEntity } from '../../domain/models/concepto-financiero.entity';

@Injectable()
export class ConceptoFinancieroFacade {

  private readonly store        = inject(ConceptoFinancieroStore);
  private readonly obtenerUC    = inject(ObtenerConceptoFinancieroUseCase);
  private readonly guardarUC    = inject(GuardarConceptoFinancieroUseCase);
  private readonly actualizarUC = inject(ActualizarConceptoFinancieroUseCase);
  private readonly eliminarUC   = inject(EliminarConceptoFinancieroUseCase);

  // Selectores
  readonly conceptos         = this.store.conceptos;
  readonly isLoading         = this.store.isLoading;
  readonly loadingObtener    = this.store.loadingObtener;
  readonly loadingGuardar    = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly hasError          = this.store.hasError;
  readonly errorObtener      = this.store.errorObtener;
  readonly errorGuardar      = this.store.errorGuardar;
  readonly errorActualizar   = this.store.errorActualizar;
  readonly resultGuardar     = this.store.resultGuardar;
  readonly resultActualizar  = this.store.resultActualizar;
  readonly resultEliminar    = this.store.resultEliminar;
  readonly errorEliminar     = this.store.errorEliminar;

  cargarConceptos(): void {
    this.store.setLoadingObtener(true);
    this.obtenerUC.execute().subscribe({
      next:     (conceptos) => this.store.setConceptos(conceptos),
      error:    (err)       => this.store.setErrorObtener(err.message || 'Error al cargar conceptos financieros'),
      complete: ()          => this.store.setLoadingObtener(false),
    });
  }

  guardarConcepto(concepto: Partial<ConceptoFinancieroEntity>): void {
    this.store.setLoadingGuardar(true);
    this.guardarUC.execute(concepto).subscribe({
      next: (result) => {
        this.store.addConcepto(result as ConceptoFinancieroEntity);
        this.store.setResultGuardar(result);
      },
      error: (err) =>
        this.store.setErrorGuardar(
          err.message || 'Error al guardar el concepto financiero',
        ),
      complete: () => this.store.setLoadingGuardar(false),
    });
  }

  actualizarConcepto(
    codigo: string,
    cambios: Partial<ConceptoFinancieroEntity>,
  ): void {
    this.store.setLoadingActualizar(true);
    this.actualizarUC.execute(codigo, cambios).subscribe({
      next: (result) => this.store.setResultActualizar(result),
      error: (err) =>
        this.store.setErrorActualizar(
          err.message || 'Error al actualizar el concepto financiero',
        ),
      complete: () => this.store.setLoadingActualizar(false),
    });
  }

  eliminarConcepto(id: number, codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.eliminarUC.execute(id).subscribe({
      next: (result) => {
        if (result.success) {
          this.store.removeConcepto(codigo);
        }
        this.store.setResultEliminar(result);
      },
      error:    (err) => this.store.setErrorEliminar(err.message || 'Error al eliminar el concepto financiero'),
      complete: ()    => this.store.setLoadingEliminar(false),
    });
  }

  limpiarErrores(): void {
    this.store.clearErrors();
  }

  limpiarStates(): void {
    this.store.clearStates();
  }

  resetState(): void {
    this.store.resetState();
  }
}
