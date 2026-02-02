FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter config --enable-web
RUN flutter build web --release

FROM caddy:2-alpine
WORKDIR /usr/share/caddy
COPY --from=build /app/build/web .
ENV PORT=8080
CMD ["sh", "-c", "caddy file-server --root /usr/share/caddy --listen :${PORT}"]
