FROM dhi.io/bun:1-alpine3.22-dev@sha256:98d923c966276fdcb92c8d2f3a7837c3c2fa034fd220dbbc53fe584ca04c0753 AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.23@sha256:74c55fc6b2c1c2d55854f0e3ccea632f8303535c4afa3d18e215bef3a1e22e1b
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
