class Matrix {
  // The inner datatype used to store matrix values
  List<List<int>> _mat;
  // The inner datatype used to store matrix values in a folded form
  List<int> _vec;
  // Number of columns in the matrix (or Matrix's width)
  final int _w;
  // Number of rows in the matrix (or Matrix's height)
  final int _h;

  int get w => _w;
  int get h => _h;

  // Instance constructor to initialise the dimensions
  // of the matrix
  Matrix(this._w, this._h);

  // Method to read values into the matrix through a serialised
  // vector
  void read(List<int> vec) {
    // Check if dimensions match
    assert(_w * _h == vec.length);
    // Store value of vec
    _vec = vec;
    // Fill the values
    _mat = List.generate(
        _h, (j) => List.generate(_w, (i) => vec[j * _w + i], growable: false),
        growable: false);
  }

  // Overload list access operator. It returns a row of type [List<int>]
  // which already provides a setter and getter API.
  operator [](int j) => _mat[j];

  // Method to import matrix from a comma seperated string
  factory Matrix.fromCSV(String text, Dimensions dim) {
    final mat = Matrix(
      dim.width.round(),
      dim.height.round(),
    );
    final bigVec = text.split(',').map(int.parse).toList();
    mat.read(bigVec);
    return mat;
  }

  // Method to export matrix into CSV format
  String toCSV() {
    if (_mat == null) throw new Exception("Matrix is not yet initialised");
    return _vec.join(",");
  }

  // Check if an index exists within the matrix
  bool includes(int x, int y) {
    return (x >= 0 && x < _w) && (y >= 0 && y < _h);
  }
}

class Dimensions {
  int width;
  int height;
  Dimensions(this.width, this.height);
}
