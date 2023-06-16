FROM ortussolutions/commandbox:lucee5 as workbench

WORKDIR /
RUN rm -rf /app && mkdir -p /app

WORKDIR /app

RUN box coldbox create app name=stachebox skeleton=supersimple && box install --force coldbox@7 && rm -rf testbox

RUN box install stachebox --production

RUN rm -f /app/config/Coldbox.cfc

COPY ./build/Coldbox.cfc /app/config/Coldbox.cfc

# Generate the startup script only
ENV FINALIZE_STARTUP true
RUN $BUILD_DIR/run.sh

# Debian Slim is the smallest OpenJDK image on that kernel. For most apps, this should work to run your applications
FROM eclipse-temurin:11-jre-jammy as app

# COPY our generated files
COPY --from=workbench /app /app
COPY --from=workbench /usr/local/lib/build /usr/local/lib/build
COPY --from=workbench /usr/local/lib/serverHome /usr/local/lib/serverHome

RUN mkdir -p /usr/local/lib/CommandBox/lib

COPY --from=workbench /usr/local/lib/CommandBox/lib/runwar-* /usr/local/lib/CommandBox/lib/
COPY --from=workbench /usr/local/bin/startup-final.sh /usr/local/bin/run.sh

RUN mkdir -p /usr/local/lib/CommandBox/cfml/system/config
COPY --from=workbench /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml

WORKDIR /app

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:8080/?healthcheck=true"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

CMD /usr/local/bin/run.sh
