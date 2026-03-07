FROM dhi.io/bun:1-alpine3.22-dev@sha256:98d923c966276fdcb92c8d2f3a7837c3c2fa034fd220dbbc53fe584ca04c0753 AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.23@sha256:a5f8a2af85666641c436502083a2f3b9a97ee3a1f8c64648a3f14b0642ed87d5
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
