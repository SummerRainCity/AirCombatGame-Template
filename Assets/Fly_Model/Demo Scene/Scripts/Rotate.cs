using UnityEngine;

namespace TinForge.AircraftDemo
{
	public class Rotate : MonoBehaviour
	{
		public Vector3 direction;
		public float rate;

		void Update()
		{
			transform.Rotate(direction.normalized * rate * Time.deltaTime);
		}
	}
}
