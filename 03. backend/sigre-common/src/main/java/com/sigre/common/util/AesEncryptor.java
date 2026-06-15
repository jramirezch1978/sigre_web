package com.sigre.common.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.HexFormat;

/**
 * Encriptación simétrica AES con IV aleatorio.
 * <p>
 * - encrypt/decrypt: AES-GCM para datos server-side (contraseñas BD tenant).
 * - decryptFromFrontend: AES-CTR para datos del frontend (CryptoJS usa CTR).
 */
public final class AesEncryptor {

    private static final String GCM_ALGORITHM = "AES/GCM/NoPadding";
    private static final String CTR_ALGORITHM = "AES/CTR/NoPadding";
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_BITS = 128;
    private static final int CTR_IV_LENGTH = 12;

    private final SecretKey secretKey;

    public AesEncryptor(String base64Key) {
        byte[] keyBytes = Base64.getDecoder().decode(base64Key);
        if (keyBytes.length != 16 && keyBytes.length != 24 && keyBytes.length != 32) {
            throw new IllegalArgumentException(
                    "La clave AES debe ser de 16, 24 o 32 bytes (128/192/256 bits). Recibido: " + keyBytes.length);
        }
        this.secretKey = new SecretKeySpec(keyBytes, "AES");
    }

    public String encrypt(String plainText) {
        try {
            byte[] iv = new byte[GCM_IV_LENGTH];
            new SecureRandom().nextBytes(iv);

            Cipher cipher = Cipher.getInstance(GCM_ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey, new GCMParameterSpec(GCM_TAG_BITS, iv));

            byte[] cipherText = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

            ByteBuffer buffer = ByteBuffer.allocate(iv.length + cipherText.length);
            buffer.put(iv);
            buffer.put(cipherText);

            return Base64.getEncoder().encodeToString(buffer.array());
        } catch (Exception e) {
            throw new RuntimeException("Error al encriptar", e);
        }
    }

    public String decrypt(String encryptedBase64) {
        try {
            byte[] decoded = Base64.getDecoder().decode(encryptedBase64);

            ByteBuffer buffer = ByteBuffer.wrap(decoded);
            byte[] iv = new byte[GCM_IV_LENGTH];
            buffer.get(iv);
            byte[] cipherText = new byte[buffer.remaining()];
            buffer.get(cipherText);

            Cipher cipher = Cipher.getInstance(GCM_ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, new GCMParameterSpec(GCM_TAG_BITS, iv));

            byte[] plainText = cipher.doFinal(cipherText);
            return new String(plainText, StandardCharsets.UTF_8);
        } catch (Exception e) {
            throw new RuntimeException("Error al desencriptar", e);
        }
    }

    /**
     * Desencripta datos encriptados con AES-CTR desde el frontend (CryptoJS).
     * Formato esperado: base64(IV_12bytes + ciphertext)
     */
    public String decryptFromFrontend(String encryptedBase64) {
        try {
            byte[] decoded = Base64.getDecoder().decode(encryptedBase64);

            ByteBuffer buffer = ByteBuffer.wrap(decoded);
            byte[] iv = new byte[CTR_IV_LENGTH];
            buffer.get(iv);
            byte[] cipherText = new byte[buffer.remaining()];
            buffer.get(cipherText);

            byte[] counterIv = new byte[16];
            System.arraycopy(iv, 0, counterIv, 0, iv.length);

            Cipher cipher = Cipher.getInstance(CTR_ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, new IvParameterSpec(counterIv));

            byte[] plainText = cipher.doFinal(cipherText);
            return new String(plainText, StandardCharsets.UTF_8);
        } catch (Exception e) {
            throw new RuntimeException("Error al desencriptar desde frontend", e);
        }
    }

    /**
     * Desencripta desde el frontend y verifica integridad comparando SHA-256.
     * @param encryptedBase64 texto encriptado con AES-CTR desde el frontend
     * @param expectedHash SHA-256 hex del texto plano original (generado por el frontend)
     * @return texto plano desencriptado si el hash coincide
     * @throws RuntimeException si la desencriptación falla o el hash no coincide
     */
    public String decryptAndVerify(String encryptedBase64, String expectedHash) {
        String plainText = decryptFromFrontend(encryptedBase64);
        String actualHash = sha256(plainText);
        if (!actualHash.equalsIgnoreCase(expectedHash)) {
            throw new RuntimeException("Verificación de integridad fallida: el hash SHA-256 no coincide");
        }
        return plainText;
    }

    public static String sha256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            return HexFormat.of().formatHex(hash);
        } catch (Exception e) {
            throw new RuntimeException("Error al generar SHA-256", e);
        }
    }
}
