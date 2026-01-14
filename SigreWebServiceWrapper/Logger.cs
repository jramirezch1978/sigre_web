using System;
using System.IO;
using System.Configuration;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Sistema de logging con rotación automática
    /// - Los logs se guardan en [Carpeta DLL]\log\SigreWebServiceWrapper.log
    /// - Cuando el archivo supera 2MB, se mueve a log\historico\ con timestamp
    /// </summary>
    public static class Logger
    {
        private static readonly object _lock = new object();
        private static string _logDir = null;
        private static string _logFile = null;
        private static string _historicoDir = null;
        private static bool _enabled = true;
        
        // Tamaño máximo del log en bytes (2 MB)
        private const long MAX_LOG_SIZE = 2 * 1024 * 1024;

        /// <summary>
        /// Obtiene la carpeta de logs
        /// </summary>
        private static string LogDir
        {
            get
            {
                if (_logDir == null)
                {
                    try
                    {
                        // Intentar obtener ruta del config
                        string configPath = ConfigurationManager.AppSettings["LogDir"];
                        if (!string.IsNullOrEmpty(configPath))
                        {
                            _logDir = configPath;
                        }
                        else
                        {
                            // Por defecto: carpeta log junto al DLL
                            string dllPath = typeof(Logger).Assembly.Location;
                            string dllDir = Path.GetDirectoryName(dllPath);
                            _logDir = Path.Combine(dllDir, "log");
                        }
                        
                        // Crear carpeta si no existe
                        if (!Directory.Exists(_logDir))
                        {
                            Directory.CreateDirectory(_logDir);
                        }
                    }
                    catch
                    {
                        // Fallback al directorio temporal
                        _logDir = Path.Combine(Path.GetTempPath(), "SigreWebServiceWrapper", "log");
                        if (!Directory.Exists(_logDir))
                        {
                            Directory.CreateDirectory(_logDir);
                        }
                    }
                }
                return _logDir;
            }
        }

        /// <summary>
        /// Obtiene la carpeta de logs históricos
        /// </summary>
        private static string HistoricoDir
        {
            get
            {
                if (_historicoDir == null)
                {
                    _historicoDir = Path.Combine(LogDir, "historico");
                    if (!Directory.Exists(_historicoDir))
                    {
                        Directory.CreateDirectory(_historicoDir);
                    }
                }
                return _historicoDir;
            }
        }

        /// <summary>
        /// Obtiene la ruta del archivo de log actual
        /// </summary>
        private static string LogFile
        {
            get
            {
                if (_logFile == null)
                {
                    _logFile = Path.Combine(LogDir, "SigreWebServiceWrapper.log");
                }
                return _logFile;
            }
        }

        /// <summary>
        /// Habilita o deshabilita el logging
        /// </summary>
        public static bool Enabled
        {
            get { return _enabled; }
            set { _enabled = value; }
        }

        /// <summary>
        /// Registra un mensaje informativo
        /// </summary>
        public static void Info(string mensaje)
        {
            Log("INFO", mensaje);
        }

        /// <summary>
        /// Registra un mensaje de advertencia
        /// </summary>
        public static void Warn(string mensaje)
        {
            Log("WARN", mensaje);
        }

        /// <summary>
        /// Registra un error
        /// </summary>
        public static void Error(string mensaje)
        {
            Log("ERROR", mensaje);
        }

        /// <summary>
        /// Registra una excepción
        /// </summary>
        public static void Error(string mensaje, Exception ex)
        {
            string fullMessage = mensaje;
            if (ex != null)
            {
                fullMessage += " | Exception: " + ex.GetType().Name + " - " + ex.Message;
                if (ex.InnerException != null)
                {
                    fullMessage += " | Inner: " + ex.InnerException.Message;
                }
            }
            Log("ERROR", fullMessage);
        }

        /// <summary>
        /// Registra un mensaje de debug (solo si está habilitado en config)
        /// </summary>
        public static void Debug(string mensaje)
        {
            try
            {
                string debugEnabled = ConfigurationManager.AppSettings["LogDebug"];
                if (debugEnabled != null && debugEnabled.ToLower() == "true")
                {
                    Log("DEBUG", mensaje);
                }
            }
            catch
            {
                // Ignorar errores de config
            }
        }

        /// <summary>
        /// Verifica el tamaño del log y lo rota si es necesario
        /// </summary>
        private static void CheckAndRotateLog()
        {
            try
            {
                if (File.Exists(LogFile))
                {
                    FileInfo fi = new FileInfo(LogFile);
                    if (fi.Length >= MAX_LOG_SIZE)
                    {
                        // Generar nombre con timestamp: SigreWebServiceWrapper_yyyyMMdd_HHmmss.log
                        string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                        string historicoFileName = string.Format("SigreWebServiceWrapper_{0}.log", timestamp);
                        string historicoPath = Path.Combine(HistoricoDir, historicoFileName);
                        
                        // Mover archivo al histórico
                        File.Move(LogFile, historicoPath);
                    }
                }
            }
            catch
            {
                // Si falla la rotación, continuar escribiendo en el mismo archivo
            }
        }

        /// <summary>
        /// Escribe una línea en el log
        /// </summary>
        private static void Log(string level, string mensaje)
        {
            if (!_enabled) return;

            try
            {
                lock (_lock)
                {
                    // Verificar si hay que rotar el log
                    CheckAndRotateLog();
                    
                    string logLine = string.Format("{0:yyyy-MM-dd HH:mm:ss} [{1}] {2}",
                        DateTime.Now, level, mensaje);

                    File.AppendAllText(LogFile, logLine + Environment.NewLine);
                }
            }
            catch
            {
                // No hacer nada si falla el logging
            }
        }

        /// <summary>
        /// Limpia el archivo de log actual
        /// </summary>
        public static void Clear()
        {
            try
            {
                lock (_lock)
                {
                    if (File.Exists(LogFile))
                    {
                        File.Delete(LogFile);
                    }
                }
            }
            catch
            {
                // Ignorar
            }
        }

        /// <summary>
        /// Limpia todos los logs históricos
        /// </summary>
        public static void ClearHistorico()
        {
            try
            {
                lock (_lock)
                {
                    if (Directory.Exists(HistoricoDir))
                    {
                        foreach (string file in Directory.GetFiles(HistoricoDir, "*.log"))
                        {
                            File.Delete(file);
                        }
                    }
                }
            }
            catch
            {
                // Ignorar
            }
        }

        /// <summary>
        /// Obtiene la ruta del archivo de log actual
        /// </summary>
        public static string GetLogPath()
        {
            return LogFile;
        }

        /// <summary>
        /// Obtiene la ruta de la carpeta de logs
        /// </summary>
        public static string GetLogDir()
        {
            return LogDir;
        }

        /// <summary>
        /// Obtiene la ruta de la carpeta de logs históricos
        /// </summary>
        public static string GetHistoricoDir()
        {
            return HistoricoDir;
        }
    }
}
