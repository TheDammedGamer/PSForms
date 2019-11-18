using System;
using System.Collections;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.IO;

namespace PSFormsClassLib
{
    public class PSFormsInput {
        public string Name { get; private set; }
        public string DisplayName { get; set; }
        public string Tooltip { get; set; }
        public string InputType { get; set; }
        public Hashtable Attributes { get; set; }

        public PSFormsInput()
        {

        }
        public PSFormsInput(string name)
        {
            Name = name;
            DisplayName = String.Format("{0}:", name);
        }
    }

    [Cmdlet(VerbsCommon.New, "PSFormsInputObject")]
    [OutputType(typeof(PSFormsInput))]
    public class NewPSFormsInputObjectCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        [Parameter(Position = 1, ValueFromPipelineByPropertyName = true)]
        public string DisplayName { get; set; }

        [Parameter(Position = 2, ValueFromPipelineByPropertyName = true)]
        [ValidateSet("checkbox", "color", "date", "datetime-local", "email", "number", "tel", "text", "time", "url")]
        public string InputType { get; set; } = "text";

        [Parameter(Position = 3, ValueFromPipelineByPropertyName = true)]
        public string ToolTip { get; set; }

        [Parameter(Position = 4, ValueFromPipelineByPropertyName = true)]
        public string Pattern { get; set; }

        [Parameter(Position = 5, ValueFromPipelineByPropertyName = true)]
        public string Placeholder { get; set; }

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

            if (!string.IsNullOrWhiteSpace(Pattern))
                Attributes.Add("pattern", Pattern);

            if (!string.IsNullOrWhiteSpace(Placeholder))
                Attributes.Add("placeholder", Placeholder);
        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            WriteVerbose("Creating Object");
            var item = new PSFormsInput(Name)
            {
                DisplayName = DisplayName,
                InputType = InputType
            };

            if (!string.IsNullOrWhiteSpace(ToolTip))
                item.Tooltip = ToolTip;

            WriteObject(item);
        }
        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
            WriteVerbose("End!");
        }
    }
}