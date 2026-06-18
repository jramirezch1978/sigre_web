import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalRechazarTrasladoComponent } from './modal-rechazar-traslado.component';

describe('ModalRechazarTrasladoComponent', () => {
  let component: ModalRechazarTrasladoComponent;
  let fixture: ComponentFixture<ModalRechazarTrasladoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalRechazarTrasladoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalRechazarTrasladoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
