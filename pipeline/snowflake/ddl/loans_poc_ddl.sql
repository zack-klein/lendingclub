-- Warehouse
create or replace warehouse loans_poc
with warehouse size = 'XSMALL'
warehouse type = 'STANDARD'
auto_suspend = 300
auto_resume = TRUE
min_cluster_count = 1
max_cluster_count = 1
scaling_policy = 'ECONOMY';

-- Database
create or replace database loans_poc;

-- Schema
create or replace schema loans_poc.loans_poc;

-- Stage
-- To create this, you'll need an AWS key to this bucket :)
create or replace stage loans_poc_stage url='s3://loans-poc'
credentials=(aws_key_id=':)' aws_secret_key=':)');

-- Stage Table
CREATE OR REPLACE TABLE loans_poc_ingest (
  id REAL,
  member_id REAL,
  loan_amnt INTEGER,
  funded_amnt INTEGER,
  funded_amnt_inv INTEGER,
  term TEXT,
  int_rate REAL,
  installment REAL,
  grade TEXT,
  sub_grade TEXT,
  emp_title TEXT,
  emp_length TEXT,
  home_ownership TEXT,
  annual_inc INTEGER,
  verification_status TEXT,
  issue_d TEXT,
  loan_status TEXT,
  pymnt_plan TEXT,
  url REAL,
  desc REAL,
  purpose TEXT,
  title TEXT,
  zip_code TEXT,
  addr_state TEXT,
  dti REAL,
  delinq_2yrs INTEGER,
  earliest_cr_line TEXT,
  inq_last_6mths INTEGER,
  mths_since_last_delinq REAL,
  mths_since_last_record REAL,
  open_acc INTEGER,
  pub_rec INTEGER,
  revol_bal INTEGER,
  revol_util REAL,
  total_acc INTEGER,
  initial_list_status TEXT,
  out_prncp REAL,
  out_prncp_inv REAL,
  total_pymnt REAL,
  total_pymnt_inv REAL,
  total_rec_prncp REAL,
  total_rec_int REAL,
  total_rec_late_fee REAL,
  recoveries REAL,
  collection_recovery_fee REAL,
  last_pymnt_d TEXT,
  last_pymnt_amnt REAL,
  next_pymnt_d TEXT,
  last_credit_pull_d TEXT,
  collections_12_mths_ex_med INTEGER,
  mths_since_last_major_derog REAL,
  policy_code INTEGER,
  application_type TEXT,
  annual_inc_joint REAL,
  dti_joint REAL,
  verification_status_joint TEXT,
  acc_now_delinq INTEGER,
  tot_coll_amt INTEGER,
  tot_cur_bal INTEGER,
  open_acc_6m INTEGER,
  open_act_il INTEGER,
  open_il_12m INTEGER,
  open_il_24m INTEGER,
  mths_since_rcnt_il INTEGER,
  total_bal_il INTEGER,
  il_util REAL,
  open_rv_12m INTEGER,
  open_rv_24m INTEGER,
  max_bal_bc INTEGER,
  all_util INTEGER,
  total_rev_hi_lim INTEGER,
  inq_fi INTEGER,
  total_cu_tl INTEGER,
  inq_last_12m INTEGER,
  acc_open_past_24mths INTEGER,
  avg_cur_bal INTEGER,
  bc_open_to_buy REAL,
  bc_util REAL,
  chargeoff_within_12_mths INTEGER,
  delinq_amnt INTEGER,
  mo_sin_old_il_acct INTEGER,
  mo_sin_old_rev_tl_op INTEGER,
  mo_sin_rcnt_rev_tl_op INTEGER,
  mo_sin_rcnt_tl INTEGER,
  mort_acc INTEGER,
  mths_since_recent_bc REAL,
  mths_since_recent_bc_dlq REAL,
  mths_since_recent_inq REAL,
  mths_since_recent_revol_delinq REAL,
  num_accts_ever_120_pd INTEGER,
  num_actv_bc_tl INTEGER,
  num_actv_rev_tl INTEGER,
  num_bc_sats INTEGER,
  num_bc_tl INTEGER,
  num_il_tl INTEGER,
  num_op_rev_tl INTEGER,
  num_rev_accts INTEGER,
  num_rev_tl_bal_gt_0 INTEGER,
  num_sats INTEGER,
  num_tl_120dpd_2m INTEGER,
  num_tl_30dpd INTEGER,
  num_tl_90g_dpd_24m INTEGER,
  num_tl_op_past_12m INTEGER,
  pct_tl_nvr_dlq REAL,
  percent_bc_gt_75 REAL,
  pub_rec_bankruptcies INTEGER,
  tax_liens INTEGER,
  tot_hi_cred_lim INTEGER,
  total_bal_ex_mort INTEGER,
  total_bc_limit INTEGER,
  total_il_high_credit_limit INTEGER,
  revol_bal_joint REAL,
  sec_app_earliest_cr_line TEXT,
  sec_app_inq_last_6mths REAL,
  sec_app_mort_acc REAL,
  sec_app_open_acc REAL,
  sec_app_revol_util REAL,
  sec_app_open_act_il REAL,
  sec_app_num_rev_accts REAL,
  sec_app_chargeoff_within_12_mths REAL,
  sec_app_collections_12_mths_ex_med REAL,
  sec_app_mths_since_last_major_derog REAL,
  hardship_flag TEXT,
  hardship_type REAL,
  hardship_reason REAL,
  hardship_status REAL,
  deferral_term REAL,
  hardship_amount REAL,
  hardship_start_date REAL,
  hardship_end_date REAL,
  payment_plan_start_date REAL,
  hardship_length REAL,
  hardship_dpd REAL,
  hardship_loan_status REAL,
  orig_projected_additional_accrued_interest REAL,
  hardship_payoff_balance_amount REAL,
  hardship_last_payment_amount REAL,
  disbursement_method TEXT,
  debt_settlement_flag TEXT,
  debt_settlement_flag_date REAL,
  settlement_status REAL,
  settlement_date REAL,
  settlement_amount REAL,
  settlement_percentage REAL,
  settlement_term REAL
);

-- Semantic Table
create or replace table loans_poc_semantic(
  addr_state varchar,
  purpose varchar,
  loan_amt number,
  last_paymnt_amnt number,
  grade varchar
);

-- Pipe
create or replace pipe loans_poc.loans_poc.loans_pipe auto_ingest=true as
  copy into loans_poc.loans_poc.loans_poc_ingest
  from @loans_poc_stage
  file_format = (TYPE = CSV)
  on_error = 'continue';


-- Tasks
-- Clears all data from the semantic table
create or replace task clear_semantic
  schedule = '1440 MINUTE'  -- 1 day
  warehouse = loans_poc
as
  delete from loans_poc.loans_poc.loans_poc_semantic;

alter task clear_semantic resume;

-- Inserts all data into the semantic table
create or replace task insert_semantic
  warehouse = loans_poc
  after clear_semantic
as
  insert into loans_poc.loans_poc.loans_poc_semantic
  select src.addr_state,
       src.purpose,
       src.loan_amnt,
       src.last_pymnt_amnt,
       src.grade
  from loans_poc_ingest src;

  alter task insert_semantic resume;
