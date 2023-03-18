FROM centos:centos7

RUN yum install python3 python3-pip -y

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

WORKDIR /python_api
COPY python-api.py python-api.py

ENTRYPOINT ["python3", "python-api.py"]
