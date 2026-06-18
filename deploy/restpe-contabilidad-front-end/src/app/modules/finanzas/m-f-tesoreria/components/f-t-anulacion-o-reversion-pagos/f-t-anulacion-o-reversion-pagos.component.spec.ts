import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTAnulacionOReversionPagosComponent } from './f-t-anulacion-o-reversion-pagos.component';

describe('FTAnulacionOReversionPagosComponent', () => {
  let component: FTAnulacionOReversionPagosComponent;
  let fixture: ComponentFixture<FTAnulacionOReversionPagosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTAnulacionOReversionPagosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTAnulacionOReversionPagosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
