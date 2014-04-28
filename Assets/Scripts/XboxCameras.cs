using UnityEngine;
using System.Collections;

public class XboxCameras : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

        GameObject.Find("CameraLeft").camera.cullingMask = ((1 << 30) | (1 << 0)); //1 << 30;
        GameObject.Find("CameraRight").camera.cullingMask = ((1 << 31) | (1 << 0)); //1 << 31;
        
        //GameObject.Find("CameraLeft").camera.cullingMask = 1 << 0;
        //GameObject.Find("CameraRight").camera.cullingMask = 1 << 0;
        
        Color originalColour;

        if(Input.GetButton("Fire1")) {
            originalColour = GameObject.Find("WebcamLeft").renderer.material.color;
            GameObject.Find("WebcamLeft").renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);

            originalColour = GameObject.Find("WebcamRight").renderer.material.color;
            GameObject.Find("WebcamRight").renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 0.0f);
        }
        else {
            originalColour = GameObject.Find("WebcamLeft").renderer.material.color;
            GameObject.Find("WebcamLeft").renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1- (Input.GetAxis("Horizontal")));

            originalColour = GameObject.Find("WebcamRight").renderer.material.color;
            GameObject.Find("WebcamRight").renderer.material.color = new Color(originalColour.r, originalColour.g, originalColour.b, 1- (Input.GetAxis("Horizontal")));
        }

    }
}

//if (virt)
//        {
//            //Debug.Log("virtual is true");
//            GameObject.Find("CameraLeft").camera.cullingMask = 1 << 30;
//            GameObject.Find("CameraRight").camera.cullingMask = 1 << 31;
//        }
//        else
//        {
//            //Debug.Log("virtual is false");
//            GameObject.Find("CameraLeft").camera.cullingMask = 1 << 0;
//            GameObject.Find("CameraRight").camera.cullingMask = 1 << 0;
//        }
//}