import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalAplicarCanjeComponent } from './modal-aplicar-canje.component';

describe('ModalAplicarCanjeComponent', () => {
  let component: ModalAplicarCanjeComponent;
  let fixture: ComponentFixture<ModalAplicarCanjeComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalAplicarCanjeComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalAplicarCanjeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
