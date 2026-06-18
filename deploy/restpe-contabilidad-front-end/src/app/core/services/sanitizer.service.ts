import { Injectable } from '@angular/core';

/**
 * Servicio de sanitización de inputs (OWASP).
 * Previene XSS y SQL injection desde el frontend antes de enviar datos al backend.
 */
@Injectable({ providedIn: 'root' })
export class SanitizerService {

  private readonly SCRIPT_RE = /<\s*script[^>]*>.*?<\/\s*script\s*>/gi;
  private readonly HTML_TAG_RE = /<[^>]+>/g;
  private readonly EVENT_HANDLER_RE = /\bon\w+\s*=/gi;
  private readonly JS_URI_RE = /javascript\s*:/gi;
  private readonly SQL_INJECTION_RE = /(--|;|'\s*(OR|AND|UNION|SELECT|INSERT|UPDATE|DELETE|DROP|ALTER|EXEC)\s)/gi;
  private readonly CONTROL_CHARS_RE = /[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/g;

  sanitize(input: string | null | undefined): string {
    if (!input) return '';
    let clean = input;
    clean = clean.replace(this.SCRIPT_RE, '');
    clean = clean.replace(this.EVENT_HANDLER_RE, '');
    clean = clean.replace(this.JS_URI_RE, '');
    clean = clean.replace(this.HTML_TAG_RE, '');
    clean = clean.replace(this.CONTROL_CHARS_RE, '');
    return clean.trim();
  }

  containsDangerousInput(input: string | null | undefined): boolean {
    if (!input) return false;
    return this.SCRIPT_RE.test(input)
        || this.SQL_INJECTION_RE.test(input)
        || this.JS_URI_RE.test(input);
  }

  sanitizeObject<T extends Record<string, any>>(obj: T, skipFields: string[] = []): T {
    const result = { ...obj };
    for (const key of Object.keys(result)) {
      if (skipFields.includes(key)) continue;
      if (typeof result[key] === 'string') {
        (result as any)[key] = this.sanitize(result[key]);
      }
    }
    return result;
  }
}
