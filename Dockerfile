FROM dhi.io/bun:1-alpine3.22-dev@sha256:759a6e7d0ce8b90a2232894eb232adc839d531d24cb1641de40a783044c74e6e AS build

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
