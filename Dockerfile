FROM node:18-alpine AS build
RUN npm i -g pnpm
WORKDIR /app
COPY package*.json .
RUN pnpm install
COPY . .


RUN npm run build


FROM nginx:stable-alpine

# copy the nginx configuration
COPY --from=build /app/nginx.conf /etc/nginx/nginx.conf

# Remove the default Nginx website that comes with the image
RUN rm -rf /usr/share/nginx/html/*

# Copy the dist/spa folder of your Quasar app to the default Nginx website directory
# copy the built app from the previous stage
COPY --from=build /app/dist/spa/ /usr/share/nginx/html/


EXPOSE 3005

# start nginx
CMD ["nginx", "-g", "daemon off;"]
