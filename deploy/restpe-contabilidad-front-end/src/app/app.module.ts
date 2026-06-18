import { NgModule, LOCALE_ID } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { IonicModule, IonicRouteStrategy } from '@ionic/angular';
import { addIcons } from 'ionicons';
import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { UiModule } from './ui/ui.module';

// Auth imports
import { AuthInterceptor } from './auth/interceptors/auth.interceptor';
import { SesionValidaGuard } from './auth/guards/sesion-valida.guard';
import { SesionNoValidaGuard } from './auth/guards/sesion-no-valida.guard';
import { IRazonSocialRepository } from './auth/domain/repositories/irazon-social.repository';
import { RazonSocialRepositoryImpl } from './auth/infrastructure/repository/razon-social.repository.impl';
import { provideCharts, withDefaultRegisterables } from 'ng2-charts';

@NgModule({
  declarations: [
    AppComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule,
    IonicModule.forRoot(),
    AppRoutingModule,
    UiModule,
  ],
  exports: [
  ],
  providers: [
    provideCharts(withDefaultRegisterables()),
    { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    { provide: LOCALE_ID, useValue: 'es-PE' },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    },
    SesionValidaGuard,
    SesionNoValidaGuard,
    { provide: IRazonSocialRepository, useClass: RazonSocialRepositoryImpl },
  ],
  bootstrap: [AppComponent],
})

export class AppModule {
  constructor() {
    addIcons({
      'chevron-down': 'assets/svg/chevron-down.svg',
      'chevron-up': 'assets/svg/chevron-up.svg',
    });
  }
}