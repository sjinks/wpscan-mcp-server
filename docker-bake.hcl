target "default" {
  dockerfile = "Dockerfile"
  tags       = ["ghcr.io/sjinks/wpscan-mcp-server:latest"]
  platforms  = ["linux/amd64", "linux/arm64"]
  pull       = true
  output = [
    "type=docker"
  ]

  cache-from = [
    "type=gha"
  ]

  cache-to = [
    "type=gha,mode=max"
  ]
}
