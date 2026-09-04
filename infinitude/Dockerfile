ARG BUILD_FROM
ARG UPSTREAM_REF=nebulous/infinitude@sha256:66f64d156c6f4537369d6ea587cf4440cf9607b0e7b8296468febf96bafebe00
FROM ${UPSTREAM_REF}

COPY run.sh render-options.pl /opt/infinitude-app/

ENTRYPOINT []
CMD [ "/opt/infinitude-app/run.sh" ]

LABEL \
    io.hass.name="Infinitude" \
    io.hass.description="Local Carrier Infinity Touch thermostat proxy" \
    io.hass.type="app"
