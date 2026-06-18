import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { RegistroIngresoDeDiaComponent } from './registro-ingreso-de-dia.component';

describe('RegistroIngresoDeDiaComponent', () => {
  let component: RegistroIngresoDeDiaComponent;
  let fixture: ComponentFixture<RegistroIngresoDeDiaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RegistroIngresoDeDiaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(RegistroIngresoDeDiaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
