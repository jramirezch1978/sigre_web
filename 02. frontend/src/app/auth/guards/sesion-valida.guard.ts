import { Injectable, inject } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { UtilityService } from '../../services/utility.service';

@Injectable({
  providedIn: 'root'
})
export class SesionValidaGuard implements CanActivate {
  private readonly router = inject(Router);
  private readonly utilityService = inject(UtilityService);

  async canActivate(): Promise<boolean> {
    const hasSession = this.utilityService.hasValidSession();
    
    if (hasSession) {
      return true;
    }
    
    await this.router.navigateByUrl('/auth/signin');
    return false;
  }
}
