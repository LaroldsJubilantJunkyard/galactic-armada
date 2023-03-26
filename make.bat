mkdir dist
mkdir bin

rgbasm -L -o bin/ShootEmUp.o src/ShootEmUp.asm
rgbasm -L -o bin/background.o src/background.asm

rgbasm -L -o bin/bullets.o src/objects/bullets.asm
rgbasm -L -o bin/enemies.o src/objects/enemies.asm
rgbasm -L -o bin/player.o src/objects/player.asm

rgbasm -L -o bin/sporbs_lib.o libs/sporbs_lib.asm
rgbasm -L -o bin/input.o libs/input.asm
rgbasm -L -o bin/math.o src/utils/math.asm
rgbasm -L -o bin/enemy-bullet-collision.o src/objects/collision/enemy-bullet-collision.asm
rgbasm -L -o bin/sprites.o src/sprites.asm
rgblink -o dist/ShootEmUp.gb bin/input.o bin/background.o bin/sprites.o bin/math.o  bin/bullets.o bin/player.o bin/enemies.o   bin/ShootEmUp.o bin/enemy-bullet-collision.o bin/sporbs_lib.o
rgbfix -v -p 0xFF dist/ShootEmUp.gb