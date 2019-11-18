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
}
