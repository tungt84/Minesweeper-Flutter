import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minesweeper/ui/common/app.colors.dart';
import 'package:minesweeper/ui/screens/settings_page/settings.page.dart';
import 'package:minesweeper/utils/game_helper.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MineSweeperGame game = MineSweeperGame();

  bool _gameStarted = false;
  bool _gamePaused = false;
  bool _touchMode = true;
  int _markMineCount = 0;


  @override
  void initState() {
    super.initState();
    game.generateMap();
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _gamePaused = false;
    });
  }

  void _pauseGame() {
    setState(() {
      _gamePaused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      _gamePaused = false;
    });
  }


  void _resetGame() {
    setState(() {
      game.resetGame();
      game.gameOver = false;
      _gameStarted = false;
      _gamePaused = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("MineSweeper"),
        actions: [
          if (!_gameStarted)
            IconButton(
              onPressed: _startGame,
              icon: const Icon(Icons.play_arrow),
              tooltip: "Start Game",
            ),
          if (_gameStarted && !_gamePaused)
            IconButton(
              onPressed: _pauseGame,
              icon: const Icon(Icons.pause),
              tooltip: "Pause Game",
            ),
          if (_gameStarted && _gamePaused)
            IconButton(
              onPressed: _resumeGame,
              icon: const Icon(Icons.play_arrow),
              tooltip: "Resume Game",
            ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(game: game),
                ),
              );
            },
            icon: const Icon(Icons.settings),
            tooltip: "Settings",
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !_touchMode? 
                      InkWell(
                        onTap: () {
                         setState(() {
                            if(_gameStarted){
                              _touchMode = false;
                            }
                          });
                        },
                        highlightColor: AppColor.secondaryColor.withOpacity(0.3),
                        splashColor: AppColor.secondaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.secondaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.flag,
                            color: AppColor.secondaryColor,
                            size: 34.0,),
                          ),
                        ),
                      ):
                      IconButton(icon:
                        Icon(
                        Icons.flag,
                        color: AppColor.secondaryColor,
                        size: 34.0,
                        ),
                        onPressed: ()=>{
                          setState(() {
                            if(_gameStarted){
                              _touchMode = false;
                            }
                          })
                        },
                      ),
                      _touchMode ?
                      InkWell(
                        onTap: () {
                         setState(() {
                            if(_gameStarted){
                              _touchMode = true;
                            }
                          });
                        },
                        highlightColor: AppColor.secondaryColor.withOpacity(0.3),
                        splashColor: AppColor.secondaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.secondaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.touch_app,
                            color: AppColor.secondaryColor,
                            size: 34.0,),
                          ),
                        ),
                      ): IconButton(icon: 
                        Icon(
                          Icons.touch_app,
                          color: AppColor.secondaryColor,
                          size: 34.0,
                        ),
                        onPressed: () =>{ 
                          setState(() {
                            if(_gameStarted){
                              _touchMode = true;
                            }
                          })
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    color: AppColor.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.flag,
                        color: AppColor.secondaryColor,
                        size: 34.0,
                      ),
                      Text(
                        _markMineCount.toString()+"/"+ MineSweeperGame.minesNo.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Game Grid
          Container(
            width: double.infinity,
            height: 500.0,
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MineSweeperGame.row,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: MineSweeperGame.cells,
              itemBuilder: (BuildContext context, index) {
                Color cellColor = game.gameMap[index].reveal
                    ? AppColor.clickedCardColor
                    : AppColor.lightPrimaryColor;
                return GestureDetector(
                  onTap: !_gameStarted || _gamePaused || game.gameOver
                      ? null
                      : () {
                          setState(() {
                            List<Cell> gameMapIndex = [];
                            game.getClickedCell(
                              cell: game.gameMap[index],
                              touchMode: _touchMode,
                                gameMapIndex: gameMapIndex
                            );
                            if(!_touchMode && !game.gameMap[index].reveal){
                              if(game.gameMap[index].markFlag){
                                _markMineCount++;
                              }else{
                                _markMineCount--;
                              }
                            }
                            if (game.gameOver || game.gameWon) {

                            }
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: (game.gameMap[index].reveal ||  game.gameMap[index].markFlag)
                          ? (game.gameMap[index].content == "X" || game.gameMap[index].markFlag)
                              ? Icon(
                                  Icons.flag,
                                  color:game.gameMap[index].markFlag ?  AppColor.secondaryColor:Colors.red,
                                  size: 24.0,
                                )
                              : Text(
                                  "${game.gameMap[index].content==0?"":game.gameMap[index].content}",
                                  style: TextStyle(
                                    color: AppColor.letterColors[
                                        game.gameMap[index].content],
                                    fontSize: 20.0,
                                  ),
                                )
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            game.gameOver ? (game.gameWon ? "You Win!" : "You Lose") : "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          game.gameOver
              ? RawMaterialButton(
                  onPressed: () {
                    _resetGame();
                  },
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 18.0,
                  ),
                  fillColor: AppColor.secondaryColor,
                  child: const Text(
                    "Play Again",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
