package maze._internal;

import maze._internal.Point2D;
import seedyrng.Random;

class Util {
    public static function getDirections(): Array<Point2D> {
		return [new Point2D( -1, 0), new Point2D(1, 0), new Point2D(0, -1), new Point2D(0, 1)];
	}

    public static function isWithinBounds(point: Point2D, columns: Int, rows: Int): Bool {
        return point.x > 0 && point.x < columns - 1 && point.y > 0 && point.y < rows - 1;
    }

    public static function getRandomStartingPoint2D(random: seedyrng.Random, Columns: Int, Rows: Int): Point2D {
        var point:Point2D = new Point2D(random.randomInt(1, Columns - 2), random.randomInt(1, Rows - 2));

		// point to be on odd numbers to avoid double-walls on the edges
		if (point.x % 2 == 0) {
			if (point.x < Columns / 2) {
				point.x += 1;
			} else {
				point.x -= 1;
			}
		}
		if (point.y % 2 == 0) {
			if (point.y < Rows / 2) {
				point.y += 1;
			} else {
				point.y -= 1;
			}
		}

        return point;
    }

    public static function shuffleArray<T>(array:Array<T>, random:Random) {
		var tmp:T;
		var j:Int;
		var i:Int = array.length;
		while (i > 0) {
			j = random.randomInt(0, i - 1);
			tmp = array[--i];
			array[i] = array[j];
			array[j] = tmp;
		}
	}
}