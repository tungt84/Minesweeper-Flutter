import 'package:flutter/material.dart';
import 'package:minesweeper/ui/common/app.colors.dart';
import 'package:minesweeper/utils/game_helper.dart';

class SettingsPage extends StatefulWidget {
  final MineSweeperGame game;
  const SettingsPage({Key? key, required this.game}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _row = MineSweeperGame.row.toDouble();
  double _col = MineSweeperGame.col.toDouble();
  double _minesNo = MineSweeperGame.minesNo.toDouble();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        title: const Text("Settings"),
        centerTitle: true,
      ),
      backgroundColor: AppColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlider(
              label: 'Rows',
              value: _row,
              min: 2,
              max: 20,
              onChanged: (value) {
                setState(() {
                  _row = value;
                });
              },
            ),
            _buildSlider(
              label: 'Columns',
              value: _col,
              min: 2,
              max: 20,
              onChanged: (value) {
                setState(() {
                  _col = value;
                });
              },
            ),
            _buildSlider(
              label: 'Mines',
              value: _minesNo,
              min: 1,
              max: (_row * _col / 2)
                  .toInt()
                  .toDouble(), // Mines shouldn't exceed half of the total cells
              onChanged: (value) {
                setState(() {
                  _minesNo = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondaryColor,
                ),
                onPressed: () {
                  widget.game.setGameParameters(
                    newRow: _row.toInt(),
                    newCol: _col.toInt(),
                    newMinesNo: _minesNo.toInt(),
                  );

                  widget.game.resetGame();
                  Navigator.pop(context);
                },
                child: const Text("Apply Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            '$label: ${value.toInt()}',
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: max.toInt() - min.toInt(),
              onChanged: onChanged,
              activeColor: AppColor.secondaryColor,
              inactiveColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
