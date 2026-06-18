import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTPagoDetraccionComponent } from './f-t-pago-detraccion.component';

describe('FTPagoDetraccionComponent', () => {
  let component: FTPagoDetraccionComponent;
  let fixture: ComponentFixture<FTPagoDetraccionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTPagoDetraccionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTPagoDetraccionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
