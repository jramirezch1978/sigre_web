import { ApplicationConfig, importProvidersFrom, APP_INITIALIZER } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { provideHttpClient } from '@angular/common/http';

import { routes } from './app.routes';
import { ConfigService } from './services/config.service';

// Factory function para inicializar la configuración
export function initializeApp(configService: ConfigService): () => Promise<any> {
  return () => configService.waitForConfig().catch(error => {
    console.error('Error al inicializar configuración:', error);
    // No lanzar error para permitir que la app continue con valores por defecto
    return Promise.resolve();
  });
}

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideAnimationsAsync(),
    provideHttpClient(),
    {
      provide: APP_INITIALIZER,
      useFactory: initializeApp,
      deps: [ConfigService],
      multi: true
    }
  ]
};
