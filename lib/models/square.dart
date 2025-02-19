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

    print('$file, $rank');

    return Square(file, rank);
  }

  factory Square.fromAlgebraicNotation(String algebraicNotation) {
    if (algebraicNotation.length != 2)
      throw ArgumentError('Algebraic notation must contain two letters');

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

  @override
  String toString() {
    return algebraicNotation;
  }

  @override
  bool operator ==(Object square) {
    if (square is Square) {
      return square._file == this._file && square._rank == this._rank;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _file * 31 + _rank; // TODO: understand this
}
