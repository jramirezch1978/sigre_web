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

/** Calcula el dígito verificador de un RUC peruano (algoritmo módulo 11 de SUNAT). */
export function digitoVerificadorRucValido(ruc: string): boolean {
  const factores = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];
  const digitos = ruc.split('').map(Number);
  const suma = factores.reduce((acc, f, i) => acc + f * digitos[i], 0);
  const resto = suma % 11;
  let esperado = 11 - resto;
  if (esperado === 11) esperado = 1;
  if (esperado === 10) esperado = 0;
  return esperado === digitos[10];
}

/** Valida longitud (11), que sean solo dígitos, y el dígito verificador del RUC. */
export function rucValidator(): ValidatorFn {
  return (control: AbstractControl): ValidationErrors | null => {
    const valor = String(control.value ?? '').trim();
    if (!valor) return null; // usar Validators.required aparte si es obligatorio
    if (!/^\d{11}$/.test(valor)) return { rucFormato: true };
    if (!digitoVerificadorRucValido(valor)) return { rucDigito: true };
    return null;
  };
}
