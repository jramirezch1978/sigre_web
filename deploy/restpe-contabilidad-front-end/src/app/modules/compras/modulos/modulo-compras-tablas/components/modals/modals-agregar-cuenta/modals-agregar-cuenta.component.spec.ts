import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalsAgregarCuentaComponent } from './modals-agregar-cuenta.component';

describe('ModalsAgregarCuentaComponent', () => {
  let component: ModalsAgregarCuentaComponent;
  let fixture: ComponentFixture<ModalsAgregarCuentaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalsAgregarCuentaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalsAgregarCuentaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
