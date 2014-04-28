using UnityEngine;
using System.Collections;

public class newGyroScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
        Input.gyro.enabled = true;
	}
	
	// Update is called once per frame
	void Update () {
        // Create a parent object containing the camera (you could do this manually in the 
        // hierarchy if preferred, or here in code)
        //GameObject camParent = new GameObject("GyroCamera");
        //camParent.transform.position = transform.position;
        //transform.parent = camParent.transform;

        // Rotate the parent object by 90 degrees around the x axis
        //this.transform.Rotate(Vector3.right, 90);

        // Invert the z and w of the gyro attitude
        Quaternion rotFix = new Quaternion(Input.gyro.attitude.x, Input.gyro.attitude.y, -Input.gyro.attitude.z,
                                           -Input.gyro.attitude.w);

        // Now set the local rotation of the child camera object
        GameObject.Find("GyroCamera").transform.localRotation = rotFix;
        GameObject.Find("GyroCamera").transform.Rotate(Vector3.back, 90);

	}
}
