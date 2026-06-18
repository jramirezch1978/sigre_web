import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AlmacenConsultasKardexComponent } from './almacen-consultas-kardex.component';

describe('AlmacenConsultasKardexComponent', () => {
  let component: AlmacenConsultasKardexComponent;
  let fixture: ComponentFixture<AlmacenConsultasKardexComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AlmacenConsultasKardexComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AlmacenConsultasKardexComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
