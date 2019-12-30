package maze._internal;

class Grid {

    /**
    * Generates a 2-Dimensional Array of a type.
    *
    * @param	Columns 				Number of columns for the grid
    * @param	Rows					Number of rows for the grid
    * @param	InitValue				Determines the value each element will be set at initialization
    * @return	A 2D Array of Int.
    * */
    public static function IntGrid(Columns:Int, Rows:Int, InitValue:Int):Array<Array<Int>> {
        var grid:Array<Array<Int>> = new Array<Array<Int>>();

        for (y in 0...Rows) {
            grid.push(new Array<Int>());

            for (x in 0...Columns) {
                grid[y].push(InitValue);
            }
        }

        return grid;
    }
}