using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mark : MonoBehaviour
{
    public float pancha = 12;
    Transform my = null;

    private void Start()
    {
        my = transform.root;
        transform.SetParent(null);
    }
    private void Update()
    {
        if (my == null)
        {
            Destroy(gameObject);
            return;
        }
        transform.position = my.position;
        transform.position = new Vector3(transform.position.x,transform.position.y + pancha, transform.position.z);
        transform.LookAt(Camera.main.transform);
    }
}
