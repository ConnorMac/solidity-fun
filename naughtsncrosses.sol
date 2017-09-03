pragma solidity ^0.4.14;

contract NaughtsAndCrosses
{

    struct Player
    {
        string char;
        address addr;
        int8 increment;
    }

    Player[2] players;
    uint8 public currentPlayer;
    string[3][3] public board;
    // col0, col1, col2, row0, row1, row2, diag0, diag1
    int8[8] score;
    bool public gameInProgress;
    Player public winner;
    
    function NaughtsAndCrosses(address playerOneAdr, address playerTwoAdr) 
    {
        players[0] = Player("X", playerOneAdr, 1);
        players[1] = Player("O", playerTwoAdr, -1);
        currentPlayer = 0;
        gameInProgress = true;
        
        board = [
            ["","",""], 
            ["","",""], 
            ["","",""]
        ];
        setScore();
    }

    function setScore() private {
        for (uint i = 0; i<8; i++) {
            score[i] = 0;
        }
    }
    
    // MODIFIERS
    modifier onlyCurrentPlayer() 
    {
        require(msg.sender == players[currentPlayer].addr);
        _;
    }
    
    modifier onlyAPlayer() 
    {
        require(msg.sender == players[0].addr || msg.sender == players[1].addr);
        _;
    }

    modifier gameIsNotFinished() 
    {
       require(gameInProgress);
        _;
    }
    
    function play(uint8[2] coords) 
        onlyCurrentPlayer()
        gameIsNotFinished()
        returns (bool, uint8)
    {
        if (sha3(board[coords[0]][coords[1]]) == sha3("")) {
            board[coords[0]][coords[1]] = players[currentPlayer].char;
            updateScore(coords[0], coords[1]);
            checkWinner();
            if (currentPlayer == 0) {
                currentPlayer = 1;
            } else {
                currentPlayer = 0;
            }
        } else {
            revert();
        }
    }
    
    function updateScore(uint8 x, uint8 y) 
        private
        returns (bool, Player)
    {
        int8 increment = 1;
        if (currentPlayer == 1) { increment = -1 ;}

        // Increments row scores
        score[x] += increment;
        // Increments column scores
        score[3 + y] += increment;
        // Incremenets diagonals
        if (x == y) { score[2*3] += increment; }
        if (3 - 1 - x == y) { score[2*3 + 1] += increment; }
    }

    function checkWinner()
        private
    {
        for (uint8 i = 0; i<8; i++) {
            if (score[i] == 3 || score[i] == -3) {
                winner = players[currentPlayer];
                gameInProgress = false;
            }
        }
    }
}