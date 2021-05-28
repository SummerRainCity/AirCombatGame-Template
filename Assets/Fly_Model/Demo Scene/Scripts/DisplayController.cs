using UnityEngine;

namespace TinForge.AircraftDemo
{
	public class DisplayController : MonoBehaviour
	{
		public Transform[] vehicles;
		private int selection = 0;

		void OnEnable()
		{
			DisplaySelection(selection);
		}
		void OnGUI()
		{

			if (GUI.Button(new Rect((Screen.width - 600) / 2, 10, 100, 25), GetName(selection - 1)))
				DisplaySelection(selection - 1);

			if (GUI.Button(new Rect((Screen.width + 400) / 2, 10, 100, 25), GetName(selection + 1)))
				DisplaySelection(selection + 1);

			if (GUI.Button(new Rect(20, (Screen.height - 60), 100, 25), "Landing Gear"))
			{
				Animator animator = vehicles[selection].GetComponent<Animator>();
				if (animator != null)
					animator.SetBool("Landing Gear", !animator.GetBool("Landing Gear"));
			}

			if (GUI.Button(new Rect((Screen.width - 200), (Screen.height - 110), 100, 25), "Reset"))
				UnityEngine.SceneManagement.SceneManager.LoadScene(0);
			
			if (GUI.Button(new Rect((Screen.width - 200), (Screen.height - 60), 100, 25), "Exit"))
				Application.Quit();
			

			GUIStyle style = new GUIStyle();
			style.alignment = TextAnchor.MiddleCenter;
			GUI.contentColor = Color.black;


			GUI.Label(new Rect(20, 10, 200, 20), "Right Mouse to Look",style);
			GUI.Label(new Rect(20, 30, 200, 20), "WASD to Move", style);
			GUI.Label(new Rect(20, 50, 200, 20), "Esc to Exit Cinematic", style);
			GUI.Label(new Rect((Screen.width - 200), 10, 200, 20), "By TinForge", style);

			style.fontSize = 25;
			GUI.Label(new Rect((Screen.width - 200) / 2, 10, 200, 25), vehicles[selection].name, style);
		}

		private void DisplaySelection(int selection)
		{
			vehicles[this.selection].gameObject.SetActive(false);
			this.selection = ClampSelection(selection);
			vehicles[this.selection].gameObject.SetActive(true);
		}

		private string GetName(int selection)
		{
			selection = ClampSelection(selection);
			return vehicles[selection].name;
		}

		private int ClampSelection(int selection)
		{
			if (selection < 0)
				return vehicles.Length-1;
			else if (selection >= vehicles.Length)
				return 0;
			else
				return selection;
		}
	}
}
