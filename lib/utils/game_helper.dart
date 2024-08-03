import 'dart:math';

class MineSweeperGame {
  static int row = 6;
  static int col = 6;
  static int minesNo = 5;

  static int cells = row * col;

  late List<List<Cell>> map;
  List<Cell> gameMap = [];

  bool gameOver = false;
  bool gameWon = false;

  MineSweeperGame() {
    resetGame();
  }

  // Method to set new game parameters
  void setGameParameters({int? newRow, int? newCol, int? newMinesNo}) {
    if (newRow != null) row = newRow;
    if (newCol != null) col = newCol;
    if (newMinesNo != null) minesNo = newMinesNo;

    cells = (newRow ?? row) * (newCol ?? col);
    resetGame(); // Reset the game with new parameters
  }

  void generateMap() {
    placeMines();
    gameMap.clear();
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        gameMap.add(map[i][j]);
      }
    }
  }

  void resetGame() {
    map = List.generate(
      row,
      (x) => List.generate(
        col,
        (y) => Cell(row: x, col: y, content: "", reveal: false),
      ),
    );
    gameMap.clear();
    generateMap();
    gameOver = false;
    gameWon = false;
  }

  // Placing Mines
  void placeMines() {
    Random rn = Random();
    int placedMines = 0;
    while (placedMines < minesNo) {
      int mR = rn.nextInt(row);
      int mC = rn.nextInt(col);
      if (map[mR][mC].content != "X") {
        map[mR][mC] = Cell(row: mR, col: mC, content: "X", reveal: false);
        placedMines++;
      }
    }
  }

  // Function To Show Mines
  void showMines() {
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == "X") {
          map[i][j].reveal = true;
        }
      }
    }
  }

  // Function to get what action to do when we click
  void getClickedCell({required Cell cell}) {
    if (cell.reveal || gameOver) return;

    // Check For Mine
    if (cell.content == "X") {
      showMines();
      gameOver = true;
    } else {
      // Calculate the number to display nearby mines
      int mineCount = 0;
      int cellRow = cell.row;
      int cellCol = cell.col;

      for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
        for (int j = max(cellCol - 1, 0); j <= min(cellCol + 1, col - 1); j++) {
          if (map[i][j].content == "X") {
            mineCount++;
          }
        }
      }

      cell.reveal = true;
      cell.content = mineCount;

      // If no mines around, reveal neighboring cells
      if (mineCount == 0) {
        for (int i = max(cellRow - 1, 0); i <= min(cellRow + 1, row - 1); i++) {
          for (int j = max(cellCol - 1, 0);
              j <= min(cellCol + 1, col - 1);
              j++) {
            if (!map[i][j].reveal) {
              getClickedCell(cell: map[i][j]);
            }
          }
        }
      }
    }

    checkWinCondition();
  }

  // Check for win condition
  void checkWinCondition() {
    bool allCellsRevealed = true;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content != "X" && !map[i][j].reveal) {
          allCellsRevealed = false;
          break;
        }
      }
      if (!allCellsRevealed) break;
    }
    if (allCellsRevealed) {
      gameWon = true;
    }
  }
}

class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal;

  Cell({
    required this.row,
    required this.col,
    required this.content,
    this.reveal = false,
  });
}
