FROM praekeltfoundation/vumi:0.6.10-alpine

COPY requirements/go-metrics-api.txt /requirements.txt
RUN pip install -r /requirements.txt

EXPOSE 8000

COPY go-metrics-api/entrypoint.sh /scripts/go-metrics-api-entrypoint.sh
CMD ["go-metrics-api-entrypoint.sh"]
