using System;
using System.Collections;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;

namespace PSFormsClassLib
{
    class PSFormsParagraph
    {
        public string Text { get; set; }
        public Hashtable Attributes { get; set; }

        public PSFormsParagraph(string text)
        {
            Text = text;
        }
    }
}
