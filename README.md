# narta

A top down multiplayer action adventure game built in Godot 4.0. Just for learning. Not for use.

## Sources:

Check out these excellent tutorials I took bits & pieces from to learn the engine & make this game.

- [Godot-Roguelike-Tutorial](https://github.com/MateuSai/Godot-Roguelike-Tutorial)
  - I borrowed a lot of the combat mechanics like the sword swinging to this tutorial, go try it!
  - Of note, the FMS (finite state machine) code in this tutorial is really robust. It also teaches a lot about inheritence, making extending things natural. A great starting point for a complex game.
- [Make an Action RPG in Godot 3.2](https://www.youtube.com/watch?v=mAbG8Oi-SvQ&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=1)
  - The most comprehensive tutorial around. A little dated for 4.0, but teaches many of the fundamentals!
- [https://www.youtube.com/watch?v=n8D3vEx7NAE](https://www.youtube.com/watch?v=n8D3vEx7NAE&t=1995s)
  - The foundation of the networked multiplayer is in this video. Highly recommend 4.0 if you're doing anything networked.
- [Inventory Editor (G4)](https://godotengine.org/asset-library/asset/1215)
  - This inventory system drives the loot system & items. Adapated for network use, of course (challenging!!)
- [Itch.io free assets](https://itch.io/game-assets/free)
  - Most pixel art can be found in the top free ones!

And that's it! This game is an amalgam of all of these and more. Many thanks to those who put these together!

## Host on AWS

Just saving some commands I use just in case. Follow this great guide. https://urodelagames.github.io/2022/04/19/setting-up-godot-server-on-aws/

```
scp -i [your_pem].pem [your_pck].pck ec2-user@[server_ip]:/home/ec2-user/
```

Connect via SSH. Swap out: `Godot_v4.0-beta17_linux` for your version.

```
sudo yum install wget && sudo yum install unzip && wget https://downloads.tuxfamily.org/godotengine/4.0/beta17/Godot_v4.0-beta17_linux.x86_64.zip && unzip Godot_v4.0-beta17_linux.x86_64.zip

```

Run. Swap out: `./Godot_v4.0-beta17_linux.x86_64` for your version. `--` are user args. Add server to yours.

```
./Godot_v4.0-beta17_linux.x86_64 --main-pack [your_pck].pck --headless  -- server
```

This is for my Ubutuntu box

```
sudo apt install unzip && wget https://downloads.tuxfamily.org/godotengine/4.0/beta17/Godot_v4.0-beta17_linux.x86_64.zip && unzip Godot_v4.0-beta17_linux.x86_64.zip
```
