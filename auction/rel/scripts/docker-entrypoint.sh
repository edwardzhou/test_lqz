#!/bin/sh
set -e

mix do ecto.create, ecto.migrate

exec $@
