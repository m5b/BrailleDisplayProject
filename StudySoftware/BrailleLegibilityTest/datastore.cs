using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data.SQLite;
using System.Data.Common;

namespace BrailleLegibilityTest
{
    class Datastore
    {
        string connStr = "";
        string filename = "";

        public Datastore(string filename)
        {
            this.filename = filename;
            connStr = string.Format(@"Data Source={0}; Pooling=false; FailIfMissing=false;", filename);
        }

        public bool TryConnect()
        {
            try
            {
                if (!System.IO.File.Exists(filename))
                    createDB();
            }
            catch { return false; }

            return true;
        }

        private void createDB()
        {
            //add table creation code.
            //Table 1:
            using (SQLiteFactory factory = new SQLiteFactory())
            {
                using (DbConnection dbconn = factory.CreateConnection())
                {
                    dbconn.ConnectionString = connStr;
                    dbconn.Open();
                    using (DbCommand cmd = dbconn.CreateCommand())
                    {
                        cmd.CommandText = @"CREATE TABLE LegibilityResults (ID integer primary key, 
                            Device text, Phrase text, Accuracy text, 
                            Flag boolean, StartTime datetime, EndTime datetime);";
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        /*
         * type of device
         * phrase
         * accuracy (1,0,0,1,etc)
         * flag (bool)
         * start time
         * end time
         * 
         * 
         */
    }
}
