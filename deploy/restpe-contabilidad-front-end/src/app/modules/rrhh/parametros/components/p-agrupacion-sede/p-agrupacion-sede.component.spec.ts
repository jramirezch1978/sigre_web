import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PAgrupacionSedeComponent } from './p-agrupacion-sede.component';

describe('PAgrupacionSedeComponent', () => {
  let component: PAgrupacionSedeComponent;
  let fixture: ComponentFixture<PAgrupacionSedeComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PAgrupacionSedeComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PAgrupacionSedeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
