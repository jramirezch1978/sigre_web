import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalRenovarPolizaComponent } from './modal-renovar-poliza.component';

describe('ModalRenovarPolizaComponent', () => {
  let component: ModalRenovarPolizaComponent;
  let fixture: ComponentFixture<ModalRenovarPolizaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalRenovarPolizaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalRenovarPolizaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
