FROM ortussolutions/commandbox:lucee5

WORKDIR /
RUN rm -rf /app && mkdir -p /app

WORKDIR /app

RUN box coldbox create app name=stachebox skeleton=supersimple && box install --force coldbox@7 && rm -rf testbox

RUN box install stachebox --production

RUN rm -f /app/config/Coldbox.cfc

COPY ./build/Coldbox.cfc /app/config/Coldbox.cfc

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:8080/?healthcheck=true"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1
