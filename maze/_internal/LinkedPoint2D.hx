package maze._internal;

import maze._internal.Point2D;

/**
A LinkedPoint2D is a Point2D with a parent.
**/
class LinkedPoint2D extends Point2D {

	public var parent(default, null):LinkedPoint2D;

	public function new(x:Int, y:Int, parent:LinkedPoint2D) {
		super(x, y);
		this.parent = parent;
	}

	/**
	Get the point opposite the parent from this one.
	E.g.
			this  -> parent -> opposite
			[0,1] -> [0,2] -> [0,3]
	**/
	public function GetOppositeFromParent():LinkedPoint2D {
		var diffX:Int = x - parent.x;
		var diffY:Int = y - parent.y;

		if (diffX != 0) return new LinkedPoint2D(x + diffX, y, parent);
		if (diffY != 0) return new LinkedPoint2D(x, y + diffY, parent);

		return null;
	}

	public static function fromPoint2D(point: Point2D): LinkedPoint2D {
		return new LinkedPoint2D(point.x, point.y, null);
	}
}