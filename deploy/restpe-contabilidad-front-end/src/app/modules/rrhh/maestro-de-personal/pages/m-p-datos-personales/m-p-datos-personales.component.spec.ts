import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { MPDatosPersonalesComponent } from './m-p-datos-personales.component';

describe('MPDatosPersonalesComponent', () => {
  let component: MPDatosPersonalesComponent;
  let fixture: ComponentFixture<MPDatosPersonalesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ MPDatosPersonalesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(MPDatosPersonalesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
