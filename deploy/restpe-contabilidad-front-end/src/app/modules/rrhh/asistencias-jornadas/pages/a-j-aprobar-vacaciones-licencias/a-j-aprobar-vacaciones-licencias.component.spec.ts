import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AJAprobarVacacionesLicenciasComponent } from './a-j-aprobar-vacaciones-licencias.component';

describe('AJAprobarVacacionesLicenciasComponent', () => {
  let component: AJAprobarVacacionesLicenciasComponent;
  let fixture: ComponentFixture<AJAprobarVacacionesLicenciasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AJAprobarVacacionesLicenciasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AJAprobarVacacionesLicenciasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
