import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ApartadoNotificacionesPage } from './apartado-notificaciones.page';

describe('ApartadoNotificacionesPage', () => {
  let component: ApartadoNotificacionesPage;
  let fixture: ComponentFixture<ApartadoNotificacionesPage>;

  beforeEach(() => {
    fixture = TestBed.createComponent(ApartadoNotificacionesPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
