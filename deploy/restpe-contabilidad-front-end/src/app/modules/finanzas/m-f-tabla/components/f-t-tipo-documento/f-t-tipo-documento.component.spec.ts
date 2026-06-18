import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTTipoDocumentoComponent } from './f-t-tipo-documento.component';

describe('FTTipoDocumentoComponent', () => {
  let component: FTTipoDocumentoComponent;
  let fixture: ComponentFixture<FTTipoDocumentoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTTipoDocumentoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTTipoDocumentoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
