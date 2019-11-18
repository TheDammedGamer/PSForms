using System;
using System.Collections;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.IO;

namespace PSFormsClassLib
{
    public class PSFormsInputTextBox
    {
        public string Name { get; private set; }
        public string DisplayName { get; set; }
        public string Tooltip { get; set; }
        public Hashtable Attributes { get; set; }
        public int Rows { get; set; }
        public int Columns { get; set; }

        public PSFormsInputTextBox()
        {

        }
        public PSFormsInputTextBox(string name)
        {
            Name = name;
            DisplayName = String.Format("{0}:", name);
        }

        public PSFormsInputTextBox(string name, string displayName)
        {
            Name = name;
            DisplayName = displayName;
        }
    }

    [Cmdlet(VerbsCommon.New, "PSFormsInputTextBoxObject")]
    [OutputType(typeof(PSFormsInput))]
    public class NewPSFormsInputTextBoxObjectCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        [Parameter(Position = 1, ValueFromPipelineByPropertyName = true)]
        public string DisplayName { get; set; }

        [Parameter(Position = 2, ValueFromPipelineByPropertyName = true)]
        public string ToolTip { get; set; }

        [Parameter(Position = 3, ValueFromPipelineByPropertyName = true)]
        public int Rows { get; set; }

        [Parameter(Position = 4, ValueFromPipelineByPropertyName = true)]
        public int Columns { get; set; }

        [Parameter(Position = 6, ValueFromPipelineByPropertyName = true)]
        public Hashtable Attributes { get; set; }

        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing()
        {
            WriteVerbose("Checking Paramters");
            if (Helper.FilePathHasInvalidChars(Name))
                throw new ArgumentException("Name Paramater contains Invalid File Path Characters");

            if (string.IsNullOrWhiteSpace(DisplayName))
                DisplayName = string.Format("{0}:", Name);
            else
                DisplayName = string.Format("{0}:", DisplayName);

            if (Rows == 0)
                Rows = 8;

            if (Columns == 0)
                Columns = 3;
        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            WriteVerbose("Creating Object");
            var item = new PSFormsInputTextBox(Name)
            {
                DisplayName = DisplayName,
                Rows = Rows,
                Columns = Columns
            };

            if (!string.IsNullOrWhiteSpace(ToolTip))
                item.Tooltip = ToolTip;

            WriteObject(item);
        }
        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
        }
    }
}