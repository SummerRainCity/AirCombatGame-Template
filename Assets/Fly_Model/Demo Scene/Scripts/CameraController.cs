using UnityEngine;

namespace TinForge.AircraftDemo
{
	public class CameraController : MonoBehaviour
	{
		[SerializeField] private float speed = 5;
		[SerializeField] private float xSensitivity = 3;
		[SerializeField] private float ySensitivity = 2;
		bool mouseLock;
		bool orbiting;
		Transform pivot;

		void Start()
		{
			pivot = transform.parent;
			Lock(true);
		}

		void Update()
		{
			//Toggle Input
			if (Input.GetButton("Fire2"))
				Lock(false);
			else if (Input.GetButtonUp("Fire2"))
				Lock(true);

			if(Input.GetAxis("Vertical")!=0|| Input.GetAxis("Horizontal") != 0)
			Camera.main.transform.parent.GetComponent<Rotate>().enabled = orbiting = false;

			//Movement
				float x = Input.GetAxis("Horizontal") * speed * Time.deltaTime;
				float z = Input.GetAxis("Vertical") * speed * Time.deltaTime;
				float y = 0;
				if (Input.GetKey(KeyCode.Space))
					y += 1 * speed * Time.deltaTime;
				if (Input.GetKey(KeyCode.LeftShift))
					y -= 1 * speed * Time.deltaTime;

				transform.Translate(new Vector3(x, y, z));

			if (!mouseLock)
			{
				//Mouse
				float X = Input.GetAxis("Mouse X") * xSensitivity;
				float Y = -Input.GetAxis("Mouse Y") * ySensitivity;

				transform.Rotate(new Vector3(Y, X, 0));
				Quaternion r = transform.rotation;
				transform.rotation = Quaternion.Euler(new Vector3(r.eulerAngles.x, r.eulerAngles.y, 0));
			}
		}

		private void Lock(bool mouseLock)
		{
			this.mouseLock = mouseLock;
			Cursor.lockState = (CursorLockMode) (mouseLock == true ? 0 : 1);
			Cursor.visible = mouseLock;
		}

		private void OnGUI()
		{
			if (GUI.Button(new Rect(20, (Screen.height - 110), 100, 25), "Orbit")) {
				orbiting = !orbiting;
				Camera.main.transform.parent.GetComponent<Rotate>().enabled = orbiting;
			}
		}

	}
}