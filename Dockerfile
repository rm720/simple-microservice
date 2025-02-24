FROM python:3.12-slim

RUN mkdir -p /app
COPY . main.py /app/
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8080
CMD [ "main.py" ]
ENTRYPOINT [ "python" ]
