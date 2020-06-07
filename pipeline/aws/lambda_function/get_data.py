"""Lambda function to call API and get data.

Uses the kaggle API to grab the data from Kaggle, save it to an S3 bucket.
"""
import boto3
import logging
import kaggle.api as kaggle

from config import DATASET_OWNER, DATASET_NAME, BUCKET_PATH, FILE_NAME


def _download_from_kaggle(owner, dataset, path, unzip=True):
    """Download data from Kaggle.

    Note: dataset owner and names can be found in the Kaggle URL - they are
        structured as: {dataset_owner}/{dataset_name}

    Args:
        owner: <String> Name of the owner of the dataset.
        dataset: <String> Name of the dataset.
        path: <String> Name of the path where the file should get downloaded.
        unzip: <Boolean> Should the file be unzipped when it downloads?
    Returns:
        <Boolean> was the download successful?
    """
    success = False
    dl_path = "{owner}/{dataset}".format(owner=owner, dataset=dataset)
    try:
        kaggle.dataset_download_files(
            dl_path, path=path, quiet=False, unzip=unzip, force=True
        )
        success = True
        print("Download successful!")
    except Exception as err:
        logging.error("An error occurred!")
        logging.error("Error type: {}".format(type(err)))
        logging.error("Error message: {}".format(err))
    finally:
        return success


def _upload_to_s3(file, bucket, key):
    """Upload a local file to an S3 bucket.
    """
    success = False
    try:
        s3 = boto3.resource("s3")
        s3.meta.client.upload_file(file, bucket, key)
        success = True
    except Exception as err:
        logging.error("An error occurred!")
        logging.error("Error type: {}".format(type(err)))
        logging.error("Error message: {}".format(err))
    finally:
        return success


def main():
    """Save the data from the DATASET specified in the config.py file to S3.
    """
    local_path = "/"
    local_download = _download_from_kaggle(
        DATASET_OWNER, DATASET_NAME, local_path
    )
    if local_download:
        success = _upload_to_s3(local_path + FILE_NAME, BUCKET_PATH, FILE_NAME)
    else:
        success = False
    return success


if __name__ == "__main__":
    main()
