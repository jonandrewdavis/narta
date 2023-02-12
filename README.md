# narta

A top down multiplayer action adventure game. Not for use.

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
