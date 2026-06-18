import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PNAprobarLiquidacionComponent } from './p-n-aprobar-liquidacion.component';

describe('PNAprobarLiquidacionComponent', () => {
  let component: PNAprobarLiquidacionComponent;
  let fixture: ComponentFixture<PNAprobarLiquidacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PNAprobarLiquidacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PNAprobarLiquidacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
