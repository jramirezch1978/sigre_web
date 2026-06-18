import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ActivofijoTablaNumtrasladosComponent } from './activofijo-tabla-numtraslados.component';

describe('ActivofijoTablaNumtrasladosComponent', () => {
  let component: ActivofijoTablaNumtrasladosComponent;
  let fixture: ComponentFixture<ActivofijoTablaNumtrasladosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoTablaNumtrasladosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoTablaNumtrasladosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
