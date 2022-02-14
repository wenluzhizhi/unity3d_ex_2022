using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainTest : MonoBehaviour
{
    // Start is called before the first frame update
    public Camera ca;

    public Transform target;
    void Start()
    {
       
    }

    // Update is called once per frame
    void Update()
    {
        ca.transform.RotateAround(target.transform.position, Vector3.up, 0.1f);
    }
}
