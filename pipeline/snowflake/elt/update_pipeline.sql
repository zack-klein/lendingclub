/* NOTE: These are the SQL's that are created in the tasks in the DDL.  There
are listed here just for reference.
*/

-- Clears all data from the semantic table
-- NOTE: Would normally use truncate but that command is not currently
-- supported by tasks :(
delete from loans_poc.loans_poc.loans_poc_semantic;

-- Inserts all data into the semantic table
insert into loans_poc.loans_poc.loans_poc_semantic
  select src.addr_state,
       src.purpose,
       src.loan_amnt,
       src.last_pymnt_amnt,
       src.grade
  from loans_poc_ingest src;
