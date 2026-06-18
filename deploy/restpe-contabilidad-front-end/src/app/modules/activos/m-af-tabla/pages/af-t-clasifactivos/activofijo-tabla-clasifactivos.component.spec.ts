import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ActivofijoTablaClasifactivosComponent } from './activofijo-tabla-clasifactivos.component';

describe('ActivofijoTablaClasifactivosComponent', () => {
  let component: ActivofijoTablaClasifactivosComponent;
  let fixture: ComponentFixture<ActivofijoTablaClasifactivosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoTablaClasifactivosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoTablaClasifactivosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
