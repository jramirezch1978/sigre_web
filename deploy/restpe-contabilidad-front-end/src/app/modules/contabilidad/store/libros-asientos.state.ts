import { LibroMayorItem, LibroDiarioItem, BalanceComprobItem } from '../domain/models/libros-asientos.entity';

/**
 * LibrosAsientosState — Estado centralizado de libros y asientos.
 * Cada tipo de reporte tiene su propio loading y error independiente.
 */
export interface LibrosAsientosState {
  libroMayor:          LibroMayorItem[];
  libroDiario:         LibroDiarioItem[];
  balanceComprobacion: BalanceComprobItem[];
  loadingLibroMayor:   boolean;
  loadingLibroDiario:  boolean;
  loadingBalanceComprob: boolean;
  errorLibroMayor:     string | null;
  errorLibroDiario:    string | null;
  errorBalanceComprob: string | null;
}

export const initialLibrosAsientosState: LibrosAsientosState = {
  libroMayor:          [],
  libroDiario:         [],
  balanceComprobacion: [],
  loadingLibroMayor:   false,
  loadingLibroDiario:  false,
  loadingBalanceComprob: false,
  errorLibroMayor:     null,
  errorLibroDiario:    null,
  errorBalanceComprob: null,
};
