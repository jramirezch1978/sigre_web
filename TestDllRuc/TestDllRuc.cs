using System;
using System.Drawing;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;

namespace TestDllRuc
{
    internal static class FileLogger
    {
        private static string _logFile;
        private static readonly object _lock = new object();

        public static string LogFile { get { return _logFile; } }

        public static void Inicializar()
        {
            string dir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logs");
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
            string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
            _logFile = Path.Combine(dir, "TestDllRuc_" + timestamp + ".log");
            Escribir("========================================================");
            Escribir("  TestDllRuc - Log iniciado");
            Escribir("  Fecha: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            Escribir("  Equipo: " + Environment.MachineName);
            Escribir("  OS: " + Environment.OSVersion);
            Escribir("  Directorio exe: " + dir);
            Escribir("  Archivo log: " + _logFile);
            Escribir("========================================================");
        }

        public static void Escribir(string mensaje)
        {
            if (string.IsNullOrEmpty(_logFile)) return;
            try
            {
                lock (_lock)
                {
                    File.AppendAllText(_logFile,
                        DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") + " | " + mensaje + Environment.NewLine);
                }
            }
            catch { }
        }

        public static void Info(string operacion, string detalle)
        {
            Escribir("[INFO ] " + operacion + " => " + detalle);
        }

        public static void Error(string operacion, string detalle)
        {
            Escribir("[ERROR] " + operacion + " => " + detalle);
        }

        public static void Error(string operacion, Exception ex)
        {
            Escribir("[ERROR] " + operacion + " => " + ex.GetType().Name + ": " + ex.Message);
            if (ex.InnerException != null)
                Escribir("[ERROR]   InnerException: " + ex.InnerException.Message);
            Escribir("[ERROR]   StackTrace: " + ex.StackTrace);
        }
    }

    internal class SigreDll : IDisposable
    {
        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
        private static extern IntPtr LoadLibrary(string lpFileName);

        [DllImport("kernel32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool FreeLibrary(IntPtr hModule);

        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Ansi, ExactSpelling = true)]
        private static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

        [UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Unicode)]
        private delegate IntPtr FnSinParams();

        [UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Unicode)]
        private delegate IntPtr FnDosParams(
            [MarshalAs(UnmanagedType.LPWStr)] string p1,
            [MarshalAs(UnmanagedType.LPWStr)] string p2);

        [UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Unicode)]
        private delegate IntPtr FnCincoParams(
            [MarshalAs(UnmanagedType.LPWStr)] string p1,
            [MarshalAs(UnmanagedType.LPWStr)] string p2,
            [MarshalAs(UnmanagedType.LPWStr)] string p3,
            [MarshalAs(UnmanagedType.LPWStr)] string p4,
            [MarshalAs(UnmanagedType.LPWStr)] string p5);

