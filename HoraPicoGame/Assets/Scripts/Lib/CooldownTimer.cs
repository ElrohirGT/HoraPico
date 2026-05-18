using System;
using UnityEngine;

namespace Lib
{
    public class CooldownTimer : MonoBehaviour
    {
        public float originalSecs;
        public float remainingSecs;

        public event Action done;
        public bool IsDone => remainingSecs <= 0;
        
        private bool _fired;
        private void Update()
        {
            if (_fired) return;
            remainingSecs -= Time.deltaTime;

            if (!IsDone) return;
            _fired = true;
            done?.Invoke();
        }

        public void Restart()
        {
            remainingSecs = originalSecs;
        }
    }
}