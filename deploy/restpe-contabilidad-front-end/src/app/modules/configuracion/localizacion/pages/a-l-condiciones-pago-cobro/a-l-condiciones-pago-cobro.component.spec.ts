import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ALCondicionesPagoCobroComponent } from './a-l-condiciones-pago-cobro.component';

describe('ALCondicionesPagoCobroComponent', () => {
  let component: ALCondicionesPagoCobroComponent;
  let fixture: ComponentFixture<ALCondicionesPagoCobroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ALCondicionesPagoCobroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ALCondicionesPagoCobroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
