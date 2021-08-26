FROM 583682874749.dkr.ecr.ap-southeast-2.amazonaws.com/base/node/build:12-latest as builder
WORKDIR /app
COPY . .
RUN yarn install
RUN yarn test
RUN yarn build

# ---- Run ---- #
FROM 238566567174.dkr.ecr.ap-southeast-2.amazonaws.com/nginx:latest
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
RUN mkdir policychange
COPY --from=builder /app/dist policychange/
COPY --from=builder /app/dist/index.html .
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT ["nginx", "-g", "daemon off;"]
