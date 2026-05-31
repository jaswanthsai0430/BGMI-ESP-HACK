class Vector2 {
	double x;
	double y;
  
	Vector2(this.x, this.y);
  
	Vector2.zero() : x = 0, y = 0;
  
	Vector2 copy() => Vector2(x, y);
  
	bool isOnScreen(double screenWidth, double screenHeight) {
		return x >= 0 && x <= screenWidth && y >= 0 && y <= screenHeight;
	}
  
	@override
	String toString() => 'Vector2($x, $y)';
}
