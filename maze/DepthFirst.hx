package maze;

import haxe.ds.GenericStack;
import maze._internal.Grid;
import maze._internal.Point2D;
import maze._internal.Util;
import seedyrng.Random;

/**
Container for a point, and the directions that can still be explored from said point.
**/
private class PointAndDirections {
	public var point(default, default):Point2D;
	public var directions(default, default):Array<Point2D>;

	public function new(point: Point2D, directions: Array<Point2D>) {
		this.point = point;
		this.directions = directions;
	}
}

/**
 * Depth-First maze generation.
 */
class DepthFirst {
	public static function make(Columns:Int, Rows:Int, seed:String = null):Array<Array<Int>> {
		// ensure minimum size
		if (Columns < 3) {
			Columns = 3;
		}
		if (Rows < 3) {
			Rows = 3;
		}

		var random = new Random();

		// if no seed is supplied, be random
		if (seed != null) {
			random.setStringSeed(seed);
		}

		var grid:Array<Array<Int>> = Grid.IntGrid(Columns, Rows, 1);

		// start with a random point that can be explored from in all directions
		var current:PointAndDirections = new PointAndDirections(
			Util.getRandomStartingPoint2D(random, Columns, Rows),
			Util.getDirections()
		);
		var next:Point2D = new Point2D(0, 0);

		var stack:GenericStack<PointAndDirections> = new GenericStack<PointAndDirections>();

		// start the stack off with a terminator value which has no directions to explore
		stack.add(new PointAndDirections(current.point, []));

		var isDeadEnd: Bool;

		grid[current.point.y][current.point.x] = 0;

		while (!stack.isEmpty()) {
			isDeadEnd = true;

			while (current.directions.length > 0) {
				var randIdx: Int = random.randomInt(0, current.directions.length - 1);
				var direction: Point2D = current.directions.splice(randIdx, 1)[0];

				// the next point is the current point in a random direction
				next.x = current.point.x + direction.x;
				next.y = current.point.y + direction.y;

				// the "next next" point is in the same direction as the next point
				var nextNext: Point2D = new Point2D(next.x + direction.x, next.y + direction.y);

				// if the next and "next next" point is within bounds
				// and if the "next next" point is a wall
				if (Util.isWithinBounds(next, Columns, Rows) &&
					Util.isWithinBounds(nextNext, Columns, Rows) &&
					grid[nextNext.y][nextNext.x] != 0) {
					stack.add(new PointAndDirections(
						current.point,
						Util.getDirections())
						);
					// make the next and "next next" points a passage
					grid[next.y][next.x] = grid[nextNext.y][nextNext.x] = 0;

					// TODO optimise: remove inverted "direction" from directions
					current = new PointAndDirections(nextNext, Util.getDirections());

					// we've moved to a new point, and can explore in new directions.
					isDeadEnd = false;
					break;
				}
			}

			if (isDeadEnd) {
				// we've reached a dead end, so rewind the stack and see if there are
				// other directions to explore.
				if (!stack.isEmpty()) {
					current = stack.pop();
				}
			}
		}

		return grid;
	}
}