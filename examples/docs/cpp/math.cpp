/**
 * This namespace contains some very totally useful functions for
 * doing very totally important operations such as sum and sub.
 */
namespace math
{
        /**
         * Sums two integers.
         * @param a first number to sum
         * @param b second number to sum
         * @see sub()
         * @return a + b
         *
         * @code
         * sum(1, 5) // 6
         * @endcode
         */
        int sum(int a, int b)
        {
                return a + b;
        }

        /**
         * Subtracts two integers.
         * @param a number to subtract from
         * @param b number to subtract from `a`
         * @see sum()
         * @return a - b
         *
         * @code
         * sub(5, 1) // 4
         * @endcode
         */
        int sub(int a, int b)
        {
                return a - b;
        }
}
