import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { DefinicionAreasJerarquiasComponent } from './definicion-areas-jerarquias.component';

describe('DefinicionAreasJerarquiasComponent', () => {
  let component: DefinicionAreasJerarquiasComponent;
  let fixture: ComponentFixture<DefinicionAreasJerarquiasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ DefinicionAreasJerarquiasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(DefinicionAreasJerarquiasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
