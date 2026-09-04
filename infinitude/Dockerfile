ARG BUILD_FROM
ARG UPSTREAM_TAG=latest
FROM nebulous/infinitude:${UPSTREAM_TAG}

COPY run.sh render-options.pl /opt/infinitude-app/

ENTRYPOINT []
CMD [ "/opt/infinitude-app/run.sh" ]

LABEL \
    io.hass.name="Infinitude" \
    io.hass.description="Local Carrier Infinity Touch thermostat proxy" \
    io.hass.type="app"
