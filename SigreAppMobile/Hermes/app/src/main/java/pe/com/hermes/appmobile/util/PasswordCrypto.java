package pe.com.hermes.appmobile.util;

import android.util.Base64;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Replica EXACTA del esquema de CryptoService (02. frontend/src/app/core/services/crypto.service.ts)
 * que el backend real espera en /api/auth/login (AesEncryptor.decryptAndVerify, sigre-common):
 * AES-256-CTR con IV aleatorio de 12 bytes, formato base64(IV(12) + ciphertext), más SHA-256
 * hex del texto plano para verificación de integridad (passwordHash).
 *
 * La clave es la misma que usa el frontend Angular (environment.encryptionKey) — ya viaja
 * embebida en el bundle JS público del frontend, así que compartirla aquí no expone nada
 * adicional que no estuviera ya expuesto.
 */
public final class PasswordCrypto {

    private static final String ENCRYPTION_KEY_BASE64 = "U2lncmVFcnBXZWJBZXMyNTZLZXlEZXYyMDI2ISEhISE=";
    private static final int IV_LENGTH = 12;

    private PasswordCrypto() {
    }

    /** base64(IV_12bytes + AES-CTR-NoPadding(texto)) — mismo formato que CryptoService.encrypt(). */
    public static String encrypt(String plainText) {
        try {
            byte[] key = Base64.decode(ENCRYPTION_KEY_BASE64, Base64.NO_WRAP);
            byte[] iv = new byte[IV_LENGTH];
            new SecureRandom().nextBytes(iv);

            byte[] counterIv = new byte[16];
            System.arraycopy(iv, 0, counterIv, 0, IV_LENGTH);

            Cipher cipher = Cipher.getInstance("AES/CTR/NoPadding");
            cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(key, "AES"), new IvParameterSpec(counterIv));
            byte[] cipherText = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

            byte[] combined = new byte[IV_LENGTH + cipherText.length];
            System.arraycopy(iv, 0, combined, 0, IV_LENGTH);
            System.arraycopy(cipherText, 0, combined, IV_LENGTH, cipherText.length);

            return Base64.encodeToString(combined, Base64.NO_WRAP);
        } catch (Exception e) {
            throw new RuntimeException("Error al cifrar la contraseña", e);
        }
    }

    /** SHA-256 hex en minúsculas — mismo formato que CryptoService.hash(). */
    public static String sha256Hex(String plainText) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(plainText.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(hash.length * 2);
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error al calcular SHA-256", e);
        }
    }
}
