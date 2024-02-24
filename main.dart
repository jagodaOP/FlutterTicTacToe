import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, '');
  String currentTurn = 'X';
  int noughtScore = 0;
  int crossScore = 0;
  String turnLabel = 'X';

  void _resetBoard() {
    setState(() {
      board = List.filled(9, '');
      currentTurn = 'X';
      turnLabel = currentTurn;
    });
  }

  void _newGame() {
    setState(() {
      _resetBoard();
      noughtScore = 0;
      crossScore = 0;
    });
  }

  void _addToBoard(int index) {
    if (board[index] == '') {
      setState(() {
        board[index] = currentTurn;
        currentTurn = currentTurn == 'O' ? 'X' : 'O';
        turnLabel = currentTurn;
        if (_victoryCheck('X')) {
          crossScore += 1;
          _endResultAlert('Crosses take this one!');
        } else if (_victoryCheck('O')) {
          noughtScore += 1;
          _endResultAlert('Noughts bring home the W!');
        } else if (!_boardHasEmptySpaces()) {
          _endResultAlert('Draw');
        }
      });
    }
  }

  bool _victoryCheck(String symbol) {
    List<List<int>> winConditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Horizontal
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Vertical
      [0, 4, 8], [2, 4, 6]            // Diagonal
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] == symbol &&
          board[condition[1]] == symbol &&
          board[condition[2]] == symbol) {
        return true;
      }
    }
    return false;
  }

  bool _boardHasEmptySpaces() {
    return board.contains('');
  }

  void _endResultAlert(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text("Noughts $noughtScore\n\nCrosses $crossScore"),
          actions: <Widget>[
            TextButton(
              child: const Text("Reset Board"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetBoard();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.gamepad_rounded),
            tooltip: 'New Game',
            onPressed: _newGame,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Board',
            onPressed: _resetBoard,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Turn: $turnLabel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _addToBoard(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blueGrey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(fontSize: 40, color: Colors.blueGrey[900], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Scores - Noughts: $noughtScore, Crosses: $crossScore', style: TextStyle(fontSize: 20, color: Colors.blueGrey[600])),
          ),
        ],
      ),
    );
  }
}
