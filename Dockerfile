FROM zooniverse/nodejs

ADD ./ /app/

WORKDIR /app

RUN npm install

ENTRYPOINT [ "npm", "run-script" ]
