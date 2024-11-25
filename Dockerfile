# Step 1: Use an official Node.js image as the base image for building the app
FROM node:18 AS build

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Step 4: Install the dependencies
RUN npm install

# Step 5: Copy the rest of the application code
COPY . ./

# Step 6: Build the React application for production
RUN npm run build

# Step 7: Use Nginx to serve the app
FROM nginx:alpine

# Step 8: Copy the build folder from the previous stage to the Nginx server's public directory
COPY --from=build /app/build /usr/share/nginx/html

# Step 9: Copy the custom Nginx configuration file to the container
COPY nginx.conf /etc/nginx/nginx.conf

# Step 10: Expose port 80 to the outside world
EXPOSE 80

# Step 11: Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
