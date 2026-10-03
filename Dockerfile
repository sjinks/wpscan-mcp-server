FROM dhi.io/bun:1-alpine3.22-dev@sha256:98d923c966276fdcb92c8d2f3a7837c3c2fa034fd220dbbc53fe584ca04c0753 AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.24@sha256:636d7e22a2249d1b7d97a70ea8cf6e8450a1faa5f6a6fa7ef7a0b1312d0353e9
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
