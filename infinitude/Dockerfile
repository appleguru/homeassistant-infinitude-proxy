ARG BUILD_FROM
ARG UPSTREAM_REF=nebulous/infinitude:2026.10.0@sha256:dc70ff6a997c5cab9b8b4ed690a70ca53ddca4d797212cc4a2d178cbb7eec094
FROM ${UPSTREAM_REF}

COPY run.sh render-options.pl /opt/infinitude-app/

ENTRYPOINT []
CMD [ "/opt/infinitude-app/run.sh" ]

LABEL \
    io.hass.name="Infinitude" \
    io.hass.description="Local Carrier Infinity Touch thermostat proxy" \
    io.hass.type="app"
