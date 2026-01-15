// SigreWrapper.cpp - DLL nativa para PowerBuilder
#define WIN32_LEAN_AND_MEAN
#define _WINSOCK_DEPRECATED_NO_WARNINGS

#include <windows.h>
#include <winhttp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <time.h>
#include <shlwapi.h>
#include <ole2.h>
#include <comdef.h>

#pragma comment(lib, "winhttp.lib")
#pragma comment(lib, "shlwapi.lib")
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "oleaut32.lib")
#pragma comment(lib, "ws2_32.lib")
#pragma comment(lib, "secur32.lib")
#pragma comment(lib, "crypt32.lib")

#include <winsock2.h>
#include <ws2tcpip.h>
#define SECURITY_WIN32
#include <security.h>
#include <schannel.h>

// ============================================================
// Variables globales
// ============================================================
static wchar_t g_result[16384];
static wchar_t g_token[4096];
static wchar_t g_usuario[256];
static wchar_t g_clave[256];
static wchar_t g_empresa[256];
static wchar_t g_dllPath[MAX_PATH];
static wchar_t g_iniPath[MAX_PATH];

// Configuración API (se carga desde SigreWebServiceWrapper.ini)
static wchar_t g_apiHost[256] = L"";
static int g_apiPort = 80;
static BOOL g_apiUseSSL = FALSE;
static wchar_t g_apiLoginPath[256] = L"";
static wchar_t g_apiConsultaPath[256] = L"";

// Configuración SMTP (se carga desde SigreWebServiceWrapper.ini)
static wchar_t g_smtpServer[256] = L"";
static int g_smtpPort = 465;
static wchar_t g_smtpUser[256] = L"";
static wchar_t g_smtpPass[256] = L"";
static wchar_t g_smtpFromName[256] = L"";
static BOOL g_smtpEnableSSL = TRUE;

// Configuración LOG
static BOOL g_logEnabled = TRUE;
static wchar_t g_logPath[MAX_PATH];
static int g_logMaxSizeMB = 2;

static HMODULE g_hModule = NULL;
static BOOL g_comInitialized = FALSE;

// ============================================================
// Funciones de configuración
// ============================================================

static void GetDllDirectory()
{
    GetModuleFileNameW(g_hModule, g_dllPath, MAX_PATH);
    PathRemoveFileSpecW(g_dllPath);
    
    wcscpy_s(g_iniPath, MAX_PATH, g_dllPath);
    wcscat_s(g_iniPath, MAX_PATH, L"\\SigreWebServiceWrapper.ini");
    
    wcscpy_s(g_logPath, MAX_PATH, g_dllPath);
    wcscat_s(g_logPath, MAX_PATH, L"\\log");
}

static void LoadConfiguration()
{
    if (GetFileAttributesW(g_iniPath) == INVALID_FILE_ATTRIBUTES) {
        return;
    }
    
    // [API]
    GetPrivateProfileStringW(L"API", L"ApiHost", L"pegazus.serveftp.com", 
                             g_apiHost, 256, g_iniPath);
    g_apiPort = GetPrivateProfileIntW(L"API", L"ApiPort", 9080, g_iniPath);
    
    wchar_t sslTemp[256];
    GetPrivateProfileStringW(L"API", L"ApiUseSSL", L"false", sslTemp, 256, g_iniPath);
    g_apiUseSSL = (_wcsicmp(sslTemp, L"true") == 0 || _wcsicmp(sslTemp, L"1") == 0);
    
    GetPrivateProfileStringW(L"API", L"ApiLoginPath", L"/SunatWebServices/api/auth/token",
                             g_apiLoginPath, 256, g_iniPath);
    GetPrivateProfileStringW(L"API", L"ApiConsultaPath", L"/SunatWebServices/api/ruc/consultar",
                             g_apiConsultaPath, 256, g_iniPath);
    
    // [SMTP]
    GetPrivateProfileStringW(L"SMTP", L"SmtpServer", L"smtp.gmail.com", 
                             g_smtpServer, 256, g_iniPath);
    g_smtpPort = GetPrivateProfileIntW(L"SMTP", L"SmtpPort", 587, g_iniPath);
    GetPrivateProfileStringW(L"SMTP", L"SmtpUser", L"no-reply@npssac.com.pe", 
                             g_smtpUser, 256, g_iniPath);
    GetPrivateProfileStringW(L"SMTP", L"SmtpPassword", L"", 
                             g_smtpPass, 256, g_iniPath);
    GetPrivateProfileStringW(L"SMTP", L"SmtpFromName", L"Sistema SIGRE", 
                             g_smtpFromName, 256, g_iniPath);
    
    wchar_t temp[256];
    GetPrivateProfileStringW(L"SMTP", L"SmtpEnableSSL", L"true", temp, 256, g_iniPath);
    g_smtpEnableSSL = (_wcsicmp(temp, L"true") == 0 || _wcsicmp(temp, L"1") == 0);
    
    // [LOG]
    GetPrivateProfileStringW(L"LOG", L"LogEnabled", L"true", temp, 256, g_iniPath);
    g_logEnabled = (_wcsicmp(temp, L"true") == 0 || _wcsicmp(temp, L"1") == 0);
    
    GetPrivateProfileStringW(L"LOG", L"LogPath", L"log", temp, 256, g_iniPath);
    if (PathIsRelativeW(temp)) {
        wcscpy_s(g_logPath, MAX_PATH, g_dllPath);
        wcscat_s(g_logPath, MAX_PATH, L"\\");
        wcscat_s(g_logPath, MAX_PATH, temp);
    } else {
        wcscpy_s(g_logPath, MAX_PATH, temp);
    }
    
    g_logMaxSizeMB = GetPrivateProfileIntW(L"LOG", L"LogMaxSizeMB", 2, g_iniPath);
}

// ============================================================
// Funciones de logging
// ============================================================

static void WriteLog(const wchar_t* level, const wchar_t* message)
{
    if (!g_logEnabled) return;
    
    CreateDirectoryW(g_logPath, NULL);
    
    wchar_t logFile[MAX_PATH];
    wcscpy_s(logFile, MAX_PATH, g_logPath);
    wcscat_s(logFile, MAX_PATH, L"\\SigreWebServiceWrapper.log");
    
    WIN32_FILE_ATTRIBUTE_DATA fileInfo;
    if (GetFileAttributesExW(logFile, GetFileExInfoStandard, &fileInfo)) {
        ULONGLONG fileSize = ((ULONGLONG)fileInfo.nFileSizeHigh << 32) | fileInfo.nFileSizeLow;
        if (fileSize > (ULONGLONG)g_logMaxSizeMB * 1024 * 1024) {
            wchar_t historicoPath[MAX_PATH];
            wcscpy_s(historicoPath, MAX_PATH, g_logPath);
            wcscat_s(historicoPath, MAX_PATH, L"\\historico");
            CreateDirectoryW(historicoPath, NULL);
            
            SYSTEMTIME st;
            GetLocalTime(&st);
            wchar_t newName[MAX_PATH];
            swprintf_s(newName, MAX_PATH, L"%s\\SigreWebServiceWrapper_%04d%02d%02d_%02d%02d%02d.log",
                      historicoPath, st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond);
            MoveFileW(logFile, newName);
        }
    }
    
    FILE* fp = NULL;
    _wfopen_s(&fp, logFile, L"a, ccs=UTF-8");
    if (fp) {
        SYSTEMTIME st;
        GetLocalTime(&st);
        fwprintf(fp, L"%04d-%02d-%02d %02d:%02d:%02d [%s] %s\n",
                st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond,
                level, message);
        fclose(fp);
    }
}

