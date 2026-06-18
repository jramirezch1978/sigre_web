import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PConfiguracionProvisionesComponent } from './p-configuracion-provisiones.component';

describe('PConfiguracionProvisionesComponent', () => {
  let component: PConfiguracionProvisionesComponent;
  let fixture: ComponentFixture<PConfiguracionProvisionesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PConfiguracionProvisionesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PConfiguracionProvisionesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
