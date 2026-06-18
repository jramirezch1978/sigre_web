import { Injectable, computed, signal } from '@angular/core';
import { LibrosAsientosState, initialLibrosAsientosState } from './libros-asientos.state';
import { LibroMayorItem, LibroDiarioItem, BalanceComprobItem } from '../domain/models/libros-asientos.entity';

/**
 * LibrosAsientosStore — Store reactivo de señales.
 * Gestiona el estado de cada tipo de reporte de forma independiente.
 */
@Injectable()
export class LibrosAsientosStore {

  private readonly state = signal<LibrosAsientosState>(initialLibrosAsientosState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly libroMayor          = computed(() => this.state().libroMayor);
  readonly libroDiario         = computed(() => this.state().libroDiario);
  readonly balanceComprobacion = computed(() => this.state().balanceComprobacion);

  // ── Selectores de loading ────────────────────────────────────────────────

  readonly loadingLibroMayor     = computed(() => this.state().loadingLibroMayor);
  readonly loadingLibroDiario    = computed(() => this.state().loadingLibroDiario);
  readonly loadingBalanceComprob = computed(() => this.state().loadingBalanceComprob);
  readonly isLoading             = computed(() => this.state().loadingLibroMayor || this.state().loadingLibroDiario || this.state().loadingBalanceComprob);

  // ── Selectores de error ──────────────────────────────────────────────────

  readonly errorLibroMayor     = computed(() => this.state().errorLibroMayor);
  readonly errorLibroDiario    = computed(() => this.state().errorLibroDiario);
  readonly errorBalanceComprob = computed(() => this.state().errorBalanceComprob);
  readonly hasError            = computed(() => !!(this.state().errorLibroMayor || this.state().errorLibroDiario || this.state().errorBalanceComprob));

  // ── Mutaciones Libro Mayor ───────────────────────────────────────────────

  setLoadingLibroMayor(value: boolean): void {
    this.state.update(s => ({ ...s, loadingLibroMayor: value }));
  }

  setLibroMayor(data: LibroMayorItem[]): void {
    this.state.update(s => ({ ...s, libroMayor: data, errorLibroMayor: null, loadingLibroMayor: false }));
  }

  setErrorLibroMayor(error: string | null): void {
    this.state.update(s => ({ ...s, errorLibroMayor: error, loadingLibroMayor: false }));
  }

  // ── Mutaciones Libro Diario ──────────────────────────────────────────────

  setLoadingLibroDiario(value: boolean): void {
    this.state.update(s => ({ ...s, loadingLibroDiario: value }));
  }

  setLibroDiario(data: LibroDiarioItem[]): void {
    this.state.update(s => ({ ...s, libroDiario: data, errorLibroDiario: null, loadingLibroDiario: false }));
  }

  setErrorLibroDiario(error: string | null): void {
    this.state.update(s => ({ ...s, errorLibroDiario: error, loadingLibroDiario: false }));
  }

  // ── Mutaciones Balance Comprobación ──────────────────────────────────────

  setLoadingBalanceComprob(value: boolean): void {
    this.state.update(s => ({ ...s, loadingBalanceComprob: value }));
  }

  setBalanceComprobacion(data: BalanceComprobItem[]): void {
    this.state.update(s => ({ ...s, balanceComprobacion: data, errorBalanceComprob: null, loadingBalanceComprob: false }));
  }

  setErrorBalanceComprob(error: string | null): void {
    this.state.update(s => ({ ...s, errorBalanceComprob: error, loadingBalanceComprob: false }));
  }

  resetState(): void {
    this.state.set(initialLibrosAsientosState);
  }
}
