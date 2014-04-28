using UnityEngine;
using System.Collections;

public class GyroCameraScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        Input.gyro.enabled = true;

        Debug.Log(Input.gyro.attitude);
        Debug.Log(Input.gyro.attitude.eulerAngles);
        //Quaternion read = new Quaternion(-Input.gyro.attitude.x, Input.gyro.attitude.y,
                                         //-Input.gyro.attitude.z, -Input.gyro.attitude.w);

        //Quaternion offset = Quaternion.Euler(0, 0, -90f);

        //Quaternion corrected = read * offset;

        // this hits gimbal lock...
        //Quaternion equiv = Quaternion.Euler((Input.gyro.attitude.eulerAngles.x),
                                            //(Input.gyro.attitude.eulerAngles.y),
                                            //(Input.gyro.attitude.eulerAngles.z));

        //this.transform.rotation = equiv;

        this.transform.rotation = Quaternion.Euler(Input.gyro.attitude.eulerAngles.x,
                                                   Input.gyro.attitude.eulerAngles.y,
                                                   Input.gyro.attitude.eulerAngles.z);

        //this.transform.Rotate(new Vector3(Input.gyro.attitude.eulerAngles.x, Input.gyro.attitude.eulerAngles.y,
                                          //Input.gyro.attitude.eulerAngles.z));

        // don't want to rotate *to* offset, want to rotate *by* offset, wave?
        
	}
}
