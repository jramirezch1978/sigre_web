import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenReportesValorizacionComponent } from './almacen-reportes-valorizacion.component';

describe('AlmacenReportesValorizacionComponent', () => {
  let component: AlmacenReportesValorizacionComponent;
  let fixture: ComponentFixture<AlmacenReportesValorizacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenReportesValorizacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenReportesValorizacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
