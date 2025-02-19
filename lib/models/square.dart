class Square {
  final int _file;
  final int _rank;

  const Square(this._file, this._rank);

  factory Square.fromId(int id) {
    if (id < 0 || id > 63) {
      throw ArgumentError('Square id must be between 0 and 63');
    }

    final file = (id % 8) + 1;
    final rank = (id ~/ 8) + 1;

    return Square(file, rank);
  }

  factory Square.fromAlgebraicNotation(String algebraicNotation) {
    if (algebraicNotation.length != 2) {
      throw ArgumentError('Algebraic notation must contain two letters');
    }

    final fileName = algebraicNotation.substring(0, 1).toLowerCase();
    // Convert ASCII: 'a' = 97, so subtract 96 to get 1 for 'a'
    final file = fileName.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1;
    if (file < 1 || file > 8) {
      throw ArgumentError('File must be a letter between a and h');
    }

    final rank = int.parse(algebraicNotation.substring(1));
    if (rank < 1 || rank > 8) {
      throw ArgumentError('Rank must be a number between 1 and 8');
    }

    print('$file $rank');

    return Square(file, rank);
  }

  int get file => _file;
  int get rank => _rank;

  bool get isDark => (_file + _rank) % 2 == 0;

  int get id => (_rank - 1) * 8 + (_file - 1);

  String get algebraicNotation {
    String fileLetter = String.fromCharCode('a'.codeUnitAt(0) + _file - 1);
    return '$fileLetter$_rank';
  }

  /// [[Top], [Right], [Bottom], [Left]]
  List<List<Square>> get orthogonalSquares {
    final result = <List<Square>>[];

    List<Square> singleDirectionSquares(bool isSameFile, int step) {
      final singleDirectionSquaresTemp = <Square>[];
      for (
        var i = step + (isSameFile ? rank : file);
        step == 1 ? i <= 8 : i >= 1;
        i += step
      ) {
        singleDirectionSquaresTemp.add(
          Square(isSameFile ? file : i, isSameFile ? i : rank),
        );
      }
      return singleDirectionSquaresTemp;
    }

    result.add(singleDirectionSquares(true, 1)); // Top
    result.add(singleDirectionSquares(false, 1)); // Right
    result.add(singleDirectionSquares(true, -1)); // Bottom
    result.add(singleDirectionSquares(false, -1)); // Left

    return result;
  }

  static bool isSquareIdValid(int squareId) {
    return squareId >= 0 && squareId <= 63; // TODO: Use this function instead
  }

  @override
  String toString() {
    return algebraicNotation;
  }

  @override
  bool operator ==(Object other) {
    if (other is Square) {
      return other._file == _file && other._rank == _rank;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _file * 31 + _rank; // TODO: Understand this
}
