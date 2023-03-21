# Build Stage 1
# This build created a staging docker image
#

FROM node:16.19.0-alpine AS appbuild

WORKDIR /usr/src/app

COPY package.json ./

COPY babel.config.json ./

RUN npm install

COPY ./src ./src

RUN npm run build


# Build Stage 2
# This build takes the production build from staging build
#

FROM node:16.19.0-alpine

WORKDIR /usr/src/app

COPY package.json ./

COPY babel.config.json ./

COPY .env ./

RUN npm install

COPY --from=appbuild /usr/src/app/dist ./dist

EXPOSE ${PORT}

ENV TZ ASIA/SEOUL

CMD ["node", "dist/app.js"]
