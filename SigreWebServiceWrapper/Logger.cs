using System;
using System.IO;
using System.Configuration;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Sistema de logging para registrar errores y eventos
    /// Los logs se guardan en SigreWebServiceWrapper.log junto al DLL
    /// </summary>
    public static class Logger
    {
        private static readonly object _lock = new object();
        private static string _logFile = null;
        private static bool _enabled = true;

        /// <summary>
        /// Obtiene la ruta del archivo de log
        /// </summary>
        private static string LogFile
        {
            get
            {
                if (_logFile == null)
                {
                    try
                    {
                        // Intentar obtener ruta del config
                        string configPath = ConfigurationManager.AppSettings["LogFile"];
                        if (!string.IsNullOrEmpty(configPath))
                        {
                            _logFile = configPath;
                        }
                        else
                        {
                            // Por defecto junto al DLL
                            string dllPath = typeof(Logger).Assembly.Location;
                            string dllDir = Path.GetDirectoryName(dllPath);
                            _logFile = Path.Combine(dllDir, "SigreWebServiceWrapper.log");
                        }
                    }
                    catch
                    {
                        // Fallback al directorio temporal
                        _logFile = Path.Combine(Path.GetTempPath(), "SigreWebServiceWrapper.log");
                    }
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
        /// Escribe una línea en el log
        /// </summary>
        private static void Log(string level, string mensaje)
        {
            if (!_enabled) return;

            try
            {
                lock (_lock)
                {
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
        /// Limpia el archivo de log
        /// </summary>
        public static void Clear()
        {
            try
            {
                if (File.Exists(LogFile))
                {
                    File.Delete(LogFile);
                }
            }
            catch
            {
                // Ignorar
            }
        }

        /// <summary>
        /// Obtiene la ruta del archivo de log
        /// </summary>
        public static string GetLogPath()
        {
            return LogFile;
        }
    }
}
