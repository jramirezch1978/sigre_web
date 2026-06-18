import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AfiliacionFondosDePensionComponent } from './afiliacion-fondos-de-pension.component';

describe('AfiliacionFondosDePensionComponent', () => {
  let component: AfiliacionFondosDePensionComponent;
  let fixture: ComponentFixture<AfiliacionFondosDePensionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AfiliacionFondosDePensionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AfiliacionFondosDePensionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
