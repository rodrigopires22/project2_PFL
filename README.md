# project2_PFL

Afonso Mansilha Vieira Leite da Silva - up:202206002 - contribution:50%
Rodrigo - contribution:50%

Developing of the "Sight" game.

**Installation and Execution:**
We both run the program on the wsl(windows subsystem for linux) where in order to start our program we first runed sictus (useing ./sictus), then we loaded the game file (using [game.pl].) and lastly we run the program (using play.). 

**Description of the game:**
Sight is a game that utilizes the concept of vision. The objective of the game is to be the last player to run out of valid moves, to do that the player as to try placing his pieces in line of sight of one and other (beacuse this enables them to play more moves) while also trying to block the opponent line of sight.


**Game Logic:**
Game Configuration Representation: To reperesent the game we used the function initial_state para criar um tabuleiro 5X5 com as células vazias.
Internal Game State Representation: We used the letters w (to represent the white pieces) and b (to represent black pieces) ,the [] to represent empty spaces and [w N] to represent stacks (N is the number of pieces int the stack).
    EX: [ ][ ][w][b][ ]          [ b ][   ][ w ][b 2][   ]          [ b ][ b ][w 2][ b ][ w ]
        [ ][ ][ ][ ][w]          [   ][   ][w 2][ b ][b 2]          [   ][ w ][ w ][b 2][ b ]
        [ ][w][ ][ ][ ]    ->    [   ][b 2][w 2][ w ][   ]    ->    [ w ][ b ][w 3][ w ][ w ]
        [ ][ ][ ][ ][b]          [   ][ w ][ w ][b 2][ w ]          [   ][ b ][w 2][b 2][w 2]
        [b][ ][ ][ ][ ]          [   ][ b ][ w ][ b ][   ]          [b 3][   ][w 2][ b ][   ]
Move Representation: For a piece to move we input the coordinates of that piece first and then we input the coordinates where we want to move it. In order to see if the moves are valid or not we used the valid_move function to validate.
User Interaction: For user interaction we opted for a simple approach where the option are displayed in the terminal and the user inputs the desired option, if it is an invalid input an error message is print and the user is sent back.

**Conclusion**
In conclusion, we think the project could have gone better beacuse even thought we work hard developing the game and improving our prolog knowlage, we had a lot of difficulty and ultimately fail in implementing the stack funcionality which is a core feature of our game, so we think the end result is below our expectation. On the plus side, we were able to implement the other funcionalities and run the program without erros.

**Bibliography:**
For this project we mainly use the slides given in classes and ChatGPT.
We use ChatGPT mainly to try to implement the stack funcionality with querys like " Can you help me develop a function to create stacks (place a piece on top of other ex: [w] -> [w 2]) from this sight mechanic" and to give us information about prolog features like nth and between.
