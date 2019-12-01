using System;
using System.Collections;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;

namespace PSFormsClassLib
{
    public class PSFormsInputMultiple
    {
        public string Name { get; private set; }
        public string DisplayName { get; set; }
        public string ToolTip { get; set; }
        public string[] Options { get; set; }
        public bool Required {get; set;}
        public Hashtable Attributes { get; set; }


        public PSFormsInputMultiple(string name)
        {
            Name = name;
        }

    }
}
