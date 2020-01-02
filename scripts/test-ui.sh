#!/bin/bash
set -ev
cd ui
mix deps.get
mix test
cd ..
