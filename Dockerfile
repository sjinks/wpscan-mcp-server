FROM dhi.io/bun:1-alpine3.23@sha256:162c9bbb91e64f978dd84d7854413e573a1c9f9e758d6b5e5d1928608a80d69c AS build

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
