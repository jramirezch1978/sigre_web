import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ATClasificacionArticulosComponent } from './a-t-clasificacion-articulos.component';

describe('ATClasificacionArticulosComponent', () => {
  let component: ATClasificacionArticulosComponent;
  let fixture: ComponentFixture<ATClasificacionArticulosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ATClasificacionArticulosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ATClasificacionArticulosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
