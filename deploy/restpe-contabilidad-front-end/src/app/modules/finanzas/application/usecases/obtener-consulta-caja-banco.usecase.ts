import { Injectable, inject } from '@angular/core';
import { IConsultaCajaBancoRepository } from '../../domain/repositories/iconsulta-caja-banco.repository';
import { ConsultaCajaBancoStore } from '../../store/consulta-caja-banco.store';

@Injectable()
export class ObtenerConsultaCajaBancoUseCase {
  private readonly repo = inject(IConsultaCajaBancoRepository);
  private readonly store = inject(ConsultaCajaBancoStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setCuentas(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener cuentas de caja y banco');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
