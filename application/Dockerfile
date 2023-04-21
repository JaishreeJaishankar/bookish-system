FROM ubuntu:20.04
RUN apt-get update -y
COPY . /app
WORKDIR /app
RUN set -xe \
    && apt-get update -y \
    && apt-get install -y python3-pip \
    && apt-get install -y mysql-client 
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
ENV FLASK_APP=app.py
ENV FLASK_ENV=development
EXPOSE 8080
ENTRYPOINT [ "flask" ]
CMD [ "run" , "--host=0.0.0.0"]