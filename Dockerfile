FROM dhi.io/bun:1-alpine3.22-dev@sha256:661f8231212f356b3b10a158763e1e45dc8d18f9335225c303af9e2bee76c880 AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.22@sha256:c30e6103d653d70950cd12028436f14c26dafd2bb4fc75174265f5a71273c045
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