            [UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Unicode)]
        private delegate void FnVoidSinParams();

        private IntPtr _hModule = IntPtr.Zero;
        private string _dllPath;

        public string DllPath { get { return _dllPath; } }
        public bool IsLoaded { get { return _hModule != IntPtr.Zero; } }

        public string Cargar(string path)
        {
            FileLogger.Info("CARGAR_DLL", "Intentando cargar: " + path);

            if (_hModule != IntPtr.Zero)
            {
                FileLogger.Info("CARGAR_DLL", "Liberando DLL anterior: " + (_dllPath ?? "?"));
                FreeLibrary(_hModule);
                _hModule = IntPtr.Zero;
            }

            _dllPath = path;
            _hModule = LoadLibrary(path);

            if (_hModule == IntPtr.Zero)
            {
                int err = Marshal.GetLastWin32Error();
                string msg = "Error al cargar DLL (Win32 error " + err + "): " + path;
                FileLogger.Error("CARGAR_DLL", msg);
                return msg;
            }

            FileLogger.Info("CARGAR_DLL", "DLL cargado OK. Handle: 0x" + _hModule.ToString("X") + " - " + path);
            ListarFunciones(path);
            return null;
        }

        private void ListarFunciones(string path)
        {
            string[] funciones = {
                "ObtenerVersion", "ObtenerIpLocal", "ConfigurarCredencialesRuc",
                "ObtenerTokenRest", "ObtenerInfoToken", "ForzarRenovacionToken",
                "ConsultarRuc", "EnviarEmail", "ObtenerConfiguracion"
            };
            FileLogger.Info("CARGAR_DLL", "--- Funciones exportadas detectadas ---");
            foreach (string fn in funciones)
            {
                IntPtr addr = GetProcAddress(_hModule, fn);
                if (addr != IntPtr.Zero)
                    FileLogger.Info("CARGAR_DLL", "  [OK] " + fn + " -> 0x" + addr.ToString("X"));
                else
                    FileLogger.Info("CARGAR_DLL", "  [--] " + fn + " -> NO ENCONTRADA");
            }
            FileLogger.Info("CARGAR_DLL", "--- Fin lista funciones ---");
        }

        public void Liberar()
        {
            if (_hModule != IntPtr.Zero)
            {
                FileLogger.Info("LIBERAR_DLL", "FreeLibrary: " + (_dllPath ?? "?"));
                FreeLibrary(_hModule);
                _hModule = IntPtr.Zero;
            }
        }

        public void Dispose() { Liberar(); }

        private T GetFunc<T>(string name) where T : class
        {
            if (_hModule == IntPtr.Zero)
                throw new InvalidOperationException("DLL no cargado. Cargue el DLL primero.");
            IntPtr addr = GetProcAddress(_hModule, name);
            if (addr == IntPtr.Zero)
                throw new EntryPointNotFoundException("Funcion '" + name + "' no encontrada en el DLL.");
            FileLogger.Info("GetProcAddress", name + " -> 0x" + addr.ToString("X"));
            return (T)(object)Marshal.GetDelegateForFunctionPointer(addr, typeof(T));
        }

        private static string PtrToStr(IntPtr ptr)
        {
            if (ptr == IntPtr.Zero) return "(null)";
            return Marshal.PtrToStringUni(ptr) ?? "(null)";
        }

        public string Version()
        {
            var fn = GetFunc<FnSinParams>("ObtenerVersion");
            string r = PtrToStr(fn());
            FileLogger.Info("ObtenerVersion", "Resultado: " + r);
            return r;
        }

        public string IpLocal()
        {
            var fn = GetFunc<FnSinParams>("ObtenerIpLocal");
            string r = PtrToStr(fn());
            FileLogger.Info("ObtenerIpLocal", "Resultado: " + r);
            return r;
        }

        public string InfoToken()
        {
            var fn = GetFunc<FnSinParams>("ObtenerInfoToken");
            string r = PtrToStr(fn());
            FileLogger.Info("ObtenerInfoToken", "Resultado: " + r);
            return r;
        }

        public string Configurar(string usuario, string clave, string empresa, string ipLocal, string computerName)
        {
            FileLogger.Info("ConfigurarCredencialesRuc", "Params: usuario=" + usuario + ", empresa=" + empresa + ", ipLocal=" + ipLocal + ", computerName=" + computerName);
            var fn = GetFunc<FnCincoParams>("ConfigurarCredencialesRuc");
            string r = PtrToStr(fn(usuario, clave, empresa, ipLocal, computerName));
            FileLogger.Info("ConfigurarCredencialesRuc", "Resultado: " + r);
            return r;
        }

        public string Consultar(string ruc, string rucOrigen)
        {
            FileLogger.Info("ConsultarRuc", "Params: ruc=" + ruc + ", rucOrigen=" + rucOrigen);
            var fn = GetFunc<FnDosParams>("ConsultarRuc");
            string r = PtrToStr(fn(ruc, rucOrigen));
            FileLogger.Info("ConsultarRuc", "Resultado: " + r);
            return r;
        }

        public string ObtenerToken(string usuario, string clave, string empresa, string ipLocal, string computerName)
        {
            FileLogger.Info("ObtenerTokenRest", "Params: usuario=" + usuario + ", empresa=" + empresa + ", ipLocal=" + ipLocal + ", computerName=" + computerName);
            var fn = GetFunc<FnCincoParams>("ObtenerTokenRest");
            string r = PtrToStr(fn(usuario, clave, empresa, ipLocal, computerName));
            FileLogger.Info("ObtenerTokenRest", "Resultado: " + (r.Length > 80 ? r.Substring(0, 80) + "..." : r));
            return r;
        }

        public void ForzarRenovacion()
        {
            FileLogger.Info("ForzarRenovacionToken", "Limpiando token");
            var fn = GetFunc<FnVoidSinParams>("ForzarRenovacionToken");
            fn();
            FileLogger.Info("ForzarRenovacionToken", "OK");
        }
    }

    public class MainForm : Form
    {
        private SigreDll dll = new SigreDll();
        private TabControl tabControl;
        private TextBox txtDllPath;
        private TextBox txtUsuario, txtClave, txtEmpresa, txtRuc;
        private TextBox txtIpLocal, txtComputerName, txtRucOrigen;
        private TextBox txtResultado;
        private StatusStrip statusStrip;
        private ToolStripStatusLabel statusLabel;
        private Label lblDllStatus;

        public MainForm()
        {
            InitializeComponents();
            AutoDetectValues();
            BuscarDllInicial();
        }

        protected override void OnFormClosed(FormClosedEventArgs e)
        {
            FileLogger.Info("APP", "Cerrando aplicacion");
            dll.Dispose();
            base.OnFormClosed(e);
        }

        private void InitializeComponents()
        {
            Text = "SIGRE - Test DLL (LoadLibrary + GetProcAddress)";
            Size = new Size(860, 750);
            StartPosition = FormStartPosition.CenterScreen;
            MinimumSize = new Size(820, 650);
            Font = new Font("Segoe UI", 9F);
            Icon = SystemIcons.Application;

            var panelDll = new Panel { Dock = DockStyle.Top, Height = 55 };

            var lblRuta = new Label { Text = "Ruta del DLL:", Location = new Point(12, 18), AutoSize = true };
            txtDllPath = new TextBox { Location = new Point(110, 15), Width = 480 };
            var btnBrowse = new Button { Text = "...", Location = new Point(596, 13), Width = 35, Height = 26 };
            btnBrowse.Click += BtnBrowse_Click;
            var btnCargar = new Button
            {
                Text = "Cargar DLL", Location = new Point(638, 13), Width = 90, Height = 26,
                BackColor = Color.FromArgb(0, 123, 255), ForeColor = Color.White, FlatStyle = FlatStyle.Flat
            };
            btnCargar.Click += BtnCargar_Click;
            lblDllStatus = new Label
            {
                Text = "No cargado", ForeColor = Color.Red, AutoSize = true,
                Location = new Point(735, 18), Font = new Font("Segoe UI", 9F, FontStyle.Bold)
            };

            panelDll.Controls.AddRange(new Control[] { lblRuta, txtDllPath, btnBrowse, btnCargar, lblDllStatus });

            tabControl = new TabControl { Dock = DockStyle.Fill };
            tabControl.TabPages.Add(BuildTabRuc());

            statusStrip = new StatusStrip();
            statusLabel = new ToolStripStatusLabel("Log: " + (FileLogger.LogFile ?? "?"));
            statusStrip.Items.Add(statusLabel);

            Controls.Add(tabControl);
            Controls.Add(panelDll);
            Controls.Add(statusStrip);
        }

        private TabPage BuildTabRuc()
        {
            var tab = new TabPage("Consulta RUC");

            var panelTop = new Panel { Dock = DockStyle.Top, Height = 250 };

            var grpCred = new GroupBox { Text = "Credenciales API", Location = new Point(10, 5), Size = new Size(390, 130) };
            AddLabel(grpCred, "Usuario:", 15, 25);
            txtUsuario = AddTextBox(grpCred, 120, 22, 240, "sigre");
            AddLabel(grpCred, "Clave:", 15, 55);
            txtClave = AddTextBox(grpCred, 120, 52, 240, "sigre1234");
            txtClave.UseSystemPasswordChar = true;
            AddLabel(grpCred, "Empresa:", 15, 85);
            txtEmpresa = AddTextBox(grpCred, 120, 82, 240, "TRANSMARINA");

            var grpEquipo = new GroupBox { Text = "Datos del Equipo", Location = new Point(420, 5), Size = new Size(390, 130) };
            AddLabel(grpEquipo, "IP Local:", 15, 25);
            txtIpLocal = AddTextBox(grpEquipo, 120, 22, 240, "");
            AddLabel(grpEquipo, "Equipo:", 15, 55);
            txtComputerName = AddTextBox(grpEquipo, 120, 52, 240, "");
            AddLabel(grpEquipo, "RUC Origen:", 15, 85);
            txtRucOrigen = AddTextBox(grpEquipo, 120, 82, 240, "20100070970");

            var grpRuc = new GroupBox { Text = "RUC a Consultar", Location = new Point(10, 140), Size = new Size(390, 55) };
            AddLabel(grpRuc, "RUC:", 15, 22);
            txtRuc = AddTextBox(grpRuc, 120, 19, 240, "10056450608");

            var panelBtn = new FlowLayoutPanel
            {
                Location = new Point(420, 145),
                Size = new Size(400, 100),
                FlowDirection = FlowDirection.LeftToRight
            };
            panelBtn.Controls.AddRange(new Control[]
            {
                MakeBtn("Version", Color.FromArgb(108, 117, 125), BtnVersion_Click),
                MakeBtn("IP Local", Color.FromArgb(108, 117, 125), BtnIpLocal_Click),
                MakeBtn("1. Configurar", Color.FromArgb(0, 123, 255), BtnConfigurar_Click),
                MakeBtn("2. Token", Color.FromArgb(23, 162, 184), BtnToken_Click),
                MakeBtn("3. Consultar", Color.FromArgb(40, 167, 69), BtnConsultar_Click),
                MakeBtn("Info Token", Color.FromArgb(23, 162, 184), BtnInfoToken_Click),
                MakeBtn("Todo en Uno", Color.FromArgb(255, 153, 0), BtnTodoEnUno_Click),
                MakeBtn("Limpiar", Color.FromArgb(220, 53, 69), delegate { txtResultado.Clear(); }),
                MakeBtn("Abrir Log", Color.FromArgb(90, 90, 90), BtnAbrirLog_Click)
            });

            panelTop.Controls.AddRange(new Control[] { grpCred, grpEquipo, grpRuc, panelBtn });

            var grpRes = new GroupBox { Text = "Resultado", Dock = DockStyle.Fill, Padding = new Padding(8) };
            txtResultado = new TextBox
            {
                Multiline = true, Dock = DockStyle.Fill, ScrollBars = ScrollBars.Both,
                ReadOnly = true, BackColor = Color.FromArgb(30, 30, 30),
                ForeColor = Color.FromArgb(0, 255, 128),
                Font = new Font("Consolas", 10F), WordWrap = true
            };
            grpRes.Controls.Add(txtResultado);

            tab.Controls.Add(grpRes);
            tab.Controls.Add(panelTop);
            return tab;
        }

        private void BuscarDllInicial()
        {
            string exeDir = AppDomain.CurrentDomain.BaseDirectory;
            FileLogger.Info("INICIO", "Buscando DLL en: " + exeDir);
            string target = Path.Combine(exeDir, "SigreWebServiceWrapper.dll");
            if (File.Exists(target))
            {
                FileLogger.Info("INICIO", "Encontrado: " + target);
                txtDllPath.Text = target;
                CargarDll(target);
                return;
            }
            string[] dlls = Directory.GetFiles(exeDir, "*.dll");
            foreach (string d in dlls)
            {
                string name = Path.GetFileName(d).ToLower();
                if (name != "newtonsoft.json.dll" && name != "rgiesecke.dllexport.metadata.dll")
                {
                    FileLogger.Info("INICIO", "Usando primer DLL encontrado: " + d);
                    txtDllPath.Text = d;
                    CargarDll(d);
                    return;
                }
            }
            FileLogger.Info("INICIO", "No se encontro DLL en " + exeDir);
            statusLabel.Text = "No se encontro DLL en " + exeDir;
        }

        private void CargarDll(string path)
        {
            string error = dll.Cargar(path);
            if (error != null)
            {
                lblDllStatus.Text = "Error";
                lblDllStatus.ForeColor = Color.Red;
                LogUI("CARGAR DLL", error);
                statusLabel.Text = error;
            }
            else
            {
                lblDllStatus.Text = "Cargado";
                lblDllStatus.ForeColor = Color.Green;
                statusLabel.Text = "DLL cargado | Log: " + FileLogger.LogFile;
                LogUI("CARGAR DLL", "OK - " + path);
            }
        }

        private void BtnBrowse_Click(object sender, EventArgs e)
        {
            using (var ofd = new OpenFileDialog())
            {
                ofd.Title = "Seleccionar SigreWebServiceWrapper.dll";
                ofd.Filter = "DLL (*.dll)|*.dll|Todos (*.*)|*.*";
                if (!string.IsNullOrEmpty(txtDllPath.Text) && Directory.Exists(Path.GetDirectoryName(txtDllPath.Text)))
                    ofd.InitialDirectory = Path.GetDirectoryName(txtDllPath.Text);
                if (ofd.ShowDialog() == DialogResult.OK)
                    txtDllPath.Text = ofd.FileName;
            }
        }

        private void BtnCargar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDllPath.Text))
            {
                MessageBox.Show("Ingrese la ruta del DLL.", "Validacion", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (!File.Exists(txtDllPath.Text.Trim()))
            {
                MessageBox.Show("El archivo no existe: " + txtDllPath.Text, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                FileLogger.Error("CARGAR_DLL", "Archivo no existe: " + txtDllPath.Text);
                return;
            }
            CargarDll(txtDllPath.Text.Trim());
        }

        private void BtnAbrirLog_Click(object sender, EventArgs e)
        {
            try
            {
                if (File.Exists(FileLogger.LogFile))
                    System.Diagnostics.Process.Start("notepad.exe", FileLogger.LogFile);
                else
                    MessageBox.Show("Archivo de log no encontrado.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show("No se pudo abrir el log: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void AutoDetectValues()
        {
            txtComputerName.Text = Environment.MachineName;
            try
            {
                var host = Dns.GetHostEntry(Dns.GetHostName());
                foreach (var ip in host.AddressList)
                {
                    if (ip.AddressFamily == AddressFamily.InterNetwork)
                    {
                        txtIpLocal.Text = ip.ToString();
                        break;
                    }
                }
            }
            catch { txtIpLocal.Text = "127.0.0.1"; }
            FileLogger.Info("INICIO", "Equipo: " + txtComputerName.Text + ", IP: " + txtIpLocal.Text);
        }

        private void LogUI(string titulo, string resultado)
        {
            string ts = DateTime.Now.ToString("HH:mm:ss.fff");
            txtResultado.AppendText("[" + ts + "] === " + titulo + " ===" + Environment.NewLine);
            txtResultado.AppendText(FormatJson(resultado) + Environment.NewLine + Environment.NewLine);
            txtResultado.SelectionStart = txtResultado.Text.Length;
            txtResultado.ScrollToCaret();
        }

        private bool CheckDll()
        {
            if (!dll.IsLoaded)
            {
                MessageBox.Show("El DLL no esta cargado. Presione 'Cargar DLL' primero.",
                    "DLL no cargado", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false;
            }
            return true;
        }

        private void BtnVersion_Click(object sender, EventArgs e)
        {
            if (!CheckDll()) return;
            try
            {
                statusLabel.Text = "GetProcAddress -> ObtenerVersion()";
                Application.DoEvents();
                string r = dll.Version();
                LogUI("ObtenerVersion()", r);
                statusLabel.Text = "DLL Version: " + r;
            }
            catch (Exception ex) { LogUI("ERROR ObtenerVersion", ex.Message); FileLogger.Error("ObtenerVersion", ex); statusLabel.Text = "Error"; }
        }

        private void BtnIpLocal_Click(object sender, EventArgs e)
        {
            if (!CheckDll()) return;
            try
            {
                statusLabel.Text = "GetProcAddress -> ObtenerIpLocal()";
                Application.DoEvents();
                string r = dll.IpLocal();
                LogUI("ObtenerIpLocal()", r);
                txtIpLocal.Text = r;
                statusLabel.Text = "IP: " + r;
            }
            catch (Exception ex) { LogUI("ERROR ObtenerIpLocal", ex.Message); FileLogger.Error("ObtenerIpLocal", ex); statusLabel.Text = "Error"; }
        }

        private void BtnConfigurar_Click(object sender, EventArgs e)
        {
            if (!CheckDll()) return;
            if (!ValidarCampos(true, false)) return;
            try
            {
                statusLabel.Text = "GetProcAddress -> ConfigurarCredencialesRuc(5 params)";
                Application.DoEvents();
                string r = dll.Configurar(
                    txtUsuario.Text.Trim(), txtClave.Text.Trim(), txtEmpresa.Text.Trim(),
                    txtIpLocal.Text.Trim(), txtComputerName.Text.Trim());
                LogUI("ConfigurarCredencialesRuc(usuario, clave, empresa, ipLocal, computerName)", r);
                statusLabel.Text = r.Contains("true") ? "Configurado OK" : "Error config";
            }
            catch (Exception ex) { LogUI("ERROR ConfigurarCredencialesRuc", ex.Message); FileLogger.Error("ConfigurarCredencialesRuc", ex); statusLabel.Text = "Error"; }
        }

        private void BtnConsultar_Click(object sender, EventArgs e)
        {
            if (!CheckDll()) return;
            if (!ValidarCampos(false, true)) return;
            try
            {
                statusLabel.Text = "GetProcAddress -> ConsultarRuc(2 params)";
                Application.DoEvents();
                string r = dll.Consultar(txtRuc.Text.Trim(), txtRucOrigen.Text.Trim());
                LogUI("ConsultarRuc(" + txtRuc.Text.Trim() + ", " + txtRucOrigen.Text.Trim() + ")", r);
                statusLabel.Text = r.Contains("\"exitoso\":true") ? "RUC encontrado" : "Error consulta";
            }
            catch (Exception ex) { LogUI("ERROR ConsultarRuc", ex.Message); FileLogger.Error("ConsultarRuc", ex); statusLabel.Text = "Error"; }
        }

        private void BtnInfoToken_Click(object sender, EventArgs e)
        {
            if (!CheckDll()) return;
            try
            {
                statusLabel.Text = "GetProcAddress -> ObtenerInfoToken()";
                Application.DoEvents();
                string r = dll.InfoToken();
                LogUI("ObtenerInfoToken()", r);
                statusLabel.Text = "Info token obtenida";
            }
            catch (Exception ex) { LogUI("ERROR ObtenerInfoToken", ex.Message); FileLogger.Error("ObtenerInfoToken", ex); statusLabel.Text = "Error"; }
        }

        private void BtnToken_Click(object sender, EventArgs e)
        {
            if (!CheckDll()) return;
            if (!ValidarCampos(true, false)) return;
            try
            {
                statusLabel.Text = "GetProcAddress -> ObtenerTokenRest(5 params)";
                Application.DoEvents();
                string r = dll.ObtenerToken(
                    txtUsuario.Text.Trim(), txtClave.Text.Trim(), txtEmpresa.Text.Trim(),
                    txtIpLocal.Text.Trim(), txtComputerName.Text.Trim());
                LogUI("ObtenerTokenRest(usuario, clave, empresa, ipLocal, computerName)", r);
                statusLabel.Text = r.Contains("ERROR") ? "Error token" : "Token obtenido";
            }
            catch (Exception ex) { LogUI("ERROR ObtenerTokenRest", ex.Message); FileLogger.Error("ObtenerTokenRest", ex); statusLabel.Text = "Error"; }
        }

        private void BtnTodoEnUno_Click(object sender, EventArgs e)
        {
            if (!CheckDll()) return;
            if (!ValidarCampos(true, true)) return;
            try
            {
                statusLabel.Text = "Paso 1/3: Configurar...";
                Application.DoEvents();
                string r1 = dll.Configurar(
                    txtUsuario.Text.Trim(), txtClave.Text.Trim(), txtEmpresa.Text.Trim(),
                    txtIpLocal.Text.Trim(), txtComputerName.Text.Trim());
                LogUI("1. ConfigurarCredencialesRuc", r1);

                statusLabel.Text = "Paso 2/3: Obtener token...";
                Application.DoEvents();
                string r2 = dll.ObtenerToken(
                    txtUsuario.Text.Trim(), txtClave.Text.Trim(), txtEmpresa.Text.Trim(),
                    txtIpLocal.Text.Trim(), txtComputerName.Text.Trim());
                LogUI("2. ObtenerTokenRest", r2);

                if (r2.Contains("ERROR"))
                {
                    statusLabel.Text = "Error al obtener token";
                    return;
                }

                statusLabel.Text = "Paso 3/3: Consultar RUC...";
                Application.DoEvents();
                string r3 = dll.Consultar(txtRuc.Text.Trim(), txtRucOrigen.Text.Trim());
                LogUI("3. ConsultarRuc(" + txtRuc.Text.Trim() + ", " + txtRucOrigen.Text.Trim() + ")", r3);
                statusLabel.Text = r3.Contains("\"exitoso\":true") ? "RUC encontrado" : "Error consulta";
            }
            catch (Exception ex) { LogUI("ERROR Todo en Uno", ex.Message); FileLogger.Error("TodoEnUno", ex); statusLabel.Text = "Error"; }
        }

        private bool ValidarCampos(bool cred, bool ruc)
        {
            if (cred && (string.IsNullOrWhiteSpace(txtUsuario.Text) || string.IsNullOrWhiteSpace(txtClave.Text) ||
                string.IsNullOrWhiteSpace(txtEmpresa.Text) || string.IsNullOrWhiteSpace(txtIpLocal.Text) ||
                string.IsNullOrWhiteSpace(txtComputerName.Text)))
            {
                MessageBox.Show("Complete todos los campos de credenciales y equipo.", "Validacion", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false;
            }
            if (ruc && string.IsNullOrWhiteSpace(txtRuc.Text))
            {
                MessageBox.Show("Ingrese el RUC a consultar.", "Validacion", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtRuc.Focus();
                return false;
            }
            return true;
        }

        private static string FormatJson(string json)
        {
            if (string.IsNullOrEmpty(json)) return "(vacio)";
            try
            {
                int indent = 0;
                bool inStr = false;
                var sb = new StringBuilder();
                for (int i = 0; i < json.Length; i++)
                {
                    char c = json[i];
                    if (c == '"' && (i == 0 || json[i - 1] != '\\')) { inStr = !inStr; sb.Append(c); }
                    else if (!inStr && (c == '{' || c == '[')) { sb.Append(c); sb.AppendLine(); indent++; sb.Append(new string(' ', indent * 2)); }
                    else if (!inStr && (c == '}' || c == ']')) { sb.AppendLine(); indent--; sb.Append(new string(' ', indent * 2)); sb.Append(c); }
                    else if (!inStr && c == ',') { sb.Append(c); sb.AppendLine(); sb.Append(new string(' ', indent * 2)); }
                    else if (!inStr && c == ':') { sb.Append(": "); }
                    else { sb.Append(c); }
                }
                return sb.ToString();
            }
            catch { return json; }
        }

        private Label AddLabel(Control p, string t, int x, int y)
        {
            var l = new Label { Text = t, Location = new Point(x, y), AutoSize = true };
            p.Controls.Add(l); return l;
        }

        private TextBox AddTextBox(Control p, int x, int y, int w, string v)
        {
            var t = new TextBox { Location = new Point(x, y), Width = w, Text = v };
            p.Controls.Add(t); return t;
        }

        private Button MakeBtn(string text, Color bg, EventHandler click)
        {
            var b = new Button
            {
                Text = text, AutoSize = true, Height = 32, FlatStyle = FlatStyle.Flat,
                BackColor = bg, ForeColor = Color.White, Cursor = Cursors.Hand, Margin = new Padding(3)
            };
            b.Click += click; return b;
        }
    }

    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            FileLogger.Inicializar();
            FileLogger.Info("APP", "Aplicacion iniciada");
            Application.Run(new MainForm());
        }
    }
}
