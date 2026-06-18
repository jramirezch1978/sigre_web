import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalGenerarAjusteComponent } from './modal-generar-ajuste.component';

describe('ModalGenerarAjusteComponent', () => {
  let component: ModalGenerarAjusteComponent;
  let fixture: ComponentFixture<ModalGenerarAjusteComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalGenerarAjusteComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalGenerarAjusteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
