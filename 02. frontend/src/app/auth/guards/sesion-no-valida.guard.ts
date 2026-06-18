import { Injectable } from '@angular/core';
import { CanActivate } from '@angular/router';

/** El login siempre es accesible; la sesión se invalida al entrar al componente signin. */
@Injectable({
  providedIn: 'root'
})
export class SesionNoValidaGuard implements CanActivate {
  canActivate(): boolean {
    return true;
  }
}
