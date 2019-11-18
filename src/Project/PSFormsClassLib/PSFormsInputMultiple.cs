using System;
using System.Collections;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;

namespace PSFormsClassLib
{
    class PSFormsInputMultiple
    {
        public string Name { get; private set; }
        public string DisplayName { get; set; }
        public string TooltTip { get; set; }
        public string[] Options { get; set; }
        public Hashtable Attributes { get; set; }


        public PSFormsInputMultiple(string name)
        {
            Name = name;
        }

    }

    [Cmdlet(VerbsCommon.New, "PSFormsInputMultipleObject")]
    [OutputType(typeof(PSFormsInputMultiple))]
    public class NewPSFormsInputMultipleObjectCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        [Parameter(Mandatory = true, Position = 1, ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string[] Options { get; set; }

        [Parameter(Position = 2, ValueFromPipelineByPropertyName = true)]
        public string DisplayName { get; set; }

        [Parameter(Position = 3, ValueFromPipelineByPropertyName = true)]
        public string ToolTip { get; set; }

        [Parameter(Position = 4, ValueFromPipelineByPropertyName = true)]
        public Hashtable Attributes { get; set; }


        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing()
        {
            WriteVerbose("Checking Paramters");
            
            
            if(Helper.FilePathHasInvalidChars(Name))
                throw new ArgumentException("Name parameter contains invalid file path characters.");

            if (string.IsNullOrWhiteSpace(DisplayName))
                DisplayName = string.Format("{0}:", Name);
            else
                DisplayName = string.Format("{0}:", DisplayName);

            if (Options.Length <= 1)
                throw new ArgumentException("Options parameter requires more than option.");
                
            WriteVerbose( string.Format("Name: {0}", Name));
            WriteVerbose( string.Format("DisplayName: {0}", DisplayName));
            WriteVerbose( string.Format("ToolTip: {0}", ToolTip));
            WriteVerbose( string.Format("Options: {0}", Options));
        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            WriteVerbose("Creating Object");
            var item = new PSFormsInputMultiple(Name);
            item.DisplayName = DisplayName;
            item.Options = Options;
            item.Attributes = Attributes;
            
            
            if (string.IsNullOrWhiteSpace(ToolTip))
                item.TooltTip = ToolTip;
            
            WriteObject(item);
        }

        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
            
        }
    }
}
