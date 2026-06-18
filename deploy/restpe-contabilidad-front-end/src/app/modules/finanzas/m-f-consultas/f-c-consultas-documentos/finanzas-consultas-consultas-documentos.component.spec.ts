import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FinanzasConsultasConsultasDocumentosComponent } from './finanzas-consultas-consultas-documentos.component';

describe('FinanzasConsultasConsultasDocumentosComponent', () => {
  let component: FinanzasConsultasConsultasDocumentosComponent;
  let fixture: ComponentFixture<FinanzasConsultasConsultasDocumentosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FinanzasConsultasConsultasDocumentosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FinanzasConsultasConsultasDocumentosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
