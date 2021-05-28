using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 相机切换
/// 
/// 原组件上挂有脚本：
/// AutoCam.cs
/// ProtectCameraFromWallClip.cs
/// </summary>
public class CamerasManager : MonoBehaviour
{
    private Transform fps_point = null, tpd_point = null;
    MonoBehaviour fpd, tpd;
    public bool playing = false;//开始游戏后才能切换视觉

    private void Start()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;

        FindFpsPoint();
        fpd = GetComponent<FPD>();
        tpd = GetComponent<TPD>();
        fpd.enabled = false;
        tpd.enabled = true;
    }

    private void FindFpsPoint()
    {
        tpd_point = GameObject.FindGameObjectWithTag("Player").transform;
        fps_point = tpd_point;
        for (int k = 0; k < fps_point.childCount; k++)
        {
            if (fps_point.GetChild(k).name == "FPS_Point")
            {
                fps_point = fps_point.GetChild(k);
                break;
            }
        }
    }

    private void InitFPD()
    {
        FindFpsPoint();
        fpd.enabled = true;
        tpd.enabled = false;
        transform.SetParent(fps_point);
        transform.localPosition = Vector3.zero;
    }

    private void InitTPD()
    {
        FindFpsPoint();
        tpd.enabled = true;
        fpd.enabled = false;
        transform.SetParent(null);
        tpd.GetComponent<TPD>().target = tpd_point;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.N))
        {
            fpd.enabled = false;
            tpd.enabled = true;
            GameObject[] o = GameObject.FindGameObjectsWithTag("Enemy");
            tpd.GetComponent<TPD>().target = o[UnityEngine.Random.Range(0, o.Length - 1)].transform;
        }
        if (Input.GetKeyDown(KeyCode.V) && playing && fps_point != null && tpd_point != null)
        {
            if (fpd.enabled)
                InitTPD();
            else
                InitFPD();
        }
    }
}
