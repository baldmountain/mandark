#!/bin/bash
set -ev
mix local.rebar --force
mix local.hex --force
mix archive.install --force hex nerves_bootstrap
cd ui
mix deps.get
mix deps.compile
cd assets
npm install
npm rum deploy
cd ..
mix phx.digest
mix test
cd ../firmware
mix deps.get
mix deps.compile
mix test
