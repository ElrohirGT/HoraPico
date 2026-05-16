using System.Text;

namespace Lib
{
    public static class RoomUtils
    {
        public static string GenerateID()
        {
            const int charsPerSection = 4;
            const int sections = 3;
            const string alphabet = "abcdefghijklmnopqrstuvwxyz0123456789";

            var roomId = new StringBuilder();

            for (var i = 0; i < sections; i++)
            {
                var str = RandomUtils.RandomString(alphabet, charsPerSection);
                roomId.Append(str);

                if (i + 1 < sections)
                {
                    roomId.Append('-');
                }
            }

            return roomId.ToString();
        }
    }
}