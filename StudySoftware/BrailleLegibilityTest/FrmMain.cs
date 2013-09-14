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
            //Put this in for dramatic effect to show that a reconnection
            //is occuring in the UI.
            System.Threading.Thread.Sleep(3000);
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
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            t.Stop();
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            //send a signal to the device to tell it to reset.
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
            //reset place counter
            place = 0;

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
            byte[] b = new byte[7];
            //lead is getting trimmed for some reason, so adding padding here.
            //Will also use this for message identification in future.
            b[0] = 2;//padding
            b[1] = 1;

            if (tbOutput.TextLength > place)
            {
                tbOutput.Select(place, 4);

                byte[] bt = System.Text.ASCIIEncoding.ASCII.GetBytes(tbOutput.SelectedText);
                for (int i = 0; i < bt.Length; i++)
                {
                    b[i+2] = bt[i];
                }
                
                b[6] = 1;//end of line char

                place = place + 4;
            }
            //send to device
            if (device != null)
                device.Write(b);
        }

        void t_Tick(object sender, EventArgs e)
        {
            
        }
        
        private void listen()
        {
            //ignore the first byte, it is always 0
            HidDeviceData data = device.Read(2000);
            if (data.Status == HidDeviceData.ReadStatus.NotConnected) return;

            //check to see if an event has been sent
            //so far only two are established, so if starts with 0 then ignore.
            
            //if the first two bytes are 255,then we are being sent a request for character
            //data.
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
            else if(data.Data[1] > 0) //a code exists, so do something.  
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
            this.rtbOutput.ScrollToCaret();
            usbBuffer.Clear();
        }

        private void hidWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            listen();
        }

        private void FrmMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            t.Stop();
            hidWorker.CancelAsync();
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