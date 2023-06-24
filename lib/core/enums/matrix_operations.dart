// All Matrix Operations like ADD, SUBTRACT and more...
// ignore_for_file: constant_identifier_names

enum Operation {
  ADD('+'),
  SUBTRACT('-'),
  MULTIPLY('*'),
  DIVIDE('/'),
  TRANSPOSE('T'),
  INVERSE('^-1'),
  DETERMINANT('|A|'),
  ADJOINT('adj(A)'),
  COFACTOR('cof(A)'),
  EIGENVALUES('eig(A)'),
  EIGENVECTORS('eigv(A)'),
  RANK('rank(A)'),
  NULLITY('null(A)'),
  TRACE('tr(A)'),
  POWER('^'),
  SQUARE_ROOT('sqrt'),
  EXPONENTIAL('exp'),
  LOGARITHM('log'),
  SINE('sin'),
  COSINE('cos'),
  TANGENT('tan'),
  COSECANT('csc'),
  SECANT('sec'),
  COTANGENT('cot'),
  SINEH('sinh'),
  COSINEH('cosh'),
  TANGENTH('tanh'),
  COSECANTH('csch'),
  SECANTH('sech'),
  COTANGENTH('coth');

  const Operation(this.symbol);
  final String symbol;
}
