// This file can be replaced during build by using the `fileReplacements` array.
// `ng build` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.

export const environment = {
  production: false,
  apiUrl: '/api',
  /** Gateway API (ms detrás del mismo host); ver docker-compose api-gateway :9080 */
  apiBaseUrl: '/api',
  /**
   * Vacío: entrar al admin en esta SPA (`/admin/inicio`).
   * Si el admin vive en otro origen, URL base del sitio admin sin barra final (ej. `https://admin.ejemplo.pe/admin` → abre `.../admin/inicio`).
   */
  adminExternalBaseUrl: '',
  simulationMode: false,
  encryptionKey: 'U2lncmVFcnBXZWJBZXMyNTZLZXlEZXYyMDI2ISEhISE=',
  provisionSecret: 'dev-provision-cambiar-produccion',
  turnstileSiteKey: '1x00000000000000000000AA'
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/plugins/zone-error';  // Included with Angular CLI.
