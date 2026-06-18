import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CPConsistenciaasientosComponent } from './c-p-consistenciaasientos.component';

describe('CPConsistenciaasientosComponent', () => {
  let component: CPConsistenciaasientosComponent;
  let fixture: ComponentFixture<CPConsistenciaasientosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ CPConsistenciaasientosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CPConsistenciaasientosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
