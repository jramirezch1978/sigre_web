import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTMovCuentasBancYCajasComponent } from './f-t-mov-cuentas-banc-y-cajas.component';

describe('FTMovCuentasBancYCajasComponent', () => {
  let component: FTMovCuentasBancYCajasComponent;
  let fixture: ComponentFixture<FTMovCuentasBancYCajasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTMovCuentasBancYCajasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTMovCuentasBancYCajasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
