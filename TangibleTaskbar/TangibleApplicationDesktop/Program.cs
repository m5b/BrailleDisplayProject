using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Runtime.InteropServices;
 

using HidLibrary;

namespace TangibleApplicationSwitcher
{
    class Program
    {
        //interop
        [DllImport("user32.dll")]
        private static extern
            bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")]
        private static extern
            bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")]
        private static extern
            bool IsIconic(IntPtr hWnd);
        
        static string devicePid = "pid_0486";
        static HidDevice device;
        static string activeRfid = string.Empty;
        static List<RfidApp> apps = new List<RfidApp>();

        static void Main(string[] args)
        {
            bool deviceConnected = false;
            //These rfids are hardcoded.  Ideally, with more hardware Id's could be dynamically assigned to 
            //any application.
            apps.Add(new RfidApp() { RFID = "67005DC3B64F", ProgramName = @"C:\Program Files (x86)\Microsoft Office\Office14\WinWord.exe" });
            apps.Add(new RfidApp() { RFID = "67005DA120BB", ProgramName = @"C:\Program Files\Internet Explorer\iexplore.exe" });
            apps.Add(new RfidApp() { RFID = "690025D364FB", ProgramName = @"C:\Windows\System32\cmd.exe" });
            apps.Add(new RfidApp() { RFID = "690025BD00F1", ProgramName = @"C:\Windows\notepad.exe" });
            apps.Add(new RfidApp() { RFID = "690025C366E9", ProgramName = @"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" });
            apps.Add(new RfidApp() { RFID = "690025FF59EA", ProgramName = @"C:\Windows\explorer.exe" });
            apps.Add(new RfidApp() { RFID = "67005D9D0CAB", ProgramName = @"C:\Program Files\Adobe\Adobe Photoshop CS6 (64 Bit)\photoshop.exe" });

            IEnumerable<HidDevice> _device = HidDevices.Enumerate();
            HidDevice hd = _device.FirstOrDefault(p => p.DevicePath.Contains(devicePid));

            if (hd != null)
            {
                device = HidDevices.GetDevice(hd.DevicePath);
                Console.WriteLine("Vendor ID:" + hd.Attributes.VendorId);
                if (device != null)
                {
                    Console.WriteLine("Vendor ID:" + hd.Attributes.VendorId);
                    deviceConnected = true;
                }

                listen();
            }
            else
            {
                Console.WriteLine("Device Not Found");
                Console.Read();
            }
        }

        static void listen()
        {
            //ignore the first byte, it is always 0
            HidDeviceData data = device.Read(2000);
            char[] chars = new char[12];
            int index=0;
            if (data.Data.Length < 64) return;
            //extract RFID
            int j = 0;
            for (int i = 3; i < 15; i++)
            {
                chars[j++] = (char)data.Data[i];
            }
            //check to see if id should be opened or closed
            if (data.Data[1] == 255 && data.Data[2] == 255) //open code
            {
                open(new String(chars));
            }
            else
            {
                close(new String(chars));
            }

            listen();
        }

        static void open(string rfid)
        {
            RfidApp rfidApp = apps.Where(p => p.RFID == rfid).FirstOrDefault();

            if (rfidApp != null)
            {
                //first check to see if app is already running...if so, just bring to focus.
                if (rfidApp.ProcessName != null && rfidApp.ProcessID != null)
                {
                    if (IsRunning(rfidApp.ProcessName, rfidApp.ProcessID))
                        return;
                }
                //otherwise, start it up.
                Process p = new Process();
                ProcessStartInfo pi = new ProcessStartInfo();
                pi.FileName = rfidApp.ProgramName;
                p.StartInfo = pi;
                try
                {
                    p.Start();
                    rfidApp.ProcessID = p.Id;
                    rfidApp.ProcessName = p.ProcessName;
                }
                catch(Exception e) {
                    Console.WriteLine(e.Message);
                }
                //Console.WriteLine(rfid);
            }
        }

        /// <summary>
        /// Should close open apps, not implemented
        /// </summary>
        /// <param name="rfid"></param>
        static void close(string rfid)
        {

        }

        /// <summary>
        /// Checks to see if a given process is already running.  If it is it will give it focus.
        /// </summary>
        /// <param name="processName"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public static bool IsRunning(string processName, int id)
        {
            const int swRestore = 9;

            var arrProcesses = Process.GetProcessesByName(processName);

            if (arrProcesses.Length > 1)
            {
                for (var i = 0; i < arrProcesses.Length; i++)
                {
                    if (arrProcesses[i].Id != id)
                    {
                        // get the window handle
                        IntPtr hWnd = arrProcesses[i].MainWindowHandle;

                        // if iconic, we need to restore the window
                        if (IsIconic(hWnd))
                        {
                            ShowWindowAsync(hWnd, swRestore);
                        }

                        // bring it to the foreground
                        SetForegroundWindow(hWnd);
                        break;
                    }
                }
                return true;
            }

            return false;
        }
    }


    class RfidApp
    {
        public string ProgramName
        {
            get;
            set;
        }

        public string RFID
        {
            get;
            set;
        }

        public int ProcessID
        {
            get;
            set;
        }

        public string ProcessName
        {
            get;
            set;
        }
    }
}
