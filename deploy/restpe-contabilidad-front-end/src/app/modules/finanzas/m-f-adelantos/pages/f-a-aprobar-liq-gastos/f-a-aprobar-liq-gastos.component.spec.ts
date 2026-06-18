import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FAAprobarLiqGastosComponent } from './f-a-aprobar-liq-gastos.component';

describe('FAAprobarLiqGastosComponent', () => {
  let component: FAAprobarLiqGastosComponent;
  let fixture: ComponentFixture<FAAprobarLiqGastosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FAAprobarLiqGastosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FAAprobarLiqGastosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
