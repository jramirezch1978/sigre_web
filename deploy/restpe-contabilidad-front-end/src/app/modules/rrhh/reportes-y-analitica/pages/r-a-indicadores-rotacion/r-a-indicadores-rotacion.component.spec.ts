import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { RAIndicadoresRotacionComponent } from './r-a-indicadores-rotacion.component';

describe('RAIndicadoresRotacionComponent', () => {
  let component: RAIndicadoresRotacionComponent;
  let fixture: ComponentFixture<RAIndicadoresRotacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RAIndicadoresRotacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(RAIndicadoresRotacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
