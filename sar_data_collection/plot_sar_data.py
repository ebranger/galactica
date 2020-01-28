# database as first argument

import matplotlib # Import matplotlib before matplotlib.pyplot to be able to run without DISPLAY
matplotlib.use('Agg')

from datetime import datetime
from matplotlib.dates import date2num
import matplotlib.pyplot as plt
import sqlite3
import sys

start = date2num(datetime.strptime("2019-01-01","%Y-%m-%d"))

if __name__ == "__main__":
    con = sqlite3.connect(sys.argv[1])
    cur = con.cursor()
    table_field_label_color = [
        ("select_cpu","percent_used","CPU [%]","red"),
        ("select_mem","percent_memused","MEM [%]","black")
    ]
    for host in cur.execute("SELECT DISTINCT hostname FROM select_cpu"):
        hostname = host[0]
        fig,ax = plt.subplots(num="{0}".format(hostname))
        ax.set_xlabel("Date")
        ax.set_ylabel("Usage")

        for tfl in  table_field_label_color:
            t = []
            y = []
            cur2 = con.cursor()
            sql = "SELECT timestamp,{0} FROM {1} WHERE hostname=?".format(tfl[1],tfl[0])
            for row in cur2.execute(sql,(hostname,)):
                d =  date2num( datetime.strptime(row[0],"%Y-%m-%d %H:%M:%S %Z") )
                if d > start:
                    t.append( d )
                    y.append( row[1] )
            ax.plot_date(t,y,ls='-',marker=None,label=tfl[2],linewidth=0.5,
		color=tfl[3])

        ax.legend()
        fig.savefig("{0}.svg".format(hostname))
    con.close()
