import { Injectable } from '@angular/core';
import * as CryptoJS from 'crypto-js';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class CryptoService {

  private readonly keyBytes: CryptoJS.lib.WordArray;

  constructor() {
    this.keyBytes = CryptoJS.enc.Base64.parse(environment.encryptionKey);
  }

  hash(plainText: string): string {
    return CryptoJS.SHA256(plainText).toString(CryptoJS.enc.Hex);
  }

  encrypt(plainText: string): string {
    const iv = CryptoJS.lib.WordArray.random(12);

    const encrypted = CryptoJS.AES.encrypt(plainText, this.keyBytes, {
      iv,
      mode: CryptoJS.mode.CTR,
      padding: CryptoJS.pad.NoPadding,
    });

    const ivBytes = this.wordArrayToUint8Array(iv);
    const cipherBytes = this.wordArrayToUint8Array(encrypted.ciphertext);

    const combined = new Uint8Array(ivBytes.length + cipherBytes.length);
    combined.set(ivBytes, 0);
    combined.set(cipherBytes, ivBytes.length);

    return this.uint8ArrayToBase64(combined);
  }

  decrypt(encryptedBase64: string): string {
    if (!encryptedBase64) return '';

    const allBytes = this.base64ToUint8Array(encryptedBase64);
    if (allBytes.length <= 12) return '';

    const ivBytes = allBytes.slice(0, 12);
    const cipherBytes = allBytes.slice(12);

    const iv = this.uint8ArrayToWordArray(ivBytes);
    const ciphertext = this.uint8ArrayToWordArray(cipherBytes);

    const decrypted = CryptoJS.AES.decrypt(
      { ciphertext } as CryptoJS.lib.CipherParams,
      this.keyBytes,
      {
        iv,
        mode: CryptoJS.mode.CTR,
        padding: CryptoJS.pad.NoPadding,
      }
    );

    return CryptoJS.enc.Utf8.stringify(decrypted);
  }

  private wordArrayToUint8Array(wordArray: CryptoJS.lib.WordArray): Uint8Array {
    const words = wordArray.words;
    const sigBytes = wordArray.sigBytes;
    const u8 = new Uint8Array(sigBytes);
    for (let i = 0; i < sigBytes; i++) {
      u8[i] = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
    }
    return u8;
  }

  private uint8ArrayToBase64(bytes: Uint8Array): string {
    let binary = '';
    for (let i = 0; i < bytes.length; i++) {
      binary += String.fromCharCode(bytes[i]);
    }
    return btoa(binary);
  }

  private base64ToUint8Array(base64: string): Uint8Array {
    const binary = atob(base64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) {
      bytes[i] = binary.charCodeAt(i);
    }
    return bytes;
  }

  private uint8ArrayToWordArray(bytes: Uint8Array): CryptoJS.lib.WordArray {
    const words: number[] = [];
    for (let i = 0; i < bytes.length; i += 4) {
      words.push(
        ((bytes[i] ?? 0) << 24) |
        ((bytes[i + 1] ?? 0) << 16) |
        ((bytes[i + 2] ?? 0) << 8) |
        (bytes[i + 3] ?? 0)
      );
    }
    return CryptoJS.lib.WordArray.create(words, bytes.length);
  }
}
