import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FRDocumentosClientesComponent } from './f-r-documentos-clientes.component';

describe('FRDocumentosClientesComponent', () => {
  let component: FRDocumentosClientesComponent;
  let fixture: ComponentFixture<FRDocumentosClientesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FRDocumentosClientesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FRDocumentosClientesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
