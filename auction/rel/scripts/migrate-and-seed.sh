#!/bin/sh

echo "Starting migration of auction"
$RELEASE_ROOT_DIR/bin/auction command Elixir.Auction.Release.Tasks migrate
echo "Finished migration of auction"

echo "Starting seeds of auction"
$RELEASE_ROOT_DIR/bin/auction command Elixir.Auction.Release.Tasks seed
echo "Finished seeds of auction"
