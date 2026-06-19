export type SigreModalTipo = 'confirm' | 'success' | 'error' | 'warning' | 'info';

export interface SigreModalOptions {
  titulo: string;
  mensaje: string;
  submensaje?: string;
  tipo?: SigreModalTipo;
  textoCancelar?: string;
  textoConfirmar?: string;
  /** Si true muestra botón cancelar (por defecto en confirmaciones). */
  conCancelar?: boolean;
}
