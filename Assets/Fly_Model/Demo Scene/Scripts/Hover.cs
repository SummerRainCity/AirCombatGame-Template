using System.Collections;
using UnityEngine;

namespace TinForge.AircraftDemo
{
	namespace TinForge.AircraftDemo
	{
		public class Hover : MonoBehaviour
		{
			[SerializeField] private bool smooth;
			[SerializeField] private Vector3 direction;
			[SerializeField] private float distance;
			[SerializeField] private float rate;

			private Vector3 start;
			private Vector3 end;

			void OnEnable()
			{
				StartCoroutine(Stuff());
			}

			private IEnumerator Stuff()
			{
				Vector3 start = transform.position;

				while (true)
				{
					float pingpong = Mathf.PingPong(Time.time * rate, 1);

					Vector3 peak = start + direction.normalized * distance;

					if (smooth)
						transform.position = Vector3.Lerp(start, peak, pingpong * pingpong * (3f - 2f * pingpong));
					else
						transform.position = Vector3.Lerp(start, peak, pingpong);

					yield return null;
				}
			}

			void OnDisable()
			{
				StopCoroutine(Stuff());
			}
		}
	}
}
