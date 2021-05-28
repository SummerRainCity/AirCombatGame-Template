using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

/// <summary>
/// 【第三人称】相机注视并跟随角色（放大、缩小、自由旋转）
/// 参考文献：https://blog.csdn.net/ff_0528/article/details/102777237
/// </summary>
public class TPD : MonoBehaviour
{
    public Transform target;
    public float x_Speed = 100;
    public float y_Speed = 100;
    public float mmSpeed = 10;
    public float xMinLimit = -30;
    public float xMaxLimit = 80;
    [Tooltip("初始视角距离")]
    public float distance = 20;
    [Tooltip("最小放大距离")]
    public float minDistance = 3.0f;
    [Tooltip("最大放大距离")]
    public float maxDistance = 50;
    public bool isNeedDamping = false;
    public float damping = 8f;
    public float x_OriginAngle = 30f;
    public float y_OriginAngle = 0f;

    private void Start()
    {
        GameObject player = GameObject.FindGameObjectWithTag("Player");//找到标签为Player的目标物体
        if(player != null)
        {
            target = player.transform;
        }
    }

    private void Update()
    {
        if (target)
        {
            y_OriginAngle += Input.GetAxis("Mouse X") * x_Speed * Time.deltaTime;
            x_OriginAngle -= Input.GetAxis("Mouse Y") * y_Speed * Time.deltaTime;

            x_OriginAngle = ClampAngle(x_OriginAngle, xMinLimit, xMaxLimit);
            distance -= Input.GetAxis("Mouse ScrollWheel") * mmSpeed;
            distance = Mathf.Clamp(distance, minDistance, maxDistance);
            Quaternion rotation = Quaternion.Euler(x_OriginAngle, y_OriginAngle, 0.0f);
            Vector3 disVector = new Vector3(0.0f, 0.0f, -distance);
            Vector3 position = rotation * disVector + target.position;
            if (isNeedDamping)
            {
                transform.rotation = Quaternion.Lerp(transform.rotation, rotation, Time.deltaTime * damping);
                transform.position = Vector3.Lerp(transform.position, position, Time.deltaTime * damping);
            }
            else
            {
                transform.rotation = rotation;
                transform.position = position;
            }
        }
    }

    static float ClampAngle(float angle, float min, float max)
    {
        if (angle < -360)
            angle += 360;
        if (angle > 360)
            angle -= 360;
        return Mathf.Clamp(angle, min, max);
    }
}
