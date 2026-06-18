import { Injectable, effect, inject } from '@angular/core';
import { GestionGrupoStore } from '../store/gestion-grupo.store';
import { GestionGrupoFacade } from '../application/facades/gestion-grupo.facade';

@Injectable()
export class GestionGrupoSyncEffects {
  private readonly store = inject(GestionGrupoStore);
  private readonly facade = inject(GestionGrupoFacade);

  private readonly recargarTrasGuardarEffect = effect(() => {
    const result = this.store.resultGuardar();
    if (result?.success) {
      this.store.setResultGuardar(null);
      this.facade.cargarGrupos();
    }
  });

  private readonly recargarTrasActualizarEffect = effect(() => {
    const result = this.store.resultActualizar();
    if (result?.success) {
      this.store.setResultActualizar(null);
      this.facade.cargarGrupos();
    }
  });
}
