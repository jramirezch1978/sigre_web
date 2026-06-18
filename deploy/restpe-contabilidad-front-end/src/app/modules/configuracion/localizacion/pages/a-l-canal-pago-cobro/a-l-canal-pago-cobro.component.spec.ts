import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ALCanalPagoCobroComponent } from './a-l-canal-pago-cobro.component';

describe('ALCanalPagoCobroComponent', () => {
  let component: ALCanalPagoCobroComponent;
  let fixture: ComponentFixture<ALCanalPagoCobroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ALCanalPagoCobroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ALCanalPagoCobroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
