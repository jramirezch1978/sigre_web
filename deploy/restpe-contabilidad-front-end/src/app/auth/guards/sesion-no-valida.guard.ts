import { Injectable, inject } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { StorageService } from '../../core/services/storage.service';

@Injectable({
  providedIn: 'root'
})
export class SesionNoValidaGuard implements CanActivate {
  private readonly router = inject(Router);
  private readonly storage = inject(StorageService);

  async canActivate(): Promise<boolean> {
    if (this.storage.isAuthenticated()) {
      await this.router.navigateByUrl('/inicio');
      return false;
    }
    
    return true;
  }
}
