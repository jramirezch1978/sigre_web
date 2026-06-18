import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { registerLocaleData } from '@angular/common';
import localeEs from '@angular/common/locales/es-PE';

import { AppModule } from './app/app.module';

// Registrar locale español peruano
registerLocaleData(localeEs, 'es-PE');

// La sesión persiste entre recargas (F5): el access token se renueva con el
// refresh token y los guards/interceptor validan su vigencia. Si el token y el
// refresh están vencidos, el guard redirige al login.

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.log(err));
