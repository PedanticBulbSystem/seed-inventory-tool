SQL scripts go in this subdirectory.

* CREATE scripts to install the tables and views.
* Utility scripts to extract data.
* QC scripts to check and clean data.
* postgres backups as pg_dump custom and plain sql

Note the data is imported interactively thru the gui from csv files rather than a bulk COPY. But the pg_dump plain sql format contains the bulk upload. I could make a separate pg_dump file with just the data.

