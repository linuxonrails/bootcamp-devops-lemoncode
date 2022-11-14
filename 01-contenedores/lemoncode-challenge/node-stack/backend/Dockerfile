FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY [".env.template", "package.json", "package-lock.json", "src", "tsconfig.json", "./"]
RUN npm install --production=false
RUN npm run build 
COPY node_modules .
COPY dist .
EXPOSE 5000
RUN chown -R node /usr/src/app
USER node
CMD ["npm", "exec", "node", "./dist/app.js"]
