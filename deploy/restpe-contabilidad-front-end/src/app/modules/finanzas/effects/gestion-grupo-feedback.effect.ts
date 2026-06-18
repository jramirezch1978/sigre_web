import { Injectable, effect, inject } from '@angular/core';
import { GestionGrupoStore } from '../store/gestion-grupo.store';
import { ToastService } from 'src/app/ui/services/toast.service';

@Injectable()
export class GestionGrupoFeedbackEffects {
  private readonly store = inject(GestionGrupoStore);
  private readonly toast = inject(ToastService);

  private readonly guardarExitoEffect = effect(() => {
    const result = this.store.resultGuardar();
    if (result?.success) {
      this.toast.success('¡Grupo registrado exitosamente!');
    }
  });

  private readonly actualizarExitoEffect = effect(() => {
    const result = this.store.resultActualizar();
    if (result?.success) {
      this.toast.success('¡Cambios guardados exitosamente!');
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
}
