FROM dhi.io/bun:1-alpine3.22-dev@sha256:a791761254163aef0c1d0a3126dbd1db7dafda6aedf6140937cb98c6dec68be6 AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.23@sha256:e20d44909ce0684a7b064bf4038dcd83f6dd27c27de7668e144f0ecd17e3e6a5
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
