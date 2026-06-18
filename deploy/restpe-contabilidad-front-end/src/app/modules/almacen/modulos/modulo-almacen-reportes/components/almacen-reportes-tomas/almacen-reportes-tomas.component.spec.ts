import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenReportesTomasComponent } from './almacen-reportes-tomas.component';

describe('AlmacenReportesTomasComponent', () => {
  let component: AlmacenReportesTomasComponent;
  let fixture: ComponentFixture<AlmacenReportesTomasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenReportesTomasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenReportesTomasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
