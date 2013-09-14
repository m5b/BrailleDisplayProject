namespace BrailleLegibilityTest
{
    partial class FrmMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FrmMain));
            this.tbOutput = new System.Windows.Forms.TextBox();
            this.btnStart = new System.Windows.Forms.Button();
            this.hidWorker = new System.ComponentModel.BackgroundWorker();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.lblDevice = new System.Windows.Forms.ToolStripStatusLabel();
            this.btnReconnect = new System.Windows.Forms.ToolStripDropDownButton();
            this.btnReset = new System.Windows.Forms.Button();
            this.btnStop = new System.Windows.Forms.Button();
            this.cbPhraseSets = new System.Windows.Forms.CheckBox();
            this.btnPrevious = new System.Windows.Forms.Button();
            this.btnNext = new System.Windows.Forms.Button();
            this.lbWordlist = new System.Windows.Forms.CheckedListBox();
            this.btnFlag = new System.Windows.Forms.Button();
            this.rtbOutput = new System.Windows.Forms.RichTextBox();
            this.statusStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tbOutput
            // 
            this.tbOutput.AccessibleDescription = "Braille Legibility Text";
            this.tbOutput.AccessibleName = "Braille Legibility Text";
            this.tbOutput.AccessibleRole = System.Windows.Forms.AccessibleRole.Text;
            this.tbOutput.Dock = System.Windows.Forms.DockStyle.Top;
            this.tbOutput.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbOutput.HideSelection = false;
            this.tbOutput.Location = new System.Drawing.Point(0, 0);
            this.tbOutput.Multiline = true;
            this.tbOutput.Name = "tbOutput";
            this.tbOutput.Size = new System.Drawing.Size(855, 116);
            this.tbOutput.TabIndex = 0;
            this.tbOutput.Text = "a b c d e f g h i j k l m n o p q r s t u v w x y z ";
            // 
            // btnStart
            // 
            this.btnStart.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.btnStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStart.Enabled = false;
            this.btnStart.Location = new System.Drawing.Point(3, 120);
            this.btnStart.Name = "btnStart";
            this.btnStart.Size = new System.Drawing.Size(75, 23);
            this.btnStart.TabIndex = 1;
            this.btnStart.Text = "Start";
            this.btnStart.UseVisualStyleBackColor = true;
            this.btnStart.Visible = false;
            this.btnStart.Click += new System.EventHandler(this.btnStart_Click);
            // 
            // hidWorker
            // 
            this.hidWorker.WorkerReportsProgress = true;
            this.hidWorker.WorkerSupportsCancellation = true;
            this.hidWorker.DoWork += new System.ComponentModel.DoWorkEventHandler(this.hidWorker_DoWork);
            this.hidWorker.RunWorkerCompleted += new System.ComponentModel.RunWorkerCompletedEventHandler(this.hidWorker_RunWorkerCompleted);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.lblDevice,
            this.btnReconnect});
            this.statusStrip1.Location = new System.Drawing.Point(0, 388);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.ShowItemToolTips = true;
            this.statusStrip1.Size = new System.Drawing.Size(855, 22);
            this.statusStrip1.SizingGrip = false;
            this.statusStrip1.TabIndex = 2;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // lblDevice
            // 
            this.lblDevice.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.lblDevice.Name = "lblDevice";
            this.lblDevice.Size = new System.Drawing.Size(126, 17);
            this.lblDevice.Text = "Device Not Connected";
            // 
            // btnReconnect
            // 
            this.btnReconnect.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.btnReconnect.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnReconnect.Image = ((System.Drawing.Image)(resources.GetObject("btnReconnect.Image")));
            this.btnReconnect.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnReconnect.Name = "btnReconnect";
            this.btnReconnect.Size = new System.Drawing.Size(29, 20);
            this.btnReconnect.Text = "toolStripDropDownButton1";
            this.btnReconnect.ToolTipText = "Reconnect to USB Device";
            this.btnReconnect.Click += new System.EventHandler(this.btnReconnect_Click);
            // 
            // btnReset
            // 
            this.btnReset.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.btnReset.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnReset.Enabled = false;
            this.btnReset.Location = new System.Drawing.Point(165, 120);
            this.btnReset.Name = "btnReset";
            this.btnReset.Size = new System.Drawing.Size(75, 23);
            this.btnReset.TabIndex = 3;
            this.btnReset.Text = "Reset";
            this.btnReset.UseVisualStyleBackColor = true;
            this.btnReset.Visible = false;
            this.btnReset.Click += new System.EventHandler(this.btnReset_Click);
            // 
            // btnStop
            // 
            this.btnStop.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.btnStop.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStop.Enabled = false;
            this.btnStop.Location = new System.Drawing.Point(84, 120);
            this.btnStop.Name = "btnStop";
            this.btnStop.Size = new System.Drawing.Size(75, 23);
            this.btnStop.TabIndex = 5;
            this.btnStop.Text = "Stop";
            this.btnStop.UseVisualStyleBackColor = true;
            this.btnStop.Visible = false;
            this.btnStop.Click += new System.EventHandler(this.btnStop_Click);
            // 
            // cbPhraseSets
            // 
            this.cbPhraseSets.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.cbPhraseSets.AutoSize = true;
            this.cbPhraseSets.Location = new System.Drawing.Point(352, 124);
            this.cbPhraseSets.Name = "cbPhraseSets";
            this.cbPhraseSets.Size = new System.Drawing.Size(105, 17);
            this.cbPhraseSets.TabIndex = 6;
            this.cbPhraseSets.Text = "Use Phrase Sets";
            this.cbPhraseSets.UseVisualStyleBackColor = true;
            this.cbPhraseSets.CheckedChanged += new System.EventHandler(this.cbPhraseSets_CheckedChanged);
            // 
            // btnPrevious
            // 
            this.btnPrevious.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.btnPrevious.Enabled = false;
            this.btnPrevious.Location = new System.Drawing.Point(463, 357);
            this.btnPrevious.Name = "btnPrevious";
            this.btnPrevious.Size = new System.Drawing.Size(75, 23);
            this.btnPrevious.TabIndex = 7;
            this.btnPrevious.Text = "Previous";
            this.btnPrevious.UseVisualStyleBackColor = true;
            this.btnPrevious.Click += new System.EventHandler(this.btnPrevious_Click);
            // 
            // btnNext
            // 
            this.btnNext.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.btnNext.Enabled = false;
            this.btnNext.Location = new System.Drawing.Point(768, 357);
            this.btnNext.Name = "btnNext";
            this.btnNext.Size = new System.Drawing.Size(75, 23);
            this.btnNext.TabIndex = 8;
            this.btnNext.Text = "Next";
            this.btnNext.UseVisualStyleBackColor = true;
            this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
            // 
            // lbWordlist
            // 
            this.lbWordlist.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.lbWordlist.FormattingEnabled = true;
            this.lbWordlist.Location = new System.Drawing.Point(463, 122);
            this.lbWordlist.Name = "lbWordlist";
            this.lbWordlist.Size = new System.Drawing.Size(380, 229);
            this.lbWordlist.TabIndex = 9;
            // 
            // btnFlag
            // 
            this.btnFlag.AccessibleRole = System.Windows.Forms.AccessibleRole.None;
            this.btnFlag.Enabled = false;
            this.btnFlag.Location = new System.Drawing.Point(651, 357);
            this.btnFlag.Name = "btnFlag";
            this.btnFlag.Size = new System.Drawing.Size(111, 23);
            this.btnFlag.TabIndex = 10;
            this.btnFlag.Text = "Flag and Next";
            this.btnFlag.UseVisualStyleBackColor = true;
            this.btnFlag.Click += new System.EventHandler(this.btnFlag_Click);
            // 
            // rtbOutput
            // 
            this.rtbOutput.Location = new System.Drawing.Point(3, 149);
            this.rtbOutput.Name = "rtbOutput";
            this.rtbOutput.Size = new System.Drawing.Size(454, 231);
            this.rtbOutput.TabIndex = 11;
            this.rtbOutput.Text = "";
            // 
            // FrmMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(855, 410);
            this.Controls.Add(this.rtbOutput);
            this.Controls.Add(this.btnFlag);
            this.Controls.Add(this.lbWordlist);
            this.Controls.Add(this.btnNext);
            this.Controls.Add(this.btnPrevious);
            this.Controls.Add(this.cbPhraseSets);
            this.Controls.Add(this.btnStop);
            this.Controls.Add(this.btnReset);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.btnStart);
            this.Controls.Add(this.tbOutput);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "FrmMain";
            this.Text = "Braille Legibility Study Tool";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.FrmMain_FormClosing);
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox tbOutput;
        private System.Windows.Forms.Button btnStart;
        private System.ComponentModel.BackgroundWorker hidWorker;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel lblDevice;
        private System.Windows.Forms.Button btnReset;
        private System.Windows.Forms.Button btnStop;
        private System.Windows.Forms.CheckBox cbPhraseSets;
        private System.Windows.Forms.Button btnPrevious;
        private System.Windows.Forms.Button btnNext;
        private System.Windows.Forms.CheckedListBox lbWordlist;
        private System.Windows.Forms.ToolStripDropDownButton btnReconnect;
        private System.Windows.Forms.Button btnFlag;
        private System.Windows.Forms.RichTextBox rtbOutput;
    }
}

