import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AJVacacionesLicenciasComponent } from './a-j-vacaciones-licencias.component';

describe('AJVacacionesLicenciasComponent', () => {
  let component: AJVacacionesLicenciasComponent;
  let fixture: ComponentFixture<AJVacacionesLicenciasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AJVacacionesLicenciasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AJVacacionesLicenciasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
