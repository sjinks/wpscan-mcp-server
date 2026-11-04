FROM dhi.io/bun:1-alpine3.22-dev@sha256:a36a544ee675461e5a33665927a0c00f5c3b2b9312dc98c471a0e5fc784c30a4 AS build

WORKDIR /app
COPY package.json bun.lock ./
RUN ["bun", "install", "--frozen-lockfile"]

COPY . .
RUN ["bun", "run", "compile"]
RUN ["apk", "add", "--no-cache", "libstdc++"]

FROM dhi.io/alpine-base:3.24@sha256:7b06d747fcb428a0699679955e903b13322c92c79d94ce94c108634f13a714f1
COPY --from=build /app/wpscan-mcp /usr/local/bin/wpscan-mcp
COPY --from=build /usr/lib/libgcc_s.* /usr/lib/libstdc++.* /usr/lib/
ENTRYPOINT [ "/usr/local/bin/wpscan-mcp" ]