static void LogInfo(const wchar_t* message) { WriteLog(L"INFO", message); }
static void LogError(const wchar_t* message) { WriteLog(L"ERROR", message); }

// ============================================================
// Funciones HTTP
// ============================================================

static BOOL HttpRequest(
    const wchar_t* host, int port, const wchar_t* path,
    const wchar_t* method, const wchar_t* headers,
    const char* body, wchar_t* response, DWORD responseSize,
    BOOL useSSL = FALSE)
{
    HINTERNET hSession = NULL, hConnect = NULL, hRequest = NULL;
    BOOL result = FALSE;
    DWORD bytesRead = 0;
    char buffer[4096];
    
    hSession = WinHttpOpen(L"SigreWrapper/1.2", 
                           WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
                           WINHTTP_NO_PROXY_NAME, 
                           WINHTTP_NO_PROXY_BYPASS, 0);
    if (!hSession) goto cleanup;
    
    hConnect = WinHttpConnect(hSession, host, (INTERNET_PORT)port, 0);
    if (!hConnect) goto cleanup;
    
    hRequest = WinHttpOpenRequest(hConnect, method, path,
                                  NULL, WINHTTP_NO_REFERER,
                                  WINHTTP_DEFAULT_ACCEPT_TYPES,
                                  useSSL ? WINHTTP_FLAG_SECURE : 0);
    if (!hRequest) goto cleanup;
    
    if (headers && wcslen(headers) > 0) {
        WinHttpAddRequestHeaders(hRequest, headers, (DWORD)-1, WINHTTP_ADDREQ_FLAG_ADD);
    }
    
    DWORD bodyLen = body ? (DWORD)strlen(body) : 0;
    if (!WinHttpSendRequest(hRequest, WINHTTP_NO_ADDITIONAL_HEADERS, 0,
                            (LPVOID)body, bodyLen, bodyLen, 0)) {
        goto cleanup;
    }
    
    if (!WinHttpReceiveResponse(hRequest, NULL)) {
        goto cleanup;
    }
    
    response[0] = L'\0';
    while (WinHttpReadData(hRequest, buffer, sizeof(buffer) - 1, &bytesRead) && bytesRead > 0) {
        buffer[bytesRead] = '\0';
        wchar_t wbuffer[4096];
        MultiByteToWideChar(CP_UTF8, 0, buffer, -1, wbuffer, 4096);
        wcscat_s(response, responseSize / sizeof(wchar_t), wbuffer);
    }
    
    result = TRUE;

cleanup:
    if (hRequest) WinHttpCloseHandle(hRequest);
    if (hConnect) WinHttpCloseHandle(hConnect);
    if (hSession) WinHttpCloseHandle(hSession);
    
    return result;
}

// ============================================================
// SMTP Nativo con TLS usando Schannel (100% C++, sin dependencias externas)
// ============================================================

static BOOL g_wsaInitialized = FALSE;

// Contexto TLS
typedef struct {
    SOCKET sock;
    CredHandle hCreds;
    CtxtHandle hContext;
    SecPkgContext_StreamSizes sizes;
    BOOL useTLS;
    char* recvBuffer;
    size_t recvBufferSize;
    size_t recvBufferUsed;
} TlsContext;

// Base64 encode para autenticación y adjuntos
static void Base64EncodeBytes(const unsigned char* input, size_t inputLen, char* output, size_t outputSize)
{
    static const char b64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    size_t outIdx = 0;
    for (size_t i = 0; i < inputLen && outIdx < outputSize - 4; i += 3) {
        unsigned int b0 = input[i];
        unsigned int b1 = (i + 1 < inputLen) ? input[i + 1] : 0;
        unsigned int b2 = (i + 2 < inputLen) ? input[i + 2] : 0;
        output[outIdx++] = b64[b0 >> 2];
        output[outIdx++] = b64[((b0 & 0x03) << 4) | (b1 >> 4)];
        output[outIdx++] = (i + 1 < inputLen) ? b64[((b1 & 0x0F) << 2) | (b2 >> 6)] : '=';
        output[outIdx++] = (i + 2 < inputLen) ? b64[b2 & 0x3F] : '=';
    }
    output[outIdx] = '\0';
}

static void Base64EncodeString(const char* input, char* output, size_t outputSize)
{
    Base64EncodeBytes((const unsigned char*)input, strlen(input), output, outputSize);
}

// Inicializar Winsock
static BOOL InitWinsock()
{
    if (!g_wsaInitialized) {
        WSADATA wsaData;
        if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
            return FALSE;
        }
        g_wsaInitialized = TRUE;
    }
    return TRUE;
}

// Conectar socket
static SOCKET ConnectSocket(const char* host, int port)
{
    struct addrinfo hints = {0}, *result = NULL;
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    
    char portStr[16];
    sprintf_s(portStr, sizeof(portStr), "%d", port);
    
    if (getaddrinfo(host, portStr, &hints, &result) != 0) {
        return INVALID_SOCKET;
    }
    
    SOCKET sock = socket(result->ai_family, result->ai_socktype, result->ai_protocol);
    if (sock == INVALID_SOCKET) {
        freeaddrinfo(result);
        return INVALID_SOCKET;
    }
    
    // Timeout corto - usamos select() para control preciso
    DWORD timeout = 3000;  // 3 segundos máximo por operación
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(timeout));
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (char*)&timeout, sizeof(timeout));
    
    // Cerrar conexiones rápidamente
    struct linger lingerOpt = {1, 0};  // Linger on, cerrar inmediatamente
    setsockopt(sock, SOL_SOCKET, SO_LINGER, (char*)&lingerOpt, sizeof(lingerOpt));
    
    // Deshabilitar Nagle para mejor rendimiento con SMTP
    int nodelay = 1;
    setsockopt(sock, IPPROTO_TCP, TCP_NODELAY, (char*)&nodelay, sizeof(nodelay));
    
    if (connect(sock, result->ai_addr, (int)result->ai_addrlen) == SOCKET_ERROR) {
        closesocket(sock);
        freeaddrinfo(result);
        return INVALID_SOCKET;
    }
    
    freeaddrinfo(result);
    return sock;
}

