FROM nginx:alpine

# копируем шаблон
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80