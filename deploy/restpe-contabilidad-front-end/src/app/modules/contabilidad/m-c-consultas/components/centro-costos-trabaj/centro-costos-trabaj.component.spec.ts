import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { CentroCostosTrabajComponent } from './centro-costos-trabaj.component';

describe('CentroCostosTrabajComponent', () => {
  let component: CentroCostosTrabajComponent;
  let fixture: ComponentFixture<CentroCostosTrabajComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ CentroCostosTrabajComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(CentroCostosTrabajComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
