using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace Lib
{
    public static class RandomUtils
    {
        public static string RandomString(string alphabet, int length)
        {
            var str = new StringBuilder(new string('?', length));
            for (var i = 0; i < length; i++)
            {
                str[i] = alphabet[Random.Range(0, alphabet.Length)];
            }
            return str.ToString();
        }
        
        public static T RandomFromList<T>(List<T> list)
        {
            return list.Count <= 0 ? default : list[Random.Range(0, list.Count)];
        }
    }
    
    
}