import { Injectable, inject } from '@angular/core';
import { RazonSocialStore } from '../../store/razon-social.store';
import { ObtenerRazonesSocialesUseCase } from '../usecases/obtener-razones-sociales.usecase';
import { RazonSocialEntity } from '../../domain/models/razon-social.entity';

@Injectable({ providedIn: 'root' })
export class RazonSocialFacade {
  private readonly store = inject(RazonSocialStore);
  private readonly obtenerRazonesUC = inject(ObtenerRazonesSocialesUseCase);

  // Selectores
  readonly razones = this.store.razones;
  readonly seleccionada = this.store.seleccionada;
  readonly loading = this.store.loading;
  readonly error = this.store.error;

  cargarRazonesSociales(): void {
    this.store.setLoading(true);
    this.obtenerRazonesUC.execute().subscribe({
      next: (razones) => {
        this.store.setRazones(razones);
        // por ahora estoy seleccionando la primera, hasta que se conecte el flujo desde el login  
        if (!this.store.seleccionada() && razones.length > 0) {
          this.store.setSeleccionada(razones[0]);
        }
      },
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar razones sociales'),
      complete: () => this.store.setLoading(false),
    });
  }

  seleccionarRazon(razon: RazonSocialEntity): void {
    this.store.setSeleccionada(razon);
  }

  limpiarError(): void {
    this.store.setError(null);
  }

  resetState(): void {
    this.store.resetState();
  }
}
