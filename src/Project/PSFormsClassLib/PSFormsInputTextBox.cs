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
        public PSFormsInputTextBox(string name)
        {
            Name = name;
        }
    }
}