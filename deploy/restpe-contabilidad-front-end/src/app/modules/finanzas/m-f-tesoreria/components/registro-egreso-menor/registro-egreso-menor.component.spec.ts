import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { RegistroEgresoMenorComponent } from './registro-egreso-menor.component';

describe('RegistroEgresoMenorComponent', () => {
  let component: RegistroEgresoMenorComponent;
  let fixture: ComponentFixture<RegistroEgresoMenorComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RegistroEgresoMenorComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(RegistroEgresoMenorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
