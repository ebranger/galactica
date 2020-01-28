-- Structure to hold data produced by the command 'sadf -d'.
CREATE TABLE cpu_info(
      hostname text not null
      ,interval integer not null
      ,timestamp datetime not null
      ,CPU integer not null
      ,percent_user real not null
      ,percent_nice real not null
      ,percent_system real not null
      ,percent_iowait real not null
      ,percent_steal real not null
      ,percent_idle real not null
      );

-- Structure to hold data produced by the command 'sadf -d -- -r'.
CREATE TABLE mem_info(
      hostname text not null
      ,interval integer not null
      ,timestamp datetime not null
      ,kbmemfree integer not null
      ,kbmemused integer not null
      ,percent_memused real not null
      ,kbbuffers integer not null
      ,kbcached integer not null
      ,kbcommit integer not null
      ,percent_commit real not null
      ,kbactive integer not null
      ,kbinact integer not null
      ,kbdirty integer not null
      );

CREATE VIEW select_cpu AS SELECT hostname,timestamp,percent_user+percent_nice+percent_system+percent_iowait+percent_steal AS percent_used FROM cpu_info ORDER BY hostname,timestamp;

CREATE VIEW select_mem AS SELECT hostname,timestamp,percent_memused FROM mem_info  ORDER BY hostname,timestamp;
