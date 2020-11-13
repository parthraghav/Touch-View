class Matrix {
  // The inner datatype used to store matrix values
  List<List<int>> _mat;
  // Number of columns in the matrix (or Matrix's width)
  final int _w;
  // Number of rows in the matrix (or Matrix's height)
  final int _h;

  // Instance constructor to initialise the dimensions
  // of the matrix
  Matrix(this._w, this._h);

  // Method to read values into the matrix through a serialised
  // vector
  void read(List<int> vec) {
    // Check if dimensions match
    assert(_w * _h == vec.length);
    // Fill the values
    _mat = List.generate(
        _h, (j) => List.generate(_w, (i) => vec[j * _w + i], growable: false),
        growable: false);
  }

  // Overload list access operator. It returns a row of type [List<int>]
  // which already provides a setter and getter API.
  operator [](int j) => _mat[j];
}
