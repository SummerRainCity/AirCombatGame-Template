using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TinForge.AircraftDemo
{

	public class TrackController : MonoBehaviour
	{

		//Disable Camera & Display (removes camera control, model selection, and GUI)
		//Set position/rotation to settings
		//Custom for each vehicle?
		//Toggle animation gears
		//Run animation
		//Return control

		CameraController cameraController;
		DisplayController displayController;

		public Transform userCamera;
		public Transform cinematicCamera;

		bool locked;

		void Awake()
		{
			cameraController = FindObjectOfType<CameraController>();
			displayController = FindObjectOfType<DisplayController>();
		}

		void OnGUI()
		{
			if (!locked) {
				if (GUI.Button(new Rect(20, 80, 200, 25), "Start Cinematic"))
					StartCoroutine(StartCinematic());
			}
		}

		private IEnumerator StartCinematic()
		{
			locked = true;
			Cursor.visible = false;

			cameraController.enabled = false;
			displayController.enabled = false;

			for (int i = 0; i < displayController.vehicles.Length; i++)
					displayController.vehicles[i].gameObject.SetActive(false);

			for (int i = 0; i < displayController.vehicles.Length; i++) {
				displayController.vehicles[i].gameObject.SetActive(true);

				userCamera.gameObject.SetActive(false);
				cinematicCamera.gameObject.SetActive(true);

				float t = 0;
				bool gearRetracted = false;
				while (t < 28.75f) {
					if (t > 17 && !gearRetracted) {
						Animator landingGear = displayController.vehicles[i].GetComponent<Animator>();
						if (landingGear != null)
							landingGear.SetBool("Landing Gear", true);
						gearRetracted = true;
					}

					if (Input.GetKeyDown(KeyCode.Escape))
						break;

					t += Time.deltaTime;
					yield return null;
				}

				displayController.vehicles[i].gameObject.SetActive(false);
			}

			userCamera.gameObject.SetActive(true);
			cinematicCamera.gameObject.SetActive(false);

			cameraController.enabled = true;
			displayController.enabled = true;

			Cursor.visible = true;
			locked = false;
		}
	}
}

