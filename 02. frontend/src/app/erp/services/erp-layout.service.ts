import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { MenuModulo } from '../services/erp-menu.service';

@Injectable({ providedIn: 'root' })
export class ErpLayoutService {
  private readonly moduloActivoSubject = new BehaviorSubject<MenuModulo | null>(null);
  readonly moduloActivo$ = this.moduloActivoSubject.asObservable();

  seleccionarModulo(modulo: MenuModulo | null): void {
    this.moduloActivoSubject.next(modulo);
  }

  moduloActivoActual(): MenuModulo | null {
    return this.moduloActivoSubject.value;
  }
}
