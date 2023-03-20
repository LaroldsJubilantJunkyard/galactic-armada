mkdir dist
mkdir bin

rgbasm -L -o bin/ShootEmUp.o src/main/ShootEmUp.asm
rgbasm -L -o bin/background.o src/main/background.asm
rgbasm -L -o bin/bullets.o src/main/bullets.asm
rgbasm -L -o bin/enemies.o src/main/enemies.asm
rgbasm -L -o bin/input.o src/main/input.asm
rgbasm -L -o bin/math.o src/main/math.asm
rgbasm -L -o bin/player.o src/main/player.asm
rgbasm -L -o bin/sprites.o src/main/sprites.asm
rgblink -o dist/ShootEmUp.gb bin/input.o bin/background.o bin/sprites.o bin/math.o  bin/bullets.o bin/player.o bin/enemies.o   bin/ShootEmUp.o
rgbfix -v -p 0xFF dist/ShootEmUp.gb