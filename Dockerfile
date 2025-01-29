FROM python:3.10

WORKDIR /template_python

COPY . .

# Install packages
RUN \
    pip install --upgrade pip &&\
    pip install -r requirements.txt &&\
    pip install -e ./

# Keep running
CMD ["tail", "-f", "/dev/null"]
