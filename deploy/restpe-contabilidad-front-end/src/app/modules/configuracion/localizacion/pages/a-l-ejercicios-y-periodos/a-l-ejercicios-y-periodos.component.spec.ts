import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ALEjerciciosYPeriodosComponent } from './a-l-ejercicios-y-periodos.component';

describe('ALEjerciciosYPeriodosComponent', () => {
  let component: ALEjerciciosYPeriodosComponent;
  let fixture: ComponentFixture<ALEjerciciosYPeriodosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ALEjerciciosYPeriodosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ALEjerciciosYPeriodosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
