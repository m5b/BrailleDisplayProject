using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Collections.ObjectModel;


using HidLibrary;

namespace BrailleLegibilityTest
{

    //    TODO
    //- Database, map the phrase to each word and correct/incorrect
    public partial class FrmMain : Form
    {
        static string devicePid = "pid_0486";
        static HidDevice device;
        bool deviceConnected = false;
        
        int place = 0;
        int phraseCount = 0;

        Timer t = new Timer();
        List<string> phrases = new List<string>();
        StringBuilder usbBuffer = new StringBuilder(2000);
        
        public FrmMain()
        {
            InitializeComponent();
            init();
        }

        /// <summary>
        /// Do req startup work, check for braille device.
        /// </summary>
        private void init()
        {
            lblDevice.Text = "Connecting to Braille Device...";
            Application.DoEvents();

            IEnumerable<HidDevice> _device = HidDevices.Enumerate();
            HidDevice hd = _device.FirstOrDefault(p => p.DevicePath.Contains(devicePid));

            if (hd != null)
            {
                device = HidDevices.GetDevice(hd.DevicePath);
                if (device != null)
                {
                    lblDevice.Text = "Connected.";
                    Application.DoEvents();
                    deviceConnected = true;
                    //start listening to device.
                    if(!hidWorker.IsBusy)
                        hidWorker.RunWorkerAsync();
                }
            }
            else
            {
                lblDevice.Text = "Device Not Found.";
                Application.DoEvents();
            }

            //TODO: Add crash check.
            //Review the log data to see if a crash occured and prompt user to reload current.
            addPhrases();

            t.Interval = 1000;
            t.Tick += t_Tick;
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            highlightText();
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            t.Stop();
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            byte[] b = new byte[5];
            b[0] = 2;//padding
            b[1] = 2;
            device.Write(b);
        }

        private void btnReconnect_Click(object sender, EventArgs e)
        {
            init();
        }

        private void btnFlag_Click(object sender, EventArgs e)
        {
            flag();
            next();
        }

        private void btnNext_Click(object sender, EventArgs e)
        {
            next();
            tbOutput.Focus();
        }

        private void btnPrevious_Click(object sender, EventArgs e)
        {
            previous();
            tbOutput.Focus();
        }

        private void cbPhraseSets_CheckedChanged(object sender, EventArgs e)
        {
            if (cbPhraseSets.Checked)
            {
                loadText(phraseCount++);
                btnNext.Enabled = true;
                btnPrevious.Enabled = true;
            }
            else
            {
                btnNext.Enabled = false;
                btnPrevious.Enabled = false;
            }
        }

        private void flag()
        {
            //datastore.flag
        }

        private void next()
        {
            phraseCount++;

            if (phraseCount > phrases.Count)
                phraseCount = 0;

            loadText(phraseCount);
        }

        private void previous()
        {
            if (phraseCount == 0) return;

            phraseCount--;
            loadText(phraseCount);
        }

        private void highlightText()
        {
            place = 0;
            t.Start();
        }

        void t_Tick(object sender, EventArgs e)
        {
            if (tbOutput.TextLength > place)
            {
                tbOutput.Select(place, 2);
                
                //lead is getting trimmed for some reason, so adding padding here.
                //Will also use this for message identification in future.
                byte[] b = new byte[5];
                b[0] = 2;//padding
                b[1] = 1;
                byte[] bt = System.Text.ASCIIEncoding.ASCII.GetBytes(tbOutput.SelectedText);
                b[2] = bt[0];
                b[3] = bt[1];
                b[4] = 1;//end of line char
                //send to device
                if(device != null)
                    device.Write(b);
                place = place + 2;
            }
            else
            {
                t.Stop();
            }
        }
        
        private void listen()
        {
            //ignore the first byte, it is always 0
            HidDeviceData data = device.Read(2000);
            
            //check to see if highlighting event has been sent
            if (data.Data[1] == 255 && data.Data[2] == 255) //open code
            {
                if (InvokeRequired)
                {
                    this.Invoke(new MethodInvoker(highlightText));
                }
                else
                {
                    highlightText();
                }
            }
            else
            {
                //must be a message, so add to buffer and display
                //extract size of message
                int sz = Convert.ToInt32(data.Data[1]);
                string response = ""; 
                if (sz > 64)
                {
                    response = System.Text.ASCIIEncoding.ASCII.GetString(data.Data, 2, 62);
                    usbBuffer.Append(response);
                    listen();
                }
                else
                {
                    response = System.Text.ASCIIEncoding.ASCII.GetString(data.Data, 2, sz);
                    usbBuffer.Append(response);
                    if (InvokeRequired)
                    {
                        this.Invoke(new MethodInvoker(printUSB));
                    }
                    else
                    {
                        printUSB();
                    }
                }

                
            }
        }

        private void printUSB()
        {
            this.rtbOutput.AppendText(usbBuffer.ToString());
            this.rtbOutput.AppendText("\n");
            usbBuffer.Clear();
        }

        private void hidWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            listen();
        }

        private void FrmMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            //hidWorker.CancelAsync();
        }

        private void hidWorker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            hidWorker.RunWorkerAsync();
        }

        private void addPhrases()
        {
            using (System.IO.StreamReader sr = new System.IO.StreamReader("phrases2.txt"))
            {
                while (!sr.EndOfStream)
                {
                    phrases.Add(sr.ReadLine());
                }
            }
        }

        private void loadText(int index)
        {
            //TODO:  Add session log update here.
            // Log should store the phrase before it is delivered to device.

            lbWordlist.Items.Clear();
            string phrase = phrases[index];
            //if there are more than 24 characters in the phrase, 
            //split at nearest word break and insert newline
            if (phrase.Length > 24)
            {
                phrase = polishPhrase(phrase);
            }
            tbOutput.Text = phrase;
            foreach(string p in phrases[index].Split(' ')){
                lbWordlist.Items.Add(p);
            }
        }

        private string polishPhrase(string phrase)
        {
            string[] temp = phrase.Split(' ');
            phrase = string.Empty;
            int max = 24;
            for (int i = 0; i < temp.Length; i++)
            {
                if (temp[i].Length + phrase.Length < max)
                    phrase += temp[i] + " ";
                else
                {
                    phrase += "\r\n" + temp[i] + " ";
                    max += 24;
                }

            }
            return phrase;
        }

    }
}