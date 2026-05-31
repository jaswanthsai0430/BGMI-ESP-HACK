import 'dart:math';

class Vector3 {
	double x;
	double y;
	double z;
  
	Vector3(this.x, this.y, this.z);
  
	Vector3.zero() : x = 0, y = 0, z = 0;
  
	Vector3 copy() => Vector3(x, y, z);
  
	double distanceTo(Vector3 other) {
		final dx = x - other.x;
		final dy = y - other.y;
		final dz = z - other.z;
		return sqrt(dx * dx + dy * dy + dz * dz);
	}
  
	Vector3 operator +(Vector3 other) => Vector3(x + other.x, y + other.y, z + other.z);
	Vector3 operator -(Vector3 other) => Vector3(x - other.x, y - other.y, z - other.z);
  
	@override
	String toString() => 'Vector3($x, $y, $z)';
}
