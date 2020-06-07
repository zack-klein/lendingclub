/* NOTE: This is duplicated in ddl/loans_poc_ddl, as this code is used
in the Snowpipe, which is created as part of the DDL.  It is outlined
here just for reference. */

copy into loans_poc.loans_poc.loans_poc_ingest
from @loans_poc_stage
file_format = (TYPE = CSV)
on_error = 'continue'
