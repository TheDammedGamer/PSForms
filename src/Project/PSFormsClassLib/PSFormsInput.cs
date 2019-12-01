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
        public bool Required {get; set;}
        public Hashtable Attributes { get; set; }
        
        public PSFormsInput(string name)
        {
            Name = name;
        }
    }
}