// Iniciar TLS con Schannel - Versión robusta compatible con Windows 7+
static BOOL StartTLS(TlsContext* ctx, const char* host)
{
    wchar_t logMsg[512];
    swprintf_s(logMsg, 512, L"TLS: Iniciando conexion SSL a %hs", host);
    LogInfo(logMsg);
    
    // Configurar credenciales Schannel
    SCHANNEL_CRED schCred = {0};
    schCred.dwVersion = SCHANNEL_CRED_VERSION;
    
    // Habilitar TLS 1.0, 1.1 y 1.2 para máxima compatibilidad
    // Windows 7 SP1+ soporta TLS 1.2
    schCred.grbitEnabledProtocols = 0; // 0 = usar defaults del sistema (recomendado)
    
    // Flags para cliente: ignorar validación de certificado (como hace cryptlib)
    schCred.dwFlags = SCH_CRED_NO_DEFAULT_CREDS | 
                      SCH_CRED_MANUAL_CRED_VALIDATION |
                      SCH_CRED_IGNORE_NO_REVOCATION_CHECK |
                      SCH_CRED_IGNORE_REVOCATION_OFFLINE;
    
    SECURITY_STATUS ss = AcquireCredentialsHandleA(
        NULL, 
        (SEC_CHAR*)UNISP_NAME_A, 
        SECPKG_CRED_OUTBOUND, 
        NULL, 
        &schCred, 
        NULL, 
        NULL, 
        &ctx->hCreds, 
        NULL);
    
    if (ss != SEC_E_OK) {
        swprintf_s(logMsg, 512, L"TLS: AcquireCredentialsHandle fallo: 0x%08X", ss);
        LogError(logMsg);
        return FALSE;
    }
    LogInfo(L"TLS: Credenciales adquiridas");
    
    // Preparar buffers de salida
    SecBuffer outBuf = {0};
    outBuf.BufferType = SECBUFFER_TOKEN;
    outBuf.cbBuffer = 0;
    outBuf.pvBuffer = NULL;
    
    SecBufferDesc outDesc = {0};
    outDesc.ulVersion = SECBUFFER_VERSION;
    outDesc.cBuffers = 1;
    outDesc.pBuffers = &outBuf;
    
    // Flags de contexto - SNI se envía automáticamente cuando pasamos el hostname
    DWORD flags = ISC_REQ_SEQUENCE_DETECT | 
                  ISC_REQ_REPLAY_DETECT | 
                  ISC_REQ_CONFIDENTIALITY | 
                  ISC_REQ_ALLOCATE_MEMORY | 
                  ISC_REQ_STREAM;
    DWORD outFlags = 0;
    
    // Primera llamada - inicia el handshake y envía SNI con el hostname
    ss = InitializeSecurityContextA(
        &ctx->hCreds, 
        NULL,                    // Sin contexto previo
        (SEC_CHAR*)host,         // Hostname para SNI
        flags, 
        0, 
        0,
        NULL,                    // Sin buffer de entrada
        0, 
        &ctx->hContext, 
        &outDesc, 
        &outFlags, 
        NULL);
    
    if (ss != SEC_I_CONTINUE_NEEDED && ss != SEC_E_OK) {
        swprintf_s(logMsg, 512, L"TLS: InitializeSecurityContext inicial fallo: 0x%08X", ss);
        LogError(logMsg);
        FreeCredentialsHandle(&ctx->hCreds);
        return FALSE;
    }
    
    swprintf_s(logMsg, 512, L"TLS: Handshake iniciado, status=0x%08X, outBytes=%d", ss, outBuf.cbBuffer);
    LogInfo(logMsg);
    
    // Enviar token inicial (ClientHello)
    if (outBuf.cbBuffer > 0 && outBuf.pvBuffer) {
        int sent = send(ctx->sock, (char*)outBuf.pvBuffer, outBuf.cbBuffer, 0);
        if (sent != (int)outBuf.cbBuffer) {
            swprintf_s(logMsg, 512, L"TLS: Error enviando ClientHello: %d", WSAGetLastError());
            LogError(logMsg);
            FreeContextBuffer(outBuf.pvBuffer);
            FreeCredentialsHandle(&ctx->hCreds);
            return FALSE;
        }
        FreeContextBuffer(outBuf.pvBuffer);
        LogInfo(L"TLS: ClientHello enviado");
    }
    
    // Handshake loop - recibir ServerHello y completar
    char buffer[32768];
    int received = 0;
    int iteration = 0;
    const int MAX_ITERATIONS = 30;
    
    while (ss == SEC_I_CONTINUE_NEEDED || ss == SEC_E_INCOMPLETE_MESSAGE) {
        iteration++;
        if (iteration > MAX_ITERATIONS) {
            LogError(L"TLS: Demasiadas iteraciones en handshake");
            DeleteSecurityContext(&ctx->hContext);
            FreeCredentialsHandle(&ctx->hCreds);
            return FALSE;
        }
        
        // Recibir datos del servidor
        int r = recv(ctx->sock, buffer + received, sizeof(buffer) - received - 1, 0);
        if (r <= 0) {
            int wsaErr = WSAGetLastError();
            swprintf_s(logMsg, 512, L"TLS: recv fallo iter=%d, r=%d, WSAError=%d, received=%d", 
                      iteration, r, wsaErr, received);
            LogError(logMsg);
            DeleteSecurityContext(&ctx->hContext);
            FreeCredentialsHandle(&ctx->hCreds);
            return FALSE;
        }
        received += r;
        
        swprintf_s(logMsg, 512, L"TLS: Iter %d, recibidos %d bytes (total %d)", iteration, r, received);
        LogInfo(logMsg);
        
        // Preparar buffers de entrada
        SecBuffer inBufs[2] = {0};
        inBufs[0].BufferType = SECBUFFER_TOKEN;
        inBufs[0].cbBuffer = received;
        inBufs[0].pvBuffer = buffer;
        inBufs[1].BufferType = SECBUFFER_EMPTY;
        inBufs[1].cbBuffer = 0;
        inBufs[1].pvBuffer = NULL;
        
        SecBufferDesc inDesc = {0};
        inDesc.ulVersion = SECBUFFER_VERSION;
        inDesc.cBuffers = 2;
        inDesc.pBuffers = inBufs;
        
        // Preparar buffer de salida
        outBuf.BufferType = SECBUFFER_TOKEN;
        outBuf.cbBuffer = 0;
        outBuf.pvBuffer = NULL;
        outDesc.cBuffers = 1;
        outDesc.pBuffers = &outBuf;
        
        // Continuar handshake
        ss = InitializeSecurityContextA(
            &ctx->hCreds, 
            &ctx->hContext, 
            NULL,  // No necesitamos hostname aquí, ya lo enviamos
            flags, 
            0, 
            0,
            &inDesc, 
            0, 
            NULL, 
            &outDesc, 
            &outFlags, 
            NULL);
        
        swprintf_s(logMsg, 512, L"TLS: InitializeSecurityContext iter=%d, status=0x%08X", iteration, ss);
        LogInfo(logMsg);
        
        // Si necesita más datos, continuar recibiendo
        if (ss == SEC_E_INCOMPLETE_MESSAGE) {
            continue;
        }
        
        // Enviar respuesta si hay
        if (outBuf.cbBuffer > 0 && outBuf.pvBuffer) {
            int sent = send(ctx->sock, (char*)outBuf.pvBuffer, outBuf.cbBuffer, 0);
            swprintf_s(logMsg, 512, L"TLS: Enviados %d bytes de respuesta", outBuf.cbBuffer);
            LogInfo(logMsg);
            FreeContextBuffer(outBuf.pvBuffer);
            if (sent <= 0) {
                LogError(L"TLS: Error enviando respuesta");
                DeleteSecurityContext(&ctx->hContext);
                FreeCredentialsHandle(&ctx->hCreds);
                return FALSE;
            }
        }
        
        // Manejar datos extra (no consumidos)
        if (inBufs[1].BufferType == SECBUFFER_EXTRA && inBufs[1].cbBuffer > 0) {
            memmove(buffer, buffer + (received - inBufs[1].cbBuffer), inBufs[1].cbBuffer);
            received = inBufs[1].cbBuffer;
            swprintf_s(logMsg, 512, L"TLS: %d bytes extra movidos", inBufs[1].cbBuffer);
            LogInfo(logMsg);
        } else {
            received = 0;
        }
        
        // Si hay error (excepto continuar e incompleto), reportar
        if (ss != SEC_E_OK && ss != SEC_I_CONTINUE_NEEDED && ss != SEC_E_INCOMPLETE_MESSAGE) {
            swprintf_s(logMsg, 512, L"TLS: Handshake fallo con codigo: 0x%08X", ss);
            LogError(logMsg);
            DeleteSecurityContext(&ctx->hContext);
            FreeCredentialsHandle(&ctx->hCreds);
            return FALSE;
        }
    }
    
    if (ss != SEC_E_OK) {
        swprintf_s(logMsg, 512, L"TLS: Handshake final fallo: 0x%08X", ss);
        LogError(logMsg);
        DeleteSecurityContext(&ctx->hContext);
        FreeCredentialsHandle(&ctx->hCreds);
        return FALSE;
    }
    
    // Obtener tamaños de buffer para encripción
    ss = QueryContextAttributes(&ctx->hContext, SECPKG_ATTR_STREAM_SIZES, &ctx->sizes);
    if (ss != SEC_E_OK) {
        swprintf_s(logMsg, 512, L"TLS: QueryContextAttributes fallo: 0x%08X", ss);
        LogError(logMsg);
        DeleteSecurityContext(&ctx->hContext);
        FreeCredentialsHandle(&ctx->hCreds);
        return FALSE;
    }
    
    ctx->useTLS = TRUE;
    
    swprintf_s(logMsg, 512, L"TLS: Handshake exitoso! Header=%d, Trailer=%d, MaxMsg=%d",
              ctx->sizes.cbHeader, ctx->sizes.cbTrailer, ctx->sizes.cbMaximumMessage);
    LogInfo(logMsg);
    
    return TRUE;
}

