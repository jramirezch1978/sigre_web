import { AbstractControl } from '@angular/forms';

export type SigreFieldValidationState = 'none' | 'valid' | 'invalid';

function tieneValor(control: AbstractControl): boolean {
  const valor = control.value;
  if (valor == null) return false;
  if (typeof valor === 'string') return valor.trim() !== '';
  if (typeof valor === 'number') return !Number.isNaN(valor);
  if (typeof valor === 'boolean') return true;
  return true;
}

/** Estado visual del campo: check verde si válido y con valor; X roja si inválido tras interacción. */
export function estadoValidacionCampo(control: AbstractControl | null): SigreFieldValidationState {
  if (!control || control.disabled) return 'none';
  if (!control.touched && !control.dirty) return 'none';
  if (control.invalid) return 'invalid';
  if (!tieneValor(control)) return 'none';
  return 'valid';
}
