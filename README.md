# Code of war 2018

Code of War 2018 is an AI programming game where you write a bot to conquer the galaxy, planet by planet. The rules are simple; each planet produces people per turn, and ships can be used to take over other planets from the enemy or neutral forces. It's inspired by Google Planetwars for those of you that are familiar with the game. Once you have written your bot, you submit it to the official site and it competes online against others from around the world!

## Requirements
- a git client
- nodejs and npm https://nodejs.org/

## Setup

* Get the project and install dependencies

```shell
git clone https://github.com/damoebius/codeofwar.git
cd codeofwar & npm i
```

* Build it

```shell
npm run build
```

* Run the local server

```shell
npm start
```

# Game Specification

This game takes place on a map which contains several planets, each of which has a population on it. Each planet may have a different population. The planets may belong to one of three different owners: you, your opponent, or neutral. The game has a certain maximum number of turns. At the time of this writing, the maximum number of turns on the official server is [500](https://github.com/damoebius/codeofwar/blob/master/src/com/tamina/planetwars/data/Game.hx#L49). Provided that neither player performs an invalid action, the player with the largest population at the end of the game wins. The game may also end earlier if one of the players loses all his planets, in which case the player that has planets remaining wins instantly. If both players have the same poulation when the game ends, it's a draw.

On each turn, the player may choose to send fleets of ships from any planet he owns to any other planet on the map. He may send as many fleets as he wishes on a single turn as long as he has enough people to supply them. After sending fleets, each planet owned by a player (not owned by neutral) will increase the forces there according to that planet's ["growth" rate](https://github.com/damoebius/codeofwar/blob/master/src/com/tamina/planetwars/data/Game.hx#L28).The fleets will then take some number of turns to reach their destination planets, where they will then fight any opposing forces there and, if they win, take ownership of the planet. Fleets cannot be redirected during travel. Players may continue to send more fleets on later turns even while older fleets are in transit.

## The Map
Maps are randomized with random planets number and size.

## Planets
https://github.com/damoebius/codeofwar/blob/master/src/com/tamina/planetwars/data/Planet.hx

Planet positions are specified relative to a common origin in Euclidean space. The coordinates are given as floating point numbers. Planets never move and are never added or removed as the game progresses. Planets are not allowed to occupy the exact same position on the map.

The owner of a planet can be neutral, player 1, or player 2. The owner of a planet can change throughout the game.
The population is given as an integer, and it may change throughout the game.

The growth rate of the planet is the number of people added to the planet after each turn. Planets have a population maxium number according to their size.
https://github.com/damoebius/codeofwar/blob/master/src/com/tamina/planetwars/data/PlanetPopulation.hx

[Each planet](https://github.com/damoebius/codeofwar/blob/master/src/com/tamina/planetwars/data/Planet.hx) is also implicitly assigned an ID. A planet's ID will never change throughout the game.

## Fleets
https://github.com/damoebius/codeofwar/blob/master/src/com/tamina/planetwars/data/Ship.hx

The source planet and destination planet are specified according to the planets' IDs as specified above.

The total trip length is given as an integer, representing the total number of turns required to make the trip from source to destination. The turns remaining is also an integer, representing the number of turns left from the current turn to arrive at the destination. Trip lengths are determined at the time of departure by taking the Euclidean distance to the destination from the source and rounding up.

## Turns
The game engine performs the following steps repeatedly:

Send the [game state](https://github.com/damoebius/codeofwar/blob/master/src/com/tamina/planetwars/data/Galaxy.hx) to the players.
Receive orders from both players.

Update the game state.
Check for endgame conditions.
There is an unspecified maximum turn limit. At the time of this writing, the maximum is 500 turns, but this may change. The intent is to have this number nailed down later in the contest period.

A turn is defined as the above four steps. They are performed up to 500 times and then the game stops. This means that the players receive the game state up to 500 times and send sets of orders up to 500 times.

## Game State Update
After receiving complete lists of commands from the players, the engine then updates the game state, advancing the game to the next turn. This happens in three phases: departure, advancement, and arrival.

### Departure
In this phase, the players' commands are carried out. This consists of creating new fleets and removing the appropriate numbers of people from each planet. Fleet trip lengths are determined by taking the Euclidean distance to the destination from the source and rounding up.

### Advancement & Arrival
This phase advances fleets. Fleets are advanced by simply decrementing their "turns remaining" values.

Fleets whose "turns remaining" became zero tried a planet invasion. It does so by considering each destination planet at a time.

For each planet, consider its owner and ship count along with the owners and ship counts of each fleet. 
If Planet and ships owners are different the system remove as planet's people as ship's crew. If the crew is larger than the planet population, the attack is a success. The new planet population start with the remaining crew.

If Planet and ships owners are the same, the crew is added to the planet population without exeeded the maximum.

If there is more than one ship, the system resolve arrival randomly.

### Endgame Conditions
The following conditions will cause the game to end:

- The turn limit is reached (500). The winner is the player with the largest population, both on planets and in fleets. If both players have the same number of ships, it's a draw.
- One player runs out of population entirely. The winner is the other player.
- Both players run out of population at the same time. The game is a draw.
- A bot issues a command with the same source and destination planet and forfeits the game.
- A bot sends invalid data and forfeits the game.
- A bot crashes and forfeits the game.
- A bot exceeds the time limit (1000ms) without completing its orders (it never sends it's turn orders) and is disqualified. This is perhaps overly harsh, but is the way it currently works. It may change in the future to simply be a forfeit.
- A bot attempts to do something that the tournament manager deems a security issue and is disqualified.

## Create your AI

You just have to edit MyIA.hx, and do things in the getOrders function to return your turn Orders.
```haxe
override public function getOrders(context:Galaxy):Array<Order> {
        var result:Array<Order> = new Array<Order>();
        //TODO Put your code here
        return result;
    }
```

Then you can compile it with :
```shell
npm run build:ai
```

And try it versus our basic AI on :
http://localhost:8092/play.html

## Publishing your AI online
```shell
npm run publish
```
