#!/bin/bash
set -ev
cd ui
mix local.rebar --force
mix local.hex --force
mix deps.get
cd assets
npm install
npm rum deploy
cd ..
mix phx.digest
mix test
cd ../firmware
mix local.rebar --force
mix local.hex --force
mix archive.install --force hex nerves_bootstrap
mix deps.get
mix test
