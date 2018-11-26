using System;

namespace espc18_azurefunc
{
    public static class ArrayExtensions
    {
        public static string Random(this string[] @this)
        {
            var rnd = new Random();
            var i = rnd.Next(0, @this.Length - 1);
            return @this[i];
        }
    }
}