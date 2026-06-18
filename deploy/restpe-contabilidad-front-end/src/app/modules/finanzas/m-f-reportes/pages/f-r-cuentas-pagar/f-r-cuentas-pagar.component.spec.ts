import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FRCuentasPagarComponent } from './f-r-cuentas-pagar.component';

describe('FRCuentasPagarComponent', () => {
  let component: FRCuentasPagarComponent;
  let fixture: ComponentFixture<FRCuentasPagarComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FRCuentasPagarComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FRCuentasPagarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
