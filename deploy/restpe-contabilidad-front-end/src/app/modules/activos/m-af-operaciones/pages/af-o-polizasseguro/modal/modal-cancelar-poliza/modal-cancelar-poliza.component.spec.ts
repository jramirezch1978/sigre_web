import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalCancelarPolizaComponent } from './modal-cancelar-poliza.component';

describe('ModalCancelarPolizaComponent', () => {
  let component: ModalCancelarPolizaComponent;
  let fixture: ComponentFixture<ModalCancelarPolizaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalCancelarPolizaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalCancelarPolizaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
