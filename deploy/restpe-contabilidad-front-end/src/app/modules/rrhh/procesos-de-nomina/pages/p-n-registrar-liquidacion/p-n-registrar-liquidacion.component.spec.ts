import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PNRegistrarLiquidacionComponent } from './p-n-registrar-liquidacion.component';

describe('PNRegistrarLiquidacionComponent', () => {
  let component: PNRegistrarLiquidacionComponent;
  let fixture: ComponentFixture<PNRegistrarLiquidacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PNRegistrarLiquidacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PNRegistrarLiquidacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
