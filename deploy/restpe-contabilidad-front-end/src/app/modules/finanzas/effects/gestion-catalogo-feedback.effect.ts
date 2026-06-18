import { Injectable, effect, inject } from '@angular/core';
import { GestionCatalogoStore } from '../store/gestion-catalogo.store';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class GestionCatalogoFeedbackEffects {
  private readonly store = inject(GestionCatalogoStore);
  private readonly toast = inject(ToastService);

  private readonly guardarExitoEffect = effect(() => {
    const result = this.store.resultGuardar();
    if (result?.success) {
      this.toast.success('¡Documento registrado exitosamente!');
    }
  });

  private readonly actualizarExitoEffect = effect(() => {
    const result = this.store.resultActualizar();
    if (result?.success) {
      this.toast.success('¡Documento actualizado exitosamente!');
    }
  });

  private readonly errorObtenerEffect = effect(() => {
    const error = this.store.errorObtener();
    if (error) {
      this.toast.danger(error);
      this.store.setErrorObtener(null);
    }
  });

  private readonly errorGuardarEffect = effect(() => {
    const error = this.store.errorGuardar();
    if (error) {
      this.toast.danger(error);
      this.store.setErrorGuardar(null);
    }
  });

  private readonly errorActualizarEffect = effect(() => {
    const error = this.store.errorActualizar();
    if (error) {
      this.toast.danger(error);
      this.store.setErrorActualizar(null);
    }
  });

  private readonly eliminarExitoEffect = effect(() => {
    const result = this.store.resultEliminar();
    if (result?.success) {
      this.toast.success('¡Documento eliminado exitosamente!');
      this.store.setResultEliminar(null);
    }
  });

  private readonly errorEliminarEffect = effect(() => {
    const error = this.store.errorEliminar();
    if (error) {
      this.toast.danger(error);
      this.store.setErrorEliminar(null);
    }
  });
}
