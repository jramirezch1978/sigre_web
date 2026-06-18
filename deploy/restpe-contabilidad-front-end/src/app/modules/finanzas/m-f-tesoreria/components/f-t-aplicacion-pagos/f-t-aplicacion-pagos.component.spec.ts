import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTAplicacionPagosComponent } from './f-t-aplicacion-pagos.component';

describe('FTAplicacionPagosComponent', () => {
  let component: FTAplicacionPagosComponent;
  let fixture: ComponentFixture<FTAplicacionPagosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTAplicacionPagosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTAplicacionPagosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
