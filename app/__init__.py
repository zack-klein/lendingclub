import flask_admin
import jana
import json
import logging
import os

from flask import Flask, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_bootstrap import Bootstrap


CLOUD_SERVICE_PROVIDER = os.getenv("CLOUD_SERVICE_PROVIDER")

# Across cloud providers, secrets get injected into the application as
# environment variables. Because of this, the application needs to know
# where to look in each environment for the secrets.
GCP_SECRET_VERSION = "1"
SECRET_STRING_NAME = os.getenv("SECRET_STRING_NAME")
GCP_PROJECT_NAME = os.getenv("GCP_PROJECT_NAME")
GCP_SECRET_VERSION = os.getenv("GCP_SECRET_VERSION")


def json_string_to_env(string):
    d = json.loads(string)
    for key, value in d.items():
        os.environ[key] = value


try:
    if CLOUD_SERVICE_PROVIDER == "gcp":
        secret_string = jana.fetch_secret(
            "gcp-secretmanager",
            SECRET_STRING_NAME,
            GCP_PROJECT_NAME,
            GCP_SECRET_VERSION,
        )
        json_string_to_env(secret_string)

    elif CLOUD_SERVICE_PROVIDER == "aws":
        secret_string = jana.fetch_secret(
            "aws-secretsmanager", SECRET_STRING_NAME,
        )
        json_string_to_env(secret_string)

except Exception as e:
    logging.error(
        f"Tried to read secrets from provider: {CLOUD_SERVICE_PROVIDER} "
        f"but failed with exception: '{e}'! The webserver will attempt to "
        "start, but likely won't function properly because it can't make API "
        "calls."
    )

app = Flask(__name__)
app.config.from_pyfile("config.py")
db = SQLAlchemy(app)
bootstrap = Bootstrap(app)


class CustomIndex(flask_admin.AdminIndexView):
    @flask_admin.expose("/")
    def index(self):
        return self.render(
            "index.html", app_name=app.config["FLASK_APP_NAME"],
        )


admin_controller = flask_admin.Admin(
    app,
    name=app.config["FLASK_APP_NAME"],
    template_mode="bootstrap3",
    url="/",
    base_template="ga_base.html",
    index_view=CustomIndex(url="/"),
)

db.create_all()


@app.route("/favicon.ico")
def favicon():
    return send_file("static/favicon.ico")
