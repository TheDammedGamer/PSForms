using System;
using System.Collections;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;

namespace PSFormsClassLib
{
    class PSFormsParagraph
    {
        public string Text { get; private set; }
        public Hashtable Attributes { get; set; }

        public PSFormsParagraph(string text)
        {
            Text = text;
        }

    }

    [Cmdlet(VerbsCommon.New, "PSFormsParagraphObject")]
    [OutputType(typeof(PSFormsParagraph))]
    public class NewPSFormsParagraphObjectCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string Text { get; set; }

        [Parameter(Position = 4, ValueFromPipelineByPropertyName = true)]
        public Hashtable Attributes { get; set; }


        // This method gets called once for each cmdlet in the pipeline when the pipeline starts executing
        protected override void BeginProcessing()
        {
            WriteVerbose("Checking Paramters");

            if (string.IsNullOrWhiteSpace(Text))
                throw new ArgumentException("Text Parameter is empty or White Space.");
        }

        // This method will be called for each input received from the pipeline to this cmdlet; if no input is received, this method is not called
        protected override void ProcessRecord()
        {
            WriteVerbose("Creating Object");
            var item = new PSFormsParagraph(Text);
            item.Attributes = Attributes;
            
            WriteObject(item);
        }

        // This method will be called once at the end of pipeline execution; if no input is received, this method is not called
        protected override void EndProcessing()
        {
            
        }
    }
}
