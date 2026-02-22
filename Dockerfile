FROM dhi.io/bun:1-alpine3.22-dev@sha256:661f8231212f356b3b10a158763e1e45dc8d18f9335225c303af9e2bee76c880 AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.23@sha256:d4a40935ea2d0086f8599aff9058ac1cac5cbdea2d8203d4cf20ae151269a91d
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
