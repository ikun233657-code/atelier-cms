FROM directus/directus:10.13.0

USER root
RUN mkdir -p /directus/uploads && chown -R node:node /directus/uploads

USER node
WORKDIR /directus

EXPOSE 8055

CMD node /directus/cli.js bootstrap && npx directus start
