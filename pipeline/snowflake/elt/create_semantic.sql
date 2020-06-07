/* NOTE: This is duplicated in ddl/loans_poc_ddl, as this code is used
in the task, which is created as part of the DDL.  It is outlined
here just for reference. */

create or replace table loans_poc_semantic(
  addr_state varchar,
  purpose varchar,
  loan_amt number,
  last_paymnt_amnt number,
  grade varchar
)
as
select src.addr_state,
       src.purpose,
       src.loan_amnt,
       src.last_pymnt_amnt,
       src.grade
from loans_poc_ingest src
