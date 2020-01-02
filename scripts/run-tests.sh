#!/bin/bash
set -ev
cd firmware
mix local.rebar --force
mix local.hex --force
mix deps.get
mix test
cd ../ui
mix local.rebar --force
mix local.hex --force
mix deps.get
mix test
