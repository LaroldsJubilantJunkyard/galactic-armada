mkdir dist
mkdir bin

rgbasm -L -o bin/ShootEmUp.o src/ShootEmUp.asm
rgbasm -L -o bin/background.o src/background.asm
rgbasm -L -o bin/bullets.o src/bullets.asm
rgbasm -L -o bin/enemies.o src/enemies.asm
rgbasm -L -o bin/input.o src/input.asm
rgbasm -L -o bin/math.o src/math.asm
rgbasm -L -o bin/enemy-bullet-collision.o src/enemy-bullet-collision.asm
rgbasm -L -o bin/player.o src/player.asm
rgbasm -L -o bin/sprites.o src/sprites.asm
rgblink -o dist/ShootEmUp.gb bin/input.o bin/background.o bin/sprites.o bin/math.o  bin/bullets.o bin/player.o bin/enemies.o   bin/ShootEmUp.o bin/enemy-bullet-collision.o
rgbfix -v -p 0xFF dist/ShootEmUp.gb