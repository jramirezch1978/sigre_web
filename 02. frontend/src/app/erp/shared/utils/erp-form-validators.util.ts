import { AbstractControl, ValidationErrors, ValidatorFn } from '@angular/forms';

/** Rechaza cadenas que solo contienen espacios (complementa Validators.required en textos). */
export function noSoloEspaciosValidator(): ValidatorFn {
  return (control: AbstractControl): ValidationErrors | null => {
    const valor = control.value;
    if (valor == null || valor === '') {
      return null;
    }
    if (typeof valor === 'string' && valor.trim().length === 0) {
      return { soloEspacios: true };
    }
    return null;
  };
}
