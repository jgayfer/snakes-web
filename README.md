# Snakes API
This app provides an API for creating and playing a game of snakes and ladders.

## Installation
Install dependencies with bundler
```
bundle
```

Start the server:
```
bundle exec rackup
```

## Endpoints

### New Game
> POST /game

**Parameters**

- `players (string list)` - Names of players to participate in the game

### Retrieve Game

> GET /game/{id}

### Move Next Player

> POST /game/{id}/move