// Enviar datos (con o sin TLS)
static int TlsSend(TlsContext* ctx, const char* data, int len)
{
    if (!ctx->useTLS) {
        return send(ctx->sock, data, len, 0);
    }
    
    // Encriptar y enviar
    size_t bufSize = ctx->sizes.cbHeader + len + ctx->sizes.cbTrailer;
    char* buf = (char*)malloc(bufSize);
    if (!buf) return -1;
    
    memcpy(buf + ctx->sizes.cbHeader, data, len);
    
    SecBuffer bufs[4] = {0};
    bufs[0].BufferType = SECBUFFER_STREAM_HEADER;
    bufs[0].cbBuffer = ctx->sizes.cbHeader;
    bufs[0].pvBuffer = buf;
    bufs[1].BufferType = SECBUFFER_DATA;
    bufs[1].cbBuffer = len;
    bufs[1].pvBuffer = buf + ctx->sizes.cbHeader;
    bufs[2].BufferType = SECBUFFER_STREAM_TRAILER;
    bufs[2].cbBuffer = ctx->sizes.cbTrailer;
    bufs[2].pvBuffer = buf + ctx->sizes.cbHeader + len;
    bufs[3].BufferType = SECBUFFER_EMPTY;
    
    SecBufferDesc desc = {0};
    desc.ulVersion = SECBUFFER_VERSION;
    desc.cBuffers = 4;
    desc.pBuffers = bufs;
    
    SECURITY_STATUS ss = EncryptMessage(&ctx->hContext, 0, &desc, 0);
    if (ss != SEC_E_OK) {
        free(buf);
        return -1;
    }
    
    int totalSize = bufs[0].cbBuffer + bufs[1].cbBuffer + bufs[2].cbBuffer;
    int sent = send(ctx->sock, buf, totalSize, 0);
    free(buf);
    
    return (sent == totalSize) ? len : -1;
}

// Recibir datos (con o sin TLS)
static int TlsRecv(TlsContext* ctx, char* data, int maxLen)
{
    if (!ctx->useTLS) {
        return recv(ctx->sock, data, maxLen, 0);
    }
    
    // Buffer para datos encriptados
    if (!ctx->recvBuffer) {
        ctx->recvBufferSize = 32768;
        ctx->recvBuffer = (char*)malloc(ctx->recvBufferSize);
        ctx->recvBufferUsed = 0;
    }
    
    BOOL firstIteration = TRUE;
    
    while (1) {
        // Intentar desencriptar lo que tenemos
        if (ctx->recvBufferUsed > 0) {
            SecBuffer bufs[4] = {0};
            bufs[0].BufferType = SECBUFFER_DATA;
            bufs[0].cbBuffer = (DWORD)ctx->recvBufferUsed;
            bufs[0].pvBuffer = ctx->recvBuffer;
            bufs[1].BufferType = SECBUFFER_EMPTY;
            bufs[2].BufferType = SECBUFFER_EMPTY;
            bufs[3].BufferType = SECBUFFER_EMPTY;
            
            SecBufferDesc desc = {0};
            desc.ulVersion = SECBUFFER_VERSION;
            desc.cBuffers = 4;
            desc.pBuffers = bufs;
            
            SECURITY_STATUS ss = DecryptMessage(&ctx->hContext, &desc, 0, NULL);
            
            if (ss == SEC_E_OK) {
                // Encontrar buffer de datos
                for (int i = 0; i < 4; i++) {
                    if (bufs[i].BufferType == SECBUFFER_DATA && bufs[i].cbBuffer > 0) {
                        int copyLen = min((int)bufs[i].cbBuffer, maxLen - 1);
                        memcpy(data, bufs[i].pvBuffer, copyLen);
                        data[copyLen] = '\0';
                        
                        // Mover datos extra
                        size_t extra = 0;
                        for (int j = 0; j < 4; j++) {
                            if (bufs[j].BufferType == SECBUFFER_EXTRA) {
                                extra = bufs[j].cbBuffer;
                                memmove(ctx->recvBuffer, bufs[j].pvBuffer, extra);
                                break;
                            }
                        }
                        ctx->recvBufferUsed = extra;
                        return copyLen;
                    }
                }
            } else if (ss != SEC_E_INCOMPLETE_MESSAGE) {
                return -1;
            }
        }
        
        // Usar select() para esperar datos - timeout mínimo
        fd_set readSet;
        FD_ZERO(&readSet);
        FD_SET(ctx->sock, &readSet);
        
        struct timeval tv;
        if (firstIteration) {
            tv.tv_sec = 0;
            tv.tv_usec = 500000;  // 500ms primera espera (el servidor ya debería haber respondido)
            firstIteration = FALSE;
        } else {
            tv.tv_sec = 0;
            tv.tv_usec = 50000;   // 50ms para datos fragmentados
        }
        
        int selectResult = select(0, &readSet, NULL, NULL, &tv);
        if (selectResult <= 0) {
            // Timeout - si tenemos datos parciales, intentar desencriptar
            if (ctx->recvBufferUsed > 0) continue;
            return 0;  // No hay más datos disponibles
        }
        
        // Recibir más datos
        int r = recv(ctx->sock, ctx->recvBuffer + ctx->recvBufferUsed, 
                    (int)(ctx->recvBufferSize - ctx->recvBufferUsed), 0);
        if (r <= 0) return r;
        ctx->recvBufferUsed += r;
    }
}

