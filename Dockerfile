FROM python:3.8-slim-buster

RUN adduser --gecos "" --disabled-password debian

COPY requirements.txt /home/debian/requirements.txt
RUN pip install --upgrade pip && \
    pip install --upgrade -r /home/debian/requirements.txt

RUN pip install -i https://test.pypi.org/simple/ jana

WORKDIR /home/debian/webserver

COPY ./ ./

RUN chown -R debian /home/debian/webserver/app/

USER debian

CMD sh scripts/entrypoint.sh
