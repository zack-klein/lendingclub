"""Configuration file for the pull ingestion.

Dataset details:
    Specifies which dataset from Kaggle should get downloaded.

AWS:
    Specifies which S3 bucket/path should receive the Kaggle download.
"""

# -- Dataset Details --
DATASET_OWNER = "wendykan"
DATASET_NAME = "lending-club-loan-data"


# -- AWS --
BUCKET_PATH = ":)"
FILE_NAME = "loan.csv"
