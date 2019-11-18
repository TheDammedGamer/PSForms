using System;
using System.Collections.Generic;
using System.Text;

namespace PSFormsClassLib
{
    public class Helper
    {
        public static bool FilePathHasInvalidChars(string path)
        {
            return (!string.IsNullOrEmpty(path) && path.IndexOfAny(System.IO.Path.GetInvalidFileNameChars()) >= 0);
        }
    }
}
