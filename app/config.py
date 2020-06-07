import os
import logging

FLASK_APP_NAME = "Lending Club Analysis Project"
FLASK_ADMIN_SWATCH = "cyborg"  # http://bootswatch.com/3/
SECRET_KEY = os.environ.get("FLASK_SECRET_KEY", "you'll never guess!")
SQLALCHEMY_ECHO = False
SQLALCHEMY_TRACK_MODIFICATIONS = False

# Database stuff
TEMP_DB_URI = "sqlite:///sample_db.sqlite"
SQLALCHEMY_DATABASE_URI = os.environ.get(
    "SQLALCHEMY_DATABASE_URI", TEMP_DB_URI
)

if SQLALCHEMY_DATABASE_URI == TEMP_DB_URI:
    logging.warning("No SQLAlchemy config found! Using local file...")
