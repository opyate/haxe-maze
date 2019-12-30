package maze ;

import seedyrng.Random;
import haxe.Int64;
import maze._internal.Grid;
import maze._internal.Util;
import maze._internal.Point2D;
import maze._internal.LinkedPoint2D;

/**
 * 1. Start with a grid full of walls.
 * 2. Pick a cell, mark it as part of the maze. Add the walls of the cell to the wall list.
 * 3. While there are walls in the list:
 *   3.1 Pick a random wall from the list. If only one of the two cells that the wall divides is visited, then:
 *     3.1.1 Make the wall a passage and mark the unvisited cell as part of the maze.
 *     3.1.2 Add the neighboring walls of the cell to the wall list.
 *   3.2 Remove the wall from the list.
 */
class Prim {
	/**
	* Call a function `fn` for each direction `[0,1], [1,0], [0,-1], [-1,0]`, passing
	* the direction tuples as arguments, if the provided `point` is within bounds `Columns` and `Rows`.
	* If `point` is not provided, then no bounds check is made.
	*
	* See https://haxe.org/manual/types-function-optional-arguments.html
	* "The Haxe Compiler ensures that optional basic type arguments are
	* nullable by inferring their type as Null<T> when compiling to a static target."
	*/
	public static function forEachDirection(fn:(Int, Int)->Void, ?point: LinkedPoint2D, ?Columns:Int, ?Rows:Int) {
		var x;
		var y;
		// for each direction
		for (dir in [[0,-1], [-1,0], [1,0], [0,1]]) {
			x = dir[0];
			y = dir[1];

			// do a bounds check if the point was provided
			if (point == null) {
				fn(x, y);
			} else {
				// if the point is within bounds
				if (point.y + y >= 0 && point.y + y < Rows && point.x + x >= 0 && point.x + x < Columns) {
					fn(x, y);
				}
			}
		}
	}

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

		// "1. Start with a grid full of walls"
		var grid:Array<Array<Int>> = Grid.IntGrid(Columns, Rows, 1);

		// "2. Pick a cell"
		// Pick at most one away from the edges, otherwise we'll get gaps in the surrounding wall.
		var start:LinkedPoint2D = LinkedPoint2D.fromPoint2D(Util.getRandomStartingPoint2D(random, Columns, Rows));

		// "(2. continued) mark it as part of the maze"
		grid[start.y][start.x] = 0;

		var walls:Array<LinkedPoint2D> = new Array<LinkedPoint2D>();

		// "(2. continued) Add the walls of the cell to the wall list."
		// Each wall has the starting point as the parent.
		forEachDirection((x, y) -> {
			if (grid[start.y + y][start.x + x] == 1) {
				walls.push(new LinkedPoint2D(start.x + x, start.y + y, start));
			}
		}, start, Columns, Rows);

		// "3. While there are walls in the list"
		// dig some holes until we've visited all the cells.
		while (walls.length != 0) {
			// This step combines 3.1 and 3.2 from the pseudocode.
			// "3.1 Pick (and remove) a random wall from the list."
			// "3.2 Remove the wall from the list."
			var wallPoint:LinkedPoint2D = walls.splice(random.randomInt(0, walls.length - 1), 1)[0];

			// "(3.1 continued) If only one of the two cells that the wall divides is visited, then:"
			// get the point on the opposite side of 'wallPoint's parent
			var pointOnOtherSideOfWall = wallPoint.GetOppositeFromParent();

			// if the opposite point is still within bounds

			if (Util.isWithinBounds(pointOnOtherSideOfWall, Columns, Rows)) {
				// ...and the point is a wall
				if (grid[wallPoint.y][wallPoint.x] == 1) {
					// ... and the opposite point is a wall
					if (grid[pointOnOtherSideOfWall.y][pointOnOtherSideOfWall.x] == 1) {
						// "3.1.1 Make the wall a passage and mark the unvisited cell as part of the maze."
						grid[wallPoint.y][wallPoint.x] = 0;
						grid[pointOnOtherSideOfWall.y][pointOnOtherSideOfWall.x] = 0;

						// "3.1.2 Add the neighboring walls of the cell to the wall list."
						forEachDirection((x, y) -> {
							if (grid[pointOnOtherSideOfWall.y + y][pointOnOtherSideOfWall.x + x] == 1) {
								walls.push(new LinkedPoint2D(pointOnOtherSideOfWall.x + x, pointOnOtherSideOfWall.y + y, pointOnOtherSideOfWall));
							}
						}, pointOnOtherSideOfWall, Columns, Rows);
					}
				}
			}
		}

		return grid;
	}
}