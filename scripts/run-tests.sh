#!/bin/bash
set -ev
cd firmware
mix deps.get
mix test
cd ../ui
mix deps.get
mix test
