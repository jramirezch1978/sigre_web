import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { of, throwError } from 'rxjs';

import { AuthService } from './auth.service';
import { UtilityService } from '../../services/utility.service';

describe('AuthService', () => {
  let service: AuthService;
  let utilityServiceSpy: jasmine.SpyObj<UtilityService>;
  let routerSpy: jasmine.SpyObj<Router>;

  beforeEach(() => {
    const utilitySpy = jasmine.createSpyObj('UtilityService', [
      'signIn',
      'signOut',
      'hasValidSession',
      'getAuthToken',
      'getCurrentSession',
      'getCurrentUser'
    ], {
      session$: of(null),
      loginLoading$: of(false),
      loginError$: of(false)
    });

    const routerSpyObj = jasmine.createSpyObj('Router', ['navigateByUrl']);

    TestBed.configureTestingModule({
      providers: [
        AuthService,
        { provide: UtilityService, useValue: utilitySpy },
        { provide: Router, useValue: routerSpyObj }
      ]
    });

    service = TestBed.inject(AuthService);
    utilityServiceSpy = TestBed.inject(UtilityService) as jasmine.SpyObj<UtilityService>;
    routerSpy = TestBed.inject(Router) as jasmine.SpyObj<Router>;
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('signIn', () => {
    it('should call UtilityService signIn with credentials', () => {
      const credentials = { usuario_nick: 'test', usuario_clave: 'password' };
      const mockResponse = { success: true, data: { token: 'abc123' } };
      
      utilityServiceSpy.signIn.and.returnValue(of(mockResponse));

    //   service.signIn(credentials);

      expect(utilityServiceSpy.signIn).toHaveBeenCalledWith(credentials);
    });
  });

  describe('signOut', () => {
    it('should call UtilityService signOut and navigate to signin', async () => {
      routerSpy.navigateByUrl.and.returnValue(Promise.resolve(true));

      await service.signOut();

      expect(utilityServiceSpy.signOut).toHaveBeenCalled();
      expect(routerSpy.navigateByUrl).toHaveBeenCalledWith('/auth/signin');
    });
  });

  describe('isAuthenticated', () => {
    it('should return true when session is valid', () => {
      utilityServiceSpy.hasValidSession.and.returnValue(true);

      const result = service.isAuthenticated();

      expect(result).toBe(true);
      expect(utilityServiceSpy.hasValidSession).toHaveBeenCalled();
    });

    it('should return false when session is invalid', () => {
      utilityServiceSpy.hasValidSession.and.returnValue(false);

      const result = service.isAuthenticated();

      expect(result).toBe(false);
      expect(utilityServiceSpy.hasValidSession).toHaveBeenCalled();
    });
  });

  describe('getAuthToken', () => {
    it('should return token from UtilityService', () => {
      const mockToken = 'test-token-123';
      utilityServiceSpy.getAuthToken.and.returnValue(mockToken);

      const result = service.getAuthToken();

      expect(result).toBe(mockToken);
      expect(utilityServiceSpy.getAuthToken).toHaveBeenCalled();
    });
  });

  describe('getCurrentUser', () => {
    it('should return user data from UtilityService', () => {
      const mockUser = { id: 1, nick: 'testuser', email: 'test@test.com' };
      utilityServiceSpy.getCurrentUser.and.returnValue(mockUser);

      const result = service.getCurrentUser();

      expect(result).toEqual(mockUser);
      expect(utilityServiceSpy.getCurrentUser).toHaveBeenCalled();
    });
  });
});
