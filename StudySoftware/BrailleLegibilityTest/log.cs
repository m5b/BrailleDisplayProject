using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BrailleLegibilityTest
{
    /// <summary>
    /// Track changes to current session.  Save to local storage.
    /// Support crash recovery
    /// </summary>
    class log
    {
        bool crashCheck()
        {
            return true;
        }

        void storeAction(Action action)
        {

        }

        Action getLastAction()
        {
            return null;
        }
    }

    public class action
    {
        string phrase;
        Device device;
    }

    public enum Device
    {
        Brailliant24,
        PrintedDisplay
    }
}
