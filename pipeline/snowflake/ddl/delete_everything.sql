-- Clear everything built from this project
drop table loans_poc_ingest;
drop table loans_poc_semantic;
drop task clear_semantic;
drop task insert_semantic;
drop pipe loans_pipe;
drop schema loans_poc;
drop database loans_poc;
drop warehouse loans_poc;
