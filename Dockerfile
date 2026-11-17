FROM dhi.io/bun:1-alpine3.23-dev@sha256:24d640e660dc63a554d4689b4b4facc652223eaeb6eb97cb51a6c5713e0c09ae AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.24@sha256:6278da77eb7e000c38b95711f93d199b2eb108e371a9eb95fb67b911c1f5e2cd
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
