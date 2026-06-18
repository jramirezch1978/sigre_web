import { Injectable, computed, inject } from '@angular/core';
import { ReporteFinancieroStore } from '../../store/reporte-financiero.store';
import { ObtenerReporteFinancieroUseCase } from '../usecases/obtener-reporte-financiero.usecase';

/**
 * ReporteFinancieroFacade — Fachada de aplicación.
 * Punto único de entrada para el componente: orquesta el caso de uso y expone los signals del store.
 */
@Injectable()
export class ReporteFinancieroFacade {

  private readonly store     = inject(ReporteFinancieroStore);
  private readonly obtenerUC = inject(ObtenerReporteFinancieroUseCase);

  // Signals expuestos al componente
  readonly rowData          = computed(() => this.store.situacionFinanciera());
  readonly rowDataResultados = computed(() => this.store.estadoResultados());
  readonly rowDataFlujos    = computed(() => this.store.flujoEfectivo());
  readonly rowDataPatrimonio = computed(() => this.store.cambiosPatrimonio());
  readonly isLoading         = computed(() => this.store.isLoading());
  readonly errorObtener      = computed(() => this.store.errorObtener());

  /**
   * Carga los cuatro datasets financieros para el país indicado.
   * @param pais Código de país: 'PE', 'EC', 'CO', 'GT'
   */
  cargarDatos(pais: string): void {
    this.store.setLoading(true);
    this.obtenerUC.execute(pais).subscribe({
      next:  (completo) => this.store.setData(completo),
      error: (err)      => this.store.setError(err?.message ?? 'Error al obtener el reporte financiero'),
    });
  }
}