// Enviar comando SMTP y leer respuesta
static BOOL SmtpCommand(TlsContext* ctx, const char* cmd, char* response, size_t respSize, int expectedCode)
{
    wchar_t logMsg[512];
    
    if (cmd && strlen(cmd) > 0) {
        if (TlsSend(ctx, cmd, (int)strlen(cmd)) <= 0) {
            LogError(L"SmtpCommand: TlsSend fallo");
            return FALSE;
        }
    }
    
    // Leer respuesta - solo esperar lo necesario
    char buf[4096] = {0};
    int total = 0;
    
    // Una sola lectura debería ser suficiente para respuestas SMTP simples
    int r = TlsRecv(ctx, buf, sizeof(buf) - 1);
    if (r > 0) {
        total = r;
        buf[total] = '\0';
    }
    
    // Si la respuesta es multi-línea, seguir leyendo
    while (r > 0 && total < (int)sizeof(buf) - 1) {
        // Verificar si la respuesta está completa
        if (total >= 4) {
            char* lastNewline = strrchr(buf, '\n');
            if (lastNewline) {
                // Buscar la última línea completa
                char* lineStart = lastNewline;
                while (lineStart > buf && *(lineStart - 1) != '\n') lineStart--;
                if (lineStart > buf) lineStart++; // Saltar el \n anterior
                
                // Si la línea tiene formato "XXX " (código + espacio), es la última
                if (strlen(lineStart) >= 4 && isdigit(lineStart[0]) && 
                    isdigit(lineStart[1]) && isdigit(lineStart[2]) && lineStart[3] == ' ') {
                    break; // Respuesta completa
                }
            } else if (buf[3] == ' ') {
                break; // Respuesta simple de una línea
            }
        }
        
        // Leer más (con timeout muy corto)
        r = TlsRecv(ctx, buf + total, sizeof(buf) - total - 1);
        if (r > 0) {
            total += r;
            buf[total] = '\0';
        }
    }
    
    if (response) {
        strncpy_s(response, respSize, buf, respSize - 1);
    }
    
    int code = atoi(buf);
    BOOL success = (expectedCode == 0 || code == expectedCode || (expectedCode == 2 && code >= 200 && code < 300));
    
    if (!success && total > 0) {
        wchar_t respW[256];
        MultiByteToWideChar(CP_UTF8, 0, buf, -1, respW, 256);
        swprintf_s(logMsg, 512, L"SmtpCommand: Esperado %d, recibido %d: %.100s", expectedCode, code, respW);
        LogError(logMsg);
    }
    
    return success;
}

