# bad-parrots

## What is this?

Some mise scripts for setting up my local LLM environment. Maybe you'll find them
useful. Review them before running, since my local setup might not work for you.

## Why no worky?

If you're on Apple silicon (M1, M4, etc) then uh, [docker no worky](https://chariotsolutions.com/blog/post/apple-silicon-gpus-docker-and-ollama-pick-two/).

## Usage

1. Install [mise](https://mise.jdx.dev/)
2. `mise run` to see list of tasks
3. `mise run ollama:docker_setup` first, then `mise run ollama:docker_run` Yes, mise can handle dependencies, I just haven't bothered yet.

## Errata

[Parrots?](https://dl.acm.org/doi/10.1145/3442188.3445922)
