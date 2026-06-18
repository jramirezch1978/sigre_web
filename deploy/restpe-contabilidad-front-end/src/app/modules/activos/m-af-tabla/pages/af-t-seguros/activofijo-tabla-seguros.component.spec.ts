import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ActivofijoTablaSegurosComponent } from './activofijo-tabla-seguros.component';

describe('ActivofijoTablaSegurosComponent', () => {
  let component: ActivofijoTablaSegurosComponent;
  let fixture: ComponentFixture<ActivofijoTablaSegurosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoTablaSegurosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoTablaSegurosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
