import { TestBed } from '@angular/core/testing';

import { TalonariosService } from './serviciotabla';

describe('TalonariosService', () => {
  let service: TalonariosService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TalonariosService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
