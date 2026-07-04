import { ApplicationConfig, importProvidersFrom, APP_INITIALIZER, LOCALE_ID, ErrorHandler } from '@angular/core';
import { provideRouter, RouteReuseStrategy, TitleStrategy } from '@angular/router';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { provideHttpClient, withInterceptorsFromDi, HTTP_INTERCEPTORS } from '@angular/common/http';
import { registerLocaleData } from '@angular/common';
import localeEsPe from '@angular/common/locales/es-PE';
import { IonicModule, IonicRouteStrategy } from '@ionic/angular';
import { provideCharts, withDefaultRegisterables } from 'ng2-charts';

import { routes } from './app.routes';
import { ConfigService } from './services/config.service';
import { SigrePageTitleStrategy } from './services/sigre-page-title.strategy';
import { AuthInterceptor } from './auth/interceptors/auth.interceptor';
import { ApiErrorInterceptor } from './core/interceptors/api-error.interceptor';
import { ChunkLoadErrorHandler } from './core/handlers/chunk-load-error.handler';

registerLocaleData(localeEsPe);

export function initializeApp(configService: ConfigService): () => Promise<unknown> {
  return () => configService.waitForConfig().catch(error => {
    console.error('Error al inicializar configuración:', error);
    return Promise.resolve();
  });
}

export const appConfig: ApplicationConfig = {
  providers: [
    { provide: ErrorHandler, useClass: ChunkLoadErrorHandler },
    provideRouter(routes),
    { provide: TitleStrategy, useClass: SigrePageTitleStrategy },
    provideAnimationsAsync(),
    provideHttpClient(withInterceptorsFromDi()),
    importProvidersFrom(IonicModule.forRoot()),
    provideCharts(withDefaultRegisterables()),
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    { provide: LOCALE_ID, useValue: 'es-PE' },
    // ApiErrorInterceptor primero = más externo: muestra modal de cualquier error de API
    // (excepto 401, que gestiona AuthInterceptor). Ningún error de API queda silencioso.
    { provide: HTTP_INTERCEPTORS, useClass: ApiErrorInterceptor, multi: true },
    { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true },
    {
      provide: APP_INITIALIZER,
      useFactory: initializeApp,
      deps: [ConfigService],
      multi: true
    }
  ]
};
