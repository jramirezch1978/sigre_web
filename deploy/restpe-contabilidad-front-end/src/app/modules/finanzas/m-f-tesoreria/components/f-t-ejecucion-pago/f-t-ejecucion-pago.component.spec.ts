import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTEjecucionPagoComponent } from './f-t-ejecucion-pago.component';

describe('FTEjecucionPagoComponent', () => {
  let component: FTEjecucionPagoComponent;
  let fixture: ComponentFixture<FTEjecucionPagoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTEjecucionPagoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTEjecucionPagoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