// Leer archivo y codificar en Base64
static char* ReadFileBase64(const wchar_t* filePath, size_t* outLen)
{
    HANDLE hFile = CreateFileW(filePath, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
    if (hFile == INVALID_HANDLE_VALUE) return NULL;
    
    DWORD fileSize = GetFileSize(hFile, NULL);
    if (fileSize == 0 || fileSize > 50 * 1024 * 1024) { // Max 50MB
        CloseHandle(hFile);
        return NULL;
    }
    
    unsigned char* fileData = (unsigned char*)malloc(fileSize);
    DWORD bytesRead;
    if (!ReadFile(hFile, fileData, fileSize, &bytesRead, NULL)) {
        free(fileData);
        CloseHandle(hFile);
        return NULL;
    }
    CloseHandle(hFile);
    
    // Calcular tamaño Base64 (4/3 del original + padding)
    size_t b64Size = ((fileSize + 2) / 3) * 4 + 1;
    char* b64Data = (char*)malloc(b64Size);
    Base64EncodeBytes(fileData, fileSize, b64Data, b64Size);
    free(fileData);
    
    if (outLen) *outLen = strlen(b64Data);
    return b64Data;
}

// Obtener nombre de archivo de una ruta
static void GetFileName(const wchar_t* path, char* name, size_t nameSize)
{
    const wchar_t* lastSlash = wcsrchr(path, L'\\');
    if (!lastSlash) lastSlash = wcsrchr(path, L'/');
    const wchar_t* fileName = lastSlash ? lastSlash + 1 : path;
    WideCharToMultiByte(CP_UTF8, 0, fileName, -1, name, (int)nameSize, NULL, NULL);
}

// Función principal de envío de correo
static BOOL SendEmailNative(
    const wchar_t* to,
    const wchar_t* toName,
    const wchar_t* cc,
    const wchar_t* bcc,
    const wchar_t* subject,
    const wchar_t* body,
    BOOL isHtml,
    const wchar_t* attachments,
    const wchar_t* fromEmail,   // Email del remitente (puede ser diferente a las credenciales)
    const wchar_t* fromName,    // Nombre del remitente
    wchar_t* errorMsg,
    size_t errorSize)
{
    if (!InitWinsock()) {
        wcscpy_s(errorMsg, errorSize, L"Error inicializando Winsock");
        return FALSE;
    }
    
    // Convertir configuración a UTF-8
    char smtpHost[256], smtpUser[256], smtpPass[256];
    WideCharToMultiByte(CP_UTF8, 0, g_smtpServer, -1, smtpHost, 256, NULL, NULL);
    WideCharToMultiByte(CP_UTF8, 0, g_smtpUser, -1, smtpUser, 256, NULL, NULL);
    WideCharToMultiByte(CP_UTF8, 0, g_smtpPass, -1, smtpPass, 256, NULL, NULL);
    
    char toAddr[256], subjectUtf8[1024], bodyUtf8[32768];
    WideCharToMultiByte(CP_UTF8, 0, to, -1, toAddr, 256, NULL, NULL);
    WideCharToMultiByte(CP_UTF8, 0, subject, -1, subjectUtf8, 1024, NULL, NULL);
    WideCharToMultiByte(CP_UTF8, 0, body, -1, bodyUtf8, 32768, NULL, NULL);
    
    // Conectar
    TlsContext ctx = {0};
    ctx.sock = ConnectSocket(smtpHost, g_smtpPort);
    if (ctx.sock == INVALID_SOCKET) {
        swprintf_s(errorMsg, errorSize, L"No se pudo conectar a %s:%d", g_smtpServer, g_smtpPort);
        return FALSE;
    }
    
    char response[4096];
    BOOL success = FALSE;
    
    // Puerto 465 = SSL implícito (iniciar TLS inmediatamente)
    if (g_smtpEnableSSL && g_smtpPort == 465) {
        if (!StartTLS(&ctx, smtpHost)) {
            wcscpy_s(errorMsg, errorSize, L"Error iniciando SSL (puerto 465)");
            goto cleanup;
        }
    }
    
    // Leer banner
    LogInfo(L"SMTP: Esperando banner del servidor...");
    if (!SmtpCommand(&ctx, NULL, response, sizeof(response), 220)) {
        wcscpy_s(errorMsg, errorSize, L"Error: servidor no respondio");
        goto cleanup;
    }
    LogInfo(L"SMTP: Banner recibido OK");
    
    // EHLO
    LogInfo(L"SMTP: Enviando EHLO...");
    char ehloCmd[256];
    sprintf_s(ehloCmd, sizeof(ehloCmd), "EHLO localhost\r\n");
    if (!SmtpCommand(&ctx, ehloCmd, response, sizeof(response), 250)) {
        wcscpy_s(errorMsg, errorSize, L"Error en EHLO");
        goto cleanup;
    }
    LogInfo(L"SMTP: EHLO OK");
    
    // STARTTLS si es necesario
    if (g_smtpEnableSSL && g_smtpPort != 465) {
        LogInfo(L"SMTP: Enviando STARTTLS...");
        if (!SmtpCommand(&ctx, "STARTTLS\r\n", response, sizeof(response), 220)) {
            wcscpy_s(errorMsg, errorSize, L"Error en STARTTLS");
            goto cleanup;
        }
        
        if (!StartTLS(&ctx, smtpHost)) {
            wcscpy_s(errorMsg, errorSize, L"Error iniciando TLS");
            goto cleanup;
        }
        
        // EHLO de nuevo después de TLS
        if (!SmtpCommand(&ctx, ehloCmd, response, sizeof(response), 250)) {
            wcscpy_s(errorMsg, errorSize, L"Error en EHLO post-TLS");
            goto cleanup;
        }
    }
    
    // AUTH LOGIN
    LogInfo(L"SMTP: Enviando AUTH LOGIN...");
    if (!SmtpCommand(&ctx, "AUTH LOGIN\r\n", response, sizeof(response), 334)) {
        wcscpy_s(errorMsg, errorSize, L"Error en AUTH LOGIN");
        goto cleanup;
    }
    LogInfo(L"SMTP: AUTH LOGIN OK, enviando usuario...");
    
    char userB64[512], passB64[512];
    Base64EncodeString(smtpUser, userB64, sizeof(userB64));
    strcat_s(userB64, sizeof(userB64), "\r\n");
    if (!SmtpCommand(&ctx, userB64, response, sizeof(response), 334)) {
        wcscpy_s(errorMsg, errorSize, L"Error en usuario AUTH");
        goto cleanup;
    }
    LogInfo(L"SMTP: Usuario enviado, enviando password...");
    
    Base64EncodeString(smtpPass, passB64, sizeof(passB64));
    strcat_s(passB64, sizeof(passB64), "\r\n");
    if (!SmtpCommand(&ctx, passB64, response, sizeof(response), 235)) {
        wcscpy_s(errorMsg, errorSize, L"Error: autenticacion fallida");
        goto cleanup;
    }
    LogInfo(L"SMTP: Autenticacion exitosa!");
    
    // MAIL FROM
    LogInfo(L"SMTP: Enviando MAIL FROM...");
    char mailFrom[512];
    sprintf_s(mailFrom, sizeof(mailFrom), "MAIL FROM:<%s>\r\n", smtpUser);
    if (!SmtpCommand(&ctx, mailFrom, response, sizeof(response), 250)) {
        wcscpy_s(errorMsg, errorSize, L"Error en MAIL FROM");
        goto cleanup;
    }
    LogInfo(L"SMTP: MAIL FROM OK");
    
    // RCPT TO
    LogInfo(L"SMTP: Enviando RCPT TO...");
    char rcptTo[512];
    sprintf_s(rcptTo, sizeof(rcptTo), "RCPT TO:<%s>\r\n", toAddr);
    if (!SmtpCommand(&ctx, rcptTo, response, sizeof(response), 250)) {
        wcscpy_s(errorMsg, errorSize, L"Error en RCPT TO");
        goto cleanup;
    }
    LogInfo(L"SMTP: RCPT TO OK");
    
    // CC
    if (cc && wcslen(cc) > 0) {
        char ccAddr[256];
        WideCharToMultiByte(CP_UTF8, 0, cc, -1, ccAddr, 256, NULL, NULL);
        sprintf_s(rcptTo, sizeof(rcptTo), "RCPT TO:<%s>\r\n", ccAddr);
        SmtpCommand(&ctx, rcptTo, response, sizeof(response), 250);
    }
    
    // BCC
    if (bcc && wcslen(bcc) > 0) {
        char bccAddr[256];
        WideCharToMultiByte(CP_UTF8, 0, bcc, -1, bccAddr, 256, NULL, NULL);
        sprintf_s(rcptTo, sizeof(rcptTo), "RCPT TO:<%s>\r\n", bccAddr);
        SmtpCommand(&ctx, rcptTo, response, sizeof(response), 250);
    }
    
    // DATA
    LogInfo(L"SMTP: Enviando DATA...");
    if (!SmtpCommand(&ctx, "DATA\r\n", response, sizeof(response), 354)) {
        wcscpy_s(errorMsg, errorSize, L"Error en DATA");
        goto cleanup;
    }
    LogInfo(L"SMTP: DATA OK, enviando mensaje...");
    
    // Construir mensaje
    char boundary[64];
    sprintf_s(boundary, sizeof(boundary), "----=_Part_%08X", GetTickCount());
    
    BOOL hasAttachments = (attachments && wcslen(attachments) > 0);
    
    // Headers
    char headers[8192];
    char fromNameUtf8[256], fromEmailUtf8[256];
    
    // Usar fromEmail/fromName si se proporcionan, sino usar los de configuración
    if (fromEmail && wcslen(fromEmail) > 0) {
        WideCharToMultiByte(CP_UTF8, 0, fromEmail, -1, fromEmailUtf8, 256, NULL, NULL);
    } else {
        strcpy_s(fromEmailUtf8, sizeof(fromEmailUtf8), smtpUser);
    }
    
    if (fromName && wcslen(fromName) > 0) {
        WideCharToMultiByte(CP_UTF8, 0, fromName, -1, fromNameUtf8, 256, NULL, NULL);
    } else {
        WideCharToMultiByte(CP_UTF8, 0, g_smtpFromName, -1, fromNameUtf8, 256, NULL, NULL);
    }
    
    int hPos = sprintf_s(headers, sizeof(headers),
        "From: %s <%s>\r\n"
        "To: %s\r\n"
        "Subject: =?UTF-8?B?",
        fromNameUtf8, fromEmailUtf8, toAddr);
    
    // Subject en Base64 para UTF-8
    char subjectB64[2048];
    Base64EncodeString(subjectUtf8, subjectB64, sizeof(subjectB64));
    hPos += sprintf_s(headers + hPos, sizeof(headers) - hPos, "%s?=\r\n", subjectB64);
    
    hPos += sprintf_s(headers + hPos, sizeof(headers) - hPos,
        "MIME-Version: 1.0\r\n");
    
    if (hasAttachments) {
        hPos += sprintf_s(headers + hPos, sizeof(headers) - hPos,
            "Content-Type: multipart/mixed; boundary=\"%s\"\r\n\r\n"
            "--%s\r\n", boundary, boundary);
    }
    
    hPos += sprintf_s(headers + hPos, sizeof(headers) - hPos,
        "Content-Type: %s; charset=UTF-8\r\n"
        "Content-Transfer-Encoding: base64\r\n\r\n",
        isHtml ? "text/html" : "text/plain");
    
    TlsSend(&ctx, headers, (int)strlen(headers));
    
    // Body en Base64
    char bodyB64[65536];
    Base64EncodeString(bodyUtf8, bodyB64, sizeof(bodyB64));
    
    // Enviar body en líneas de 76 caracteres
    size_t bodyB64Len = strlen(bodyB64);
    for (size_t i = 0; i < bodyB64Len; i += 76) {
        size_t lineLen = min((size_t)76, bodyB64Len - i);
        TlsSend(&ctx, bodyB64 + i, (int)lineLen);
        TlsSend(&ctx, "\r\n", 2);
    }
    
    // Adjuntos
    if (hasAttachments) {
        wchar_t* attachCopy = _wcsdup(attachments);
        wchar_t* context = NULL;
        wchar_t* token = wcstok_s(attachCopy, L"|", &context);
        
        while (token) {
            // Verificar que el archivo existe
            if (GetFileAttributesW(token) != INVALID_FILE_ATTRIBUTES) {
                char fileName[256];
                GetFileName(token, fileName, sizeof(fileName));
                
                size_t fileB64Len = 0;
                char* fileB64 = ReadFileBase64(token, &fileB64Len);
                
                if (fileB64) {
                    char attachHeader[1024];
                    sprintf_s(attachHeader, sizeof(attachHeader),
                        "\r\n--%s\r\n"
                        "Content-Type: application/octet-stream; name=\"%s\"\r\n"
                        "Content-Transfer-Encoding: base64\r\n"
                        "Content-Disposition: attachment; filename=\"%s\"\r\n\r\n",
                        boundary, fileName, fileName);
                    
                    TlsSend(&ctx, attachHeader, (int)strlen(attachHeader));
                    
                    // Enviar archivo en líneas de 76 caracteres
                    for (size_t i = 0; i < fileB64Len; i += 76) {
                        size_t lineLen = min((size_t)76, fileB64Len - i);
                        TlsSend(&ctx, fileB64 + i, (int)lineLen);
                        TlsSend(&ctx, "\r\n", 2);
                    }
                    
                    free(fileB64);
                }
            }
            token = wcstok_s(NULL, L"|", &context);
        }
        free(attachCopy);
        
        // Boundary final
        char endBoundary[128];
        sprintf_s(endBoundary, sizeof(endBoundary), "\r\n--%s--\r\n", boundary);
        TlsSend(&ctx, endBoundary, (int)strlen(endBoundary));
    }
    
    // Fin del mensaje
    LogInfo(L"SMTP: Finalizando mensaje...");
    if (!SmtpCommand(&ctx, "\r\n.\r\n", response, sizeof(response), 250)) {
        wcscpy_s(errorMsg, errorSize, L"Error finalizando mensaje");
        goto cleanup;
    }
    LogInfo(L"SMTP: Mensaje aceptado por el servidor!");
    
    // QUIT
    LogInfo(L"SMTP: Enviando QUIT...");
    SmtpCommand(&ctx, "QUIT\r\n", response, sizeof(response), 221);
    
    success = TRUE;
    LogInfo(L"SMTP: Correo enviado exitosamente!");
    wcscpy_s(errorMsg, errorSize, L"Correo enviado exitosamente");

cleanup:
    // Limpiar recursos TLS
    if (ctx.useTLS) {
        DeleteSecurityContext(&ctx.hContext);
        FreeCredentialsHandle(&ctx.hCreds);
        ctx.useTLS = FALSE;
    }
    
    // Liberar buffer de recepción
    if (ctx.recvBuffer) {
        free(ctx.recvBuffer);
        ctx.recvBuffer = NULL;
    }
    
    // Cerrar socket
    if (ctx.sock != INVALID_SOCKET) {
        // Enviar shutdown antes de cerrar (graceful close)
        shutdown(ctx.sock, SD_BOTH);
        closesocket(ctx.sock);
        ctx.sock = INVALID_SOCKET;
    }
    
    return success;
}

// ============================================================
// Funciones exportadas
// ============================================================

extern "C" {

__declspec(dllexport) const wchar_t* __stdcall ObtenerVersion()
{
    return L"2.0.0";
}

__declspec(dllexport) const wchar_t* __stdcall ConfigurarCredencialesRuc(
    const wchar_t* usuario, const wchar_t* clave, const wchar_t* empresa)
{
    if (usuario) wcscpy_s(g_usuario, 256, usuario);
    if (clave) wcscpy_s(g_clave, 256, clave);
    if (empresa) wcscpy_s(g_empresa, 256, empresa);
    
    wchar_t logMsg[512];
    swprintf_s(logMsg, 512, L"ConfigurarCredencialesRuc: usuario=%s, empresa=%s", g_usuario, g_empresa);
    LogInfo(logMsg);
    
    wcscpy_s(g_result, 16384, L"{\"exitoso\":true,\"mensaje\":\"Credenciales configuradas\"}");
    return g_result;
}

__declspec(dllexport) const wchar_t* __stdcall ObtenerTokenRest(
    const wchar_t* usuario, const wchar_t* clave, const wchar_t* empresa)
{
    LogInfo(L"ObtenerTokenRest: iniciando");
    
    if (usuario) wcscpy_s(g_usuario, 256, usuario);
    if (clave) wcscpy_s(g_clave, 256, clave);
    if (empresa) wcscpy_s(g_empresa, 256, empresa);
    
    char body[1024];
    char user_utf8[256], pass_utf8[256], emp_utf8[256];
    WideCharToMultiByte(CP_UTF8, 0, g_usuario, -1, user_utf8, 256, NULL, NULL);
    WideCharToMultiByte(CP_UTF8, 0, g_clave, -1, pass_utf8, 256, NULL, NULL);
    WideCharToMultiByte(CP_UTF8, 0, g_empresa, -1, emp_utf8, 256, NULL, NULL);
    
    sprintf_s(body, sizeof(body), 
              "{\"usuario\":\"%s\",\"clave\":\"%s\",\"empresa\":\"%s\"}",
              user_utf8, pass_utf8, emp_utf8);
    
    wchar_t response[4096] = {0};
    
    if (HttpRequest(g_apiHost, g_apiPort, g_apiLoginPath, L"POST",
                    L"Content-Type: application/json\r\n", body, response, sizeof(response), g_apiUseSSL))
    {
        wchar_t* tokenStart = wcsstr(response, L"\"token\":\"");
        if (tokenStart) {
            tokenStart += 9;
            wchar_t* tokenEnd = wcschr(tokenStart, L'"');
            if (tokenEnd) {
                size_t len = tokenEnd - tokenStart;
                wcsncpy_s(g_token, 4096, tokenStart, len);
                g_token[len] = L'\0';
                wcscpy_s(g_result, 16384, g_token);
                LogInfo(L"ObtenerTokenRest: token obtenido");
                return g_result;
            }
        }
        wcscpy_s(g_result, 16384, response);
        LogError(L"ObtenerTokenRest: token no encontrado en respuesta");
    }
    else {
        wcscpy_s(g_result, 16384, L"ERROR: No se pudo conectar");
        LogError(L"ObtenerTokenRest: error de conexion");
    }
    
    return g_result;
}

__declspec(dllexport) const wchar_t* __stdcall ConsultarRuc(
    const wchar_t* ruc, const wchar_t* rucOrigen, const wchar_t* computerName)
{
    wchar_t logMsg[512];
    swprintf_s(logMsg, 512, L"ConsultarRuc: ruc=%s", ruc ? ruc : L"null");
    LogInfo(logMsg);
    
    if (wcslen(g_token) == 0) {
        wcscpy_s(g_result, 16384, L"{\"exitoso\":false,\"mensaje\":\"No hay token\"}");
        return g_result;
    }
    
    wchar_t path[512];
    swprintf_s(path, 512, L"%s?ruc=%s&rucOrigen=%s&computerName=%s",
               g_apiConsultaPath, ruc ? ruc : L"", rucOrigen ? rucOrigen : L"",
               computerName ? computerName : L"PC");
    
    wchar_t headers[4096];
    swprintf_s(headers, 4096, L"Authorization: Bearer %s\r\n", g_token);
    
    wchar_t response[8192] = {0};
    
    if (HttpRequest(g_apiHost, g_apiPort, path, L"GET", headers, NULL, response, sizeof(response), g_apiUseSSL)) {
        wcscpy_s(g_result, 16384, response);
        LogInfo(L"ConsultarRuc: exitoso");
    } else {
        wcscpy_s(g_result, 16384, L"{\"exitoso\":false,\"mensaje\":\"Error de conexion\"}");
        LogError(L"ConsultarRuc: error");
    }
    
    return g_result;
}

// Función auxiliar: Parsear "email, nombre" y extraer email y nombre
static void ParseEmailNombre(const wchar_t* input, wchar_t* email, size_t emailSize, wchar_t* nombre, size_t nombreSize)
{
    email[0] = L'\0';
    nombre[0] = L'\0';
    
    if (!input || wcslen(input) == 0) return;
    
    const wchar_t* comma = wcschr(input, L',');
    if (comma) {
        // Copiar email (antes de la coma)
        size_t emailLen = comma - input;
        if (emailLen > 0 && emailLen < emailSize) {
            wcsncpy_s(email, emailSize, input, emailLen);
            // Quitar espacios al final
            while (emailLen > 0 && email[emailLen-1] == L' ') {
                email[--emailLen] = L'\0';
            }
        }
        
        // Copiar nombre (después de la coma, saltando espacios)
        const wchar_t* nameStart = comma + 1;
        while (*nameStart == L' ') nameStart++;
        // Quitar punto y coma al final si existe
        size_t nameLen = wcslen(nameStart);
        if (nameLen > 0 && nameStart[nameLen-1] == L';') nameLen--;
        if (nameLen > 0 && nameLen < nombreSize) {
            wcsncpy_s(nombre, nombreSize, nameStart, nameLen);
        }
    } else {
        // Solo email, sin nombre
        wcscpy_s(email, emailSize, input);
        // Quitar punto y coma al final si existe
        size_t len = wcslen(email);
        if (len > 0 && email[len-1] == L';') email[len-1] = L'\0';
    }
}

// Función auxiliar: Extraer solo emails de formato "email1, nombre1; email2, nombre2;"
static void ExtractEmails(const wchar_t* input, wchar_t* emails, size_t emailsSize)
{
    emails[0] = L'\0';
    if (!input || wcslen(input) == 0) return;
    
    wchar_t buffer[4096];
    wcscpy_s(buffer, 4096, input);
    
    wchar_t* context = NULL;
    wchar_t* token = wcstok_s(buffer, L";", &context);
    BOOL first = TRUE;
    
    while (token) {
        wchar_t email[256], nombre[256];
        ParseEmailNombre(token, email, 256, nombre, 256);
        
        if (wcslen(email) > 0) {
            if (!first) wcscat_s(emails, emailsSize, L";");
            wcscat_s(emails, emailsSize, email);
            first = FALSE;
        }
        
        token = wcstok_s(NULL, L";", &context);
    }
}

// ============================================================
// FUNCION PRINCIPAL UNIFICADA: EnviarEmail
// ============================================================
// Formatos:
//   remitente: "email, nombre" (ej: "sigre@npssac.com.pe, SIGRE ERP")
//   destinatarios: "email1, nombre1; email2, nombre2;" (separados por ;)
//   cc: mismo formato que destinatarios (o vacío)
//   cco: mismo formato que destinatarios (o vacío)
//   adjuntos: rutas separadas por | (ej: "C:\file1.pdf|C:\file2.xlsx")
// ============================================================
__declspec(dllexport) const wchar_t* __stdcall EnviarEmail(
    const wchar_t* remitente,      // "email, nombre"
    const wchar_t* destinatarios,  // "email, nombre; email2, nombre2;"
    const wchar_t* cc,             // igual formato o vacío
    const wchar_t* cco,            // igual formato o vacío
    const wchar_t* asunto,
    const wchar_t* mensaje,
    int esHtml,
    const wchar_t* adjuntos)       // rutas separadas por |
{
    wchar_t fromEmail[256] = {0};
    wchar_t fromName[256] = {0};
    wchar_t toEmails[2048] = {0};
    wchar_t ccEmails[2048] = {0};
    wchar_t ccoEmails[2048] = {0};
    
    // Parsear remitente
    ParseEmailNombre(remitente, fromEmail, 256, fromName, 256);
    
    // Extraer emails de destinatarios
    ExtractEmails(destinatarios, toEmails, 2048);
    
    // Extraer emails de CC (si existe)
    if (cc && wcslen(cc) > 0) {
        ExtractEmails(cc, ccEmails, 2048);
    }
    
    // Extraer emails de CCO (si existe)
    if (cco && wcslen(cco) > 0) {
        ExtractEmails(cco, ccoEmails, 2048);
    }
    
    wchar_t logMsg[512];
    swprintf_s(logMsg, 512, L"EnviarEmail: from=%s <%s>, to=%s, subject=%s", 
               fromName, fromEmail, toEmails, asunto ? asunto : L"null");
    LogInfo(logMsg);
    
    wchar_t errorMsg[512];
    
    const wchar_t* pFromEmail = (wcslen(fromEmail) > 0) ? fromEmail : NULL;
    const wchar_t* pFromName = (wcslen(fromName) > 0) ? fromName : NULL;
    const wchar_t* pCC = (wcslen(ccEmails) > 0) ? ccEmails : NULL;
    const wchar_t* pCCO = (wcslen(ccoEmails) > 0) ? ccoEmails : NULL;
    
    if (SendEmailNative(toEmails, NULL, pCC, pCCO, asunto, mensaje, 
                     esHtml != 0, adjuntos, pFromEmail, pFromName, errorMsg, 512))
    {
        swprintf_s(g_result, 16384, L"{\"exitoso\":true,\"mensaje\":\"%s\"}", errorMsg);
        LogInfo(L"EnviarEmail: exitoso");
    }
    else {
        swprintf_s(g_result, 16384, L"{\"exitoso\":false,\"mensaje\":\"%s\"}", errorMsg);
        LogError(errorMsg);
    }
    
    return g_result;
}

__declspec(dllexport) const wchar_t* __stdcall ObtenerConfiguracion()
{
    swprintf_s(g_result, 16384,
        L"{\"apiHost\":\"%s\",\"apiPort\":%d,\"smtpServer\":\"%s\",\"smtpPort\":%d,"
        L"\"smtpUser\":\"%s\",\"logEnabled\":%s,\"logPath\":\"%s\",\"version\":\"2.1.0\"}",
        g_apiHost, g_apiPort, g_smtpServer, g_smtpPort, g_smtpUser,
        g_logEnabled ? L"true" : L"false", g_logPath);
    return g_result;
}

} // extern "C"

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
    if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
        g_hModule = hModule;
        g_token[0] = L'\0';
        g_usuario[0] = L'\0';
        g_clave[0] = L'\0';
        g_empresa[0] = L'\0';
        
        GetDllDirectory();
        LoadConfiguration();
        
        // Inicializar COM
        HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
        g_comInitialized = SUCCEEDED(hr);
        
        LogInfo(L"DLL cargada - SigreWebServiceWrapper v2.0.0 (SMTP nativo TLS)");
    }
    else if (ul_reason_for_call == DLL_PROCESS_DETACH) {
        LogInfo(L"DLL descargada");
        if (g_comInitialized) {
            CoUninitialize();
        }
    }
    return TRUE;
}
