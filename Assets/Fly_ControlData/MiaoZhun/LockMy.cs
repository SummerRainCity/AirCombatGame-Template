using UnityEngine;
using System.Collections;

public class LockMy : MonoBehaviour
{
	//Backup
	Transform myroot;
	public bool locking;
	//锁定贴图
	public Texture2D Img_Locke;
	//主角对象
	GameObject player;
	//锁定时间间隔
	public float time_intervals_max = 0.5f;
	float time_current_inter;
	float time_count = 0;

	private void Start()
	{
		myroot = transform.root;
		transform.SetParent(null);

		player = GameObject.FindGameObjectWithTag("Player");
		time_current_inter = time_intervals_max;
	}

	private void Update()
	{
		if(myroot == null)
        {
			Destroy(gameObject);
			return;
        }

		transform.position = myroot.position;

		//保持NPC一直面朝主角
		transform.LookAt(player.transform);
		for(time_count += Time.deltaTime; time_count >= time_current_inter;)
        {
			locking = !locking;
			time_count = 0;
		}
	}


	void OnGUI()
	{
		if (locking) return;

		 //得到NPC头顶在3D世界中的坐标
		Vector3 worldPosition = new Vector3(transform.position.x, transform.position.y, transform.position.z);
		//根据NPC头顶的3D坐标换算成它在2D屏幕中的坐标
		Vector3 position = Camera.main.WorldToScreenPoint(worldPosition);
		if(position.z < 0) {
			return;
		}
		//得到真实NPC头顶的2D坐标
		position = new Vector2(position.x, Screen.height - position.y);
		//计算出血条的宽高
		Vector2 bloodSize = GUI.skin.label.CalcSize(new GUIContent(Img_Locke));
		//通过血值计算红色血条显示区域
		int blood_width = Img_Locke.width;
		//在绘制红色血条
		GUI.DrawTexture(new Rect(position.x - (bloodSize.x / 2), position.y - (bloodSize.y/2), blood_width, bloodSize.y), Img_Locke);
	}
}